# Which medium, therefore which reference

Read this **first**, before [usage-map.md](usage-map.md) and before loading any technology reference. It answers the question that comes before every other question in this skill: *what is actually being made?*

**Stand down when the medium is out of scope.** This skill is an effect and motion layer. It carries deep references for the web and for video, and routing rows for everything else. If the request is an Android app's information architecture, an iOS onboarding flow, or a slide deck's argument, the work belongs to another skill — say so and hand off, rather than stretching a web effect to cover it. A broad trigger is not a broad claim. Being wrong about what this skill can do is worse than not being invoked.

## The routing table

| Medium | Stack | Primary reference | Borrow from | Defer to |
|---|---|---|---|---|
| **Web — React** | Next/Remix/Astro + React | [usage-map.md](usage-map.md) → the effect's own reference | [ui-registries.md](ui-registries.md) first, then [design-galleries.md](design-galleries.md) for section shape | — |
| **Web — vanilla / non-React** | Plain HTML/CSS/JS, Vue, Svelte, Rails | [usage-map.md](usage-map.md), then the imperative paths in [lenis.md](lenis.md), [stringtune.md](stringtune.md), [liquid-glass.md](liquid-glass.md) | [motion.md](motion.md) (the vanilla `animate()`/`scroll()` entry point) | — |
| **Video / motion graphics** | HTML → MP4 via HyperFrames | [hyperframes.md](hyperframes.md) | [motion.md](motion.md) for timing craft, [shader-gradient.md](shader-gradient.md) and [liquid-logo.md](liquid-logo.md) for the shader-transition path, [design-references.md](design-references.md) for `frame.md` | Upstream's `/hyperframes` router for all authoring detail |
| **Slide deck / presentation** | HyperFrames `/slideshow` | [hyperframes.md](hyperframes.md) | [design-galleries.md](design-galleries.md) for section anatomy, DESIGN.md catalog for tokens | Upstream `/slideshow` — it owns decks, including fragment reveals and presenter mode |
| **3D — authored in code** | react-three-fiber | [react-three-fiber.md](react-three-fiber.md) | [motion.md](motion.md) for scroll-linked camera work | — |
| **3D — authored by a designer** | Spline | [spline.md](spline.md) | [react-three-fiber.md](react-three-fiber.md) only if the scene must also react to app data | — |
| **Android** | Jetpack Compose, Material 3 | — | [motion.md](motion.md) for easing and duration vocabulary only | **`android-native-dev`** and **`mobile-android-design`** own this. `android-cli` for tooling |
| **iOS** | SwiftUI, Human Interface Guidelines | — | [motion.md](motion.md) for timing vocabulary only | **`impeccable`** for direction. No iOS skill is installed — say so rather than improvising |
| **Static brand asset** | SVG, PNG, a poster frame | [liquid-logo.md](liquid-logo.md) | [design-references.md](design-references.md) for tokens | — |
| **Presentation-adjacent but code-shaped** | A single-page site standing in for a deck | Treated as **Web**, above | HyperFrames `/slideshow` if it should step rather than scroll | — |

## The two rules this table encodes

1. **Medium first.** Identify what is being made before choosing anything. A "deck" and a "landing page" can carry near-identical content and need different tools; a "video" and a "hero section" can share a shader and share almost no contract.
2. **Then the effect's job, in one sentence.** The rest of this skill already requires it — *"the hero carries a scroll-driven 3D product that resolves into the feature section."* An effect with no sentence is decoration, and the answer is no. That rule does not weaken with the medium; it just changes vocabulary. For a video it becomes "the title resolves over 0.8s as the music lands on beat."

## How the mediums actually differ

The reason this table exists rather than a single universal contract: the obligations genuinely change.

| | Web | Video / deck |
|---|---|---|
| **Lifetime** | Infinite; a page can run for hours | Fixed; a known number of frames, rendered once |
| **Cost driver** | Per-frame GPU work, while a visitor watches | Total render time, before anyone watches |
| **Motion source** | Often the visitor — scroll, pointer, hover | Always authored; nobody scrolls a video |
| **Failure mode** | Jank, leaked WebGL contexts, scroll fights | Non-determinism, missing FFmpeg, unreadable text |
| **Accessibility** | Contrast, focus, keyboard, reduced motion | Captions, hold duration, audio description |
| **Reduced motion** | A real requirement — a static composed frame | Not applicable in the same way; the viewer controls playback |

Read that table literally. **A technology moving between mediums does not carry its contract with it.** ShaderGradient on a page must pause off-screen and honour `prefers-reduced-motion`; the same shader rendered into a composition must instead be seekable and render identically on every pass. [liquid-glass.md](liquid-glass.md) needs a live DOM to refract; a video has none, and the effect does not port at all.

## What this skill does not have

Stated plainly, so an agent does not invent it:

- **No deep references for Android, iOS, or decks.** Decks route to HyperFrames' `/slideshow`; Android routes to the two installed Android skills; iOS has no installed skill — use `impeccable` for direction and say the platform guidance is not covered here.
- **No native-mobile effect layer.** Every effect in this skill is a browser or GPU technology. Compose motion, SwiftUI animation, and platform haptics are different tools; this skill has no business advising on them beyond shared timing vocabulary.
- **No design direction.** Unchanged from the rest of the skill: [impeccable](../../impeccable/SKILL.md) owns that, with [design-references.md](design-references.md) covering the alternatives.
