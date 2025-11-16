import os, sys, re, json, base64

class Convertor:
    def __init__(self, filename: str) -> None:
        self.filename = filename
        self.input_file = f"{self.filename}.md"
        self.output_json = os.path.join(os.getcwd(), "assets", self.filename, "context.json")
        self.asset_dir = os.path.join(os.getcwd(), "assets", self.filename)
        os.makedirs(self.asset_dir, exist_ok=True)

    def extract_base64_images(self, markdown):
        """
        解析形如 [imageX]: <data:image/png;base64,...> 的行
        將圖片存成 assets/FILENAME/imageX.png
        回傳 {imageX: 路徑}
        """
        image_map = {}
        pattern = re.compile(r'\[(image\d+)\]:\s*<data:image/(png|jpg|jpeg);base64,([^>]+)>', re.I)
        for match in pattern.finditer(markdown):
            name, ext, b64data = match.groups()
            img_path = os.path.join(self.asset_dir, f"{name}.png")
            with open(img_path, "wb") as f:
                f.write(base64.b64decode(b64data))
            image_map[name] = f"assets/{self.filename}/{name}.png"
        return image_map

    def parse_sections(self, markdown):
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

    def parse_info(self, info_md):
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

    def parse_content(self, content_md, image_map):
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
                        "path": "assets/" + image_map.get(image_key, ""),
                        "caption": caption
                    })
            elif typ == "text":
                content.append({"type": "text", "text": body})
            elif typ == "quote":
                content.append({"type": "quote", "text": body.strip('"“”')})
        return content

    def parse_links(self, links_md):
        """
        擷取類似：
        前往購買連結([https://bookwalker.jp/...])
        """
        links = []
        for line in links_md.splitlines():
            line = line.strip()
            if not line: continue
            m = re.match(r'(.+)\(([^\)]+)\)', line)
            if m:
                label = m.group(1).strip()
                url = "https://" + m.group(2).strip()
                links.append({"label": label, "url": url})
        return links

    def convert(self):
        with open(self.input_file, encoding="utf-8") as f:
            md = f.read()

        # 抽出圖片
        image_map = self.extract_base64_images(md)
        md_clean = re.sub(r'\[image\d+\]:\s*<data:image/[^>]+>\s*', '', md)

        sections = self.parse_sections(md_clean)
        result = {}

        # 基本欄位
        result["title"] = sections.get("title", "").strip()
        result["author"] = sections.get("author", "").strip()
        result["tags"] = [t.strip() for t in sections.get("tags", "").splitlines() if t.strip()]
        result["summary"] = sections.get("summary", "").strip()

        # 封面
        cover_match = re.search(r'!\[\]\[(image\d+)\]', sections.get("cover", ""))
        if cover_match:
            result["cover"] = "assets/" + image_map.get(cover_match.group(1), "")

        # info
        result["info"] = self.parse_info(sections.get("info", ""))

        # content
        result["content"] = self.parse_content(sections.get("content", ""), image_map)

        # links
        result["links"] = self.parse_links(sections.get("links", ""))

        # 輸出
        with open(self.output_json, "w", encoding="utf-8") as f:
            json.dump(result, f, ensure_ascii=False, indent=2)

        print(f"轉換完成 → {self.output_json}")
        print(f"圖片儲存於 {self.asset_dir}")

if __name__ == "__main__":
    if (len(sys.argv) < 2) :
        print("Convert <file_name>.md to <file_name>.json in PWD.")
        print("Usage: python convert <file_name>")
        exit(1)

    Convertor(sys.argv[1]).convert()
