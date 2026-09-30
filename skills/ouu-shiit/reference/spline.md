# Spline

A browser 3D editor plus a runtime that plays its scenes. Use it when a **designer has already authored the 3D** and integration is the job. Use react-three-fiber when the 3D has to be controlled by code.

Site: https://spline.design · React runtime: https://github.com/splinetool/react-spline · Vanilla runtime: https://github.com/splinetool/spline-runtime · Docs: https://docs.spline.design

## What the agent can and cannot do

**Cannot:** author a scene. The `.splinecode` file is produced in the Spline editor by a person, and its object names, events, and variables are defined there. There is no way to generate one from code.

**Can:** integrate a scene the user supplies, drive it from the page, listen to its events, and make it perform well.

So the first step is always to ask for the scene URL or file. If there is no scene and no designer, Spline is the wrong choice — say so and use react-three-fiber with primitives, or skip the 3D.

## Install

```bash
npm install @splinetool/react-spline @splinetool/runtime
```

Non-React sites only need the runtime:

```bash
npm install @splinetool/runtime
```

## Three integration paths

| Path | Use when |
|---|---|
| `<Spline scene="..." />` from `@splinetool/react-spline` | React site. The default. |
| `Application` from `@splinetool/runtime` | Vanilla JS, Vue, Svelte, Astro, plain HTML. |
| Self-hosted `.splinecode` | You need to avoid the CDN, control caching, or the export URL gets CORS-blocked. |

## React

Export from the Spline editor: **Export → Code → React**, which gives a URL to pass as `scene`.

```jsx
'use client'
import Spline from '@splinetool/react-spline'

export default function Hero({ onReady }) {
  return (
    <Spline
      scene="https://prod.spline.design/XXXXXXXX/scene.splinecode"
      onLoad={(spline) => {
        const obj = spline.findObjectByName('Cube')
        if (obj) obj.position.x = 1.5
        onReady?.(spline)
      }}
      onSplineMouseDown={(e) => console.log('clicked', e.target.name)}
      className="h-full w-full"
      style={{ width: '100%', height: '100%' }}
      renderOnDemand
    />
  )
}
```

Props: `scene`, `onLoad`, `renderOnDemand` (default `true`), `className`, `style`, `id`, `ref`. Event props: `onSplineMouseDown`, `onSplineMouseUp`, `onSplineMouseHover`, `onSplineKeyDown`, `onSplineKeyUp`, `onSplineStart`, `onSplineLookAt`, `onSplineFollow`, `onSplineScroll`.

**Self-hosting:** the docs recommend downloading the `.splinecode` and hosting it yourself rather than depending on the export CDN. Set `scene="/scene.splinecode"`.

**Next.js:** import from `@splinetool/react-spline/next` instead. That variant renders an auto-generated blurred placeholder on the server, so the first paint is not empty. Exporting as Next.js from the editor generates the placeholder.

## Vanilla

```js
import { Application } from '@splinetool/runtime'

const canvas = document.getElementById('canvas3d')
const app = new Application(canvas)
await app.load('https://prod.spline.design/XXXXXXXX/scene.splinecode')

const cube = app.findObjectByName('Cube')
app.addEventListener('mouseDown', (e) => {
  if (e.target.name === 'Cube') app.emitEvent('mouseHover', 'Cube')
})
```

## Driving the scene from the page

The scene's objects and their event names come from the editor. The page talks to them by name.

- **Into the scene:** `app.emitEvent('mouseDown' | 'mouseUp' | 'mouseHover' | 'keyDown' | 'keyUp' | 'start' | 'lookAt' | 'follow', 'ObjectName')`. `emitEventReverse` plays a transition backwards, from last state to first.
- **Out of the scene:** `app.addEventListener(...)` on the runtime, or the `onSpline*` props in React. The handler receives the event; check `e.target.name` to know which object fired.
- **Direct mutation:** `findObjectByName` / `findObjectById` return the object; you can set `position`, `rotation`, `scale`, and `visible`. Object IDs come from right-click → *Copy Development Object ID* in the editor.
- **Variables:** scene variables set up in the editor can be written from the page, which is how you make a scene react to application state. This is the main lever, and it only exists if the designer wired it.

This is the boundary against react-three-fiber: Spline's reactivity is limited to what the editor exposes. If the 3D has to be a function of live data, use r3f.

## Performance

- **`renderOnDemand`** (default `true`) is the important one — the runtime only renders when something changes, instead of 60fps forever. Keep it on unless something in the scene animates continuously.
- The runtime plus a scene is heavier than a poster image and lighter than a hand-built three app. It is still a WebGL context, so it counts against the same ~8–16 limit.
- Lazy-load it: `React.lazy()` with a dynamic import wrapped in `<Suspense>`, or IntersectionObserver on a non-React site.
- Self-host the `.splinecode` so the page doesn't wait on a third-party origin.
- The free plan adds a Spline watermark. Paid plans remove it. Tell the user if the watermark shows up.

## Contract

- **Fallback:** ship a static poster in the server HTML and mount the scene over it. `@splinetool/react-spline/next` does this automatically in Next; elsewhere do it by hand.
- **Sizing:** the canvas needs a resolved height from CSS. `height: 100svh`, an aspect ratio, or explicit pixels. Zero-height containers are the classic blank scene.
- **Motion:** the scene's own animation is authored, not scripted here. On `prefers-reduced-motion`, do not mount the animated scene — show the poster frame. `renderOnDemand` already stops idle rendering; it does not stop an authored looping animation.
- **Cleanup:** the React component disposes on unmount. With the vanilla runtime, clear the canvas and release the context yourself when the section unmounts.
- **Accessibility:** the canvas is `aria-hidden="true"`. Any information carried by the scene needs a text equivalent in the DOM. Do not put the only copy of a call to action inside a Spline scene — its buttons are not keyboard reachable.

## Pitfalls

- **No scene, no integration.** Ask for the URL or `.splinecode`; do not fabricate one.
- **`pointer-events` and scroll.** The canvas sits in the page and swallows wheel and drag events. On a marketing page where scrolling matters more than the 3D, set `pointer-events: none` on the canvas and only enable it on hover or click. Otherwise the scene hijacks the scroll and the page feels broken.
- **CORS on the export URL.** If the scene fails to load, download the `.splinecode` and self-host.
- **Multiple scenes.** Each is a WebGL context. One per page.
- **Resizing.** The canvas must be told to resize; a scene in a container that changes size without a resize call renders stretched.
- **Editor round-trips.** Object names, event names, and variables are the contract with the designer. If the agent renames or re-creates objects in the scene, the page breaks. Treat them as an external API.

## Spline vs react-three-fiber

| | Spline | react-three-fiber |
|---|---|---|
| Authored by | Designer, GUI | Engineer, code |
| Agent can build from scratch | No | Yes |
| Reacts to app data | Only via editor-defined variables | Fully |
| Time to integrate a supplied scene | Minutes | Hours |
| Ongoing dependency | Spline runtime + scene file | Your code |
| Best for | A designed hero or explainer | 3D that *is* the product logic |
