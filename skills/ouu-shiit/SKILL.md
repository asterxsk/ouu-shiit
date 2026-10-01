---
name: ouu-shiit
description: Use for any creative surface that needs a designed visual or motion layer - a website or web UI, a 3D scene or product viewer, a video or motion graphic, a slide deck or presentation, an app screen's motion, or a brand asset. Covers react-three-fiber (and the drei/postprocessing ecosystem), Spline, liquid glass, ShaderGradient, liquid-logo, Lenis, Motion, StringTune, and HyperFrames for HTML-to-video and decks. Routes by medium first: web effects, video and motion graphics, decks, and 3D each load different references and carry different contracts. Handles effect selection by surface and visitor mode, imperative vs declarative integration, particle and post-processing setup, scroll-driven 3D, glass refraction, gradient configs, GLSL displacement, smooth-scroll conflict resolution, deterministic frame rendering, and the performance, accessibility, SSR, reduced-motion, and cleanup contracts each layer has to satisfy. Pairs with the impeccable design skill, which owns visual direction and craft; this skill supplies the effect technology and the rules for using it without wrecking the page or the cut. Also covers the free shadcn component registries that ship pre-built versions of these effects - Cult UI, Kokonut UI, Skiper UI, and Watermelon UI - and which of their tiers are free, plus the design galleries that collect hero, pricing, navbar, call-to-action, and footer examples for settling a section's shape before the effect goes in.
---

# ouu-shiit

Eight web effect technologies and one video framework. This skill does not choose the design — [impeccable](../impeccable/SKILL.md) does. This skill answers a narrower question: **given the direction already chosen, which effect, scroll layer, or rendered frame earns a place on this surface, and how is it built so it stays fast, accessible, and alive after the hero scrolls away — or renders identically on every pass?**

**Start with the medium.** A website, a video, a deck, and an app screen take different references and obey different contracts. [reference/mediums.md](reference/mediums.md) is the router: read it first, and read its stand-down rule. This skill is deep on the web and on video, and routes rather than improvises everywhere else.

Effect inventory. The first eight are the **web** effect layer; the ninth leaves the browser entirely:

| Repo | Technology | Delivers | Reference |
|---|---|---|---|
| react-three-fiber | React renderer for three.js | Code-controlled 3D: product viewers, scenes, scroll-driven 3D, particles, post-processing | [reference/react-three-fiber.md](reference/react-three-fiber.md) |
| Spline | Browser 3D editor plus runtime | Designer-authored 3D scenes the page can drive | [reference/spline.md](reference/spline.md) |
| liquidglass.js | Glass refraction over live background | Floating chrome: nav bars, panels, modals, control clusters | [reference/liquid-glass.md](reference/liquid-glass.md) |
| shadergradient | Animated WebGL gradient | Hero and section backgrounds, card backdrops | [reference/shader-gradient.md](reference/shader-gradient.md) |
| liquid-logo | GLSL displacement on a logo texture | Brand moment: intro reveal, footer wordmark, divider | [reference/liquid-logo.md](reference/liquid-logo.md) |
| Lenis | Interpolated native smooth scroll | Whole-page scroll feel, scroll-driven storytelling | [reference/lenis.md](reference/lenis.md) |
| Motion | Animation library, scroll reader | Scroll-linked reveals, parallax, layout and exit animation — the general motion layer | [reference/motion.md](reference/motion.md) |
| StringTune | CSS-variable scroll and cursor effects | Scroll-choreographed marketing sections | [reference/stringtune.md](reference/stringtune.md) |
| HyperFrames | HTML/CSS/JS → deterministic MP4 | **Video, motion graphics, and slide decks** — the only non-browser medium here | [reference/hyperframes.md](reference/hyperframes.md) |

These are **GitHub repos, not npm package names.** `react-three-fiber`, `Spline`, `shadergradient`, `liquidglass.js`, `liquid-logo`, `Lenis`, `Motion`, `StringTune`, and `HyperFrames` are all repo names, and several are ambiguous in the wild: more than one unrelated repo is called `liquid-glass`, `liquid-logo` or `liquidglass.js`, "StringTune" collides with a guitar tuner, and **HyperFrames is the worst of them** — singular `hyperframe` on PyPI is a widely-used Python HTTP/2 library, and there is also a steel-framing construction company and a closed SaaS with no CLI under the same name. Each reference file opens with the real repos and which one to pick. The repo is the entry point; the package it publishes (or the source you copy in, when it publishes none) is the second hop. Never `npm install <repo-name>` — check the reference's table first.

**Which reference for which medium**, in brief — the full table, with the hand-offs, is [reference/mediums.md](reference/mediums.md):

| The brief is… | Load |
|---|---|
| A website or web UI | [reference/usage-map.md](reference/usage-map.md), then the effect's own reference |
| A video, motion graphic, or slide deck | [reference/hyperframes.md](reference/hyperframes.md) — decks included, via its `/slideshow` workflow |
| 3D, authored in code | [reference/react-three-fiber.md](reference/react-three-fiber.md) |
| 3D, authored by a designer | [reference/spline.md](reference/spline.md) |
| An Android or iOS app screen | Nothing here as the authority — hand off, per [reference/mediums.md](reference/mediums.md) |

Placement — which effect belongs on which part of a page, including the surfaces where every one of them is wrong — is [reference/usage-map.md](reference/usage-map.md). Read that before picking.

This skill supplies the effect layer, not the taste. Three installed references cover what it deliberately leaves out — the `design-taste-frontend` skill (motion budget, anti-slop bans, pre-flight check), the `web-design-guidelines` skill (interface audit), and the 74-brand DESIGN.md catalog at `~/.agents/design-md/` — documented in [reference/design-references.md](reference/design-references.md).

Five galleries collect one UI section each — hero, pricing page, navbar, call to action, footer — as screenshots of real shipped sites. They publish no code, so they are reference rather than dependency: use them to settle what the section is before deciding what goes in it. See [reference/design-galleries.md](reference/design-galleries.md).

Four shadcn component registries — [Cult UI](https://www.cult-ui.com), [Kokonut UI](https://kokonutui.com), [Skiper UI](https://skiper-ui.com), [Watermelon UI](https://ui.watermelon.sh) — ship free, ready-made versions of several effects on this list, together with the ordinary components that surround them. Before hand-building a glass panel, liquid-metal mark, shader blur, or animated gradient, check there: a registry component is usually smaller and already styled to the project. They are not exempt from the contract, though, and their paid tiers are out of scope — see [reference/ui-registries.md](reference/ui-registries.md).

## Order of operations

1. **Identify the medium.** Read [reference/mediums.md](reference/mediums.md) and name what is being made: a website, a video, a motion graphic, a slide deck, a 3D scene, an app screen. The medium decides which references are even relevant and which contract applies. If it falls outside this skill's depth — native mobile UI, a deck's argument, anything that is not an effect or motion layer — hand off now rather than stretching a web effect to cover it. `mediums.md` names the skill to defer to in each case.
2. **Direction is owned elsewhere.** Run impeccable's setup (`impeccable context`) and resolve its mode and visual world first. If the user's request is "make this site better", that is an impeccable request that may pull this skill in — not the reverse. When the brief is a greenfield landing page or portfolio with no committed world, the `design-taste-frontend` skill is the alternative direction source; when a brand or an obvious reference point is named, the DESIGN.md catalog supplies the tokens. See [reference/design-references.md](reference/design-references.md). Do not add an effect to a surface whose fundamentals (hierarchy, spacing, type, contrast, states) are unresolved; fix those first. The floor in impeccable's `craft-floor.md` still applies verbatim, and two of its refusals bite directly here — see **Reconcile with the craft floor** below.
3. **Pick one effect, name its job.** Read [reference/usage-map.md](reference/usage-map.md). State the job in one sentence before writing code: "the hero carries a scroll-driven 3D product that resolves into the feature section" or "the header floats as glass over the page content". An effect with no sentence is decoration, and the answer is no. If `design-taste-frontend` is in play, its `MOTION_INTENSITY` dial is the budget this effect has to fit inside. When the job is a hero, navbar, CTA, footer, or pricing page and the section's shape is not settled, [reference/design-galleries.md](reference/design-galleries.md) is where you calibrate it — before choosing the effect, not after.
4. **Check whether it already exists.** Read [reference/ui-registries.md](reference/ui-registries.md) when the effect is one Cult UI, Kokonut UI, Skiper UI, or Watermelon UI ships and the project is already React with shadcn configured. Free components only — never configure a paid tier's licence key, and surface any attribution requirement to the user instead of absorbing it. If a registry has it, use it and skip to step 6. On the video and deck path the same move applies: `npx hyperframes catalog` and `npx hyperframes add` ship transitions, overlays, captions, charts, and maps.
5. **Load the reference for the chosen technology.** Do not load all nine; they are long and only one applies. The exceptions are real but rare: a brief needing both a 3D layer and a scroll layer loads those two and settles scroll ownership first; a video brief loads [reference/hyperframes.md](reference/hyperframes.md) and then **defers to upstream's `/hyperframes` router for the authoring detail** rather than re-deriving it here.
6. **Implement against that medium's contract.** Every reference file ends with a **Contract** and a **Pitfalls** section and those are not optional — read them before the first edit, not after the first bug. But the contract is not the same one across mediums: the six rules below are the **web** contract, and [reference/hyperframes.md](reference/hyperframes.md) carries a video contract that shares almost none of it. Do not carry web obligations into a frame, or the reverse. The same applies to a registry component you installed rather than wrote: its reduced motion, its canvas lifetime, and its scroll listeners are yours to verify.
7. **Verify, in bounded rounds, for the medium.** On the web, follow impeccable's discipline: one batched inspection round (desktop and mobile together), fix everything it shows in one batch, confirm once, stop. Effects that "should look right" do not. Screenshot the real page. On video, verify before rendering where you can — `hyperframes lint`, `check`, `snapshot`, and `keyframes` inspect motion without paying for a full encode — then confirm the rendered file exists at the right duration and resolution before calling it done.
8. **Audit once, then stop.** Run the `web-design-guidelines` skill over the changed files for the interface rules a screenshot cannot see, and `design-taste-frontend`'s pre-flight check for the taste rules. Fix what they flag in one pass; do not loop. On video, the audit is captions, audio levels, hold duration, and asset licensing — [reference/hyperframes.md](reference/hyperframes.md) lists them.

## Reconcile with the craft floor

`craft-floor.md` refuses two things this skill makes easy to abuse. Both refusals stand; the effect has to be earned, not defaulted to.

- **"Glass and blur as decoration rather than as a specific effect."** Liquid glass is legitimate when it does a job: chrome floating over content that must stay visible beneath it (a nav bar over a hero, a control cluster over a canvas, a modal over a live page). It is decoration when a plain surface would read better — a static card on a static background gains nothing but cost and a contrast hazard. If you cannot say what is showing through the glass and why the user benefits from seeing it, use a solid surface.
- **"Gradient text."** A shader gradient behind a heading is fine. Clipping the gradient to the glyphs is still refused; emphasis comes from weight or size.

Two more that follow from the same idea: **one authored moment per surface**, not several effects stacked because several were available (impeccable's `overdrive.md` calls this out — "Layer multiple competing extraordinary moments. Focus creates impact, excess creates noise"), and **no effect that masks weak fundamentals**.

## The web contract

**This is the contract for the web effect layer — the eight browser technologies. It is not the contract for everything in this skill.** A video or a deck renders a fixed grid of frames once rather than sustaining a page indefinitely, so it obeys a different set of obligations: determinism, render cost, codec, audio levels, captions, asset licensing. That contract lives in [reference/hyperframes.md](reference/hyperframes.md), and the two must not be mixed. Carrying "pause off-screen" and "one owner for scroll" into a composition is cargo-culting; carrying "seekable, renders identically every pass" back onto a page is meaningless.

Every WebGL or scroll layer on the web obeys these six rules. The per-technology reference gives the specifics; these are the invariants.

- **The page works without it.** Content, copy, controls, and navigation render and function with the canvas absent. The effect is an enhancement layered over a complete page — never a container that content lives inside. Build and verify the static version first, then add the canvas.
- **GPU cost is bounded and measured.** Cap device pixel ratio (1.5–2, and lower on mobile). Pause rendering when the canvas is off-screen or the tab is hidden. Lazy-mount the canvas only when it approaches the viewport. If a mid-range phone drops below ~50fps, cut resolution, then particle/geometry counts, then the effect itself.
- **Motion respects `prefers-reduced-motion`.** Reduced motion means a static, composed frame — not a paused canvas showing nothing, and not a continuing animation. Lenis handles it by default; for everything else you wire it, and the references say where.
- **Everything is unmounted and disposed.** Cancel animation frames, remove listeners, dispose geometries, materials, textures, and renderers, and drop the GL context. A route change that leaks a renderer will exhaust the browser's context limit and kill every canvas on the page.
- **It is legible and keyboard-reachable.** Text over an effect gets a real contrast guarantee (scrim, gradient wash, or a solid backing), not hope. Decorative canvases get `aria-hidden="true"`; meaningful ones get a text alternative. Nothing interactive may live only inside a canvas.
- **Scroll has exactly one owner.** Native, Lenis, drei `ScrollControls`, or StringTune's smooth mode — one of them, never two. This is the failure that produces judder and a page that will not settle. See [reference/usage-map.md](reference/usage-map.md).

## Web integration

Applies to the browser technologies. The video path has its own integration story — `npx hyperframes init`, Node ≥ 22, FFmpeg — in [reference/hyperframes.md](reference/hyperframes.md).

- **Stack:** on the web, confirm the framework before choosing an integration style. react-three-fiber and ShaderGradient assume React (ShaderGradient has a Vue package and no vanilla path at all). Spline and most liquid-glass implementations have a vanilla path. Lenis and StringTune are framework-agnostic. For a non-React site, prefer the imperative libraries over introducing React for one effect.
- **SSR (Next.js, Remix, SvelteKit, Astro):** canvases touch `window`, `document`, and the WebGL context at import time. Client-only load them — `dynamic(() => import(...), { ssr: false })` in Next, an island or client directive elsewhere — and keep the static fallback in the server-rendered HTML so the first paint is never empty.
- **Sizing:** every WebGL container needs a resolved height from CSS (`height: 100svh`, an aspect ratio, or explicit min-height). A flex child with no intrinsic height renders a zero-height canvas, which is the single most common "nothing appears" failure.
- **Multiple canvases:** browsers cap live WebGL contexts (typically ~8–16). Prefer one canvas per page, mounted once near the top and reused, over one per section. If a page truly needs several, they must mount on scroll and dispose on exit.
- **Layering:** canvases default above static content in paint order. Content that must sit above gets `position: relative` and an explicit `z-index`, and stays interactive (`pointer-events`) while the canvas behind is `pointer-events: none` unless it is the thing being dragged.

## Assets

Effects that need supplied assets must name them to the user rather than inventing a placeholder: a logo for liquid-logo (SVG or transparent PNG, ideally a two-colour mark), a `.splinecode` scene for Spline, product models or textures for react-three-fiber, brand colours or a playground URL for ShaderGradient. If an asset is missing, build the effect so the slot is obvious and the page still works, then say exactly what to drop in. The full checklist is at the end of [reference/usage-map.md](reference/usage-map.md).

On the video path the asset situation is different in one useful way and one dangerous way. HyperFrames can generate what it needs — voiceover, music, images, captions — so a missing asset is less of a blocker, and `/media-use` is the skill that resolves one. But a rendered video is a **published artifact**, so every music track, font, and image in it must be licensed or original. Generated is not the same as cleared. Name what was used and where it came from; see [reference/hyperframes.md](reference/hyperframes.md).

## Report

State what was added, where, what it costs (rough bundle weight and per-frame work, or render minutes on the video path), how it degrades, and what the user must supply. Name the effect's job in the same sentence as the effect, so the next reader can judge whether it earned its place.
