# Lenis

Smooth scrolling. Lenis intercepts wheel, touch, and keyboard input and interpolates the scroll position toward it, so the page eases instead of snapping. It keeps native scrolling underneath — `position: sticky`, anchors, find-in-page, and screen readers keep working — which is why it is the safe choice over the older scroll-hijacking libraries.

Repo: https://github.com/darkroomengineering/lenis · Docs: https://lenis.darkroom.engineering · MIT

Formerly `@studio-freight/lenis`; the package is now `lenis`.

## Install

```bash
npm i lenis
```

```js
import Lenis from 'lenis'
import 'lenis/dist/lenis.css'
```

Script tag: `https://unpkg.com/lenis@1.3.26/dist/lenis.min.js`

## Setup

```js
const lenis = new Lenis({ autoRaf: true })

lenis.on('scroll', (e) => { console.log(e) })
```

Or drive it yourself:

```js
const lenis = new Lenis()

function raf(time) {
  lenis.raf(time)
  requestAnimationFrame(raf)
}
requestAnimationFrame(raf)
```

The no-code one-liner, for a page you do not want to build:

```html
<script>new Lenis({ autoRaf: true, autoToggle: true, anchors: true, allowNestedScroll: true, naiveDimensions: true, stopInertiaOnNavigate: true })</script>
```

## React

```jsx
import { ReactLenis, useLenis } from 'lenis/react'

export default function Layout({ children }) {
  useLenis((lenis) => {
    // runs on every scroll event
  })

  return (
    <ReactLenis root options={{ lerp: 0.1, duration: 1.2, smoothWheel: true }}>
      {children}
    </ReactLenis>
  )
}
```

`root` means Lenis attaches to the window and wraps the whole document rather than an inner container. Use `root` for a page-level smooth scroll; omit it only when a nested container genuinely needs its own smoothing. `useLenis(callback)` subscribes to scroll events and gives you the instance.

Related entry points in the same package: `lenis/vue`, `lenis/framer`, `lenis/snap`.

## Options

| Option | Default | Note |
|---|---|---|
| `duration` | `1.2` | seconds; used when `lerp` is not set |
| `easing` | `t => Math.min(1, 1.001 - Math.pow(2, -10 * t))` | |
| `lerp` | `0.1` | 0–1 interpolation; takes precedence over `duration` |
| `smoothWheel` | `true` | |
| `wheelMultiplier` | `1` | |
| `touchMultiplier` | `1` | |
| `syncTouch` | `false` | see Pitfalls — usually leave off |
| `syncTouchLerp` | `0.075` | |
| `touchInertiaExponent` | `1.7` | |
| `infinite` | `false` | |
| `orientation` | `'vertical'` | or `horizontal` |
| `gestureOrientation` | `'vertical'` | `vertical` \| `horizontal` \| `both` |
| `autoRaf` | `false` | |
| `autoResize` | `true` | |
| `autoToggle` | `false` | |
| `anchors` | `false` | boolean or ScrollToOptions; enables anchor-link handling during scroll |
| `overscroll` | `true` | |
| `prevent` | `undefined` | function `(node) => boolean` |
| `virtualScroll` | `undefined` | |
| `wrapper` | `window` | |
| `content` | `document.documentElement` | |
| `eventsTarget` | `wrapper` | |
| `naiveDimensions` | `false` | |
| `stopInertiaOnNavigate` | `false` | |
| `allowNestedScroll` | `false` | |
| `respectReducedMotion` | `true` | see Contract |

## Methods

- `scrollTo(target, options)` — `target` is a number (px), a CSS selector string, or one of `top` / `left` / `start` / `bottom` / `right` / `end`, or an element. Options: `offset`, `lerp`, `duration`, `easing`, `immediate`, `lock`, `force`, `onComplete`, `userData`.
- `stop()` / `start()` — pause and resume. Use for modals, 3D interactions, and anything that needs the page to hold still.
- `destroy()` — remove the instance and its listeners.
- `raf(time)` — call each frame, in milliseconds.
- `on(id, fn)` — events: `scroll` (instance) and `virtual-scroll` (`{ deltaX, deltaY, event }`).
- `resize()` — only needed when `autoResize: false`.

Useful state: `isStopped`, `isSmooth`, `progress`, `velocity`, `direction`, `limit`, `prefersReducedMotion`.

## Integrations

**GSAP ScrollTrigger** — the documented pattern:

```js
const lenis = new Lenis()
lenis.on('scroll', ScrollTrigger.update)
gsap.ticker.add((time) => { lenis.raf(time * 1000) })
gsap.ticker.lagSmoothing(0)
```

Note `time * 1000`: Lenis wants milliseconds, the GSAP ticker gives seconds. Do not use `scrollerProxy` — it is not needed and it fights the native scroll Lenis keeps.

**Framer Motion / Motion** — `useScroll` reads window scroll, which Lenis still drives, so it works without extra wiring.

**react-three-fiber `ScrollControls`** — these two both want to own scroll. Pick one. Either use ScrollControls and no Lenis on that page, or use native scroll plus Lenis and drive your `useFrame` animations from `lenis.on('scroll', ...)` / the `useLenis` hook. Do not run both.

**Sticky and fixed elements** — Lenis scrolls natively, so `position: sticky` works; enable `anchors: true` if you want anchor links to be handled while scrolling is in flight. Known issue: `position: fixed` can lag on macOS Safari on pre-M1 hardware.

**Nested scroll containers** (modals, drawers, code blocks, horizontal galleries) — opt them out:

```html
<div data-lenis-prevent>scrollable content</div>
```

Variants: `data-lenis-prevent-wheel`, `data-lenis-prevent-touch`, `data-lenis-prevent-vertical`, `data-lenis-prevent-horizontal`. Or `prevent: (node) => node.id === 'modal'`.

**Scroll snap** — Lenis has no CSS scroll-snap support. Use the `lenis/snap` plugin.

## Contract

- **Fallback:** the page scrolls natively without Lenis, because Lenis *is* the native scroll position. That is the built-in fallback and it is why this library is low-risk compared to the alternatives.
- **Motion:** `respectReducedMotion` defaults to `true`, and the behavior is right — smoothing is disabled, `lerp` is forced to `1` so the scroll tracks the input device 1:1, and programmatic scrolls jump instantly. Lenis keeps running so WebGL and DOM stay in sync. The preference is read live, with no reload, and exposed as `lenis.prefersReducedMotion`. Leave this on.
- **Cleanup:** always `lenis.destroy()` on unmount. Under React StrictMode, effects run twice in development — a missing destroy leaves two RAF loops fighting, which reads as stutter.
- **Accessibility:** because Lenis does not move the scroll position away from native, keyboard paging, find-in-page, and screen-reader scrolling continue to work. Anchor links need `anchors: true` while a scroll is in flight.
- **Performance:** this is a transform on scroll position, not a paint per frame. The cost is the RAF loop and whatever your scroll listeners do — keep those cheap, and read scroll values in `useFrame` or a passive listener rather than in React state.

## Pitfalls

- **Smooth scroll that feels laggy.** `lerp` below about 0.08 with a heavy `duration` makes the page feel unresponsive, which is worse than no smoothing. Start at the defaults; tune down only with a reason.
- **Double RAF loops.** `autoRaf: true` plus your own `requestAnimationFrame(raf)` doubles the work. One or the other.
- **`syncTouch: true`** can feel laggy on mobile and overrides native momentum, which users notice immediately. Off by default; leave it off unless there is a specific reason.
- **`scroll-behavior: smooth` in CSS** conflicts. Drop it when Lenis is active.
- **Iframes** do not forward wheel events, so smooth scroll appears broken over an embedded iframe.
- **Nested containers without `data-lenis-prevent`** swallow the wheel and never scroll, because Lenis takes the event first.
- **Safari frame caps.** Lenis is capped at 60fps on Safari, and 30fps in low-power mode. Fine, but it makes comparisons against Chrome misleading.
- **Breaking `scrollIntoView`.** Code that calls native `scrollIntoView` fights the smooth position; use `lenis.scrollTo` instead.
- **Don't add it reflexively.** See the placement table in `usage-map.md` — if the page is a dashboard, a docs site, or anything a user scans to find one thing, smoothing costs more than it gives.

## When not to use it

Operate-mode dashboards, documentation, long tables, search results, and mobile-first sites where native momentum is already good. Also skip it on a page whose only scroll interaction is "read to the bottom" — there is nothing to smooth.
