# The cheap audit protocol

How to audit a chapter for roughly a tenth of what chapter 8 cost.

The ch8 audit was thorough and expensive. This is the same audit, restructured around one
finding from its own data: **the lanes grounded in a retrievable artifact were both cheaper
and far more accurate than the lanes doing general historical reasoning.**

| ch8 lane | proposals | survived refutation intact |
|---|---|---|
| images (Commons API + the file itself) | 7 | 6 |
| quotations (a downloadable book) | 7 | 7 |
| numbers (the chapter file itself) | 9 | 6 |
| sections I&ndash;II (general reasoning) | 11 | 6 |
| sections III&ndash;IV (general reasoning) | 9 | **0** |
| sections V&ndash;VI (general reasoning) | 10 | **1** |

The two most serious findings in that chapter were nearly free to obtain. A CC BY-SA 4.0
photograph was captioned "(Public domain, 19th century)" &mdash; one Commons API call returns
`AttributionRequired: true`. A fabricated primary source was caught by `grep` against a
downloaded text file. Neither needed a language model at all; both cost one.

---

## The four tiers

Work down the list. **Never start a tier before finishing the one above it** &mdash; each tier
shrinks the input to the next, and the expensive tiers are priced per token of input.

| Tier | Who | Cost | What |
|---|---|---|---|
| **0** | `scripts/audit_prep.sh` | free | Licences, duplicates, stray tags, invented quotations, number inventory, quotation triage |
| **1** | local model | free | Claim extraction, reported-speech drafts, caption drafts |
| **2** | Haiku subagents | cents | Verify each extracted quotation against the prefetched source; confirm dates against one named reference |
| **3** | Claude (Opus/Sonnet) | dollars | Adjudicate what tiers 0&ndash;2 flag, look at images, write final prose |

Two settings matter before you spend anything:

- **Turn ultracode off.** On, it makes Claude default to spawning a multi-agent workflow for
  every substantive task. That alone is a large multiplier.
- **Let subagents use Haiku for retrieval.** The ch8 agents inherited Opus for everything,
  including "fetch this JSON and read one field." `CLAUDE.md` &sect;5 already specifies haiku
  for mechanical verification; the run did not honour it.

---

## Running it on a chapter

### 1. Branch

```bash
git checkout -b ch9-accuracy-audit
```

### 2. Tier 0 &mdash; free, always first

```bash
bash scripts/audit_prep.sh 9
```

Writes `audit/ch9/` (gitignored):

| file | contents |
|---|---|
| `licences.tsv` | real artist / date / licence / `attribution_required` per image, from Commons |
| `quotations.jsonl` | every quoted run of 40+ characters, flagged `in_yawp` true/false |
| `numbers.txt` | every number with the lines it appears on &mdash; consistency candidates |
| `../_yawp/NN.txt` | **all fifteen** Yawp Volume I chapters, cached once and shared by every chapter audit |

Read the terminal output before going further. On ch9 it reported, in about twenty seconds:
7 composite voices punctuated as real quotations, 3 figcaptions with no credit line at all,
and a quotation triage that correctly surfaced the Jackson/Marshall apocrypha and the Burnett
letter as the two highest-risk quotations in the chapter.

**`in_yawp` is the column that matters.** A quotation found anywhere in the Yawp is inherited
and carries its sourcing; the report names the chapter it came from. One found nowhere was
written or altered during adaptation &mdash; and that is where fabrications live. ch8's fake
Robinson passage was in that group.

**Why it searches all fifteen chapters, not the same-numbered one.** The MS chapters do not map
1:1 onto the Yawp's. MS ch9 carries the entire Indian Removal story, but the Yawp puts Cherokee
removal in **chapter 12**: its own chapter 9 has Cherokee=0, Worcester=0, "Removal Act"=0. The
first version of this script compared ch9 only against Yawp ch9 and duly reported every
quotation as unverified &mdash; noise, not signal, and noise that costs money downstream. Never
assume the parent chapter shares the number.

### 3. Tier 1 &mdash; the local model

Three jobs. Run them one section at a time, not on the whole file: a small model's accuracy
falls off a cliff as context grows, and a chapter is 400&ndash;550 lines.

Each job is **extraction or drafting, never judgment**. The model is never asked whether
anything is true.

#### Job A &mdash; claim inventory

> You are indexing a middle-school history textbook chapter. You are NOT checking whether
> anything is true. Do not correct anything. Do not comment.
>
> For every factual assertion in the text below, output one JSON object per line:
>
> `{"line": <line number>, "type": "<type>", "text": "<exact words from the chapter>"}`
>
> `type` is exactly one of: date, name, statistic, quotation, causal, consistency, image.
>
> RULES:
> - `text` must be copied **character for character** from the chapter. Never paraphrase,
>   summarise, tidy, or complete a sentence. If you cannot copy it exactly, skip it.
> - `line` is the line number the text appears on.
> - Output JSON lines only. No preamble, no markdown fences, no explanation.
>
> Chapter text follows, with line numbers:
> ```
> <paste one section, numbered>
> ```

Append output to `audit/ch9/claims.jsonl`. Number the lines for it with:

```bash
grep -n '<section id=' ch9.html                              # find the boundaries
awk 'NR>=116 && NR<=143 {printf "%d\t%s\n", NR, $0}' ch9.html # one section (ch9 "suffrage")
```

#### Job B &mdash; reported-speech rewrites

Tier 0 lists the composite voices. For each one:

> This is a "Multiple Perspectives" entry in a middle-school textbook. The words in quotation
> marks are invented &mdash; nobody actually said them &mdash; but the punctuation makes them
> look like a real quotation, which misleads students.
>
> Rewrite it as reported speech. Keep every argument and the same reading level. Remove the
> quotation marks. Do not add a disclaimer and do not address the reader. Keep the format
> `<div class="perspective"><strong>Group:</strong> ...</div>`.
>
> `<paste the div>`

Write to `audit/ch9/perspectives.md`. These are drafts for review &mdash; **the local model
never touches `ch9.html`.**

#### Job C &mdash; caption drafts

Only for the files Tier 0 listed as having no credit line, and only using facts already in
`licences.tsv`:

> Write a figcaption for a middle-school history textbook. Use ONLY the facts given. Invent
> nothing &mdash; no dates, no places, no artist names beyond what is listed. If a fact is
> missing, leave it out rather than guessing. Two to three sentences.
>
> Existing caption: `<paste>`
> Artist: `<from licences.tsv>` &middot; Date: `<...>` &middot; Licence: `<...>` &middot; Source: `<...>`

Write to `audit/ch9/captions.md`.

### 4. The gate &mdash; before spending a cent

```bash
bash scripts/check_handoff.sh 9
```

Every claim must quote the chapter **verbatim**. That is mechanically checkable, so
hallucinations die here for free instead of during a paid review. The script writes
`claims.accepted.jsonl` and exits non-zero if more than 30% was rejected.

**A high reject rate means the prompt asked for judgment instead of extraction.** Fix the
prompt and re-run locally. Do not hand a bad run to a paid model &mdash; reviewing invented
claims costs more than doing the work, which is exactly how a "free" local pass turns
expensive.

### 5. Hand back

Give Claude these four things and nothing else:

1. The Tier 0 terminal output
2. `audit/ch9/claims.accepted.jsonl`
3. `audit/ch9/perspectives.md` and `captions.md`
4. The branch name

A useful opening message:

> Tier 0 and Tier 1 are done for ch9 on branch `ch9-accuracy-audit`. Output is in `audit/ch9/`.
> Use Haiku subagents for verification. Skip general historical reasoning over the whole
> chapter &mdash; audit only what the accepted claims and the Tier 0 flags point at. Show me
> the corrections before applying.

---

## What never to ask the local model

Not because it is rude to, but because its answers here cost more to check than to produce:

- **Any verdict** &mdash; "this date is wrong", "this quotation is fabricated". A verdict has
  to be re-verified from scratch, so it saves nothing and risks a confident wrong correction.
- **Anything about an image.** A text model cannot see one and will describe what the filename
  implies. ch8's licence violation was caught by *looking* at the photograph and seeing a
  modern guardrail.
- **The refutation pass.** Small models are agreeable and will rubber-stamp. In ch8 the
  refuters killed 12 of 53 proposals and rewrote 29 of the 41 they upheld. A pass that
  approves everything is not a cheap version of that; it is a liability, because a bad
  correction arrives wearing the authority of having been checked.
- **Edits to `ch*.html`.** Drafts go in `audit/`. Applying is a reviewed step.

---

## Two traps worth knowing

**Grep is line-based; plain-text books wrap at about 70 characters.** During the ch8 audit the
first search made the *correct* Robinson replacement look fabricated &mdash; four of its
phrases spanned line breaks and returned zero hits. Normalise whitespace before searching a
book, or you will delete a genuine passage. `check_handoff.sh` normalises for this reason.

**Normalise punctuation, not just whitespace.** Searching Joseph Story's *Life and Letters* for
"The reign of King Mob seemed triumphant" returned zero hits. The OCR renders it `King " Mob"`
&mdash; Story put the words in quotation marks &mdash; so a literal substring search failed on
*interior punctuation*, exactly as the ch8 search failed on *line wrapping*. Strip to letters
and spaces before comparing. Both failures would have produced a confident, false "this
quotation is fabricated."

**Sanity-probe the substrate before concluding a quotation is absent.** Bassett's
*Correspondence of Andrew Jackson* vol. 4 was genuinely searchable (Jackson 1110, Eaton 559,
"my dear sir" 93), so an absence there is evidence. The *Papers of Andrew Jackson* vol. 7 is
lending-restricted and returned 33k characters with "Jackson" appearing twice &mdash; an
absence there means nothing. Only the first kind counts.

**Strip tags before looking for quotations.** The first version of `audit_prep.sh` scraped
`href`, `content` and inline `style` attributes as "quotations" and reported 34 of 34
unverifiable. After stripping tags it found 18 real ones. Noise in a triage step is worse than
no triage, because it gets paid for downstream.
