# Review Status

> **Do not edit the table below by hand.** It is generated from `data/chapters.json` by
> `bash scripts/build_status.sh`, which also rewrites the tables in `README.md`,
> `teachers.html` and `contributors.html`. CI fails if they drift.


Each chapter must be reviewed by at least **3 people** before it is considered ready for classroom use.

<!-- BEGIN generated:status-table -->
| Ch. | Title | Status | Reviewers | Notes |
|-----|-------|--------|-----------|-------|
| 1 | Indigenous America | Draft | 0 / 3 |  |
| 2 | Colliding Cultures | Draft | 0 / 3 |  |
| 3 | British North America | Draft | 0 / 3 |  |
| 4 | Colonial Society | Draft | 0 / 3 |  |
| 5 | The American Revolution | Draft | 0 / 3 |  |
| 6 | A New Nation | Draft | 0 / 3 |  |
| 7 | The Early Republic | Draft | 0 / 3 |  |
| 8 | The Market Revolution | Draft | 0 / 3 |  |
| 9 | Democracy in America | Draft | 0 / 3 |  |
| 10 | Religion and Reform | Draft | 0 / 3 |  |
| 11 | The Cotton Revolution | Draft | 0 / 3 |  |
| 12 | Manifest Destiny | Draft | 0 / 3 |  |
| 13 | The Sectional Crisis | Draft | 0 / 3 |  |
| 14 | The Civil War | Draft | 0 / 3 |  |
| 15 | Reconstruction | Draft | 0 / 3 |  |
<!-- END generated:status-table -->

## How Reviews Are Counted

*Written before the first review was recorded, so that no rule is ever invented in
response to a particular verdict.*

A chapter needs **3 counted reviews** to reach Approved. A review counts when:

- its assessment is **Ready to use**, or
- its assessment is **Needs revision** and every factual-error item it raised has been
  closed — either fixed in a merged PR or answered in writing on the issue.

A review of **Needs significant work** does not count. It moves the chapter to *Under
Review* and holds it there until the chapter is revised; the reviewer is invited to
re-review afterward, and that re-review counts normally.

Other rules:

- **Reviews are pinned to a version.** Each reviewer records the chapter's short commit
  SHA. A review of an old version stays on the record, but if the maintainer declares a
  **substantive rewrite** of a chapter, the count resets to 0 and prior reviewers are
  asked to look again. Copy edits, image swaps and typo fixes are not substantive.
- **A classroom pilot by the maintainer counts as one review**, labeled as a pilot. It
  can never be the third review — a chapter cannot reach Approved on the strength of
  its own author's classroom.
- **One reviewer, one count per chapter.** A second review of the same chapter by the
  same person is welcome but does not increment the number.
- **Reviewers are credited only with consent.** The chapter-review form asks; unchecked
  means the review still counts and the name is not published.
- **The maintainer adjudicates** disagreements between reviews, and records the reasoning
  in the chapter's `notes` field in `data/chapters.json`.

Status is **derived from the count**, never set by hand: 0 counted → Draft, 1–2 →
Under Review, 3+ → Approved.

## Status Definitions

- **Draft** — AI-generated, not yet reviewed by a human.
- **Under Review** — At least one reviewer is actively reviewing.
- **Approved** — Reviewed and approved by 3+ teachers/historians. Cleared for classroom use.

## How to Review

See the [Teachers Hub](https://shiebenaderet.github.io/yawpms/teachers.html) for full instructions, or open a [Chapter Review issue](https://github.com/shiebenaderet/yawpms/issues/new?template=chapter-review.yml).
