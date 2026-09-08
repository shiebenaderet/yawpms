# CLAUDE.md — American Yawp MS

Standing instructions for every Claude Code session in this repository. Read this
before touching anything. Where this file and another doc disagree, see
**Authority map** at the bottom.

---

## 1. What this is

**The American Yawp MS** — a free middle school (grades 6–8, ages 11–14) US history
textbook adapted from *The American Yawp* (Locke & Wright, Stanford UP, 2018),
licensed **CC BY-SA 4.0**.

- **Static HTML, no build step.** No `package.json`, no bundler, no preprocessor.
  33 hand-written `.html` files at the repo root, served as-is.
- **Deploys via GitHub Pages** from `main` to **americanyawpms.com** (set by `CNAME`).
  There is no Pages deploy workflow. Note: `README.md` still links
  `shiebenaderet.github.io/yawpms` in 22 places; the github.io URL 301s to the custom
  domain.
- **Volume I only** — 15 chapters, pre-Columbian through Reconstruction. Volume II
  (1877–present) is explicitly conditional: *"If there's demand… we'll build it."*
  Do not treat it as committed work.
- **All 15 chapters are Draft.** The bar for classroom-ready is **3 reviewers per
  chapter**; every chapter currently reads `0 / 3`.

**Voice.** The book "treats students like thinkers, not test-takers." Tell stories,
be honest about complexity without overwhelming, and center the voices traditional
textbooks omit. "Stop and Think" prompts are analytical, never recall quizzes.

**Free forever.** CC BY-SA 4.0 exists here specifically to prevent paywalling. Never
link a paywalled resource as a primary source, and never propose monetization.

---

## 2. Non-negotiable guardrails

This project has been burned by each of these.

### 2.1 Verify every image before you use it

- **Look at the actual image.** Never write a caption or `alt` text from a filename,
  a URL, or a search result title.
- **Fetch the source metadata** (Wikimedia Commons API: `action=query`,
  `prop=imageinfo`, `iiprop=extmetadata`) and confirm **artist, date, and license**
  match what the page claims.
- **Modern photographs are never presented as historical artwork.** If a page shows a
  present-day photo of a historical site, the caption must say so.
- **"Public domain" is claimed only when the source confirms it.** CC BY-SA images
  require **named attribution in the caption**.
- Caption attribution follows the existing parenthetical form:
  `(NOAA, public domain)` · `(Wikimedia Commons, public domain)`.

### 2.2 Primary sources keep their original-source link

There are **two different primary-source markups**. Do not confuse them.

| | `primary-sources/chN-sources.html` | inside `chN.html` |
|---|---|---|
| Wrapper | `<div class="ps-source" id="source-N-M">` | `<div class="primary-source">` |
| Count | 61 blocks (4/chapter; ch5 has 5) | 29 blocks |
| Source link | **required** | **none — by convention** |
| Citation | `<div class="ps-citation">` | `<p class="source-citation">` |

- All **61** `.ps-source` blocks carry exactly one `<p class="ps-source-link">`. This
  invariant was established by the three most recent commits — **do not break it.**
- The class sits on the **`<p>`, never on the `<a>`**. CSS targets the descendant
  (`.ps-source-link a`), so a class on the anchor renders unstyled.
- Anchors use `target="_blank" rel="noopener"`.
- Link text is **not** uniform, and that is correct: 59 read
  `View the original source &rarr;`, 2 read `…photograph &rarr;`, 1 reads
  `…engraving &rarr;`. Source 1.2 (Cahokia) deliberately carries **two** anchors — an
  1887 engraving and a modern photograph. Match the text to what the link shows;
  do not "normalize" these.
- Any new source needs a **curl-verified** original-source URL.
- Do **not** add source links to in-chapter `.primary-source` boxes. Zero of the 29
  have one.

### 2.3 Follow MAINTENANCE.md's markup patterns exactly

`MAINTENANCE.md` is the **markup authority**. Copy its patterns; never invent variants.

- `### Callout Boxes` (line 21) gives exact HTML for 8 types: `vocab-box`, `key-idea`,
  `perspectives`, `stop-think`, `primary-source`, `story-box`, `voices-left-out`,
  `activity-box`.
- `### Do NOT Use` (line 75) is binding — all 8 bullets, including no `<dl>` in vocab
  boxes, no `<ol>` in stop-think, no `<blockquote>` in primary sources, no emoji or
  ALL CAPS in `<h3>`.
- Two live classes are **undocumented but legitimate**: `.big-questions` and
  `.overview` (15 uses each, styled in `chapter.css`). Preserve them.
- The vocab-box list ban applies **only to chapter `.vocab-box`** (parsed by
  `reader-tools.js` and `build_search_index.sh`). Primary-source `.ps-vocab`
  correctly uses `<ul><li><strong>term</strong> &mdash; def</li></ul>`. Leave it alone.

### 2.4 Accessibility — WCAG 2.1 AA minimum

The requirements live in **`MAINTENANCE.md:124–130`**, not `DESIGN_GUIDE.md`:

- `alt` on every `<img>` (currently 127/127 — keep it perfect)
- Skip-to-content link on every page with a header
- ARIA landmarks (`<main>`, `<nav>`, `<aside>`)
- Keyboard access; visible focus (3px teal outline, 2px offset)
- 4.5:1 contrast body / 3:1 large text; color never the sole signal
- Container is `max-width: 640px` — **do not exceed** (keeps ~68–72 chars/line)
- **Dark mode:** every new `chapter.css` rule needs a `body.dark-mode` counterpart

Compliance is **uneven, so verify rather than assume**: skip links exist in 15 of 48
HTML files (chapters only); 33 files have no `<main>`; `body.dark-mode` appears 122×
in `chapter.css` but **0×** in `pages.css` and `primary-sources.css`.

### 2.5 Chapter text changes trigger the downstream checklist

`.github/pull_request_template.md` carries an **11-item** downstream-impact checklist.
The four CI tracks are vocabulary cards, quizzes, slideshows, and the search index:

```bash
bash scripts/build_search_index.sh   # regenerates js/search-index.json
```

Also consider: timeline, pacing guide, standards, graphic organizers, Cornell notes,
primary sources. **Nothing enforces this** — CI only posts an advisory comment.

---

## 3. Working conventions

### Local development

**Serve over HTTP. Do not `open ch1.html`.**

```bash
python3 -m http.server 8000     # then http://localhost:8000/ch1.html
```

`js/search.js` loads the index by `XMLHttpRequest`, which `file://` blocks with no
error path — search hangs on "Loading index..." forever. `CONTRIBUTING.md` documents
`open ch1.html`; that instruction hides the bug.

### Images

- **All images are committed and present** — 124 tracked under `images/`, 16 under
  `primary-sources/images/`, zero broken references. `CONTRIBUTING.md`'s "they're not
  stored in the repo" is **wrong**; do not tell contributors to download anything.
- Chapter images: `images/chN/<name>.jpg`. Primary-source images: **flat and
  chapter-prefixed**, `primary-sources/images/chN-<slug>.jpg`.
- `scripts/download_primary_source_images.sh` is the **provenance manifest for
  `primary-sources/images/` only** (15 entries with artist/date/collection/license
  comments). Keep it accurate when adding a source image. The other 124 images are
  covered by per-chapter scripts + `IMAGES_AUDIT.md` + `MAPS.md`.
- `scripts/download_all_images.sh` runs only the 15 per-chapter scripts. Maps and
  primary-source images need their own two commands.

### Figures

```html
<figure class="map-figure">
  <img src="images/chN/name.jpg" alt="Descriptive alt text" />
  <figcaption><span class="map-label">Map</span> Caption. (Source, license)</figcaption>
</figure>
```

Non-map figures use bare `<figure>` with no label span. **`MAPS.md`'s snippet is
stale** — it omits `class="map-figure"` and the label span that all 23 real map
figures carry.

### Adding a chapter

`MAINTENANCE.md`'s checklist is incomplete. Also required:

1. `<li>` in `index.html`'s `<ol class="toc-list">` — otherwise unreachable
2. Update the previous chapter's `.chapter-nav` next-link
3. `primary-sources/chN-sources.html` + its `primary-source-reader.html` entry
4. Entries in `QUIZZES` (quizzes.html:245), `VOCAB` (vocabulary-cards.html:339),
   `SLIDES` (slideshows.html:425)
5. Edit `scripts/build_search_index.sh` — both `i <= 15` and `chapterTitles` are
   hard-coded; a ch16 is silently unindexed
6. A chapter entry in `data/chapters.json`, then `bash scripts/build_status.sh` —
   this regenerates the status tables in `REVIEW_STATUS.md`, `README.md`,
   `teachers.html` and `contributors.html`. **Never hand-edit those four surfaces**;
   CI fails on drift.

### Before finishing

```bash
npx html-validate <changed pages>
```

There is no test suite, linter config, or formatter in this repo.

### Style details

- Match the **em-dash encoding of the file you're editing**: ch6/ch7 and all
  `primary-sources/*.html` use `&mdash;`; other chapters use literal `—`.
- TOC `<li>` links carry **no numeral** (CSS `counter(toc-counter, upper-roman)`
  supplies it); the section `<h2>` hard-codes one.
- Never put anything but whitespace between `<section id="…">` and its `<h2>` — the
  search indexer's regex silently drops the section otherwise.

### Handling an incoming review

`TRIAGE.md` is the ten-step loop from "a review issue exists" to "the status tables are
correct." It is written to be executable from an issue URL alone. Counting policy lives
in `REVIEW_STATUS.md`; `TRIAGE.md` is procedure only.

### Git

Branch (never commit straight to `main` for content work), then PR. Content changes
need an issue first per `CONTRIBUTING.md`. Commit bodies use bullets and end with the
session trailer.

---

## 4. Known traps — verified, do not "fix" without asking

- **`/download_ch6_images.sh` (repo root) is a stale duplicate.** It calls the project
  "American Yawp Jr.", pulls over plain `http://`, sends no User-Agent, and has no
  skip-existing guard — it will overwrite good tracked images with error pages.
  `scripts/download_ch6_images.sh` is canonical. Deleting the root copy is a good
  cleanup task.
- **`scripts/build_search_index.sh` has two real regex bugs.** In
  `<(?:section[^>]*>)?\s*<h2[^>]*(?:id="([^"]*)")?[^>]*>` the leading literal `<` makes the
  "optional" `<section…>` prefix effectively mandatory, so **ch6 and ch7 index zero**
  **sections**; and the greedy `<h2[^>]*` consumes the id before the optional capture group
  can reach it, so **all 89 indexed sections carry `id: ""`** and every search result links
  to the top of a chapter with no anchor. Note ids live on `<section>`, not `<h2>`.
- **ch6.html and ch7.html are not templates.** Zero `<section>` elements, so reading
  time, read-aloud, and the PDF section picker are all degraded there. They carry four
  classes with no CSS anywhere: `body-text`, `section-heading`, `subtitle`,
  `attribution-footer`. They are also the only two files using
  `<div class="attribution">` (a Do-NOT-Use violation, but in the title block, not a
  citation — do not blind-fix).
- **`.chapter-resources` / `.resource-links` ship unstyled** in 10 chapters (zero CSS
  rules), and their 30 `?ch=N` links are inert — nothing reads `location.search`.
  Do not propagate this block to the other 5 chapters.
- **Deliberate decisions recorded in git, not bugs:** Lexend was reverted in `ed317a7`;
  OpenDyslexic ships with a Comic Sans fallback and no `@font-face` on purpose;
  `js/tts-kokoro.js` was intentionally orphaned in PR #42. Commit bodies are the
  authority over `DESIGN_GUIDE.md` here.
- **`index.html` links no stylesheet** — its design is an inline `<style>`.
  `css/index.css` (README.md:164) does not exist.
- **One external CDN dependency total** (PptxGenJS 3.12.0, pinned, slideshows.html).
  Do not add a second.
- **CI is advisory only.** `content-change-check.yml` runs on `pull_request` touching
  `ch*.html`, posts a comment, and never fails. Its `grep -oP` is GNU-only and will
  not run on macOS.

### Standards status (corrects a common assumption)

`standards.html` is **already substantially built** (404 lines): Common Core
**RH.6-8.1–9** and **WHST.6-8.1/2/9**, with a Quick Reference Matrix and
Feature-to-Standard Map. What's missing is **C3 Framework** and **NCSS**, which
`teaching.html:325` names while calling the guide "in development." Scope that work as
*add C3 + NCSS*, not *author from scratch*.

---

## 5. Model economy

- **fable / opus** — historical judgment, pedagogy, content accuracy, architecture,
  planning, anything touching how a source is framed for students.
- **sonnet** — routine content edits, markup work, script writing.
- **haiku subagents** — mechanical verification: link checking, HTML validation,
  metadata lookups, reading-level checks.

Project subagents live in `.claude/agents/`:

| Agent | Model | Use for |
|---|---|---|
| `link-checker` | haiku | Curl external hrefs (browser UA, 20s timeout, retry once) and report non-200s |
| `html-validator` | haiku | `html-validate` + tag balance + skip link / landmark / alt checks |
| `image-provenance-auditor` | sonnet | Verify an image's real artist, date, and license against every claim the page makes |
| `reading-level-checker` | haiku | Grade-level estimate, excluding quoted primary sources |

All four are read-only and report rather than edit. The agent registry loads at session
start, so an agent added mid-session is not callable until the session restarts.

---

## Authority map

When docs disagree, this order wins:

1. **Git commit bodies** — record deliberate decisions (fonts, orphaned files)
2. **The code itself** — 61/61 invariants, actual CSS, actual markup
3. **MAINTENANCE.md** — callout markup, Do-NOT-Use list, accessibility requirements
4. **DESIGN_GUIDE.md** — color, spacing, typography, roadmap (its callout spec is a
   partial, conflicting copy — prefer MAINTENANCE.md)
5. **CONTRIBUTING.md / README.md** — process and identity (both contain known stale
   claims: images "not stored in the repo", `css/index.css`, github.io as canonical)

Known-stale text to correct rather than obey: `MAPS.md` figure snippet and Ch1 status;
`MAINTENANCE.md` File Structure Reference (names two files that don't exist) and its
`primary-sources.css` body-text note; `DESIGN_GUIDE.md` alt-text percentage and Lexend;
`differentiation.html`'s four claims that Lexend is selectable.
