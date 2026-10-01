# HyperFrames

**Write HTML. Render video.** An HTML/CSS/JS page becomes a deterministic, frame-perfect MP4. Use it when the deliverable is a **video, a motion graphic, or a deck** — the one medium this skill could not reach before.

Site: https://hyperframes.video · Repo: https://github.com/heygen-com/hyperframes · Docs: https://hyperframes.heygen.com · Package: `hyperframes` (npm) · License: Apache-2.0

The authoring bet is the inverse of Remotion's. Remotion renders React components; HyperFrames renders **plain HTML with `data-*` timing attributes**, needs no build step, and an `index.html` plays as-is. That is why it is unusually well suited to an agent: the agent already writes HTML, and the CLI is non-interactive by default.

## It is not the other thing

This name is worse than the ones this skill already warns about. Four unrelated projects answer to it, and three of them are *not* video tools. Check before installing anything:

| What you found | What it actually is | Video? |
|---|---|---|
| **`hyperframes`** on npm · [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) | **This one.** HTML→video framework by HeyGen | **Yes** |
| **`hyperframe`** on PyPI (v6.x) | Pure-Python **HTTP/2 framing layer**. Popular, mature, totally unrelated | No |
| [hyperframe.com](https://www.hyperframe.com) | Steel-framing construction system and BIM software | No |
| [hyperframe.ai](https://hyperframe.ai) | Closed B2B SaaS that assembles explainers from an approved brand-footage library. **No CLI, no public API** — not agent-drivable | Yes, but unusable here |
| hyperframes.app | Third-party SEO wrapper site, not the canonical source. Cite `hyperframes.video` | — |

Note the spelling: **HyperFrames**, plural, capital F. Singular `hyperframe` is the Python HTTP/2 library. As with every other reference in this skill, **never `npm install <what-you-googled>`** — confirm you have `heygen-com/hyperframes`.

## What the agent can and cannot do

**Can:** author a composition from nothing. Unusually for this skill, there is no designer in the loop and no supplied asset required — an agent can write the HTML, wire the animation, add synthesized voiceover and music, lint, preview, and render. This is the one reference here that does not begin by asking the user for a scene file.

**Cannot:** render without prerequisites. Node ≥ 22 and **FFmpeg on `PATH`** are hard requirements, and a missing FFmpeg fails at encode time, after the work is done. Run `npx hyperframes doctor` first.

**Cannot:** supply taste, or the assets only the user has. Same boundary as everywhere else in this skill — see [design-references.md](design-references.md) for who owns direction.

## Install

Two paths. Pick by how the agent is being used.

**As a plugin** (keeps itself updated, for Claude Code):

```bash
claude plugin marketplace add heygen-com/hyperframes
claude plugin install hyperframes@hyperframes
```

Then enable auto-update for the **hyperframes** marketplace in `/plugin` → **Marketplaces**, and invoke `/hyperframes:hyperframes`.

**As standalone skills** (any agent — this is the path the ouu-shiit installer uses):

```bash
npx skills add heygen-com/hyperframes
```

**Read this before scripting either one.** The `skills add` picker is **interactive-only and opens with nothing pre-selected**. A non-interactive or agent run that omits `--skill` therefore installs **all 21 skills** — not the core set. For a scripted, non-interactive install the documented path is:

```bash
npx hyperframes skills update          # installs exactly the core set, from current main
npx skills add heygen-com/hyperframes --skill <name>   # one skill, bare name, no leading slash
npx skills add heygen-com/hyperframes --all            # the full published set, deliberately
```

`skills add` resolves the skills.sh registry blob, which can lag `main` by hours. `npx hyperframes skills update` installs from current `main`. Prefer it when the newest copy matters.

Without any skills at all, the CLI alone is enough — `npx hyperframes <command>` needs no install:

```bash
npx hyperframes init my-video
cd my-video
npx hyperframes preview      # live-reloading preview
npx hyperframes render       # → MP4
```

## The authoring model, in one screen

A composition is a stage element, clips with timing attributes on tracks, and a seekable animation. That is the whole format.

```html
<div id="stage" data-composition-id="launch" data-start="0" data-width="1920" data-height="1080">
  <video class="clip" data-start="0" data-duration="6" data-track-index="0" src="intro.mp4" muted playsinline></video>

  <h1 id="title" class="clip" data-start="1" data-duration="4" data-track-index="1">Launch day</h1>

  <audio data-start="0" data-duration="6" data-track-index="2" data-volume="0.5" src="music.wav"></audio>

  <script src="https://cdn.jsdelivr.net/npm/gsap@3/dist/gsap.min.js"></script>
  <script>
    const tl = gsap.timeline({ paused: true });
    tl.from("#title", { opacity: 0, y: 40, duration: 0.8 }, 1);
    window.__timelines = window.__timelines || {};
    window.__timelines.launch = tl;   // the renderer seeks this timeline, frame by frame
  </script>
</div>
```

The renderer drives headless Chrome's BeginFrame API to **seek** each frame — it does not play in real time — then streams frames to FFmpeg. `window.__timelines` is the hook that makes a timeline seekable; an animation that runs on wall-clock time and cannot be seeked is the single most common authoring mistake. `data-composition-variables` plus render-time overrides let one bundle produce many videos, which is the batch/agent pitch.

## Where this skill's stack maps onto it

This is the reason the fit is good rather than merely adjacent — but it is a *partial* fit, and the gaps matter as much as the overlaps. Count them honestly before promising a port.

| Web technology | On HyperFrames |
|---|---|
| **react-three-fiber** | Three.js frame adapter — the same Three.js, driven seekably instead of by rAF |
| **Motion** (its animation core) | The GSAP adapter, and the default. `window.__timelines` is the contract |
| **ShaderGradient** | `@hyperframes/shader-transitions` — "WebGL shader transitions for compositions" |
| **liquid-logo** | The same shader-transition path. GLSL displacement ports; it is a fragment shader either way |
| **Spline** | **Not a documented adapter.** The vanilla Spline runtime can run inside a composition page, but seekability is unverified — test it before promising a port |
| **Lenis** | **Nothing.** Scroll is not a concept in a fixed-duration frame |
| **StringTune** | **Nothing.** Its whole model is scroll- and cursor-driven CSS variables |
| **liquid glass** | **Nothing direct.** It refracts a *live DOM*; a video has no live DOM. `capture` can film a page that has one, but the effect does not port |

**Four port cleanly, one is plausible but unverified, three do not transfer at all.** The three that fail all fail for the same reason: they are driven by a *visitor* — by scroll, by pointer, by whatever is behind the element. A rendered frame has no visitor. Anything interactive on a page becomes authored motion in a composition, or it does not come along.

The meta-references map better than the technologies do:

| Reference here | On HyperFrames |
|---|---|
| **UI registries** | [`hyperframes catalog`](https://hyperframes.heygen.com/catalog/blocks/data-chart) and `npx hyperframes add` — the identical "check it exists before hand-building" move. See [ui-registries.md](ui-registries.md) |
| **DESIGN.md catalog** | **frame.md** — takes a web `design.md` and inverts it for the camera: "the same tokens, the same rules, rewritten so an agent can compose a promo video without guessing at scale." A `DESIGN.md` superset. Browse at [hyperframes.dev/design](https://www.hyperframes.dev/design) |
| **A built website** | `npx hyperframes capture` — pulls a live site into a composition. The bridge from the page you already shipped to the launch video |
| **design-galleries.md** | Not applicable — those are page sections, not frames |

## Delegation — read this before authoring anything

HyperFrames ships **21 skills**, including its own router. Do not re-derive the authoring detail from this file, and do not re-implement what a workflow already does.

**Read `/hyperframes` first.** It is the capability map and intent router: it confirms the creation brief up front, then picks a workflow. It installs each workflow on demand.

| Workflow | For |
|---|---|
| `/product-launch-video` | A product/website — launch, promo, site tour, social clip (sweet spot 30–90s) |
| `/faceless-explainer` | Explaining a concept from text; every visual invented |
| `/pr-to-video` | A GitHub pull request → changelog or feature explainer, read via `gh` |
| `/motion-graphics` | Short, unnarrated, design-led — kinetic type, stat hit, logo sting (~under 10s) |
| `/music-to-video` | A track → a beat-synced video; music drives pacing |
| **`/slideshow`** | **A presentation, pitch deck, or interactive deck — fragment reveals, branching, hotspot navigation, presenter mode. Output is a navigable deck, not a rendered video** |
| `/embedded-captions` | Captions/subtitles onto an existing talking-head video |
| `/talking-head-recut` | Packaging an existing interview/podcast with designed overlays |
| `/remotion-to-hyperframes` | Porting an existing Remotion composition. One-way migration |
| `/general-video` | Anything else — the fallback, and the home of companion mode |

Domain skills load on demand: `/hyperframes-core` (the composition contract — `data-*`, `clip`, tracks, sub-compositions, variables, determinism), `/hyperframes-animation` (motion rules, scene blueprints, all seven adapters), `/hyperframes-keyframes`, `/hyperframes-creative` (`frame.md`, palettes, typography, beat planning), `/media-use` (the media OS — BGM, SFX, image, voice, transcribe, caption), `/hyperframes-cli`, `/hyperframes-audio` (mixing, EQ, ducking), `/hyperframes-registry`, `/figma`.

The `/slideshow` row is worth pausing on: **a deck is covered here, not elsewhere.** A request for a presentation is a HyperFrames request, routed to `/slideshow`.

## CLI

The dev loop, and the commands worth knowing exist:

| Command | Does |
|---|---|
| `init` | Scaffold a project. Takes `--non-interactive` for agents and CI |
| `doctor` | Verify Node, FFmpeg, and Chrome. **Run before the first render** |
| `preview` | Live-reloading preview. In a **non-interactive shell (an agent) it starts a managed background preview** that survives the command returning — `--background` / `--foreground` to choose, `--status`, `--stop`, `--list`, `--kill-all` to manage, `--json` for machine-readable output |
| `lint` · `check` | Validate the composition before spending render time |
| `snapshot` · `keyframes` · `compare` · `grade-compare` | Inspect rendered motion and colour without a full encode |
| `render` | Encode. Positional arg is the **project directory**, not a file: `-o output.mp4`, or `-c ./composition.html` for a specific one. Set `HYPERFRAMES_RENDER_DETACHED=1` under `nohup`/`disown` |
| `capture` | Pull a live website into a composition |
| `catalog` · `add` | Search and install registry blocks — transitions, overlays, captions, charts, maps |
| `transcribe` · `tts` · `bgm` · `beats` · `remove-background` | Media production, via `/media-use` |
| `normalize-audio` | Match loudness between clips in **LUFS**. Dry run unless `--write`; refuses unsafe boosts past Studio's +12 dB ceiling |
| `publish` | Upload and get a hosted URL. Private by default |
| `cloud render` · `lambda deploy/render/progress` · `cloudrun` | Remote render backends |

## Cost

**Local rendering is free.** Apache-2.0, no per-render fee, no commercial-use threshold — this is the licence difference from Remotion, which is source-available. Docker, AWS Lambda, and Cloud Run paths are self-hosted and likewise free of per-render charges.

**Only `cloud render` bills**, on HeyGen's managed infrastructure. State the rate to the user before invoking it, the way [ui-registries.md](ui-registries.md) handles paid tiers: do not silently spend someone's credits. **Default to local.** Reach for cloud only when the user asks, or when a render is too slow locally to be practical.

Render time is the real local cost. A seeked-frame render is not real-time: a 60-second 1080p30 composition is 1800 frames, each a headless Chrome seek plus an encode step. Budget minutes, not seconds — and use `snapshot`/`keyframes` to iterate on motion before paying for a full encode.

## Contract

This is a **video contract, and it is not the web contract.** The six rules in [SKILL.md](../SKILL.md) — WebGL context limits, scroll ownership, `pointer-events`, lazy mounting — are browser rules about a page that lives indefinitely. A video is a fixed grid of frames rendered once. Almost nothing transfers, so do not carry those obligations over and call it done.

- **Determinism is the headline guarantee, and it is yours to keep.** Same input, same frames, same output — that is what makes rendering in CI viable. It survives only if fonts are pinned (use the Docker path, which pins Chrome and fonts, when identical output actually matters), if no animation depends on `Date.now()` or `Math.random()`, and if every animation is **seekable** rather than wall-clock. An unseekable animation renders differently each pass and destroys the guarantee.
- **Resolution and frame rate are budget decisions, not defaults.** Output supports 16:9, 9:16, and 1:1, 1–240fps, 1080p and 4K. Pick from where the video will actually be watched — 9:16 and 30fps for social, 16:9 for a site hero. Frame count is the cost driver, so raising fps multiplies render time linearly.
- **Delivery format is chosen once, at encode.** MP4/H.264 is the default and the safe answer. WebM/MOV with alpha when an overlay must composite onto other footage. GIF only when a loop is genuinely required and the quality loss is acceptable. Decide before rendering; re-encoding later wastes the whole render.
- **Audio is mixed, not merely attached.** Level-match voice and music (`normalize-audio`, in LUFS), duck the bed under the voice (`/hyperframes-audio`), and keep music well under the voice. Do not ship a music bed at the same level as narration.
- **Captions are an accessibility requirement, not a nice-to-have.** Any narration or dialogue gets captions — `/embedded-captions` for existing footage, `/media-use` for transcription. A video whose only content is spoken and whose only channel is audio is inaccessible. The same applies to text the viewer must read: hold it long enough, and size it for a phone.
- **Every asset is licensed or original.** Music, footage, fonts, and images are the user's to clear, and a generated video is a published artifact. Name what was used and where it came from. If an asset is missing, ask — do not substitute a look-alike.

## Pitfalls

- **FFmpeg missing.** The most common first failure, and it surfaces at encode time — after all the authoring work. `npx hyperframes doctor` first, always.
- **You installed the wrong package.** PyPI `hyperframe` is an HTTP/2 library. If a Python environment suddenly has "HyperFrames" installed and no video tooling, that is what happened.
- **An agent-run `skills add` pulled all 21 skills.** The picker is interactive-only and starts empty, so a non-interactive run without `--skill` installs everything. Use `npx hyperframes skills update` from scripts.
- **A blind `preview` in an agent session.** It is managed and survives the command returning. Use `--status` / `--list` / `--stop` / `--kill-all` rather than launching a second one, and never leave them piling up.
- **Accidental spend.** `cloud render` bills per minute. Local is free. Check which one you invoked.
- **Promising a video that will not render.** Before saying "here is your video", confirm a real file exists on disk, at the right duration and resolution. A composition that previews correctly can still fail in the encoder.
- **Pre-1.0 churn.** 0.8.x, with a very fast release cadence. Any CLI flag pinned in a script can move. Pin the version in a project that must keep working, and re-check flags when you upgrade.
- **Treating the web contract as satisfied.** A composition is a web page underneath, which makes it tempting to assume the browser rules applied. They did not — determinism, codec, audio, and captions did, and they are different rules.
- **Re-deriving authoring detail instead of delegating.** 21 skills already document the composition contract, the animation adapters, and the media pipeline. Read `/hyperframes` and load the matching workflow; use this file for *whether* and *how it connects*, not for *how to write a timeline*.
