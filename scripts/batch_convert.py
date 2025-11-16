import glob
from md_convert import Convertor

for md in glob.glob("*.md"):
    Convertor(md.split(".")[0]).convert()
