# Maintenance Checklist

**Project:** American Yawp Middle School Edition
**Last Updated:** 2026-02-16

---

## Adding a New Chapter

When adding a new chapter (e.g., ch16.html), follow this checklist:

### HTML Structure
- [ ] Copy an existing chapter (ch1.html) as a template
- [ ] Include skip-to-content link: `<a href="#main-content" class="skip-link">Skip to main content</a>`
- [ ] Use `<nav aria-label="Chapter navigation">` for the top nav bar
- [ ] Use `<nav aria-label="Table of contents">` for the TOC sidebar
- [ ] Use `<main id="main-content">` as the content container (not `<div>`)
- [ ] Use `<aside aria-label="Reading tools">` for the reader toolbar
- [ ] Close with `</main>` (not `</div>`)

### Callout Boxes
All callout boxes must follow these standard patterns:

```html
<!-- Vocabulary Box -->
<div class="vocab-box">
  <h3>Vocabulary</h3>
  <p><strong>Term:</strong> Definition goes here.</p>
</div>

<!-- Key Idea -->
<div class="key-idea">
  <h3>Key Idea</h3>
  <p>Content here.</p>
</div>

<!-- Multiple Perspectives -->
<div class="perspectives">
  <h3>Multiple Perspectives: [Topic]</h3>
  <div class="perspective"><strong>Person/Group:</strong> Their viewpoint.</div>
</div>

<!-- Stop and Think -->
<div class="stop-think">
  <h3>Stop and Think</h3>
  <p>Question or prompt here.</p>
</div>

<!-- Primary Source -->
<div class="primary-source">
  <h3>Primary Source: [Title]</h3>
  <p>Source text here.</p>
  <p class="source-citation">— Attribution</p>
</div>

<!-- Story Behind the Story -->
<div class="story-box">
  <h3>Story Behind the Story</h3>
  <p>Content here.</p>
</div>

<!-- Whose Voices Were Left Out? -->
<div class="voices-left-out">
  <h3>Whose Voices Were Left Out?</h3>
  <p><strong>Group:</strong> Description.</p>
</div>

<!-- Activity Box -->
<div class="activity-box">
  <h3>Chapter Activity: [Title]</h3>
  <p>Instructions here.</p>
</div>
```

### Do NOT Use
- `<dl>`, `<dt>`, `<dd>` in vocab boxes (use `<p><strong>`)
- `<ol>`, `<li>` in stop-think boxes (use `<p>`)
- `<blockquote>` in primary sources (use `<p>`)
- `<div class="attribution">` (use `<p class="source-citation">`)
- Emojis in h3 headings
- ALL CAPS in h3 headings
- `class="activity"` (use `class="activity-box"`)
- `class="perspectives"` for "Voices Left Out" sections (use `class="voices-left-out"`)

### Images
- [ ] Add descriptive `alt` text to every `<img>` tag
- [ ] Use `<figure>` and `<figcaption>` for images with captions
- [ ] Verify image files exist and paths are correct

### Reader Tools
- [ ] Include the reader toolbar HTML (copy from template)
- [ ] Link `js/reader-tools.js`
- [ ] Test all reader tools (font size, spacing, dark mode, focus mode, TTS)

### Interactive Resources
- [ ] Add chapter to quizzes.html (QUIZZES object in `<script>`)
- [ ] Add vocabulary cards (vocabulary data)
- [ ] Add timeline events if applicable
- [ ] Add quiz questions (5 MC + 3 SA recommended)

---

## Modifying CSS

### chapter.css
- **Container max-width:** 640px (do not exceed — maintains ~68-72 chars per line)
- **Breakpoints:** 768px (tablet), 600px (mobile)
- **Custom properties:** `--teal`, `--navy`, `--gold` — use these for colors
- **Dark mode:** Every new style needs a `body.dark-mode` counterpart

### pages.css
- **Container max-width:** 640px (matches chapter.css)
- **Breakpoints:** 768px (tablet), 600px (mobile)
- **Nav styling:** `aria-current="page"` used for current page indicator

### primary-sources.css
- **Caption size:** 14px (recently increased from 13px)
- **Body text:** 15.5px italic, 1.75 line-height

---

## Accessibility Standards

### Required (WCAG 2.1 AA)
- All text must pass WCAG AA contrast ratio (4.5:1 for body text, 3:1 for large text)
- All images must have `alt` text
- All interactive elements must be keyboard-accessible
- Focus indicators must be visible (3px teal outline, 2px offset)
- Skip-to-content link on every page with a header
- ARIA landmarks on every page (`<main>`, `<nav>`, `<aside>`)
- Color must not be the sole means of conveying information

### Best Practices
- Heading hierarchy: h1 → h2 → h3 (never skip levels)
- Touch targets: minimum 44x44px on mobile
- `aria-label` on all `<nav>` elements to distinguish them
- `aria-expanded` on buttons that toggle visibility
- `aria-pressed` on toggle buttons
- `aria-live="polite"` on dynamically updated content

---

## Quarterly Review Checklist

Run these checks every 3 months:

### Content
- [ ] All chapter links work (no broken internal links)
- [ ] All images load correctly
- [ ] Quiz questions are accurate and answers are correct
- [ ] Vocabulary definitions are complete

### Technical
- [ ] Run HTML validation: `npx html-validate ch*.html index.html`
- [ ] Check for console errors in browser dev tools
- [ ] Test reader tools in latest browser versions
- [ ] Verify dark mode styling on all page types
- [ ] Test on at least one mobile device

### Accessibility
- [ ] Run Lighthouse accessibility audit on ch1.html
- [ ] Tab through a chapter page — verify focus indicators
- [ ] Test skip link functionality
- [ ] Verify screen reader announces landmarks correctly

---

## File Structure Reference

```
yawpms/
├── ch1-15.html              # Chapter pages (15 total)
├── index.html               # Home page
├── about.html               # About page
├── contributors.html        # Contributors
├── introduction.html        # Introduction
├── teaching.html            # Teaching materials hub
├── teachers.html            # Teachers hub
├── whopays.html             # Funding info
├── quizzes.html             # Chapter quizzes
├── timeline.html            # Interactive timeline
├── vocabulary-cards.html    # Flash cards
├── cornell-notes.html       # Cornell notes templates
├── graphic-organizers.html  # Graphic organizers
├── slideshows.html          # Chapter slideshows
├── css/
│   ├── chapter.css          # Chapter page styles
│   ├── pages.css            # Supporting page styles
│   └── primary-sources.css  # Primary source reader styles
├── js/
│   └── reader-tools.js      # Reader toolbar functionality
├── images/                  # All site images
├── primary-sources/         # Primary source reader pages
├── DESIGN_GUIDE.md          # Design specifications
├── CSS_AUDIT_AND_IMPLEMENTATION_PLAN.md  # Audit results
├── TESTING_REPORT.md        # Testing checklists
└── MAINTENANCE.md           # This file
```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-02-16 | Initial standardization (ch6/ch7 HTML, CSS cleanup) |
| 1.0.1 | 2026-02-16 | Stage 1: Line length, focus indicators, skip links |
| 1.0.2 | 2026-02-16 | Stages 2-3: ARIA, breakpoints, nav, polish fixes |
