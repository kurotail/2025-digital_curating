import os, sys, re, json, base64

if (len(sys.argv) < 2) :
    print("Convert <file_name>.md to <file_name>.json in PWD.")
    print("Usage: python convert <file_name>")
    exit(1)

FILENAME = sys.argv[1]
INPUT_FILE = f"{FILENAME}.md"
OUTPUT_JSON = os.path.join(os.getcwd(), "assets", FILENAME, "context.json")
ASSET_DIR = os.path.join(os.getcwd(), "assets", FILENAME)

os.makedirs(ASSET_DIR, exist_ok=True)

def extract_base64_images(markdown):
    """
    解析形如 [imageX]: <data:image/png;base64,...> 的行
    將圖片存成 assets/FILENAME/imageX.png
    回傳 {imageX: 路徑}
    """
    image_map = {}
    pattern = re.compile(r'\[(image\d+)\]:\s*<data:image/(png|jpg|jpeg);base64,([^>]+)>', re.I)
    for match in pattern.finditer(markdown):
        name, ext, b64data = match.groups()
        img_path = os.path.join(ASSET_DIR, f"{name}.png")
        with open(img_path, "wb") as f:
            f.write(base64.b64decode(b64data))
        image_map[name] = f"assets/{FILENAME}/{name}.png"
    return image_map

def parse_sections(markdown):
    """
    將 markdown 分成以 # 為主層級的區塊
    """
    sections = re.split(r'\n(?=# )', markdown.strip())
    data = {}
    for sec in sections:
        lines = sec.strip().splitlines()
        if not lines: continue
        header = re.sub(r'^#\s*', '', lines[0]).strip()
        body = "\n".join(lines[1:]).strip()
        data[header] = body
    return data

def parse_info(info_md):
    """
    處理 # info 區塊中的二級標題
    """
    info = {}
    blocks = re.split(r'\n(?=## )', info_md.strip())
    for blk in blocks:
        lines = blk.strip().splitlines()
        if len(lines) < 1:
            break
        title = re.sub(r'^##\s*', '', lines[0]).strip()
        content = "\n".join(lines[1:]).strip()
        info[title] = content
    return info

def parse_content(content_md, image_map):
    """
    解析 # content 區塊內的各種 type
    """
    blocks = re.split(r'\n(?=/text|/quote|/image)', content_md.strip())
    content = []
    for blk in blocks:
        lines = blk.strip().splitlines()
        if len(lines) < 1:
            break
        typ = re.sub(r'^/', '', lines[0]).strip().lower()
        body = "\n".join(lines[1:]).strip()
        if typ == "image":
            m = re.search(r'!\[\]\[(image\d+)\]', body)
            caption = re.sub(r'!\[\]\[image\d+\]\s*', '', body).strip()
            if m:
                image_key = m.group(1)
                content.append({
                    "type": "image",
                    "path": image_map.get(image_key, ""),
                    "caption": caption
                })
        elif typ == "text":
            content.append({"type": "text", "text": body})
        elif typ == "quote":
            content.append({"type": "quote", "text": body.strip('"“”')})
    return content

def parse_links(links_md):
    """
    擷取類似：
    前往購買連結([https://bookwalker.jp/...])
    """
    links = []
    for line in links_md.splitlines():
        line = line.strip()
        if not line: continue
        m = re.match(r'(.+) \[([^\]]+)', line)
        if m:
            label = m.group(1).strip()
            url = "https://" + m.group(2).strip()
            links.append({"label": label, "url": url})
    return links

with open(INPUT_FILE, encoding="utf-8") as f:
    md = f.read()

# 抽出圖片
image_map = extract_base64_images(md)
md_clean = re.sub(r'\[image\d+\]:\s*<data:image/[^>]+>\s*', '', md)

sections = parse_sections(md_clean)
result = {}

# 基本欄位
result["title"] = sections.get("title", "").strip()
result["author"] = sections.get("author", "").strip()
result["tags"] = [t.strip() for t in sections.get("tags", "").splitlines() if t.strip()]
result["summary"] = sections.get("summary", "").strip()

# 封面
cover_match = re.search(r'!\[\]\[(image\d+)\]', sections.get("cover", ""))
if cover_match:
    result["cover"] = image_map.get(cover_match.group(1), "")

# info
result["info"] = parse_info(sections.get("info", ""))

# content
result["content"] = parse_content(sections.get("content", ""), image_map)

# links
result["links"] = parse_links(sections.get("links", ""))

# 輸出
with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
    json.dump(result, f, ensure_ascii=False, indent=2)

print(f"轉換完成 → {OUTPUT_JSON}")
print(f"圖片儲存於 {ASSET_DIR}")

