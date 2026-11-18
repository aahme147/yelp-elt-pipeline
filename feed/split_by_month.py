import gzip, json, os, resource

SRC = os.path.expanduser("~/Downloads/Yelp JSON/yelp_dataset/yelp_academic_dataset_review.json")
OUT = os.path.expanduser("~/yelp_feed/review/incoming")
CUTOFF = "2021-01"   # months >= this are treated as "incoming"

# macOS allows only 256 open files by default; raise it
soft, hard = resource.getrlimit(resource.RLIMIT_NOFILE)
resource.setrlimit(resource.RLIMIT_NOFILE, (min(4096, hard), hard))

os.makedirs(OUT, exist_ok=True)
handles, counts, skipped = {}, {}, 0

def handle(month):
    if month not in handles:
        handles[month] = gzip.open(f"{OUT}/review_{month}.json.gz", "wt")
    return handles[month]

with open(SRC, encoding="utf-8") as f:
    for line in f:
        month = json.loads(line)["date"][:7]   # e.g. "2021-03"
        if month >= CUTOFF:
            handle(month).write(line)
            counts[month] = counts.get(month, 0) + 1
        else:
            skipped += 1

for h in handles.values():
    h.close()

print("history rows (not written):", skipped)
for m in sorted(counts):
    print(m, counts[m])
print("incoming total:", sum(counts.values()))