import os, time
fpath = os.path.expanduser('~/AUREON/wiki_entries/beweise.md')
with open(fpath, 'a') as f:
    f.write(f'\n- Archiv erstellt: {time.strftime("%Y-%m-%d %H:%M:%S")}')
