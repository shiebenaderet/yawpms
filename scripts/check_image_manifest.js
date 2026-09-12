// Every chapter image must have a provenance record, and every record must match a file.
//
// audit_images.sh --strict answers only "does this referenced file exist on disk?".
// A file can be present, referenced and rendering perfectly while nobody knows its artist,
// date or licence -- which makes its caption unfalsifiable. Two ch5 images were in exactly
// that state while CI passed. Run via: bash scripts/check_image_manifest.sh
const fs = require("fs");
const { execFile } = require("child_process");
const CHECK_URLS = process.argv.includes("--check-urls");
let fail = 0;
const problem = m => { console.log("  " + m); fail = 1; };

const REF   = /images\/(ch\d+)\/([A-Za-z0-9._-]+)/g;   // chapter images
const PSREF = /images\/(ch\d+-[A-Za-z0-9._-]+)/g;      // primary-source images (flat, chN-slug)
const ENTRY = /\["([^"]+)"\]/g;
const names = (text, re) => [...text.matchAll(re)];

for (let n = 1; n <= 15; n++) {
  const chapter = `ch${n}.html`, script = `scripts/download_ch${n}_images.sh`, dir = `images/ch${n}`;
  if (!fs.existsSync(chapter)) continue;

  const referenced = new Set(
    names(fs.readFileSync(chapter, "utf8"), REF)
      .filter(m => m[1] === `ch${n}`)
      .map(m => m[2])
  );
  if (!referenced.size) continue;

  if (!fs.existsSync(script)) { problem(`ch${n}: ${referenced.size} image(s) referenced but ${script} is missing`); continue; }

  const manifest = new Set(names(fs.readFileSync(script, "utf8"), ENTRY).map(m => m[1]));
  const onDisk = new Set(fs.existsSync(dir) ? fs.readdirSync(dir).filter(f => !f.startsWith(".")) : []);

  for (const f of referenced)
    if (!manifest.has(f)) problem(`ch${n}: ${f} is referenced by ${chapter} but has no manifest entry -- no provenance record`);
  for (const f of manifest)
    if (!onDisk.has(f)) problem(`ch${n}: ${script} lists ${f}, which is not in ${dir}`);
}

// Primary-source images: one flat manifest, chN-slug naming.
const psScript = "scripts/download_primary_source_images.sh";
if (fs.existsSync(psScript)) {
  const manifest = new Set(names(fs.readFileSync(psScript, "utf8"), ENTRY).map(m => m[1]));
  const onDisk = new Set(fs.readdirSync("primary-sources/images").filter(f => !f.startsWith(".")));
  const referenced = new Set();
  for (const f of fs.readdirSync("primary-sources").filter(f => f.endsWith(".html")))
    for (const m of names(fs.readFileSync(`primary-sources/${f}`, "utf8"), PSREF)) referenced.add(m[1]);

  for (const f of referenced)
    if (!manifest.has(f)) problem(`primary-sources: ${f} is referenced but has no manifest entry`);
  for (const f of manifest)
    if (!onDisk.has(f)) problem(`primary-sources: manifest lists ${f}, which is not on disk`);
  for (const f of onDisk)
    if (!referenced.has(f)) problem(`primary-sources: ${f} is on disk but referenced by no page (orphan)`);
}

// --check-urls: does each provenance record actually RESOLVE?
//
// Everything above asks whether an entry and a file exist. Neither asks whether the URL the
// entry names still leads anywhere. Two ch7 entries pointed at Commons titles that had never
// existed: one was a Jefferson "campaign banner" that is really a Richmond elector circular
// naming no candidate, the other an almanac scan traceable to no repository at all. Both
// passed every check in this repo while their captions stayed unverifiable. A sweep on
// 2026-09-11 found 29 of 132 entries dead across 11 chapters.
//
// Network-gated and opt-in, so the default check stays deterministic and offline.
const UA = "AmericanYawpMS-ImageDownloader/1.0 (https://github.com/shiebenaderet/yawpms; contact via GitHub Issues)";
const ENTRY_URL = /\["([^"]+)"\]="([^"]*)"/g;

const status = url => new Promise(resolve => {
  execFile("curl", ["-sS", "-o", "/dev/null", "-w", "%{http_code}", "-L", "--max-time", "60", "-A", UA, url],
    { timeout: 90000 }, (err, stdout) => resolve((stdout || "000").trim()));
});

async function checkUrls() {
  const entries = [];
  for (const script of fs.readdirSync("scripts").filter(f => /^download_.*\.sh$/.test(f)))
    for (const m of fs.readFileSync(`scripts/${script}`, "utf8").matchAll(ENTRY_URL))
      entries.push({ script, name: m[1], url: m[2] });

  console.log(`  checking ${entries.length} manifest URL(s) -- this makes network requests`);
  const dead = [];
  const CONCURRENCY = 4;
  let next = 0;
  await Promise.all(Array.from({ length: CONCURRENCY }, async () => {
    while (next < entries.length) {
      const e = entries[next++];
      if (!e.url) { dead.push({ ...e, code: "empty" }); continue; }
      const code = await status(e.url);
      if (code !== "200") dead.push({ ...e, code });
    }
  }));

  for (const d of dead.sort((a, b) => (a.script + a.name).localeCompare(b.script + b.name)))
    problem(`${d.script}: ${d.name} -- source URL does not resolve (${d.code}); provenance unverifiable`);
  if (!dead.length) console.log(`  all ${entries.length} source URLs resolve`);
}

(async () => {
  if (CHECK_URLS) await checkUrls();
  if (!fail) console.log("  every referenced image has a manifest entry, and every entry matches a file");
  process.exit(fail);
})();
