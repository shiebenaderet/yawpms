#!/usr/bin/env bash
# Regenerate every chapter-status surface from data/chapters.json.
#
# data/chapters.json is the ONLY file you hand-edit. This script rewrites the
# regions between BEGIN/END generated markers in:
#   REVIEW_STATUS.md   status table
#   README.md          status table
#   teachers.html      status rows
#   contributors.html  reviewer credits
#
# Running it twice is a no-op. site-check.yml fails if committed output drifts
# from what this produces.
#
# Usage: bash scripts/build_status.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$SCRIPT_DIR/.."
cd "$ROOT"

command -v node >/dev/null || { echo "node is required" >&2; exit 1; }

node -e '
const fs = require("fs");
const d = JSON.parse(fs.readFileSync("data/chapters.json", "utf8"));
const BAR = d.review_bar;
const chapters = d.chapters;
const SITE = "https://americanyawpms.com";

let bannersChanged = 0;
const esc = s => String(s).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");
const counted = c => (c.reviewers || []).filter(r => r.counts !== false).length;

// A chapter is Approved only when the bar is met. Status is derived, never
// hand-set, so the three tables cannot disagree with each other.
function statusOf(c) {
  const n = counted(c);
  if (n >= BAR) return "Approved";
  if (n > 0 || c.status === "Under Review") return "Under Review";
  return "Draft";
}

function replaceRegion(file, name, body) {
  const src = fs.readFileSync(file, "utf8");
  const begin = `<!-- BEGIN generated:${name} -->`;
  const end = `<!-- END generated:${name} -->`;
  const i = src.indexOf(begin), j = src.indexOf(end);
  if (i === -1 || j === -1) throw new Error(`${file}: missing ${name} markers`);
  const out = src.slice(0, i + begin.length) + "\n" + body + "\n" + src.slice(j);
  if (out !== src) { fs.writeFileSync(file, out); return true; }
  return false;
}

// --- REVIEW_STATUS.md -------------------------------------------------------
let rs = "| Ch. | Title | Status | Reviewers | Notes |\n|-----|-------|--------|-----------|-------|\n";
rs += chapters.map(c =>
  `| ${c.number} | ${c.title} | ${statusOf(c)} | ${counted(c)} / ${BAR} | ${c.notes || ""} |`
).join("\n");

// --- README.md --------------------------------------------------------------
let rm = "| Chapter | Title | Status | Reviewers |\n|---------|-------|--------|-----------|\n";
rm += chapters.map(c =>
  `| ${c.number} | [${c.title}](${SITE}/ch${c.number}.html) | ${statusOf(c)} | ${counted(c)} / ${BAR} |`
).join("\n");

// --- teachers.html ----------------------------------------------------------
const badge = { "Draft": "status-draft", "Under Review": "status-review", "Approved": "status-approved" };
let th = chapters.map(c => {
  const st = statusOf(c);
  const slot = c.review_slot_issue
    ? ` <a href="https://github.com/shiebenaderet/yawpms/issues/${c.review_slot_issue}">claim</a>`
    : "";
  return `    <tr><td>${c.number}</td><td><a href="ch${c.number}.html">${esc(c.title)}</a></td>` +
         `<td><span class="status-badge ${badge[st]}">${st}</span></td>` +
         `<td>${counted(c)} / ${BAR}${slot}</td></tr>`;
}).join("\n");

// --- contributors.html ------------------------------------------------------
const credited = [];
for (const c of chapters)
  for (const r of (c.reviewers || []))
    if (r.consent_to_credit && r.display_name) credited.push({ ch: c.number, title: c.title, name: r.display_name });

let cb;
if (!credited.length) {
  cb = `<p>No chapter reviews have been recorded yet. <a href="teachers.html">Review a chapter &rarr;</a></p>`;
} else {
  const byCh = {};
  credited.forEach(r => (byCh[r.ch] = byCh[r.ch] || []).push(r));
  cb = "<ul>\n" + Object.keys(byCh).sort((a,b)=>a-b).map(n => {
    const names = byCh[n].map(r => esc(r.name)).join(", ");
    return `  <li><strong>Chapter ${n}: ${esc(byCh[n][0].title)}</strong> &mdash; ${names}</li>`;
  }).join("\n") + "\n</ul>";
}

// --- chapter banners -------------------------------------------------------
// Disclosure belongs on the page a student or evaluating teacher actually
// opens, not only on teachers.html. Generated, so it can never become a
// fourth hand-synced status surface.
const REPO = "https://github.com/shiebenaderet/yawpms";
const slug = { "Draft": "draft", "Under Review": "under-review", "Approved": "approved" };

for (const c of chapters) {
  const file = `ch${c.number}.html`;
  if (!fs.existsSync(file)) continue;
  const st = statusOf(c);
  const n = counted(c);
  const bits = [`Reviewed by ${n} of ${BAR} educators`];
  bits.push(c.accuracy_pass
    ? `AI-assisted fact check completed ${c.accuracy_pass}; not yet reviewed by a historian`
    : "AI-assisted draft, not yet reviewed by a historian");
  if (c.chapter_sha) bits.push(`version ${c.chapter_sha}`);

  const report = `${REPO}/issues/new?template=content-revision.yml&amp;title=${encodeURIComponent(`Chapter ${c.number}: `)}`;
  const links = [`<a href="${report}">Report an error</a>`];
  if (c.review_slot_issue) links.push(`<a href="${REPO}/issues/${c.review_slot_issue}">Review this chapter</a>`);
  links.push(`<a href="primary-sources/ch${c.number}-sources.html">Primary sources</a>`);

  const banner =
    `<div class="chapter-banner" data-status="${slug[st]}">\n` +
    `  <span class="cb-status">${st}</span>\n` +
    `  <span class="cb-detail">${bits.join(" &middot; ")}</span>\n` +
    `  <span class="reading-time cb-readtime"></span>\n` +
    `  <span class="cb-links">${links.join("\n    ")}</span>\n` +
    `</div>`;

  const src = fs.readFileSync(file, "utf8");
  const B = "<!-- BANNER:START -->", E = "<!-- BANNER:END -->";
  const i = src.indexOf(B), j = src.indexOf(E);
  if (i === -1 || j === -1) throw new Error(`${file}: missing BANNER markers`);
  const out = src.slice(0, i + B.length) + "\n" + banner + "\n" + src.slice(j);
  if (out !== src) { fs.writeFileSync(file, out); bannersChanged++; }
}

const changed = [
  replaceRegion("REVIEW_STATUS.md", "status-table", rs),
  replaceRegion("README.md", "status-table", rm),
  replaceRegion("teachers.html", "status-rows", th),
  replaceRegion("contributors.html", "reviewers", cb),
];

const n = changed.filter(Boolean).length;
const total = n + bannersChanged;
console.log(total === 0
  ? "Status surfaces and chapter banners already up to date (no-op)."
  : `Updated ${n} of 4 status surfaces and ${bannersChanged} chapter banner(s).`);
const approved = chapters.filter(c => statusOf(c) === "Approved").length;
const reviews = chapters.reduce((t,c) => t + counted(c), 0);
console.log(`${chapters.length} chapters, ${reviews} counted review(s), ${approved} approved.`);
'
