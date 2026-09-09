# Task 04 — Agent team audit (watch only)

> **Block:** The delegation ladder (01:35–01:45) · **Time-box:** 10 min · **Mode:** watch only
> **Reset branch:** `wk/03-start`

## Goal

Watch a lead agent supervise four domain-specific peer auditors, and see two peers reach
different conclusions about the same file before the lead reconciles them.

## Why this matters

Strategy two of three on the same problem. A single subagent is enough when the work is
noisy but self-contained. Agent teams exist for when workers need to talk to each other over
time — and the moment that actually teaches that is watching two peers disagree and get
reconciled, not a slide describing it. This segment is explicitly "hands off keyboards" —
you watch, you don't drive.

## Starting point

`wk/03-start` — same starting state as Task 03; this block runs on the same seeded branch,
it just uses a different orchestration strategy on the same underlying problem.

**Agent teams are experimental and off by default.** They require
`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in `~/.claude/settings.json`'s `env` block (set
during Task 00 / pre-flight). If you didn't set this, that's fine for this task — it's
watch-only regardless.

## Steps

1. The trainer names one auditor per domain: clashes, venues, participations, profile.
2. Teammates message each other **by name**, not by `@`-mention — teams use the
   `SendMessage` tool addressed to a teammate's name, backed by JSON mailboxes under
   `~/.claude/teams/<team>/inboxes/`. Watch for a message actually being sent between peers.
3. Watch for two peers reaching different conclusions about the same file — most likely
   around `app/actions/venues.ts`, since `deleteVenue` is one of the two seeded findings and
   its neighbor `updateVenue` is correctly guarded, which is exactly the kind of near-miss
   that produces disagreement.
4. Watch the lead reconcile the disagreement — this is the entire argument for teams over a
   single subagent, in one screen.
5. Note: the in-session agent panel below the prompt input is where you watch team activity
   live. `claude agents` is a **different** thing — it's the view for parallel background
   sessions, not a team dashboard. Don't confuse the two commands.

## Prompts used

```
Set up an agent team to audit app/actions/ for missing ownership checks.
Assign one teammate per domain: clashes, venues, participations, profile.
Each teammate should independently report PASS/FAIL per exported action in
their domain, citing the exact check (or its absence). If two teammates'
findings touch the same file, have them compare notes before the lead
finalizes the report.
```

## Success criteria

- [ ] You can name which four domains were assigned
- [ ] You observed at least one message sent between teammates by name (not by `@`-mention — that syntax doesn't exist between peers)
- [ ] You watched a disagreement get reconciled by the lead, or can describe why one didn't surface this run
- [ ] You can state the difference between the in-session team panel and `claude agents` (background sessions view)

## If you fall behind

`git checkout wk/03-start` — nothing to rebuild; this task doesn't change repository state.

## Going further

At home, with `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` set, re-run this audit yourself and
try deliberately assigning overlapping domains to force a disagreement, rather than waiting
for one to occur naturally.

## References

- Agent teams — https://code.claude.com/docs/en/agent-teams
- CLI reference (background sessions) — https://code.claude.com/docs/en/cli-reference
