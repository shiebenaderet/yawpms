# Roadmap — American Yawp MS

Planned moves for **Q4 2026 and Q1 2027**. Each milestone has a definition of done
that is checkable, not aspirational. Where a finish line depends on volunteers who do
not exist yet, it is marked as a *stretch* and never as a requirement.

**Organizing principle:** deadlines come from the pacing guide. A chapter is fixed and
fact-checked the month *before* real classrooms reach it — not in the order that suits
the dependency graph. Work that no student or teacher would notice is scheduled around
that calendar, not ahead of it.

**Model tiers:** `[fable]` historical and pedagogical judgment · `[sonnet]` routine
edits, markup, scripts · `[haiku]` mechanical verification.

---

## Where we actually are (verified 2026-09-07)

- **15 chapters, all Draft, all 0/3 reviewers.** The bar for classroom-ready is 3.
  Status is duplicated across `REVIEW_STATUS.md`, the `README.md` table, and the
  `teachers.html` table — three shapes, hand-synced, and the sync has run zero times.
- **The Primary Source Reader is done and audited.** 61 sources, every one carrying a
  verified original-source link. **Chapter pages have had no equivalent pass.**
- **`standards.html` already ships** Common Core RH.6-8.1–9 and WHST.6-8.1/2/9 with a
  Quick Reference Matrix. C3 and NCSS are promised but absent — this is *extend*, not
  *author*.
- **Search is silently broken site-wide.** `scripts/build_search_index.sh` has two
  regex bugs: ch6/ch7 index zero sections, and all 89 indexed sections carry `id: ""`,
  so every result links to the top of a chapter with no anchor.
- **ch6 and ch7 have zero `<section>` elements**, which breaks reading time, read-aloud,
  the Print/PDF picker, and print pagination in those two files. ch6 is the largest chapter.
- **`scripts/audit_images.sh` reports zero missing while 16 refs are broken** — it
  matches `src="..."` only, not the JS `src:`/`img:` keys in slideshows and timeline.
- **Accessibility stops at the chapter boundary.** Skip links in 15 of 48 files;
  33 files have no `<main>`; `body.dark-mode` has 122 rules in `chapter.css` and
  **zero** in `pages.css` and `primary-sources.css`.
- **CI gates nothing.** One advisory workflow, PR-only, never fails. The last four
  commits went straight to main unchecked.
- **Reviewer recruitment is just beginning.** The feedback channel is live and producing.

---

## Milestone map

```
Q4 2026                                  Q1 2027
  M0 truth tooling ──┬─→ M1 ch6/7 + search ──┬─→ M5 companions + CI
                     │                       │
                     └─→ M5                  └─→ (M3)
  M2 review pipeline ──┬─→ M3 chapter doors ──→ M9 loop on real data
                       └─→ M9
  M4 accuracy ch5–ch8 ─────────────────────────→ M6 accuracy ch9–ch15
                       └────────────────────────→ M9
                                                  M7 accessibility (unblocked)
                                                  M8 standards C3+NCSS (unblocked)
```

M2, M4, M7 and M8 have **no blockers** — a common false dependency is assuming
accessibility or standards work waits on content review. It does not.

---

# Q4 2026

## M0 — Truth tooling and week-one triage · `S` · `[sonnet]` `[haiku]`
**Blocks:** M1, M5 · **Blocked by:** — · **Target:** end of September

The audit script lies, so nothing measured against it can be trusted. Fix the
instrument first, then the breakage it was hiding, then make CI capable of failing.

**Done when:**
- [ ] `scripts/audit_images.sh` matches `(src|img)\s*[:=]\s*"` across all 48 HTML files
      and uses no GNU-only flags (runs identically on macOS and ubuntu-latest). It
      reports the 16 broken refs before the fix and 0 after.
- [ ] All 12 broken `slideshows.html` slides and 4 `timeline.html` thumbnails resolve:
      9 mechanical renames plus 5 editorial picks made by the maintainer, licenses
      noted in `IMAGES_AUDIT.md`.
- [ ] `.github/workflows/site-check.yml` runs on **push to main and pull_request** and
      **fails** when any image ref is missing. Green on its first run after the fixes.
- [ ] `git rm` the root-level `download_ch6_images.sh` (stale, plain `http://`, no
      skip-existing) and `js/tts-kokoro.js` (loaded by zero pages).
- [ ] Minimal CSS for `.chapter-resources` / `.resource-links` so the block in the 10
      chapters that carry it looks intentional. (`?ch=N` behavior is M5.)
- [ ] Doc corrections: `CONTRIBUTING.md` stops claiming images aren't in the repo;
      `README.md` stops calling the audited Primary Source Reader "under construction";
      `teaching.html` stops calling the shipped standards guide "in development".

## M1 — ch6/ch7 get real skeletons, then search lands on a section · `M` · `[sonnet]` `[haiku]`
**Blocks:** M3, M5 · **Blocked by:** M0 · **Hard deadline: ~Nov 10 (pacing week 10)**

Full-year classes open ch6 around Nov 10 and ch7 two weeks later. The regex fix is
sequenced *after* the restructure on purpose — fixing it first would re-index ch6/ch7
as empty and force a second rebuild.

**Done when:**
- [ ] ch6 and ch7 wrap every h2-led block in `<section id="…">`, preserving every
      existing id so all 57 timeline anchors still resolve (re-run the anchor check:
      57/57). Ids move from the `h2` to the `section`, matching ch1–5 and ch8–15.
- [ ] Zero occurrences of `body-text`, `section-heading`, `subtitle`,
      `attribution-footer`, or `<div class="attribution">` in either file.
- [ ] The diff is **structural only** — `[haiku]` confirms extracted visible text is
      byte-identical before and after.
- [ ] In a browser: reading time displays, Read Aloud starts, and the Print/PDF picker
      lists all sections in both chapters.
- [ ] `build_search_index.sh` fixed for **both** bugs — the `<section>` prefix genuinely
      optional, and the id captured non-greedily from `<section id>` with an `h2`
      fallback. Rebuilt index has 15/15 chapters, ch6 contributes its sections, and
      **0 entries with `id: ""`**. Searching "Whiskey Rebellion" opens `ch6.html#whiskey`.
- [ ] `scripts/check_companion_sync.sh` exists and **fails** when a chapter `.vocab-box`
      term is missing from `VOCAB`, when any chapter is absent from
      `QUIZZES`/`VOCAB`/`SLIDES`, or when a timeline/slideshow anchor doesn't exist.
      Red on ch6/ch7 before the backfill, green after.
- [ ] `site-check.yml` gains three failing checks **in the same PRs as the fixes**:
      section-count/banned-class, index freshness (`git diff --exit-code` after rebuild),
      and companion sync.

## M2 — Review pipeline before review #1 · `M` · `[sonnet]` `[fable]`
**Blocks:** M3, M9 · **Blocked by:** — · Starts week 1, in parallel with M0/M1

This writes tables and YAML, not chapter HTML, so it is **not** blocked by ch6/ch7. The
first real review will otherwise hit undefined rules.

**Done when:**
- [x] `data/chapters.json` is the only hand-edited source of chapter status.
      `scripts/build_status.sh` regenerates the `REVIEW_STATUS.md` table, the
      `README.md` table, the `teachers.html` table, and a `contributors.html` reviewer
      section. Running it twice is a no-op; `site-check.yml` fails on drift.
- [x] `REVIEW_STATUS.md` states the counting rule in one paragraph, **written before the
      first review is recorded**: which verdicts increment N/3, that reviews pin to a
      chapter short SHA, that a substantive rewrite resets the count, and who adjudicates.
- [x] `chapter-review.yml` gains consent-to-credit with display name, chapter version,
      grade level, and piloted-in-class. A labeler applies `review:chNN`.
- [x] The Google Form's "Full Chapter Review" option is removed so every countable
      review arrives as a GitHub issue.
- [x] 15 pinned "Review slot" issues exist; claiming = commenting. `teachers.html` points
      to the slot with the fewest reviewers.
- [x] `TRIAGE.md` documents the loop in under 10 steps, written so an AI assistant can
      execute it from an issue URL alone.
- [x] Recruitment message sent through **three** existing channels, text committed to
      `docs/` for reuse.

## M3 — Every chapter is a door, and the front door tells the truth · `M` · `[sonnet]` `[haiku]`
**Blocks:** M9 · **Blocked by:** M1, M2

ch2–ch15 currently have no outbound feedback path and no Draft disclosure. The banner is
**generated** from `data/chapters.json` — adding it by hand would create a fourth status surface.

**Done when:**
- [x] `build_status.sh` stamps a one-line banner into each chapter: status, "reviewed by
      N of 3 educators", short SHA, an AI-assisted-draft disclosure, and links to Report
      an error / Review this chapter / Primary sources for this chapter. One template,
      fifteen files, no hand edits.
- [x] Every `primary-sources/chN-sources.html` links back to its chapter.
- [x] `index.html` has a visible "For Teachers" block linking all 10 tool pages.
- [x] All 48 files carry `meta description` + OG tags + favicon; a shared chapter link
      renders as a card in Google Classroom or Slack.
- [x] **Volume II demand has a home** — a pinned Discussion linked from `index.html`,
      plus a Volume II question on the Google Form. The opening post states that Volume
      II is not planned until chapters reach 3/3 and what a "yes" would require.

## M4 — Accuracy pass wave 1: ch5, ch6, ch7, ch8 · `L` · `[fable]` `[haiku]`
**Blocks:** M6, M9 · **Blocked by:** — · **ch5 by Oct 15 · ch6 by Oct 31 · ch7 by Nov 15 · ch8 by Dec 20**

Chapter pages have had no accuracy audit while all 61 primary sources have. Rather than a
15-chapter sweep finishing after the school year, each chapter is checked the month before
students open it. Method mirrors the proven Primary Source Reader audit.

**Done when:**
- [ ] `docs/ACCURACY_AUDIT.md` holds a per-chapter ledger: every date, proper name,
      statistic, direct quotation and causal claim, each with a verdict
      (verified / corrected / caveated / could not verify) and the source consulted —
      the corresponding American Yawp chapter plus one independent reference. The method
      is written once in `MAINTENANCE.md` so M6 repeats it.
- [ ] Every "corrected" row has a PR that **also** updates that chapter's quiz answers,
      vocab deck, slideshow text and timeline entry in the same PR, with `site-check.yml`
      green.
- [ ] Each chapter's "could not verify" rows post as **one issue linked from that
      chapter's Review slot**, so a volunteer confirms a short list rather than
      discovering from scratch.
- [ ] Figcaptions in ch5–ch8 end with an attribution clause and a "View original" link
      mirroring the `ps-source-link` pattern. Anything unprovable is replaced and the
      swap logged in `IMAGES_AUDIT.md`. *(No zero-unknown promise across all 124 images.)*
- [ ] **Editorial items closed here** because reviewers would otherwise re-find them:
      Source 9.3 (Burnett Trail of Tears memoir, 1890) carries an in-page sourcing caveat
      on the 52-year gap and contested authenticity, framed as a source-reliability
      exercise; the 1769 Charleston broadside (`ch11-slave-broadside.jpg`) is placed in
      ch3- or ch4-sources with context and a verified link, or explicitly declined in an
      issue; the `ch8-erie-canal.jpg` orphan is resolved.
- [ ] Each passed chapter's banner reads **"AI-assisted fact check completed <date>; not
      yet reviewed by a historian"** — worded so it cannot be mistaken for human review.

---

# Q1 2027

## M5 — Companion finish and CI consolidation · `S` · `[sonnet]` `[haiku]`
**Blocked by:** M0, M1

**Done when:**
- [ ] `quizzes.html`, `vocabulary-cards.html`, `slideshows.html` and `timeline.html` read
      `?ch=N` via `URLSearchParams` and open that chapter; invalid values fall back.
- [ ] ch1, ch3, ch8, ch14, ch15 gain the `.chapter-resources` block.
- [ ] `content-change-check.yml` is folded into `site-check.yml` — exactly one workflow.
      The advisory comment covers all 11 PR-template items, and the template marks each
      "automated" or "manual" so CI and the checklist agree.
- [ ] One deliberate breaking PR is opened, observed to fail both checks, and closed.
- [ ] `CONTRIBUTING.md` documents `bash scripts/check_all.sh` as the local pre-commit step.

## M6 — Accuracy pass wave 2: ch9–ch15 · `L` · `[fable]` `[haiku]`
**Blocked by:** M4 · **ch9 by Jan 15 · ch10–11 by Feb 10 · ch12–15 by Mar 15**

**Done when:**
- [ ] Ledgers complete in the M4 format, corrections merged via green PRs, companion data
      updated in the same PR, figcaption attribution added, "could not verify" issues filed.
- [ ] ch9, ch11, ch13–15 additionally have every "Whose Voices Were Left Out" and
      "Multiple Perspectives" callout reviewed against current scholarly consensus, with
      changes logged.
- [ ] Thin vocab decks (ch3/ch4/ch5/ch8, 6 terms each) and 7-question quizzes (ch8, ch12)
      are **flagged for human reviewers, not expanded here.**
- [ ] Summary table shows 11/15 chapters passed, with ch1–ch4 listed and the reason.

## M7 — Accessibility beyond the chapter boundary · `M` · `[sonnet]` `[haiku]`
**Blocked by:** — (sits in Q1 only because Q4 is full of calendar-bound work)

A student who enables dark mode in ch1 and clicks into a primary source is flashed white.
`CONTRIBUTING.md` actively recruits SPED/ELL reviewers who would hit this in minute one.

**Done when:**
- [ ] All 48 files have a skip link as the first focusable element targeting exactly one
      `<main id="main-content">`, plus `aria-current="page"`.
      `scripts/check_a11y_landmarks.sh` joins `site-check.yml` as a failing check.
- [ ] `pages.css` and `primary-sources.css` define the same `body.dark-mode` / `.sepia` /
      `.high-contrast` tokens and `:focus-visible` rules as `chapter.css`; a theme applier
      honoring `yawp_theme` loads on all 48 pages. No white flash when navigating between them.
- [ ] `reader-tools.js` loads on all 15 primary-source pages.
- [ ] One keyboard-only pass and one **VoiceOver** pass (~45 min) across five
      representative pages, findings filed as issues.
- [ ] `DESIGN_GUIDE.md` bumped to v1.1.0, stating honestly which earlier claims were
      chapter-only, and deferring the callout icon system with a reason.

## M8 — Standards: extend with C3 and NCSS · `M` · `[fable]`
**Blocked by:** — · Lands in Q1 for **next year's** adoption season

**Done when:**
- [ ] `standards.html` gains a C3 Framework section (Dimension 2 History indicators
      D2.His.1–16.6-8; Dimension 4 D4.1–8.6-8) and an NCSS section covering the four
      themes named on `teaching.html`, with rows in the existing Quick Reference Matrix format.
- [ ] Every indicator code and quoted descriptor is checked **against the published
      documents, not from memory**; a `docs/` note records the editions consulted.
- [ ] `teaching.html` updated from "in development" to shipped, with a link.
- [ ] An issue titled "Curriculum coordinator: check the C3/NCSS mapping" is opened and
      linked, so the ask is visible — but **no DoD item depends on that volunteer**.

## M9 — The review loop runs on real data · `M` · `[fable]`
**Blocked by:** M2, M3, M4

**Done when:**
- [ ] **Checkpoint written in Discussions by Dec 20, 2026.** If ≥5 real reviews have
      arrived since M2 shipped, Q1 proceeds as scheduled. If fewer than 5, Q1 opens with
      direct outreach (state social-studies council, the American Yawp community, one
      district pilot) **before** M8 starts, and M8 moves to Q2.
- [ ] Every review is recorded within 7 days of arrival with zero hand edits to any
      status table. Every factual-error item has a merged PR or a written answer.
- [ ] `TRIAGE.md` has been walked end-to-end on the first real review and corrected.
- [ ] `contributors.html` lists every consenting reviewer, generated.
- [ ] *Stretch, not required:* ch1–ch4 each at 1/3 or better by Mar 15. A maintainer
      classroom pilot counts as one labeled review, **never as a third**.
- [ ] `teachers.html` states the next frontier ("Units 1–2 approved by June 2027").

---

## Deliberately not scheduled

- **AI accuracy pass on ch1–ch4.** Classrooms pass these before M4 begins, so the work
  would land after every student who reads them this year has moved on. They are also the
  chapters most likely to be claimed first by human reviewers. Q2 2027.
- **Any promise that chapters reach 3/3 Approved.** 45 reviews from a recruitment effort
  that began this month is not credible. Honest exit state: the pipeline records reviews
  unattended, every chapter has a door, 11 of 15 carry a fact-check date, some chapters
  sit at 1/3–2/3.
- **A full 124-image licensing manifest with zero unknowns.** Real exposure, but the
  finish line is not in the maintainer's control — provenance chains dead-end. Covered
  per-chapter by M4/M6 instead.
- **Callout icons, grayscale color-independence test, F-pattern work, pull quotes,
  learning objectives, Key Takeaways boxes** (DESIGN_GUIDE Priority 2–3). New content
  across 15 files that scarce reviewers would have to re-review — and the icon system
  contradicts v1.0.2's own removal of emojis from headings.
- **NVDA/JAWS testing.** The maintainer has a Mac; VoiceOver is in M7. Windows AT testing
  is a recruitment ask, not a milestone that would produce a checkbox instead of a test.
- **General companion-resource sync automation** regenerating `QUIZZES`/`VOCAB`/`SLIDES`
  from chapter edits. The objects are keyed cleanly 1–15; the only syncs that break on day
  one are status (M2/M3 generator) and vocab drift (M1's failing check). Content sync stays
  human-plus-failing-CI.
- **Wiring Kokoro TTS.** Deleted in M0. Browser-native `speechSynthesis` already works.

---

## Review cadence

Revisit this roadmap at the **Dec 20 checkpoint** (M9) and again at the end of Q1 2027.
When a milestone completes, update `CLAUDE.md` if it changes a fact that file asserts —
in particular the search-index bug in section 4 and the `.claude/agents/` note in section 5.
