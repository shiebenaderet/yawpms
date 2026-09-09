# Tasks — American Yawp MS

Working backlog for **Q4 2026 and Q1 2027**, decomposed from [ROADMAP.md](ROADMAP.md).
Every task traces to a roadmap definition-of-done bullet; nothing here is invented work.

**Model tags:** `[fable]` historical/pedagogical judgment · `[sonnet]` routine edits, markup,
scripts · `[haiku]` mechanical verification.  **Sizes:** S = under an hour · M = a few hours ·
L = multi-session.

Tasks are ordered by dependency within each milestone. `after:` lists hard prerequisites —
work done out of that order is wasted, not merely early.

**148 tasks across 10 milestones.** M2, M4, M7 and M8 have no blocking milestone and can
start immediately.

---

## Discovered during execution

**2026-09-08 — M0-3/M0-4/M0-5 landed.** The 14 broken references were not lost images:
none appeared in any download script. They were filenames invented to fill slide and
timeline slots for pictures nobody ever sourced. Consequences for later milestones:

- **Two filenames each served two unrelated events.** `burning-of-jamestown.jpg` was on
  both "Jamestown Founded" (1607) and "Bacon's Rebellion" (1676) — the burning *is*
  Bacon's Rebellion, so it now serves 1676 only. `civil-war-1861.jpg` was on
  "Emancipation Proclamation" (1863) and "Lincoln Assassinated" (1865). **M4/M6 should
  assume this class of error exists elsewhere** and check filename against caption, not
  just existence on disk.
- **The repo now has its first non-public-domain image.** `ch3/jamestown-burial.jpg` is
  CC BY-SA 3.0 with attribution required. `timeline.html` had no field able to carry a
  credit, so an optional `credit:` (and `alt:`) field was added to the entry schema and
  rendered under the description, with a dark-mode CSS counterpart. Any future
  CC-licensed timeline image must use it.
- **A resolving reference is not a correct one.** After sourcing, every path resolved
  while the 1607 entry still showed a 1676 burning. An existence check cannot catch a
  caption/image mismatch — M0-8's CI job will not either. Only reading the image does.
- **Flagged for M4, not fixed here:** the 1619 entry ("First Enslaved Africans Arrive in
  Virginia") uses `ch3/old-plantation.jpg`, a c.1785–95 watercolor ~170 years later. Not
  a broken reference, so out of M0 scope.
- **Not yet done in M0:** M0-1 and M0-2 (the audit script's regex and macOS portability)
  remain open — these fixes were made by direct extraction instead. M0-8's failing
  image-ref job still waits on them.


**2026-09-07 — M0-6/M0-7 landed.** Notes that change later work:

- **`html-validate` found 12 real WCAG failures**, not just style noise: every `<th>` in
  `pacing-guide.html`'s three tables lacked a `scope` attribute (rule `wcag/h63`), so
  screen readers could not associate headers with cells on a teacher-facing page. Fixed
  (`scope="col"`). `DESIGN_GUIDE.md` claims the accessibility audit passed — **M7 should
  treat its ✅ rows as unverified.**
- **5 raw `&` characters** in `standards.html` and `teaching.html` are now `&amp;`.
- **`.htmlvalidate.json` disables exactly three stylistic rules** —
  `no-implicit-button-type` (542 hits), `no-inline-style` (128), `void-style` (56) — and
  leaves every correctness and accessibility rule on. The repo passes clean at exit 0.
  Re-enabling any of the three means fixing 700+ findings first.
- **The link checker must distinguish bot-blocked from dead.** A first pass flagged 5
  failures; all 5 were false. `founders.archives.gov` answers `202` with a **zero-byte**
  body, and `encyclopediavirginia.org` answers `403` to any non-browser client — both
  serve fine to humans. The job now classifies `403/429/202/503` as *blocked*
  (informational) and only genuine 4xx/5xx/000 as *broken* (opens an issue). Verified
  full sweep: **62 URLs, 0 broken, 3 blocked** (all Encyclopedia Virginia).
- **`html-validate` is not installed and there is no `package.json`**; CI uses
  `npx --yes`. `CLAUDE.md`'s "run `npx html-validate`" instruction prompts locally
  without `--yes`.
- **M0-8 was deliberately not done here.** It depends on M0-2 and M0-4 (the audit-script
  fix and the editorial image picks), and landing a failing image job before those would
  put main red by design.

---


# Q4 2026


## M0 — Truth tooling and week-one triage

- [x] **M0-1** Fix Phase 1 of scripts/audit_images.sh to extract refs matching `(src|img)[[:space:]]*[:=][[:space:]]*"` from all 48 root and primary-sources HTML files, not just `src="..."`  
  `S` `[sonnet]`  
  *Done when `bash scripts/audit_images.sh | grep 'Missing from disk'` prints 14 (was 0) and audit-results.json's missing_images array contains images/ch11/underground-railroad.jpg and images/ch3/burning-of-jamestown.jpg.*  
  > The roadmap says '16 broken refs'; that is 16 raw references (12 in slideshows.html, 4 in timeline.html) over 14 unique paths — beringia-land-bridge.png and bleeding-kansas.jpg each appear in both files. The audit dedups via `sort -u`, so its counter reads 14. Do not 'correct' the roadmap; both numbers are right at different granularity.  

- [x] **M0-2** Replace the GNU-only `stat -c%s` calls in scripts/audit_images.sh (line 314, and line 570 inside the generated download-missing.sh heredoc) with a portable size probe  
  `S` `[sonnet]` · after: `M0-1`  
  *Done when `grep -n 'stat -c\|grep -oP\|grep -P\|sed -i ' scripts/audit_images.sh` returns 0 matches and the script prints the same 'Missing from disk' and 'Orphaned files' counts on macOS and on ubuntu-latest.*  
  > `stat -c%s` currently fails silently on macOS via `|| echo 0`, so every orphan reports as 0KB. Use `wc -c < "$f"` rather than branching on `stat -f%z` vs `stat -c%s`. Same file as M0-1, so sequence them to avoid a conflict.  

- [x] **M0-3** Repoint the 9 mechanical name-mismatch `src:`/`img:` keys in slideshows.html and timeline.html at the filenames that already exist on disk or are declared in scripts/download_all_maps.sh  
  `S` `[sonnet]` · after: `M0-1`  
  *Done when `bash scripts/audit_images.sh | grep 'Missing from disk'` prints 5 and no slideshow/timeline caption or alt text still describes the old filename's subject.*  
  > Candidates confirmed on disk: beringia-land-bridge.png→beringia-map.jpg, thirteen-colonies-1775.png→thirteen-colonies-map.png, triangular-trade.png→triangular-trade-map.png, gold-rush.jpg→gold-rush-miners.jpg, manifest-destiny-painting.jpg→american-progress.jpg, black-soldiers.jpg→usct-soldiers.jpg, black-legislators.jpg→reconstruction-congress.jpg, civil-war-1861.jpg→civil-war-states-map.png. underground-railroad.jpg→underground-railroad-map.jpg is declared in download_all_maps.sh but absent from disk, so run that script. The fixed audit's 'LIKELY NAME MISMATCHES' section is the authority on the final list. Two of these swap a scene for a map (civil-war-1861, underground-railroad) — the caption must change with the file.  

- [x] **M0-4** Source, license-verify and commit replacement images for the ~5 broken refs with no disk candidate (ch13/bleeding-kansas, ch14/appomattox, ch14/civil-war-battle, ch15/reconstruction-ends, ch3/burning-of-jamestown), adding each to its scripts/download_chN_images.sh  
  `M` `[fable]` · after: `M0-1`, `M0-3`  
  *Done when `bash scripts/audit_images.sh | grep 'Missing from disk'` prints 0 and every new file has an artist/date/collection/license comment line in its per-chapter download script.*  
  > CLAUDE.md 2.1 is binding: look at the actual image, fetch Wikimedia extmetadata (action=query&prop=imageinfo&iiprop=extmetadata), confirm artist/date/license, and never write a caption from a filename. IMAGES_AUDIT.md already claims ch3 uses Pyle's *Burning of Jamestown* (1676) — that file was never committed, so this is a real gap, not a rename. Slideshow and timeline captions must be written from the chosen image, not carried over.  

- [x] **M0-5** Record all 14 resolved image paths in IMAGES_AUDIT.md with old ref, replacement filename, and license/attribution line  
  `S` `[sonnet]` · after: `M0-3`, `M0-4`  
  *Done when `grep -c` in IMAGES_AUDIT.md returns at least 1 for each of the 14 old filenames and each entry carries a license string.*  
  > Must run after both fix passes so the logged replacement names are final. IMAGES_AUDIT.md's 'Recent changes' paragraph currently claims the Jamestown image is already in the chapter HTML — correct that claim in the same edit.  

- [x] **M0-6** Create .github/workflows/site-check.yml (push to main + pull_request) with an html-validate job and a committed .htmlvalidate.json the repo already passes  
  `S` `[sonnet]`  
  *Done when a PR introducing an unclosed <section> in ch1.html fails the html-validate job, a no-op PR passes, and site-check.yml is the only workflow file besides content-change-check.yml.*  
  > Re-cut so the workflow exists WITHOUT waiting on maintainer image picks — html-validate and the link-check are dependency-free. Only the failing image-ref job (M0-8) must land after M0-4. Pick a ruleset the 48 hand-written files pass today so the gate catches regressions instead of demanding a mass rewrite. Every job added here later MUST gate on `if: github.event_name == ...` or it runs on every trigger.  

- [x] **M0-7** Add a monthly scheduled link-check job to site-check.yml that curls every href inside the 61 <p class="ps-source-link"> blocks  
  `M` `[sonnet]` · after: `M0-6`  
  *Done when the job has both a monthly `schedule:` cron and `workflow_dispatch`, carries `if: github.event_name == 'schedule' || github.event_name == 'workflow_dispatch'`, a manual dispatch checks 62 URLs, and an injected bad URL exits non-zero naming the file and source id.*  
  > 61 blocks but 62 anchors — source 1.2 (Cahokia) deliberately carries two links per CLAUDE.md 2.2. Use a browser User-Agent and a 20s timeout so CI and the local link-checker subagent agree; Archive.org rate-limits and some library catalogs 403 non-browser agents. MUST be event-gated or the 62-URL sweep runs on every PR and breaks M0-6's green-on-first-run.  

- [x] **M0-8** Add the failing image-ref job to site-check.yml that runs scripts/audit_images.sh and fails when any reference is missing  
  `S` `[sonnet]` · after: `M0-6`, `M0-2`, `M0-4`  
  *Done when the job exits non-zero on a PR that deletes any file under images/, carries `if: github.event_name != 'schedule'`, and its first run on main after M0-4 merges is green.*  
  > audit_images.sh currently exits 0 regardless of findings — parse the count or add --strict rather than relying on its status. Lands after the editorial picks so main is never red by design.  

- [x] **M0-9** git rm the root-level download_ch6_images.sh and js/tts-kokoro.js  
  `S` `[sonnet]`  
  *Done when `ls download_ch6_images.sh js/tts-kokoro.js` reports no such file for both and `grep -rl 'tts-kokoro' --exclude-dir=.git .` returns only CLAUDE.md and ROADMAP.md.*  
  > scripts/download_ch6_images.sh is the canonical copy and stays. The root duplicate pulls over plain http:// with no skip-existing guard and will overwrite good tracked images with error pages. tts-kokoro.js was intentionally orphaned in PR #42 and is loaded by zero pages — deleting it is the roadmap's decision, not a reversal. Update CLAUDE.md section 4's trap entries in the same commit.  

- [x] **M0-10** Add minimal .chapter-resources / .resource-links rules to css/chapter.css, each with a body.dark-mode counterpart  
  `S` `[sonnet]`  
  *Done when `grep -c 'chapter-resources\|resource-links' css/chapter.css` is greater than 0 with at least one `body.dark-mode` counterpart rule, and the block in ch2.html no longer renders as an unstyled default `<ul>`.*  
  > Exactly 10 chapters carry the block (ch2, ch4, ch5, ch6, ch7, ch9, ch10, ch11, ch12, ch13) and css/ has zero rules for it today. CLAUDE.md 2.4 requires a body.dark-mode counterpart for every new chapter.css rule. Do NOT propagate the block to the other 5 chapters (that is M5-2) and do NOT wire the 30 inert `?ch=N` links (also M5).  

- [x] **M0-11** Correct three stale doc claims: CONTRIBUTING.md's "they're not stored in the repo", README.md's "under construction" for the Primary Source Reader (lines 120 and 160), and teaching.html:325's "in development" standards guide  
  `S` `[sonnet]`  
  *Done when `grep -in "not stored in the repo" CONTRIBUTING.md`, `grep -in 'under construction' README.md`, and `grep -in 'in development' teaching.html` all return 0 matches.*  
  > All 124 images under images/ and 16 under primary-sources/images/ are tracked, so CONTRIBUTING.md's download instruction at lines 105-107 is actively wrong today — this does not wait on the image fixes. teaching.html must say the Common Core section shipped while being honest that C3/NCSS are still absent; the full rewording to 'shipped, with a link' is M8's job, so keep the edit to removing the false 'in development' framing.  

- [x] **M0-12** Verify every M0 done-when line mechanically on both macOS and ubuntu-latest and record the results  
  `S` `[haiku]` · after: `M0-2`, `M0-5`, `M0-6`, `M0-7`, `M0-8`, `M0-9`, `M0-10`, `M0-11`  
  *Done when a single verification run confirms: audit reports 0 missing with identical counts on both platforms, the latest site-check.yml run on main is green with all three jobs present, both deleted files are absent, and the CSS and doc greps in M0-10/M0-11 pass.*  
  > Mechanical only — no judgment calls. If the two platforms disagree on any count, that is an M0-2 regression and reopens it rather than being logged as a pass.  

- [x] **M0-13** Add `audit-results.json` to .gitignore  
  `S` `[sonnet]`  
  *Done when `git status --porcelain` is empty immediately after `bash scripts/audit_images.sh` runs.*  
  > Tracked three times historically and removed in 286963f, but never ignored — so every audit run reappears as an untracked file. Fixed once, never made unable to recur: the exact pattern M0 exists to correct.

- [ ] **M4-18** Add a manifest-integrity arm to site-check.yml: every `images/chN/` file referenced by a chapter has a manifest entry, and every manifest entry matches a file on disk  
  `S` `[sonnet]` · after: `M0-6`  
  *Done when a PR that references an unmanifested image fails CI.*  
  > Found during the ch5 figure audit: two ch5 images were referenced with no provenance record and `audit_images.sh --strict` passed anyway, because existence on disk is not provenance.

<details><summary>Why this order</summary>

The audit script is the measuring instrument for the whole milestone, so it is fixed first (M0-1, M0-2): with the current `src="..."`-only regex it prints `Missing from disk: 0` while 14 paths are broken, so any image fix done before it is unverifiable and any CI gate built on it would be a gate that can never fire. Portability (M0-2) comes before CI because ubuntu-latest and the maintainer's macOS must produce the same count or a green local run means nothing. The image fixes (M0-3 mechanical, M0-4 editorial) come after the instrument and before the workflow, because the DoD requires site-check.yml to be green on its first run — a workflow merged before the images would land red on main. M0-5 logs licenses only once both fix passes have decided what the final filenames are. site-check.yml must exist (M0-6) before the html-validate (M0-7) and monthly link-check (M0-8) jobs can be added to it; the roadmap allows exactly one workflow file, so these are jobs, not new files. M0-9, M0-10 and M0-11 are dependency-free and can run in parallel with everything above; M0-11 in particular does not wait on the image work, since CONTRIBUTING.md's "not stored in the repo" claim is already false for all 124 tracked images. M0-12 is last because it re-checks every other task's assertion on both platforms.

</details>


## M1 — ch6/ch7 get real skeletons, then search lands on a section

**Hard deadline ~Nov 10 (pacing week 10)**

- [x] **M1-1** Write scripts/check_companion_sync.sh with three independent failure arms: chapter .vocab-box term missing from VOCAB (vocabulary-cards.html), chapter key absent from QUIZZES/VOCAB/SLIDES, and a timeline.html/slideshows.html chapter anchor whose id does not exist in chN.html  
  `S` `[sonnet]`  
  *Done when `bash scripts/check_companion_sync.sh` exits non-zero on current main, names 18 missing ch6 terms and 12 missing ch7 terms, and prints 57/57 for resolved timeline anchors.*  
  > Verified inputs: QUIZZES (quizzes.html:245), VOCAB (vocabulary-cards.html:339) and SLIDES (slideshows.html:425) each already have all 15 keys, so that arm passes today. Anchors live as `ch:N, anchor:"…"` keys in timeline.html (57 refs, 42 unique) — there is no href form. slideshows.html currently has ZERO chapter anchors; scan it for `chN.html#id` anyway so the arm stays correct if slides gain links. Match `id="…"` anywhere in the chapter file, not `<section id=`, so the script gives the same 57/57 before and after M1-2/M1-3. Normalize HTML entities and \u escapes when comparing terms — ch7 has `Gabriel&rsquo;s Rebellion` in the box vs `Gabriel’s Rebellion` in the deck.  

- [x] **M1-2** Wrap the ten section-heading h2 blocks in ch6.html in <section id="…">, moving intro, shays, convention, ratification, slavery, hamilton, whiskey, french, election and conclusion off the h2 and onto the section  
  `M` `[sonnet]` · after: `M1-1`  
  *Done when `grep -c '^<section id=' ch6.html` returns 10, `grep -c '<h2[^>]*id=' ch6.html` returns 0, and `bash scripts/check_companion_sync.sh` still prints 57/57 for timeline anchors.*  
  > Do NOT wrap the three h2s in .toc, .overview and .big-questions (ch6.html:33, 49, 58) — they have no ids and are separate blocks in the ch1–ch5/ch8–ch15 pattern. Per CLAUDE.md, nothing but whitespace may sit between `<section id=…>` and its `<h2>` or the indexer silently drops the section. Each section ends where the next section-heading h2 begins; the last (conclusion) closes before `<div class="chapter-resources">` at ch6.html:491. ch6 uses `&mdash;` — keep the entity encoding. ch6 is the largest chapter (53KB, 13 h2 total) and carries the ~Nov 10 pacing deadline.  

- [x] **M1-3** Wrap the seven section-heading h2 blocks in ch7.html in <section id="…">, moving intro7, slavery7, republicanism, jefferson-pres, native, war1812 and conclusion7 off the h2 and onto the section  
  `M` `[sonnet]` · after: `M1-1`  
  *Done when `grep -c '^<section id=' ch7.html` returns 7, `grep -c '<h2[^>]*id=' ch7.html` returns 0, and `bash scripts/check_companion_sync.sh` still prints 57/57 for timeline anchors.*  
  > Same rules as M1-2: skip the .toc/.overview/.big-questions h2s (ch7.html:33, 46, 54), no non-whitespace between section and h2, keep `&mdash;`. Last section closes before `<div class="chapter-resources">` at ch7.html:418. Three of the 57 timeline anchors point here (jefferson-pres, slavery7, war1812).  

- [x] **M1-4** Strip the five unstyled/banned class usages from ch6.html and ch7.html: 74 `class="body-text"` paragraphs, any leftover `class="section-heading"`, `<div class="subtitle">` → `<div class="chapter-subtitle">`, `<div class="attribution">` → `<p class="attribution">`, and `<div class="attribution-footer">` → a `<footer>` block matching ch5.html:348  
  `S` `[sonnet]` · after: `M1-2`, `M1-3`  
  *Done when `grep -E 'class="body-text"|class="section-heading"|class="subtitle"|attribution-footer|<div class="attribution"' ch6.html ch7.html | wc -l` returns 0.*  
  > Counts verified: body-text 46 in ch6 + 28 in ch7; section-heading 10 + 7 (M1-2/M1-3 should already have removed these); subtitle at line 24 of each; div.attribution at line 25 of each; attribution-footer at ch6.html:504 and ch7.html:430. All four replacement classes already have CSS — `.chapter-subtitle` and `.attribution` are in chapter.css, `footer` has 3 rules; the five banned ones have zero rules anywhere, so nothing renders differently by accident. `pdf-subtitle` (ch6.html:615, ch7.html:541) must survive — do not use a bare `subtitle` grep to edit.  

- [x] **M1-5** Verify the ch6/ch7 restructure is structural only by diffing tag-stripped visible text against the pre-M1 blobs from `git show`  
  `S` `[haiku]` · after: `M1-4`  
  *Done when a text-extraction diff between the restructure PR's own merge-base and head is byte-identical for ch6.html and ch7.html.*  
  > Use the same strip as build_search_index.sh (drop <script>/<style>, strip tags, collapse whitespace) so entity handling matches. Record the pre-M1 SHA before M1-2 starts; f4e5cf9 is the last commit before this milestone. Run it against ch6 as soon as M1-4 lands for ch6 rather than waiting for ch7 — ch6 has the Nov 10 deadline. Diff the PR's own merge-base, NOT a hardcoded pre-milestone SHA — otherwise any M4 text edit landing during M1 fails this check even though the restructure is correct.  

- [x] **M1-6**  Verify in a browser that ch6.html and ch7.html now show a reading-time estimate, start Read Aloud, and list every section in the Print/PDF picker  
  `S` `[haiku]` · after: `M1-4`  
  *Done when, served over `python3 -m http.server 8000`, ch6.html and ch7.html each render a non-empty "About N min read", Read Aloud begins speaking, and the PDF picker lists 10 (ch6) and 7 (ch7) section rows beyond the Title/TOC/Overview/Big Questions/Activity entries.*  
  > All three features key off `document.querySelectorAll('section, …')` in js/reader-tools.js — reading time at line 688, Read Aloud node collection at 713, PDF picker at 484 — which is why they are dead in ch6/ch7 today. Must be served over HTTP, not `open ch6.html` (CLAUDE.md section 3).  

- [x] **M1-7** Fix both regex bugs in scripts/build_search_index.sh — make the `<section…>` prefix genuinely optional and capture the id non-greedily from `<section id>` with an `h2` fallback — then rebuild and commit js/search-index.json  
  `M` `[sonnet]` · after: `M1-4`  
  *Done when `bash scripts/build_search_index.sh` prints "15 chapters indexed" and a node pass over js/search-index.json reports ch6 with 10 sections, ch7 with 7, and 0 sections whose `id` is the empty string.*  
  > MUST come after M1-2/M1-3 — running it first re-indexes ch6/ch7 as empty and forces a second rebuild and a second index commit. Current state: 15 chapters, 89 sections, ch6=0, ch7=0, and 89/89 ids empty. Real trap: once the `<section>` prefix is truly optional the regex also matches the .toc/.overview/.big-questions h2s in all 15 files, none of which carry an id — drop id-less matches or the "0 entries with id: ''" clause can never pass. Also note js/search-index.json is a tracked file, so it must be committed in the same commit as the script fix.  

- [x] **M1-8**  Verify in a browser that a search result now lands on a section anchor rather than the top of a chapter  
  `S` `[haiku]` · after: `M1-7`  
  *Done when, served over localhost, typing "Whiskey Rebellion" into the chapter search returns a result whose anchor href is exactly `ch6.html#whiskey` and following it scrolls to section VII.*  
  > js/search.js:212 builds `basePath + hit.file + (hit.id ? '#' + hit.id : '')`, so this can still fail on a correct index if basePath is wrong from a subdirectory — check from a chapter page, not only index.html. Search hangs forever on `file://` (XMLHttpRequest), so HTTP is mandatory.  

- [x] **M1-9** Backfill the 18 ch6 and 12 ch7 vocab terms that exist in chapter .vocab-box blocks but are missing from VOCAB in vocabulary-cards.html  
  `M` `[sonnet]` · after: `M1-1`  
  *Done when `bash scripts/check_companion_sync.sh` reports 0 missing terms for ch6 and ch7.*  
  > Definitions already exist verbatim in the chapter boxes, so this is a copy, not authoring. ch6 missing: Ratify, Federalists, Anti-Federalists, Bill of Rights, Secretary of the Treasury, Bank of the United States, Strict construction, Loose construction, Excise tax, Impressment, Jay's Treaty (1794), French Revolution, Alien Act (1798), Sedition Act (1798), XYZ Affair, Electoral College, Peaceful transfer of power, Judicial review. ch7 missing: Suffrage, Second Great Awakening, Play-off system, Tecumseh, Tenskwatawa (The Prophet), Confederacy, War Hawks, Impressment, Treaty of Ghent, Hartford Convention, Monroe Doctrine, American System. VOCAB uses \u escapes for curly quotes and em dashes — match the file's existing encoding. Impressment and Judicial review appear in both chapters' boxes; each deck gets its own copy.  

- [x] **M1-10** Backfill the 8 pre-existing drifted vocab terms in ch5, ch9, ch10, ch12 and ch14 so check_companion_sync.sh can pass on all 15 chapters  
  `S` `[sonnet]` · after: `M1-9`  
  *Done when `bash scripts/check_companion_sync.sh` exits 0 with no missing terms reported for any of the 15 chapters.*  
  > Found during M1 verification, not listed in the roadmap, but required or the M1-13 CI job can never be added without turning main red. The 8: ch5 "No taxation without representation"; ch9 States' rights; ch10 Suffrage and Convention; ch12 Treaty of Guadalupe Hidalgo (1848) and Foreign Miners' Tax; ch14 Secession and Confederacy (Confederate States of America). The ch5 term is wrapped in typographic quotes inside the box — decide once whether the comparison strips quotes or the deck entry keeps them, and apply the same rule in the script. ch10's Suffrage/Convention duplicate ch6/ch7 deck entries; that is fine, decks are per-chapter. This is NOT the M6 'thin deck' expansion — do not add terms that no .vocab-box contains.  

- [x] **M1-11** Add a section-count / banned-class job to .github/workflows/site-check.yml that fails when any chapter has fewer <section id> blocks than h2 ids or when body-text, section-heading, subtitle, attribution-footer or <div class="attribution"> reappears in any ch*.html  
  `S` `[sonnet]` · after: `M1-4`, `M0-6`  
  *Done when the job exits 0 on main and exits non-zero on a scratch commit that re-adds `class="body-text"` to one paragraph of ch6.html, both observed in the Actions run.*  
  > Roadmap requires this to ship in the SAME PR as M1-2/M1-3/M1-4 — adding it earlier turns main red. site-check.yml is created in M0; there must be exactly one workflow file, so add a job, not a new file. Use POSIX grep only, no `grep -oP` — content-change-check.yml's GNU-only `grep -oP` is the existing bug to avoid repeating. The pattern must not match `pdf-subtitle` or `chapter-subtitle`.  

- [x] **M1-12** Add a search-index freshness job to .github/workflows/site-check.yml that re-runs scripts/build_search_index.sh and fails on `git diff --exit-code js/search-index.json`  
  `S` `[sonnet]` · after: `M1-7`, `M0-6`  
  *Done when the job exits 0 on main and exits non-zero on a scratch commit that edits a ch6.html h2 without rebuilding the index, both observed in the Actions run.*  
  > Ships in the same PR as M1-7. This is the guard that makes a stale index unshippable — the current advisory content-change-check.yml only posts a comment and never fails. build_search_index.sh output is deterministic (JSON.stringify with indent 0) so the diff is stable; it needs node on the runner, and its `stat -c%s || stat -f%z` fallback already works on ubuntu-latest.  

- [x] **M1-13** Add a companion-sync job to .github/workflows/site-check.yml that runs scripts/check_companion_sync.sh and fails on a non-zero exit  
  `S` `[sonnet]` · after: `M1-10`, `M0-6`, `M1-1`  
  *Done when the job exits 0 on main and exits non-zero on a scratch commit that deletes one term from VOCAB["6"] in vocabulary-cards.html, both observed in the Actions run.*  
  > Gated on M1-10, not just M1-9: the 8 ch5/ch9/ch10/ch12/ch14 drifted terms would keep main red otherwise. Ships in the same PR as M1-9/M1-10. Must run on push to main and pull_request like the rest of site-check.yml.  

- [x] **M1-14** Correct the two CLAUDE.md section 4 trap entries that M1 invalidates — the build_search_index.sh two-regex-bug bullet and the "ch6.html and ch7.html are not templates" bullet  
  `S` `[sonnet]` · after: `M1-7`, `M1-4`  
  *Done when `grep -c 'ch6 and ch7 index zero\|all 89 indexed sections carry\|Zero <section> elements' CLAUDE.md` returns 0.*  
  > Called for by the roadmap's Review cadence section, which names the section 4 search-index bug specifically. Leave the `<div class="attribution">` do-not-blind-fix note's history intact but state that it was resolved in M1; do not touch the .chapter-resources bullet (M0/M5 own that) or the .claude/agents/ note in section 5.  

- [x] **M1-15** Re-run every M1 mechanical check in one pass on main and record the results  
  `S` `[haiku]` · after: `M1-5`, `M1-6`, `M1-8`, `M1-11`, `M1-12`, `M1-13`, `M1-14`  
  *Done when a single script run reports: ch6=10 and ch7=7 `^<section id=` lines, 0 banned-class hits across ch6/ch7, 0 `<h2 … id=` in either file, check_companion_sync.sh exit 0 with 57/57 anchors, index 15 chapters with 0 empty ids, and all three site-check.yml jobs green on the latest main commit.*  
  > Mechanical only — this task re-verifies, it does not fix. Anything red here goes back to the owning task rather than being patched inside this one. The browser items (M1-6, M1-8) are already signed off and are not re-run here.  

<details><summary>Why this order</summary>

Three ordering constraints drive this list. (1) The roadmap's explicit trap: scripts/build_search_index.sh must be fixed AFTER ch6.html and ch7.html gain <section> elements (M1-7 depends on M1-4). Verified today: js/search-index.json has 15 chapters, 89 sections, ch6=0 and ch7=0 sections, and 89/89 entries with id:"". Fixing the regex first would re-index ch6/ch7 as empty and force a second rebuild plus a second index commit. (2) scripts/check_companion_sync.sh is written FIRST (M1-1) even though its own DoD bullet appears later, because its anchor arm is the only mechanical way to prove the "57/57 timeline anchors still resolve" clause in the restructure tasks — timeline.html carries exactly 57 `ch:N, anchor:"…"` entries, 5 of them pointing into ch6/ch7 (convention, ratification, jefferson-pres, slavery7, war1812). Writing the script after the restructure would leave DoD bullet 1 unverifiable at the moment it matters. It also captures the "red before backfill" state the DoD requires. (3) Each of the three site-check.yml jobs (M1-11, M1-12, M1-13) must land after its corresponding fix, or main goes red the moment the job is added — this is why the companion-sync job (M1-13) waits on M1-10 and not just M1-9. Within the chapter work, the class cleanup (M1-4) follows the sectioning (M1-2/M1-3) rather than preceding it, because the sectioning pass already strips `class="section-heading"` off the ten/seven h2 elements it moves ids from; running the cleanup first would touch those same lines twice. The byte-identity check (M1-5) and the browser check (M1-6) both gate on M1-4 so they run once against final markup. The whole milestone sits behind M0, which creates .github/workflows/site-check.yml (it does not exist yet — .github/workflows/ contains only content-change-check.yml). ch6 carries the Nov 10 pacing deadline, so M1-2 → M1-4 → M1-5/M1-6 is the critical path; ch7's chain can trail it by two weeks.

</details>


## M2 — Review pipeline before review #1

- [x] **M2-1** Create data/chapters.json as the single hand-edited chapter-status source (15 entries; number, title, status, reviewers[], review_slot_issue, chapter_sha)  
  `S` `[sonnet]`  
  *Done when `python3 -c "import json;c=json.load(open('data/chapters.json'))['chapters'];assert len(c)==15 and all({'number','title','status','reviewers','review_slot_issue','chapter_sha'}<=set(x) for x in c)"` exits 0 and the 15 titles match the current REVIEW_STATUS.md table exactly.*  
  > There is no data/ directory yet. Titles differ between surfaces today — README.md carries "A New Nation (1786-1800)" and "The Early Republic (1800-1824)" while REVIEW_STATUS.md and teachers.html carry the short forms; pick one canonical title per chapter here and let M2-2 handle the README's date-range suffix, or the first generator run will produce a diff.  

- [x] **M2-2** Write scripts/build_status.sh and add BEGIN/END generated markers around the three existing status tables in REVIEW_STATUS.md, README.md and teachers.html  
  `M` `[sonnet]` · after: `M2-1`  
  *Done when `bash scripts/build_status.sh && bash scripts/build_status.sh && git diff --exit-code` exits 0 on a clean checkout, i.e. the regenerated tables are byte-identical to the committed ones and the second run is a no-op.*  
  > Three different table shapes: REVIEW_STATUS.md is Ch/Title/Status/Reviewers/Notes markdown; README.md:62-78 is Chapter/Title/Status with a github.io link and a "✓ " prefix; teachers.html:194-220 is an HTML <table class="review-table"> with <span class="status-badge status-draft">. Match the em-dash/entity conventions of each file. Pure bash + python3/jq only — no build step exists in this repo.  

- [x] **M2-3** Add a generated reviewer section to contributors.html and emit it from scripts/build_status.sh  
  `S` `[sonnet]` · after: `M2-2`  
  *Done when `grep -c 'BEGIN GENERATED reviewers' contributors.html` returns 1 and `bash scripts/build_status.sh && git diff --exit-code` exits 0 with the section rendering a "No reviewers yet" placeholder while reviewers[] is empty everywhere.*  
  > contributors.html has no reviewer section today — it goes between "Project Creator" and "Special Thanks". Only reviewers who set consent-to-credit (M2-6) are ever listed, so the generator must key off that field, not merely off reviewers[] length.  

- [x] **M2-4** Add a status-drift job to .github/workflows/site-check.yml that re-runs build_status.sh and fails on any diff  
  `S` `[sonnet]` · after: `M2-2`, `M2-3`, `M0-6`  
  *Done when a PR that hand-edits one `0 / 3` cell in teachers.html shows the site-check status-drift job red, and the same PR goes green once the `bash scripts/build_status.sh` output is committed to it.*  
  > Blocked by the M0 DoD item that creates .github/workflows/site-check.yml on push-to-main + pull_request. Add a job to that file — do NOT create a second workflow, or M5's "exactly one workflow" finish line cannot be met. Keep the script POSIX/BSD-safe: the existing content-change-check.yml uses GNU-only `grep -oP`, which is a known trap here.  

- [x] **M2-5** Write the review-counting rule paragraph into REVIEW_STATUS.md, outside the generated markers  
  `S` `[fable]` · after: `M2-2`  
  *Done when `grep -c 'How Reviews Are Counted' REVIEW_STATUS.md` returns 1, that section names which of chapter-review.yml's three overall-assessment verdicts increment N/3, that a review pins to a chapter short SHA, that a substantive rewrite resets the count, and who adjudicates, and `bash scripts/build_status.sh && git diff --exit-code` still exits 0.*  
  > Must be written before the first review is recorded — that is the whole point of the DoD item. Place it below the generated table region so the generator cannot clobber it. The three existing verdicts are "Ready", "Needs revision", "Needs significant work" (chapter-review.yml, id: overall-assessment); decide explicitly whether "Needs significant work" counts toward 3/3. The maintainer's own classroom pilot never counts as a third (M9).  

- [x] **M2-6** Add consent-to-credit, display name, chapter version (short SHA), grade level and piloted-in-class fields to .github/ISSUE_TEMPLATE/chapter-review.yml  
  `S` `[sonnet]` · after: `M2-5`  
  *Done when `grep -cE 'id: (consent-to-credit|display-name|chapter-sha|grade-level|piloted-in-class)' .github/ISSUE_TEMPLATE/chapter-review.yml` returns 5 and a test issue opened from the template on GitHub renders all five fields.*  
  > Depends on M2-5 because the counting rule defines what "chapter version" means and therefore what the SHA field must ask for. Consent-to-credit should be a checkboxes field (opt-in, unchecked default) — contributors.html (M2-3) lists only reviewers who checked it. Do not disturb the existing `chapter` dropdown option strings; M2-7's labeler parses them.  

- [x] **M2-7**  Create the 15 review:chNN labels and add an issue-labeler job to site-check.yml that applies one from the chapter-review.yml dropdown  
  `M` `[sonnet]` · after: `M2-6`, `M0-6`  
  *Done when `gh label list --limit 100 | grep -c '^review:ch'` returns 15 and a test issue filed from chapter-review.yml with Chapter "6 — A New Nation" selected carries label `review:ch06` after the site-check labeler job runs.*  
  > This repo currently has only the nine GitHub default labels — the `review`, `chapter-feedback`, `feedback`, and `review-slot` labels named by the four existing issue templates do not exist, so GitHub is silently dropping them; create those too. The labeler must be an `on: issues` job inside site-check.yml, not a new workflow file (M5 requires exactly one). Zero-pad to review:ch06 so sorting matches the chapter order.  

- [~] **M2-8** *(teachers.html done; Google Form edit is manual)*  Remove the "Full Chapter Review" option from the Google Form and drop the form path from teachers.html's review instructions  
  `S` `[sonnet]` · after: `M2-6`  
  *Done when `grep -c 'Full Chapter Review\" in the feedback type' teachers.html` returns 0 and the live form at https://forms.gle/xzSs9fkXc9LEye3g9 offers no "Full Chapter Review" choice in its feedback-type question.*  
  > Only teachers.html:245 (step 3 of "How to Do a Full Chapter Review") sends reviewers to the form; the teachers.html:184 channel card titled "Full Chapter Review" already links to the GitHub template and should stay. The Google Form edit itself is a maintainer action outside the repo — it cannot be done by a script. Sequenced after M2-6 so the surviving path collects strictly more than the form did.  

- [x] **M2-9** Open 15 "Review slot" issues (one per chapter, labeled review-slot + review:chNN, claiming = commenting) and backfill their numbers into data/chapters.json  
  `M` `[sonnet]` · after: `M2-7`, `M2-5`, `M2-1`  
  *Done when `gh issue list --label review-slot --state open --limit 30 --json number | jq length` returns 15 and every review_slot_issue value in data/chapters.json matches one of those numbers.*  
  > GitHub caps pinned issues at 3 per repo, so "15 pinned Review slot issues" cannot be taken literally — pin one "Review slots" index issue and label the other fifteen, and confirm that reading with the maintainer. The repo has zero issues today, so these will be #1-#15. Each body should link the M2-5 counting rule and the chapter's primary-sources page, and state that commenting claims the slot.  

- [x] **M2-10** Emit a generated "claim a chapter" pointer on teachers.html aimed at the slot issue with the fewest reviewers  
  `S` `[sonnet]` · after: `M2-9`, `M2-2`  
  *Done when the generated pointer in teachers.html links the review_slot_issue of the lowest-reviewer-count chapter in data/chapters.json (verified by bumping one chapter's reviewers count, re-running, and seeing the link move), and `bash scripts/build_status.sh && git diff --exit-code` exits 0.*  
  > All 15 chapters sit at 0/3 today, so the tie-break rule must be explicit (lowest chapter number wins) or the output is nondeterministic and the M2-4 drift job will flap.  

- [x] **M2-11** Write TRIAGE.md: the review-intake loop in 10 steps or fewer, executable by an AI assistant from an issue URL alone  
  `M` `[fable]` · after: `M2-9`, `M2-6`, `M2-5`, `M2-2`  
  *Done when `grep -cE '^[0-9]+\.' TRIAGE.md` returns 10 or fewer and every step names a concrete file path or runnable command, including data/chapters.json, scripts/build_status.sh, and the gh command used to read the issue.*  
  > Written after the artifacts it references exist, otherwise the steps name files that are not there. Must cover: read issue → apply the M2-5 counting rule → edit data/chapters.json only → run build_status.sh → open PRs for factual-error items → reply and close. M9 walks this end-to-end on the first real review and corrects it.  

- [x] **M2-12** Correct CLAUDE.md's "Adding a chapter" step 6 to name data/chapters.json instead of three hand-edited status surfaces  
  `S` `[sonnet]` · after: `M2-2`  
  *Done when `grep -c 'Chapter status in \*\*three\*\* places' CLAUDE.md` returns 0 and step 6 of the "Adding a chapter" list names data/chapters.json and `bash scripts/build_status.sh`.*  
  > Required by ROADMAP.md's "Review cadence" rule (update CLAUDE.md when a milestone changes a fact it asserts) and by the DoD phrase "the only hand-edited source" — CLAUDE.md:177 currently instructs the opposite. CLAUDE.md is the only file with this instruction; MAINTENANCE.md and CONTRIBUTING.md do not mention status tables.  

- [x] **M2-13** Write docs/RECRUITMENT.md with three send-ready recruitment variants (email/listserv, social post, GitHub Discussions post)  
  `S` `[fable]` · after: `M2-9`, `M2-8`  
  *Done when docs/RECRUITMENT.md holds three clearly labeled variants, each containing a github.com/shiebenaderet/yawpms/issues/ review-slot URL, and `grep -c forms.gle docs/RECRUITMENT.md` returns 0.*  
  > There is no docs/ directory yet. The message must link slot issues (M2-9) and must not advertise the retired Google Form review path (M2-8). Be honest about the AI-drafted status, per the framing already on teachers.html — recruiting reviewers under a softer claim is exactly what this project's disclosure rules forbid.  

- [ ] **M2-14** Send the recruitment message through three existing channels and log each send in docs/RECRUITMENT.md  
  `S` `[sonnet]` · after: `M2-13`  
  *Done when docs/RECRUITMENT.md's "Sent" table has three rows, each carrying a date, the named channel, and a URL or message receipt.*  
  > Maintainer action — only GitHub Discussions (enabled on the repo) is a channel visible from inside the repo; the other two are the maintainer's own and must be named in the log rather than guessed. Last content task in M2 on purpose: intake form, labels, slots and the counting rule must all be live before anyone is invited.  

- [ ] **M2-15** Run the M2 verification sweep and tick M2's seven DoD boxes in ROADMAP.md with the proving command for each  
  `S` `[haiku]` · after: `M2-4`, `M2-10`, `M2-11`, `M2-12`, `M2-14`  
  *Done when `bash scripts/build_status.sh && git diff --exit-code` exits 0, `ls data/chapters.json scripts/build_status.sh TRIAGE.md docs/RECRUITMENT.md` succeeds, `gh issue list --label review-slot --state open --limit 30 --json number | jq length` returns 15, and all seven M2 checkboxes in ROADMAP.md are checked with the command that proved each recorded beside it.*  
  > Mechanical only — do not fix findings here; file them back as tasks. If the drift job (M2-4) is still blocked on M0's site-check.yml, record that DoD box as blocked rather than checked.  

<details><summary>Why this order</summary>

Three real ordering traps drive this sequence. (1) The generator must exist before any prose is written into the files it owns: build_status.sh rewrites regions of REVIEW_STATUS.md, README.md, teachers.html and contributors.html, so the counting-rule paragraph (M2-5) and the fewest-reviewers pointer (M2-10) are written after the BEGIN/END markers are in place — writing them first guarantees they are clobbered on the first run. (2) Everything that invites a review must come after everything that defines what a review is. The roadmap is explicit that the counting rule is "written before the first review is recorded", so M2-5 precedes the intake form change (M2-6), the labels/labeler (M2-7), the 15 slot issues (M2-9) and recruitment (M2-13/M2-14). Sending recruitment before the chapter-review.yml consent-to-credit field ships would produce reviews that legally cannot be credited in contributors.html and would have to be re-solicited; closing the Google Form path (M2-8) before the GitHub template collects consent + chapter version would push reviewers into a template that collects less than the form did. (3) The label must exist before the issues that carry it — GitHub silently drops labels that do not exist (this repo currently has only the nine default labels, so the templates' existing "review"/"chapter-feedback" labels are already being dropped), so M2-7 precedes M2-9, and M2-9 precedes M2-10 because the pointer needs real issue numbers backfilled into data/chapters.json. The CI drift job (M2-4) is the only task with a cross-milestone blocker: site-check.yml does not exist until M0 creates it, and adding a second workflow file here would violate M5's "exactly one workflow" finish line. The haiku sweep is last because every earlier artifact is one of its inputs.

</details>


## M3 — Every chapter is a door, and the front door tells the truth

- [x] **M3-1** Add `.chapter-banner` rules to `css/chapter.css` — one-line layout, link row, plus the matching `body.dark-mode` block  
  `S` `[sonnet]`  
  *Done when `grep -c '\.chapter-banner' css/chapter.css` returns at least 4 and `grep -cE 'body\.dark-mode[^{]*\.chapter-banner' css/chapter.css` returns at least 1.*  
  > Must land before M3-2 stamps 15 files. `.chapter-resources` shipped into 10 chapters with zero CSS rules (CLAUDE.md section 4) — do not repeat it. CLAUDE.md 2.4 makes the `body.dark-mode` counterpart mandatory for every new chapter.css rule. Container is capped at max-width 640px; the banner must stay on one line inside it.  

- [x] **M3-2** Extend `scripts/build_status.sh` to stamp the banner into all 15 `chN.html` between `<!-- BANNER:START -->` / `<!-- BANNER:END -->` markers  
  `M` `[sonnet]` · after: `M3-1`, `M2-2`, `M1-5`  
  *Done when `bash scripts/build_status.sh && bash scripts/build_status.sh && git diff --exit-code` exits 0 and `grep -l '<!-- BANNER:START -->' ch*.html | wc -l` prints 15.*  
  > Insert anchor is identical in all 15 files (verified): the `.title-page` closing `</div>` immediately followed by `<main id="main-content" class="container">`. Banner carries status + 'reviewed by N of 3 educators' + short SHA (`git log -1 --format=%h -- chN.html`, not the repo HEAD) + AI-assisted-draft disclosure + three links: Report an error (`issues/new?template=feedback.yml`), Review this chapter (`issues/new?template=chapter-review.yml`), Primary sources (`primary-sources/chN-sources.html` — chapters currently link there 0 times). One template, no per-file hand edits. Per CLAUDE.md style rules, emit `&mdash;` when writing ch6.html/ch7.html and a literal em dash elsewhere. Blocked by M1 because stamping before the ch6/ch7 restructure means redoing the insert and polluting M1's required structural-only diff.  

- [x] **M3-3** Add a `banner` job to `.github/workflows/site-check.yml` that regenerates, diffs, and asserts banner contents in every `ch*.html`  
  `S` `[sonnet]` · after: `M3-2`, `M0-6`  
  *Done when a branch that hand-edits one banner line in `ch3.html` makes the `banner` job in `.github/workflows/site-check.yml` fail, and the same job passes on unmodified `main`.*  
  > Two assertions: `bash scripts/build_status.sh` then `git diff --exit-code` (enforces 'no hand edits'), and a grep per chapter for 'of 3 educators', the AI-assisted-draft phrase, and all three link hrefs. Confirm M2's existing drift step actually includes `ch*.html` in its diff scope — if it only diffs the four status tables, chapters are the fourth unguarded surface. Use POSIX grep only; the existing `content-change-check.yml` uses GNU-only `grep -oP` and cannot run locally on macOS.  

- [x] **M3-4** Add a `backlinks` step to `site-check.yml` asserting each `primary-sources/chN-sources.html` links to `../chN.html`  
  `S` `[sonnet]` · after: `M0-6`  
  *Done when `for n in $(seq 1 15); do grep -q "href=\"../ch$n.html\"" primary-sources/ch$n-sources.html || echo MISSING $n; done` prints nothing and the identical loop runs as a failing step in `site-check.yml`.*  
  > Verified: all 15 files already carry 2 correct back-links each (the `.ps-nav` line and the footer line), so this DoD item is already satisfied in content — the deliverable is the guard that keeps it true, not a fix. Do not 'normalize' the two link texts; CLAUDE.md 2.2 warns against homogenizing primary-source link wording.  

- [x] **M3-5** Add a visible "For Teachers" block to `index.html` linking all 10 tool pages  
  `M` `[sonnet]`  
  *Done when `grep -oE 'href="(cornell-notes|current-events|differentiation|graphic-organizers|pacing-guide|quizzes|slideshows|standards|timeline|vocabulary-cards)\.html"' index.html | sort -u | wc -l` prints 10.*  
  > The 10 pages are exactly those linked from `teaching.html` but absent from `index.html` (verified by diffing their href sets). Layout gotcha: `index.html` sets `body { overflow: hidden }` and `.page { height: 100vh }`, so an appended block is clipped, not scrolled to — the DoD word is 'visible'. `index.html` links no stylesheet at all; its CSS is an inline `<style>` and `css/index.css` does not exist (README.md:164 is wrong).  

- [x] **M3-6** Create and commit `favicon.ico` and a 1200x630 `images/site/og-default.jpg`  
  `S` `[sonnet]`  
  *Done when `git ls-files favicon.ico images/site/og-default.jpg` lists both and `sips -g pixelWidth -g pixelHeight images/site/og-default.jpg` reports 1200 x 630.*  
  > The repo has no favicon or icon file of any kind today (verified) and `images/site/` holds only `westward-banner.jpg`. Must land before M3-7/M3-8 or every card renders imageless. Chapter pages can instead point `og:image` at their existing title-page background (e.g. `images/ch5/boston-massacre.jpg`) — all 15 exist and are already licensed in `IMAGES_AUDIT.md`. Do not confuse `images/ch8/erie-canal.jpg` (a live chapter title image) with `primary-sources/images/ch8-erie-canal.jpg` (the orphan M4 resolves).  

- [x] **M3-7** Add `meta description`, OG/Twitter card tags and the favicon link to all 33 root `*.html` files  
  `M` `[sonnet]` · after: `M3-6`  
  *Done when `for f in *.html; do grep -q 'name="description"' "$f" && grep -q 'og:image' "$f" && grep -q 'rel="icon"' "$f" || echo "$f"; done` prints nothing.*  
  > Verified greenfield: 0 of 48 files carry any of the three today. `og:url` and `og:image` must be absolute on `https://americanyawpms.com` (the CNAME); do not use the github.io host, which 301s. Per-chapter `og:title` should reuse the existing `<title>` text and `og:image` the chapter's own title-page background. Run `npx html-validate` on changed pages per CLAUDE.md before finishing.  

- [x] **M3-8** Add `meta description`, OG/Twitter card tags and the favicon link to the 15 `primary-sources/ch*-sources.html` files  
  `S` `[sonnet]` · after: `M3-6`  
  *Done when `for f in primary-sources/ch*-sources.html; do grep -q 'name="description"' "$f" && grep -q 'og:image' "$f" && grep -q 'rel="icon"' "$f" || echo "$f"; done` prints nothing and `grep -l 'rel="icon" href="favicon' primary-sources/*.html` returns nothing.*  
  > Split from M3-7 because these files sit one directory down — a relative `href="favicon.ico"` or `images/site/...` resolves to nothing here and fails silently while the 33 root files look fine (their existing links already use `../css/pages.css`). The second grep clause is the trap check. These files use `&mdash;` encoding per CLAUDE.md.  

- [~] **M3-9** *(needs the maintainer's account)*  Verify the unfurl: confirm a shared chapter URL renders a title/description/image card in Slack and Google Classroom  
  `S` `[haiku]` · after: `M3-7`, `M3-8`  
  *Done when `curl -s https://americanyawpms.com/ch5.html | grep -c 'og:'` returns at least 4 and screenshots of the `https://americanyawpms.com/ch5.html` unfurl in both Slack and Google Classroom are attached to the M3 tracking issue.*  
  > Requires the tags to be deployed to `main` — GitHub Pages serves the live domain and both crawlers fetch it, so this cannot be checked from the working tree. Slack caches unfurls per URL; use a fresh chapter or append a cache-busting query the first time.  

- [~] **M3-10** *(needs the maintainer's account)*  Open and pin a GitHub Discussion "Volume II: is there demand?" with the gating opening post  
  `S` `[fable]`  
  *Done when the Discussion is pinned in `shiebenaderet/yawpms` and its opening post states both that Volume II is not planned until chapters reach 3/3 and an explicit list of what a "yes" would require.*  
  > This is a public commitment statement, so it needs judgment about what the project can honestly promise — CLAUDE.md section 1 and README.md:80 both frame Volume II as conditional, and the roadmap's 'Deliberately not scheduled' section refuses to promise 3/3 at all. The post must not read as a soft yes. Existing Volume II copy to stay consistent with: `index.html:374`, `about.html:61`, `README.md:80`.  

- [x] **M3-11** Link the Volume II Discussion from the `.vol-placeholder` block in `index.html`  
  `S` `[sonnet]` · after: `M3-10`, `M3-5`  
  *Done when `grep -c 'github.com/shiebenaderet/yawpms/discussions/' index.html` returns at least 1 and the match sits inside the `div.volume` that contains `p.vol-placeholder`.*  
  > Needs the Discussion URL from M3-10, so it cannot go first. Sequenced after M3-5 only to serialize the two `index.html` edits. The target block is `index.html:371-375` (the 'Volume II: Since 1877' `div.volume`); the styling hook `.vol-placeholder` is defined in the inline `<style>` at index.html:194.  

- [~] **M3-12** *(needs the maintainer's account)*  Add a Volume II demand question to the Google Form at forms.gle/xzSs9fkXc9LEye3g9  
  `S` `[sonnet]` · after: `M3-10`, `M2-8`  
  *Done when opening https://forms.gle/xzSs9fkXc9LEye3g9 shows a "Would you use a Volume II (1877–present)?" question and one test submission for it appears in the linked response Sheet.*  
  > Same form that M2-4 edits to remove the 'Full Chapter Review' option — do both in one editing session so the form is touched once. The form is linked from `teachers.html:171` and `teachers.html:245`; the second link's surrounding text tells reviewers to note 'Full Chapter Review' there and will need updating when M2-4 lands. Question wording should match the Discussion's framing from M3-10.  

- [ ] **M3-13** Run the M3 verification sweep across all five DoD items and post results to the M3 tracking issue  
  `S` `[haiku]` · after: `M3-3`, `M3-4`, `M3-5`, `M3-9`, `M3-11`, `M3-12`  
  *Done when all five checks pass in one run — 15 files matching `BANNER:START`, 15 primary-source back-links, 10 tool-page hrefs in `index.html`, 0 files printed by the description+og:image+rel=icon loop over all 48 HTML files, and 1+ discussions URL in `index.html` — and the raw output is pasted into the M3 tracking issue.*  
  > Mechanical only — no judgment calls, no fixes. Count of 48 HTML files = 33 at repo root + 15 under `primary-sources/`; assert the count itself so a new unstamped page cannot slip past. If any check fails, file the gap against the owning task rather than patching it here.  

<details><summary>Why this order</summary>

Four independent tracks, serialized only where a later task would otherwise be redone.

Banner track (M3-1 → M3-2 → M3-3): CSS lands before the generator stamps 15 files, because shipping an unstyled banner into every chapter is exactly the `.chapter-resources` failure CLAUDE.md section 4 records (10 chapters, zero CSS rules). M3-2 depends on M2-1 as a hard blocker — `data/` does not exist in the repo today, so there is no `chapters.json` to read status from and no `build_status.sh` to extend. M3-2 also waits on M1's ch6/ch7 restructure: stamping a banner and then rewriting the surrounding markup means resolving the same insert twice, and the ch6/ch7 diff in M1 is required to be structural-only, which a banner insert would violate. The drift check (M3-3) must follow the stamping or it has nothing to guard and would go red on an empty baseline.

Meta/OG track (M3-6 → M3-7/M3-8 → M3-9): the OG image and favicon files must exist before 48 files point at them — tags referencing a 404 render a card with no image, which is the one thing this DoD item is for. Root and primary-sources files are separate tasks because they need different path depths (`../images/site/...`), and a path bug in the 15 nested files fails silently while the 33 root files look fine. The unfurl check (M3-9) is last and needs main to be deployed, because Slack and Google Classroom crawl the live domain, not the working tree.

Volume II track (M3-10 → M3-11): the Discussion has to exist before `index.html` can link its URL. M3-11 is also sequenced after M3-5 purely so the two `index.html` edits don't collide.

M3-4, M3-5, M3-6 and M3-10 have no blockers and can start on day one. M3-13 is last by construction — it re-checks all five DoD items after every other task has merged.

</details>


## M4 — Accuracy pass wave 1: ch5, ch6, ch7, ch8

**ch5 by Oct 15 · ch6 by Oct 31 · ch7 by Nov 15 · ch8 by Dec 20**

- [x] **M4-1** Write the chapter accuracy-audit method into MAINTENANCE.md and scaffold docs/ACCURACY_AUDIT.md  
  `S` `[fable]`  
  *Done when MAINTENANCE.md contains a `## Chapter Accuracy Audit` section naming the five claim types (date, proper name, statistic, direct quotation, causal claim) and the four verdicts (verified / corrected / caveated / could not verify), and docs/ACCURACY_AUDIT.md exists carrying the header row `| Claim | Type | Verdict | Yawp source | Independent source | PR |` plus a `### Chapter N` heading for each of 5, 6, 7, 8.*  
  > docs/ does not exist in this repo yet — mkdir docs; nothing in .gitignore blocks it. Write the method generic enough that M6 replays it on ch9-ch15 with no edits. Mirror the Primary Source Reader audit that produced the 61/61 verified ps-source-link invariant: every claim gets the corresponding American Yawp chapter plus one independent reference, not one source.  

- [x] **M4-2** Fill the Chapter 5 ledger in docs/ACCURACY_AUDIT.md against ch5.html (The American Revolution)  
  `L` `[fable]` · after: `M4-1`  
  *Done when the `### Chapter 5` table has one row per date, proper name, statistic, direct quotation and causal claim in ch5.html, zero rows with an empty Verdict cell, and every row naming both the American Yawp ch5 section and one independent reference.*  
  > Calendar-bound: ch5 by Oct 15. Do not batch with ch6-ch8 — the milestone's whole premise is that each chapter is checked the month before classrooms reach it. ch5.html also holds `.primary-source` boxes; those correctly carry no source link (CLAUDE.md 2.2) — audit their quoted text, do not add links.  

- [x] **M4-3** Merge a correction PR for every Chapter 5 `corrected` row, updating QUIZZES["5"], VOCAB["5"], SLIDES["5"] and ch:5 timeline entries in the same PR  
  `M` `[fable]` · after: `M4-2`, `M0-6`  
  *Done when every `corrected` row in the Chapter 5 ledger cites a merged PR number, and each of those PRs touches ch5.html plus every companion object repeating the corrected claim (`QUIZZES["5"]` in quizzes.html, `VOCAB["5"]` in vocabulary-cards.html, `SLIDES["5"]` in slideshows.html, `ch:5` entries in timeline.html), with site-check.yml green on the merge commit.*  
  > Blocked by M0-3 because 'site-check.yml green' is meaningless while CI is advisory and never fails. A correction that shifts a quiz `answer` index must also rewrite that question's `explain` string — the two drift silently otherwise.  

- [~] **M4-4** *(ch5 figures done; ch6-ch8 pending)*  Add an attribution clause and a `View original` link to all 42 figcaptions in ch5.html, ch6.html, ch7.html and ch8.html  
  `L` `[fable]` · after: `M4-1`  
  *Done when `grep -o 'View original' ch5.html ch6.html ch7.html ch8.html | wc -l` returns 42 and every `<figcaption>` in those four files contains a parenthetical attribution clause.*  
  > Ordering trap: this edits ch6.html and ch7.html, the same two files M1-2/M1-3 restructure wholesale by ~Nov 10, and ch6's own deadline is Oct 31 — land the ch6/ch7 figcaptions before M1-2/M1-3 open its branch, or rebase onto it. Mirror the ps-source-link wording but do NOT use the `ps-source-link` class here; it belongs to the 61 reader blocks. Source URLs come from scripts/download_ch5_images.sh through download_ch8_images.sh and scripts/download_all_maps.sh — curl-verify each, and match the file's em-dash encoding (`&mdash;` in ch6/ch7, literal — in ch5/ch8).  

- [x] **M4-5** Replace ch5-ch8 images whose provenance cannot be curl-verified and log every swap in IMAGES_AUDIT.md  
  `M` `[fable]` · after: `M4-4`, `M0-1`  
  *Done when no figure in ch5-ch8 references an image lacking a verified source URL, IMAGES_AUDIT.md has one row per swap giving old file, new file, reason and license, and `bash scripts/audit_images.sh` reports 0 missing refs.*  
  > Depends on M0-1: the unfixed audit_images.sh reports zero missing while 16 refs are broken, so its 0 is not evidence. Each replacement also needs its entry updated in scripts/download_chN_images.sh (or download_all_maps.sh for the map figures). The roadmap explicitly does not promise zero unknowns across all 124 images — replace only what ch5-ch8 actually shows.  

- [x] **M4-6** Add an in-page sourcing caveat to Source 9.3 (Burnett Trail of Tears memoir) in primary-sources/ch9-sources.html  
  `S` `[fable]`  
  *Done when the `#source-9-3` block contains a caveat naming both the 52-year gap (1838 events, written 1890) and the contested authenticity of the memoir, framed as a source-reliability exercise, and `grep -c 'ps-source-link' primary-sources/ch9-sources.html` still returns 4.*  
  > ch9 sits outside M4's ch5-ch8 range on purpose — closed here so a reviewer does not re-find it. Use the already-styled but unused `.ps-excerpt-note` hook (css/primary-sources.css:158) or extend the existing `.ps-context` block; do not invent a new ps- class. The block's existing sourcing question already asks why Burnett waited 52 years, so the caveat must add the authenticity dispute rather than restate the gap.  

- [x] **M4-7** Place the 1769 Charleston slave-importation broadside (primary-sources/images/ch11-slave-broadside.jpg) as a new source in primary-sources/ch4-sources.html or ch3-sources.html  
  `M` `[fable]`  
  *Done when the chosen file has 5 `ps-source` blocks and 5 `ps-source-link` paragraphs with the new block also listed in its `.ps-source-nav`, the image renamed to the flat chN-<slug> convention, the 'Unused, kept for reference' comment removed from scripts/download_primary_source_images.sh, and CLAUDE.md section 2.2's source count updated from 61 to 62 — or an open issue records the decision to decline.*  
  > The file is committed but referenced by no page; its ch11- prefix is misleading and the manifest itself already flags it as a ch3/ch4 candidate (scripts/download_primary_source_images.sh lines 57-58). ch11-sources.html Source 11.3 uses the separate 1852 DeSaussure broadside — do not touch that one. Fetch Commons extmetadata for `Slave_Auction_Ad.jpg` and confirm it really is the 1769 importation broadside before writing alt text or caption (CLAUDE.md 2.1); ch4 'Colonial Society' is the likelier home given Source 4.1 is the 1705 Virginia Slave Code.  

- [x] **M4-8** Resolve the primary-sources/images/ch8-erie-canal.jpg orphan (16 image files against 15 manifest entries)  
  `S` `[sonnet]`  
  *Done when `ls primary-sources/images | wc -l` equals the count of `["…"]=` entries in scripts/download_primary_source_images.sh, either because the orphan was git rm'd or because it is now referenced by a primary-sources/*.html page and has its own manifest entry with artist/date/collection/license.*  
  > ch8-sources.html Source 8.4 already uses ch8-erie-canal-1831.jpg, so the orphan is a duplicate rather than a gap — deletion is the likely answer. Do not confuse it with images/ch8/erie-canal.jpg, which ch8.html (title-page background and a figure), timeline.html and slideshows.html all reference and which must stay.  

- [ ] **M4-9** Fill the Chapter 6 ledger in docs/ACCURACY_AUDIT.md against ch6.html (A New Nation)  
  `L` `[fable]` · after: `M4-1`  
  *Done when the `### Chapter 6` table has one row per date, proper name, statistic, direct quotation and causal claim in ch6.html, zero rows with an empty Verdict cell, and every row naming both the American Yawp ch6 section and one independent reference.*  
  > ch6 by Oct 31, and ch6 is the largest chapter (53KB). It has zero `<section>` elements until M1-1 lands, so cite each claim by its `<h2>` heading text rather than a section id — id-based anchors written now would break when M1 moves ids onto `<section>`.  

- [ ] **M4-10** Merge a correction PR for every Chapter 6 `corrected` row, updating QUIZZES["6"], VOCAB["6"], SLIDES["6"] and ch:6 timeline entries in the same PR  
  `M` `[fable]` · after: `M4-9`, `M0-6`  
  *Done when every `corrected` row in the Chapter 6 ledger cites a merged PR number, and each of those PRs touches ch6.html plus every companion object repeating the corrected claim (`QUIZZES["6"]`, `VOCAB["6"]`, `SLIDES["6"]`, `ch:6` timeline.html entries), with site-check.yml green on the merge commit.*  
  > Merge these before M1-2/M1-3 open its ch6 restructure branch. ch6.html uses `&mdash;` and carries the four CSS-less classes (body-text, section-heading, subtitle, attribution-footer) — a correction PR fixes text only and must not blind-fix those; that removal is M1-2's job.  

- [ ] **M4-11** Fill the Chapter 7 ledger in docs/ACCURACY_AUDIT.md against ch7.html (The Early Republic)  
  `L` `[fable]` · after: `M4-1`  
  *Done when the `### Chapter 7` table has one row per date, proper name, statistic, direct quotation and causal claim in ch7.html, zero rows with an empty Verdict cell, and every row naming both the American Yawp ch7 section and one independent reference.*  
  > ch7 by Nov 15, which straddles M1's ~Nov 10 restructure deadline. ch7 carries 19 figures — the most of any chapter in this wave — so its ledger and M4-4's figcaption work overlap heavily; do the image provenance once. Same `<h2>`-not-id citation rule as ch6.  

- [ ] **M4-12** Merge a correction PR for every Chapter 7 `corrected` row, updating QUIZZES["7"], VOCAB["7"], SLIDES["7"] and ch:7 timeline entries in the same PR  
  `M` `[fable]` · after: `M4-11`, `M0-6`  
  *Done when every `corrected` row in the Chapter 7 ledger cites a merged PR number, and each of those PRs touches ch7.html plus every companion object repeating the corrected claim (`QUIZZES["7"]`, `VOCAB["7"]`, `SLIDES["7"]`, `ch:7` timeline.html entries), with site-check.yml green on the merge commit.*  
  > Sequence against M1-1: merge these either fully before the ch7 restructure branch opens or fully after it lands, never across it — both diffs rewrite large regions of the same 49KB file.  

- [ ] **M4-13** Fill the Chapter 8 ledger in docs/ACCURACY_AUDIT.md against ch8.html (The Market Revolution)  
  `L` `[fable]` · after: `M4-1`  
  *Done when the `### Chapter 8` table has one row per date, proper name, statistic, direct quotation and causal claim in ch8.html, zero rows with an empty Verdict cell, and every row naming both the American Yawp ch8 section and one independent reference.*  
  > ch8 by Dec 20. Smallest chapter in the wave (27KB, 6 figures) but statistic-dense — the '30,000 miles of railroad track, more than the rest of the world combined' and the 60,000-to-N New York population figures in its figcaptions are exactly the kind of claim this ledger exists to check. ch8's quiz has only 7 questions and its vocab deck only 6 terms; flag, do not expand — expansion is explicitly out of scope.  

- [ ] **M4-14** Merge a correction PR for every Chapter 8 `corrected` row, updating QUIZZES["8"], VOCAB["8"], SLIDES["8"] and ch:8 timeline entries in the same PR  
  `M` `[fable]` · after: `M4-13`, `M0-6`  
  *Done when every `corrected` row in the Chapter 8 ledger cites a merged PR number, and each of those PRs touches ch8.html plus every companion object repeating the corrected claim (`QUIZZES["8"]`, `VOCAB["8"]`, `SLIDES["8"]`, `ch:8` timeline.html entries), with site-check.yml green on the merge commit.*  
  > The ch:8 Erie Canal timeline entry and the ch8 Erie Canal slideshow caption both restate the 363-mile figure that ch8.html's map figcaption carries — a correction to one must move all three.  

- [ ] **M4-15** File one `could not verify` issue per chapter for ch5-ch8 and link each from that chapter's pinned Review slot issue  
  `S` `[sonnet]` · after: `M4-2`, `M4-9`, `M4-11`, `M4-13`, `M2-9`  
  *Done when exactly four open issues exist, one naming each of chapters 5-8, each listing that chapter's `could not verify` ledger rows verbatim, and each linked by a comment on the matching pinned Review slot issue.*  
  > Cross-milestone: blocked by M2-5's 15 pinned Review slot issues — without them there is nothing to link from. One issue per chapter, never one per row: the point is that a volunteer confirms a short list instead of discovering the same items from scratch.  

- [x] **M4-16** Add the fact-check line to the generated chapter banner via data/chapters.json and scripts/build_status.sh  
  `M` `[sonnet]` · after: `M4-3`, `M4-10`, `M4-12`, `M4-14`, `M3-2`  
  *Done when data/chapters.json carries a fact-check date for chapters 5-8, `bash scripts/build_status.sh` stamps "AI-assisted fact check completed <date>; not yet reviewed by a historian" into exactly ch5.html, ch6.html, ch7.html and ch8.html and into no other chapter, and a second run of the script produces no diff.*  
  > Real cross-milestone dependency that the milestone map's 'M4 blocked by —' line hides: the banner is generated by M3-1's build_status.sh from data/chapters.json, so this item cannot ship before M3-1 exists. Never hand-stamp the line into a chapter — that creates the fourth status surface M2/M3 exist to eliminate. Wording is fixed by the roadmap so it cannot be misread as human review; do not paraphrase it.  

- [ ] **M4-17** Run the mechanical verification sweep closing M4  
  `S` `[haiku]` · after: `M4-3`, `M4-5`, `M4-6`, `M4-7`, `M4-8`, `M4-10`, `M4-12`, `M4-14`, `M4-15`, `M4-16`  
  *Done when one run reports all of: 42 `View original` occurrences across ch5-ch8, zero empty Verdict cells in the ch5-ch8 ledgers of docs/ACCURACY_AUDIT.md, ps-source block count equal to ps-source-link count in all 15 primary-sources/*.html files, `bash scripts/audit_images.sh` 0 missing refs, `bash scripts/build_status.sh` a no-op on a second run, and site-check.yml green on main.*  
  > Purely mechanical — no historical judgment. The ps-source/ps-source-link equality check must account for M4-7 raising the total from 61 to 62 (or leaving it at 61 if the broadside was declined); read the count from CLAUDE.md 2.2 rather than hard-coding 61.  

<details><summary>Why this order</summary>

The method comes first (M4-1) because every later ledger row must use the same columns and the same four verdicts — M6 replays this format on ch9–ch15, and a ch5 ledger improvised before the method is written would have to be re-cut. Each chapter is then a ledger-then-corrections pair, never one task: a completed ledger with unmerged correction PRs is a real and common half-state, and the roadmap tracks them as separate checkboxes. Corrections depend on M0-3 because the DoD requires the PR to be green under site-check.yml, and a workflow that cannot fail cannot be green in any meaningful sense. The chapter waves run in calendar order (ch5 Oct 15, ch6 Oct 31, ch7 Nov 15, ch8 Dec 20) rather than in size order, because the whole point of this milestone is that a chapter is fixed the month before classrooms open it. The figcaption pass (M4-4) sits early, not after ch8, for a sequencing reason the milestone map hides: it edits ch6.html and ch7.html, the same two files M1-1 restructures wholesale by ~Nov 10, and ch6's own M4 deadline is Oct 31. Done late, it collides with the restructure branch; done early, it merges clean and M1's byte-identical-text check simply carries the new figcaption text through. Image replacement (M4-5) follows the figcaption pass because you only learn which images are unprovable by trying to source all 42, and it depends on M0-1 because `audit_images.sh` reports zero missing while 16 refs are broken — "0 missing" is not evidence until the instrument is fixed. The three editorial one-offs (M4-6, M4-7, M4-8) have no dependencies and are placed early so they are not stranded behind the December ch8 wave; they are in this milestone at all only because a reviewer would otherwise re-find them. The two tail tasks are genuinely blocked across milestones: the could-not-verify issues (M4-15) need M2-5's pinned Review slots to link from, and the fact-check banner (M4-16) needs M3-1's generator, because the banner is generated from data/chapters.json and hand-stamping it would create the fourth status surface M3 exists to prevent. Verification (M4-17) is last and mechanical.

</details>


# Q1 2027


## M5 — Companion finish and CI consolidation

- [ ] **M5-1** Read ?ch=N via URLSearchParams in quizzes.html and slideshows.html, selecting that chapter on load  
  `S` `[sonnet]`  
  *Done when quizzes.html?ch=7 and slideshows.html?ch=7 open the Ch. 7 quiz/deck with #ch-select showing 7, ?ch=99 and ?ch=abc show the existing "Select a chapter" empty state, and `grep -c URLSearchParams quizzes.html slideshows.html` returns 1 for each file.*  
  > Both pages already have the fallback: loadQuiz (quizzes.html:407) and loadSlides (slideshows.html:641) both open with `if (!ch || !SLIDES[ch]) { ...empty state...; return; }`, so the new code only has to set `sel.value` and call the loader with the raw param. Put the helper inline in each page's existing <script> right after the "Build select" loop (quizzes.html:396) — no new js/ file and no second CDN dependency (CLAUDE.md section 4).  

- [ ] **M5-2** Read ?ch=N in vocabulary-cards.html, validating against VOCAB before calling loadChapter  
  `S` `[sonnet]`  
  *Done when vocabulary-cards.html?ch=4 opens on a Ch. 4 card with #ch-select showing 4, ?ch=0 and ?ch=xx still load "All Chapters" with no console error, and `grep -c URLSearchParams vocabulary-cards.html` returns 1.*  
  > Unlike quizzes/slideshows, loadChapter (vocabulary-cards.html:585) has NO guard — its else branch does `VOCAB[ch].terms.forEach(...)` and throws a TypeError on an unknown key, blanking the page. The param must be checked with `VOCAB[ch]` (or `ch === 'all'`) before the call. Init is `buildChapterSelect(); loadChapter('all');` at the end of the file; the change goes there, and buildChapterSelect attaches the change listener via addEventListener rather than an inline onchange.  

- [ ] **M5-3** Read ?ch=N in timeline.html to preset #tl-chapter before buildTimeline() runs  
  `S` `[sonnet]`  
  *Done when timeline.html?ch=14 renders only Ch. 14 events with #tl-chapter showing 14 and #tl-filter still "All Events", ?ch=16 renders all events (not zero), and `grep -c URLSearchParams timeline.html` returns 1.*  
  > timeline.html uses #tl-chapter (line 305), not #ch-select, and filterTimeline (line 448) string-compares the value against each event's data-ch attribute — an out-of-range value matches nothing and silently shows "Showing 0 of N events" instead of falling back, so validate the param against the option list before assigning. Set the value before the trailing `buildTimeline();` call and leave the separate category filter #tl-filter at "all".  

- [ ] **M5-4** Add the .chapter-resources block to ch1, ch3, ch8, ch14 and ch15, copying the ch5.html template  
  `S` `[sonnet]` · after: `M5-1`, `M5-2`, `M0-10`  
  *Done when `grep -l 'class="chapter-resources"' ch*.html | wc -l` prints 15 and each new block's vocabulary-cards/quizzes/slideshows links carry that file's own chapter number (ch1 -> ?ch=1, ch3 -> ?ch=3, ch8 -> ?ch=8, ch14 -> ?ch=14, ch15 -> ?ch=15).*  
  > Template is ch5.html:336-346 — h3 "Chapter N Resources", intro <p>, then .resource-links with five anchors (three ?ch=N plus cornell-notes.html and graphic-organizers.html, both un-parameterized). Insert immediately before <footer>: ch1.html:396, ch3.html:304, ch8.html:258, ch14.html:337, ch15.html:355. Blocked until M5-1/M5-2 ship because CLAUDE.md section 4 says do not propagate this block while the ?ch=N links are inert, and until M0 supplies the .chapter-resources / .resource-links CSS, which today has zero rules in css/.  

- [ ] **M5-5** Fold content-change-check.yml into site-check.yml and git rm it, leaving exactly one workflow  
  `M` `[sonnet]` · after: `M0-6`, `M0-7`, `M0-8`, `M1-11`, `M1-12`, `M1-13`  
  *Done when `ls .github/workflows/*.yml | wc -l` prints 1 (site-check.yml only), `git log --diff-filter=D --name-only -1 -- .github/workflows/content-change-check.yml` shows the deletion, and `grep -c 'grep -[oq]P' .github/workflows/site-check.yml` returns 0.*  
  > Carry over all four steps (changed-chapter detection, companion-update detection, the github-script comment step with its find-existing-comment dedupe, and `permissions: pull-requests: write`) as an additional job in site-check.yml, gated on `if: github.event_name == 'pull_request'` so the push-to-main trigger M0 added does not try to comment. Replace the GNU-only `grep -oP 'ch\d+'` and `grep -qP '^ch\d+\.html$'` with POSIX ERE (`grep -oE` / `grep -qE`) so the same logic is reusable by scripts/check_all.sh on macOS. Do not disturb M0's image-ref, monthly link-check and html-validate jobs or M1's section-count, index-freshness and companion-sync checks.  

- [ ] **M5-6** Expand the advisory comment in site-check.yml to cover all 11 downstream-impact items  
  `M` `[sonnet]` · after: `M5-5`  
  *Done when the comment step's item list in .github/workflows/site-check.yml contains one entry for each of the 11 bullets in .github/pull_request_template.md lines 17-27 (vocabulary cards, quizzes, slideshows, primary sources, pacing guide, standards, timeline, graphic organizers, cornell notes, search index, N/A) — `grep -c 'items.push' site-check.yml` returns 11 or the equivalent array literal has 11 elements.*  
  > Today the comment checks only 4 of the 11 (vocabulary-cards.html, quizzes.html, slideshows.html, js/search-index.json). The seven added items map to real files: primary-sources/chN-sources.html, pacing-guide.html, standards.html, timeline.html, graphic-organizers.html, cornell-notes.html, plus the N/A escape. Detect each by path in the same `git diff --name-only` output the existing step already computes; do not add a new checkout or diff step.  

- [ ] **M5-7** Mark each of the 11 pull_request_template.md downstream items "automated" or "manual" to match the CI comment  
  `S` `[sonnet]` · after: `M5-6`  
  *Done when every bullet in .github/pull_request_template.md lines 17-27 ends with `(automated)` or `(manual)`, and every bullet marked `(automated)` has a matching entry in site-check.yml's comment item list (diffing the two extracted lists produces no output).*  
  > "Automated" means CI can see the file changed and will say so in the advisory comment; it does not mean CI verifies the content is correct — word the template's intro sentence (line 15) so a contributor cannot read "automated" as "already checked for me". Annotate only the Downstream impact checklist; the Images (lines 31-34) and Testing (lines 38-40) sections are outside this DoD item.  

- [ ] **M5-8** Open one deliberate breaking PR, observe site-check.yml fail and comment, then close it unmerged  
  `S` `[sonnet]` · after: `M5-5`, `M5-6`, `M5-7`  
  *Done when a closed, unmerged PR exists whose site-check.yml run conclusion is `failure` and which carries the advisory comment listing the un-updated companion resources, with the run URL pasted into the PR description before closing.*  
  > One PR must trip both behaviors at once: point an existing <img src> in a chapter at a nonexistent file (fails M0's image-ref check) and edit that chapter's visible text without touching vocabulary-cards.html / quizzes.html / slideshows.html / js/search-index.json (triggers the advisory comment's "Not updated in this PR" list). Branch, never push to main. Close without merging — the broken ref must not reach main, where M0's push trigger would turn the default branch red.  

- [ ] **M5-9** Write scripts/check_all.sh running every site-check.yml check locally, macOS-safe  
  `M` `[sonnet]` · after: `M5-5`  
  *Done when `bash scripts/check_all.sh` exits 0 on a clean checkout of main, exits non-zero when any single site-check.yml check is deliberately broken, and contains no GNU-only flags (`grep -c -- '-[a-zA-Z]*P' scripts/check_all.sh` returns 0).*  
  > Must stay in step with the consolidated workflow: run scripts/audit_images.sh (M0), scripts/check_companion_sync.sh (M1), the section-count/banned-class check (M1), `bash scripts/build_search_index.sh && git diff --exit-code js/search-index.json` (M1), and `npx html-validate` on changed ch*.html and primary-sources/*.html (M0). Skip the monthly link-check job — it is network-bound and scheduled, not a pre-commit gate. There is no test runner, linter config or package.json in this repo, so this is plain bash; run it from the repo root with absolute-safe paths.  

- [ ] **M5-10** Document `bash scripts/check_all.sh` in CONTRIBUTING.md as the local pre-commit step  
  `S` `[sonnet]` · after: `M5-9`  
  *Done when `grep -n 'bash scripts/check_all.sh' CONTRIBUTING.md` matches at least once inside the "## Running the Project Locally" section (currently line 97) and names it as the step to run before pushing.*  
  > That section currently has no verification step at all. Do not re-fix the two stale claims sitting next to it — "Download images (they're not stored in the repo)" (line 105) and "Open any chapter in your browser" (line 109) — the first is M0's doc-correction item and the second is the file:// trap CLAUDE.md section 3 covers; if M0 has already landed, just leave them as they stand.  

- [ ] **M5-11** Verify the M5 exit state mechanically and record the results in the M5 checklist  
  `S` `[haiku]` · after: `M5-1`, `M5-2`, `M5-3`, `M5-4`, `M5-5`, `M5-6`, `M5-7`, `M5-8`, `M5-9`, `M5-10`  
  *Done when one pass records: `ls .github/workflows/*.yml | wc -l` prints 1, `grep -l 'class="chapter-resources"' ch*.html | wc -l` prints 15, `grep -c URLSearchParams quizzes.html vocabulary-cards.html slideshows.html timeline.html` returns 1 for each, `bash scripts/check_all.sh` exits 0, and all four pages load correctly at ?ch=8 and fall back at ?ch=99.*  
  > Serve over HTTP for the browser half — `python3 -m http.server 8000`, never `open quizzes.html`; file:// blocks the XMLHttpRequest in js/search.js with no error path and every page loads that script. Report findings, do not fix: any failure goes back to the owning task rather than being patched here.  

<details><summary>Why this order</summary>

Four hard ordering constraints. (1) The `?ch=N` handling (M5-1, M5-2) must land BEFORE ch1/ch3/ch8/ch14/ch15 gain the `.chapter-resources` block (M5-4): the block ships three `?ch=` links per chapter, and CLAUDE.md section 4 explicitly forbids propagating it to the remaining 5 chapters while those links are inert. Doing M5-4 first ships 15 more dead links and a block with no CSS. M5-4 also waits on M0's `.chapter-resources` CSS for the same reason. (2) The fold (M5-5) must come BEFORE the advisory-comment expansion (M5-6): expanding the item list inside `content-change-check.yml` and then folding it into `site-check.yml` re-does the same edit twice, and the fold is a file move that would conflict with it. (3) The PR-template annotation (M5-7) comes after M5-6 because "automated" is only true of items the consolidated comment actually emits — annotating first would label items the CI does not yet check. (4) The deliberate breaking PR (M5-8) is the observation step for M5-5/M5-6/M5-7 and must run against the final single workflow; run before the fold it would only prove the old advisory workflow still behaves. `scripts/check_all.sh` (M5-9) mirrors whatever `site-check.yml` runs, so it is written after the fold settles that list and after M1 has added `check_companion_sync.sh`; CONTRIBUTING.md (M5-10) cannot honestly document a script that does not exist. M5-1, M5-2 and M5-3 are independent of each other and of M0/M1 — they touch three different pages with three different init paths — so they can run in parallel in week one of the milestone.

</details>


## M6 — Accuracy pass wave 2: ch9–ch15

**ch9 by Jan 15 · ch10–11 by Feb 10 · ch12–15 by Mar 15**

- [ ] **M6-1** Write the ch9 (Democracy in America) accuracy ledger into docs/ACCURACY_AUDIT.md using the M4 method in MAINTENANCE.md  
  `L` `[fable]` · after: `M4-1`  
  *Done when docs/ACCURACY_AUDIT.md has a Chapter 9 section covering every date, proper name, statistic, direct quotation and causal claim in ch9.html, and an awk pass over that section reports 0 rows with an empty verdict cell (verified/corrected/caveated/could not verify) and 0 rows citing fewer than two sources (American Yawp ch9 plus one independent reference).*  
  > Hard deadline Jan 15. Do NOT re-audit source 9.3 (Burnett Trail of Tears memoir) — its sourcing caveat is an M4 deliverable in primary-sources/ch9-sources.html; this ledger covers ch9.html only. ch9.html uses '--' rather than literal em dashes in body text; match the file you are editing.  

- [ ] **M6-2** Open and merge the ch9 corrections PR, updating QUIZZES['9'], VOCAB['9'], SLIDES['9'] and the 3 ch:9 timeline.html entries in the same PR  
  `M` `[sonnet]` · after: `M6-1`  
  *Done when the ch9 corrections PR is merged with site-check.yml green and `git show --stat` on the merge lists ch9.html plus every companion file (quizzes.html, vocabulary-cards.html, slideshows.html, timeline.html) that any ch9 ledger row marked 'corrected' touches, with zero 'corrected' rows unapplied.*  
  > Any chapter text change requires `bash scripts/build_search_index.sh` in the same PR or M1's index-freshness check fails. If a correction changes a .vocab-box term, M1's scripts/check_companion_sync.sh fails until VOCAB['9'] matches.  

- [ ] **M6-3** File the single ch9 'could not verify' issue and link it from the ch9 Review slot issue  
  `S` `[sonnet]` · after: `M6-1`, `M6-2`, `M2-9`  
  *Done when exactly one open GitHub issue lists every ch9 ledger row marked 'could not verify', the ch9 Review slot issue links to it, and every such ledger row in docs/ACCURACY_AUDIT.md carries that issue URL in its notes cell.*  
  > Gated on the corrections PR so a question the correction pass already answered is not handed to a volunteer as open. One issue per chapter, not one per row — the point is that a reviewer confirms a short list.  

- [ ] **M6-4** Add attribution clauses and 'View original' links to all 6 figcaptions in ch9.html  
  `M` `[fable]` · after: `M6-2`  
  *Done when `grep -c 'View original' ch9.html` returns 6, every <figcaption> in ch9.html ends with a parenthetical attribution clause, and any image whose provenance could not be confirmed is swapped with the swap logged as a row in IMAGES_AUDIT.md.*  
  > CLAUDE.md 2.1 binds: look at the actual image and fetch Wikimedia extmetadata for artist/date/license — never write attribution from a filename. The Robert Lindneux 1942 Trail of Tears painting is a modern depiction of an 1838 event and its caption must say so. This is the figcaption pattern, NOT ps-source-link; do not add source links to the 3 in-chapter .primary-source boxes.  

- [ ] **M6-5** Review ch9's 1 'Whose Voices Were Left Out' and 2 'Multiple Perspectives' callouts against current scholarly consensus  
  `M` `[fable]` · after: `M6-2`  
  *Done when docs/ACCURACY_AUDIT.md has a ch9 callout-review subsection with one row per callout (voices-left-out on Cherokee women and children; perspectives on Andrew Jackson; perspectives on the Bank War), each marked unchanged or changed with the scholarly source consulted, and any changed text merged in a green PR.*  
  > Second M6 DoD bullet — applies to ch9, ch11, ch13, ch14, ch15 only, not ch10 or ch12. Changes must be logged, not just made.  

- [ ] **M6-6** Write the ch10 (Religion and Reform) accuracy ledger into docs/ACCURACY_AUDIT.md  
  `L` `[fable]` · after: `M4-1`  
  *Done when docs/ACCURACY_AUDIT.md has a Chapter 10 section covering every date, proper name, statistic, direct quotation and causal claim in ch10.html, with 0 rows carrying an empty verdict cell and 0 rows citing fewer than two sources.*  
  > Deadline Feb 10 with ch11. Independent of the ch9 ledger — it is sequenced after only by the pacing calendar, so it can start early if ch9 stalls.  

- [ ] **M6-7** Open and merge the ch10 corrections PR, updating QUIZZES['10'], VOCAB['10'], SLIDES['10'] and the 2 ch:10 timeline.html entries in the same PR  
  `M` `[sonnet]` · after: `M6-6`  
  *Done when the ch10 corrections PR is merged with site-check.yml green and `git show --stat` on the merge lists ch10.html plus every companion file any ch10 'corrected' ledger row touches, with zero 'corrected' rows unapplied.*  
  > Same rebuild-and-sync rules as M6-2: build_search_index.sh in the PR, check_companion_sync.sh green on VOCAB['10'].  

- [ ] **M6-8** Write the ch11 (The Cotton Revolution) accuracy ledger into docs/ACCURACY_AUDIT.md  
  `L` `[fable]` · after: `M4-1`  
  *Done when docs/ACCURACY_AUDIT.md has a Chapter 11 section covering every date, proper name, statistic, direct quotation and causal claim in ch11.html, with 0 rows carrying an empty verdict cell and 0 rows citing fewer than two sources.*  
  > Deadline Feb 10. Enslavement statistics carry the highest correction risk in this chapter; each needs the independent reference named in the row, not just the American Yawp figure.  

- [ ] **M6-9** Open and merge the ch11 corrections PR, updating QUIZZES['11'], VOCAB['11'], SLIDES['11'] and the 1 ch:11 timeline.html entry in the same PR  
  `M` `[sonnet]` · after: `M6-8`  
  *Done when the ch11 corrections PR is merged with site-check.yml green and `git show --stat` on the merge lists ch11.html plus every companion file any ch11 'corrected' ledger row touches, with zero 'corrected' rows unapplied.*  
  > ch11 has only one timeline entry, so a corrected date there is easy to miss; check `grep 'ch:11' timeline.html` explicitly rather than assuming no timeline impact.  

- [ ] **M6-10** File the ch10 and ch11 'could not verify' issues and link each from its Review slot issue  
  `S` `[sonnet]` · after: `M6-7`, `M6-9`, `M2-9`  
  *Done when exactly two open GitHub issues exist (one for ch10, one for ch11), each listing that chapter's 'could not verify' ledger rows, each linked from that chapter's Review slot issue, and every such ledger row carries its issue URL in the notes cell.*  
  > One issue per chapter even though the two chapters are audited in the same wave — a reviewer claims a chapter, not a wave.  

- [ ] **M6-11** Add attribution clauses and 'View original' links to the 7 figcaptions in ch10.html and 5 in ch11.html  
  `M` `[fable]` · after: `M6-7`, `M6-9`  
  *Done when `grep -c 'View original' ch10.html` returns 7 and `grep -c 'View original' ch11.html` returns 5, every <figcaption> in both files ends with a parenthetical attribution clause, and each unprovable image swap is logged in IMAGES_AUDIT.md.*  
  > ch11-slave-broadside.jpg belongs to M4 (it is placed in ch3- or ch4-sources), not here — do not pull it into ch11.html. No zero-unknown promise: an image that cannot be provenanced is replaced and logged, not left with an invented attribution.  

- [ ] **M6-12** Review ch11's 'Whose Voices Were Left Out' and 'Multiple Perspectives' callouts against current scholarly consensus  
  `S` `[fable]` · after: `M6-9`  
  *Done when docs/ACCURACY_AUDIT.md has a ch11 callout-review subsection with one row for each of the 2 callouts in ch11.html, each marked unchanged or changed with the scholarly source consulted, and any changed text merged in a green PR.*  
  > ch10 and ch12 are deliberately out of scope for this DoD bullet; do not add callout-review rows for them.  

- [ ] **M6-13** Write the ch12 (Manifest Destiny) accuracy ledger into docs/ACCURACY_AUDIT.md  
  `L` `[fable]` · after: `M4-1`  
  *Done when docs/ACCURACY_AUDIT.md has a Chapter 12 section covering every date, proper name, statistic, direct quotation and causal claim in ch12.html, with 0 rows carrying an empty verdict cell and 0 rows citing fewer than two sources.*  
  > Deadline Mar 15 with ch13–ch15. ch12 also has a 7-question quiz — record that as a flag for M6-24, do not expand it here.  

- [ ] **M6-14** Open and merge the ch12 corrections PR, updating QUIZZES['12'], VOCAB['12'], SLIDES['12'] and the 3 ch:12 timeline.html entries in the same PR  
  `M` `[sonnet]` · after: `M6-13`  
  *Done when the ch12 corrections PR is merged with site-check.yml green and `git show --stat` on the merge lists ch12.html plus every companion file any ch12 'corrected' ledger row touches, with zero 'corrected' rows unapplied.*  
  > Correcting a quiz answer in QUIZZES['12'] is in scope; adding an eighth question is not.  

- [ ] **M6-15** Write the ch13 (The Sectional Crisis) accuracy ledger into docs/ACCURACY_AUDIT.md  
  `L` `[fable]` · after: `M4-1`  
  *Done when docs/ACCURACY_AUDIT.md has a Chapter 13 section covering every date, proper name, statistic, direct quotation and causal claim in ch13.html, with 0 rows carrying an empty verdict cell and 0 rows citing fewer than two sources.*  
  > Deadline Mar 15. ch13 carries 6 timeline entries — the second-densest in the book — so date corrections here have wide companion blast radius.  

- [ ] **M6-16** Open and merge the ch13 corrections PR, updating QUIZZES['13'], VOCAB['13'], SLIDES['13'] and the 6 ch:13 timeline.html entries in the same PR  
  `M` `[sonnet]` · after: `M6-15`  
  *Done when the ch13 corrections PR is merged with site-check.yml green and `git show --stat` on the merge lists ch13.html plus every companion file any ch13 'corrected' ledger row touches, with zero 'corrected' rows unapplied.*  
  > Timeline entries carry an `anchor:` key; if a correction renames a section id, M1's check_companion_sync.sh fails on the dangling anchor.  

- [ ] **M6-17** Write the ch14 (The Civil War) accuracy ledger into docs/ACCURACY_AUDIT.md  
  `L` `[fable]` · after: `M4-1`  
  *Done when docs/ACCURACY_AUDIT.md has a Chapter 14 section covering every date, proper name, statistic, direct quotation and causal claim in ch14.html, with 0 rows carrying an empty verdict cell and 0 rows citing fewer than two sources.*  
  > Deadline Mar 15. Casualty figures are the highest-risk statistic class here and current scholarship has revised them upward; cite the edition consulted in the row.  

- [ ] **M6-18** Open and merge the ch14 corrections PR, updating QUIZZES['14'], VOCAB['14'], SLIDES['14'] and the 7 ch:14 timeline.html entries in the same PR  
  `M` `[sonnet]` · after: `M6-17`  
  *Done when the ch14 corrections PR is merged with site-check.yml green and `git show --stat` on the merge lists ch14.html plus every companion file any ch14 'corrected' ledger row touches, with zero 'corrected' rows unapplied.*  
  > ch14 has the most timeline entries (7) of any chapter; a revised casualty figure usually appears in the chapter text, SLIDES['14'] and a timeline desc simultaneously.  

- [ ] **M6-19** Write the ch15 (Reconstruction) accuracy ledger into docs/ACCURACY_AUDIT.md  
  `L` `[fable]` · after: `M4-1`  
  *Done when docs/ACCURACY_AUDIT.md has a Chapter 15 section covering every date, proper name, statistic, direct quotation and causal claim in ch15.html, with 0 rows carrying an empty verdict cell and 0 rows citing fewer than two sources.*  
  > Deadline Mar 15. ch15 is the last chapter of Volume I; causal claims about Reconstruction's end are where the Dunning-school residue would show up, so weight causal-claim rows heavily.  

- [ ] **M6-20** Open and merge the ch15 corrections PR, updating QUIZZES['15'], VOCAB['15'], SLIDES['15'] and the 5 ch:15 timeline.html entries in the same PR  
  `M` `[sonnet]` · after: `M6-19`  
  *Done when the ch15 corrections PR is merged with site-check.yml green and `git show --stat` on the merge lists ch15.html plus every companion file any ch15 'corrected' ledger row touches, with zero 'corrected' rows unapplied.*  
  > VOCAB['15'] is the largest deck in the book (14 terms); a corrected definition there also needs the matching .vocab-box text in ch15.html or check_companion_sync.sh fails.  

- [ ] **M6-21** File the ch12, ch13, ch14 and ch15 'could not verify' issues and link each from its Review slot issue  
  `S` `[sonnet]` · after: `M6-14`, `M6-16`, `M6-18`, `M6-20`, `M2-9`  
  *Done when exactly four open GitHub issues exist (one per chapter ch12–ch15), each listing that chapter's 'could not verify' ledger rows, each linked from that chapter's Review slot issue, and every such ledger row carries its issue URL in the notes cell.*  
  > With M6-3 and M6-10 this brings the wave-2 total to 7 issues — one per chapter ch9 through ch15.  

- [ ] **M6-22** Add attribution clauses and 'View original' links to the 24 figcaptions across ch12.html, ch13.html, ch14.html and ch15.html  
  `L` `[fable]` · after: `M6-14`, `M6-16`, `M6-18`, `M6-20`  
  *Done when `grep -c 'View original'` returns 6 for ch12.html, 5 for ch13.html, 7 for ch14.html and 6 for ch15.html, every <figcaption> in those four files ends with a parenthetical attribution clause, and each unprovable image swap is logged in IMAGES_AUDIT.md.*  
  > Verify each image by fetching its source metadata, not by reading the filename — several ch13/ch14 captions currently name a photographer and approximate date with no link, which is exactly the claim that has to be confirmed or removed. Map figures keep their <span class="map-label">Map</span> and the attribution goes after the caption sentence.  

- [ ] **M6-23** Review the 'Whose Voices Were Left Out' and 'Multiple Perspectives' callouts in ch13.html, ch14.html and ch15.html against current scholarly consensus  
  `L` `[fable]` · after: `M6-16`, `M6-18`, `M6-20`  
  *Done when docs/ACCURACY_AUDIT.md has callout-review subsections for ch13 (3 callouts), ch14 (2) and ch15 (2), each row marked unchanged or changed with the scholarly source consulted, and any changed text merged in a green PR.*  
  > With M6-5 and M6-12 this closes the DoD bullet for all five named chapters (ch9, ch11, ch13, ch14, ch15) — 11 callouts total. Keep MAINTENANCE.md's exact markup for .voices-left-out and .perspectives; no emoji or ALL CAPS in the <h3>.  

- [ ] **M6-24** Flag the thin vocab decks (ch3/ch4/ch5/ch8) and 7-question quizzes (ch8/ch12) for human reviewers in docs/ACCURACY_AUDIT.md without expanding them  
  `S` `[sonnet]` · after: `M2-9`  
  *Done when docs/ACCURACY_AUDIT.md has a 'Flagged for human reviewers, not fixed here' table naming ch3/ch4/ch5/ch8 (6-term decks) and ch8/ch12 (7-question quizzes) with each row linking that chapter's Review slot issue, AND VOCAB['3'/'4'/'5'/'8'] still count 6 terms each and QUIZZES['8'/'12'] still count 7 questions each.*  
  > The negative half of the check is the point: this DoD bullet fails if the decks or quizzes get expanded. No blockers beyond the Review slot issues, so it can be done in week one of the milestone.  

- [ ] **M6-25** Record the ch9–ch15 fact-check dates in data/chapters.json so build_status.sh stamps the M4 banner wording  
  `S` `[sonnet]` · after: `M6-4`, `M6-5`, `M6-11`, `M6-12`, `M6-22`, `M6-23`, `M4-16`  
  *Done when data/chapters.json carries a fact-check date for ch9 through ch15, `bash scripts/build_status.sh` is a no-op on a second run (`git diff --exit-code` clean), and `grep -l 'AI-assisted fact check completed' ch*.html` lists exactly the 11 files ch5.html through ch15.html.*  
  > Carries forward M4's banner rule ('...; not yet reviewed by a historian') to the wave-2 chapters — a chapter the summary table counts as passed must show the passed marker. Edit data/chapters.json only; hand-stamping a chapter file would create a fourth status surface. Run per wave as each chapter closes rather than all seven in March.  

- [ ] **M6-26** Add the 11/15 summary table to the top of docs/ACCURACY_AUDIT.md, listing ch1–ch4 with the reason they were not audited  
  `S` `[sonnet]` · after: `M6-1`, `M6-6`, `M6-8`, `M6-13`, `M6-15`, `M6-17`, `M6-19`, `M6-24`, `M6-25`  
  *Done when docs/ACCURACY_AUDIT.md opens with a 15-row summary table in which exactly 11 rows (ch5–ch15) read 'passed' with a date and the 4 ch1–ch4 rows read 'not scheduled', each naming the ROADMAP.md reason (classrooms pass ch1–ch4 before M4 begins; most likely to be claimed first by human reviewers; revisit Q2 2027).*  
  > The count is 11 because M4 passed ch5–ch8 and M6 passes ch9–ch15. Do not present ch1–ch4 as failed or pending — the roadmap deliberately does not schedule them.  

- [ ] **M6-27** Run the mechanical close-out sweep over the seven wave-2 chapters and report any gap as a blocking issue  
  `S` `[haiku]` · after: `M6-3`, `M6-10`, `M6-21`, `M6-22`, `M6-23`, `M6-25`, `M6-26`  
  *Done when a single verification run reports all of: 7 ledger sections (ch9–ch15) with 0 empty verdict cells, 42 'View original' links across ch9–ch15 (6/7/5/6/5/7/6), 7 open 'could not verify' issues each linked from its Review slot, 11 chapters stamped with the fact-check banner, 11 callout-review rows across ch9/ch11/ch13/ch14/ch15, unchanged term and question counts for ch3/ch4/ch5/ch8/ch12, and site-check.yml green on main.*  
  > Mechanical only — this pass checks counts and presence, never historical judgment. Any shortfall is filed as an issue against the specific task above, not fixed here.  

<details><summary>Why this order</summary>

Three forces set this order. (1) The pacing calendar, not the dependency graph: ch9 is due Jan 15, ch10–ch11 by Feb 10, ch12–ch15 by Mar 15, so ch9's five tasks come first even though ch10–ch15 ledgers have no dependency on them. (2) Within a chapter, the ledger is the single source of truth for everything downstream — the corrections PR applies only rows the ledger marked "corrected", and the "could not verify" issue lists only rows the ledger marked "could not verify"; filing issues or editing ch9.html before the ledger exists means guessing at the list and redoing it. (3) The corrections PR must land before the figcaption pass and the callout review for the same chapter, because all three edit the same chapter file: doing figcaptions first guarantees conflict resolution on every corrected paragraph, and a callout whose surrounding facts are still wrong gets reviewed twice. The could-not-verify issue is deliberately gated on the corrections PR too, so a fact that the correction pass resolved is not filed as an open question for a volunteer. Ledgers depend on M4 rather than on each other: M4 writes the method into MAINTENANCE.md and establishes the row format in docs/ACCURACY_AUDIT.md, and starting a wave-2 ledger before that format is fixed produces rows that must be reshaped. Issue-filing tasks depend on M2 because the "one issue per chapter, linked from that chapter's Review slot" shape has nowhere to link until the 15 pinned Review slot issues exist; the banner task depends on M3 because the banner is generated by build_status.sh from data/chapters.json and hand-stamping it would create the fourth status surface M3 exists to prevent. The summary table is second-to-last because it can only claim 11/15 once the seven chapters have actually passed, and the haiku sweep is last because it verifies the other twenty-six.

</details>


## M7 — Accessibility beyond the chapter boundary

- [ ] **M7-1** Write scripts/check_a11y_landmarks.sh: assert every HTML file has a skip link as first focusable element with href="#main-content", exactly one <main id="main-content">, and at most one aria-current="page"  
  `M` `[sonnet]`  
  *Done when `bash scripts/check_a11y_landmarks.sh` exits non-zero and names exactly the 33 non-chapter HTML files as failing, and `grep -cE 'grep -[a-zA-Z]*P|sed -r|--regexp-extended' scripts/check_a11y_landmarks.sh` returns 0.*  
  > Instrument first, mirroring M0's rule that audit_images.sh is fixed before the images. Must be BSD/GNU portable — CLAUDE.md records that content-change-check.yml's `grep -oP` is GNU-only and will not run on macOS. Do not wire it into CI yet (M7-15); a failing check on main before the fixes lands red.  

- [ ] **M7-2** Port body.dark-mode / body.sepia / body.high-contrast / :focus-visible / .skip-link rules from css/chapter.css into css/pages.css  
  `M` `[sonnet]`  
  *Done when `grep -c 'body.dark-mode' css/pages.css` returns 40 or more and `body.sepia`, `body.high-contrast`, `:focus-visible` and `.skip-link` each appear at least once in css/pages.css.*  
  > pages.css has 55 rule blocks, 48 of which set color or background — 40 is the floor, not the target. pages.css has no `:root` custom properties (it uses literal hex), so chapter.css's `var(--teal)` / `var(--navy)` / `var(--gold)` must be resolved to hex or a matching `:root` block added. Must land before M7-5 or the skip links render visible.  

- [ ] **M7-3** Port the same dark-mode / sepia / high-contrast / :focus-visible / .skip-link rules into css/primary-sources.css, covering the 35 .ps-* component classes  
  `M` `[sonnet]`  
  *Done when `grep -c 'body.dark-mode' css/primary-sources.css` returns 50 or more and `body.sepia`, `body.high-contrast`, `:focus-visible` and `.skip-link` each appear at least once in css/primary-sources.css.*  
  > primary-sources.css has 83 rule blocks and 69 color/background declarations across .ps-source, .ps-citation, .ps-excerpt, .ps-questions, .ps-vocab, .ps-type-* and the rest. Same `var(--*)` resolution problem as M7-2. The 15 source pages load pages.css AND primary-sources.css, so M7-2 covers .header/.nav-bar/.container and this task covers only the .ps-* layer.  

- [ ] **M7-4** Add the same theme and focus blocks to index.html's inline <style> element  
  `S` `[sonnet]` · after: `M7-2`  
  *Done when `body.dark-mode`, `body.sepia`, `body.high-contrast`, `:focus-visible` and `.skip-link` each appear at least once inside index.html's inline `<style>` block.*  
  > index.html links no stylesheet at all — CLAUDE.md section 4 confirms css/index.css does not exist and the design is an inline `<style>`. Without this, a student in dark mode who clicks Home from ch1 gets flashed white, which is the exact scenario M7 exists to fix. Its markup uses `.page`/`.hero`/`.util-links`, not `.container`.  

- [ ] **M7-5** Add the skip link and convert the container div to <main id="main-content"> in the 18 root non-chapter pages (about, contributors, cornell-notes, current-events, differentiation, graphic-organizers, index, introduction, pacing-guide, primary-source-reader, quizzes, slideshows, standards, teachers, teaching, timeline, vocabulary-cards, whopays)  
  `M` `[sonnet]` · after: `M7-1`, `M7-2`, `M7-4`  
  *Done when `grep -L 'class="skip-link"' *.html` and `grep -L '<main id="main-content"' *.html` each print nothing across all 33 root HTML files.*  
  > Copy ch1.html:10 verbatim (`<a href="#main-content" class="skip-link">Skip to main content</a>`) as the first focusable element in `<body>`. 17 of the 18 wrap content in `<div class="container">` — convert that div to `<main id="main-content" class="container">` so the existing styles survive; index.html uses `<div class="page">` instead. The 15 chapters already pass both checks, so the root glob covers them for free.  

- [ ] **M7-6** Add the skip link and convert `<div class="container" style="max-width:820px;">` to <main id="main-content"> in all 15 primary-sources/chN-sources.html files  
  `M` `[sonnet]` · after: `M7-1`, `M7-2`, `M7-3`  
  *Done when `grep -L 'class="skip-link"' primary-sources/*.html` and `grep -L '<main id="main-content"' primary-sources/*.html` each print nothing across all 15 files.*  
  > Keep the inline `style="max-width:820px;"` on the new `<main>` — these pages deliberately run wider than the 640px chapter container. Use `&mdash;` if any new copy needs an em dash: CLAUDE.md requires matching the file's encoding, and every primary-sources/*.html uses entities.  

- [ ] **M7-7** Enforce the aria-current="page" invariant across all 48 files: every nav link whose href resolves to its own page carries it, and no page carries more than one  
  `S` `[sonnet]` · after: `M7-1`  
  *Done when, for each of the 48 HTML files, the count of `aria-current="page"` equals the count of nav links whose href resolves to that same file, and no file exceeds 1.*  
  > Verified baseline: exactly 6 files (about, contributors, introduction, teachers, teaching, whopays) have a nav self-link and all 6 already carry aria-current. The other 42 have no self-link — the 15 chapter-navs are Home/center/Next, the 15 primary-source nav-bars are Reader/Chapter/Prev/Next, and index.html and primary-source-reader.html are omitted from the shared 7-link site nav. Mark self-links where they exist; do NOT redesign navs to add self-links. Record the exception list as a comment in scripts/check_a11y_landmarks.sh. Touches ch6/ch7, so rebase after M1 if M1 has landed.  

- [ ] **M7-8** Create js/theme.js (synchronous, reads localStorage yawp_theme, applies dark-mode/sepia/high-contrast to document.body) and load it as the first element inside <body> on all 48 pages  
  `M` `[sonnet]` · after: `M7-2`, `M7-3`, `M7-4`  
  *Done when all 48 HTML files contain a non-deferred `<script src="js/theme.js"></script>` (`../js/theme.js` under primary-sources/) as the first element inside `<body>`, and `grep -c yawp_theme js/theme.js` returns 1 or more.*  
  > It must be synchronous and inside `<body>`, not `<head>`: a head script cannot touch document.body, and defer/async reintroduces the flash. A `<script>` is not focusable, so it can precede the skip link without violating M7-5/M7-6. Mirror reader-tools.js:179-183 applyTheme() exactly (removes high-contrast/sepia/dark-mode, maps 'contrast'->high-contrast, 'dark'->dark-mode) so the two never diverge; leave reader-tools.js initTheme() owning the button wiring. Do not add a CDN dependency — CLAUDE.md caps the repo at one (PptxGenJS).  

- [ ] **M7-9** Verify no white flash: cold-load teachers.html and primary-sources/ch1-sources.html with yawp_theme set to dark and confirm the first painted frame is already dark  
  `S` `[haiku]` · after: `M7-8`  
  *Done when a Chrome DevTools performance trace of a cold load of teachers.html and primary-sources/ch1-sources.html with localStorage yawp_theme='dark' shows the first painted screenshot frame already dark, with no #FAFAF8 frame.*  
  > Serve over `python3 -m http.server 8000` — never `open`. This is a separate failure from M7-8: theme.js can be present on all 48 pages and still flash if it is deferred, moved into `<head>`, or placed after the header markup.  

- [ ] **M7-10** Port the .reader-toolbar / .reader-toggle / .reader-panel / .reader-btn / .line-focus-overlay / .notes-panel component styles from css/chapter.css into css/primary-sources.css  
  `M` `[sonnet]` · after: `M7-3`  
  *Done when `.reader-toolbar`, `.reader-toggle`, `.reader-panel`, `.reader-btn`, `.line-focus-overlay` and `.notes-panel` each appear in css/primary-sources.css and `grep -c 'reader-panel.open' css/primary-sources.css` returns 1.*  
  > Hard ordering trap: `.reader-panel { display: none }` (chapter.css:542) and `.reader-panel.open { display: block }` (chapter.css:546) exist only in chapter.css. Ship M7-11 without this and all 15 source pages render the full seven-section tool panel permanently expanded, with the toolbar inline instead of `position: fixed`. Source range is roughly chapter.css:508-660.  

- [ ] **M7-11** Add the reader-toolbar aside, line-focus overlay, notes panel and `<script src="../js/reader-tools.js">` to all 15 primary-sources/chN-sources.html files  
  `M` `[sonnet]` · after: `M7-6`, `M7-8`, `M7-10`  
  *Done when all 15 primary-sources/ch*-sources.html files contain both `<script src="../js/reader-tools.js"></script>` and `class="reader-toolbar"`.*  
  > Copy the block at ch1.html:406-500 verbatim, adjusting the script src to `../js/`. reader-tools.js guards every init with an early return on a missing node, so omitting the .progress-bar and .back-to-top elements is safe if those are not wanted here. The Read Aloud section reads `.vocab-box` and section text; primary-source pages use `.ps-vocab` instead, so expect the glossary button to find nothing — that is acceptable and should not be 'fixed' by touching .ps-vocab markup (CLAUDE.md 2.3 explicitly protects it).  

- [ ] **M7-12** Run a keyboard-only (Tab/Shift-Tab/Enter/Escape) pass over the five representative pages — ch1.html, primary-sources/ch1-sources.html, teachers.html, quizzes.html, index.html — and file each finding as an issue  
  `S` `[sonnet]` · after: `M7-5`, `M7-6`, `M7-7`, `M7-8`, `M7-11`  
  *Done when a Tab-only traversal of those five pages is recorded with one GitHub issue per finding labeled `a11y`, or a single issue stating zero findings.*  
  > Five pages chosen to cover every template family: chapter (chapter.css), primary source (pages.css + primary-sources.css), site page (pages.css), JS-heavy tool page, and the inline-styled home page. Check reader-panel focus trapping and Escape-to-close, and that the skip link is genuinely the first stop. Must run after all markup lands or it audits a state about to change.  

- [ ] **M7-13** Run a VoiceOver (Safari on macOS) pass over the same five representative pages and file each finding as an issue  
  `M` `[sonnet]` · after: `M7-5`, `M7-6`, `M7-7`, `M7-8`, `M7-11`  
  *Done when a VoiceOver pass over ch1.html, primary-sources/ch1-sources.html, teachers.html, quizzes.html and index.html is recorded with one GitHub issue per finding labeled `a11y`, or a single issue stating zero findings.*  
  > Budget ~45 min per the roadmap. Independently failable from M7-12 — keyboard order can be perfect while landmark and aria-pressed announcements are wrong. Exercise the rotor landmark list to confirm exactly one `main` per page. NVDA/JAWS is explicitly out of scope (Deliberately not scheduled); do not expand into it.  

- [ ] **M7-14** Bump DESIGN_GUIDE.md to v1.1.0, stating which v1.0.x accessibility claims were chapter-only, and defer the callout icon system with a stated reason  
  `S` `[fable]` · after: `M7-2`, `M7-3`, `M7-8`, `M7-11`, `M7-12`, `M7-13`  
  *Done when DESIGN_GUIDE.md line 3 reads `**Version:** 1.1.0`, its Version History contains a 1.1.0 entry naming which earlier accessibility claims were chapter-only, and the `Callout Icons` checklist item (line 378) is marked deferred with a reason.*  
  > Requires editorial honesty, not markup: the v1.0.1 audit lines (370-377) read as site-wide but were chapter-only. The deferral reason is already recorded in the roadmap's 'Deliberately not scheduled' — icons would add new content across 15 files for scarce reviewers to re-review, and the icon system contradicts v1.0.2's own removal of emojis from headings. Also correct the stale alt-text percentage (line 371 says 99.2%; the repo is at 127/127).  

- [ ] **M7-15** Add scripts/check_a11y_landmarks.sh to .github/workflows/site-check.yml as a failing check  
  `S` `[sonnet]` · after: `M0-6`, `M7-5`, `M7-6`, `M7-7`  
  *Done when site-check.yml invokes `bash scripts/check_a11y_landmarks.sh` and a throwaway PR deleting the skip link from about.html turns that job red.*  
  > Cross-milestone: site-check.yml is created in M0 (it does not exist yet — .github/workflows/ currently holds only content-change-check.yml). Wire this in only after M7-5/M7-6/M7-7 are green, or main goes red. The roadmap requires exactly one workflow file, so add a job or step to site-check.yml — never a new .yml.  

- [ ] **M7-16** Update CLAUDE.md section 2.4 so its accessibility compliance counts describe the post-M7 state  
  `S` `[sonnet]` · after: `M7-5`, `M7-6`, `M7-8`, `M7-11`, `M7-15`  
  *Done when `grep -c '15 of 48\|33 files have no\|0×' CLAUDE.md` returns 0 and section 2.4 instead states the post-M7 counts.*  
  > Required by the roadmap's Review cadence rule ('update CLAUDE.md if it changes a fact that file asserts'). M7 falsifies three assertions in section 2.4: skip links in 15 of 48 files, 33 files with no `<main>`, and `body.dark-mode` appearing 0x in pages.css and primary-sources.css. Leave the section 4 search-index note and the section 5 .claude/agents/ note alone — those belong to M1 and to the subagent task.  

- [ ] **M7-17** Mechanically verify every M7 done-when in one pass and record the results  
  `S` `[haiku]` · after: `M7-9`, `M7-12`, `M7-13`, `M7-14`, `M7-15`, `M7-16`  
  *Done when a single recorded run shows: check_a11y_landmarks.sh exits 0; theme.js referenced in 48 HTML files; reader-tools.js referenced in 30; `body.dark-mode` count non-zero in both css/pages.css and css/primary-sources.css; DESIGN_GUIDE.md at 1.1.0; the a11y job green on main; and the M7-12/M7-13 issues filed.*  
  > Pure verification, no edits. reader-tools.js should reach 30 files (15 chapters, unchanged, plus the 15 primary-source pages from M7-11) — a count of 15 means M7-11 did not land.  

<details><summary>Why this order</summary>

Two hard ordering traps drive this sequence. (1) CSS before markup: chapter.css is the only stylesheet with a `.skip-link` rule (`top:-40px`, revealed on `:focus`). The 33 non-chapter files load css/pages.css and css/primary-sources.css, which have zero `.skip-link`, zero `:focus-visible` and zero `body.dark-mode` rules. Adding skip-link markup first would ship 33 pages with a permanently visible stray link at the top-left, so M7-2/M7-3/M7-4 (the CSS ports) must land before M7-5/M7-6 (the markup). The same applies to js/theme.js: applying `body.dark-mode` on a page whose stylesheet does not define it produces a half-dark page, so M7-8 comes after all three CSS tasks. (2) Toolbar CSS before toolbar markup: `.reader-panel { display: none }` and `.reader-panel.open { display: block }` exist only in css/chapter.css. Adding the reader-toolbar aside to the 15 primary-source pages before porting those rules (M7-10) would render the whole panel permanently expanded on every source page — so M7-11 depends on M7-10. Separately, the instrument comes first: M7-1 writes scripts/check_a11y_landmarks.sh before any markup is touched, mirroring M0's audit-script-before-images rule, so the 33-file failure baseline is measurable and the later fixes are provable rather than asserted. CI wiring (M7-15) is last among the code tasks because a failing check merged to main before the fixes would red the default branch; it also needs site-check.yml, which M0 creates. The two assistive-technology passes (M7-12, M7-13) run only after every markup and theme change is in place, otherwise they audit a state that is about to change; DESIGN_GUIDE.md (M7-14) and CLAUDE.md (M7-16) are written last because both must describe the finished state honestly.

</details>


## M8 — Standards: extend standards.html with C3 and NCSS

- [ ] **M8-1** Create docs/STANDARDS_SOURCES.md: transcribe C3 D2.His.1-16.6-8, D4.1-8.6-8 and the four NCSS themes verbatim from the published documents, recording editions consulted  
  `M` `[fable]`  
  *Done when docs/STANDARDS_SOURCES.md exists, `grep -oE 'D2\.His\.[0-9]+\.6-8|D4\.[0-9]+\.6-8' docs/STANDARDS_SOURCES.md | sort -u | wc -l` returns 24, each code carries a verbatim descriptor, the four NCSS theme names from teaching.html:329 are listed, and each source document has a line giving publisher, edition/year, and the URL or page consulted.*  
  > The docs/ directory does not exist yet in this repo — create it. M2 and M4 also write into docs/; no coordination needed beyond not clobbering. Do not paraphrase descriptors: M8-2/M8-3/M8-10 compare the page against this file character-for-character, so a remembered wording here propagates as a silent failure. Scheduling caveat: M9's Dec 20 checkpoint can move all of M8 to Q2 — that decides when this starts, it is not a blocker.  

- [ ] **M8-2** Add the C3 Dimension 2 (History) section to standards.html: <h2 id="c3-framework"> plus 16 .standard-block entries for D2.His.1.6-8 through D2.His.16.6-8  
  `L` `[fable]` · after: `M8-1`  
  *Done when `grep -c 'standard-code">D2\.His\.' standards.html` returns 16, standards.html contains `<h2 id="c3-framework"`, each block's .standard-text matches its descriptor in docs/STANDARDS_SOURCES.md character-for-character, and `npx html-validate standards.html` exits 0.*  
  > Copy the existing RH.6-8 block shape exactly (lines 239-247): .standard-code, <h3>, .standard-text, .chapter-tags of <a class="ch-tag">, .how-to. No new CSS classes — .standard-block styling is the inline <style> at standards.html:27-89. Place the section after the WHST section's <hr class="section-divider"> (line 363 region), before Feature-to-Standard Map. Use &mdash;/&ndash; entities, matching this file. Chapter tags and how-to text must name features that actually exist (vocab-box, stop-think, perspectives, voices-left-out, primary-source, story-box, big-questions).  

- [ ] **M8-3** Add the C3 Dimension 4 (Communicating Conclusions) subsection to standards.html: 8 .standard-block entries for D4.1.6-8 through D4.8.6-8  
  `M` `[fable]` · after: `M8-1`, `M8-2`  
  *Done when `grep -c 'standard-code">D4\.' standards.html` returns 8, each block's .standard-text matches docs/STANDARDS_SOURCES.md character-for-character, and `npx html-validate standards.html` exits 0.*  
  > Depends on M8-2 only to serialize edits to the same region of standards.html and keep D2 before D4 on the page. D4.1-8 are argument/communication indicators, so how-to text should point at Chapter Activities, WHST.6-8.1 overlap, and the graphic-organizers.html / cornell-notes.html tools rather than at reading features.  

- [ ] **M8-4** Add a C3 Quick Reference Matrix table to standards.html in the existing .matrix-table / .dot format, 15 chapter rows  
  `M` `[fable]` · after: `M8-2`, `M8-3`  
  *Done when `xmllint --html --xpath 'count(//table[@id="c3-matrix"]/tbody/tr)' standards.html` prints 15 and every code appearing in that table's <th> cells is present in docs/STANDARDS_SOURCES.md.*  
  > Reuse .matrix-table, .dot-primary/.dot-secondary/.dot-light and the .matrix-legend block (standards.html:227-231) — no new CSS. Wrap in <div style="overflow-x: auto;"> like the existing matrix at line 191. 24 one-per-indicator columns is unreadable at max-width 640px; group columns by C3 sub-strand as long as every header code exists on the page. Each dot must agree with that indicator's .chapter-tags from M8-2/M8-3 — the matrix restates those decisions, it does not make new ones.  

- [ ] **M8-5** Add the NCSS themes section to standards.html: <h2 id="ncss-themes"> plus 4 .standard-block entries for the themes named at teaching.html:329  
  `M` `[fable]` · after: `M8-1`, `M8-3`  
  *Done when standards.html contains `<h2 id="ncss-themes"` followed by exactly 4 .standard-block entries whose <h3> text equals the four theme strings on teaching.html:329 (Culture; Time, Continuity & Change; People, Places & Environments; Power, Authority & Governance), and `npx html-validate standards.html` exits 0.*  
  > Scope is exactly the four themes teaching.html already promises — do not add the other six NCSS themes. Theme descriptors come from docs/STANDARDS_SOURCES.md, not from memory. Depends on M8-3 to serialize same-file edits.  

- [ ] **M8-6** Add an NCSS Quick Reference Matrix table to standards.html, 15 chapter rows by the 4 themes  
  `M` `[fable]` · after: `M8-5`  
  *Done when `xmllint --html --xpath 'count(//table[@id="ncss-matrix"]/tbody/tr)' standards.html` prints 15 and `xmllint --html --xpath 'count(//table[@id="ncss-matrix"]//th)' standards.html` prints 5 (Chapter plus the four themes).*  
  > Same .matrix-table / .dot markup and legend as M8-4. Rows must run ch1-ch15 in order with the same chapter labels used in the existing matrix (standards.html:208-222), e.g. "1. Indigenous America".  

- [ ] **M8-7** Update standards.html page identity: <title>, .header subtitle and .standards-intro so the page names Common Core, C3 and NCSS instead of Common Core only  
  `S` `[sonnet]` · after: `M8-4`, `M8-6`  
  *Done when `grep -c 'Common Core Alignment' standards.html` returns 0 and the <title>, the .header subtitle paragraph (line 173 region) and the first .standards-intro paragraph each contain both "C3" and "NCSS".*  
  > Currently <title> reads "Common Core Alignment | American Yawp MS" and the header subtitle reads "Common Core ELA/Literacy &mdash; Grades 6&ndash;8" — both become false the moment the C3/NCSS sections land, which is why this follows them. If M3's meta-description/OG pass (M3 DoD: all 48 files carry meta description + OG tags) has already run on standards.html, update the OG title to match; do not add OG tags here if it has not.  

- [ ] **M8-8** Update teaching.html's .standards-box from "in development" to shipped, linking standards.html#c3-framework and standards.html#ncss-themes  
  `S` `[sonnet]` · after: `M8-2`, `M8-5`, `M8-7`  
  *Done when `grep -c 'in development' teaching.html` returns 0, the .standards-box <h3> no longer contains "(Preview)", its C3 and NCSS bullets link to standards.html#c3-framework and standards.html#ncss-themes, and both ids are present in standards.html.*  
  > The block is teaching.html:323-331. Leave the existing Standards Alignment card at teaching.html:264-267 alone except to widen its description beyond "Common Core ELA/Literacy standards (RH.6-8 and WHST.6-8)". teaching.html uses &mdash; entities — match them. This also clears the third bullet of M0's doc-corrections item ("teaching.html stops calling the shipped standards guide 'in development'"); if M0 already reworded it, reconcile rather than revert.  

- [ ] **M8-9** Open the issue "Curriculum coordinator: check the C3/NCSS mapping" and link it from the C3/NCSS sections of standards.html  
  `S` `[sonnet]` · after: `M8-7`  
  *Done when `gh issue list --state open --search 'Curriculum coordinator: check the C3/NCSS mapping'` returns exactly that title, standards.html contains a link to that issue URL, and the issue body states in writing that no milestone item waits on a response.*  
  > The roadmap is explicit that no DoD item depends on this volunteer — the issue existing and being visible is the whole deliverable, so never mark M8 blocked on a reply. Body should name the editions from docs/STANDARDS_SOURCES.md so a coordinator can check against the same documents.  

- [ ] **M8-10** Mechanical verification sweep of the M8 deliverables across standards.html, teaching.html and docs/STANDARDS_SOURCES.md  
  `S` `[haiku]` · after: `M8-1`, `M8-2`, `M8-3`, `M8-4`, `M8-5`, `M8-6`, `M8-7`, `M8-8`, `M8-9`  
  *Done when one run confirms all five: 24 D2.His/D4 codes and 4 NCSS themes on standards.html match docs/STANDARDS_SOURCES.md character-for-character, both #c3-matrix and #ncss-matrix have 15 tbody rows, `npx html-validate standards.html teaching.html` exits 0, `grep -c 'in development' teaching.html` returns 0, and the #c3-framework and #ncss-themes anchors linked from teaching.html resolve.*  
  > Verification only — file no fixes, open an issue or hand back a failure list instead. This is the mechanical half of the roadmap's "checked against the published documents, not from memory" item: it proves the page matches the transcription, while M8-1 is what proves the transcription matches the published documents.  

<details><summary>Why this order</summary>

M8-1 comes first for the same reason M0 fixes audit_images.sh before the images: the milestone's second DoD item forbids writing indicator codes and descriptors from memory, so docs/STANDARDS_SOURCES.md is the instrument every later task is graded against. Author the 24 blocks first and you have 24 descriptors to re-verify and probably re-type, plus no way to prove the check happened. The three section tasks (M8-2, M8-3, M8-5) precede their matrix tasks (M8-4, M8-6) because a matrix header cell can only name a code that already exists on the page, and each chapter dot restates an alignment decision already made in that indicator's .chapter-tags row — building a matrix first fixes 15x24 judgments that the block-writing pass then changes, and the two would silently disagree. M8-3 follows M8-2 and M8-5 follows M8-3 only to serialize edits to the same region of standards.html; they are otherwise independent. All authoring precedes M8-7 and M8-8: standards.html's <title> and header currently say "Common Core Alignment", and teaching.html:325 must not be flipped from "in development" to "shipped" until the page it links actually contains C3 and NCSS sections at real anchors — otherwise the front-of-house claim is false for however long the authoring takes. M8-9 needs the #c3-framework and #ncss-themes anchors to exist before it can link the coordinator issue at them. M8-10 is last and mechanical. Note on scheduling, not dependency: the roadmap's milestone map lists M8 as unblocked, but M9's Dec 20 checkpoint can push all of M8 to Q2 if fewer than 5 real reviews have arrived; that gate decides when M8-1 starts, it is not a task dependency.

</details>


## M9 — The review loop runs on real data

**Checkpoint due Dec 20, 2026**

- [ ] **M9-1a** Record the first real review end-to-end and prove build_status.sh regenerates all four status surfaces with a clean diff  
  `M` `[sonnet]` · after: `M2-2`, `M2-3`, `M2-5`, `M2-6`, `M3-2`  
  *Done when one review:chNN issue has become a reviewer entry in data/chapters.json, build_status.sh has regenerated REVIEW_STATUS.md, the README table, teachers.html and contributors.html, and `git diff` shows no hand edits to any of them.*  
  > Split from the standing loop: five tasks including the hard-dated Dec 20 checkpoint depended on a task that cannot close before Mar 15.  

- [ ] **M9-1b** Run the standing review-recording loop through Mar 15, 2027: every review recorded within 7 days of arrival, zero hand edits  
  `L` `[sonnet]` · after: `M9-1a`  
  *Done when every review issue's recorded-at timestamp is within 7 days of its opened-at timestamp and no status table has a commit that is not generator output.*  
  > Standing loop; only M9-10 depends on it.  

- [ ] **M9-2** Walk TRIAGE.md end to end on the first real chapter review and commit the corrections the walk exposes  
  `M` `[sonnet]` · after: `M2-11`, `M9-1a`  
  *Done when `git log --oneline -- TRIAGE.md` shows a commit dated after the first review:chNN issue was recorded whose body cites that issue's URL, and TRIAGE.md still contains 10 or fewer numbered steps.*  
  > Do the walk from the issue URL alone, as M2-6 promises an AI assistant can — every place the doc had to be improvised is a correction. Correcting TRIAGE.md before a real review arrives is guesswork and does not satisfy this item.  

- [ ] **M9-3** Disposition every factual-error item from recorded reviews: a merged correction PR or a written answer in the issue thread  
  `L` `[fable]` · after: `M9-1a`, `M9-2`, `M4-1`  
  *Done when no issue labeled review:chNN with a non-empty "Factual errors or inaccuracies" field is open, and each such closed issue's thread contains either a link to a merged PR or a comment beginning "No change:" with the reasoning.*  
  > A correction PR touching chN.html carries the same downstream duty as M4: quiz answers, vocab deck, slideshow text, timeline entry and the search index in the same PR, site-check.yml green. Judging whether a reported error is real is historical judgment, hence fable — check against the corresponding American Yawp chapter plus one independent reference, the same method as docs/ACCURACY_AUDIT.md.  

- [ ] **M9-4** Populate consenting reviewer entries and regenerate the contributors.html reviewer section from data/chapters.json  
  `M` `[sonnet]` · after: `M2-3`, `M9-1a`  
  *Done when the reviewer count in contributors.html equals `jq '[.chapters[].reviewers[]|select(.consent)]|length' data/chapters.json`, no reviewer name appears in contributors.html that lacks consent in data/chapters.json, and `bash scripts/build_status.sh && git diff --exit-code contributors.html` exits 0.*  
  > Consent and display name come from the M2-3 consent-to-credit fields on the chapter-review.yml issue, never from a GitHub handle inferred by hand. contributors.html today has only Project Creator / Special Thanks / How to Join sections written by hand — the generated reviewer section is new markup that must sit in a delimited generated block so build_status.sh can rewrite it idempotently.  

- [ ] **M9-5** Extend the REVIEW_STATUS.md counting rule with the classroom-pilot clause and flag pilot reviews in data/chapters.json  
  `S` `[fable]` · after: `M2-5`, `M9-1a`  
  *Done when `grep -q 'never as the third' REVIEW_STATUS.md` succeeds and every maintainer-authored reviewer entry in data/chapters.json carries the pilot flag (`jq '[.chapters[].reviewers[]|select(.pilot)]|length'` equals the number of pilot reviews recorded).*  
  > Must land before M9-6, not after: the Dec 20 census counts real reviews, and an unflagged maintainer pilot could push the count to 5 and flip the checkpoint to the wrong branch. Extends the M2-2 paragraph rather than replacing it.  

- [ ] **M9-6** Write the Dec 20, 2026 checkpoint post in GitHub Discussions with the review census and the Q1 branch decision  
  `M` `[fable]` · after: `M9-1a`, `M9-5`, `M2-14`  
  *Done when a GitHub Discussion created on or before 2026-12-20 states N = the count of review:chNN issues opened since the M2 ship commit (with the `gh issue list` query that produced it) and names exactly one branch: "proceed as scheduled" for N>=5 or "outreach first, M8 moves to Q2" for N<5.*  
  > Hard date — the post is late if it lands after Dec 20, 2026 even if the number is right. Exclude pilot-flagged reviews from N per M9-5. This is the roadmap's own review-cadence checkpoint, so link it from the roadmap's Review cadence section.  

- [ ] **M9-7** If the checkpoint counted fewer than 5 reviews, run direct outreach to the three named channels and move M8 to Q2 in ROADMAP.md  
  `M` `[fable]` · after: `M9-6`, `M2-13`  
  *Done when either the checkpoint Discussion records N>=5 and this task is closed as not-applicable in that thread, or docs/ holds the sent outreach text for all three targets (state social-studies council, American Yawp community, one district pilot) with send dates and `grep -n 'M8' ROADMAP.md` shows the M8 heading under Q2 2027.*  
  > Conditional branch — do not start it before M9-6 produces the number, and do not run outreach anyway if N>=5. Reuse the recruitment text committed to docs/ by M2-7 rather than writing new copy; outreach must precede any M8 work, so the M8 tasks stall until this closes.  

- [ ] **M9-8** Stretch: push chapters 1-4 to 1/3 or better by Mar 15, 2027 through the ch1-ch4 review slot issues  
  `L` `[sonnet]` · after: `M2-9`, `M2-13`, `M9-6`, `M9-7`  
  *Done when `jq '[.chapters[]|select(.number<=4)|select([.reviewers[]|select(.consent and (.pilot|not))]|length>=1)]|length' data/chapters.json` returns 4 on or before 2027-03-15, or the shortfall is recorded as a comment on each ch1-ch4 review slot issue.*  
  > Explicitly a stretch: an unmet target here never blocks M9 sign-off — record the shortfall and move on. ch1-ch4 are the chapters M4/M6 deliberately skip, so a human reviewer is the only coverage they get; a maintainer classroom pilot counts as one labeled review and never as the third (M9-5).  

- [ ] **M9-9** State the next frontier on teachers.html: "Units 1-2 approved by June 2027"  
  `S` `[sonnet]` · after: `M2-2`  
  *Done when `grep -q 'Units 1–2 approved by June 2027' teachers.html` succeeds and `bash scripts/build_status.sh && git diff --exit-code teachers.html` exits 0.*  
  > Place the sentence outside the build_status.sh generated block that owns the `.review-table`, or the next generator run erases it. teachers.html uses literal em/en dashes (not `&mdash;`), so write "Units 1–2" with a literal en dash to match the file.  

- [ ] **M9-10** Verify all six M9 done-when items in one mechanical pass and post the results on the checkpoint Discussion  
  `S` `[haiku]` · after: `M9-1b`, `M9-2`, `M9-3`, `M9-4`, `M9-5`, `M9-6`, `M9-7`, `M9-9`  
  *Done when a single verification run reports PASS for all six checks — build_status.sh idempotence (`git diff --exit-code`), the 7-day recording jq query, the post-first-review TRIAGE.md commit, contributors.html consent parity, the checkpoint Discussion URL and its branch line, and `grep 'Units 1–2 approved by June 2027' teachers.html` — and the output is posted as a comment on the checkpoint Discussion.*  
  > Mechanical only — no judgment about whether a review was handled well. M9-8 is excluded because it is a stretch item and its miss must not fail the milestone. Also spot-check the no-hand-edit invariant: for each commit touching REVIEW_STATUS.md, README.md, teachers.html or contributors.html, check the commit out, re-run scripts/build_status.sh, and confirm git diff is clean.  

<details><summary>Why this order</summary>

M9 is a loop that runs on data arriving from outside, so the order is set by when facts become available, not by convenience. M9-1 comes first because every other item consumes what it records: TRIAGE cannot be walked, factual errors cannot be dispositioned, contributors cannot be generated and the census cannot be counted until reviews exist as reviewer entries in data/chapters.json. M9-2 must follow the first real review — correcting TRIAGE.md against an imagined review is guesswork and produces a document that still breaks on contact, which is exactly the failure M9 exists to prevent. M9-3 follows M9-2 because the triage loop is what defines how a factual-error item is dispositioned; doing PRs first would set a precedent the corrected doc then contradicts. M9-5 is deliberately placed before M9-6: the counting rule that says a maintainer classroom pilot is one labeled review and never a third has to exist before anything is counted, or an unflagged pilot can lift N from 4 to 5 and send the Dec 20 checkpoint down the wrong branch — an ordering trap with real consequences, since that branch decides whether M8 stays in Q1. M9-7 is conditional on the number M9-6 produces, so it cannot start earlier; running outreach before the count either wastes the effort or pre-empts the decision. M9-8 depends on M9-6/M9-7 because the outreach targets and the channel to push ch1-ch4 through are settled there. M9-4 sits after M9-1 (consent data arrives with reviews) but before verification. M9-9 depends only on M2-1's generator and could run any time, but it is placed late because the generated-block boundary must already exist. M9-10 is last by definition and excludes the stretch item so a missed stretch cannot fail the milestone.

</details>


---

## Maintenance

When a task changes a fact `CLAUDE.md` asserts, update `CLAUDE.md` in the same PR — this is
why **M1-14** exists. The repo's recurring failure mode is fixing something once rather than
making it unable to recur; the same applies to its documentation.
