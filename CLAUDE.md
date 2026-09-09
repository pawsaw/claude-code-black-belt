# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Current state

This repository is **pre-build**. It contains only the build specification under
`input/spec/`:

- `input/spec/WORKSHOP-BUILD-SPEC.md` — the authoritative, exhaustive spec (mission,
  constraints, required repo layout, slide-by-slide diagram requirements, timing table,
  acceptance criteria).
- `input/spec/clash-black-belt-runsheet.md` — the trainer-facing run-sheet with the same
  content in narrative form, including the exact talking points and section timings.

There is no `slides/`, `tasks/`, `README.md`, or any other build output yet — nothing to
lint, test, or run. **Read both spec files in full before doing anything else.** They are
long; do not skim. Do not start producing slides, tasks, or README content from partial
context.

## Mission (from the spec)

Build a complete, presentable, self-contained workshop repository for a 4-hour code-along
titled **"Claude Code: Black Belt"** (nextacademy.io, trainer Pawel Sawicki, first run at
React Day Berlin 2026). Three deliverables:

1. A Slidev presentation (`slides/`), nextacademy.io-branded, graphics-led not bullet-led.
2. A `tasks/` directory — one markdown spec per hands-on task, individually linkable.
3. A `README.md` — the participant entry point, linking every task.

## Non-negotiable constraints

- **Do not redesign the curriculum.** §6 of the build spec is fixed content and fixed
  timing (240 minutes total, section-by-section). Build exactly what it specifies —
  do not add topics, even ones that seem like natural fits.
- **The workshop is a live code-along**, not a workbook. Task specs exist so participants
  can re-read/catch up/repeat at home — never write a task or slide implying silent
  independent work in the room.
- **The target codebase is `pawsaw/clash`** (Next.js 16 / React 19 / Prisma 7 + SQLite /
  shadcn / Leaflet), and it is already fully built. The workshop *extends* CLASH — never
  write a slide or task implying CLASH is built from scratch.
- **All code examples must be real.** Clone `https://github.com/pawsaw/clash` and verify
  every file path, command, and snippet against the actual repo before referencing it. No
  invented paths.
- **The `hooks/` naming trap:** CLASH has a top-level `hooks/` directory of **React**
  hooks. Claude Code hooks live in `.claude/settings.json`. These must be explicitly
  disambiguated on an early slide (before §6.7 of the build spec), and "hooks" must never
  be used unqualified anywhere in the deck.
- **Branding must be extracted, not invented.** Colors, fonts, and spacing come from
  fetching `https://www.nextacademy.io` and sampling the live stylesheet — never guessed.
  Anything that can't be retrieved becomes a clearly labeled placeholder
  (`slides/public/brand/PLACEHOLDER-<name>.svg`), logged in `slides/BRAND.md` — never
  silently faked.
- **Every external link (§9 of the build spec) must be fetched and confirmed live**
  before it appears in output, with results recorded in `docs/LINK-AUDIT.md`. Links marked
  `[VERIFY]` are known-uncertain and must be resolved by search, not guessed.

## Target repository layout

The build spec (§4) defines the exact layout to produce:

```
README.md, FACILITATOR.md
docs/{LINK-AUDIT.md, SETUP.md}
slides/{slides.md, sections/00-title.md … 09-methodologies-close.md, components/, styles/,
        public/{brand/, diagrams/}, BRAND.md, package.json}
tasks/{README.md, 00-setup.md … 11-headless-ci.md}
```

`slides/sections/*.md` are composed into `slides/slides.md` via Slidev `src:` imports.
Once `slides/package.json` exists, the deck is a normal Slidev project: `npm install`,
`npm run dev`, `npm run build`, `npx slidev export` (must produce `dist/black-belt.pdf`).

## Content structure to implement

The 240-minute agenda (build spec §6 / run-sheet) is the spine of everything — slide
sections, task numbering, and diagram placement all map to it 1:1:

| Time | Block | Ships | Task(s) |
|---|---|---|---|
| 00:00–00:10 | Cold open (naive prompt, watch context drift) | — | — |
| 00:10–00:15 | The map (7 primitives table, slide only) | — | — |
| 00:15–00:50 | Context engineering | `docs/plans/realtime-notifications.md`, rewritten CLAUDE.md/AGENTS.md | 01 |
| 00:50–01:18 | Skills (`clash-feature` skill) | `.claude/skills/clash-feature/SKILL.md` + one feature | 02 |
| 01:18–02:30 | Delegation ladder — subagent → agent team → dynamic workflow → merge (centerpiece) | authorization fixes merged | 03, 04, 05 |
| 02:30–02:40 | Break | — | — |
| 02:40–03:10 | Hooks (anatomy → one built slowly → three fast → frame) | hook set | 06, 07 |
| 03:10–03:38 | MCP and the browser (Playwright MCP tests, DevTools MCP perf fix) | test suite, perf fix | 08, 09 |
| 03:38–03:52 | Letting go (worktrees, headless CI; SDK bridge conceptual only) | CI workflow | 10, 11 |
| 03:52–04:00 | Spec Kit vs BMAD, close | — | — |

Do not compress or expand any block's minutes — the spec calls timing changes a common
failure mode ("the risk is volume, not difficulty").

## Diagrams (G1–G20)

The build spec (§5.3) requires 20 specific, purpose-built diagrams (inline SVG or Vue
components preferred over Mermaid/static images, brand palette only, animated with
`<v-clicks>`). G4 (the seven-primitive toolkit map) is the deck's spine and must reappear
on every section-divider slide with the current row highlighted. Do not treat the diagram
list as optional polish — it's in the acceptance criteria (§10).

## Slide layout types

Four reusable Slidev layouts are required, defined once and reused:

- `layout: concept` — graphic-dominant, ≤3 lines of text.
- `layout: code-live` — a **skeleton only** (real file path, real surrounding CLASH code,
  `// ⟵ LIVE` markers). Never a filled-in solution — the full working solution goes only
  in the presenter note (`<!-- -->`), for the trainer's eyes.
- `layout: task` — task number, one-sentence goal, time-box, QR code + short URL to the
  task's markdown file (generated at build time into `slides/public/diagrams/qr/`),
  one-line success criterion.
- `layout: section` — divider carrying G4 with the current primitive row highlighted.

## Task file template

Every `tasks/NN-*.md` follows the exact structure in build spec §8.1: header with block/
time-box/mode/reset-branch, then Goal, Why this matters, Starting point, Steps, Prompts
used (verbatim), Success criteria (checkboxes), If you fall behind (`git checkout
wk/NN-start`), Going further, References. Do not deviate from this structure across tasks.

## Acceptance criteria

Build spec §10 is the authoritative checklist before reporting the work done — it covers
the Slidev build/export succeeding, timings summing to exactly 240 minutes, all 20
diagrams present and animated, every `code-live` slide containing a skeleton (not a
solution), every `task` slide's QR code resolving, all 12 task files present, every
README link resolving, every CLASH-referencing snippet verified against a real clone, and
the link audit / brand doc being complete. Re-check against this list, not against
intuition, before calling any phase of the build finished.
