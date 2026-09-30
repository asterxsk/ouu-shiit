# Liquid glass

An Apple-Liquid-Glass-style refractive panel: the content behind it is bent, tinted, and given a highlight at the edge, as if you were looking through a thick piece of glass.

`liquidglass.js` is a **GitHub repo name, not an npm package name.** Several unrelated repos use that name and they are not interchangeable — pick by stack and by browser support, then install whatever package the repo publishes (some publish none and are meant to be copied in).

| Repo | npm | Stack | How it renders | Reach for it when |
|---|---|---|---|---|
| [rdev/liquid-glass-react](https://github.com/rdev/liquid-glass-react) | `liquid-glass-react` | React | SVG `feDisplacementMap` via `backdrop-filter: url()` | React site, most-used, **Chromium only** for refraction |
| [ybouane/liquidglass](https://github.com/ybouane/liquidglass) | `@ybouane/liquidglass` | Vanilla TS | WebGL1 shader over a rasterized snapshot of the DOM | Non-React, or refraction that must work everywhere |
| [naughtyduk/liquidGL](https://github.com/naughtyduk/liquidGL) | `liquid-gl` | Vanilla | WebGPU → WebGL2 → WebGL → CSS fallback chain | Live video or live text behind the glass |
| [shuding/liquid-glass](https://github.com/shuding/liquid-glass) | none — copy-paste | Vanilla IIFE | Pure SVG filter, no `backdrop-filter`, no WebGL | A one-off snippet, no build step |

The literal name appears on a handful of low-traction repos too — `carry-yu-0239/liquid-glass` (a zero-dependency single file, Chinese-language, WebGL refraction) and `KaranocaVe/LiquidGlass.js` — ~1 star each and unaudited. Treat a hit on the exact string as unvetted until you have read it. [archisvaze/liquid-glass](https://github.com/archisvaze/liquid-glass) is a demo page, not a library. [iyinchao/liquid-glass-studio](https://github.com/iyinchao/liquid-glass-studio) is an editor, not a library.

**Default choice:** React → `liquid-glass-react`. Anything else → `@ybouane/liquidglass`. Both are MIT and need no displacement-map asset; the map is generated.

## React

```bash
npm install liquid-glass-react
```

```jsx
import LiquidGlass from 'liquid-glass-react'

<LiquidGlass
  displacementScale={64}
  blurAmount={0.1}
  saturation={130}
  aberrationIntensity={2}
  elasticity={0.35}
  cornerRadius={100}
  mode="standard"
  overLight={false}
  padding="8px 16px"
  style={{ position: 'fixed', top: 16, left: '50%', transform: 'translateX(-50%)' }}
>
  <nav>…</nav>
</LiquidGlass>
```

Props with defaults: `displacementScale` 70 · `blurAmount` 0.0625 · `saturation` 140 · `aberrationIntensity` 2 · `elasticity` 0.15 · `cornerRadius` 999 · `className` "" · `overLight` false · `mode` `"standard" | "polar" | "prominent" | "shader"` · `padding` · `style` · `onClick` · `mouseContainer` / `globalMousePos` / `mouseOffset` for controlling the refraction from a mouse position other than the element's own.

`overLight` is the one people miss: on a light background, the glass needs to invert its tint or it disappears.

The size is driven by the wrapped children. The component measures them and generates a displacement map on a hidden canvas — no asset required.

## Vanilla

```bash
npm install @ybouane/liquidglass
```

```js
import LiquidGlass from '@ybouane/liquidglass'

const root = document.querySelector('#root')
const glassElement = document.querySelector('.glass')

glassElement.dataset.config = JSON.stringify({
  refraction: 0.69,
  blurAmount: 0.25,
  cornerRadius: 65,
  floating: true,
})

const instance = await LiquidGlass.init({
  root,
  glassElements: [glassElement],
})
```

Per-element `data-config` options with defaults: `blurAmount` 0 · `refraction` 0.69 · `chromAberration` 0.05 · `edgeHighlight` 0.05 · `specular` 0 · `fresnel` 1 · `distortion` 0 · `cornerRadius` 65 · `zRadius` 40 · `opacity` 1 · `saturation` 0 · `tintStrength` 0 · `brightness` 0 · `shadowOpacity` 0.3 · `shadowSpread` 10 · `shadowOffsetY` 1 · `floating` false · `button` false · `bevelMode` 0.

The instance exposes `.fps`, `.destroy()`, and `.markChanged(el?)` — call `markChanged` when the DOM inside or behind the glass changes, or the snapshot goes stale. A `<video>` behind the glass is handled automatically; a CSS animation behind it is not.

## How each one works, because it decides the browser story

- **`liquid-glass-react`** generates a displacement map on a hidden canvas, exports it as a data URL into an SVG `feImage`, feeds it to `feDisplacementMap`, and applies that whole filter through `backdrop-filter: url(#filter)`.
- **`@ybouane/liquidglass`** rasterizes the DOM subtree to a canvas (via `html-to-image`), then runs a WebGL1 fragment shader over it doing refraction, chromatic aberration, Fresnel, specular rim, and shadow.
- **`liquidGL`** does the same idea with an offscreen snapshot, but selects the best available engine: WebGPU, then WebGL2, then WebGL, then plain CSS `backdrop-filter`.
- **`shuding/liquid-glass`** is pure SVG filters — no `backdrop-filter`, no WebGL. It pastes into a console and exposes `window.liquidGlass`.

`filter: url()` inside `backdrop-filter` is effectively **Chromium-only**. On Safari and Firefox the SVG-based versions silently drop the refraction and render a flat blur. The `liquid-glass-react` README says so directly: Safari and Firefox only partially support the effect and the displacement will not be visible.

That is the whole decision: if the refraction must appear on every browser, use a WebGL implementation. If the site is Chromium-targeted, or blur-without-refraction is an acceptable degradation, the SVG path is fine and much lighter.

## Contract

- **Fallback:** the glass must degrade to something that still reads — a solid or semi-transparent surface with a real border and shadow. Layer it with `@supports (backdrop-filter: url(#f))` or let the library's own chain handle it, and verify the fallback by disabling the effect, not by trusting it.
- **Sizing:** glass needs a sized element. A glass panel with auto height around absolutely-positioned children collapses.
- **Motion:** glass is static. If the panel animates in, animate the wrapper, not the filter — animating a filter that regenerates a displacement map every frame is expensive.
- **Cost:** every glass element forces a backdrop repaint on scroll and on animation. Keep it to one or two per page. The WebGL implementations rasterize the DOM, which is more expensive still — keep the glassed wrappers shallow, and call `markChanged` rather than re-initializing.
- **Cleanup:** call `destroy()` (or unmount) on route change. WebGL-based implementations hold a context, and there is a hard limit of roughly 8–16.
- **DPR:** cap at 1.5–2. The WebGL paths render a full scene; full-retina glass on mobile is wasteful.
- **Accessibility:** text over live refraction has no contrast guarantee. Put a scrim (a solid or gradient layer) between the glass and the text, and check the contrast against the *busiest* thing that can pass behind it, not the calmest.

## Pitfalls

- **Stacking contexts silently break it.** `filter`, `transform`, `opacity < 1`, and `will-change` each create a stacking context, and an ancestor filter can isolate the backdrop so the glass samples nothing. When the glass renders as plain blur or plain nothing, look up the ancestor chain first — not at the props.
- **Glass on glass** compounds the cost and usually looks wrong. One layer.
- **Safari and Firefox** drop refraction on the SVG implementations. Test there; do not assume.
- **`@ybouane/liquidglass` specifics:** the glass element must be a direct child of the configured root (nested ones are rejected); the root itself is never captured; a cross-origin image inside the root without `crossorigin="anonymous"` taints the canvas and kills capture for the entire root; webfonts must be loaded before `init()`; `destroy()` does not restore `position: static` on elements it moved.
- **`liquidGL` specifics:** unstable on Safari when the glass covers more than about half the viewport; fixed-position elements are ignored; per-instance `zIndex` values must be consistent across lenses.
- **Text legibility** is the real failure mode. A refractive panel over photographic or high-contrast content makes small text unreadable. Keep body copy off the glass; glass carries chrome, labels, and controls.
- **`prefers-reduced-motion`** does not apply — glass isn't motion. But glass that tracks the cursor via `mouseContainer` should stop tracking under reduced motion, and should be disabled entirely on touch devices where there is no cursor.
- **SSR:** all of these touch `window` and canvas at mount. Client-only load them; the server output is the solid fallback.
