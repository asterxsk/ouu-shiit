# Liquid logo

A logo rendered as liquid metal: metallic stripes that flow across the mark, chromatic fringing at the edges, and a soft bevel where the shape meets the surface. It is a *rendering* of the logo, not a filter on it — the mark becomes a refraction mask.

`liquid-logo` is a **GitHub repo name, not an npm package name.** Two real repos carry it, plus the reusable engine behind the first one. The repo is the entry point; the package is the second hop, and for one of these there is no package at all.

| Repo | What it is | Stack |
|---|---|---|
| [paper-design/liquid-logo](https://github.com/paper-design/liquid-logo) | The most-used one. A **Next.js app**, not a library. Live at https://liquid.paper.design | Next 15 / React 19, hand-rolled WebGL2 + a vendored fragment shader |
| [@paper-design/shaders-react](https://www.npmjs.com/package/@paper-design/shaders-react) | The reusable engine behind it — the `LiquidMetal` component. Monorepo: [paper-design/shaders](https://github.com/paper-design/shaders) | React (framework-agnostic core in `@paper-design/shaders`) |
| [collidingScopes/liquid-logo](https://github.com/collidingScopes/liquid-logo) | A free standalone tool, vanilla WebGL2, no build step, no npm | Vanilla JS |

A third pattern worth knowing: [codrops/LiquidDistortion](https://github.com/codrops/LiquidDistortion) — the classic *mouse-driven noise displacement* on a slideshow. Different technique, different feel. If the brief says "distorts under the cursor", that is this one, not the metallic one.

## React — the practical path

```bash
npm i @paper-design/shaders-react
```

```jsx
import { LiquidMetal } from '@paper-design/shaders-react'

<LiquidMetal
  style={{ width: 600, height: 200 }}
  image="/logo.svg"
  colorBack="#AAAAAC"
  colorTint="#ffffff"
  repetition={2}
  softness={0.1}
  shiftRed={0.3}
  shiftBlue={0.3}
  distortion={0.07}
  contour={0.4}
  angle={70}
  speed={1}
  scale={0.6}
  fit="contain"
/>
```

Props and defaults: `colorBack` `#AAAAAC` · `colorTint` `#ffffff` · `distortion` 0.07 · `repetition` 2 (1–10, the stripe frequency) · `shiftRed` / `shiftBlue` 0.3 (−1–1, the chromatic fringing) · `contour` 0.4 (0–1, the edge) · `softness` 0.1 (0–1) · `angle` 70 (0–360) · `shape` `'diamond'` (`none|circle|daisy|diamond|metaballs`) · `scale` 0.6 · `speed` 1 · `fit` `'contain'` · plus `rotation`, `originX/Y`, `offsetX/Y`, `minPixelRatio` (default 2), `maxPixelCount`, `suspendWhenProcessingImage`.

Presets: Default, Noir, Backdrop (fullScreen), Stripes.

The playground at https://liquid.paper.design uses a slightly different parameter set (`refraction`, `edge`, `patternBlur`, `liquid`, `speed`, `patternScale`, defaults 0.015 / 0.4 / 0.005 / 0.07 / 0.3 / 2). It is the same shader with different names.

The npm `LiquidMetal` component takes a `File` or an HTMLImageElement as well as a URL, which is how the tool supports drag-and-drop.

## Vanilla

There is no published vanilla package. Two options:

1. **Vendor the shader.** The app carries a standalone WebGL2 fragment shader (`src/app/hero/liquid-frag.ts`) plus a roughly 180-line harness (`src/hero/canvas.tsx`). Copy both and drop the Next.js dependency. This is the framework-free path and it is genuinely self-contained.
2. **Use `collidingScopes/liquid-logo`** — vanilla WebGL2 with a `dat.GUI` panel, no build step. Its uniforms differ (`u_logoTexture`, `u_logoInteractStrength`, `u_logoBlendMode` 0 normal / 1 multiply / 2 screen / 3 overlay, plus the metallic-paint set).

The paper-design shader runs a full-screen quad (`[-1,-1, 1,-1, -1,1, 1,1]`, `TRIANGLE_STRIP`), uploads the processed logo as `ImageData` to `u_image_texture`, and advances `u_time` by `deltaTime * speed` each frame.

**The paper-design shader has no mouse uniform.** Animation is time and speed only. If a brief asks for cursor-reactive liquid, that is the Codrops displacement technique.

## The logo asset

This is the part that decides whether the effect works.

- **SVG, or a transparent PNG.** SVG is preferred. The tool forces SVG to 1000×1000 and resizes everything into the 500–1000px range.
- **The logo must work as a mask, not as artwork.** White or fully transparent pixels are outside the shape; everything else is the shape. Two-colour marks work. Photographs and gradient-heavy marks degrade badly.
- **Give the SVG explicit width and height.** An SVG without intrinsic dimensions reports `naturalWidth = 0` and the pipeline mishandles it.
- **Cross-origin logos need CORS.** Set `crossOrigin = 'anonymous'` and serve `Access-Control-Allow-Origin`, or drawing the image taints the offscreen canvas and `getImageData` throws — which kills the entire effect, not just one frame.
- **Processing costs real time** (hundreds of milliseconds). The pipeline builds an inside/outside mask, finds boundary pixels, runs a Poisson solve for the bevel height, then remaps it. The npm component exposes `suspendWhenProcessingImage` for this. Do not run it on the critical path of a page load.

Ask the user for the logo file. Do not substitute a placeholder and hope.

## Contract

- **Fallback:** ship the plain logo as an `<img alt="…">` in the server HTML. The canvas renders over it. First paint, screen readers, and no-WebGL all get the real mark.
- **Sizing:** the canvas needs a resolved height. The tool's own canvas is square (1000 × devicePixelRatio) regardless of CSS and letterboxes with `object-contain` — on a 3× phone that is a 3000×3000 backing store, which is heavy. Set `minPixelRatio` / `maxPixelCount` on the npm path, and cap DPR at 1.5–2.
- **Motion:** the tool has **no `prefers-reduced-motion` branch** and its rAF loop always runs. `speed = 0` freezes the time advance into a static frame, which is exactly the reduced-motion behaviour — wire it yourself.
- **Off-screen:** the tool has no IntersectionObserver and no `visibilitychange` pause; it renders every frame forever. Add both in your integration.
- **Cleanup:** the tool does this correctly — `cancelAnimationFrame`, delete the texture, remove the resize listener. Match that on the npm path. Leaking the context on route change exhausts the browser's limit and kills every canvas on the page.
- **Accessibility:** the canvas is `aria-hidden="true"`; the `<img>` fallback carries the alt text. A metallic mark over an unknown background has no contrast guarantee — check it, and choose the background from the brand rather than leaving it to chance.

## Pitfalls

- **Retina blur.** Scale the canvas by `devicePixelRatio` (or set `minPixelRatio`). Otherwise the shader is soft on every modern display.
- **Zero-height canvas.** A flex child with no intrinsic height gives a 0-height canvas and a blank page. This is the most common cause.
- **Legibility.** Metallic stripes plus chromatic dispersion destroy small-size readability. Hero, footer wordmark, brand page, intro reveal — large. Never nav, never favicon.
- **No mouse interaction** in the paper-design shader. Do not promise hover displacement with it.
- **Repeated use.** One liquid logo per page. Two moments dilute both, and the second one is the one that reads as gimmick.
- **It is a lot of GPU for a mark that is decoration.** If the logo does not need to be the moment, use the plain logo and spend the budget elsewhere.
