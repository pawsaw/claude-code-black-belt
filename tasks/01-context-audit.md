# Task 01 — Context audit and CLAUDE.md authoring

> **Block:** Context engineering (00:15–00:50) · **Time-box:** 35 min · **Mode:** follow along
> **Reset branch:** `wk/01-start`

## Goal

Author a `CLAUDE.md` from scratch around CLASH's real architectural invariants, and produce
a reviewed plan for a real feature before writing any code.

## Why this matters

The workshop's throughline is that context is a resource you engineer, not a dumping ground.
CLASH's actual `CLAUDE.md` is 11 bytes — just `@AGENTS.md` — and `AGENTS.md` is 327 bytes of
generic, auto-injected Next.js boilerplate with nothing project-specific in it. There is
nothing to "trim." The real exercise, and the harder one, is writing a *good* context file
from nothing, grounded in invariants you can point to in the actual code rather than
guessing at what an agent might need.

## Starting point

`wk/01-start` — CLASH at baseline. `CLAUDE.md` contains only `@AGENTS.md`; `AGENTS.md`
contains only the generic Next.js warning block. Nothing else.

## Steps

1. Open `/context` and read the breakdown aloud. This is the instrument you'll come back to
   after every major step today, not a one-off curiosity.
2. Open `CLAUDE.md` and `AGENTS.md`. Confirm out loud that there is nothing project-specific
   in either — this is a from-scratch authoring exercise, not an audit-and-shrink one.
3. Using `@`-references (not grep-and-guess), point Claude at the real invariants:
   `app/actions/clashes.ts`, `lib/data/clashes.ts`, `lib/validation.ts`,
   `app/(app)/layout.tsx`, `prisma/schema.prisma`. Ask it to draft a `CLAUDE.md` capturing
   what it finds.
4. Review and correct the draft against these six invariants, which must all appear:
   - Reads go through `lib/data/*` — RSC pages never call Prisma directly.
   - Writes go through `app/actions/*`, and **every action re-establishes its own
     authorization** — the `requireUser()` guard in `app/(app)/layout.tsx` protects the
     *page*, not the action, because a Server Action compiles to a public POST endpoint
     with a generated ID.
   - `lib/validation.ts` is the single source of truth for Zod schemas.
   - Next 16: `params` and `searchParams` are Promises — always `await` them.
   - Prisma client is generated to `lib/generated/prisma`, not `@prisma/client`.
   - Status fields (`Participation.status`, `Notification.type`) are documented strings, not
     enums — SQLite has no enum support — with allowed values in `lib/constants.ts`.
5. Compare against `/context` again. The file should be small and dense, not a transcript of
   everything Claude read to write it.
6. Switch into **Plan Mode** and describe the next feature: real-time notifications for
   CLASH (currently notifications only load on render). Let Claude produce a plan without
   touching any files.
7. Review the plan together, then save it: `docs/plans/realtime-notifications.md`.
8. Run `/skill-doctor` (needs Claude Code 2.1.252+). Look at `.agents/skills/` — CLASH
   ships nine vendored skills. Two of them, `react-best-practices` and
   `vercel-react-best-practices`, are near-duplicate ~100KB rule sets. This is the real
   "what does unmanaged context cost you" moment for today — a live, findable case of
   redundant context loaded on every session.

## Prompts used

```
Read app/actions/clashes.ts, lib/data/clashes.ts, lib/validation.ts,
app/(app)/layout.tsx, and prisma/schema.prisma. Draft a CLAUDE.md for this
repository covering: where reads happen, where writes happen and how they're
authorized, where Zod schemas live, how Next 16 handles params/searchParams,
where the generated Prisma client lives, and how status fields are modeled.
Keep it dense — invariants, not a tour of the codebase.
```

```
I want to add real-time notifications to CLASH — currently notifications only
load on render via getNotifications/getUnreadCount in lib/data/notifications.ts.
Don't write any code yet. Propose an approach and the files it touches.
```

```
/skill-doctor
```

## Success criteria

- [ ] `CLAUDE.md` no longer just contains `@AGENTS.md` — it states the six invariants above in your own words
- [ ] The authorization invariant explicitly says every Server Action re-checks ownership itself
- [ ] `docs/plans/realtime-notifications.md` exists and was reviewed in Plan Mode before any code was touched
- [ ] `/skill-doctor` ran and you can name at least one skill worth pruning

## If you fall behind

`git checkout wk/01-start`

## Going further

Compare your `CLAUDE.md` against `workshop-artifacts/02-context/CLAUDE.md` in this
workshop repository — the version produced during rehearsal. Yours doesn't need to match it
exactly; it needs to be grounded in the same six invariants.

## References

- Plan mode / permission modes — https://code.claude.com/docs/en/permission-modes
- Skills — https://code.claude.com/docs/en/skills
- Settings reference — https://code.claude.com/docs/en/settings-reference
