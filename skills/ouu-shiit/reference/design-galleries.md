# Design galleries

Five galleries that collect one UI section each — hero, pricing page, navbar, call to action, footer — and publish screenshots of real, shipped sites. They are reference, not dependency: every one of them shows what a section should look like, and none of them ships the code to build it. They answer the section-level question this skill does not own. This skill owns the effect layer; the section is the container the effect goes into, and these galleries are where you calibrate the container before you place anything in it.

The word to hold onto: **reference, not dependency**. A gallery entry is a screenshot and an outbound link. Nothing installs, nothing versions, nothing arrives in the project. [ui-registries.md](ui-registries.md) is the opposite — installable components. A gallery tells you what a good navbar looks like; this skill tells you which effect earns a place inside it and what that effect must satisfy.

| Gallery | Collects | Run by | Cost | Ships code |
|---|---|---|---|---|
| [Supahero](https://supahero.io) | Hero sections — the first screen | Now part of screensdesign (contact alex@screensdesign.com) | Free to browse; Featured and Premium rows are paid placement | No — screenshots and outbound links |
| [PricingPages.design](https://pricingpages.design) | Pricing pages | Credited "by FS" (finniansturdy.com); no owner named | Free; no paid tier found | No — screenshots and outbound links |
| [Navbar Gallery](https://www.navbar.gallery) | Navigation bars | Christina Liubynska | Free; a "Sponsored by Mobbin" slot sits on the home page | No — screenshots and outbound links |
| [CTA.gallery](https://www.cta.gallery/) | Individual CTAs | Salim Lunat, founder of Webestica and Iconstica | Free; advertising-funded | No — screenshots and outbound links |
| [Footer](https://www.footer.design) | Whole website footers | Benten Woodring, Devin Fountain, and Matt Cram; site by NOOON Studio | Free to browse and submit; a "Sponsored" affiliate card sits in the grid | No — screenshots and outbound links |

---

## Supahero

**What it is.** The hero-section gallery, at `supahero.io`. Its tagline is "Curated collection of beautiful website hero sections." It is now part of screensdesign (banners link to screensdesign.com, "the biggest UX app library in the world"), the only on-site contact is alex@screensdesign.com, and no individual owner is named. Entries live at `supahero.io/hero/<name>` — the served home HTML carried 573 distinct entry links.

**What it collects.** One artifact only: the hero section, the first screen of a site. Each entry is a single top-cropped screenshot of a real named site's homepage opening — nav, H1, and CTA visible together — not a mockup. One hero per entry, one entry per site. No full-page captures, no inner pages.

**How it is organised.** Flat and reverse-chronological: the home page is the browse index, a grid of screenshots keyed by slug (`/hero/better-stack`, `/hero/arc`), each carrying the site name, a date, and a one-line description. There are no on-site style or category filters and no category pages. The style filters third-party directories claim (Dark, Minimal, Bento, 3D, Gradient) are not present in the served HTML. A "Premium Spot" homepage section is paid placement, not an editorial category.

**Good for.** Settling the concrete decisions of the first screen: above-the-fold layout and grid, H1 type scale and line breaks, headline-versus-CTA pairing and button copy, nav placement and density, dark versus light and gradient/3D/video/illustration treatment, and background media choice — by comparing many real landed pages side by side rather than mockups. This is the container for the scroll-driven three.js scene ([react-three-fiber.md](react-three-fiber.md), [spline.md](spline.md)) or the shader gradient ([shader-gradient.md](shader-gradient.md)); read the gallery to decide what the hero is, then read [usage-map.md](usage-map.md) to decide which effect belongs in it.

**Not good for.** Motion. Every entry is a frozen moment of one screen — no scroll, no mobile view, no hover, no load behaviour — so it cannot tell you how a hero performs or reflows, and it gives no rationale for why a hero works. The set leans toward well-funded, English-language, design-led marketing sites and Framer template demos, and the Featured and Premium rows are advertising rather than editorial ranking. The project is folded into a commercial product, so URLs are stable but not guaranteed.

**Cost and licensing.** Browsing is free — no account, no paywall, no email wall. Monetisation is sponsored placement: "Get Featured" ($79), "Get Spotlight" ($149), and a $279 all-pages featured spot, sold on impressions and clicks. The screenshots are other sites' copyrighted work with no stated license; use them as visual inspiration, not as assets to lift.

---

## PricingPages.design

**What it is.** A curated gallery of pricing-page designs at `pricingpages.design`. Its description: "Discover handpicked pricing page examples from SaaS companies, ecommerce brands, and digital agencies." It is credited "by FS" linking to finniansturdy.com; no owner or company name is printed. Go to `pricingpages.design`, not the unrelated `pricingpages.com`.

**What it collects.** Real companies' live pricing pages — one entry per company, each a full-page screenshot of that company's pricing page shown as Desktop View and Mobile View, plus an outbound link to the source pricing URL and a small tag set. It collects the whole page, not isolated components. The visible first page runs n8n, Ramp, Supernotes, OneSignal, Chronicle, Orshot, Reducto, Stytch, AirShaper, Geostar, Dynamic, Chroma, Mux, Delphi AI, Osmo, Made with GSAP, ChatGPT, Squarespace, Calendly, Figma, Statamic, Whimsical, Vanta, and more.

**How it is organised.** The home page exposes two filter groups. **Components**: Color Coded Tiers, Comparison Table, Contact Sales option, Custom Pricing, Enterprise pricing, FAQs, Feature Checkmarks, Feature Sections, Monthly/Annual switch, Table, Testimonials, Tier Cards, Tier feature table, Usage-Based Calculator, Usage-Based pricing. **Design patterns**: Contact Sales, Enterprise pricing, Long and content heavy, One-off payment, Short and content light, Subscription option, Usage-Based Calculator. Each detail page adds Date Added, Styles, Industry, Editor's Note, Designed By, and Submitted By.

**Good for.** Settling pricing-page layout decisions: three-tier card row versus comparison table versus feature-checkmark matrix; whether to include a monthly/annual switch; where a "Contact Sales" or Enterprise tier sits in the ladder; whether to include a usage-based calculator; FAQ and testimonial placement; short versus long page length; how multi-currency and one-off versus subscription pricing are shown.

**Not good for.** Anything dynamic or measured. It is static screenshots — no copy, no hover behaviour, no conversion or analytics data, no signal about which design performed. The set is editor-curated plus user-submitted and skews to polished SaaS, startup, fintech, and AI/dev-tool pages, so it is not representative. Screenshots may be stale; the site's own legal page warns that pricing shown may be outdated.

**Cost and licensing.** Free — no login, no email gate, no paid tier found, free submission via `/submit`. All designs remain their owners' IP and screenshots are shown "for design inspiration only," so copying a layout carries IP risk. Minor discrepancy worth knowing: the legal page claims no cookies or analytics, but the page loads Fathom analytics.

---

## Navbar Gallery

**What it is.** A navigation-only gallery, served at `www.navbar.gallery` (the bare `navbar.gallery` redirects there). It is "a curated navigation-focused design inspiration website," made by Christina Liubynska and built in public on Twitter after the creation of footer.design. Home headline: "Best Navbar Design Inspiration Websites."

**What it collects.** Navigation bars only — a single-element gallery. One entry per source site (`/navbar/cloudflare`, `/navbar/asana`), each a screenshot or recording of that site's real navbar with desktop and, on detail pages, mobile versions. A reconnaissance figure put it at 496 entries.

**How it is organised.** Two parallel axes plus builder filters, on `/type/` and `/style/` routes. **Types** (10): static, dropdowns, mega-menu, side-bar, search-bar, announcement, full-screen, breadcrumbs, tabs, progress-bar. **Styles/industries** (~107, explicitly mixed): minimal, dark, brutalist, bento-box, glassy/blurred, gradient, pastel, colorful, flat, editorial, large-type, monochromatic, motion, parallax, horizontal-scroll, custom-cursor, animated, ai, saas, e-commerce, crypto, fintech, health, fitness, education, real-estate, restaurant, fashion, travel, gaming, portfolio, agency, startup, and more. **Builder filters**: `/webflow-navbars`, `/framer-navbars`, `/mobile-navigation`. The home page paginates and ranks entries by a numeric score.

**Good for.** Settling which navigation *pattern* to build before writing markup — mega menu versus dropdown, full-screen overlay versus side bar, announcement bar versus search bar — and seeing how a site pairs its desktop nav with its mobile counterpart. The `/type/` routes give a shared vocabulary for naming the pattern. This is the container for liquid glass ([liquid-glass.md](liquid-glass.md)): [ui-registries.md](ui-registries.md) ships `distorted-glass`, `dock`, and `dynamic-island` for exactly this slot, and the gallery is where you calibrate what the nav is before choosing the component.

**Not good for.** Behaviour. A static screenshot hides collapsed and expanded states, so you cannot see hover, open, or scroll states, breakpoints, spacing, type, motion, or accessibility. The set skews recent and fashionable — marketing, SaaS, AI, Framer, and Webflow sites that submit themselves — so it over-represents current style and under-represents enterprise, checkout, legacy, and non-Latin navigation. The taxonomy carries near-duplicate tags (ecommerce versus e-commerce, animated versus animation).

**Cost and licensing.** Free to browse — no paywall, no login, `/pricing` and `/pro` both 404. Monetised by a "Sponsored by Mobbin" slot on the home page and a Substack newsletter link in the footer, so ranking is not purely editorial. The nav designs are third-party brands' copyrighted work; copy the layout idea, never the logo, iconography, or assets.

---

## CTA.gallery

**What it is.** A call-to-action gallery at `www.cta.gallery/` (the apex `cta.gallery` redirects there; `catcta.gallery` does not resolve). Home title: "The Best Call-to-Action (CTA) Design Inspiration." Owner: Salim Lunat, founder of Webestica and Iconstica.

**What it collects.** Individual CTAs from real sites, captured at whole-CTA granularity — a button, a form, a modal, a newsletter block, a pricing CTA. Each entry is one specific CTA shown as a Desktop view and a Mobile view, not a full page.

**How it is organised.** Three facets per entry. **Category/Type** (8): Button, Call-to-Buy, Download, Form, Modal/Pop-up, Navigation, Newsletter, Pricing/Subscription. **Industry** (24): agency, ai, architecture, cafe, design, ecommerce, education, event-conference, finance, health-fitness, hotel, insurance, landing, logistic, marketing, medical, mobile-app, nonprofit, portfolio, real-estate, saas, services, tech, travel. **Mode** (2): Light, Dark. A separate Templates section collects Framer website templates marked "Use for FREE"/"Live preview," and there is a Submit flow.

**Good for.** Settling CTA copy and placement: copy length and wording ("Get started" versus "Start free trial"), above-fold layout and hierarchy, button versus modal versus pop-up, newsletter form patterns, pricing/subscription phrasing, nav CTA placement, and light-versus-dark treatment — with mobile and desktop shown together.

**Not good for.** Behaviour and evidence. Two static screenshots per entry tell you no conversion data, no A/B results, no performance, no accessibility, no animation or responsive behaviour, and no specs. The set is a curator's taste, skewed to trendy, high-production, English-language, mostly Western branding, agency, and SaaS sites. Sponsored, Featured, and template entries are paid placements mixed into ordinary listings.

**Cost and licensing.** Free to browse — no paywall, no email wall, `/pricing` is 404. Monetised by advertising: a "Sponsored by" block and a `/advertise` page selling Template Listing, Logo Sponsorship, and Featured Banner placements. The Templates section is the owner's own commercial funnel. Screenshots are of third-party sites the gallery does not own; use them for inspiration, not reproduction.

---

## Footer

**What it is.** The footer gallery, at `www.footer.design`. Title: "Footer — The only footer gallery on earth." It describes itself as "a curated gallery of the top website footer inspiration on earth." A self-described passion project started by Benten Woodring and Devin Fountain, and Matt Cram, with logo by Fons Mans; site by NOOON Studio.

**What it collects.** Whole website footers — the entire footer section of a site, one entry per website. Not separate components: there is no "link column" or "copyright bar" entry, only the full footer of one real site as an image card. The sitemap lists 36 style pages and 81 type pages.

**How it is organised.** Two orthogonal axes plus browse. **Styles** (36): 3d, animated, bento-box, bold, bright, brutalist, calm, cards, colorful, custom-cursor, dark, elegant, flat, fun, gradient, grid, gsap, horizontal-scroll, illustrative, interactive, large-type, minimal, monochromatic, parallax, pastel, patterns, photographic, retro, skeuomorphic, small-type, sound, transitions, typographic, unusual, video, webgl. **Types** (81, industry/topic): agency, ai, architecture, beauty, crypto, d2c-direct-to-consumer, design, ecommerce, editorial, education, fashion, film, finance, fitness, food-drink, gaming, health, legal, marketing, motion, music, real-estate, restaurant, robotics, saas, security, startup, studio, technology, travel, venture-capital, and more down to watchos-app and writing. `/browse` hosts the full index.

**Good for.** Settling footer decisions at scale: layout archetype (multi-column link grid versus one large wordmark versus bento/card footer), typographic treatment (large-type, small-type, typographic), colour mode (dark, bright, pastel, monochromatic), density and information architecture (how many link columns, where social/newsletter/legal sit), and motion approach (animated, video, webgl, gsap, parallax, horizontal-scroll). This is the container for a liquid-metal wordmark ([liquid-logo.md](liquid-logo.md)) or an interactive scroll moment ([lenis.md](lenis.md), [motion.md](motion.md)) — pick the footer shape here, then pick the effect from [usage-map.md](usage-map.md).

**Not good for.** Building instructions. No code, no spacing, type, or colour values, no motion specs, no rationale — only static captures that can go stale against the live site, with links out to third parties. The set skews to designer and studio portfolios, indie studios, startups, and agency work, so enterprise, legacy, and non-Western sites are under-represented.

**Cost and licensing.** Free to browse and submit — no account, no paywall, `/pricing` and `/pro` both 404. Monetised by a "Sponsored" affiliate card mixed into the same grid as editorial picks, so placement is not purely merit-based. Every footer is the copyright of its site owner; being listed is curation, not a licence — treat entries as inspiration to re-implement, not assets to copy.

---

## How these fit the build

Mirroring design-references.md's own list, with the galleries supplying the section shape:

1. **Direction** — impeccable owns the visual direction. The gallery does not set the brand; it only shows how a section type is commonly built.
2. **Section shape** — before the effect, settle what the section is. Hero from Supahero, navbar pattern from Navbar Gallery, CTA form from CTA.gallery, footer archetype from Footer, pricing layout from PricingPages.design. This decides the container.
3. **Effect** — this skill. Pick one effect from [usage-map.md](usage-map.md), load its reference, build it against the contract. The gallery never chooses the effect; it only says what the section should contain.
4. **Pre-built** — [ui-registries.md](ui-registries.md), when the effect the section needs is one Cult UI, Kokonut UI, Skiper UI, or Watermelon UI already ships as a free component. Free tiers only.
5. **Audit** — the effect's own Pitfalls section for the GPU and scroll rules, `web-design-guidelines` for the interface rules, and design-taste-frontend's pre-flight check for the taste rules. One batched pass, then stop.

## Honesty rule

These galleries showcase other companies' live sites. Do not copy a showcased design wholesale. Read them for structure and pattern calibration — how a hero arranges its nav, headline, and CTA; how a footer lays out its columns — and then derive the palette and type from the user's own brand. A design seen in a gallery still has to satisfy this skill's contract when you build it: page works without the effect, GPU cost bounded, reduced motion respected, disposed on unmount, legible and keyboard-reachable, scroll has exactly one owner. The gallery screenshot shows the section frozen; the contract governs whether the built section is shippable. Browsing every one of these is free, and no licence key is ever configured — the same rule [ui-registries.md](ui-registries.md) applies to paid registry tiers.
