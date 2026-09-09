---
layout: section
heading: "Context engineering"
current: context
---

<template #map>
  <ToolkitMap current="context" />
</template>

<!--
00:15–00:50, 35 min. Divider slide — the toolkit map from 00:10 comes back with the
"Context" row highlighted. Say: "we start here because it's the row that's always in
play — every other primitive works around this constraint." This is the first of eight
re-shows of this map across the day; keep the beat short, under 20 seconds, and move on.
-->

---
layout: concept
heading: "/context is an instrument, not a curiosity"
lines:
  - "Read the breakdown aloud — system prompt, CLAUDE.md, skills, tool results, conversation"
  - "You'll come back to this after every major step today"
---

<G02ContextBudget />

<!--
Run `/context` right now on the session from the cold open (or a fresh one if you moved
on). Read the breakdown aloud line by line — don't summarize it, let the room hear the
actual numbers. This diagram is the same one from the cold open; showing it again here is
deliberate — it's the instrument, not a one-off gag. Say explicitly: "we're going to come
back to this same command after every major step for the rest of the day."
-->

---
layout: concept
heading: "Budget, or dumping ground?"
lines:
  - "CLAUDE.md is 11 bytes — just @AGENTS.md"
  - "AGENTS.md is 327 bytes of generic, auto-injected Next.js boilerplate"
  - "Nothing here is project-specific. There's nothing to trim."
---

<div class="na-card p-6 font-mono text-sm" style="color: var(--na-fg-muted)">
  <div class="mb-1" style="color: var(--na-fg)">CLAUDE.md</div>
  <div class="mb-4">@AGENTS.md</div>
  <div class="mb-1" style="color: var(--na-fg)">AGENTS.md</div>
  <div>&lt;!-- BEGIN:nextjs-agent-rules --&gt;<br/># This is NOT the Next.js you know<br/><br/>This version has breaking changes — APIs, conventions, and file<br/>structure may all differ from your training data. Read the relevant<br/>guide in `node_modules/next/dist/docs/` before writing any code.<br/>&lt;!-- END:nextjs-agent-rules --&gt;</div>
</div>

<!--
Open both files live and let the room see this is the actual, complete content — not an
excerpt. ⚠ This is a deliberate reframe from earlier versions of this workshop, which
assumed there'd be a bloated CLAUDE.md to audit and halve. There isn't one. Say so
plainly: "there is nothing to trim here — today's exercise is writing a good context file
from nothing, grounded in real invariants, which is honestly the harder and more useful
skill anyway." Don't apologize for the codebase being clean; treat it as the more
realistic scenario — most repos you'll touch don't have a villain-sized CLAUDE.md waiting
to be caught, they have this: nothing, or nearly nothing.
-->

---
layout: concept
heading: "The shape underneath the invariants"
---

<G13ClashArchitecture />

<!--
Before writing a single invariant, show the room the shape they're encoding. Reads: Browser
→ RSC page → a helper in lib/data/*.ts → Prisma Client (lib/generated/prisma) → SQLite. Writes:
Client → a Server Action in app/actions/*.ts → requireUser() + an ownership check → Prisma →
SQLite → revalidatePath() closing the loop back to the page. Point at the auth-check node
specifically — it's highlighted on purpose. This is the exact picture block 5 will spend 72
minutes on when that node turns out to be missing on two actions. Plant it here, quietly.
-->

---
layout: code-live
heading: "Write CLAUDE.md around the real invariants"
filePath: "CLAUDE.md"
success: "Every invariant traces to a real file or behavior in CLASH, not a guess"
---

```md
# CLASH — agent instructions

A geospatial social platform for spontaneous meetups across Berlin.
Next.js 16 (App Router) · React 19 · Prisma 7 + SQLite · Tailwind v4 · shadcn/ui · Leaflet.

@AGENTS.md

## Architecture invariants

<!-- ⟵ LIVE: use @-references to app/actions/clashes.ts, lib/data/clashes.ts,
     lib/validation.ts, app/(app)/layout.tsx, and prisma/schema.prisma —
     then draft the six invariants from what Claude actually finds there. -->
```

<!--
FULL WORKING SOLUTION (trainer only — do not reveal before the room writes their own):

# CLASH — agent instructions

A geospatial social platform for spontaneous meetups across Berlin.
Next.js 16 (App Router) · React 19 · Prisma 7 + SQLite · Tailwind v4 · shadcn/ui · Leaflet.

@AGENTS.md

## Architecture invariants

These are the rules that actually prevent bugs in this codebase. Follow them.

**Reads go in `lib/data/*`.** RSC pages call a helper from `lib/data/` — they never call
Prisma directly. Each helper owns its own `select`/`include` shape and exports the
inferred type alongside it.

**Writes go in `app/actions/*`.** Every mutation is a Server Action marked `"use server"`.

**Every Server Action re-establishes authorization itself.** A Server Action compiles to
a public POST endpoint with a generated ID. The `requireUser()` guard in
`app/(app)/layout.tsx` protects the *page*, not the action. So: `await requireUser()` at
the top of every action, and an explicit ownership check before any mutation of an
existing row (`if (existing.creatorId !== user.id) { ... }`). Zod validates shape, not
permission.

**`lib/validation.ts` is the single source of truth for Zod schemas.**

**Prisma client is generated to `lib/generated/prisma`** — not `@prisma/client`.

**Status fields are documented strings, not enums.** SQLite has no enum support. Allowed
values live in `lib/constants.ts`.

**Next 16: `params` and `searchParams` are Promises.** Always `await` them.

Talking points while building this live:
- Point at the exact line in `app/actions/clashes.ts` that shows the ownership check —
  don't just assert it exists, show `if (clash.creatorId !== user.id)` on screen. This is
  the invariant that block 5 will spend 72 minutes on; planting it here is deliberate.
  Full reference at workshop-artifacts/02-context/CLAUDE.md in the workshop repo.
- If the room drafts a CLAUDE.md that's mostly prose/vibes rather than falsifiable rules,
  push back live: "could a hook enforce this? If not, is it actually an invariant, or is
  it a preference?" — this seeds the skills-vs-hooks framing from block 6 without naming it.
-->

---
layout: concept
heading: "@-references vs. grep-and-guess"
---

<G03CarelessVsEngineered />

<!--
This is the same shape of task as the cold open, side by side. Left: what just happened
at 00:00 — Claude reading 40 files it found by grepping around, guessing at a model that
doesn't exist yet. Right: what @-references and Plan Mode buy you — you tell it exactly
where to look, and it doesn't have to guess. Say it plainly: "the difference between these
two columns is not a smarter model. It's the same model, pointed on purpose."
-->

---
layout: concept
heading: "Plan Mode: review before a byte moves"
lines:
  - "Task: real-time notifications for CLASH"
  - "Claude proposes an approach — you review it before anything is touched"
  - "Ships: docs/plans/realtime-notifications.md"
---

<!--
Switch into Plan Mode live and describe the next feature: "I want to add real-time
notifications — currently notifications only load on render, via getNotifications and
getUnreadCount in lib/data/notifications.ts. Don't write any code yet. Propose an
approach and the files it touches." Let it produce a plan with zero file writes. Review
it together, out loud, then save it to docs/plans/realtime-notifications.md. Note for
anyone who goes looking later: plan mode doesn't have its own doc page — it's documented
as one of the permission modes at code.claude.com/docs/en/permission-modes.
-->

---
layout: concept
heading: "/skill-doctor: what's loaded, and what it costs"
lines:
  - "Needs Claude Code 2.1.252+"
  - "CLASH ships nine vendored skills in .agents/skills/"
  - "Two of them are ~100KB near-duplicates, loaded every session"
---

<!--
Run /skill-doctor live. This is where the "wasted context" narrative actually lives now —
not in a bloated CLAUDE.md (there wasn't one), but here: .agents/skills/react-best-practices
and .agents/skills/vercel-react-best-practices are two real, vendored, near-duplicate rule
sets, each roughly 100KB, both loaded on every session whether or not either is ever used.
Show the room the two directories side by side if you have a second to spare — the
overlap is obvious on sight. This is a genuine, checkable "what does unmanaged context
cost you" moment, and it's better than a scripted one because it's real.
-->

---
layout: task
number: "01"
heading: "Context audit & CLAUDE.md authoring"
goal: "Author a CLAUDE.md from scratch around CLASH's real architectural invariants, and produce a reviewed plan for real-time notifications before writing any code."
timebox: "35 min"
mode: "follow along"
qrSlug: "01-context-audit"
repoUrl: "github.com/pawsaw/claude-code-black-belt/tasks/01-context-audit.md"
success: "CLAUDE.md states the six invariants in your own words, and docs/plans/realtime-notifications.md was reviewed in Plan Mode before any code was touched"
---

<!--
This is the task-01 recap slide. Point at the QR code, say the branch: wk/01-start if
anyone needs to catch up. Everything on this slide is pulled directly from
tasks/01-context-audit.md — don't paraphrase the success criteria differently here than
what's written there, participants will compare the two later.
-->
