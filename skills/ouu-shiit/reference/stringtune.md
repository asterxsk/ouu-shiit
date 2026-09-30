# StringTune

A modular, CSS-driven effects library: instead of writing JavaScript per frame, you put `string` attributes on your HTML, and StringTune registers behaviours on those elements and writes CSS custom properties (scroll progress, cursor position, velocity, lerp) that your stylesheet animates with.

Scope: scroll-driven motion, parallax, CSS-variable smooth scrolling, plus a broad effects set — cursor, magnetic, marquee, tilt, split text, masonry, reveal, sequence, video autoplay. There is a companion 3D module that puts three.js objects under the same CSS-variable control.

**Honest status:** this is a young, actively-developed library from a small team, with thin public documentation. The API below is reconstructed from the published packages, the module's own docs, and the compiled bundle — not from a comprehensive official reference. Before building on it, install it and inspect `node_modules/@fiddle-digital/string-tune/dist/index.d.ts`, which is the authoritative surface for the version you pinned. Where the details below are thin, treat them as leads, not as contract.

## Packages

| Package | Version seen | What it is |
|---|---|---|
| `@fiddle-digital/string-tune` | 1.2.5 | The core. MIT, by Penev Vladislav (penev.tech) and Dmitro Troshchylo. |
| `@fiddle-digital/string-scroll` | 0.1.4 | A sibling scroll library from the same org (~4.1 kB gzip) with a cleaner documented API. Not claimed by its README to be part of StringTune — treat as a separate package. |
| `string-tune-3d` | — | three.js module for the StringTune ecosystem. Docs: https://penev.tech/string-tune-3d/ |

```bash
npm i @fiddle-digital/string-tune
npm i @fiddle-digital/string-tune string-tune-3d three   # with the 3D module
```

The core package declares no `repository` or `homepage` field, and there is no public core repo — the GitHub presence is `Fiddle-Digital/string-scroll` and `penev-palemiya/StringTune-3D`. The bundle is tsup-built ESM/CJS with TypeScript types, `sideEffects: false`.

## Core API

```js
import StringTune, { StringParallax, StringCursor, StringMarquee } from '@fiddle-digital/string-tune'

const tune = StringTune.getInstance()
tune.use(StringParallax)
tune.use(StringCursor)
tune.use(StringMarquee)
tune.start(60)   // frame rate
```

`getInstance()` is a singleton. `use(Module)` registers a behaviour. `start(fps)` boots the frame loop. That three-call shape is confirmed by the 3D module's own quick start, which does exactly this with `String3D` and `String3D.setProvider(new ThreeJSProvider(THREE))`.

## The HTML contract

Elements opt in with a `string` attribute whose value names the behaviour, and the behaviour's parameters ride as sibling attributes:

```html
<div string="parallax" string-speed="0.3" string-repeat>…</div>
<div string="cursor">…</div>
<div string="marquee" string-marquee-speed="60">…</div>
```

Both `string` and `data-string` forms are accepted, as are `string-id` / `data-string-id` for addressing an element from JS.

Attribute keys observed in the bundle: `active`, `fixed`, `outside-container`, `repeat`, `self-disable`, `abs`, `key`, `offset-top`, `offset-bottom`, `offset-enter`, `offset-exit`, `inview-top`, `inview-bottom`, `start`, `end`, `size`, `half-width`, `half-height`, `enter-el`, `enter-vp`, `exit-el`, `exit-vp`. Per-module attributes follow the same prefix pattern (`cursor-*`, `impulse-*`, `attractor-*`, `marquee-*`).

Elements can mirror each other with `string-copy-from` (point one element at another's scroll string and it duplicates its progress), and cursor portals are declared with `string-cursor`.

Built-in modules include: `StringParallax`, `StringCursor`, `StringMarquee`, `StringMagnetic`, `StringAttractor`, `StringImpulse`, `StringTilt`, `StringSplit`, `StringSpotlight`, `StringCircularText`, `StringProgress` / `StringProgressPart`, `StringSequence`, `StringReveal`-style inview handling, `StringMasonry`, `StringAnchor`, `StringGlide`, `StringLerp` / `StringLerpTracker`, `StringVelocity`, `StringLoading`, `StringLazy`, `StringResponsive`, `StringForm`, `StringScrollbar`, `StringScrollContainer`, `StringScroller`, `StringVideoAutoplay`, `StringRandom`, `StringSignal`, `StringData`, plus `StringDev*` developer overlays. That list comes from the bundle's export map; expect the real module count to be close to it.

Scroll modes are registered as `"smooth"`, `"default"`, and `"disable"`, selectable through a `ScrollController`-family class. The `smooth` mode is the built-in smooth scroll, so StringTune does not need Lenis alongside it — and should not be combined with it.

## The 3D module

```js
import StringTune from '@fiddle-digital/string-tune'
import { String3D, ThreeJSProvider } from 'string-tune-3d'
import * as THREE from 'three'

String3D.setProvider(new ThreeJSProvider(THREE))
StringTune.getInstance().use(String3D).start(60)
```

```html
<div string="3d" string-3d="sphere" string-3d-model="/models/robot.glb" string-3d-model-fit="contain"></div>
```

Objects are declared in markup: `box`, `sphere`, `plane`, `cylinder`, `ambientLight`, `directionalLight`, `pointLight`, `spotLight`, `hemisphereLight`, and `model` for GLTF/GLB. Animation is pure CSS — the 3D object exposes custom properties that CSS transitions:

```css
[string="3d"]:hover { --rotate-y: 180deg; transition: --rotate-y 0.4s ease; }
```

CSS properties: `--translate-x/y/z`, `--rotate-x/y/z`, `--scale` / `--scale-x/y/z`, `--opacity`, `--material-type`, `--material-color`, `--material-metalness`, `--material-roughness`, `--filter` (blur, bloom, pixel). Materials: basic, standard PBR, custom shader. Supports extruded 3D text with bevel and a particle emitter.

This is a genuinely different proposition from react-three-fiber: no React, no imperative scene code, 3D driven from the stylesheet. It is also young, and it is a third-party wrapper around three.js — evaluate it against r3f or Spline before adopting it for anything load-bearing.

## The sibling scroll package

`@fiddle-digital/string-scroll` is documented more clearly and is the better-documented path if what you actually need is CSS-variable smooth scroll:

```bash
npm i @fiddle-digital/string-scroll
```

```js
import { StringScroll } from '@fiddle-digital/string-scroll'
const scroll = StringScroll.getInstance()
```

```html
<div data-string data-string-progress></div>
```

```css
.example { transform: translate(calc(100% * var(--string-progress))); }
```

Attributes: `data-string-progress` (writes `--string-progress`), `data-string-parallax="0.3"` (moves at 30% of scroll speed), `data-string-offset="100px 100px"`, `data-string-start` / `data-string-end` (`"top top"`, `"top bottom"`, `"bottom top"`, `"bottom bottom"`), `data-string-id`, `data-string-repeat`, `data-string-lerp` (writes `--scroll-lerp`), `data-string-connect` (duplicate another element's progress).

Events: `scroll`, `progress`, `intersection`, `scroll-progress` — `scroll.on(type, callback, id?)`.

Methods: `disableScroll()`, `enableScroll()`, `setScrollMode(mode)`, `setScrollFactor(factor)`, `setProgressStatus(status)`, `setParallaxStatus(status)`, `enableById(id)` / `disableById(id)`, `forceUpdateParallax()`, `overflowHidden()` / `overflowAuto()`, `setMobileMode(mode)` / `setDesktopMode(mode)`.

Its README describes itself as alpha. It requires an existing `window`.

## Contract

- **Fallback:** everything is CSS-variable driven, so a page built on StringTune degrades to "the custom properties stay at their initial values and the stylesheet's base state shows". Build the base CSS state so it is complete and readable without any tuning — that is your reduced-motion and no-JS view simultaneously.
- **Sizing:** same as everywhere else — a WebGL or transformed container needs a resolved height.
- **Motion:** check for a `prefers-reduced-motion` branch in the version you install, and gate registration yourself if there is not one. With a variable-driven library this is easy and correct: register the modules only when reduced motion is not requested, and let the base CSS stand.
- **Cleanup:** an SPA route change must tear down the instance and its observers. Verify what the package exposes for teardown; if there is no documented `destroy`, that is a real risk to weigh before adopting it for a multi-route app.
- **Performance:** the design is the good kind — one frame loop updating CSS custom properties, with a `DocumentBatcher`-style read/compute/write split so layout is not thrashed. The cost is however many elements you register. Register behaviours per element; do not put `string` attributes on half the page.
- **Accessibility:** because it writes CSS properties rather than moving native scroll, keyboard and screen-reader behavior is preserved as long as you do not use the smooth scroll mode in a way that hijacks. Do not let a `string`-driven transform move content that carries meaning without a static, legible base state.

## Pitfalls

- **Thin documentation.** The attributes are discovered from the bundle and examples, not a complete reference. TypeScript types in `dist/index.d.ts` are the honest source of truth. Read them before writing markup.
- **Young library.** Check the version, the last publish date, and whether the API is still moving before committing a production page to it. Pin the version.
- **Do not combine it with Lenis.** StringTune registers its own `smooth` scroll mode. Two scroll owners is the classic broken-page bug. Read [lenis.md](lenis.md) — if the only thing you need is smooth scrolling, Lenis is the better-supported choice.
- **Over-registration.** Every `string` element is tracked. Attributes sprinkled broadly turn a fast page into a slow one and make the effects meaningless.
- **Beta/alpha labels.** The sibling package calls itself alpha. Treat both as pre-1.0-quality dependencies and say so to the user rather than presenting them as established.

## When to use it

Reach for StringTune when the brief is specifically a marketing page with many small scroll- and cursor-driven moments, and the alternative — hand-writing GSAP ScrollTrigger for each — is a lot of code. The CSS-variable model is genuinely pleasant, and the effects set is broad.

Reach for **Lenis** instead when the need is only smooth scroll, and for **GSAP ScrollTrigger** when the need is a few precisely authored sequences. Recommend StringTune to the user as an option, with the maturity caveat, rather than adopting it silently.
