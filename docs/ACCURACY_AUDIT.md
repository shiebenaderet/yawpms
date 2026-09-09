# Chapter Accuracy Audit

Per-chapter ledgers. The method is in [MAINTENANCE.md](../MAINTENANCE.md#chapter-accuracy-audit-method).

Chapters are audited **one unit ahead of the pacing guide**, so each is checked the month
before classrooms reach it — not in a single sweep that finishes after the year ends.

## Summary

| Ch | Title | Target | Status | verified | corrected | caveated | could not verify |
|----|-------|--------|--------|----------|-----------|----------|------------------|
| 5 | The American Revolution | Oct 15, 2026 | **applied 2026-09-08** | 130 | 34 applied | &mdash; | 3 |
| 6 | A New Nation | Oct 31, 2026 | **ledger complete, 33 pending sign-off** | 198 | 35 | — | 7 |
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

---

## Chapter 6 — A New Nation

**Audited 2026-09-09. INCOMPLETE — do not apply from this ledger yet.**

323 checkable claims across ten sections plus ten figures, verified against
[The American Yawp ch. 6](https://www.americanyawp.com/text/06-a-new-nation/) plus an
independent reference. All eleven audit arms completed.

| | Count |
|---|---|
| claims audited | 323 |
| verified | 198 |
| flagged (corrected + caveated) | 118 |
| could not verify | 7 |
| **adjudicated** | **81** |
| upheld | 27 |
| overturned | 54 |
| **NOT adjudicated** | **37** |

> **Stopped by a session limit, not finished.** 37 flagged rows never reached the
> refutation pass. They are unresolved, not cleared, and nothing from this ledger has been
> applied to `ch6.html`. Resume with the run id recorded below before applying anything.

**The overturn rate on what did complete is 67%** — 54 of 81.
On ch5 it was 40%. A rate this high says the auditors over-flagged on ch6, which makes
finishing the refutation pass more important here, not less.

### Upheld so far

**1. `caveated` — /Users/shiebenaderet/Developer/yawpms/ch6.html, line 100 — §I "Introduction: The**

- *Claim:* Figure 1 figcaption (§I): the cartoon is titled "The Federal Pillars"
- *Proposed:* "The Federal Edifice" (often reprinted as "The Federal Pillars")

**2. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, line 100 — §I "Introduction: The**

- *Claim:* The cartoon was published "August 2, 1789" — figcaption: "\"The Federal Pillars,\" from The Massachusetts Centinel, August 2, 1789."
- *Proposed:* August 2, 1788 Full corrected figcaption sentence in place: "The Federal Pillars," from <em>The Massachusetts Centinel</em>, August 2, 1788.

**3. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, §I "Introduction: The Sword and **

- *Claim:* "Each pillar represents a state ratifying the Constitution." — §I, figure 1 figcaption, ch6.html line 100. Full line as written: `"The Federal Pillars," from <em>The Massachusetts Centinel</em>, Augus
- *Proposed:* "The Federal Edifice," from <em>The Massachusetts Centinel</em>, August 2, 1788. Each pillar is a state. Eleven stand upright&mdash;the eleventh is New York, which had ratified just a week before. A hand from the clouds is hauling North Carolina's pillar up, and Rhode Island's lies broken on the gro

**4. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html line 100 — §I "Introduction: The **

- *Claim:* "The last pillar, North Carolina, is shown rising to join the others." (verified verbatim in the ch6.html figcaption; the auditor quoted it accurately, not partially)
- *Proposed:* Full replacement figcaption for line 100 (only the middle sentence changed; publication line and credit preserved): "The Federal Pillars," from <em>The Massachusetts Centinel</em>, August 2, 1789. Each pillar represents a state ratifying the Constitution. Eleven stand. A hand reaches out of the clou

**5. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, line 105 — §I "Introduction: The**

- *Claim:* "A few years later, Daniel Shays sold that sword." (asserting the sword sale happened several years after Lafayette's c. 1780 gift)
- *Proposed:* Within months, Daniel Shays sold that sword. He had six children at home and debts he couldn't pay.

**6. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, §I "Introduction: The Sword and **

- *Claim:* "A few years later, Daniel Shays sold that sword. He needed the money to keep his farm." (ch6.html line 105 — the auditor quoted only the second sentence)
- *Proposed:* Before the year was out, Daniel Shays sold that sword. The army owed him years of back pay, his debts were piling up, and, he pointed out, he already owned a sword. Other officers were disgusted—a gentleman was supposed to keep a gift like that forever. Shays needed the money more than the honor. Th

**7. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, line 111 — §I "Introduction: The**

- *Claim:* Vocabulary box, "Articles of Confederation" entry: "America's first constitution (1781–1789). It created a national government so weak it couldn't collect taxes, raise an army, or settle disputes betw
- *Proposed:* Replace the vocabulary entry at line 111 with: <p><strong>Articles of Confederation:</strong> America's first constitution (1781&ndash;1789). It created a national government so weak it couldn't collect taxes, raise an army, or make the states follow its own laws.</p> (Only the third item changes. "

**8. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, line 132 — Section II, "Shays's **

- *Claim:* "He had charged British positions at Saratoga."
- *Proposed:* He had been in the fighting at Saratoga.

**9. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html line 132 — Section II, "Shays's R**

- *Claim:* "He had watched a man hanged for treason against the United States."
- *Proposed:* He had watched a man hanged as a British spy.

**10. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, line 138 — Section II ("Shays's **

- *Claim:* "His neighbors were outraged—not at Shays, but at a government that forced a war hero to sell his sword to survive. It became a rallying cry: if the country couldn't take care of the men who had fough
- *Proposed:* The criticism landed on Shays, not on the government. Fellow officers called the sale dishonorable, and historians repeated that judgment for two hundred years. Shays had an answer: he already owned a working sword, and like most Continental soldiers, he had gone long stretches without pay. He neede

**11. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, line 139 — Section II (Shays's R**

- *Claim:* "His sixty-eight-acre farm in Shutesbury was everything his family had."
- *Proposed:* His rocky hill farm in Pelham was everything his family had.

**12. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html line 139 — Section II "Shays's Re**

- *Claim:* "Shays had a wife, Abigail, and six children. His sixty-eight-acre farm in Shutesbury was everything his family had. When the courts came for it, Shays didn't write a letter. He gathered his neighbors
- *Proposed:* When the courts came after him for debt, Shays didn't reach for a gun. His town sent petitions to Boston, along with dozens of other towns, asking for relief from their debts and lower court fees. Boston ignored them. And when his neighbors first marched on the Northampton courthouse in the summer o

**13. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, lines 146-150 — Section II, "Sha**

- *Claim:* Citation: "— A correspondent in Shrewsbury, Massachusetts, after the rebellion turned violent, January 1787" attached to the quotation "The seeds of war are now sown."
- *Proposed:* &mdash; A correspondent in Shrewsbury, Massachusetts, December 1786, after rebel leader Job Shattuck was hunted down, wounded, and jailed

**14. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, line 194 — section id="constitut**

- *Claim:* "The first thing the delegates do is take a vow of secrecy." (ch6.html, Constitutional Convention section, line 194)
- *Proposed:* On the very first day, May 25, the delegates elect George Washington to preside. Four days later they adopt a rule of secrecy: nothing said in this room can be shared with anyone&mdash;not the press, not their families, not even other politicians.

**15. `caveated` — /Users/shiebenaderet/Developer/yawpms/ch6.html — Section III, "The Constitutiona**

- *Claim:* "To make sure no one outside can eavesdrop, they nail the windows shut" (ch6.html line 194), and the Independence Hall figure caption "with the windows nailed shut in the middle of summer" (line 189).
- *Proposed:* Body text (line 194), replacing the final sentence of the paragraph: "Then, to make sure no one outside can eavesdrop, they shut the windows, pull the curtains, and post guards at the doors." Figure caption (line 189): "The Assembly Room in Independence Hall, Philadelphia. In this room, with the win

**16. `caveated` — /Users/shiebenaderet/Developer/yawpms/ch6.html line 202 — "Story Behind the Stor**

- *Claim:* Franklin "was too ill to walk."
- *Proposed:* Benjamin Franklin, at eighty-one the oldest delegate, was in constant pain from gout and a stone in his bladder, and he could barely walk.

**17. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html line 202 — "Story Behind the Stor**

- *Claim:* Franklin "was too ill to walk. He was carried to the Convention every day in a sedan chair—a covered seat hoisted by four prisoners from the Walnut Street Jail."
- *Proposed:* &lt;p&gt;&lt;strong&gt;Benjamin Franklin&lt;/strong&gt;, at eighty-one the oldest delegate, was in constant pain from gout and a stone in his bladder. On his worst days he was carried the few hundred yards from his house to the State House in a sedan chair&amp;mdash;a covered seat lifted on poles by

**18. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, "The Constitutional Convention" **

- *Claim:* PRIMARY SOURCE box titled "Primary Source: George Washington on the Secrecy Rule": "Nothing spoken in the house be printed, or otherwise published or communicated without leave. Gossip or misunderstan
- *Proposed:* Replace ch6.html lines 219-223 with: &lt;div class="primary-source"&gt; &lt;h3&gt;Primary Source: The Secrecy Rule&mdash;and Washington Enforcing It&lt;/h3&gt; &lt;p&gt;"That nothing spoken in the house be printed, or otherwise published or communicated without leave."&lt;/p&gt; &lt;p class="source-

**19. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, line 260 — Section IV "Ratifying**

- *Claim:* "The original Constitution said nothing about... the right to a fair trial." (full sentence: "They had a point. The original Constitution said nothing about freedom of speech, freedom of religion, the
- *Proposed:* They had a point. The original Constitution said nothing about freedom of speech, freedom of religion, or protection from unreasonable searches. It did promise a jury to anyone accused of a crime&mdash;but it said nothing about having a lawyer, getting a speedy trial, or a ban on cruel punishments. 

**20. `caveated` — /Users/shiebenaderet/Developer/yawpms/ch6.html:262 — Section IV, ¶4, first sente**

- *Claim:* "State by state, the vote was agonizingly close." (ch6.html line 262, Section IV "Ratifying the Constitution: The People Decide," paragraph 4, opening sentence)
- *Proposed:* In some states it was easy&mdash;Delaware, New Jersey, and Georgia approved the Constitution unanimously. But where Anti-Federalists were strong, the vote was agonizingly close: Massachusetts said yes 187 to 168, Virginia 89 to 79, and New York by just three votes, 30 to 27.

**21. `corrected` — ch6.html line 271, Section IV (ratification), "Story Behind the Story" box — "Th**

- *Claim:* "And leading the parade was a float called \"The Grand Federal Edifice\"—a miniature temple held up by thirteen pillars, one for each state."
- *Proposed:* And the centerpiece of the whole parade was a float called "The Grand Federal Edifice"&mdash;a thirty-six-foot temple held up by thirteen pillars, one for each state, pulled by ten white horses.

**22. `corrected` — ch6.html, Section V ("Slavery and the New Nation"), paragraph 2 (line 294)**

- *Claim:* "In the South, enslaved people made up nearly 40% of the total population."
- *Proposed:* In the South as a whole, about one in three people was enslaved&mdash;and in South Carolina it was more than four in ten.

**23. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html line 328 — Section VI ("Hamilton **

- *Claim:* "Loose construction: Hamilton's view that the Constitution allows the government to do anything it doesn't specifically forbid."
- *Proposed:* Loose construction: Hamilton's view that the government can use any reasonable method to carry out the jobs the Constitution gives it, even if that exact method isn't listed.

**24. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html line 344 — Story Behind the Story**

- *Claim:* "His opponents loved to remind everyone of his origins. They called him 'the bastard brat of a Scotch pedlar.' Hamilton used it as fuel."
- *Proposed:* His opponents never let him forget where he came from. A year and a half after Hamilton died, John Adams was still calling him "a bastard brat of a Scotch pedler" in a private letter.

**25. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html line 356 — Section VI ("Hamilton **

- *Claim:* Citation: "— Thomas Jefferson, in a letter begging James Madison to attack Hamilton's ideas in print, 1790s"
- *Proposed:* — Thomas Jefferson, in a letter begging James Madison to answer Hamilton in print, July 7, 1793. (By then the two were also fighting over foreign policy: Hamilton had published newspaper essays defending Washington's power to keep America out of Europe's war, and Madison answered him in print.)

**26. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, line 393 — Section V (Whiskey Re**

- *Claim:* "Washington crushed both the Whiskey Rebellion and (through the states) Shays's Rebellion."
- *Proposed:* Washington crushed the Whiskey Rebellion in 1794. Eight years earlier, when Shays's farmers rebelled, Washington was still a private citizen and Massachusetts had to put that rebellion down alone.

**27. `corrected` — /Users/shiebenaderet/Developer/yawpms/ch6.html, section X "Wrapping Up: A Nation**

- *Claim:* "James Madison locked the windows."
- *Proposed:* James Madison showed up eleven days early and wrote a whole new plan of government.

### Not yet adjudicated — 37 rows

Flagged by an auditor, never refuted. **Do not treat as findings.**

The list below is *indicative, not exact*. Matching adjudicator output back to auditor rows
is unreliable because adjudicators rephrase the claim they were handed, so this list
over-counts. The authoritative figures come from the run itself: **118 flagged, 81
adjudicated, 37 outstanding.** Resume the run rather than working from this list.

- `caveated` §I, figure 1 figcaption (ch6.html line 100) — Figure 1 figcaption: the cartoon is titled "The Federal Pillars"
- `corrected` §I, figure 1 figcaption (ch6.html line 100) — The cartoon was published "August 2, 1789"
- `corrected` §I, paragraph 2 — "A few years later, Daniel Shays sold that sword."
- `corrected` §I, paragraph 2 — "He needed the money to keep his farm."
- `corrected` §I, vocabulary box — Under the Articles the national government "couldn't ... settle disputes between states"
- `caveated` Paragraph 1 — "when the war ended, the government that owed him years of back pay simply… didn't pay"
- `corrected` Story Behind the Story box, second paragraph — "When the courts came for it, Shays didn't write a letter. He gathered his neighbors, and they marched."
- `caveated` Key Idea box — "It became the single most important reason why men like Washington and Madison agreed to meet in Philadelphia
- `caveated` Figure caption — Caption gloss: the two are "shown rising 'illustrious from the Jail.' Not everyone thought they were villains.
- `caveated` Story Behind the Story box, Franklin entry — Franklin "was carried to the Convention every day in a sedan chair — a covered seat hoisted by four prisoners 
- `caveated` Story Behind the Story box, Madison entry — Madison "used the time to write the Virginia Plan."
- `caveated` Paragraph 6 — "The solution came from Roger Sherman of Connecticut... This 'Great Compromise' saved the Convention."
- `corrected` Primary Source box 1 (after paragraph 6) — PRIMARY SOURCE box attributed to George Washington: "Nothing spoken in the house be printed, or otherwise publ
- `caveated` ¶3 — "The original Constitution said nothing about... freedom of religion."
- `caveated` ¶4 — "State by state, the vote was agonizingly close."
- `corrected` Story Behind the Story — "Leading the parade was a float called 'The Grand Federal Edifice.'"
- `caveated` Paragraph 1 — "…and his mother die of yellow fever."
- `caveated` Paragraph 1 — "…all before he was thirteen."
- `caveated` Story Behind the Story — "The fifteen-year-old Hamilton wrote a letter…"
- `caveated` Paragraph 4, first sentence — "Thomas Jefferson… was horrified" by Hamilton's plan (assumption + Bank + whiskey tax).
- `caveated` Story Behind the Story, sentence 1 — "the national government under the Articles couldn't do anything — Massachusetts had to handle it alone."
- `caveated` Vocabulary box, definition 4 (line 407) — "XYZ Affair: A scandal in which French officials demanded bribes before they would negotiate with American dip
- `caveated` Body paragraph 2 (line 419) — "...and then thousands of its own citizens during the Reign of Terror."
- `caveated` Body paragraph 3 (line 421) — "...Congress passed two of the most controversial laws in American history."
- `corrected` Body paragraph 4 (line 423) — Quotation: the Sedition Act criminalized publishing "false, scandalous, or malicious" writing about the presid
- `caveated` First figure caption, final sentence — Caption frames the 1797 cartoon as evidence that "Campaign propaganda in 1800 was brutal."
- `caveated` Paragraph 3 — "Instead, they unleashed their supporters and hired newspaper writers to destroy each other in print."
- `caveated` Story Behind the Story: The Insults of 1800, sentence 1 — "Jefferson hired a journalist named James Callender to attack Adams."
- `corrected` Story Behind the Story: The Insults of 1800, sentence 2 — "Callender called President Adams 'old, querulous, bald, blind, crippled, and toothless.'"
- `corrected` Story Behind the Story: The Insults of 1800, sentence 3 — "He also mocked Adams's weight, earning the president the nickname 'His Rotundity.'"
- `caveated` Story Behind the Story: The Insults of 1800, paragraph 2 — Jefferson "would destroy Christianity, burn all the Bibles, and invite chaos."
- `caveated` Story Behind the Story: The Insults of 1800, paragraph 2 — "Martha Washington herself reportedly told a visiting minister that Jefferson was 'one of the most detestable 
- `caveated` Paragraph after the insults box — Jefferson won "in part because his old enemy Alexander Hamilton, who despised both men, considered Burr even m
- `caveated` Paragraph beginning "But here is the remarkable part" — "John Adams left. He packed his bags, walked out of the brand-new White House, and went home to Massachusetts.
- `corrected` Primary Source: Jefferson on the "Revolution of 1800" — Primary-source block quotation: "The revolution of 1800 was as real a revolution in the principles of our gove
- `caveated` Second figure caption, credit line — Second figure credited to "Wikimedia."
- `caveated` Final body paragraph — "in 1803, Chief Justice John Marshall decided the landmark case Marbury v. Madison"
- `caveated` Key Idea box, final sentence — "That precedent [of peaceful transfer] has held for over two hundred years."
- `caveated` Key Idea box — "Adams and Jefferson hated each other's politics, but both loved the republic enough to let the system work."
- `caveated` Section heading and paragraph 1 — Section title: "The Election of 1800: The Nastiest Campaign in History" and opening line "If you think modern 

### Resume

```
Workflow({scriptPath: '.../yawpms-ch6-accuracy-ledger-wf_563055da-cb4.js',
          resumeFromRunId: 'wf_563055da-cb4'})
```
Completed agents replay from cache; only the 37 failed refutations re-run.


### Adjudication complete — 2026-09-09

All **118 of 118** flagged claims adversarially checked after the session limit lifted.
**35 upheld, 83 overturned — a 70% overturn rate**, against 40% on ch5.
Nearly three quarters of what the auditors flagged did not survive a second look, which makes
the refutation pass most of the work on this chapter rather than a formality.

| | Count |
|---|---|
| claims audited | 323 |
| verified | 198 |
| flagged | 118 |
| upheld | 35 |
| overturned | 83 |
| could not verify | 7 |
| **pending sign-off** | **33** |

Two upheld rows were applied ahead of the rest, because both were verifiable without an
adjudicator: the Federal Edifice figure was dated 1789 for an August 1788 print, and its
caption called North Carolina "the last pillar" when Rhode Island is drawn broken in the
same image. Both are live.

Review sheet: https://claude.ai/code/artifact/04006738-3f87-4512-bf5b-621d2c280c5f

#### Could not verify

- **Map credit: "(Public domain, Wikimedia Commons)"** (§I, figure 2 figcaption (ch6.html line 118)) — Handoff row, not a shrug: the map's CONTENT is verified (two rows above, by reading the image). What cannot be verified is its provenance clause. MAINTENANCE.md requires 'an attrib
- **"…still insisting that everything he did was to protect the rights he had fought for in 1776."** (Paragraph 5) — Per the method, this stays could_not_verify — it is not upgraded because it sounds like something he would have said. It is a sentiment placed in a dead man's mouth with no source 
- **"Bakers pulled a float with an oven baking 'Federal Bread.'"** (Story Behind the Story) — Bakers were in the procession, so the claim is plausible, not invented. But the oven and the quoted phrase "Federal Bread" are in quotation marks in the text, and I could not confi
- **Adams's supporters called Jefferson "a mean-spirited, low-lived fellow."** (Story Behind the Story: The Insults of 1800, paragraph 2) — Do not upgrade this to verified because it 'sounds like 1800.' It is a quotation whose original printing nobody has produced. For a book that models source-checking to students, an
- **Adams's supporters called Jefferson "a howling atheist."** (Story Behind the Story: The Insults of 1800, paragraph 2) — The documented insults are just as vivid as the undocumented one and carry a citation. Swapping them costs nothing.
- **Adams's supporters called Jefferson "a coward."** (Story Behind the Story: The Insults of 1800, paragraph 2) — Quotation marks are a promise. If the word is a characterization rather than a quotation, it should not be inside them.
- **"Library of Congress." (credit line for the Federal Pillars cartoon)** (Section I, figcaption line 100 — figure 1, federal-pillars.j) — Do not upgrade to verified. The credit may well be right, but nothing in the repo or in LOC's own catalog confirms it, and the manifest asserts a different source.

