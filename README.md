# The American Yawp Jr.

A middle school adaptation of [*The American Yawp*](http://www.americanyawp.com/), the free, online, collaboratively built American history textbook.

## About This Project

*The American Yawp Jr.* reimagines the open-source college textbook for 6th–8th grade readers. Each chapter features:

- **Narrative storytelling** — History told through people, scenes, and drama, not dry summaries
- **"Story Behind the Story" callouts** — The fascinating details that make history stick
- **Primary source voices** — Actual quotes from the people who lived it
- **Multiple Perspectives boxes** — Competing viewpoints on contested events
- **"Whose Voices Were Left Out?" sections** — Explicitly addressing exclusion and power
- **Stop and Think questions** — Analytical prompts, not recall quizzes
- **Vocabulary boxes** — Key terms with student-friendly definitions
- **Chapter activities** — Debates, rankings, and evidence-based discussions

## Chapters

| Chapter | Title | Status |
|---------|-------|--------|
| 6 | A New Nation (1786–1800) | ✅ Draft |
| 7 | The Early Republic (1800–1824) | 🔜 Coming |
| 1–5, 8–30 | Additional chapters | 📋 Planned |

## Getting Started

### View the chapters
Open any `.html` file in your browser. If hosting on GitHub Pages, visit the site URL.

### Download images
Images are sourced from *The American Yawp* (CC BY-SA 4.0) and are not included in the repository. To download them:

```bash
bash scripts/download_ch6_images.sh
```

### Project structure
```
yawp-jr/
├── ch6.html                  # Chapter 6: A New Nation
├── images/
│   └── ch6/                  # Chapter 6 images (download via script)
├── scripts/
│   └── download_ch6_images.sh
└── README.md
```

## License

This adaptation is licensed under [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).

Adapted from *The American Yawp*, eds. Joseph Locke and Ben Wright (Stanford University Press, 2018). Original images are used under their respective Creative Commons or public domain licenses.

## Contributing

This project is in active development. Feedback from teachers, students, and historians is welcome. Open an issue or submit a pull request.
