# ShaderGradient

An animated WebGL gradient. One canvas, three colours, a light, and a camera — enough to turn a flat hero into a moving surface without authoring a 3D scene.

Repo: https://github.com/ruucm/shadergradient · Playground: https://www.shadergradient.co

## Install

```bash
npm i @shadergradient/react @react-three/fiber three three-stdlib camera-controls
npm i -D @types/three
```

`@react-three/drei` is **not** required — do not add it for this.

Package is `@shadergradient/react` (v2.x). `shadergradient-old` is legacy v1 — avoid. `@shadergradient/ui` is not published to npm. For Vue, `@shadergradient/vue` (Vue 3.5 + TresJS + three ≥0.186). **There is no vanilla build and no official iframe embed** — on a plain-HTML site, either port the shader or do not use this.

Version matrix:

| Environment | React | @react-three/fiber | three |
|---|---|---|---|
| Next 15 App Router | 19 | **9** | ≥0.158 |
| Next 14 / Vite | 18 or 19 | 8 or 9 (match React) | ≥0.158 |

React 19 in the App Router requires R3F v9. v8 is incompatible with the canary React the App Router vendors.

## Minimal

```jsx
'use client'
import { ShaderGradientCanvas, ShaderGradient } from '@shadergradient/react'

export default function Hero() {
  return (
    <div style={{ position: 'relative', height: '100svh' }}>
      <ShaderGradientCanvas
        style={{ position: 'absolute', inset: 0, pointerEvents: 'none' }}
        pixelDensity={1.5}
        fov={45}
      >
        <ShaderGradient cDistance={32} cPolarAngle={125} />
      </ShaderGradientCanvas>
      <div style={{ position: 'relative', zIndex: 1 }}>{/* content */}</div>
    </div>
  )
}
```

`pointerEvents: 'none'` matters on React. The Vue package defaults it to `'none'`; the React one leaves it undefined, so the canvas swallows touch scroll and drag unless you say otherwise. Always set it on a decorative background.

## Reproducing a designed gradient

Design it in the playground, then copy the **customize URL** and pass it whole:

```jsx
<ShaderGradientCanvas>
  <ShaderGradient
    control="query"
    urlString="https://www.shadergradient.co/customize?animate=on&cDistance=3.6&cPolarAngle=90&color1=%2352ff89&color2=%23dbba95&color3=%23d0bce1&lightType=3d&shader=defaults&type=plane&uFrequency=5.5&uSpeed=0.4&uStrength=4"
  />
</ShaderGradientCanvas>
```

The playground does not emit JSX or JSON. The URL *is* the handoff artifact — either pass it with `control="query"` and `urlString`, or hand-transcribe the parameters into individual props. Do not tell the user a "copy code" button exists.

Presets ship in the package and can be spread: `<ShaderGradient {...presets.mint.props} />` — `halo`, `pensive`, `mint`.

**Defaults are the Halo preset, not the documented types.** `<ShaderGradient>` merges `presets.halo.props` with whatever you pass, so an omitted prop is a Halo value.

## Props

| Prop | Default | Notes |
|---|---|---|
| `type` | `'plane'` | `plane` \| `sphere` \| `waterPlane` |
| `shader` | `'defaults'` | `defaults` \| `positionMix` \| `cosmic` \| `glass` |
| `animate` | `'on'` | `on` \| `off` |
| `color1` / `color2` / `color3` | `#ff5005` / `#dbba95` / `#d0bce1` | hex |
| `uSpeed` | `0.4` | min 0.1; 0.1–2 reads well |
| `uStrength` | `4` | min 0.1; 0–10 practical |
| `uDensity` | `1.3` | min 0.1; presets use 0.8–2 |
| `uFrequency` | `5.5` | ~0–10 practical |
| `uAmplitude` | `1` | min 0.1; sphere only |
| `positionX/Y/Z` | `-1.4` / `0` / `0` | |
| `rotationX/Y/Z` | `0` / `10` / `50` | degrees, −360…360 |
| `lightType` | `'3d'` | `3d` (cheap, ambient) \| `env` (HDR, expensive) |
| `brightness` | `1.2` | 0.1–3 — **only affects `lightType='3d'`** |
| `envPreset` | `'city'` | `city` \| `dawn` \| `lobby` — **only affects `lightType='env'`** |
| `reflection` | `0.1` | 0–1 — **only visible with `lightType='env'`** |
| `cDistance` | `3.6` | 0–20 — **plane and waterPlane only** |
| `cAzimuthAngle` | `180` | 0–360 |
| `cPolarAngle` | `90` | 0–180 |
| `cameraZoom` | `1` | 0.1–30 — **sphere only** (sphere uses a fixed distance of 14) |
| `grain` | `'on'` | toggles a halftone post-processing pass — expensive |
| `range` | `'disabled'` | `enabled` \| `disabled`, with `rangeStart` / `rangeEnd` |
| `uTime` | `0` | manual seek; **ignored while `animate='on'`** |
| `control` | `'props'` | `props` \| `query` |
| `wireframe` | `false` | **no-op in v2** — do not advertise it |

Canvas props: `style`, `className`, `pixelDensity` (default 1 — "1 fast, 2 detailed and slow"; cap at 1–1.5, 0.5–1 on mobile), `fov` (45; 10–180), `pointerEvents`, `lazyLoad` (**default true**), `threshold` (0.1), `rootMargin` (`'0px'`), `envBasePath`, `preserveDrawingBuffer`, `powerPreference`.

Changing `pixelDensity` or `fov` remounts the canvas — the component keys on them.

## Performance

- **One canvas, one render loop, one GL context.** Multiple instances mean multiple contexts, and browsers cap those around 8–16. One gradient per page.
- **`lazyLoad` is on by default** — an IntersectionObserver at `threshold: 0.1` mounts the Canvas only when in view, and unmounts it off-screen, disposing the context. Keep it on.
- **`grain='on'`** mounts an `EffectComposer` with two render targets and fullscreen passes every frame. Set `grain='off'` unless the halftone is the look. Default is on.
- **`lightType='env'`** loads an HDRI (network plus PMREM cost). `lightType='3d'` is one ambient light and no texture.
- **It renders continuously** — there is no `frameloop="demand"` path. `animate='off'` freezes the shader's motion but the R3F loop still runs. If you need true idling, unmount the canvas when off-screen.
- **Reduced motion is not handled in the React package.** Only the Vue package reads `prefers-reduced-motion`. Wire it yourself: `animate={reducedMotion ? 'off' : 'on'}`.

## Contract

- **Fallback:** the React package has no fallback slot. Render a static CSS gradient or solid colour in the server HTML so the first paint has the right composition, then let the canvas mount over it. The CSS gradient should use the same three colours — that is what the visitor sees when WebGL is slow, blocked, or disabled.
- **Sizing:** the canvas renders into a wrapper that is `width: 100%, height: 100%`. If the parent has no resolved height, the canvas is 0px tall. Give the parent `100svh`, an aspect ratio, or a min-height, or absolutely position the canvas inside a sized relative parent.
- **Motion:** freeze with `animate='off'` under reduced motion. Do not leave a moving background running behind text for a user who asked for less motion.
- **Cleanup:** handled by the component when the Canvas unmounts. This is another reason to prefer one instance and `lazyLoad`.
- **Accessibility:** decorative background → `pointerEvents="none"` and `aria-hidden="true"`. Text over it needs a scrim: the gradient has no control over contrast, so the headline needs an actual overlay or a solid backing behind it.
- **SSR:** `'use client'`, and for safety `dynamic(() => import('./Gradient'), { ssr: false })`. Keep the static gradient in the server HTML.

## Pitfalls

- **Text contrast.** The gradient is unpredictable behind text. Compose the gradient so the headline's region stays dark (or light) enough, and still add a scrim. Never place body copy over a full-bleed animated gradient and hope.
- **Zero height.** See Contract. The most common "nothing appears".
- **The duplicate DOM id.** The canvas is created with `id="gradientCanvas"` — two instances produce duplicate IDs. Another reason for one.
- **Parameter asymmetry.** `brightness` only does anything in `3d` mode, `reflection` and `envPreset` only in `env` mode. Tuning the wrong one looks like a broken prop.
- **`uTime` does nothing while animating.** To control playback, use `range` / `rangeStart` / `rangeEnd`, or set `animate='off'` and seek `uTime` yourself.
- **Peer conflicts.** React 19 + Next 15 App Router needs R3F v9. R3F v8 fails against the App Router's vendored React.
- **The canvas eats scroll on touch** unless `pointerEvents='none'`.
- **One per page.** Two gradients means two contexts, two render loops, and eight times the GPU work for a background nobody looks at twice.
