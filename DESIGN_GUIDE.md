# American Yawp MS — Design & Styling Guide

**Version:** 1.0.2
**Last Updated:** 2026-02-16
**Status:** Living Document

---

## Table of Contents

1. [Design Philosophy](#design-philosophy)
2. [Current Implementation Audit](#current-implementation-audit)
3. [Typography System](#typography-system)
4. [Color Palette](#color-palette)
5. [Callout Box System](#callout-box-system)
6. [Layout & Spacing](#layout--spacing)
7. [Accessibility Standards](#accessibility-standards)
8. [Best Practices Compliance](#best-practices-compliance)
9. [Improvement Roadmap](#improvement-roadmap)
10. [Version History](#version-history)

---

## Design Philosophy

### Core Principles

1. **Learning First**: Every design decision prioritizes comprehension and cognitive accessibility
2. **Consistency Breeds Trust**: Predictable patterns across all 15 chapters reduce cognitive load
3. **Accessible by Default**: WCAG AA compliance minimum, AAA where achievable
4. **Progressive Enhancement**: Core content accessible to all; enhanced features for capable devices
5. **Student Agency**: Reader tools empower students to customize their reading experience

### Target Audience

- **Primary**: 6th-8th grade students (ages 11-14)
- **Secondary**: Teachers, homeschool educators, accessibility-focused learners
- **Reading Level**: Lexile 900-1100L (adapted from college-level source material)

---

## Current Implementation Audit

### ✅ Strengths

| Category | Implementation | Compliance |
|----------|----------------|------------|
| **Cognitive Load** | Chunked content, clear hierarchy, consistent callout system | ✅ Excellent |
| **Typography** | Multiple font options (serif/sans-serif/dyslexia-friendly) | ✅ Excellent |
| **Accessibility** | Reader tools: font size, line spacing, dark mode, high contrast | ✅ Excellent |
| **Visual Hierarchy** | Clear heading structure (h1→h2→h3), size/color differentiation | ✅ Good |
| **Consistency** | Standardized HTML structure across all 15 chapters (as of v1.0) | ✅ Excellent |
| **White Space** | Generous padding in callouts (22-26px), margins between sections | ✅ Good |

### ⚠️ Areas for Improvement

| Issue | Current State | Best Practice | Priority |
|-------|---------------|---------------|----------|
| **Body text size** | 17px | 16-18px recommended for screens | ✅ Compliant |
| **Line length** | ~68-72 characters (640px container) | 50-75 optimal | ✅ Fixed |
| **Contrast ratios** | All tested combinations pass WCAG AA/AAA | WCAG AA: 4.5:1 minimum | ✅ Audited |
| **Color-only indicators** | Callout boxes use color + border | Must pair with text/icons | Medium |
| **Reading pattern optimization** | Linear top-to-bottom | Consider F-pattern optimization | Low |
| **Callout icons** | Text-only headers | Icons improve scannability | Medium |

---

## Typography System

### Font Stack

```css
/* Primary (Body) - Serif for extended reading */
font-family: 'Libre Baskerville', Georgia, serif;

/* Alternative (Sans-serif) - User-selectable via reader tools */
font-family: 'Source Sans 3', sans-serif;

/* Headings & UI */
font-family: 'Lexend', 'Source Sans 3', sans-serif;

/* Accessibility (Dyslexia-friendly) - User-selectable */
font-family: 'OpenDyslexic', sans-serif;
```

### Type Scale

| Element | Size | Weight | Line Height | Notes |
|---------|------|--------|-------------|-------|
| **Body text** | 17px | 400 | 1.8 | Optimized for screen reading |
| **H1 (Chapter title)** | 48px | 700 | 1.2 | Title page only |
| **H2 (Section)** | 28px | 600 | 1.4 | Main section headings |
| **H3 (Subsection)** | 20px | 600 | 1.5 | Subsections & callout headers |
| **Callout body** | 16px | 400 | 1.7-1.75 | Slightly smaller for visual distinction |
| **Callout label** | 12px | 700 | 1.2 | UPPERCASE, 1.5px letter-spacing |

### Responsive Font Sizing

User-controlled via reader tools:

- **Default**: 17px body
- **Large**: 19px body, 18px callouts
- **X-Large**: 21px body, 20px callouts

### Line Spacing Options

- **Default**: 1.8
- **Wide**: 2.2
- **X-Wide**: 2.5

---

## Color Palette

### Primary Colors (CSS Variables)

```css
:root {
  --navy: #1B3A5C;      /* Headings, navigation */
  --teal: #2A7F8E;      /* Vocabulary, accents */
  --gold: #C4941D;      /* TOC active state, borders */
  --cream: #FAFAF8;     /* Page background */
  --dark-gray: #2C2C2C; /* Body text */
  --light-gray: #F5F5F5;/* Subtle backgrounds */
}
```

### Callout Box Color System

| Callout Type | Background | Border | Text/Accent | Purpose |
|--------------|------------|--------|-------------|---------|
| **Vocabulary** | `#F0F7FA` (cool blue-tint) | `#2A7F8E` (teal, 4px left) | `#2A7F8E` | Definitions, key terms |
| **Stop & Think** | `#FFFBF0` (warm yellow-tint) | `#C4941D` (gold, 4px left) | `#9A7410` | Reflection prompts |
| **Multiple Perspectives** | `#F7F2FD` (purple-tint) | `#7C3AED` (purple, 4px left) | `#7C3AED` / `#5B21B6` | Diverse viewpoints |
| **Key Idea** | `#F0F7F0` (green-tint) | `#2E7D32` (green, 4px left) | `#2E7D32` | Essential takeaways |
| **Primary Source** | `#FFFAF5` (warm peach-tint) | `#BF360C` (deep red, 4px left) | `#BF360C` | Historical documents |
| **Story Box** | `#FFFAF2` (warm orange-tint) | `#E67E22` (orange, 4px left) | `#C56A12` | Narrative examples |
| **Voices Left Out** | `#FDF2F5` (pink-tint) | `#C2185B` (mauve, 4px left) | `#C2185B` / `#AD1457` | Marginalized perspectives |

### Color Psychology Alignment

✅ **Cool colors (blue, green)** → Supporting details, definitions, key concepts
✅ **Warm colors (yellow, orange, red)** → Emphasis, activities, critical analysis
✅ **Consistent mapping** → Same color = same content type across all chapters

### Dark Mode Palette

Automatically applied when user enables dark mode:

- **Background**: `#121212` (near-black)
- **Text**: `#d0d0d0` (off-white)
- **Callout backgrounds**: Darkened versions with preserved hue relationships
- **Borders**: Brightened for visibility against dark backgrounds

---

## Callout Box System

### Design Specifications

#### Shared Styles (All Callout Types)

```css
/* Visual container */
border-radius: 6px;
padding: 22px 26px;
margin: 28px 0;
border-left: 4px solid [accent-color];

/* Header styling */
h3 {
  font-family: 'Source Sans 3', sans-serif;
  font-size: 12px;
  font-weight: 700;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  margin: 0 0 14px;
  padding-bottom: 10px;
  border-bottom: 1px solid [accent-color-alpha-15%];
}

/* Body text */
p {
  font-family: 'Source Sans 3', sans-serif;
  font-size: 16px;
  line-height: 1.7-1.75;
}
```

#### Callout-Specific Features

**Multiple Perspectives**
- Each `.perspective` div has:
  - Left border (3px, accent color, 20% opacity)
  - Top border separator between perspectives (1px, 8% opacity)
  - Padding-left: 14px for visual "quotation" effect
- `<strong>` labels displayed as block elements with letter-spacing

**Voices Left Out**
- Each `<p>` (representing one marginalized group) has:
  - Bottom border separator (1px, accent color, 8% opacity)
  - Padding-bottom: 12px
  - `<strong>` group names with letter-spacing for emphasis

**Key Idea**
- Simple, clean design
- Larger line-height (1.75) for reflective reading

### HTML Structure (Standardized v1.0)

```html
<!-- Key Idea -->
<div class="key-idea">
  <h3>Key Idea: [Title]</h3>
  <p>[Content paragraph 1]</p>
  <p>[Content paragraph 2]</p>
</div>

<!-- Multiple Perspectives -->
<div class="perspectives">
  <h3>Multiple Perspectives: [Question]</h3>
  <div class="perspective">
    <strong>[Viewpoint Label]:</strong> [Content]
  </div>
  <div class="perspective">
    <strong>[Viewpoint Label]:</strong> [Content]
  </div>
</div>

<!-- Whose Voices Were Left Out -->
<div class="voices-left-out">
  <h3>Whose Voices Were Left Out?</h3>
  <p><strong>[Group Name]:</strong> [Explanation]</p>
  <p><strong>[Group Name]:</strong> [Explanation]</p>
</div>
```

### Best Practice Compliance

✅ **Consistent design language** → Same callout type looks identical across all chapters
✅ **Color + structure** → Not relying on color alone (borders, headings, typography all provide cues)
⚠️ **Missing icons** → Future enhancement to improve scannability
✅ **Concise content** → Callouts kept focused and digestible
✅ **Strategic positioning** → Full-width for major concepts

---

## Layout & Spacing

### Container & Grid

```css
.container {
  max-width: 640px;     /* ~68-72 characters at 17px */
  margin: 0 auto;
  padding: 48px 24px;
}
```

**✅ Line Length**: Optimized to ~68-72 characters per line (reduced from 720px to 640px in v1.0.1).

### Vertical Rhythm

| Element | Top Margin | Bottom Margin |
|---------|------------|---------------|
| **H2 (Section)** | 48px | 16px |
| **H3 (Subsection)** | 32px | 16px |
| **Paragraph** | 0 | 20px |
| **Callout boxes** | 28px | 28px |
| **Figures (images)** | 32px | 32px |

### White Space Philosophy

✅ **Generous padding inside callouts** (22-26px) aids comprehension
✅ **Clear separation between elements** (28-48px margins)
✅ **Breathing room around headings** prevents visual crowding
⚠️ **Could benefit from more horizontal margins** on smaller screens

---

## Accessibility Standards

### WCAG Compliance Target

**Minimum**: WCAG 2.1 Level AA
**Goal**: WCAG 2.1 Level AAA where feasible

### Current Accessibility Features

#### ✅ Implemented

| Feature | Implementation | Standard |
|---------|----------------|----------|
| **Text resizing** | Font size controls (Default/Large/X-Large) | WCAG AA |
| **Custom line spacing** | User-selectable (1.8 / 2.2 / 2.5) | WCAG AA |
| **Color themes** | Light / Dark / Sepia / High Contrast | WCAG AA |
| **Font options** | Serif / Sans-serif / OpenDyslexic | Best Practice |
| **Keyboard navigation** | Full keyboard support via reader tools | WCAG AA |
| **Semantic HTML** | Proper heading hierarchy (h1→h2→h3) | WCAG AA |
| **Focus indicators** | Custom :focus-visible outlines (teal, 3px) + focus mode | WCAG AA |
| **Skip links** | Skip-to-content link on all chapter pages | WCAG AA |

#### ⚠️ Needs Audit/Testing

| Requirement | Action Needed | Priority |
|-------------|---------------|----------|
| **Contrast ratios** | ✅ Audited — all pass WCAG AA/AAA | ✅ Complete |
| **Non-text contrast** | ✅ Callout borders meet 3:1 ratio | ✅ Complete |
| **Alt text** | ✅ 100% coverage (127/127 images) | ✅ Complete |
| **Color independence** | Confirm callouts distinguishable without color perception | Medium |
| **Focus order** | Test keyboard navigation flow | Medium |
| **Screen reader testing** | Test with NVDA, JAWS, VoiceOver | Medium |

### Cognitive Accessibility

✅ **Consistent layout** → Predictable structure across all chapters
✅ **Clear language** → 6th-8th grade reading level
✅ **Vocabulary support** → Definitions provided inline
✅ **Chunked content** → Short sections, clear subheadings
✅ **Reader control** → Students can customize reading experience

---

## Best Practices Compliance

### Cognitive Load Management

| Principle | Implementation | Status |
|-----------|----------------|--------|
| Break into digestible chunks | Sections rarely exceed 500 words; callouts break up text | ✅ Excellent |
| Align design with learning objectives | Callout types map to pedagogical goals | ✅ Excellent |
| Minimize extraneous load | Clean design, no decorative elements | ✅ Excellent |

### Visual Hierarchy

| Tool | Implementation | Status |
|------|----------------|--------|
| Size | Clear type scale (48px → 28px → 20px → 17px) | ✅ Good |
| Color | Accent colors draw attention to callouts | ✅ Good |
| Contrast | High contrast headings (navy on cream) | ✅ Audited |
| Alignment | Consistent left-alignment, grid system | ✅ Good |
| Proximity | Related content grouped visually | ✅ Good |
| Whitespace | Generous spacing isolates important content | ✅ Excellent |

### Reading Patterns

⚠️ **F-Pattern Optimization**: Current layout is optimized for linear reading. Consider:
- Placing key takeaways at top-left of sections
- Using pull quotes or highlighted sentences in left margin
- Ensuring first words of paragraphs are meaningful

### Typography Principles

| Guideline | Current | Compliant? |
|-----------|---------|------------|
| Readable font | Libre Baskerville (serif), Source Sans 3 (sans) | ✅ Yes |
| Body text size | 17px | ✅ Yes (16-18px recommended) |
| Large text | 18pt+ in headings | ✅ Yes |
| Line spacing | 1.8 (body), 1.7-1.75 (callouts) | ✅ Yes (1.5-2.0 recommended) |
| Line length | ~68-72 characters (640px) | ✅ Yes (50-75 optimal) |
| Contrast | All combinations pass WCAG AA/AAA | ✅ Audited |
| Font families | 3 families (serif, sans, dyslexic) | ✅ Yes (1-2 recommended, +1 for accessibility OK) |

---

## Improvement Roadmap

### Priority 1 (High) — Accessibility Compliance

- [x] **Contrast Audit**: All text/background combinations pass WCAG AA/AAA (audited v1.0.1)
- [x] **Alt Text Audit**: 100% coverage (127/127 images) — descriptive alt on all (re-verified 2026-09-08)
- [x] **Non-text Contrast**: Callout borders meet 3:1 ratio (audited v1.0.1)
- [ ] **Screen Reader Testing**: Test with assistive technologies (NVDA, JAWS, VoiceOver)

### Priority 2 (Medium) — Usability Enhancements

- [x] **Line Length Reduction**: Reduced max-width from 720px to 640px (~68-72 chars) (fixed v1.0.1)
- [ ] **Callout Icons**: Add consistent icon system for instant recognition
  - Key Idea: 💡 lightbulb
  - Perspectives: 💬 speech bubbles
  - Vocabulary: 📖 book/dictionary
  - Primary Source: 📜 scroll/document
  - Stop & Think: 🤔 thinking face
  - Voices Left Out: 🔇 muted speaker
- [ ] **Color Independence Test**: Verify callouts distinguishable in grayscale
- [ ] **F-Pattern Optimization**: Consider layout tweaks for scanning behavior

### Priority 3 (Low) — Polish & Enhancement

- [ ] **Pull Quotes**: Extract compelling quotes for left-margin emphasis
- [ ] **Learning Objectives**: Add explicit learning objectives callout at chapter start
- [ ] **Chapter Summary Callout**: Standardize end-of-chapter "Key Takeaways" box
- [ ] **Hover Effects**: Add subtle hover states to glossary terms, links
- [ ] **Print Stylesheet**: Optimize CSS for PDF export/printing

---

## Version History

### Version 1.0.2 (2026-02-16)

**Stage 2 — Accessibility Enhancements:**
- ✅ Added ARIA landmarks to all 15 chapter pages (`<main>`, `<aside>`, `<nav>` with aria-labels)
- ✅ Added comprehensive ARIA attributes to reader tools (`aria-expanded`, `aria-pressed`, `aria-label`, `aria-live`)
- ✅ Added tablet breakpoint (768px) for chapter and supporting pages
- ✅ Standardized navigation across all 34 supporting pages (`aria-label`, `aria-current="page"`)

**Ch6/Ch7 Callout Box Standardization:**
- ✅ Converted vocab boxes from `dl/dt/dd` to `p/strong` format
- ✅ Converted stop-think from `ol/li` to `p` format
- ✅ Converted primary-source from `blockquote` to `p` with `p.source-citation`
- ✅ Fixed "Whose Voices Were Left Out?" sections (`class="voices-left-out"` with `<p>` children)
- ✅ Fixed activity boxes (`class="activity-box"`)
- ✅ Removed emojis from h3 headings and normalized casing
- ✅ Fixed container closing tags (`</div>` → `</main>`)

**Stage 3 — Polish & Consistency:**
- ✅ Timeline: Added visible category text badges (WCAG: not color-only)
- ✅ Quizzes: Added ✓/✗ icons to feedback and answer labels
- ✅ Primary sources: Increased caption font-size from 13px to 14px
- ✅ Vocabulary cards: Added smooth easing to flip animation (`cubic-bezier(.4, 0, .2, 1)`)

**Files Changed:**
- `ch1-15.html` — ARIA landmarks, skip links, semantic elements
- `ch6.html`, `ch7.html` — Complete callout box restructuring
- `css/chapter.css` — Tablet breakpoint
- `css/pages.css` — Tablet breakpoint, `aria-current` styling
- `css/primary-sources.css` — Caption font-size (13px → 14px)
- `js/reader-tools.js` — Comprehensive ARIA attributes
- `timeline.html` — Category text badges
- `quizzes.html` — Feedback icons (✓/✗)
- `vocabulary-cards.html` — Flip animation easing
- `index.html` — Nav semantics
- 32+ supporting pages — Nav aria-labels

---

### Version 1.0.1 (2026-02-16)

**Stage 1 — CSS Audit Fixes:**
- ✅ Reduced container max-width from 720px to 640px (~68-72 chars per line)
- ✅ Added skip-to-content links on all 15 chapter pages
- ✅ Added custom `:focus-visible` indicators (3px teal outline)
- ✅ Fixed vocab-box paragraph font size (15px → 16px) and line-height (1.65 → 1.7)
- ✅ Improved vocab-box readability: terms display as block labels (teal) above definitions, with separator borders between entries
- ✅ Completed contrast ratio audit (all pass WCAG AA/AAA)
- ✅ Completed alt text audit (99.2% coverage, 125/126 images)

**Files Changed:**
- `ch1-15.html` — Skip-to-content links
- `css/chapter.css` — Focus indicators, line length, vocab-box styling
- `css/pages.css` — Line length (720px → 640px)
- `DESIGN_GUIDE.md` — Updated to reflect audit results

---

### Version 1.0.0 (2026-02-16)

**Major Changes:**
- ✅ Standardized HTML structure across all 15 chapters
  - Converted ch6-7 from legacy "label-style" to h3-based structure
  - All callout boxes now use identical HTML patterns
- ✅ Typography improvements to callout boxes
  - Increased body text from 15px → 16px
  - Added color-matched h3 border-bottom separators
  - Enhanced visual structure in "Multiple Perspectives" with left-borders
  - Added separator lines in "Voices Left Out" between entries
- ✅ CSS cleanup
  - Removed 80+ lines of legacy CSS rules
  - Consolidated dark mode, font-size, and responsive styles
- ✅ Created comprehensive design guide document

**Files Changed:**
- `ch6.html`, `ch7.html` — HTML structure standardization
- `css/chapter.css` — Typography updates, CSS cleanup
- `DESIGN_GUIDE.md` — Initial design documentation (this file)

**Next Version Goals:**
- Accessibility audit (contrast ratios, alt text)
- Icon system implementation
- Line length optimization

---

## Document Maintenance

### How to Update This Guide

1. **When making design changes:**
   - Update relevant sections (Typography, Color Palette, Layout, etc.)
   - Document rationale in commit messages
   - Increment version number following semantic versioning

2. **Version numbering:**
   - **Major (X.0.0)**: Breaking changes, major redesigns
   - **Minor (1.X.0)**: New features, significant improvements
   - **Patch (1.0.X)**: Bug fixes, minor adjustments

3. **Required sections for updates:**
   - Version History (what changed, why, when)
   - Current Implementation Audit (update compliance status)
   - Improvement Roadmap (add new items, mark completed)

### Contribution Guidelines

- All design changes must reference this guide
- Deviations from standards require documented justification
- Accessibility regressions are unacceptable
- Consistency > individual aesthetics

---

**Last reviewed:** 2026-02-16
**Next review due:** 2026-03-16 (or after 10+ chapters edited)
