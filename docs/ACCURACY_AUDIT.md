# Chapter Accuracy Audit

Per-chapter ledgers. The method is in [MAINTENANCE.md](../MAINTENANCE.md#chapter-accuracy-audit-method).

Chapters are audited **one unit ahead of the pacing guide**, so each is checked the month
before classrooms reach it — not in a single sweep that finishes after the year ends.

## Summary

| Ch | Title | Target | Status | verified | corrected | caveated | could not verify |
|----|-------|--------|--------|----------|-----------|----------|------------------|
| 5 | The American Revolution | Oct 15, 2026 | **applied 2026-09-08** | 130 | 34 applied | &mdash; | 3 |
| 6 | A New Nation | Oct 31, 2026 | not started | — | — | — | — |
| 7 | The Early Republic | Nov 15, 2026 | not started | — | — | — | — |
| 8 | The Market Revolution | Dec 20, 2026 | not started | — | — | — | — |
| 9–11 | — | Jan–Feb 2027 | M6 | — | — | — | — |
| 12–15 | — | Mar 2027 | M6 | — | — | — | — |

**ch1–ch4 are deliberately not scheduled for an AI pass this year.** Classrooms pass them
before the audit begins, so a pass would finish after every student who reads them has
moved on. They go to the human review pipeline first, with an AI pass in Q2 2027.

## Ledger format

| # | Claim (quoted) | Type | Verdict | Sources consulted | Action |
|---|----------------|------|---------|-------------------|--------|

`Type` is one of: date · name · statistic · quotation · causal.

---

## Findings ahead of the ledgers

Two corrections were made before the per-chapter ledgers began, because both were already
on the site and both were being taught as fact.

### Source 9.3 — the John Burnett letter is a fabrication (2026-09-08)

Presented in `primary-sources/ch9-sources.html` as a soldier's eyewitness memoir of the
Trail of Tears, and quoted in `ch9.html` as the same. It is neither.

- Burnett's company **mustered out of service in April 1837**, more than a year before the
  1838–39 removal the letter describes.
- His unit took part in 1836–37 operations, not the 1838–39 march.
- **No U.S. soldiers accompanied the Cherokee** on that march, so no soldier could have
  witnessed what the letter recounts.
- Larry A. Vogt, *Myth, Legend, Hoax, and History* (2020), building on Higginbotham (1988)
  and Duffield (2002), traces the letter to Burnett's grandson.

**Action:** kept, and rewritten as a source-reliability case study rather than removed.
A false source that fooled historians, museums and textbooks for a century teaches
something an authentic source cannot. Both pages now state the evidence plainly and make
the point that the Trail of Tears happened and was that cruel — the Cherokee left their
own accounts, which need no invented witness.

### Source 4.5 — the 1769 Charleston broadside is genuine (2026-09-08)

Added to `primary-sources/ch4-sources.html`. Its Wikimedia Commons record credits
**Pinterest** and calls the file a "reproduction," which looked like a forgery risk. It is
not: the artifact is catalogued as **Early American Imprints, First Series, no. 41926**
(Evans), `[Charleston, S.C.: s.n., 1769]`, one sheet, 32 × 20 cm, with relief cuts and the
ornamental border that first raised the suspicion. Held at Stanford, Indiana and Villanova.

**Action:** cited to Evans 41926 rather than the Commons credit chain, with a note that
every circulating copy is a photographic reproduction of the original sheet.

---

## Chapter 5 — The American Revolution

**Audited 2026-09-08.** 190 checkable claims across six sections plus seven figures.
Each claim checked against [The American Yawp ch. 5](https://www.americanyawp.com/text/05-the-american-revolution/)
plus one independent reference. Every proposed change was then re-checked by a second
pass instructed to *refute* it.

| | Count |
|---|---|
| verified | 130 |
| caveated (as proposed) | 38 |
| corrected (as proposed) | 19 |
| could not verify | 3 |
| **flagged for adjudication** | **57** |
| adjudicated | 40 |
| **upheld** | **26** |
| **overturned** (page was right) | **14** |

**14 of 40 proposed changes were refused** on second look — a 35% overturn rate.
Auditors misread their own cited sources, mistook grade-appropriate compression for error,
and in one case misdescribed a map that the adjudicator checked by cropping and upscaling
its legend. The adversarial pass is not ceremony.

> **Coverage gap closed.** A second run adjudicated the remaining 17 rows and overturned
> 9 of them — a higher rate than the first run. All 57 flagged claims are now adversarially
> checked: **34 upheld, 23 overturned**. The skipped rows were not a random sample; the cap
> fell such that it had missed the entire conclusion section and nearly every figure row.

### Upheld — changes to make

**1. `caveated` — Patriot: A colonist who supported independence from Britain. Also called "Whigs" or "rebels." (ch5.html line 97, intro vocabulary box, entry 2)**

> Patriot: A colonist who actively opposed British control — and, from 1776 on, supported independence. Patriots called themselves "Whigs," after a British political party; the British called them "rebels." Careful with this word: before 1776, most Patriots wanted their rights as British subjects restored, not a separate country.

*Why:* I tried to refute this and could not. The definition is not fabricated — Britannica Kids and Wikipedia both gloss "Patriot" as a colonist who wanted independence, so it is the standard encyclopedia shorthand and this stays at `caveated`, never `corrected`. But two sources plus the chapter's own text

**2. `caveated` — "Colonists rallied around a powerful slogan: 'No taxation without representation.'" — ch5.html line 109, Section II "The Imperial Crisis," Stamp Act (**

> Colonists rallied around one idea: no taxes without their consent. Over the next few years, that idea hardened into a slogan—"No taxation without representation."

*Why:* I tried to refute this and could not. Both required sources point the same way. YAWP (ch. 5, The American Revolution): the phrase never appears. The Yawp gives the argument in period wording — Daniel Dulany, 1765: "It is an essential principle of the English constitution, that the subject shall not 

**3. `corrected` — ch5.html, Section II "The Imperial Crisis," para 3 (Stamp Act), final clause: "Parliament repealed the Stamp Act in 1766—but immediately passed the De**

> Mobs attacked the homes of tax collectors. Merchants organized boycotts of British goods. Colonial assemblies passed resolutions declaring the tax illegal. A group called the Sons of Liberty organized protests throughout the colonies. Facing overwhelming resistance, Parliament repealed the Stamp Act in 1766—but on the very same day it passed the Declaratory Act, announcing that Parliament had "full power and authorit

*Why:* Tried to refute; could not. Three sources agree the quoted phrase modifies a claim to LEGISLATE, not to TAX. (1) American Yawp ch. 5: Parliament "simultaneously passed the Declaratory Act," asserting "full power and authority to make laws . . . to bind the colonies and people of America . . . in all

**4. `caveated` — ch5.html, "The Townshend Acts and the Boston Massacre (1770)," para 2: "The first to die was Crispus Attucks—a man of African and Native American desc**

> The first to die was Crispus Attucks—a man of African and Native American descent, and the person most often called the first casualty of the Revolution. That title has been argued over. Eleven days before the Massacre, a boy named Christopher Seider, about eleven years old, was shot dead by a customs informer at a protest a few streets away. And Attucks himself was nearly forgotten for eighty years, until Black abol

*Why:* I tried to knock this down and couldn't. The refutation I wanted to make was "first martyr of the Revolution is a conventional phrase, and compression isn't error." It doesn't survive contact with the sources. PARENT SOURCE (American Yawp, ch. 5): silent. It says only "five Bostonians were dead, inc

**5. `caveated` — dressed as Mohawk Indians (a disguise that fooled no one) — ch5.html line 130, crisis section, para 8 (Boston Tea Party)**

> dressed as Mohawk Indians (nobody believed real Mohawks had done it—but the costumes hid the men's names for decades)

*Why:* I tried to refute this and could not. The parenthetical is defensible only on its narrow reading — no one in Boston believed actual Mohawks destroyed the tea — but the reading a 6th-8th grader will take from "a disguise that fooled no one" is "everyone knew which men did it," and that is contradicte

**6. `corrected` — "and quartering British troops in private homes" — ch5.html line 132, crisis section para 9 (Boston Tea Party / Coercive Acts)**

> and letting the army take over empty buildings—barns, sheds, vacant houses—to quarter soldiers in any colony

*Why:* Attempted refutation failed on every angle. (1) Primary text is decisive: Avalon Project, Quartering Act of 1774 (June 2, 1774), Section II authorizes the governor to take "such and so many uninhabited houses, out-houses, barns, or other buildings, as he shall think necessary"; Section I otherwise r

**7. `corrected` — "They weren't trying to fool anyone—everyone knew who they were." (ch5.html line 136, Story Behind the Story: Why Dress as "Mohawks"?)**

> They were not trying to convince anyone that real Mohawks had done it. But they did want to hide who they were, and it worked. British officials called the destruction of the tea treason—a crime a man could hang for—and they offered rewards for names. Nobody talked. The government never gathered enough evidence to put a single participant on trial, and most of the men kept quiet for decades; many of their names did n

*Why:* I tried to refute this and could not. The second half of the sentence is flatly false, and the falsity is checkable by a student. WHAT HOLDS UP IN THE AUDIT: - The Yawp (Ch. 5, https://www.americanyawp.com/text/05-the-american-revolution/) says only "dozens of men disguised as Mohawks made their way

**8. `corrected` — "...toward the towns of Lexington and Concord, Massachusetts, to seize colonial weapons stockpiled there." (ch5.html line 161, "Lexington and Concord **

> On the night of April 18, 1775, British troops marched out of Boston toward Concord, Massachusetts, to seize the weapons and gunpowder the colonists had stored there. The road to Concord ran straight through the town of Lexington. Thanks to riders like Paul Revere and William Dawes, the colonial militia (known as Minutemen) was warned.

*Why:* Attempted refutation failed. Two independent sources put the military stores at Concord alone. NPS Minute Man NHP reproduces Gage's April 18, 1775 order to Lt. Col. Smith: march "to Concord, where you will seize and destroy all artillery, Ammunition, Provisions, Tents, Small Arms, and all Military S

**9. `corrected` — independence / "Lexington and Concord (April 1775)", para 1: "Thanks to riders like Paul Revere and William Dawes, the colonial militia (known as Minu**

> Thanks to riders like Paul Revere and William Dawes, the colonial militia was warned. Some of those companies were minutemen—about a quarter of a town's militia, picked to be ready to march at a minute's notice. Lexington had no minute company. The men who met the British on its green were the town's ordinary militia.

*Why:* I tried to refute this and could not; the evidence is stronger than the auditor's own write-up. What the auditor got wrong: American Yawp is NOT silent. Ch. 5 says "Militia members, known as minutemen, responded quickly and inflicted significant casualties on the British regiments as they chased the

**10. `caveated` — Figcaption (ch5.html line 175): "it sold over 100,000 copies in its first months" — Common Sense figure caption, images/ch5/common-sense.jpg**

> The title page of <em>Common Sense</em> (1776) by Thomas Paine. Written in plain language for ordinary people, it made the case for independence to a public that was still undecided. Paine claimed more than 100,000 copies sold within a few months; historians who have counted the surviving printings think the real number was far smaller. Either way, the pamphlet changed the argument fast. (Public domain, Wikimedia Com

*Why:* I attempted to refute and succeeded on one of the auditor's two arguments, but not the load-bearing one. REFUTED: The auditor's claim that the caption "contradicts the body text five paragraphs later, which says 500,000." It does not contradict it. "Over 100,000 in its first months" and "over 500,00

**11. `caveated` — "It sold over 500,000 copies in a population of 2.5 million—making it, proportionally, the best-selling American publication of all time." (ch5.html, **

> Common Sense was a sensation. Paine himself said it sold 120,000 copies in its first three months, in colonies of about 2.5 million people. Later writers stretched that number to half a million, and you will still see the bigger figure repeated today — but historians who have gone back and counted the actual print runs think the real total was far smaller, and the records from 1776 are too thin to settle it. What is 

*Why:* I tried to refute this and could not. Parent source: American Yawp ch. 5 gives no sales figure whatsoever ("the pamphlet was quickly published and dispersed"), so the 500,000 is not inherited from the parent chapter. Independent source: Ray Raphael, "Thomas Paine's Inflated Numbers" (Journal of the 

**12. `caveated` — "...making it, proportionally, the best-selling American publication of all time." (ch5.html:178, "Common Sense (January 1776)", para 3)**

> Replace the full sentence "It sold over 500,000 copies in a population of 2.5 million—making it, proportionally, the best-selling American publication of all time." with: "No one kept sales records, so the exact number is lost. Paine claimed 120,000 copies in three months; historians who have counted the known printings think the real ceiling was closer to 75,000. Either way, in a country of 2.5 million people, nothi

*Why:* I tried to refute this and could not. (1) The parent source is silent: the American Yawp chapter gives no sales figure and makes no bestseller claim — only "His combination of easy language, biblical references, and fiery rhetoric proved potent, and the pamphlet was quickly published and dispersed."

**13. `corrected` — Primary Source box: "There is something absurd, in supposing a continent to be perpetually governed by an island." (ch5.html line 182, Primary Source:**

> "There is something very absurd, in supposing a continent to be perpetually governed by an island. In no instance hath nature made the satellite larger than its primary planet... Everything that is right or natural pleads for separation. The blood of the slain, the weeping voice of nature cries, 'Tis time to part."

*Why:* I tried to knock this down and could not. WHAT THE ORIGINAL SAYS (/Users/shiebenaderet/Developer/yawpms/ch5.html, line 182): "There is something absurd, in supposing a continent to be perpetually governed by an island. In no instance hath nature made the satellite larger than its primary planet... E

**14. `corrected` — ch5.html, section "independence", Primary Source box "Thomas Paine, Common Sense": "There is something absurd, in supposing a continent to be perpetua**

> "Every thing that is right or reasonable pleads for separation. The blood of the slain, the weeping voice of nature cries, 'TIS TIME TO PART.... There is something very absurd, in supposing a continent to be perpetually governed by an island. In no instance hath nature made the satellite larger than its primary planet." (Citation line unchanged: —Thomas Paine, Common Sense (January 1776))

*Why:* I tried to refute this and could not. The auditor is right on the substance, and the box is in fact wrong in three ways, not one. ORDER (auditor's finding — confirmed by four independent texts). Both passages sit in Section III, "Thoughts on the Present State of American Affairs," but the pamphlet's

**15. `caveated` — "Jefferson meant white, property-owning men." — ch5.html line 207, Section III, Multiple Perspectives box, "Thomas Jefferson (the author)"**

> Historians still argue about how wide Jefferson meant the word "men" to be. In his first draft he called enslaved Africans "men" and blamed the king for the slave trade—but Congress cut that passage, and Jefferson enslaved more than 600 people over the course of his life. Whatever he meant, he did not live by his own words.

*Why:* I tried to refute this and could not. Three independent problems, two of them factual rather than interpretive. (1) The "property-owning" half is contradicted by primary evidence about Jefferson specifically. The box is headed with his name, so it is a claim about him, not about general colonial pra

**16. `caveated` — The colonies had no army, no navy, no central government, and no money. (ch5.html, Section IV "The War", "David vs. Goliath", para 1)**

> The colonies had no professional army, almost no navy, no money, and a Continental Congress that could ask the states for soldiers and taxes but could not make them hand over either.

*Why:* The finding stands, but for only one of the four clauses, and the auditor's proposed replacement must not be used as written. WHAT SURVIVES AS LEGITIMATE COMPRESSION. "No navy": the American Battlefield Trust page the auditor cited says the Continental Navy was born October 13, 1775, peaked at thirt

**17. `corrected` — "Washington's troops were starving, freezing, and dying of disease. About 2,000 soldiers died that winter—not from enemy fire, but from cold and sickn**

> Washington's troops were hungry, cold, and — above all — sick. About 2,000 soldiers died at Valley Forge, almost none of them in battle. The killers were diseases: influenza, typhus, typhoid, and dysentery, racing through a crowded camp where a dozen men shared each log hut. And here is the part that surprises people — two-thirds of those deaths came not during the freezing weeks but in March, April, and May, after t

*Why:* I attempted to refute this and could not. The causal claim fails against every independent source; only the death count survives, and it survives better than the auditor's own replacement. WHAT I CHECKED (three independent references, plus the parent text): 1. NPS, Valley Forge NHP, "What Happened a

**18. `corrected` — "Washington himself wrote that you could \"track the army... to Valley Forge by the blood of their feet.\"" — ch5.html line 231, Story Behind the Stor**

> That spring, still camped at Valley Forge, Washington described his soldiers to John Banister, a Virginia delegate to the Continental Congress: men "without Shoes, by which their Marches might be traced by the Blood from their feet." (George Washington to John Banister, April 21, 1778)

*Why:* I tried to refute this and could not. TWO SOURCES: (1) American Yawp ch.5 is silent — its only Valley Forge sentence is "During the single winter at Valley Forge in 1777-1778, over 2,500 Americans died from disease and exposure"; no bloody-feet language and no Washington quotation, so the parent tex

**19. `corrected` — ch5.html, Section IV ("The War"), story-box "Story Behind the Story: The Bloody Footprints" — the bloody-footprints image at Valley Forge, including t**

> One of the most haunting images of the Revolution is the picture of bloody footprints in the snow at Valley Forge. Here is what the record actually shows. The shoe shortage is beyond doubt: on December 23, 1777, Washington reported to Congress that 2,898 men in camp were unfit for duty because they were barefoot and had no proper clothing. The following April he wrote of soldiers "without Shoes, by which their Marche

*Why:* I tried to refute this and could not, but the audit understates the problem and its replacement text introduces a new error. WHAT THE AUDIT MISSED. The CLAIM AS WRITTEN handed to the auditor stops before the box's fourth sentence. The live file (/Users/shiebenaderet/Developer/yawpms/ch5.html, line 2

**20. `corrected` — "Yet these same soldiers stayed. They didn't desert." (ch5.html, Section IV. The War, Story Behind the Story: The Bloody Footprints)**

> Some of them did leave. More than a thousand soldiers deserted over the course of that winter, and Washington worried about it constantly. But the army never collapsed—there was no mass desertion, no mutiny. Most of these men stayed.

*Why:* Could not refute; the original is factually wrong, not a defensible simplification. INDEPENDENT SOURCE 1 — American Battlefield Trust, "Winter at Valley Forge": Washington's leadership "likely accounted for the fact that there was a never a mass desertion or mutiny at Valley Forge." The documented c

**21. `corrected` — ch5.html, "Saratoga and the French Alliance," para 2: "The French navy, in particular, evened the odds at sea and prevented Britain from resupplying i**

> The French navy evened the odds at sea. It never cut Britain off completely—British ships kept supplying New York, Charleston, and Savannah until the end of the war—but at the right moment a French fleet could seal off a harbor, and in 1781 that was enough to decide the war.

*Why:* I tried two ways to refute the audit and both fail. (1) Narrow reading. The sentence could be defended if it meant "prevented Britain from resupplying its forces AT YORKTOWN." But the paragraph is a general statement about what French entry did to the war ("French money, soldiers, ships, and weapons

**22. `corrected` — ch5.html, Section IV "Yorktown: The End", para 2: "The Treaty of Paris, signed in 1783, officially ended the war. Britain recognized American independ**

> Britain recognized American independence and gave up its claim to the land between the Appalachian Mountains and the Mississippi River — roughly doubling the size of the new nation on paper. Britain kept Canada to the north, and Spain got Florida to the south. But Britain was signing away land it did not control: that territory was home to dozens of Indigenous nations, and not one of them was at the negotiating table

*Why:* I tried to defend the original as acceptable compression and could not. It is not a simplification; it is wrong, and wrong in a way students must unlearn. SOURCE 1 (parent text) — American Yawp ch. 5 is silent on the treaty's territorial terms. It says only "Peace negotiations took place in France, 

**23. `corrected` — "Women played essential roles in the Revolution, even though they couldn't vote, hold office, or own property in most colonies." (ch5.html line 274, S**

> Women played essential roles in the Revolution, even though they could not vote or hold office. The colonies had inherited an English law called coverture: when a woman married, her legal identity disappeared into her husband's. A wife could not own property, sign a contract, or keep the wages she earned — it all belonged to him. Widows and unmarried women had more freedom. They could buy and sell land, sign contract

*Why:* I tried to defend the line as acceptable compression and could not. SOURCE 1 (parent). American Yawp ch. 5 is silent on colonial property law — it covers women's boycotts, spinning clubs, republican motherhood, and Abigail Adams, and never mentions coverture or married-vs-single legal status. So the

**24. `caveated` — "about 5,000 Black men served in the Continental Army" — ch5.html line 284 (figcaption on the DeVerger Yorktown watercolor) and line 287 (Everyone's R**

> FIGCAPTION (ch5.html line 284) — replace the whole figcaption with: A watercolor by French officer Jean-Baptiste-Antoine DeVerger (1781) showing soldiers at Yorktown. Note the Black soldier on the far left — about 5,000 Black men fought on the American side, for a freedom the new nation would not fully grant. (Public domain, Wikimedia Commons) BODY (ch5.html line 287) — replace sentence 1 of the paragraph with these 

*Why:* I tried to refute this and could not. The number survives; the institutional label does not. TRACING THE FIGURE TO ITS ORIGIN. The strongest evidence is the National Park Service's "Patriots of Color" paper by historian John Hannigan (https://www.nps.gov/articles/000/john-hannigan-patriots-of-color-

**25. `corrected` — "The Revolution did spark a wave of emancipation in the Northern states—by 1804, every Northern state had passed gradual emancipation laws." (ch5.html**

> The Revolution did spark a wave of emancipation in the North—but it happened state by state, and it happened slowly. Pennsylvania passed the first gradual emancipation law in 1780; Connecticut and Rhode Island followed in 1784, New York in 1799, and New Jersey, the last, in 1804. Other Northern states took different roads. Vermont's 1777 constitution barred slavery, though enslavers there found ways around it for dec

*Why:* I tried to defend the original as acceptable compression and could not. It fails on both sources and on three states. PARENT SOURCE: The American Yawp ch. 5 says "most of the new northern states soon passed gradual emancipation laws." It says "most," not "every," and gives no date. The page's strong

**26. `corrected` — "Most Native nations, including the powerful Haudenosaunee Confederacy, sided with Britain" — ch5.html, section V "Everybody's Revolution," Native Ame**

> Most Native nations sided with Britain—not out of loyalty to the king, but because Britain's Proclamation of 1763 had at least tried to limit colonial expansion onto Native land. The Americans made no such promise. But the Haudenosaunee Confederacy—six nations bound together by a centuries-old peace—could not agree on what to do. In January 1777 the central council fire at Onondaga went out, and each nation was left 

*Why:* The refutation attempt fails. Two independent sources plus the parent text all contradict the sentence as written. NPS, "The Six Nations Confederacy During the American Revolution": "Unable to agree on a unified course of action, the Confederacy split, with not only nation fighting nation, but indiv

### Overturned — the page was right

Recorded so the same objections are not re-raised by the next reviewer.

1. **ch5.html line 90, Section I (Introduction), para 2, sentence 1: "In 1763, Britain had just won the French and Indian War** — proposed `caveated`, kept as written. The correction does not survive its own sources, and the erasure argument does not survive the page it is on. 1) BOTH REQUIRED SOURCES SUPPORT THE LINE AS WRITTEN. Yawp ch5 (https://www.americanyawp.c

2. **About 15-20% of the colonial population were Loyalists. (ch5.html line 98, vocabulary box; also restated at ch5.html lin** — proposed `corrected`, kept as written. REFUTED. The audit's denominator argument collapses against its own cited source. 1) The audit's independent source (Journal of the American Revolution, "John Adams's Rule of Thirds") gives TWO estima

3. **"Paul Revere's famous engraving of the Boston Massacre (1770)." — ch5.html line 123, figcaption in section id="crisis"** — proposed `caveated`, kept as written. The caption as written is correct by the standard of every institution that holds the print, and the auditor concedes as much ("Not an error"). The Massachusetts Historical Society catalogs Paul Rever

4. **ch5.html, "The Boston Tea Party (1773)," para 2: "On December 16, 1773, about 150 Sons of Liberty, dressed as Mohawk Ind** — proposed `caveated`, kept as written. The proposed change does not survive an independent check. 1. "About 150" is not an outlier the page invented — it is the figure published verbatim by the National Park Service. Boston National Histor

5. **"dissolving Massachusetts's elected government" — ch5.html line 132, Boston Tea Party section, describing the Coercive A** — proposed `caveated`, kept as written. The correction does not survive checking, for three reasons. 1. The auditor truncated its own required parent source. It quotes the Yawp as saying the Massachusetts Government Act "put the colonial go

6. **Sons of Liberty: A secret organization of colonial men who led resistance to British taxation through protests, boycotts** — proposed `caveated`, kept as written. The proposed change rests on two grounds and both fail on inspection. GROUND 1 — "secret" is misleading. REFUTED, and refuted by the auditor's own source. The auditor cites the Massachusetts Historica

7. **"As Martin Luther King Jr. put it, the Declaration was a 'promissory note' that America has yet to fully cash." (ch5.htm** — proposed `corrected`, kept as written. REFUTED. The auditor's rule — "a real quotation with a changed referent is corrected" — does not apply, because the referent was not changed. It was narrowed to one of the two documents King actually 

8. **"The Declaration's promise of equality has been invoked by every major freedom movement in American history—abolitionist** — proposed `caveated`, kept as written. The auditor's stated basis is factually wrong. They claim "yawp says: Silent on this specific generalization." It is not. American Yawp ch. 5, Section VII (Conclusion), states the generalization direc

9. **"About 2,000 soldiers died that winter" — ch5.html line 225, "Valley Forge and the Turning Point," paragraph 1** — proposed `caveated`, kept as written. The refutation rests on three findings. 1. The independent source states "about 2,000" as its own headline figure, not as an upper bound. The auditor characterized NPS as giving a range that "About 2,

10. **"Many walked barefoot through the snow because they had no shoes." — ch5.html line 225, "Valley Forge and the Turning Po** — proposed `caveated`, kept as written. The proposed change fails on its own sources. 1) The auditor's independent citation contradicts the auditor's summary of it. The NPS page cited (https://www.nps.gov/articles/000/valley-forge-footwear-

11. **ch5.html, Section IV "The War," subsection "Saratoga and the French Alliance," para 2: "Without France, the Americans al** — proposed `caveated`, kept as written. The proposed change rests on a misreading of the sentence it wants to fix, and the sourcing runs against it. 1. The auditor's core charge is factually wrong about the text. The note says the line "sta

12. **Figcaption in ch5.html, section IV "Yorktown: The End", map figure (images/ch5/revolution-battles-map.png): "Major battl** — proposed `corrected`, kept as written. The audit rested on two grounds; the load-bearing one collapses on direct inspection of the image, and the other is not an error. GROUND 1 — "It plots campaign routes rather than battle sites." REFUTE

13. **"Women played essential roles in the Revolution, even though they couldn't vote, hold office, or own property in most co** — proposed `caveated`, kept as written. The original line is a hedged, defensible generalization and the proposed replacement introduces two fresh errors, so the page should be left alone. SOURCES CHECKED: 1. American Yawp ch. 5 — silent on

14. **"Thousands of enslaved people fled to British lines." — ch5.html line 280, Section V "Everybody's Revolution," subsectio** — proposed `caveated`, kept as written. The proposed change should be rejected. The sentence on the page is supported by both required sources, and the replacement would introduce two new errors into the book. WHAT THE PAGE ACTUALLY SAYS. T

### Could not verify

- **Figcaption: "(U.S. Army, public domain)" — attribution for the Yorktown siege map** (war, "Yorktown: The End", figure 1 (siege-of-yorktown.gif)) — Handoff to a human reviewer, per the method — I am not upgrading this to verified on the strength of a stylistic match. The map's *content* is verified (see the row above); it is the attribution claus
- **"[Black Loyalists'] stories of courage and betrayal are rarely told."** (conclusion, Whose Voices Were Left Out — "Enslaved people who fled to the British") — An editorial claim about the historical record rather than about the past. Not upgraded to verified. Handoff: either soften to "stories most textbooks leave out" (which the book can stand behind about
- **"Their [Loyalists'] perspective on the Revolution is almost never told in American schools."** (conclusion, Whose Voices Were Left Out — "Loyalist families") — Same class of claim as the Black Loyalist row. Flagged for a human reviewer rather than corrected, since a defensible weaker version ("rarely told from their own point of view") may be what is meant.



### Applied 2026-09-08

All 34 upheld corrections are in `ch5.html`. Visible text grew by ~4,400 characters, almost
entirely because caveats add context rather than replace it.

**Companion fan-out:** none required. `QUIZZES["5"]`, `VOCAB["5"]`, `SLIDES["5"]` and the
eight `ch:5` timeline entries were checked against every corrected claim and none repeated
one. That is a finding, not a skipped step.

**Manifest defect found during the figure audit.** `scripts/download_ch5_images.sh` listed
`yorktown-soldiers.jpg` while the committed file is `.gif`, and `siege-of-yorktown.gif` had
no entry at all. Both are now recorded with provenance. `audit_images.sh --strict` passed
throughout, because it only asks whether referenced files exist on disk — an image can be
present, referenced, and rendering while having no provenance record whatsoever. **A CI arm
asserting manifest/reference/disk agreement is a live gap** (see TASKS.md).

**The siege-of-Yorktown map is a modern teaching map**, not a period plan: it carries NATO
unit symbols (XXX corps, XX division), a circled atlas plate number, and vector typography.
The caption said "Plan of the Siege of Yorktown," which implied a 1781 document. Corrected.
