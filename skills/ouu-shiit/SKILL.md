---
name: ouu-shiit
description: Use when a website or web UI should be enhanced with a real-time GPU visual effect or a scroll-driven motion layer - a 3D scene or product viewer, a designed Spline scene, a liquid-glass chrome, an animated shader gradient background, a liquid-metal logo, smooth scrolling, or CSS-variable scroll choreography. Covers react-three-fiber (and the drei/postprocessing ecosystem), Spline, liquid glass, ShaderGradient, liquid-logo, Lenis, and StringTune. Handles effect selection by surface and visitor mode, imperative vs declarative integration, particle and post-processing setup, scroll-driven 3D, glass refraction, gradient configs, GLSL displacement, smooth-scroll conflict resolution, and the performance, accessibility, SSR, reduced-motion, and cleanup contracts every WebGL or scroll layer has to satisfy. Pairs with the impeccable design skill, which owns visual direction and craft; this skill supplies the effect technology and the rules for using it without wrecking the page.
---

# ouu-shiit

Seven effect technologies, one contract. This skill does not choose the design — [impeccable](../impeccable/SKILL.md) does. This skill answers a narrower question: **given the direction already chosen, which GPU effect or scroll layer earns a place on this surface, and how is it built so it stays fast, accessible, and alive after the hero scrolls away?**

Effect inventory:

| Repo | Technology | Delivers | Reference |
|---|---|---|---|
| react-three-fiber | React renderer for three.js | Code-controlled 3D: product viewers, scenes, scroll-driven 3D, particles, post-processing | [reference/react-three-fiber.md](reference/react-three-fiber.md) |
| Spline | Browser 3D editor plus runtime | Designer-authored 3D scenes the page can drive | [reference/spline.md](reference/spline.md) |
| liquidglass.js | Glass refraction over live background | Floating chrome: nav bars, panels, modals, control clusters | [reference/liquid-glass.md](reference/liquid-glass.md) |
| shadergradient | Animated WebGL gradient | Hero and section backgrounds, card backdrops | [reference/shader-gradient.md](reference/shader-gradient.md) |
| liquid-logo | GLSL displacement on a logo texture | Brand moment: intro reveal, footer wordmark, divider | [reference/liquid-logo.md](reference/liquid-logo.md) |
| Lenis | Interpolated native smooth scroll | Whole-page scroll feel, scroll-driven storytelling | [reference/lenis.md](reference/lenis.md) |
| StringTune | CSS-variable scroll and cursor effects | Scroll-choreographed marketing sections | [reference/stringtune.md](reference/stringtune.md) |

These are **GitHub repos, not npm package names.** `react-three-fiber`, `Spline`, `shadergradient`, `liquidglass.js`, `liquid-logo`, `Lenis`, and `StringTune` are all repo names, and several are ambiguous in the wild: more than one unrelated repo is called `liquid-glass`, `liquid-logo` or `liquidglass.js`, and "StringTune" collides with a guitar tuner. Each reference file opens with the real repos and which one to pick. The repo is the entry point; the package it publishes (or the source you copy in, when it publishes none) is the second hop. Never `npm install <repo-name>` — check the reference's table first.

Placement — which effect belongs on which part of a page, including the surfaces where every one of them is wrong — is [reference/usage-map.md](reference/usage-map.md). Read that before picking.

This skill supplies the effect layer, not the taste. Three installed references cover what it deliberately leaves out — the `design-taste-frontend` skill (motion budget, anti-slop bans, pre-flight check), the `web-design-guidelines` skill (interface audit), and the 74-brand DESIGN.md catalog at `~/.agents/design-md/` — documented in [reference/design-references.md](reference/design-references.md).

## Order of operations

1. **Direction is owned elsewhere.** Run impeccable's setup (`impeccable context`) and resolve its mode and visual world first. If the user's request is "make this site better", that is an impeccable request that may pull this skill in — not the reverse. When the brief is a greenfield landing page or portfolio with no committed world, the `design-taste-frontend` skill is the alternative direction source; when a brand or an obvious reference point is named, the DESIGN.md catalog supplies the tokens. See [reference/design-references.md](reference/design-references.md). Do not add an effect to a surface whose fundamentals (hierarchy, spacing, type, contrast, states) are unresolved; fix those first. The floor in impeccable's `craft-floor.md` still applies verbatim, and two of its refusals bite directly here — see **Reconcile with the craft floor** below.
2. **Pick one effect, name its job.** Read [reference/usage-map.md](reference/usage-map.md). State the job in one sentence before writing code: "the hero carries a scroll-driven 3D product that resolves into the feature section" or "the header floats as glass over the page content". An effect with no sentence is decoration, and the answer is no. If `design-taste-frontend` is in play, its `MOTION_INTENSITY` dial is the budget this effect has to fit inside.
3. **Load exactly one reference file.** The one for the chosen technology. Do not load all seven; they are long and only one applies. The exception is a brief that genuinely needs both a 3D layer and a scroll layer — then load those two, and settle scroll ownership first.
4. **Implement against the shared contract.** Every reference file ends with the same section headings — **Contract** (perf, fallback, motion) and **Pitfalls** — and those are not optional. Read them before the first edit, not after the first bug.
5. **Verify in the browser, in bounded rounds.** Follow impeccable's verification discipline: one batched inspection round (desktop and mobile together), fix everything it shows in one batch, confirm once, stop. Effects that "should look right" do not. Screenshot the real page.
6. **Audit once, then stop.** Run the `web-design-guidelines` skill over the changed files for the interface rules a screenshot cannot see, and `design-taste-frontend`'s pre-flight check for the taste rules. Fix what they flag in one pass; do not loop.

## Reconcile with the craft floor

`craft-floor.md` refuses two things this skill makes easy to abuse. Both refusals stand; the effect has to be earned, not defaulted to.

- **"Glass and blur as decoration rather than as a specific effect."** Liquid glass is legitimate when it does a job: chrome floating over content that must stay visible beneath it (a nav bar over a hero, a control cluster over a canvas, a modal over a live page). It is decoration when a plain surface would read better — a static card on a static background gains nothing but cost and a contrast hazard. If you cannot say what is showing through the glass and why the user benefits from seeing it, use a solid surface.
- **"Gradient text."** A shader gradient behind a heading is fine. Clipping the gradient to the glyphs is still refused; emphasis comes from weight or size.

Two more that follow from the same idea: **one authored moment per surface**, not several effects stacked because several were available (impeccable's `overdrive.md` calls this out — "Layer multiple competing extraordinary moments. Focus creates impact, excess creates noise"), and **no effect that masks weak fundamentals**.

## The shared contract

Every WebGL or scroll layer in this skill obeys the same six rules. The per-technology reference gives the specifics; these are the invariants.

- **The page works without it.** Content, copy, controls, and navigation render and function with the canvas absent. The effect is an enhancement layered over a complete page — never a container that content lives inside. Build and verify the static version first, then add the canvas.
- **GPU cost is bounded and measured.** Cap device pixel ratio (1.5–2, and lower on mobile). Pause rendering when the canvas is off-screen or the tab is hidden. Lazy-mount the canvas only when it approaches the viewport. If a mid-range phone drops below ~50fps, cut resolution, then particle/geometry counts, then the effect itself.
- **Motion respects `prefers-reduced-motion`.** Reduced motion means a static, composed frame — not a paused canvas showing nothing, and not a continuing animation. Lenis handles it by default; for everything else you wire it, and the references say where.
- **Everything is unmounted and disposed.** Cancel animation frames, remove listeners, dispose geometries, materials, textures, and renderers, and drop the GL context. A route change that leaks a renderer will exhaust the browser's context limit and kill every canvas on the page.
- **It is legible and keyboard-reachable.** Text over an effect gets a real contrast guarantee (scrim, gradient wash, or a solid backing), not hope. Decorative canvases get `aria-hidden="true"`; meaningful ones get a text alternative. Nothing interactive may live only inside a canvas.
- **Scroll has exactly one owner.** Native, Lenis, drei `ScrollControls`, or StringTune's smooth mode — one of them, never two. This is the failure that produces judder and a page that will not settle. See [reference/usage-map.md](reference/usage-map.md).

## Integration

- **Stack:** confirm the framework before choosing an integration style. react-three-fiber and ShaderGradient assume React (ShaderGradient has a Vue package and no vanilla path at all). Spline and most liquid-glass implementations have a vanilla path. Lenis and StringTune are framework-agnostic. For a non-React site, prefer the imperative libraries over introducing React for one effect.
- **SSR (Next.js, Remix, SvelteKit, Astro):** canvases touch `window`, `document`, and the WebGL context at import time. Client-only load them — `dynamic(() => import(...), { ssr: false })` in Next, an island or client directive elsewhere — and keep the static fallback in the server-rendered HTML so the first paint is never empty.
- **Sizing:** every WebGL container needs a resolved height from CSS (`height: 100svh`, an aspect ratio, or explicit min-height). A flex child with no intrinsic height renders a zero-height canvas, which is the single most common "nothing appears" failure.
- **Multiple canvases:** browsers cap live WebGL contexts (typically ~8–16). Prefer one canvas per page, mounted once near the top and reused, over one per section. If a page truly needs several, they must mount on scroll and dispose on exit.
- **Layering:** canvases default above static content in paint order. Content that must sit above gets `position: relative` and an explicit `z-index`, and stays interactive (`pointer-events`) while the canvas behind is `pointer-events: none` unless it is the thing being dragged.

## Assets

Effects that need supplied assets must name them to the user rather than inventing a placeholder: a logo for liquid-logo (SVG or transparent PNG, ideally a two-colour mark), a `.splinecode` scene for Spline, product models or textures for react-three-fiber, brand colours or a playground URL for ShaderGradient. If an asset is missing, build the effect so the slot is obvious and the page still works, then say exactly what to drop in. The full checklist is at the end of [reference/usage-map.md](reference/usage-map.md).

## Report

State what was added, where, what it costs (rough bundle weight and per-frame work), how it degrades, and what the user must supply. Name the effect's job in the same sentence as the effect, so the next reader can judge whether it earned its place.
