# Contributing to American Yawp MS

Thank you for your interest in making history education free and accessible for every middle school student. This project depends on contributions from teachers, historians, developers, students, and anyone who believes textbooks shouldn't cost $100.

## Ways to Contribute

### Teachers

- **Pilot a chapter** in your classroom and share what worked and what didn't
- **Review content** for age-appropriateness, clarity, and engagement
- **Suggest activities** — debates, projects, discussions that worked with your students
- **Report confusing sections** — if your students struggled with something, we want to know

### History Educators and Historians

- **Review chapters for accuracy** — catch errors, suggest better framing, flag outdated interpretations
- **Write or revise content** — propose new "Story Behind the Story" boxes, primary source selections, or "Whose Voices Were Left Out?" sections
- **Suggest primary sources** — especially from underrepresented perspectives

### Curriculum Designers

- **Build lessons and projects** around existing chapters
- **Align content to state standards** — help us map chapters to your state's framework
- **Create assessments** that go beyond recall (analytical prompts, document-based questions, Socratic seminars)

### Special Education and ELL/ESL Specialists

- **Review for accessibility** — reading level, vocabulary scaffolding, visual supports
- **Suggest adaptations** for diverse learners
- **Test reader tools** — font options, read-aloud, line focus, high-contrast themes

### Developers and Designers

- **Fix bugs** in the reader tools or chapter layouts
- **Improve accessibility** — screen reader support, keyboard navigation, ARIA labels
- **Optimize performance** — image loading, mobile experience

### Students

- **Tell us what's engaging and what's boring** — your feedback shapes the textbook
- **Spot typos and confusing sentences** — every fix matters

## How to Submit Changes

### Quick Fixes (typos, broken links, small corrections)

1. Open an [issue](https://github.com/shiebenaderet/yawpms/issues) describing the problem
2. Or fork the repo, make the fix, and submit a pull request

### Content Contributions (new sections, chapter revisions, activities)

1. **Open an issue first** to discuss what you'd like to write or change
2. Fork the repository
3. Create a branch for your work (`git checkout -b your-branch-name`)
4. Make your changes
5. Submit a pull request with a clear description of what you changed and why

### Classroom Feedback

If you used a chapter in your classroom, open an issue with the **Chapter Review** template and tell us:

- Which chapter and grade level
- What students responded to
- What was confusing or didn't land
- Any activities you adapted or created

## Content Guidelines

### Voice and Tone

- **Write for middle schoolers** (grades 6-8) — clear, direct, engaging
- **Tell stories** — history is about people, not abstractions
- **Be honest about complexity** — don't oversimplify, but don't overwhelm
- **Center diverse voices** — if a section only tells one perspective, ask who's missing

### Structure

Each chapter follows a consistent pattern:

- Narrative sections with historical storytelling
- **"Story Behind the Story"** callout boxes — fascinating details that make history memorable
- **Primary source quotes** — real words from the people who lived it
- **"Multiple Perspectives"** boxes — competing viewpoints on contested events
- **"Whose Voices Were Left Out?"** sections — explicitly addressing who's missing from the narrative
- **"Stop and Think"** questions — analytical prompts, not recall quizzes
- **Vocabulary boxes** — key terms with student-friendly definitions

See `MAINTENANCE.md` for the full HTML structure and callout box patterns.

### Images

- Use images from Wikimedia Commons (public domain) or *The American Yawp* (CC BY-SA 4.0)
- Every `<img>` tag must have a descriptive `alt` attribute
- Add images to the appropriate `images/chN/` folder
- Create or update the download script in `scripts/`

## Running the Project Locally

This is a static HTML site — no build tools required.

```bash
git clone https://github.com/shiebenaderet/yawpms.git
cd yawpms

# Download images (they're not stored in the repo)
bash scripts/download_all_images.sh
bash scripts/download_all_maps.sh

# Open any chapter in your browser
open ch1.html
```

## Code of Conduct

Be kind. Be constructive. Remember that this project exists to help kids learn history. Contributions should reflect that spirit — inclusive, respectful, and focused on making education better for everyone.

## License

By contributing, you agree that your contributions will be licensed under the [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license. This ensures all contributions remain free and open forever.

## Questions?

Open an [issue](https://github.com/shiebenaderet/yawpms/issues) or check the [README](README.md) for more context about the project.
