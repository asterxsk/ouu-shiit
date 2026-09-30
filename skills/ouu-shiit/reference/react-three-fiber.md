# react-three-fiber

React renderer for three.js. Use it when the 3D has to be **programmatic** — driven by data, state, scroll position, or user input — and the site is already React.

Repo: https://github.com/pmndrs/react-three-fiber · Docs: https://r3f.docs.pmnd.rs · drei: https://drei.docs.pmnd.rs

## Install

```bash
npm install three @react-three/fiber @react-three/drei @react-three/postprocessing
npm install -D @types/three
```

**Pairing is a hard constraint.** Match the fiber major to the React major:

| React | @react-three/fiber | @react-three/drei |
|---|---|---|
| 18 | `^8` | `^9` |
| 19 | `^9` | `^10` |

drei v10 requires React 19. `@react-three/fiber@10` is alpha (WebGPU) — not for production. `leva` is a dev-only GUI for tuning values by hand; guard or strip it before shipping.

## The mental model

`<Canvas>` builds the scene, camera, and the render loop. It replaces the imperative three.js lifecycle entirely — never write your own `requestAnimationFrame` loop around it.

Lowercase JSX elements *are* three.js objects: `<mesh />` → `new THREE.Mesh()`. Constructor arguments go in `args` as an array (`<boxGeometry args={[1, 1, 1]} />`), and any other prop assigns the same-named property (`position={[0, 0, 5]}` calls `.set(...)`). Changing `args` reconstructs the object; keep those arrays stable.

```jsx
import { Canvas, useFrame } from '@react-three/fiber'
import { useRef, useState } from 'react'

function Spinner() {
  const ref = useRef()
  const [hovered, setHover] = useState(false)
  useFrame((state, delta) => { ref.current.rotation.y += delta * 0.4 })
  return (
    <mesh ref={ref} onPointerOver={() => setHovered(true)} onPointerOut={() => setHovered(false)}>
      <torusKnotGeometry args={[1, 0.35, 160, 32]} />
      <meshStandardMaterial color={hovered ? 'hotpink' : '#111'} metalness={0.9} roughness={0.15} />
    </mesh>
  )
}

export default function Scene() {
  return (
    <Canvas>
      <ambientLight intensity={Math.PI / 2} />
      <directionalLight position={[5, 5, 5]} intensity={Math.PI} />
      <Spinner />
    </Canvas>
  )
}
```

`useFrame` is the per-frame hook. Mutate refs inside it; never call `setState` per frame. Components render outside React, so animation costs nothing in reconciliation.

Canvas defaults worth knowing: `camera={{ fov: 75, near: 0.1, far: 1000, position: [0, 0, 5] }}`, `dpr=[1, 2]`, `frameloop="always"`, `shadows=false`. `dpr`, `frameloop`, `performance`, and `shadows` can all be changed at runtime. `fallback` renders DOM JSX when WebGL is unavailable — use it instead of sniffing for support yourself.

## drei helpers worth reaching for

drei is where the site-useful abstractions live. The shortlist:

- **`<Environment>`** — image-based lighting from an HDRI. The single highest-impact helper: it makes materials look real without a light rig. **Do not ship the `preset` prop** — its own docs say presets are not for production because they fetch from a CDN. Ship an `.hdr`/`.exr` via `files`.
- **`<Float>`** — idle hover. `speed`, `rotationIntensity`, `floatIntensity`, `floatingRange` (default `[-0.1, 0.1]`).
- **`<ContactShadows>`** — cheap fake ground shadow, no shadow maps. `frames={1}` for a static scene. `opacity`, `scale`, `blur`, `far`, `resolution`.
- **`<PresentationControls>`** — springy, snap-back product spin. Use this instead of `OrbitControls` for a product: the user can't get the object lost, and the camera never moves.
- **`<OrbitControls>`** — free camera orbit. Only when exploring the scene *is* the task.
- **`useTexture(url)`** — suspense-based texture loading. Accepts an array or a prop object: `useTexture({ metalnessMap, map })`.
- **`<Html>`** — DOM labels anchored to 3D points. The right tool for product callouts: `occlude`, `center`, `transform`, `distanceFactor`, `zIndexRange`.
- **`<MeshTransmissionMaterial>`** — real glass/acrylic refraction. Expensive: keep `samples` low (6) and `resolution` explicit (256), not fullscreen.
- **`<PerspectiveCamera makeDefault />`** — declare a camera in the tree instead of prop-drilling the Canvas.
- **`<Text>`** — troika SDF text. Pass `font` and `characters` to avoid a flash of unstyled text.
- **`useGLTF` / `Preload` / `useProgress`** with drei's `<Loader />` — model loading with a real progress bar.
- **`PerformanceMonitor`, `AdaptiveDpr`, `AdaptiveEvents`** — see Contract.

Also: `Bounds`, `Center`, `Stage`, `Sky`, `Stars`, `Cloud`, `Sparkles`, `Instances`, `Merged`, `Detailed` (LOD), `useDetectGPU`, `useIntersect`.

## Scroll-driven 3D

`<ScrollControls>` creates an HTML scroll container *in front of* the canvas, in three zones:

```jsx
<Canvas>
  <ScrollControls pages={3} damping={0.2}>
    <Rig />                       {/* pinned: doesn't scroll, reads useScroll */}
    <Scroll>{/* canvas children that scroll */}</Scroll>
    <Scroll html>{/* DOM children that scroll */}</Scroll>
  </ScrollControls>
</Canvas>
```

`useScroll()` returns `{ offset, delta, range(a, b, margin?), curve(a, b, margin?), visible(a, b, margin?) }`, read **inside `useFrame` only**. `range` ramps 0→1 across a slice of the page; `curve` ramps in and back out; `visible` returns a boolean for a slice. Props: `pages=1`, `damping=0.2`, `distance=1`, `infinite=false`.

**The important caveat:** ScrollControls installs its own scroll container. That fights native scroll, `position: sticky`, and especially Lenis. When you only need "animate this as the section scrolls past", skip ScrollControls — mount the canvas in a normal div and drive `useFrame` from an `IntersectionObserver` or a passive scroll listener. Use ScrollControls when the sequence *is* the page, and scroll one canvas per page.

## Performance

- **Cap dpr.** `dpr={[1, 1.5]}` for hero and product canvases. Never full retina on mobile.
- **`frameloop="demand"`** renders only on change — right for static or interaction-driven scenes. Call `invalidate()` after mutations React can't see; drei controls and `<Float>` need `autoInvalidate` under demand or they freeze.
- **Suspense everything async.** `<Suspense fallback={null}>` around models and textures. Nested Suspense gives progressive quality: low-detail model as the fallback for the high-detail one.
- **Lazy-mount the canvas.** IntersectionObserver or a dynamic import. A hero below the fold should not build a GL context on page load.
- **Reuse geometry and materials.** Build once outside the tree, pass via `geometry={g} material={m}`. Every unique material is GPU state.
- **Draw-call budget:** a few hundred meshes is comfortable, ~1000 is the ceiling. Use `<Instances>` for anything repeated at scale (one call, hundreds of thousands of objects).
- **Adapt to the device:**
  ```jsx
  <Canvas dpr={[1, 2]} performance={{ min: 0.5 }}>
    <PerformanceMonitor onIncline={() => setDpr(2)} onDecline={() => setDpr(1)} flipflops={3} />
    <AdaptiveDpr pixelated />
    <AdaptiveEvents />
  </Canvas>
  ```
  `useDetectGPU` lets you serve a static poster instead of a live canvas on weak GPUs.

## Contract

- **Fallback:** the poster image or static composition ships in the server HTML and is what renders without JS. The Canvas mounts on top. `<Canvas fallback={...}>` covers the no-WebGL case.
- **Sizing:** `<Canvas>` fills its parent. The wrapper needs a resolved height — `height: 100svh`, an aspect ratio, or explicit pixels. A flex child with no intrinsic height gives a 0×0 canvas, which is the single most common "nothing appears".
- **Motion:** on `prefers-reduced-motion`, render one composed frame and stop. Freeze `useFrame` work, disable `<Float>` (`speed={0}`), and switch to `frameloop="demand"` so the loop isn't idling at 60fps.
- **Off-screen and hidden:** stop the loop when the canvas leaves the viewport or the tab is hidden.
- **Cleanup:** R3F disposes what it created; do not pass `dispose={null}` unless the geometry is intentionally shared. Anything you created globally (textures, geometries, an `Environment` you cached) must be disposed by hand, along with listeners and animation frames. Leaking a renderer across route changes exhausts the browser's context limit and kills every canvas on the page.
- **Accessibility:** decorative canvas gets `aria-hidden="true"`. Anything meaningful needs a text alternative in the DOM. Nothing interactive may exist only inside the canvas.

## Pitfalls

- **SSR crashes.** Every R3F and three import touches `window`/`document` at import time. In Next App Router the Canvas must be a client component *and* dynamically imported with SSR off, from inside a `'use client'` wrapper — `ssr: false` is not allowed in a Server Component. Keep the fallback in server HTML.
- **Next.js builds.** Add `transpilePackages: ['three']` to `next.config.js` (Next 13.1+) or the build fails on untranspiled add-ons.
- **Multiple canvases.** Browsers cap live WebGL contexts around 8–16. One canvas per page, mounted once near the top. If more are truly needed, mount on scroll and dispose on exit.
- **Bundle weight.** three plus fiber is roughly 600 KB minified before compression. It belongs below the critical path, lazy-loaded, with a real fallback.
- **Z-order and pointer events.** The canvas paints above static content. Content that must sit above it needs `position: relative` and a `z-index`; the canvas behind gets `pointer-events: none` unless it is the thing being dragged.
- **`args` identity.** An inline `args={[1, 2, 3]}` array is a new array every render and reconstructs the object. Hoist it.
- **`leva` in production.** Never ship `useControls` panels.
- **Event raycasting in scroll containers.** If the canvas sits inside a scroll container or a transformed parent, raycasting misses; set `eventSource` / `eventPrefix`.

## When not to use it

- A static, non-interactive object where a rendered image, a pre-baked turntable, or a video would do — no bundle, no runtime.
- One decorative shape with no assets, no designer, and no interactivity: primitives may be enough, or Spline if a designer supplies a scene.
- Behind body copy on Read surfaces, inside cards, on Operate/dashboard screens, more than once per page.
- A non-React site — do not introduce React for one effect. Use an imperative path instead.
- A simple animated gradient background: that is ShaderGradient, not three.
