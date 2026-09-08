# Triage: what to do when a review arrives

The loop from "a review issue exists" to "the status tables are correct." Written so a
Claude Code session can execute it from the issue URL alone. Ten steps.

**Counting rules live in [REVIEW_STATUS.md](REVIEW_STATUS.md).** This file is the
procedure; that file is the policy. If they ever disagree, the policy wins.

---

### 1. Read the issue

```bash
gh issue view <NUMBER> --json number,title,body,labels,author,createdAt
```

Pull out: chapter number, chapter version (short SHA), overall assessment, the
factual-error list, display name, and whether the credit box is checked.

### 2. Confirm the label

The `label-review` job should have applied `review:chNN`. If it didn't (the chapter
dropdown was left blank, or the body was edited into a shape the regex misses), apply it
by hand: `gh issue edit <NUMBER> --add-label review:ch07`.

### 3. Split factual errors into their own issues

Every item in the "Factual errors or inaccuracies" field becomes one
`content-revision` issue, each linked back to the review. One issue per claim — a review
listing four errors becomes four issues, because they will be fixed, verified and closed
independently.

```bash
gh issue create --template content-revision.yml --label "review:ch07"
```

Interpretation and pedagogy suggestions do **not** become issues here. Record them in
the chapter's `notes` in `data/chapters.json` and leave them for the accuracy pass.

### 4. Check whether the version still matters

```bash
git log --oneline <SHA>..HEAD -- ch7.html
```

If the chapter changed since the reviewed SHA, check each reported error against the
current file before opening an issue — it may already be fixed. Say so on the review
issue rather than silently dropping the item.

### 5. Fix what is clearly wrong

Corrections go in one PR per chapter, not per error. **A chapter text change fans out**
— the PR must also update that chapter's quiz answers, vocab deck, slideshow text and
timeline entry. See the downstream checklist in the PR template.

### 6. Answer what you are not changing

A reviewer who gets no response does not come back. If an item is not being changed,
write why on the issue: the source disagrees, the simplification is deliberate for grade
6–8, the scholarship is contested. Close it with the reasoning attached.

### 7. Record the review

Edit `data/chapters.json` — the **only** file you hand-edit:

```json
{
  "number": 7,
  "reviewers": [
    {
      "display_name": "Jordan Rivera",
      "consent_to_credit": true,
      "issue": 42,
      "sha": "58e1af7",
      "assessment": "Needs revision",
      "counts": true,
      "piloted": false,
      "recorded": "2026-09-15"
    }
  ]
}
```

Set `counts` per the policy: `true` for *Ready*; `true` for *Needs revision* **only once
every factual-error issue it raised is closed**; `false` for *Needs significant work*.
A maintainer classroom pilot gets `"piloted": true` and can never be the third count.

### 8. Regenerate

```bash
bash scripts/build_status.sh
```

This rewrites the tables in `REVIEW_STATUS.md`, `README.md`, `teachers.html` and
`contributors.html`. Never edit those four by hand; CI fails on drift.

### 9. Verify before you close

```bash
bash scripts/audit_images.sh --strict
bash scripts/check_companion_sync.sh     # once M1 lands
npx --yes html-validate ch7.html
git diff --exit-code -- REVIEW_STATUS.md README.md teachers.html contributors.html
```

The last one must be clean *after* step 8 — if it isn't, the generator didn't run.

### 10. Close the loop with the reviewer

Comment on the review issue: what was fixed (with PR links), what wasn't and why, and
where the chapter now stands (`N of 3`). Then close it. If they consented to credit,
their name is already on the contributors page from step 8 — say so.

---

## Service level

**Record every review within 7 days of arrival.** Recording is step 7 and takes minutes;
fixing can take longer and does not block it. A reviewer should never wonder whether
their evening disappeared into a void.

## When a chapter reaches 3 of 3

`build_status.sh` flips it to Approved on its own. Announce it — a pinned Discussion
comment and a note on the chapter's Review slot. The bar is the point of the project;
crossing it should be visible.
