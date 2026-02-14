# Maps Plan: Chapters 1–15

This document tracks the plan to add at least one substantive map to every chapter of Volume I. For each chapter there are three candidate maps (A, B, C); the **Chosen** column indicates which to use (or multiple, if desired).

**Already in the book** (images/ + HTML): Ch2 (Waldseemüller), Ch3 (slave ship diagram), Ch11 (slave population 1860), Ch12 (Mexican Cession), Ch13 (Reynolds political map).

---

## Summary Table

| Ch | Topic | A | B | C | Chosen | In book? |
|----|-------|---|---|---|--------|----------|
| 1 | Indigenous America | Native American cultural regions (color-coded) | Beringia land bridge | Global human migration routes | | No |
| 2 | Colliding Cultures | Waldseemüller map (1507, first "America") | European colonial claims (color-coded) | Columbus's 4 voyage routes | A | **Yes** |
| 3 | British North America | 13 Colonies map (regions labeled) | 13 Colonies (more geographic detail) | 18th-c Virginia colony map | | No (has slave ship) |
| 4 | Colonial Society | Triangular trade routes | Atlantic slave trade routes w/ numbers | (use slave ship diagram from ch3) | C = reuse ch3 | No |
| 5 | American Revolution | 1775 military campaigns map | All major Rev War battle locations | Battle of Yorktown map | | No |
| 6 | A New Nation | US territorial map 1789 | US territorial map 1790 | Northwest Territory locator | | No |
| 7 | Early Republic | Louisiana Purchase (National Atlas) | All US territorial acquisitions | William Clark's 1810 expedition map | | No (has Lewis & Clark image) |
| 8 | Market Revolution | Canals & railroads 1840 (LOC) | Erie Canal route + elevation profile | Erie Canal proposed route (1821) | | No |
| 9 | Democracy in America | Trail of Tears (NPS official) | Five Tribes removal routes (color-coded) | Land cessions under Jackson | | Has Trail of Tears image |
| 10 | Religion & Reform | UGRR network (Public Domain Mark) | UGRR routes (Siebert 1898 scholarly) | UGRR routes (large format) | | No |
| 11 | Cotton Revolution | Slave population density 1860 | Cotton production by county 1860 | Spread of slavery over time | A | **Yes** |
| 12 | Manifest Destiny | Mexican Cession | Full territorial acquisitions | Oregon Territory / 49th parallel | A | **Yes** |
| 13 | Sectional Crisis | Reynolds political map 1856 | Free vs slave states post Kansas-Nebraska | Compromise of 1850 territories | A | **Yes** |
| 14 | Civil War | Union vs Confederate states + battles | Major battles map (both theaters) | Anaconda Plan cartoon map | | No |
| 15 | Reconstruction | 5 military districts map | Territorial evolution / readmission | 1868 electoral map | | No |

---

## Chapter-by-Chapter Checklist

### Chapter 1 — Indigenous America
- [ ] **A.** Native American cultural regions (color-coded) — *source TBD; e.g. LOC or NPS*
- [ ] **B.** Beringia land bridge — *Wikimedia/LOC*
- [ ] **C.** Global human migration routes — *optional*
- **Suggested placement:** After "A Continent of Nations" (cultural regions); Beringia near "The First Americans."
- **Download script:** Add to `scripts/download_ch1_images.sh` when URLs are set.
- **HTML:** Add `<figure>` with map image + figcaption in `ch1.html`.

### Chapter 2 — Colliding Cultures
- **A.** Waldseemüller map (1507) — **DONE** (`waldseemuller-map.jpg`, in ch2.html).
- [ ] **B.** European colonial claims (color-coded) — optional second map.
- [ ] **C.** Columbus's 4 voyage routes — optional.
- **Download script:** Already in `download_ch2_images.sh`.

### Chapter 3 — British North America
- [ ] **A.** 13 Colonies map (regions labeled)
- [ ] **B.** 13 Colonies (more geographic detail)
- [ ] **C.** 18th-c Virginia colony map
- **Note:** Slave ship diagram (Brookes) already in chapter; Ch4 will reuse it.
- **Download script:** Add map(s) to `scripts/download_ch3_images.sh`.

### Chapter 4 — Colonial Society
- [ ] **A.** Triangular trade routes map
- [ ] **B.** Atlantic slave trade routes w/ numbers
- **C.** Reuse slave ship diagram from Ch3 — reference `images/ch3/slave-ship-brookes.jpg` in ch4.html (no new asset).
- **Download script:** Only if adding A or B; C needs no new download.

### Chapter 5 — American Revolution
- [ ] **A.** 1775 military campaigns map
- [ ] **B.** All major Rev War battle locations
- [ ] **C.** Battle of Yorktown map
- **Suggested placement:** Campaigns near military narrative; Yorktown near surrender.
- **Download script:** Add to `scripts/download_ch5_images.sh`.

### Chapter 6 — A New Nation
- [ ] **A.** US territorial map 1789
- [ ] **B.** US territorial map 1790
- [ ] **C.** Northwest Territory locator
- **Download script:** Add to `scripts/download_ch6_images.sh` (create if missing).

### Chapter 7 — Early Republic
- [ ] **A.** Louisiana Purchase (National Atlas)
- [ ] **B.** All US territorial acquisitions
- [ ] **C.** William Clark's 1810 expedition map
- **Note:** Lewis and Clark painting already in chapter; maps would complement it.
- **Download script:** Add to `scripts/download_ch7_images.sh`.

### Chapter 8 — Market Revolution
- [ ] **A.** Canals & railroads 1840 (LOC)
- [ ] **B.** Erie Canal route + elevation profile
- [ ] **C.** Erie Canal proposed route (1821)
- **Download script:** Add to `scripts/download_ch8_images.sh`.

### Chapter 9 — Democracy in America
- **A.** Trail of Tears — already have `trail-of-tears.jpg` (title + in body). Consider NPS official map if different.
- [ ] **B.** Five Tribes removal routes (color-coded)
- [ ] **C.** Land cessions under Jackson
- **Download script:** Add any new map to `scripts/download_ch9_images.sh`.

### Chapter 10 — Religion & Reform
- [ ] **A.** UGRR network (Public Domain Mark)
- [ ] **B.** UGRR routes (Siebert 1898 scholarly)
- [ ] **C.** UGRR routes (large format)
- **Download script:** Add to `scripts/download_ch10_images.sh`.

### Chapter 11 — The Cotton Revolution
- **A.** Slave population density 1860 — **DONE** (`slave-population-map.jpg`, in ch11.html).
- [ ] **B.** Cotton production by county 1860 — optional.
- [ ] **C.** Spread of slavery over time — optional.
- **Download script:** Already in `download_ch11_images.sh`.

### Chapter 12 — Manifest Destiny
- **A.** Mexican Cession — **DONE** (`mexican-cession-map.jpg`, in ch12.html).
- [ ] **B.** Full territorial acquisitions
- [ ] **C.** Oregon Territory / 49th parallel
- **Download script:** Add B/C to `scripts/download_ch12_images.sh` if desired.

### Chapter 13 — The Sectional Crisis
- **A.** Reynolds political map 1856 — **DONE** (`reynolds-political-map.jpg`, in ch13.html).
- [ ] **B.** Free vs slave states post Kansas-Nebraska
- [ ] **C.** Compromise of 1850 territories
- **Download script:** Add B/C to `scripts/download_ch13_images.sh` if desired.

### Chapter 14 — Civil War
- [ ] **A.** Union vs Confederate states + battles
- [ ] **B.** Major battles map (both theaters)
- [ ] **C.** Anaconda Plan cartoon map
- **Download script:** Add to `scripts/download_ch14_images.sh`.

### Chapter 15 — Reconstruction
- [ ] **A.** 5 military districts map
- [ ] **B.** Territorial evolution / readmission
- [ ] **C.** 1868 electoral map
- **Download script:** Add to `scripts/download_ch15_images.sh`.

---

## One script for all maps

**`scripts/download_all_maps.sh`** downloads every chapter map in one go into `images/ch1/` … `images/ch15/`. All sources are license-safe (public domain or CC). Run:

```bash
bash scripts/download_all_maps.sh
```

If a download shows `[FAIL]`, run the script again later (Wikimedia may rate-limit) or run the specific `scripts/download_chN_images.sh` for that chapter.

---

## Workflow

1. **Pick** which of A/B/C (or combo) to use for each chapter.
2. **Find** a high-quality, license-friendly image (Wikimedia, LOC, NPS, National Atlas; note Public Domain / CC).
3. **Add** the URL to the chapter’s `scripts/download_chN_images.sh` (create script if needed).
4. **Run** `bash scripts/download_chN_images.sh` and confirm files appear in `images/chN/`.
5. **Insert** in the chapter HTML: `<figure><img src="images/chN/filename.jpg" alt="..." loading="lazy"><figcaption>...</figcaption></figure>` in a logical spot in the narrative.

---

## Notes

- **Ch4 C:** Reuse Ch3 asset by using `src="images/ch3/slave-ship-brookes.jpg"` in ch4.html so one diagram serves both chapters.
- **Ch6:** Check whether a download script exists; create `scripts/download_ch6_images.sh` if not.
- **Licenses:** Prefer public domain or CC BY/CC BY-SA; note source in figcaption (e.g. "Library of Congress," "NPS," "Wikimedia").
