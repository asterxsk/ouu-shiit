# Motion

[motion.dev](https://motion.dev) — the animation library formerly called Framer Motion. MIT, package name **`motion`**, currently 13.x, React peer `^18 || ^19` (so it pairs with either the React 18 or React 19 half of the react-three-fiber matrix).

It is the general-purpose motion layer, and its most useful property for this skill is a negative one: **Motion reads scroll, it does not own it.** That single fact is what makes it the safe default when a page needs scroll-driven animation *and* smooth scrolling, and it is why Motion appears in the scroll-ownership discussion below rather than in the conflict list.

## Install and imports

```bash
npm i motion
```

```jsx
import {
  motion, useScroll, useTransform, useSpring, useInView,
  useMotionValueEvent, MotionConfig, useReducedMotion, AnimatePresence,
} from "motion/react"
```

The package ships several entry points, and picking the right one is the difference between a small dependency and a large one:

| Import | What it is |
|---|---|
| `motion` | The full package: vanilla `animate()` and `scroll()`, for non-React sites |
| `motion/react` | Motion for React. The normal import |
| `motion/react-m` | The lightweight `m` component, for use with `LazyMotion` |
| `motion/mini` | Minimal core |
| `motion/three` | Three.js integration — relevant when the page already runs react-three-fiber |
| `motion/vgpu` | WebGPU |

## Scroll: a reader, not an owner

This is the part to get right before writing anything.

`useScroll()` returns four motion values: `scrollX` and `scrollY` in pixels, and `scrollXProgress` / `scrollYProgress` normalised 0 to 1.

Motion does not intercept wheel events, does not translate the page, and does not set scroll position. Where the browser supports it, scroll-linked animations run on the native **`ScrollTimeline`**, with a JavaScript fallback otherwise; scroll-*triggered* animations (`whileInView`) use a pooled `IntersectionObserver`.

The consequences:

- **Motion composes with Lenis.** Lenis drives the real scroll position, and Motion reads the real scroll position, so the usual pairing is native scroll plus Lenis with Motion reading from it. This is the combination to reach for when a page needs both smooth scroll and scroll-driven animation.
- **Motion conflicts with `ScrollControls` and StringTune's smooth mode** — but by displacement, not by argument. Those two *take over* the scroll, and a page can only have one owner. Do not stack them.
- Do not hand-wire an adapter as you would for GSAP ScrollTrigger. There is no `ScrollTrigger.update` equivalent to write, because nothing is being told about scroll — the browser is.

## The APIs worth knowing

Scroll progress driving a style:

```jsx
const { scrollYProgress } = useScroll()

<motion.div style={{ scaleX: scrollYProgress, originX: 0 }} />
```

Scoped to an element, with offset strings describing where the animation starts and ends relative to the viewport:

```jsx
useScroll({ target: ref, offset: ["start end", "end start"] })
```

`useTransform` maps a progress value onto anything — numbers, colours, transform strings, even filters:

```jsx
const filter = useTransform(scrollYProgress, [0, 1], ["blur(0px)", "blur(10px)"])
```

It also takes a function, which is how you derive from several values at once:

```jsx
const { scrollY } = useScroll()
const invertScroll = useTransform(() => scrollY.get() * -1)
```

Smoothing, when raw scroll progress is too twitchy to drive a transform:

```jsx
const scaleX = useSpring(scrollYProgress, { stiffness: 100, damping: 30, restDelta: 0.001 })
```

Entry and exit, without a scroll listener:

```jsx
<motion.div initial="hidden" whileInView="visible" viewport={{ once: true }} />
```

Reading a value imperatively, for side effects rather than styles:

```jsx
useMotionValueEvent(scrollY, "change", (latest) => { /* ... */ })
```

The two structural patterns worth stealing, both as documented:

- **Horizontal scroll on a vertical page.** Outer container `height: 300vh`, inner element `position: sticky`, and `useTransform(scrollYProgress, [0, 1], ["0%", "-75%"])` on the track.
- **Parallax.** Different rates per layer — the documented example pairs `foregroundY: [0, 2]` with `backgroundY: [0, 0.5]`, meaning two pixels of movement per pixel scrolled for the foreground and half that for the background. Pass `{ clamp: false }` so the value is allowed to run past the range.

## Reduced motion, honestly

Motion supports `prefers-reduced-motion` better than most libraries and still does not satisfy this skill's contract on its own.

`MotionConfig` takes a `reducedMotion` prop with three values — `"user"` to respect the device setting, `"always"` to force it, `"never"` to ignore it. **The official documentation gives the default as `"never"`.** Some mirrors of those docs say `"user"`. Do not depend on which is true in the version you install: set it explicitly at the app root.

```jsx
<MotionConfig reducedMotion="user">
  {children}
</MotionConfig>
```

By default this provider also propagates to library components you did not write. That is useful — Cult UI, Kokonut UI, and the other registries in [ui-registries.md](ui-registries.md) are built on Motion, so a single `MotionConfig` at the root covers their components too.

**What it actually disables is narrower than the name suggests.** With reduced motion active, Motion disables **transform and layout animations**; `opacity` and `backgroundColor` animations keep running. So the page becomes quieter, not static — which is not the "static, composed frame" this skill's contract asks for.

Scroll-linked work is not covered by the provider at all and has to be gated by hand:

```jsx
function Parallax() {
  const shouldReduceMotion = useReducedMotion()
  const { scrollY } = useScroll()
  const y = useTransform(scrollY, [0, 1], [0, -0.2], { clamp: false })

  return <motion.div style={{ y: shouldReduceMotion ? 0 : y }} />
}
```

`useReducedMotion()` is imported from `motion/react`, returns a boolean, and re-renders when the setting changes — so it is also the right tool for switching off autoplaying background video or a cursor-tracking flourish.

One development-time trap: when the OS has reduced motion on, Motion disables animations in development too, so the site you are looking at is not the site most users see. The documented workaround keys off `NODE_ENV` — do not ship that. Understand why the page is static and move on.

## Bundle

`motion/react` pulls the full feature set. `LazyMotion` with the `m` component (`motion/react-m`) loads animation features on demand and is the documented way to cut the size; `motion/mini` is the minimal core. Reach for feature-loading before either dropping the library or accepting its full weight.

## Contract

- **The page works without it.** Motion is progressive by construction — every `initial`/`whileInView` pair resolves to its final state without JavaScript if the markup starts visible rather than hidden. Start elements at `opacity: 1` in the server-rendered HTML and let Motion set the initial state, rather than rendering `opacity: 0` and depending on JS to reveal it. Otherwise a JS failure leaves an invisible page.
- **Cost is bounded.** Transform and opacity animations are compositor-friendly and cheap. Filter animations — `blur()`, and anything else `useTransform` can output — repaint, so keep them off full-viewport surfaces and off per-frame scroll transforms. `useSpring` and scroll-linked values evaluate every frame; that is the budget, spend it on a few elements.
- **Reduced motion.** As above: `reducedMotion="user"` on a root `MotionConfig`, plus explicit `useReducedMotion()` gating for everything scroll-linked.
- **Disposal.** Motion manages its own listeners and will not leak the way a hand-rolled `scroll` handler does. `AnimatePresence` is the exception worth watching — exit animations keep components mounted, so confirm they actually complete and unmount on route changes.
- **Legible and keyboard-reachable.** Motion does not touch focus or semantics. Interactive elements stay real buttons; a `whileTap` scale is not a focus indicator.
- **Scroll has exactly one owner.** Motion reads; it never owns. So it never conflicts with Lenis, and it is displaced by `ScrollControls` and StringTune's smooth mode rather than fighting them.

## Pitfalls

- **The `reducedMotion` default is not what most developers assume.** Set it explicitly.
- **Two animation libraries in one bundle.** The registries differ: Cult UI and Kokonut UI build on `motion`, while Skiper UI and Watermelon UI document `framer-motion`. Those are the old and new names for the same project but different packages, and installing both ships the engine twice. Check which the project already has and match it.
- **`filter` in a scroll transform.** It is in the documentation's own examples and it is the fastest way to a janky page, because it forces a repaint each frame over whatever it covers.
- **`whileInView` without `once: true`** re-fires every time the element crosses the viewport, which is rarely what the design meant.
- **Motion+ is paid** and out of scope. It adds premium examples, advanced APIs, an AI kit, and community access. Nothing in this reference needs it, and no licence key should be configured. The library itself is MIT.

## When not to use it

- A hover state, a fade, or a focus ring: CSS transition, no JavaScript.
- Smooth scroll as the only requirement: [Lenis](lenis.md) alone is smaller and does that one job.
- A project already committed to GSAP with a team that knows it: adding Motion means two animation systems and two mental models for the same work. Pick one.
- A scroll-driven 3D scene that needs to drive `useFrame` from scroll: read the scroll value and pass it in, rather than reaching for `ScrollControls` — see [react-three-fiber.md](react-three-fiber.md).
