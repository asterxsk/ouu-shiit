# Where each effect belongs

Pick by **job**, then confirm against **visitor mode**. The mode names what success looks like for the visitor; it comes from impeccable's SKILL.md and governs how much effect a surface can carry.

| Mode | Visitor… | Effect budget |
|---|---|---|
| **Persuade** | decides and acts | High. Effects may carry the voice. One focal moment, fully authored. |
| **Experience** | is inside the work | Highest. The artifact leads; interface recedes. |
| **Read** | understands something | Near zero behind text. Structure first. |
| **Operate** | completes a task | None behind content. Feedback, state, and continuity only. |

## Effect placement table

| Effect | Best placement | Also works | Wrong here |
|---|---|---|---|
| **react-three-fiber** ([ref](react-three-fiber.md)) | Hero 3D product or scene that continues into the page; scroll-driven storytelling; configurators | Section focal object, data-driven 3D, particle field, post-processed accent | Behind body copy, inside cards, on Operate screens, more than once per page |
| **Spline** ([ref](spline.md)) | Hero 3D when a designer authored the scene; interactive 3D product or explainer | 3D section accent, interactive state machine in a model | Dense-text pages, dashboards, pages where the 3D has to react to app state |
| **ShaderGradient** ([ref](shader-gradient.md)) | Hero background behind a headline; section background for a single feature band | Card header backdrop, empty-state backdrop, 404, auth screens | Full-page behind scrolling text, repeated per section, behind data tables, more than one instance |
| **liquidglass.js** ([ref](liquid-glass.md)) | Floating chrome: header/nav over content, control cluster over a canvas, modal/filter panel, floating action bar | Toast, tooltip chrome, media overlay controls | Static cards on static backgrounds, anything needing a contrast guarantee over unknown content, stacked glass on glass |
| **liquid-logo** ([ref](liquid-logo.md)) | Intro/reveal moment at first load; footer wordmark; large logo on a brand/About page | Section divider wordmark, loading state | Nav bar, favicon, small sizes, any place the logo must stay legible, repeated positions |
| **Lenis** ([ref](lenis.md)) | Whole-page scroll feel on Persuade/Experience surfaces; scroll-driven storytelling | Portfolio, campaign microsites, pinned-section sequences | Operate dashboards, docs, long tables, search results, mobile-first sites where native momentum is better |
| **Motion** ([ref](motion.md)) | Scroll-linked reveals, parallax, sticky-pinned sequences, layout and exit animation — anything that reads scroll without taking it over | Any React surface that needs one scroll-driven moment; the safe pairing with Lenis; the base layer under most registry components | Simple hover and focus states (use CSS), pages already committed to GSAP, a project that only needs smooth scroll |
| **StringTune** ([ref](stringtune.md)) | Scroll-choreographed marketing sections with many small moments | Campaign pages, cursor-reactive detail work | Anywhere a differently-supported library would be safer — it is young and thinly documented |

## Check the pre-built version first

Four of these effects already exist as free, copy-paste React components in shadcn registries, with the ordinary UI around them included. When the project is React with shadcn configured, look there before writing shader or WebGL code — a component someone else maintains is smaller than a scene you hand-build, and easier for the user's team to edit later.

| Effect | Registry component | Skip building it when |
|---|---|---|
| Liquid glass | Cult UI `distorted-glass`; Kokonut UI `liquid-glass-card` | The project is React + shadcn; a fixed glass panel is enough; there is no need to react to live DOM behind it |
| Liquid metal | Cult UI `hero-liquid-metal`, `metal-button` | The moment is a styled brand accent, not a bespoke shader on the user's own logo asset |
| Shader blur / refraction | Cult UI `shader-lens-blur`, `morph-surface` | The blur is decorative; the effect does not need to track app state |
| Animated gradient background | Cult UI `bg-animated-gradient`, `canvas-fractal-grid`; Watermelon UI animated backgrounds | The background is not the page's one focal moment, or the brief does not need a configurable gradient |
| Particles, shimmer, small animated details | Kokonut UI `particle-button`, `shimmer-text`, `ai-prompt` | The detail is a piece of a bigger composition rather than the composition itself |
| Scroll-reactive marquee / section | Skiper UI scroll components; Motion direct in Cult and Kokonut components | Nothing else on the page owns scroll |

Do not use a registry component as a substitute for the decision. It still has to pass "what job does this do" and it still has to satisfy the contract — in particular, none of these libraries reliably honours `prefers-reduced-motion` on its own, and several bind scroll listeners that will fight a smooth-scroll library. Full detail, including which tiers are paid and which require attribution, is [ui-registries.md](ui-registries.md).

## Choosing between the two 3D paths

| | Spline | react-three-fiber |
|---|---|---|
| Author | Designer, in a GUI | Engineer, in code |
| Agent can build it? | No — needs a scene URL or `.splinecode` from the user | Yes, entirely |
| Reacts to app state | Limited (variables you set up in the editor) | Fully |
| Bundle | Runtime + scene | three + your scene code (~600KB before compression) |
| Right when | Art is done, integration is the job | The 3D logic is the product |
| Wrong when | No designer, no scene, no asset | One decorative object is the whole need |

Default to Spline when the user supplies an authored scene. Default to react-three-fiber when the 3D must respond to data, state, or scroll position programmatically, or when the user has no scene and no designer.

## Choosing where a gradient goes

ShaderGradient replaces one background. It does not become the page.

- **Persuade:** hero. The headline sits on it, and the gradient's composition is chosen so the headline's area stays dark or light enough. One instance.
- **Read / Operate:** no. If a surface needs atmosphere, use a static surface from the world's palette.
- **Experience:** a single section band behind the artifact, never competing with the work itself.

## Glass, honestly

The craft floor refuses glass as decoration. Before adding liquid glass, answer in one sentence: **what is behind it, and why does the user benefit from seeing it?**

Good answers: a nav bar over a hero image the user is looking at; a control cluster over a 3D viewport the user is manipulating; a filter panel over a product grid the user is browsing. The glass communicates "you are on top of this content, and the content is still there."

Bad answers: "it looks modern"; "the card needed something"; "the reference site did it". Use a solid surface, a border, or a real shadow instead.

## Scroll, honestly

Lenis and StringTune replace native scrolling with a smoothed one. That trade is only worth it when the page is *about* its scroll — a story told in sequence, a pinned scene, a horizontal gallery. On a page where the user is scanning to find something and leave, smoothing makes the site feel slower and breaks expectations. When in doubt, do not smooth. `prefers-reduced-motion` always wins, and Lenis honors it by default while StringTune may not.

Motion is not in that trade at all. It reads the scroll position rather than replacing it, so it never changes how the page feels to scroll — it only decides what moves as a result. Reaching for Motion costs bundle size, not scroll feel. See [motion.md](motion.md).

## One owner for scroll

This is the rule that breaks pages most often. Exactly one thing may own scroll position:

| Owner | Use when |
|---|---|
| **Native** | Default. Most pages. |
| **Lenis** | The page needs smoothed scroll and nothing else needs to own it. (`root` mode, whole page.) |
| **drei `ScrollControls`** | A react-three-fiber scene *is* the page and needs a scroll timeline. No Lenis on that page. |
| **StringTune smooth mode** | The page is built on StringTune's CSS-variable model. No Lenis alongside it. |

Never combine them. Lenis plus ScrollControls, or Lenis plus StringTune's smooth mode, produces scroll that fights itself — the symptom is judder, doubled easing, or a page that will not settle. If you need 3D that responds to scroll *and* smooth scroll, pick native scroll plus Lenis and drive your `useFrame` work from the scroll value, rather than reaching for ScrollControls.

**Reads are not ownership, and that is the whole distinction.** Motion, CSS `position: sticky`, `IntersectionObserver`, and scroll-linked animation on the native `ScrollTimeline` all *read* the scroll position. They compose with any owner above — Motion over Lenis is the standard pairing and needs no adapter. `ScrollControls` and StringTune's smooth mode *own* the position, which is why they are on the list and the readers are not. When two things seem to fight, one of them is an owner you forgot about.

Nested scroll containers (modals, drawers, code blocks, horizontal galleries) always opt out of the page's scroll owner — `data-lenis-prevent` for Lenis, `outside-container` for StringTune.

## Asset checklist to hand the user

Name what you need rather than inventing it:

- **liquid-logo:** the logo as SVG, or a transparent PNG at 2× display size. A two-colour mark works best; a photo does not work. Give the SVG explicit width and height.
- **Spline:** the scene URL (`prod.spline.design/<id>/scene.splinecode`) or the exported `.splinecode` file, plus the object names, event names, and variables the page is allowed to drive. Without a scene, Spline is not an option — say so.
- **react-three-fiber:** any product model (`.glb`/`.gltf`), textures, or environment maps. Without them, use primitives or generated geometry and say so.
- **ShaderGradient:** three brand colours, or a screenshot of a designed gradient, or the customize URL from the playground.
- **Fonts:** a display face, if the world calls for one. The system font is not a fallback for a designed page.
