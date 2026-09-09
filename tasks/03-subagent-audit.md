# Task 03 — Subagent security audit

> **Block:** The delegation ladder (01:23–01:35) · **Time-box:** 12 min · **Mode:** follow along
> **Reset branch:** `wk/03-start`

## Goal

Run a single, isolated `security-auditor` subagent against `app/actions/` and watch the main
thread's context barely move.

## Why this matters

This is strategy one of three on the same problem. The point of a subagent isn't more
intelligence — it's an isolated context window for noisy, exploratory work, so your main
thread's `/context` stays close to where it started. Watching that *not* happen is the
argument, not a slide about it.

## Starting point

`wk/03-start`. **This branch deliberately seeds a real vulnerability for this exercise**:
the ownership check (`creatorId !== user.id`) has been removed from `deleteClash`
(`app/actions/clashes.ts`) and `deleteVenue` (`app/actions/venues.ts`). Every other exported
action in `app/actions/` is already correctly guarded — this is not a broad sweep that finds
many bugs, it's two specific ones to locate precisely. (This flaw does not exist in CLASH's
real, published codebase — it's seeded for this workshop; see
`docs/SPEC-DEVIATIONS.md` item 1 if you're curious why.)

Before running any agent, do the 5-minute setup this task assumes already happened live:
open `app/(app)/layout.tsx`, find `requireUser()`, then open any file in `app/actions/`.
Confirm for yourself that the layout guard never runs when an action is called directly.

## Steps

1. Note your current `/context` reading.
2. Launch a subagent with a narrow, falsifiable brief — not "find security bugs" but the
   specific property to check.
3. Let it read every file in `app/actions/` and report back file, function name, and verdict
   per exported action.
4. Read `/context` again. It should have moved only slightly — the subagent's file reads
   happened in its own window, not yours.
5. Discuss fork-by-default: in Claude Code 2.1, fork mode is **on by default** in interactive
   sessions (off under `-p` and the Agent SDK). A fork inherits the entire parent
   conversation, tools, model, and the parent's prompt-cache TTL — cheaper than a cold
   subagent when shared context is genuinely needed, but it also means a fork's context isn't
   as isolated as a fresh subagent's. This audit works either way, but know which one you're
   invoking and why.
6. Cross-check the two findings against `workshop-artifacts/03-delegation-ladder/AUTH-FIX.md`
   in this workshop repository — the answer key.

## Prompts used

```
Launch a subagent named security-auditor. Give it this brief: for every
exported Server Action in app/actions/, confirm that any mutation of an
EXISTING row is preceded by a check that the current user owns or is
otherwise authorized for that row (not just authenticated). Report per
action: file, function name, and PASS or FAIL with the exact line if it
fails. Do not report on actions that only ever affect the caller's own row
by construction (e.g. a query already scoped by userId) — those are safe
by design, not a finding.
```

## Success criteria

- [ ] The subagent correctly flags `deleteClash` and `deleteVenue` as FAIL
- [ ] The subagent correctly does NOT flag `updateClash`, `updateVenue`, `joinClash`, `reviewRequest`, `markNotificationRead`, `updateProfile`, or `updateAvatar` — these are already safe
- [ ] Main-thread `/context` moved only slightly compared to before the subagent ran
- [ ] You can state which mode you used (fork vs. fresh subagent) and what that traded off

## If you fall behind

`git checkout wk/03-start`

## Going further

Re-run the same audit as a fresh (non-forked) subagent and compare `/context` deltas and
wall-clock between the two modes.

## References

- Subagents — https://code.claude.com/docs/en/sub-agents
