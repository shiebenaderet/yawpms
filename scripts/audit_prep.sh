#!/usr/bin/env bash
# Tier 0 of the cheap audit protocol: everything learnable about a chapter WITHOUT a
# language model. Costs bandwidth, not tokens. Run this FIRST, always.
#
# Both of the most serious ch8 findings were obtainable here, for free:
#   - erie-canal.jpg was CC BY-SA 4.0 with AttributionRequired=true while its caption read
#     "(Public domain, 19th century)". One API call says so. It took a subagent to find it.
#   - The chapter gave the Erie Canal's cost saving as 90% in the body and 95% in a caption
#     on the same screen. A number inventory shows that with no reasoning at all.
#
# check_image_manifest.js asks "does a provenance record exist?". This asks "is it TRUE?".
#
# Usage:  bash scripts/audit_prep.sh 9
# Output: audit/ch9/   (gitignored)

set -euo pipefail
N="${1:?usage: bash scripts/audit_prep.sh <chapter-number>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CH="$ROOT/ch$N.html"
OUT="$ROOT/audit/ch$N"

[ -f "$CH" ] || { echo "no such chapter: $CH" >&2; exit 1; }
mkdir -p "$OUT"
echo "Tier 0 audit prep for chapter $N -> audit/ch$N/"

python3 - "$N" "$ROOT" "$OUT" <<'PY'
import re, sys, io, os, json, html, collections, urllib.parse, urllib.request

N, ROOT, OUT = sys.argv[1], sys.argv[2], sys.argv[3]
FAIL = {"n": 0}
def problem(msg):
    FAIL["n"] += 1
    print("  [!] " + msg)

UA = "AmericanYawpMS-Audit/1.0 (https://github.com/shiebenaderet/yawpms; contact via GitHub Issues)"
ch = io.open(f"{ROOT}/ch{N}.html", encoding="utf-8").read()
lines = ch.split("\n")

def get(url, timeout=45):
    try:
        req = urllib.request.Request(url, headers={"User-Agent": UA})
        return urllib.request.urlopen(req, timeout=timeout).read().decode("utf-8", "replace")
    except Exception as e:
        return f"__ERR__{e}"

# ---------------------------------------------------------------- parent text, prefetched
# Cache ALL of Volume I once, not just the same-numbered chapter.
#
# The MS chapters do not map 1:1 onto the Yawp's. ch9 "Democracy in America" carries the whole
# Indian Removal story, but the Yawp puts Cherokee removal in chapter 12: its own chapter 9 has
# Cherokee=0, Worcester=0, "Removal Act"=0. Triaging ch9's quotations against Yawp ch9 alone
# reported every one of them as "not in the parent text", which is noise, not signal.
CACHE = f"{ROOT}/audit/_yawp"
os.makedirs(CACHE, exist_ok=True)

if not os.listdir(CACHE):
    idx = get("https://www.americanyawp.com/text/", 60)
    slugs = sorted(set(re.findall(r"americanyawp\.com/text/(\d{2}-[a-z0-9-]+)/", idx)))
    slugs = [s for s in slugs if 1 <= int(s[:2]) <= 15 and not s.endswith("-2")]
    print(f"  [fetch] caching {len(slugs)} Yawp chapters (once; reused by every chapter audit)")
    for s in slugs:
        body = get(f"https://www.americanyawp.com/text/{s}/", 60)
        if body.startswith("__ERR__"):
            print(f"  [warn] {s}: {body[7:60]}"); continue
        txt = re.sub(r"<(script|style)[^>]*>.*?</\1>", " ", body, flags=re.S)
        txt = html.unescape(re.sub(r"<[^>]*>", " ", txt))
        io.open(f"{CACHE}/{s[:2]}.txt", "w", encoding="utf-8").write(re.sub(r"\s+", " ", txt))

YAWP = {}
for fn in sorted(os.listdir(CACHE)):
    t = io.open(f"{CACHE}/{fn}", encoding="utf-8").read()
    YAWP[fn[:2]] = t.replace("\u2019", "'").replace("\u201c", '"').replace("\u201d", '"')
print(f"  [cache] {len(YAWP)} Yawp chapters available for triage")

# ---------------------------------------------------------------- image licence truth table
# THE highest-value free check: the real licence for every image the manifest names, so a
# caption claiming "public domain" becomes a falsifiable statement instead of a decoration.
man = f"{ROOT}/scripts/download_ch{N}_images.sh"
flagged = []
if os.path.exists(man):
    entries = re.findall(r'\["([^"]+)"\]="([^"]*)"', io.open(man, encoding="utf-8").read())
    rows = [("file", "artist", "date", "licence", "attribution_required")]
    print(f"  [api] Commons licence table ({len(entries)} entries)")
    for name, url in entries:
        if "Special:FilePath/" not in url:
            rows.append((name, "(not a Commons FilePath URL)", "", "", "")); continue
        title = urllib.parse.unquote(url.split("Special:FilePath/")[1].split("?")[0]).replace("_", " ")
        api = ("https://commons.wikimedia.org/w/api.php?action=query&format=json"
               "&prop=imageinfo&iiprop=extmetadata|size&titles=" + urllib.parse.quote("File:" + title))
        raw = get(api)
        if raw.startswith("__ERR__"):
            rows.append((name, "(api error)", "", "", "")); continue
        pages = (json.loads(raw).get("query") or {}).get("pages") or {}
        for p in pages.values():
            if "missing" in p:
                rows.append((name, "(FILE MISSING ON COMMONS)", "", "", "")); break
            em = ((p.get("imageinfo") or [{}])[0]).get("extmetadata") or {}
            f = lambda k: re.sub(r"<[^>]*>", "", html.unescape(str((em.get(k) or {}).get("value", "")))).strip()[:70] or "-"
            row = (name, f("Artist"), f("DateTimeOriginal") if f("DateTimeOriginal") != "-" else f("DateTime"),
                   f("LicenseShortName"), f("AttributionRequired"))
            rows.append(row)
            if row[4].lower() == "true": flagged.append(row)
            break
    io.open(f"{OUT}/licences.tsv", "w", encoding="utf-8").write("\n".join("\t".join(r) for r in rows))

    # "Requires attribution" is not a violation. NOT NAMING THE CREATOR IN THE CAPTION is.
    # That distinction is the whole point: ch8 shipped a CC BY-SA photograph captioned
    # "(Public domain, 19th century)" for months, and five more chapters asserted
    # "(Wikimedia Commons, public domain)" over CC-licensed maps.
    #
    # Matching is deliberately forgiving. A Commons Artist field can be a derivative filename
    # ("North_America_laea_location_map.svg: Uwe Dedering"), a handle with digits ("Kgv88"),
    # or a bare URL. An earlier version of this check took the first few long words and so
    # flagged three correctly-credited captions -- noise, which is the one thing a triage step
    # must not produce, because it gets paid for downstream.
    STOP = {"user","users","made","own","work","wikipedia","commons","wikimedia","https","http",
            "media","twimg","file","svg","png","jpg","jpeg","shared","original","derivative"}
    def creator_tokens(artist):
        a = re.sub(r"https?://\S+", " ", artist)          # drop URLs
        a = re.sub(r"\b[\w-]+\.(svg|png|jpe?g|gif)\b", " ", a, flags=re.I)  # drop filenames
        toks = re.findall(r"[A-Za-z][A-Za-z0-9'\u00c0-\u024f-]{2,}", a)
        return [t for t in toks if t.lower() not in STOP]

    def caption_of(fname):
        for fig in re.findall(r"<figure[^>]*>.*?</figure>", ch, re.S):
            if fname in fig:
                c = re.search(r"<figcaption>(.*?)</figcaption>", fig, re.S)
                return re.sub(r"<[^>]*>", "", c.group(1)) if c else ""
        return None

    violations, unnameable = [], []
    for r in flagged:
        cap = caption_of(r[0])
        if cap is None:
            violations.append((r, "referenced by no <figure> - cannot carry a caption")); continue
        toks = creator_tokens(r[1])
        if not toks:
            unnameable.append(r); continue
        if not any(t.lower() in cap.lower() for t in toks):
            violations.append((r, f"caption does not name {toks[0]}"))

    print(f"  --- {len(flagged)} image(s) require named attribution ---")
    for r in flagged: print(f"      {r[0]:<28} {r[3]:<16} {r[1][:46]}")
    if not flagged: print("      (none - every image is public domain or CC0)")
    if violations:
        problem(f"{len(violations)} LICENCE VIOLATION(S) - attribution required but not given:")
        for r, why in violations: problem(f"    {r[0]} ({r[3]}): {why}")
    elif flagged:
        print("      all named in their captions - no violation")
    for r in unnameable:
        print(f"  known gap: {r[0]} requires attribution but its Commons Artist field names "
              f"no person ({r[1][:40]}) - licence metadata unreliable, check by hand")

    # the manifest header claiming one licence for all files is a repeat offender: ch5, ch6,
    # ch7 and ch8 each had a blanket header that was the thing concealing a real defect.
    head = "\n".join(io.open(man, encoding="utf-8").read().split("\n")[:8])
    if re.search(r"#.*(public domain|CC BY)", head, re.I) and len(set(r[3] for r in rows[1:])) > 1:
        print("  [!] manifest header asserts a licence, but the entries do not all share one")

# ---------------------------------------------------------------- free text scans
def report(title, items, cap=8):
    print(f"  --- {title}: {len(items)} ---")
    for it in items[:cap]: print(f"      {it}")

dups = []
for pat in (r"((?:[A-Z][^.!?]{15,200}[.!?]\s*){1,5})\1", r"\b(\w[\w ,'’—:-]{20,110})\s*\1\b"):
    dups += [m.group(1)[:110].replace("\n", " ") for m in re.finditer(pat, ch)]
report("duplicated passages", dups)

stray = [f"line {i}: {l.strip()[:88]}" for i, l in enumerate(lines, 1)
         if re.search(r"(?<!<)/(?:p|div|em|strong|li|ul|ol|h[1-6]|figure|figcaption|section|span)>", l)]
report("stray tag fragments (html-validate passes these)", stray)

persp = re.findall(r'<div class="perspective">(.*?)</div>', ch, re.S)
quoted = [re.sub(r"<[^>]*>", "", p).strip()[:78] for p in persp
          if re.match(r'\s*<strong>[^<]*</strong>\s*&?[“"]', p)]
report("composite voices punctuated as real quotations", quoted)

nocredit = []
for fig in re.findall(r"<figure[^>]*>(.*?)</figure>", ch, re.S):
    src, cap = re.search(r'src="([^"]+)"', fig), re.search(r"<figcaption>(.*?)</figcaption>", fig, re.S)
    if src and cap and not re.search(r"public domain|CC[ -]|Commons|Library of Congress|Museum|Archives|no known restrictions",
                                     cap.group(1), re.I):
        nocredit.append(src.group(1))
report("figcaptions with no credit line at all", nocredit)

nums = collections.defaultdict(list)
for i, l in enumerate(lines, 1):
    if re.search(r"<(script|style)", l): continue
    for m in re.finditer(r"(?<![\w.-])(\d{1,3}(?:,\d{3})+|\d+(?:\.\d+)?%|\b1[5-9]\d{2}\b)(?![\w%])", l):
        nums[m.group(1)].append(i)
io.open(f"{OUT}/numbers.txt", "w", encoding="utf-8").write(
    "\n".join(f"{k}\tlines {','.join(map(str, v))}" for k, v in sorted(nums.items(), key=lambda kv: -len(kv[1]))))

# Quotation inventory. Strip tags from each line FIRST: without that, every href, meta
# description and inline style="background-image: url(...)" is scraped as a "quotation",
# and the triage below drowns in markup instead of pointing at real quoted prose.
quotes = []
for i, l in enumerate(lines, 1):
    visible = re.sub(r"<[^>]*>", " ", l)
    for m in re.finditer(r'[“"]([^“”"]{40,})[”"]', visible):
        quotes.append({"line": i, "text": re.sub(r"\s+", " ", html.unescape(m.group(1))).strip()})

# Triage every quotation against the WHOLE cached corpus, and say which chapter it came from.
# A run that appears anywhere in the Yawp is inherited and carries its sourcing; one that
# appears nowhere was written or altered during adaptation, and that is where fabrications
# live. ch8's fake Robinson passage was in the second group.
if YAWP:
    for q in quotes:
        probe = re.sub(r"\s+", " ", q["text"]).replace("\u2019", "'")[:60]
        q["in_yawp"] = next((c for c, t in sorted(YAWP.items()) if probe in t), None)
    only_here = [q for q in quotes if not q["in_yawp"]]
    inherited = [q for q in quotes if q["in_yawp"]]
    if inherited:
        print(f"  --- {len(inherited)} quotation(s) inherited from the parent text ---")
        for q in inherited[:6]:
            print(f"      (Yawp ch{q['in_yawp']}) {q['text'][:62]}")
    print(f"  --- quotations found nowhere in Yawp Volume I: {len(only_here)} of {len(quotes)} ---")
    print("      (written or altered in adaptation - verify these first)")
    for q in only_here[:8]:
        print(f"      line {q['line']}: {q['text'][:72]}")

io.open(f"{OUT}/quotations.jsonl", "w", encoding="utf-8").write(
    "\n".join(json.dumps(q, ensure_ascii=False) for q in quotes))

print(f"  --- wrote numbers.txt ({len(nums)} distinct) and quotations.jsonl ({len(quotes)} runs) ---")
PY

echo
echo "Next: bash scripts/check_handoff.sh $N   (after the local model writes audit/ch$N/claims.jsonl)"
