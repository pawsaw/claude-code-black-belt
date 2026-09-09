# nextacademy.io brand system

Extracted live from `https://www.nextacademy.io` (server-rendered Next.js — HTML and CSS
fetched directly, no headless browser needed) on 2026-09-09, the morning of delivery.
Nothing here is guessed; where an asset could not be retrieved it is called out explicitly
below and a marked placeholder was created instead.

## Tagline

The real lockup, verified in the hero `<h1>`, the `<title>` tag, and the OG meta:

> **"Learn What's Next. Today."** — with "Today." rendered in the primary colour.

(A related but distinct strapline, `"Build the Skills of Tomorrow, Today."`, appears in the
footer and social meta. Use the hero lockup for the title slide, per the build spec.)

## Colour palette

Sampled from the live Tailwind v4 stylesheet (`_next/static/chunks/*.css`).

| Role | Token | Hex |
|---|---|---|
| **Primary** (the brand colour — 91 occurrences on the homepage) | `--color-primary-600` | `#1e4478` |
| Primary, lighter/interactive | `--color-primary-500` | `#2f5f9f` |
| Secondary | `--color-secondary-600` | `#a63d56` |
| Accent | `--color-accent-500` | `#c99850` |
| Success | `--color-success-500` | `#16a34a` |
| Error | `--color-error-500` | `#dc2626` |

Signature gradient used across the homepage (8× `bg-gradient-to-br`, 4× `bg-gradient-to-r`):
`#1e4478 → #a63d56`.

Neutrals: the **zinc** scale is what's actually used in markup (a separate warm "neutral"
scale is defined but never applied) — `#fafafa` (50) down to `#09090b` (950), text at
`#18181b` (900) on a white page.

Full 50–950 ramps for primary/secondary/accent are in `slides/styles/tokens.css`.

### A genuine gap in the site's own CSS

The stylesheet references `--color-background: var(--background)` and
`--color-foreground: var(--foreground)`, but **`--background` and `--foreground` are never
defined anywhere** in any served CSS. They're dangling tokens. Effective values in practice
are white background / zinc-900 text, derived from utility classes, not a declared token —
noted here as observed usage, not fact.

### This deck's deliberate deviation: dark, not light

**The live site is light-only** — zero `prefers-color-scheme: dark` rules exist, and the only
dark surface on the whole site is the zinc-900 footer (which is exactly why the white-N logo
variant exists). For this deck, the trainer chose a **dark rendering of the same brand
palette** for projection legibility in a conference room, using that same zinc-900/950
surface as the deck's base and the site's own primary/secondary/accent hues as the accent
system on top of it. This is a considered choice, not a brand extraction — call it out if
anyone asks why the deck doesn't match the website.

## Typography

**Inter**, variable weight (100–900), self-hosted via `next/font`, no separate heading
typeface — headings are just heavier Inter. There is **no monospace font loaded** on the
site; `--font-mono: var(--font-geist-mono)` is defined in the stylesheet but Geist is never
actually served (leftover Tailwind default). This deck therefore makes an independent,
explicit choice for code: **JetBrains Mono**, loaded via Slidev's `fonts:` frontmatter.

## Shape, shadow, motion

- Radius: `rounded-lg` (`0.5rem`) dominant, `rounded-full` for pills/avatars.
- Shadow: `shadow-lg` dominant; a bespoke `--shadow-accent: 0 10px 15px -3px #c9985040`
  (gold-tinted glow) exists as a custom token — reused in this deck for "the thing to look
  at right now" per the style rule in the build spec.
- Motion: `--duration-fast .15s / normal .25s / slow .35s`, `--ease-out cubic-bezier(0,0,.2,1)`.

## Logo assets

| File | Source | Notes |
|---|---|---|
| `nalogo.svg` | `https://www.nextacademy.io/nalogo.svg` | Primary mark, light-background variant |
| `nalogo-white-n.svg` | `https://www.nextacademy.io/nalogo-white-n.svg` | White "N" for dark surfaces (footer variant) |
| `nalogo.png` | `https://www.nextacademy.io/nalogo.png` | 300×300 raster, not linked from the site's own HTML but genuinely served |

### Known asset trap — read before using the SVGs in export

Both logo SVGs draw the letters as `<text>` elements in **Source Sans Pro**, not outlined
paths. In headless Chromium (which is what `slidev export` uses for the PDF), if that font
isn't installed on the export machine, the glyphs silently fall back to a system font and
look wrong. **Decision: use `nalogo.png` anywhere the logo must survive PDF export**
(title slide, footer), and keep the SVGs available for on-screen/live presentation where
font substitution is less likely to matter or is easier to catch and fix before doors.

The logo's own internal colours — `#378292` (teal) and `#f6a672` (orange) — belong to a
**different palette than the website's**. This is a genuine inconsistency in nextacademy.io's
own brand, not a mistake on our part. We do not reconcile it; the deck uses the website
palette (primary/secondary/accent above) for everything except the logo mark itself.

## Manual follow-up required — do not invent these

| Asset | Status | What to do |
|---|---|---|
| Any social/OG image | `/opengraph-image` returns 404 on both the homepage and the topic page | Placeholder created at `public/brand/PLACEHOLDER-og-image.svg` |
| Apple touch icon | `/apple-icon.tsx` returns 404 (broken reference in the site's own `<head>`) | None created — not needed for a Slidev deck; flagged for completeness |
| 32×32 favicon | `/icon.tsx` returns 404 (same issue) | None created — Slidev ships its own favicon; not required |
| Wordmark lockup SVG | Does not exist — the wordmark is HTML text next to the mark, not an SVG | Do not fabricate one. The title slide sets the wordmark as real text in Inter, next to `nalogo.png` |
| `--background` / `--foreground` values | Referenced in CSS, never defined anywhere | Not used in this deck's tokens; see `tokens.css` for the deck's own explicit values instead |

## Trainer bio note (not a brand asset, but adjacent)

The nextacademy.io trainer page (`/trainers/pawel-sawicki`) describes Pawel Sawicki primarily
as a Senior Machine Learning Engineer (deep learning / NLP / LLM-based systems), while the
GitNation listing for this specific workshop credits "Pawel Sawicki, TuneTrain.ai." Both are
accurate descriptions of the same person from different angles; this repo does not attempt to
reconcile the two bios and quotes only the GitNation-sourced framing that matches this
specific workshop's abstract.
