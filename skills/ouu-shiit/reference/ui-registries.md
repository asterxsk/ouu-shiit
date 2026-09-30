# UI registries

Four component registries that overlap this skill's effect layer. They are the "do not hand-roll it" escape hatch: before writing a custom glass panel, shader background, or liquid-metal mark from scratch, check whether someone already ships it as a copy-paste component that matches the project's stack.

They are also the risk. A registry component arrives with its own animation loop, its own dependencies, and its own opinion about reduced motion — none of which are covered by this skill's contract until you check. Treat a registry component as a starting point that has to pass the same six rules as anything you build yourself, not as a finished answer.

All four are **shadcn registry** libraries. That is the shared architecture and the shared constraint: they install into a project that already has shadcn configured (`components.json`, Tailwind, a `cn()` helper), by fetching JSON from a registry URL and writing source files into the project. The component is yours to edit afterwards — which is the point, and also why nothing is versioned for you.

| Site | What it is | Cost | Best for | Install |
|---|---|---|---|---|
| [Cult UI](https://www.cult-ui.com) | Design-engineer components, MIT, 6.2k stars | Free (Pro blocks are paid — excluded) | **The closest overlap with this skill.** Glass, liquid metal, shader blur, gradient and texture backgrounds, ready-made | `npx shadcn@latest add @cult-ui/<name>` |
| [Kokonut UI](https://kokonutui.com) | 100+ animated components on Motion, ~2k stars | Free and open source (Kokonut UI Pro is paid — excluded) | Small, self-contained animated details: particles, shimmer, glass cards, AI-prompt surfaces | `npx shadcn@latest add @kokonutui/<name>` |
| [Skiper UI](https://skiper-ui.com) | "Un-common" animated components | Free tier + paid Pro (Pro excluded) | Odd interaction moments: dynamic island, token swaps, theme toggles, scroll marquees | `npx shadcn add @skiper-ui/skiperN` |
| [Watermelon UI](https://ui.watermelon.sh) | Broad React registry, MIT, 260+ components | Free | Breadth: ordinary components, dashboards and blocks alongside one effect, plus agent tooling | `npx shadcn@latest add "https://registry.watermelon.sh/r/<name>.json"` |

### Paid content is out of scope

This file documents **free components only**, and the instructions below are written so you never trip a paywall or a licence check.

- **Skiper UI Pro is paid** and is excluded. The Pro flow needs a Polar membership, a `SKIPER_LICENSE_KEY`, and an `Authorization: Bearer` header injected into the registry config. Do not configure that, do not ask the user for a licence key, and do not use a component marked with the premium symbol. See [Skiper UI, below](#skiper-ui) for how to tell the tiers apart. Note that the **free** tier requires attribution — that is a real constraint, not a formality.
- **Cult Pro blocks** at `pro.cult-ui.com` are paid and excluded. Every component in the open registry is MIT and unaffected.
- **Kokonut UI Pro** at `kokonutui.pro` is paid and excluded. Its own pricing and licence terms are not stated on the main site, so treat the boundary as "the open registry only" — `@kokonutui` components are the free ones.
- **Watermelon** is MIT with no paid tier documented. Some enterprise-hosting and template offerings may change; check before assuming.

If a user explicitly owns a licence and asks for a paid component, that is their call to make with their own key. Do not treat this section as permission to quietly enable one.

---

## Cult UI

[`nolly-studio/cult-ui`](https://github.com/nolly-studio/cult-ui) — MIT, 6.2k stars, actively developed. "Components crafted for Design Engineers."

**This is the one to check first.** Its component list overlaps this skill's effect layer more than any other registry: distorted glass, liquid metal, shader lens blur, animated gradient and fractal-dot-grid backgrounds, image textures, and a three.js carousel. If the brief calls for one of those and the project is already React with shadcn, a Cult component is usually a better answer than a hand-built `react-three-fiber` scene — smaller, already styled to the project's tokens, and already accessible.

Free components worth knowing, by the effect they supply:

| Need | Component |
|---|---|
| Liquid glass | `distorted-glass` |
| Liquid metal | `hero-liquid-metal`, `metal-button` |
| Shader / blur | `shader-lens-blur`, `edge-blur`, `morph-surface` |
| Animated background | `bg-animated-gradient`, `bg-animated-fractal-dot-grid`, `canvas-fractal-grid`, `stripe-bg-guides`, `grid-beam` |
| Texture and image treatment | `bg-image-texture`, `texture-card`, `texture-button`, `texture-overlay`, `dither-image`, `hero-dithering` |
| Moving imagery | `hover-video-player`, `three-d-carousel`, `feature-carousel`, `logo-carousel` |
| Chrome and shell | `dynamic-island`, `dock`, `floating-panel`, `side-panel`, `expandable-screen`, `mock-browser-window` |
| Type motion | `pixel-heading-word`, `pixel-heading-character`, `typewriter`, `text-animate`, `gradient-heading` |

Install:

```bash
npx shadcn@latest add @cult-ui/distorted-glass
```

Registry namespace, if `components.json` needs it:

```json
{ "registries": { "@cult-ui": "https://cult-ui.com/r/{name}.json" } }
```

Prerequisites, and this is the part that bites: Cult components target **Tailwind CSS v4** and the **`motion`** package (the current name; older Cult docs and older components used `framer-motion`). Check which the project has before installing, and expect to reconcile if the component and the project disagree.

```bash
npm install -D tailwindcss@latest @tailwindcss/postcss clsx tailwind-merge
npm install motion
```

It also ships an MCP path, which is the tidiest way to let the agent browse the catalogue rather than guess component names:

```bash
npx shadcn@latest mcp init --client claude
```

Note the repo README leans into AI-agent blocks and templates (92+ agent patterns, starter templates) with a separate paid tier. That is a different product line from the components above; this skill only cares about the free component registry.

## Kokonut UI

[kokonutui.com](https://kokonutui.com) — 100+ open-source components by Dorian Baffier, ~2k stars, built on React, Tailwind, and [Motion](motion.md). Its tagline is "Components humans browse. Agents ship." — and it backs that up with a machine-readable registry, an `llms.txt`, and shadcn MCP support, which makes it unusually easy to work with from an agent rather than through a browser.

**Reach for it for small, self-contained animated details**, where Cult UI ships the spectacular full-component version. The names to know overlap this skill directly: `liquid-glass-card`, `particle-button`, `shimmer-text`, `ai-prompt`. Where a Cult component is a whole hero, a Kokonut component is the one button or the one card — better when the effect needs to be a piece of a larger composition rather than the composition itself.

Install:

```bash
npx shadcn@latest add @kokonutui/liquid-glass-card
```

Registry namespace, if `components.json` needs it:

```json
{ "registries": { "@kokonutui": "https://kokonutui.com/r/{name}.json" } }
```

Stack and prerequisites are the same family as Cult UI — React, Next.js, Tailwind, shadcn, Motion — so the two registries coexist in one project without a second animation engine. That matters: both are built on `motion`, so a project using both ships one copy of the animation library, not two. Its MCP path is the same as Cult's:

```bash
npx shadcn@latest mcp init --client claude
```

The core registry is free and open source. **Kokonut UI Pro** at `kokonutui.pro` is a separate paid product — premium components, advanced templates, priority support — and is excluded here. There is no attribution requirement on the free components.

Because these components are Motion-based and mounted inside the app tree, a single root `<MotionConfig reducedMotion="user">` propagates to them. That is the cheapest way to make a page full of registry components respect reduced motion — but it is still only partial cover, and everything scroll-linked needs gating by hand. See [motion.md](motion.md).

## Skiper UI

[skiper-ui.com](https://skiper-ui.com) — by Gxuri. A trusted shadcn registry of deliberately unusual components: recreations of interface moments that are hard to build and rarely standardised. The site says so plainly — "most components here are recreations of the best out there."

**Reach for it when the brief wants one distinctive interaction**, not a component system: a dynamic island, an Aave-style token swap, a marquee that reacts to scroll, a theme toggle animated through the View Transition API (`useThemeToggle` from `skiper26`), flip and hover cards, animated theme-switch buttons (`skiper4`).

Two real ergonomic costs:

- **Components are numbered, not named.** `skiper4`, `skiper20`, `skiper26`, `skiper40`. You cannot tell what a component does from its name, so browse the site rather than guessing a slug.
- **The free tier requires attribution.** Free components are free to use and modify in personal and commercial projects, but "attribution to Skiper UI is required when using the free version." If the user's project cannot carry that attribution, either do not use these components or build the effect another way. Raising this with the user is part of using the library honestly.

Install a free component:

```bash
npx shadcn add @skiper-ui/skiper40
```

Prerequisites are heavier than the other two, because the components lean on motion and GSAP together:

```bash
pnpm add clsx framer-motion lucide-react tailwind-merge
```

Plus `tailwindcss`, `react`, `react-use-measure`, `gsap`, and a `lib/utils.ts` exporting `cn()` built from `clsx` + `tailwind-merge`.

**The paid tier, and how to avoid it.** Some components carry a premium symbol on the `/components` page. Pro installs use a Polar licence key, a `SKIPER_LICENSE_KEY` environment variable, and an `Authorization: Bearer ${SKIPER_LICENSE_KEY}` header on the `@skiper-ui` registry entry. Do not set any of that up. If a component you want turns out to be Pro, say so and propose a free alternative — a Cult UI component, or something built against this skill's references.

Because free components are third-party recreations under attribution, treat them as a starting point to restyle, not as a finished pattern to drop in unread.

## Watermelon UI

[ui.watermelon.sh](https://ui.watermelon.sh) — by [WatermelonCorp](https://github.com/WatermelonCorp), MIT. The broad one: 260+ components, plus blocks, page sections, dashboards, templates, and showcase compositions.

**Reach for it for breadth, not for effects.** Where Cult UI gives you one spectacular component, Watermelon gives you the whole ordinary surface — buttons, inputs, cards, accordions, modals, charts, dashboards — so the one effect you add is not sitting in a page you also had to build from scratch. It is the pragmatic choice when the brief is "a real product page with a moment in the hero" rather than "an effects showcase".

Stack: React 19, Tailwind CSS v4, Radix UI, Framer Motion, TypeScript throughout. Copy-paste architecture — components land in the project and stay editable.

Install by registry URL, since it does not use a namespaced shorthand:

```bash
npx shadcn@latest add "https://registry.watermelon.sh/r/card-split-accordian.json"
```

Its distinguishing feature for agent work is a **hosted MCP server with no API key**, which lets the agent search the catalogue and pull a component instead of guessing names from a 260-component list:

```bash
claude mcp add --transport http watermelon https://mcp.watermelon.sh/mcp
npx @watermelon-ui/cli init --client claude
```

The site markets itself as "Premium React Components", which is a tagline rather than a price — the project is MIT with no paid tier documented, no signup, and read-only public endpoints. Worth knowing so you are not put off by the word.

---

## How registry components meet the contract

A registry component is not exempt from the six rules in `SKILL.md`. It arrives as third-party source, so the rules have to be verified against it rather than assumed:

- **Page works without it.** Usually fine — these are self-contained UI, not page containers. Verify anyway for anything full-bleed, and for `expandable-screen`-style components that take over the viewport.
- **GPU cost bounded.** The shader and canvas components (`shader-lens-blur`, `canvas-fractal-grid`, `bg-animated-fractal-dot-grid`, `three-d-carousel`) allocate WebGL contexts and run their own loops. Check the DPR cap, check whether the loop pauses off-screen, and count the contexts against the page's budget.
- **Reduced motion respected.** The weakest point of every one of these libraries. They animate by default and rarely check `prefers-reduced-motion`. For the Motion-based ones — Cult UI and Kokonut UI — a single root `<MotionConfig reducedMotion="user">` covers them, though only partially, and never covers scroll-linked work. For the rest, you wire it in the project's own CSS. Do not assume the component did.
- **Disposed on unmount.** Specific to the canvas, GSAP, and three.js components: an unmounted route that leaves a renderer or a ticker alive is the classic leak. Motion handles its own listeners, so the Motion-based components are the safer half here.
- **Legible and keyboard-reachable.** Registry components are usually sound here, but check anything the component renders over its own effect, and check focus order in `dock`, `floating-panel`, and `dynamic-island`.
- **Scroll has exactly one owner.** The real trap, and it cuts two ways. The Motion-based components in Cult UI and Kokonut UI only *read* scroll, so they compose fine with Lenis — see [motion.md](motion.md). The GSAP-based scroll components in Skiper UI, and the scroll-triggered sections elsewhere, bind their own listeners and will fight a smooth-scroll library. Decide the scroll owner first, then pick components that respect it.

## Which to reach for

- Effect that Cult UI already ships — glass, liquid metal, shader blur, gradient background, texture — **use Cult UI**, do not hand-build it.
- A single animated detail inside a larger composition — an animated button, a shimmer heading, a glass card, a prompt field — **Kokonut UI**. Same stack as Cult, so they mix.
- One distinctive interaction the brief names specifically — a dynamic island, a token swap, a View-Transition theme toggle — **Skiper UI**, and check whether the one you want is free.
- A whole product surface that needs to look finished around the effect — **Watermelon UI**.
- **Build it yourself** when the effect has to react to app state, when the project is not on React with shadcn, when nothing ships the specific thing the brief describes, or when the cost of bending a component to fit exceeds the cost of writing it.
- Genuine 3D, real scroll physics, or a designer-authored scene: **none of these**. That is this skill's own layer — [react-three-fiber](react-three-fiber.md), [Spline](spline.md), [Lenis](lenis.md), [Motion](motion.md), [ShaderGradient](shader-gradient.md). The registries do not replace it, they reduce how much of it you have to write.

## Checking terms before you ship

Component libraries move fast: tiers change, licences change, components get renamed or gated. Before relying on any component from this file, confirm the current state of three things — the licence on the component you are actually installing, whether it sits in the free or paid tier, and whether attribution is required. If a check fails, or the answer is unclear, say so and offer an alternative rather than shipping an assumption.
