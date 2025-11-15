import glob, json, pathlib

OUTPUT_JSON = "assets/novels_config.json"
novels_path = [pathlib.Path(path) for path in glob.glob("assets/*/")]
novels = [path.name for path in novels_path]
print("- "+OUTPUT_JSON)
print("\n".join(["- "+path.as_posix() for path in novels_path]))
with open(OUTPUT_JSON, "w", encoding="utf-8") as f:
    json.dump({"novels": novels}, f, ensure_ascii=False, indent=2)
