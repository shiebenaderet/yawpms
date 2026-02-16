# American Yawp MS

**A free, open-source middle school American history textbook.**

Adapted from [*The American Yawp*](http://www.americanyawp.com/), the collaboratively built college-level textbook, and rewritten for 6th-8th grade readers.

**[Read it live here](https://shiebenaderet.github.io/yawpms)**

---

## About This Project

**American Yawp MS** (Middle School Edition) is a free, open-source American history textbook that treats students like thinkers, not test-takers. It tells real stories, includes the voices that traditional textbooks leave out, and asks hard questions instead of easy ones.

This project is built on a simple belief: history education should be universally accessible. That means free forever, with no paywalls, no ads, and no commercialization.

### What "Yawp" Means

**Yawp** \yôp\ *n*: 1: a raucous noise 2: rough vigorous language

> "I sound my barbaric yawp over the roofs of the world."
> —Walt Whitman, *Song of Myself* (1855)

The name comes from Walt Whitman's celebration of the diverse, messy, and vibrant voices that make up America. This textbook embraces that spirit.

---

## Why This Exists

Most middle school history textbooks are expensive, dry, and sanitized. They present history as a list of facts to memorize rather than a story to wrestle with. They skim over complexity, avoid controversy, and leave out the perspectives of women, Indigenous peoples, enslaved Africans, immigrants, and working people.

**American Yawp MS** is different. It's:

- **Free forever** — Licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/), ensuring it can never be locked behind a paywall
- **Narrative-driven** — History told through people, scenes, and drama
- **Inclusive** — Centering marginalized voices and asking "whose voices were left out?"
- **Rigorous** — College-level scholarship adapted for middle schoolers
- **Open-source** — Anyone can use, adapt, and improve it

---

## What Makes It Different

Each chapter includes:

- **Narrative storytelling** — History told through people and drama, not dry summaries
- **"Story Behind the Story" callouts** — Fascinating details that make history stick
- **Primary source voices** — Actual quotes from the people who lived it
- **Multiple Perspectives boxes** — Competing viewpoints on contested events
- **"Whose Voices Were Left Out?" sections** — Explicitly addressing exclusion and power
- **Stop and Think questions** — Analytical prompts, not recall quizzes
- **Vocabulary boxes** — Key terms with student-friendly definitions
- **Chapter activities** — Debates, rankings, and evidence-based discussions
- **Built-in reader tools** — Text size and line spacing (including extra-wide), **OpenDyslexic** font option, line focus, read-aloud with speed control, reading-time estimate, highlighting, notes, sepia/dark/high-contrast themes, and selective Print/PDF. Respects reduced-motion preferences.

---

## Volume I: To 1877 (Chapters 1–15)

The primary focus of this project is **Volume I**, covering pre-Columbian America through Reconstruction. These 15 chapters align with most middle school U.S. history curricula.

| Chapter | Title | Status |
|---------|-------|--------|
| 1 | [Indigenous America](https://shiebenaderet.github.io/yawpms/ch1.html) | ✓ Draft |
| 2 | [Colliding Cultures](https://shiebenaderet.github.io/yawpms/ch2.html) | ✓ Draft |
| 3 | [British North America](https://shiebenaderet.github.io/yawpms/ch3.html) | ✓ Draft |
| 4 | [Colonial Society](https://shiebenaderet.github.io/yawpms/ch4.html) | ✓ Draft |
| 5 | [The American Revolution](https://shiebenaderet.github.io/yawpms/ch5.html) | ✓ Draft |
| 6 | [A New Nation (1786-1800)](https://shiebenaderet.github.io/yawpms/ch6.html) | ✓ Draft |
| 7 | [The Early Republic (1800-1824)](https://shiebenaderet.github.io/yawpms/ch7.html) | ✓ Draft |
| 8 | [The Market Revolution](https://shiebenaderet.github.io/yawpms/ch8.html) | ✓ Draft |
| 9 | [Democracy in America](https://shiebenaderet.github.io/yawpms/ch9.html) | ✓ Draft |
| 10 | [Religion and Reform](https://shiebenaderet.github.io/yawpms/ch10.html) | ✓ Draft |
| 11 | [The Cotton Revolution](https://shiebenaderet.github.io/yawpms/ch11.html) | ✓ Draft |
| 12 | [Manifest Destiny](https://shiebenaderet.github.io/yawpms/ch12.html) | ✓ Draft |
| 13 | [The Sectional Crisis](https://shiebenaderet.github.io/yawpms/ch13.html) | ✓ Draft |
| 14 | [The Civil War](https://shiebenaderet.github.io/yawpms/ch14.html) | ✓ Draft |
| 15 | [Reconstruction](https://shiebenaderet.github.io/yawpms/ch15.html) | ✓ Draft |

**Volume II** (1877–present) is planned for future development. Most middle school curricula end with Reconstruction, and most high schools start American history at or after this point. If there's demand for a middle school adaptation of Volume II, we'll build it.

---

## How to Use This Textbook

### Read Online

Visit **[shiebenaderet.github.io/yawpms](https://shiebenaderet.github.io/yawpms)** to read chapters in your browser.

### Run Locally

Clone the repo and open any `.html` file in your browser:

```bash
git clone https://github.com/shiebenaderet/yawpms.git
cd yawpms
open ch1.html
```

### Download Images

Images are sourced from *The American Yawp* (CC BY-SA 4.0) and Wikimedia Commons (public domain). To get **all** chapter images and maps in the right place (so they load in the browser), run from the repo root:

```bash
bash scripts/download_all_images.sh   # ch1–ch15 (including ch6)
bash scripts/download_all_maps.sh     # maps only (Beringia, 13 colonies, triangular trade, etc.)
```

Or run per-chapter scripts, e.g. `bash scripts/download_ch1_images.sh`. See **IMAGES_AUDIT.md** if images don’t load (wrong folder or missing files).

---

## Companion Resources

- **[Introduction](https://shiebenaderet.github.io/yawpms/introduction.html)** — Why this project exists and what makes it different
- **[About](https://shiebenaderet.github.io/yawpms/about.html)** — The story behind American Yawp MS
- **[Teaching Materials](https://shiebenaderet.github.io/yawpms/teaching.html)** — Resources for educators
- **[Contributors](https://shiebenaderet.github.io/yawpms/contributors.html)** — The people making this happen
- **[Who Pays for This?](https://shiebenaderet.github.io/yawpms/whopays.html)** — The economics of free education
- **Primary Source Reader** — *Under construction*

---

## Call for Collaborators

**This project needs you.**

One person can only do so much. If any of this sounds like you, please reach out:

- **Teachers** who want to pilot chapters in their classrooms and give feedback
- **History educators** who want to write or review chapter content
- **Curriculum designers** who want to build lessons, projects, and activities
- **Special education teachers** who can help ensure accessibility for all learners
- **ELL/ESL specialists** who can help adapt content for multilingual classrooms
- **Designers and developers** who want to improve the reading experience
- **Students** who are willing to tell us what's engaging and what's not

### How to Contribute

1. **Open an issue** — Share feedback, suggest corrections, or propose a new chapter
2. **Submit a pull request** — Write content, fix errors, or improve the design
3. **Pilot a chapter** — Use it in your classroom and tell us what happened
4. **Spread the word** — Share the project with teachers and educators who might want to help

No contribution is too small. A typo fix matters. A student saying "this part was confusing" matters. A teacher saying "my kids loved this activity" matters.

---

## Project Structure

```
yawpms/
├── index.html                    # Landing page
├── ch1.html – ch15.html          # Chapters 1–15 (Volume I)
├── introduction.html             # Project introduction
├── about.html                    # About page
├── contributors.html             # Contributors page
├── teaching.html                 # Teaching materials
├── whopays.html                  # Who pays for this?
├── primary-source-reader.html    # Primary source reader (under construction)
├── css/
│   ├── chapter.css               # Shared chapter stylesheet
│   ├── pages.css                 # Shared supporting-page stylesheet
│   └── index.css                 # Landing page stylesheet
├── js/
│   └── reader-tools.js           # Reader tools (highlighting, notes, TTS, PDF, etc.)
├── images/
│   ├── ch1/ … ch15/              # Chapter images and maps (run scripts to populate)
├── scripts/
│   ├── download_all_images.sh    # Download all chapter images (ch1–ch15)
│   ├── download_all_maps.sh      # Download all maps into images/chN
│   ├── download_ch1_images.sh … download_ch15_images.sh
│   └── ...
├── IMAGES_AUDIT.md               # Image reference & troubleshooting
├── MAPS.md                       # Maps plan and sources
└── README.md
```

---

## License

This adaptation is licensed under [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).

Adapted from *The American Yawp*, edited by Joseph L. Locke and Ben Wright (Stanford University Press, 2018). Original images are used under their respective Creative Commons or public domain licenses.

**What CC BY-SA means in practice:**

- You are free to use, remix, and redistribute this material for any purpose—including commercial use
- You must give appropriate credit to the original source
- You must share your adaptations under the same license
- This ensures the material stays free and open forever

**What this license prohibits:**

- Locking this material behind a paywall
- Selling it on platforms like Teachers Pay Teachers
- Changing the license to restrict future use

If you believe history education should be universally accessible, this license is your guarantee.

---

## Credits

This project would not exist without the groundbreaking work of the editors, authors, and contributors to *The American Yawp*. We are deeply grateful to:

- **Joseph L. Locke** and **Ben Wright**, editors of *The American Yawp*
- The **300+ historians** who wrote and reviewed the original textbook
- **Stanford University Press**, for publishing and supporting open-source scholarship
- The **Creative Commons community**, for building the legal framework that makes projects like this possible

---

## Contact

Questions? Feedback? Want to contribute?

- **GitHub Issues:** [github.com/shiebenaderet/yawpms/issues](https://github.com/shiebenaderet/yawpms/issues)
- **Email:** (coming soon)

---

**American Yawp MS** is a passion project created by a history educator who believes that every student deserves access to high-quality, free, and inclusive history education. If you believe that too, join us.
