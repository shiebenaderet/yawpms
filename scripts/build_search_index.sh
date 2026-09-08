#!/usr/bin/env bash
# Build a JSON search index from chapter HTML files.
# Extracts headings, section text, vocab terms, and key ideas.
# Output: js/search-index.json
# Usage: bash scripts/build_search_index.sh

set -eo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/js/search-index.json"

echo "Building search index..."

node -e '
const fs = require("fs");
const path = require("path");

const root = process.argv[1];
const chapters = [];

const chapterTitles = {
  1: "Indigenous America",
  2: "Colliding Cultures",
  3: "British North America",
  4: "Colonial Society",
  5: "The American Revolution",
  6: "A New Nation",
  7: "The Early Republic",
  8: "The Market Revolution",
  9: "Democracy in America",
  10: "Religion and Reform",
  11: "The Cotton Revolution",
  12: "Manifest Destiny",
  13: "The Sectional Crisis",
  14: "The Civil War",
  15: "Reconstruction"
};

for (let i = 1; i <= 15; i++) {
  const file = path.join(root, `ch${i}.html`);
  if (!fs.existsSync(file)) continue;
  const html = fs.readFileSync(file, "utf8");

  // Extract sections. Two bugs used to live in this regex:
  //   1. It began with a literal "<" followed by an OPTIONAL (?:section[^>]*>)?
  //      group, so a match required "<" then "<h2" -- i.e. the section prefix was
  //      effectively mandatory. ch6 and ch7, which had no <section> elements,
  //      indexed zero sections.
  //   2. The greedy <h2[^>]* consumed the whole attribute list before the
  //      optional (?:id="...")? group could reach it, so every captured id was ""
  //      and every search result linked to the top of a chapter with no anchor.
  // Ids live on <section>, not <h2>; the h2 branch is a fallback.
  const sections = [];
  const h2Re = /(?:<section\b([^>]*)>\s*)?<h2\b([^>]*)>(.*?)<\/h2>/gi;
  const idOf = attrs => {
    const m = /\bid="([^"]*)"/.exec(attrs || "");
    return m ? m[1] : "";
  };
  let match;
  const h2Positions = [];

  while ((match = h2Re.exec(html)) !== null) {
    const id = idOf(match[1]) || idOf(match[2]);
    // Skip headings with no anchor -- the chapter TOC, Overview and Big
    // Questions blocks. Indexing them would produce search results that land at
    // the top of the chapter, which is the defect this fix exists to remove.
    if (!id) continue;
    h2Positions.push({
      pos: match.index,
      id: id,
      title: match[3].replace(/<[^>]*>/g, "").trim()
    });
  }

  // For each h2, get text until next h2
  for (let j = 0; j < h2Positions.length; j++) {
    const start = h2Positions[j].pos;
    const end = j + 1 < h2Positions.length ? h2Positions[j + 1].pos : html.length;
    const block = html.substring(start, end);

    // Strip HTML tags, collapse whitespace
    let text = block
      .replace(/<script[\s\S]*?<\/script>/gi, "")
      .replace(/<style[\s\S]*?<\/style>/gi, "")
      .replace(/<[^>]*>/g, " ")
      .replace(/&[a-z]+;/gi, " ")
      .replace(/&#x?[0-9a-f]+;/gi, " ")
      .replace(/\s+/g, " ")
      .trim();

    // Truncate for index size (keep first 600 chars for preview)
    const preview = text.substring(0, 300).trim();
    sections.push({
      id: h2Positions[j].id,
      heading: h2Positions[j].title,
      text: text.substring(0, 600),
      preview: preview
    });
  }

  // Extract vocab terms
  const vocabTerms = [];
  const vocabRe = /<div class="vocab-box">[\s\S]*?<\/div>/gi;
  let vm;
  while ((vm = vocabRe.exec(html)) !== null) {
    const block = vm[0];
    const termRe = /<strong>([^<]*?)(?::)?<\/strong>\s*(.*?)(?=<\/p>|<strong>)/gi;
    let tm;
    while ((tm = termRe.exec(block)) !== null) {
      const term = tm[1].replace(/:$/, "").trim();
      const def = tm[2].replace(/<[^>]*>/g, "").trim().substring(0, 200);
      if (term) vocabTerms.push({ term, def });
    }
  }

  chapters.push({
    chapter: i,
    title: chapterTitles[i] || `Chapter ${i}`,
    file: `ch${i}.html`,
    sections,
    vocab: vocabTerms
  });
}

// Write index
fs.writeFileSync(process.argv[2], JSON.stringify(chapters, null, 0));
console.log(`  ${chapters.length} chapters indexed`);
let totalSections = chapters.reduce((s, c) => s + c.sections.length, 0);
let totalVocab = chapters.reduce((s, c) => s + c.vocab.length, 0);
console.log(`  ${totalSections} sections, ${totalVocab} vocab terms`);
' "$ROOT" "$OUT"

echo "Search index written to $OUT"
SIZE=$(stat -c%s "$OUT" 2>/dev/null || stat -f%z "$OUT" 2>/dev/null)
echo "  Size: $((SIZE / 1024)) KB"
