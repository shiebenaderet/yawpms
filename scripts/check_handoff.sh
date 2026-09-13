#!/usr/bin/env bash
# The gate between a local model and a paid review.
#
# A local model's cheapest failure is inventing a claim that is not in the chapter and then
# reasoning about it convincingly. Catching that by hand costs more than doing the work
# yourself, which is how a "free" local pass turns expensive.
#
# So: every claim must quote the chapter VERBATIM. That is mechanically checkable and kills
# hallucinations for nothing. What survives is a real inventory worth paying to audit.
#
# Whitespace is normalised before comparison. That matters: searching a wrapped text
# line-by-line made a GENUINE Robinson passage look fabricated during the ch8 audit, and a
# gate carrying that bug would silently reject good work.
#
# Usage: bash scripts/check_handoff.sh 9
# Reads  audit/ch9/claims.jsonl  ->  writes audit/ch9/claims.accepted.jsonl

set -euo pipefail
N="${1:?usage: bash scripts/check_handoff.sh <chapter-number>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

python3 - "$N" "$ROOT" <<'PY'
import json, re, sys, io, os

N, ROOT = sys.argv[1], sys.argv[2]
src = f"{ROOT}/audit/ch{N}/claims.jsonl"
if not os.path.exists(src):
    print(f"no handoff file: audit/ch{N}/claims.jsonl"); sys.exit(1)

ch = io.open(f"{ROOT}/ch{N}.html", encoding="utf-8").read()
nlines = len(ch.split("\n"))

def norm(s):
    s = str(s).replace("’", "'").replace("‘", "'").replace("“", '"').replace("”", '"')
    return re.sub(r"\s+", " ", s).strip()

flat_text = norm(re.sub(r"<[^>]*>", " ", ch))   # visible prose, tags stripped
flat_raw  = norm(ch)                             # markup included, for alt/attribute claims

TYPES = {"date", "name", "statistic", "quotation", "causal", "consistency", "image"}
ok, bad = [], []

for n, line in enumerate(io.open(src, encoding="utf-8"), 1):
    line = line.strip()
    if not line:
        continue
    try:
        c = json.loads(line)
    except Exception as e:
        bad.append((n, "not valid JSON", str(e)[:60])); continue

    missing = [k for k in ("line", "type", "text") if k not in c]
    if missing:
        bad.append((n, "missing field(s)", ",".join(missing))); continue
    if c["type"] not in TYPES:
        bad.append((n, "unknown type", str(c["type"])[:40])); continue
    if not isinstance(c["line"], int) or not (1 <= c["line"] <= nlines):
        bad.append((n, "line out of range", f"{c['line']} (file has {nlines})")); continue

    t = norm(c["text"])
    if len(t) < 12:
        bad.append((n, "text too short to locate", t)); continue
    if t not in flat_text and t not in flat_raw:
        # THE hallucination check: the model says the chapter contains this. It does not.
        bad.append((n, "NOT IN CHAPTER", t[:72])); continue
    ok.append(c)

out = f"{ROOT}/audit/ch{N}/claims.accepted.jsonl"
io.open(out, "w", encoding="utf-8").write("\n".join(json.dumps(c, ensure_ascii=False) for c in ok))

total = len(ok) + len(bad)
print(f"handoff check, chapter {N}")
print(f"  accepted {len(ok)} / {total}")

if bad:
    grouped = {}
    for n, why, detail in bad:
        grouped.setdefault(why, []).append((n, detail))
    print(f"  REJECTED {len(bad)}:")
    for why, items in sorted(grouped.items(), key=lambda kv: -len(kv[1])):
        print(f"    {why}  x{len(items)}")
        for n, detail in items[:5]:
            print(f"       jsonl line {n}: {detail}")
        if len(items) > 5:
            print(f"       ... and {len(items) - 5} more")

by_type = {}
for c in ok:
    by_type[c["type"]] = by_type.get(c["type"], 0) + 1
print("  accepted by type: " + (", ".join(f"{k} {v}" for k, v in sorted(by_type.items())) or "none"))
print(f"  -> audit/ch{N}/claims.accepted.jsonl")

if total and len(bad) / total > 0.30:
    print()
    print("  [!] over 30% rejected. Do NOT pay to review this run. Fix the prompt and re-run")
    print("      the local model. A high reject rate almost always means it was asked for")
    print("      judgment when it should have been asked for extraction.")
    sys.exit(1)
PY
