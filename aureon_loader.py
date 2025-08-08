#!/usr/bin/env python3
import json, os, subprocess
INDEX = os.path.expanduser("~/AUREON/aureon_ai_index_clean.json")
db = json.load(open(INDEX))
cats = {}
for e in db:
    cats.setdefault(e["kategorie"], []).append(e)
while True:
    print("\n=== AUREON MODULE-LOADER ===")
    for i, c in enumerate(cats, 1):
        print(f"{i}) {c} ({len(cats[c])})")
    print("0) Exit")
    try:
        ci = int(input("Kategorie wählen: "))
        if ci == 0: break
        selcat = list(cats.keys())[ci - 1]
        mods = cats[selcat]
        for j, m in enumerate(mods, 1):
            print(f"  {j}) {m['name']}")
        print("  0) Zurück")
        mi = int(input("Modul wählen: "))
        if mi == 0: continue
        path = mods[mi - 1]['pfad']
        subprocess.call(['sh', path]) if path.endswith('.sh') else subprocess.call(['python', path])
    except: continue
