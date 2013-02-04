import sys
import os
import glob
from xml.dom import minidom

if len(sys.argv) < 2:
    print("Give HoN directory path")
    sys.exit(1)

hon_dir = sys.argv[1]
if not os.path.isdir(hon_dir):
    print("Invalid HoN direct")
    sys.exit(1)

hero_entities = glob.glob(os.path.join(hon_dir, "game/heroes/*/hero.entity"))
hero_names = []

for hero in hero_entities:
    if os.path.isfile(hero):
        dom = minidom.parse(hero)
        name = dom.getElementsByTagName("hero")[0].getAttribute("name")
        hero_names.append(name)

sys.stdout.write("return {\n")
sys.stdout.write(", ".join(['"'+name+'"' for name in hero_names]))
sys.stdout.write("\n}\n")
