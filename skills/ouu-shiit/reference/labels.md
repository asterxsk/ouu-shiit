# The label rule

Every surface this skill touches — a landing page, a printed PDF, a deck, a one-page SVG — carries small labels above or beside larger content: the eyebrow above a headline, the card kicker, the table header, the figure caption, the footer section name, the slide number. **These have exactly one correct treatment, and it is the same treatment in every medium.**

```
A serif (or high-contrast book) face, italic.
Sentence case. No exception for "design" labels.
No letter-spacing. None.
One to one-and-a-half steps smaller than the body text it labels.
```

That is the whole rule. Everything below is why, and how to apply it without re-deriving it per medium.

## The tell being removed

```
SIGNALS AND SYSTEMS  /  SEMESTER PROJECT      ← mono, caps, 2.2px tracking
GROUP 4   ·   FOUR PRESENTERS   ·   2026      ← mono, caps, 2.2px tracking
WORKED EXAMPLE                                ← mono, caps, 1.6px tracking
```

Three things make this the strongest generative-design tell there is:

1. **Tracked uppercase monospace** is the visual grammar of a terminal, a bootstrap badge, a UI chip, and every LLM-generated "premium dark landing page" of the last three years. On paper — and on a deck — it reads as a component pasted onto a page rather than a line of type set on it.
2. **Wide tracking on small caps** is a substitute for hierarchy. It is used when the designer has no italic or small-caps cut to work with, so it announces "this is meta text" by shouting the letters apart. A serif italic says the same thing at a whisper, which is the correct volume for meta text.
3. **The all-caps string itself** loses the words. `HRTF` and `Hrtf` are different tokens; `8D` and `8d` are different tokens. Casing belongs in the source text, where the writer can protect an acronym, not in `text-transform`, which cannot.

The tell is *not* limited to dark themes, to mono fonts, or to uppercase-with-tracking. Any label that is shouting — a grey sans-serif in caps, a bold 10px chip, a filled pill — reads as generated. The fix is the same: serif italic, sentence case, quiet colour.

## The replacement, as a design decision

A serif italic label does four things a tracked mono capital cannot:

| | Tracked mono caps | Serif italic sentence case |
|---|---|---|
| Voice | a UI state | an editorial aside |
| Relationship to the heading | competes — two shouting elements | defers — one speaks, one murmurs |
| Acronyms | destroyed unless escaped | preserved |
| At print size | breaks up; tracking plus small type at 300 dpi is mush | holds; italics survive ink spread |
| In a column | needs extra leading to breathe | sits naturally on the baseline rhythm |

The label is also the place where a document signs its own authorship. `Group 4 · four presenters · 2026` set as a colophon reads as a document someone made. The same content as `GROUP 4 · FOUR PRESENTERS · 2026` reads as a template someone filled in.

## Applying it

### Web (HTML/CSS)

```css
/* One token for the whole surface. Never redefine it per component. */
:root {
  --label-font: "Constantia", "Iowan Old Style", Georgia, serif;
  --label-size: 0.78rem;      /* ~1 step under body */
  --label-tone: var(--muted); /* muted, not accent, unless it is a kicker */
}
.eyebrow, .kicker, .card-label, .table th, .figcaption, .footer-label, .pager {
  font-family: var(--label-font);
  font-style: italic;
  font-weight: 400;
  font-size: var(--label-size);
  letter-spacing: 0;
  text-transform: none;
}
```

Write `Worked example` in the markup, not `WORKED EXAMPLE`. Write `HRTFs after 3D Tune-In`, not `HRTFS AFTER 3D TUNE-IN`.

The eyebrow may take the accent colour; every other label takes the muted or faint tone. **Never put a label in a filled pill unless the pill is a real control** — a static label styled as a button is the same tell by another route.

### Print / PDF (WeasyPrint, Prince, LaTeX, reportlab)

CSS as above. Two print-specific hazards:

- **Subset the italic.** If the label face has no italic cut and the renderer synthesises one (a slanted roman), it looks wrong at 300 dpi — the serifs shear. Ship a real italic file. For PDF builds with a bundled font, subset it with `fonttools subset --flavor=woff2 --layout-features=*` and emit a second `@font-face` with `font-style: italic`.
- **WeasyPrint will not fix your casing.** `text-transform: lowercase` plus `::first-letter { text-transform: uppercase }` does *not* compose — the first-letter rule is ignored and you get `the budget`. Set sentence case in the source.

In LaTeX: `\textsc` is not the answer (small caps are a different shout). Use `\textit{Worked example}` at `\small`, or a `\labelstyle` macro wrapping `\itshape\small`.

### Decks (python-pptx, Keynote, Slides)

No CSS, so the rule has to live in the generator:

```python
def label(slide, text, x, y, w, size=11, color=MUTED):
    """Serif italic label. Casing arrives from the source, not from .upper()."""
    run = slide.shapes.add_textbox(...).text_frame.paragraphs[0].add_run()
    run.text = text                      # "Worked example", not text.upper()
    run.font.name = "Constantia"
    run.font.italic = True
    run.font.size = Pt(size)
    run.font.color.rgb = color
```

If the generator currently calls `.upper()` or applies character spacing (`spc=`), delete it. A deck's speaker notes, section labels, page numbers and footer all move to this style together — changing the title eyebrow alone leaves the deck half-converted and looks worse than either state.

A kicker can take a **short rule before it** (a 0.42in hairline, then the phrase). That is the editorial replacement for the tracked mono caps: the rule carries the emphasis the tracking used to.

### SVG / static asset

`font-style: italic; font-family: Georgia, "Times New Roman", serif;` on the `<text>`. Letter-spacing attributes (`letter-spacing="2"`) on a label must be removed, not reduced — half-tracked caps are the worst of both.

## What the label is *not*

- **Not a substitute for hierarchy.** If a section needs a label because the heading is too weak, fix the heading. A label over a 16px heading is a bandage.
- **Not a colour carrier.** One accent for the kicker; everything else in the muted tone. Labels in five colours is the multi-accent templated look in miniature.
- **Not a container.** No background, no border, no radius, no pill — unless it is a real control.
- **Not uppercase for emphasis.** If something must be emphasised, it gets a bigger size, a heavier weight, or a rule — not capitals.

## Check before shipping

- [ ] No `text-transform: uppercase` anywhere on a label selector.
- [ ] No `letter-spacing` on a label, in CSS, SVG, or a PPTX run's `spc` attribute.
- [ ] Casing lives in the source string, and acronyms (`HRTF`, `ITD`, `FFT`, `8D`, `LTI`) survive verbatim.
- [ ] The label face ships a real italic; no synthesised slant.
- [ ] Every label on the surface shares the same family, size and tone — kicker excepted, which may take the accent.
- [ ] The label is at most 1.5 steps smaller than the body, and no smaller than 9pt in print.
- [ ] Read at arm's length, the label disappears and the heading is what you see. If the label is the first thing you notice, it is still too loud.
