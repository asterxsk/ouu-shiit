# Design references

Three installed references back this skill. They answer questions this skill deliberately does not: what the design should be, whether the built result passes, and what a given brand's visual language actually is.

| Reference | Kind | Answers | Invoke |
|---|---|---|---|
| **design-taste-frontend** | Installed skill | What the design should be. Brief inference, three dials, anti-slop bans, pre-flight check | Skill tool, or read `~/.agents/skills/design-taste-frontend/SKILL.md` |
| **web-design-guidelines** | Installed skill | Does the built result pass. Review against the Web Interface Guidelines | Skill tool |
| **DESIGN.md catalog** | Reference files | What this brand's design language is. 74 analysed brand systems | Read `~/.agents/design-md/<brand>/DESIGN.md` |

Plus **impeccable**, which owns direction and craft in the normal case.

## design-taste-frontend

The anti-slop frontend skill (Leonxlnx/taste-skill, MIT, ~91k stars). It gives the agent a design read, three dials, and a long list of banned defaults.

**Load it when:** the brief is a greenfield landing page, portfolio, or redesign, and the design direction has not been settled by impeccable.

**Do not load it when:** the task is dashboard or dense product UI. It says so itself — dashboards, data tables, multi-step wizards, and code editors are out of scope, and it points at Fluent, Carbon, Atlassian, or Polaris instead.

What matters most to this skill:

- **The three dials are the budget for effects.** `DESIGN_VARIANCE` 1-10, `MOTION_INTENSITY` 1-10, `VISUAL_DENSITY` 1-10, baseline `8 / 6 / 4`. Read `MOTION_INTENSITY` before adding any of this skill's effects. Below 5, a scroll-driven 3D hero or a liquid logo is over budget and the answer is no. Above 5, its rule is "motion claimed, motion shown" — a page that declares high motion intensity must actually move, and every animation must be justifiable in one sentence (hierarchy, storytelling, feedback, or state transition).
- **It names the same glass problem.** Section 5 lists Liquid Glass as context-appropriate for premium consumer, Apple-adjacent, luxury, and media-overlay work, and inappropriate for dashboards, public-sector, and boring B2B. Section 2.B states plainly that there is no official `liquid-glass.css` and that web implementations are approximations, to be labeled as such. That agrees with impeccable's craft floor and with [liquid-glass.md](liquid-glass.md).
- **Reduced motion is mandatory above `MOTION_INTENSITY` 3.** Non-negotiable there, and it is one of this skill's six contracts.
- **Two bans that constrain the effect layer.** Section 9.A bans custom mouse cursors outright — so a cursor-tracking glass panel, a magnetic cursor, or a StringTune cursor module needs a real justification or a drop. Section 9.E treats three.js as a large dependency that must be lazy-loaded and kept off the critical path, which is the same conclusion as [react-three-fiber.md](react-three-fiber.md).
- **Its pre-flight check is a better final gate than anything this skill would invent.** Run it after the effect is built. In particular: real images used, no div-based fake screenshots, no hand-rolled decorative SVGs, motion motivated, marquee at most one per page, reduced motion handled, dark mode defined and tested.

**Sibling skills in the same repo, installable but not installed:** `redesign-existing-projects` (relevant when the job is upgrading an existing site rather than a greenfield build), `full-output-enforcement` (when the agent truncates long output), `high-end-visual-design`, `minimalist-ui`, `industrial-brutalist-ui`, `stitch-design-taste`, plus image-generation skills. Install one at a time; they are alternatives, not layers.

## web-design-guidelines

Vercel's review skill (~680k installs). Thin by design: it fetches the current guidelines from a source URL at review time, reads the target files, and reports findings as terse `file:line` entries.

**Use it as the audit pass**, after the effect is built and verified visually. It catches the interface-level defects that a visual check misses — focus states, form contrast, semantics, and the accessibility rules that survive a screenshot.

It is a review skill, not a build skill. It reports; it does not fix.

## The DESIGN.md catalog

`VoltAgent/awesome-design-md` (MIT) is 74 markdown design systems reverse-engineered from real sites, plus preview pages. Google Stitch's DESIGN.md idea: a plain document an agent reads before building, describing how a product should look and feel, as distinct from AGENTS.md which describes how to build.

Installed locally at `~/.agents/design-md/<brand>/` with `DESIGN.md`, `preview.html`, and `preview-dark.html` per brand.

```
airbnb  airtable  apple  binance  bmw  bmw-m  bugatti  cal  claude  clay
clickhouse  cohere  coinbase  composio  cursor  dell-1996  elevenlabs  expo
ferrari  figma  framer  hashicorp  hp  ibm  intercom  kraken  lamborghini
linear.app  lovable  mastercard  meta  minimax  mintlify  miro  mistral.ai
mongodb  nike  nintendo-2001  notion  nvidia  ollama  opencode.ai  pinterest
playstation  posthog  raycast  renault  replicate  resend  revolut  runwayml
sanity  sentry  shopify  slack  spacex  spotify  starbucks  stripe  supabase
superhuman  tesla  theverge  together.ai  uber  vercel  vodafone  voltagent
warp  webflow  wired  wise  x.ai  zapier
```

Each file carries a frontmatter token block plus nine sections: Visual Theme and Atmosphere; Color Palette and Roles; Typography Rules; Component Stylings; Layout Principles; Depth and Elevation; Do's and Don'ts; Responsive Behavior; Agent Prompt Guide.

**Use it when** the brief names a brand or an obvious reference point ("like Stripe", "Linear-clean", "Apple-y"), and you need concrete tokens rather than a vibe. It converts a named reference into values a build can use.

**Do not use it when** the brief has its own brand. The catalog is reference material, not an identity.

**The honesty rule that applies here:** this catalog describes other companies' visual identities, built from their publicly visible CSS. Do not copy a brand's system wholesale and ship it as the user's design, and do not present an analysed token set as official brand documentation. Read it for structure, calibration, and the shape of a good design document — then derive the actual palette and type from the user's own brand. When a system genuinely is the brief, use the official package: Fluent, Carbon, Polaris, GOV.UK, USWDS, Primer, or the design system the brand actually ships.

Fetching a fresh copy instead of using the local one:

```
https://raw.githubusercontent.com/VoltAgent/awesome-design-md/main/design-md/<brand>/DESIGN.md
```

## How the three fit the build

1. **Direction** — impeccable (or design-taste-frontend when the brief is a marketing page with no committed world). Settle the mode, the world, and the motion budget.
2. **Effect** — this skill. Pick one effect from [usage-map.md](usage-map.md), load its reference, build it against the contract.
3. **Pre-built** — [ui-registries.md](ui-registries.md), when the effect is one Cult UI, Skiper UI, or Watermelon UI already ships as a free component. Free tiers only.
4. **Tokens** — the DESIGN.md catalog, when a named reference needs concrete values.
5. **Audit** — web-design-guidelines for the interface rules, the effect's own Pitfalls section for the GPU and scroll rules, and design-taste-frontend's pre-flight check for the taste rules. One batched pass, then stop.
