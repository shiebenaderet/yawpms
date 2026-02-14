# Images Audit: What’s Referenced, What’s Missing, What to Run

This document compares our chapter HTML with the [American Yawp](https://www.americanyawp.com) source, lists every image the book expects, and explains why some images don’t load and how to fix it.

**Recent changes:** The audit’s recommended images (Ch1 Crooked Beak mask, Ch2 Castello Plan, New Orleans 1728, Battle of Gravelines, Ch3 Virginia fishing) are now in the download scripts and in the chapter HTML. The old `scripts/images/` folder and `scripts/download-images.sh` have been removed; use only `download_all_images.sh` and `download_all_maps.sh` (and per-chapter scripts) which write to repo-root `images/`. **Ch3:** The Bacon's Rebellion section now uses Howard Pyle's *Burning of Jamestown* (1676); *The Old Plantation* (c. 1790) was moved to the "Hardening of Racial Slavery" section where it fits the context (enslaved people's cultural life).

---

## Why images might not be loading

1. **Images were never downloaded**  
   The HTML expects files in `images/ch1/` … `images/ch15/` at the **repo root**. Those folders are created and filled only when you run the download scripts.

2. **Use the right scripts**  
   All image and map files must end up in repo-root **`images/ch1/`** … **`images/ch15/`**. Use **`download_all_images.sh`** (chapter images) and **`download_all_maps.sh`** (maps). Per-chapter scripts (`download_ch1_images.sh`, etc.) also write to repo-root `images/`.

3. **Chapter 6**  
   `scripts/download_ch6_images.sh` exists and is included when you run `download_all_images.sh`.

4. **Maps and extras only in `download_all_maps.sh`**  
   Several images (e.g. Beringia, 13 colonies map, triangular trade, siege of Yorktown, US 1789, Louisiana Purchase, canals map, Trail of Tears map, UGRR map, Civil War maps, Reconstruction districts) are **only** provided by **`scripts/download_all_maps.sh`**. If you never run that script, those files are missing and those figures won’t load.

---

## What to run so all images load

From the repo root:

```bash
# 1. All chapter images (ch1–ch15, including ch6)
bash scripts/download_all_images.sh

# 2. All maps (writes into same images/ch1 … images/ch15)
bash scripts/download_all_maps.sh
```

- **Skip existing:** Both scripts skip files that already exist and are at least 5 KB (so broken/error-page files get re-downloaded).
- **Errors:** A failed download in one chapter (or one map) does not stop the rest. Re-run the same script to retry; existing good files are skipped. At the end, `download_all_images.sh` prints a list of all failed images.
- **User-Agent:** Wikimedia Commons requires a User-Agent header. All download scripts source `scripts/download_common.sh`, which sets a compliant User-Agent so requests are not blocked. If you see many "[FAILED] … check URL" errors, ensure you're running the scripts as provided (they send the User-Agent automatically).
- If something fails (e.g. rate limit or temporary outage), run the script again later or run the specific `download_chN_images.sh` for that chapter.

---

## Reference: images by chapter

| Ch | File | Provided by | Notes |
|----|------|-------------|--------|
| **1** | beringia-land-bridge.png | download_all_maps.sh | |
| 1 | native-cultural-regions.jpg | download_all_maps.sh | |
| 1 | cahokia-mounds.jpg | download_ch1_images.sh | |
| 1 | mesa-verde.jpg | download_ch1_images.sh | |
| 1 | tenochtitlan.jpg | download_ch1_images.sh | |
| 1 | casta-painting.jpg | download_ch1_images.sh | |
| **2** | waldseemuller-map.jpg | download_ch2_images.sh | |
| 2 | de-bry-spanish-cruelty.jpg | download_ch2_images.sh | |
| 2 | champlain-habitation.jpg | download_ch2_images.sh | |
| 2 | secotan-village.jpg | download_ch2_images.sh | |
| 2 | negotiating-peace.jpg | download_ch2_images.sh | |
| **3** | thirteen-colonies-1775.png | download_all_maps.sh | |
| 3 | pocahontas.jpg | download_ch3_images.sh | |
| 3 | mayflower-compact.jpg | download_ch3_images.sh | |
| 3 | slave-ship-brookes.jpg | download_ch3_images.sh | |
| 3 | old-plantation.jpg | download_ch3_images.sh | |
| **4** | slave-ship (ch3) | ch3 script | Reused in ch4 |
| 4 | triangular-trade.png | download_all_maps.sh | |
| 4 | peale-family.jpg | download_ch4_images.sh | |
| 4 | rice-cultivation.jpg | download_ch4_images.sh | |
| 4 | whitefield-preaching.jpg | download_ch4_images.sh | |
| 4 | join-or-die.jpg | download_ch4_images.sh | |
| **5** | boston-massacre.jpg | download_ch5_images.sh | |
| 5 | common-sense.jpg | download_ch5_images.sh | |
| 5 | declaration-of-independence.jpg | download_ch5_images.sh | |
| 5 | siege-of-yorktown.gif | download_all_maps.sh | |
| 5 | surrender-cornwallis.jpg | download_ch5_images.sh | |
| 5 | yorktown-soldiers.jpg | download_ch5_images.sh | |
| **6** | federal-pillars.jpg | download_ch6_images.sh | **Was missing; script added** |
| 6 | us-territory-1789.png | download_all_maps.sh | |
| 6 | shays-shattuck.jpg | download_ch6_images.sh | |
| 6 | independence-hall.jpg | download_ch6_images.sh | |
| 6 | madison.jpg | download_ch6_images.sh | |
| 6 | hamilton.jpg | download_ch6_images.sh | |
| 6 | execution-louis-xvi.jpg | download_ch6_images.sh | |
| 6 | anti-jefferson-cartoon.jpeg | download_ch6_images.sh | |
| 6 | us-capitol-1800.jpg | download_ch6_images.sh | |
| **7** | louisiana-purchase.jpg | download_all_maps.sh | |
| 7 | (all others) | download_ch7_images.sh | |
| **8** | canals-railroads-1840.jpg | download_all_maps.sh | |
| 8 | (all others) | download_ch8_images.sh | |
| **9** | trail-of-tears-map.jpg | download_all_maps.sh | |
| 9 | (all others) | download_ch9_images.sh | |
| **10** | ugrr-siebert-1898.png | download_all_maps.sh | |
| 10 | (all others) | download_ch10_images.sh | |
| **11** | slave-population-map.jpg | download_ch11_images.sh | |
| 11 | (all others) | download_ch11_images.sh | |
| **12** | mexican-cession-map.jpg | download_ch12_images.sh | |
| 12 | (all others) | download_ch12_images.sh | |
| **13** | (all) | download_ch13_images.sh | |
| **14** | civil-war-1861.jpg | download_all_maps.sh | |
| 14 | anaconda-plan.jpg | download_all_maps.sh | |
| 14 | (all others) | download_ch14_images.sh | |
| **15** | reconstruction-military-districts.png | download_all_maps.sh | |
| 15 | (all others) | download_ch15_images.sh | |

---

## American Yawp: key images we could add

The [American Yawp](https://www.americanyawp.com) uses many of the same images we do, plus a few we don’t yet have. Below are **high-value additions** that would strengthen our chapters (all can be found on Wikimedia Commons or LOC with license-safe terms).

### Chapter 1 – Indigenous America
- **Prehistoric Settlement / Kings Crossing mural** (Robert Dafford) – Eastern Woodlands agriculture (Yawp uses this for “Prehistoric Settlement in Warren County, Mississippi”).
- **Crooked Beak of Heaven Mask** (Kwakwaka’wakw) – Pacific Northwest culture; Yawp uses for spiritual/ceremonial context.
- **Lisbon 1572** (Civitatis Orbis Terrarum) – European expansion context; optional for “European Expansion.”

### Chapter 2 – Colliding Cultures
- **Tabula Terre Nove (1513)** – Early Atlantic map; Yawp uses for Spanish Florida.
- **Castello Plan (1660)** – New Amsterdam/Manhattan; Yawp uses for Dutch section.
- **New Orleans 1726** (Lassus) – French colonization; Yawp uses for Louisiana.
- **Virginia fishing (Incolarum Virginiae)** – Jamestown / Indigenous economy; Yawp uses for “Method of Fishing.”
- **Battle of Gravelines (1588)** – Spanish Armada; Yawp uses for English colonization.

### Chapter 5 – American Revolution
- We already have strong coverage (Boston Massacre, Common Sense, Declaration, Yorktown siege map, surrender, soldiers). Optional: **Washington at Princeton** or **Valley Forge** if we add a short visual for the middle of the war.

### Later chapters
- **Ch 11:** We have slave population map; Yawp also uses **cotton production by region** – consider adding if we find a clear, license-safe map.
- **Ch 12:** We have American Progress, Oregon Trail, Chapultepec, Mexican Cession, Gold Rush; coverage is good.
- **Ch 14–15:** We have Fort Sumter, Civil War/Anaconda maps, Antietam, field hospital, Reconstruction districts, etc. Optional: **Gettysburg** or **Appomattox** image if we want one more “end of war” visual.

---

## Where to add new images in the narrative

- **Ch 1:** After “Eastern Woodlands” / Three Sisters paragraph → Prehistoric Settlement or similar agriculture image. After Pacific Northwest paragraph → Crooked Beak mask or totem/potlatch image.
- **Ch 2:** After “Spain’s rivals” / Dutch section → Castello Plan. After French section → New Orleans 1726. In English colonization → Battle of Gravelines (Armada). In Jamestown section → Virginia fishing (Incolarum Virginiae).
- **Ch 6:** Already has good spread (Federal Pillars, US 1789 map, Shays, Independence Hall, Madison, Hamilton, Louis XVI, anti-Jefferson cartoon, Capitol). No urgent gaps.
- **Ch 7–15:** Maps and key figures are in place; any of the “optional” items above can be dropped in next to the cited sections in the chapter HTML.

---

## Summary

1. **Run `download_all_images.sh` and `download_all_maps.sh`** so every referenced file exists under repo-root `images/`.
2. **Run both** `download_all_images.sh` and `download_all_maps.sh` so every referenced image and map is present under `images/`.
3. **Chapter 6** is now covered by `download_ch6_images.sh` and by `download_all_images.sh`.
4. **Optional improvements:** add a few key Yawp images (Prehistoric Settlement or Crooked Beak for ch1; Castello Plan, New Orleans 1726, Virginia fishing, Gravelines for ch2) and place them as in the table above.
