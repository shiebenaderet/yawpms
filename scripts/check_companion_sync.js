// Check that companion resources stay in step with the chapters.
// Three independent arms, each reported separately so one failure does not
// hide the others. Run via: bash scripts/check_companion_sync.sh
const fs = require("fs");
let fail = 0;
const problem = (arm, msg) => { console.log("  [" + arm + "] " + msg); fail = 1; };

// Companion data lives in three inline JS objects on three pages.
function pluck(file, varName) {
  const src = fs.readFileSync(file, "utf8");
  const i = src.indexOf("var " + varName + " = {");
  if (i === -1) throw new Error(varName + " not found in " + file);
  let depth = 0, start = src.indexOf("{", i), j = start;
  for (; j < src.length; j++) {
    if (src[j] === "{") depth++;
    else if (src[j] === "}") { depth--; if (!depth) break; }
  }
  return eval("(" + src.slice(start, j + 1) + ")");
}

const VOCAB   = pluck("vocabulary-cards.html", "VOCAB");
const QUIZZES = pluck("quizzes.html", "QUIZZES");
const SLIDES  = pluck("slideshows.html", "SLIDES");

// --- arm 1: every chapter present in all three objects ----------------------
for (let n = 1; n <= 15; n++) {
  const pairs = [["VOCAB", VOCAB], ["QUIZZES", QUIZZES], ["SLIDES", SLIDES]];
  for (const pair of pairs)
    if (!pair[1][String(n)]) problem("coverage", "chapter " + n + " missing from " + pair[0]);
}

// --- arm 2: chapter vocab-box terms present in the deck ---------------------
const SMART = String.fromCharCode(8216, 8217);
const APOS = String.fromCharCode(39);
const ENT = { "&rsquo;": APOS, "&lsquo;": APOS, "&#39;": APOS, "&apos;": APOS,
              "&amp;": "&", "&mdash;": "-", "&ndash;": "-", "&nbsp;": " ",
              "&ldquo;": "", "&rdquo;": "", "&quot;": "" };
const norm = s => {
  let t = s;
  for (const k of Object.keys(ENT)) t = t.split(k).join(ENT[k]);
  return t.replace(new RegExp("[" + SMART + "]", "g"), APOS)
          .replace(/["\u201c\u201d]/g, "")
          .replace(/\s+/g, " ").trim().toLowerCase();
};

for (let n = 1; n <= 15; n++) {
  const file = "ch" + n + ".html";
  if (!fs.existsSync(file)) continue;
  const html = fs.readFileSync(file, "utf8");
  const inChapter = new Set();
  const boxRe = /<div class="vocab-box">([\s\S]*?)<\/div>/g;
  let b;
  while ((b = boxRe.exec(html)) !== null) {
    const tRe = /<p><strong>([^<]*?):?<\/strong>/g;
    let t;
    while ((t = tRe.exec(b[1])) !== null) inChapter.add(norm(t[1]));
  }
  const deckTerms = ((VOCAB[String(n)] || {}).terms || []).map(x => norm(x.term));
  const deck = new Set(deckTerms);
  for (const term of inChapter)
    if (!deck.has(term))
      problem("vocab", "ch" + n + ": \"" + term + "\" is in the chapter but not the VOCAB deck");
}

// --- arm 3: cross-page anchors resolve --------------------------------------
const tl = fs.readFileSync("timeline.html", "utf8");
const tlRe = /ch:\s*(\d+)\s*,\s*anchor:\s*"([^"]+)"/g;
let m;
while ((m = tlRe.exec(tl)) !== null) {
  const file = "ch" + m[1] + ".html";
  if (!fs.existsSync(file)) { problem("anchor", "timeline.html -> " + file + " (missing)"); continue; }
  if (!fs.readFileSync(file, "utf8").includes("id=\"" + m[2] + "\""))
    problem("anchor", "timeline.html -> " + file + "#" + m[2] + " does not exist");
}

if (!fail) console.log("  companion resources in sync");
process.exit(fail);
