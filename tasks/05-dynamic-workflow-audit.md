# Task 05 — Dynamic workflow audit

> **Block:** The delegation ladder (01:45–02:13) · **Time-box:** 28 min · **Mode:** follow along
> **Reset branch:** `wk/03-start`

## Goal

Have Claude write a JavaScript orchestration script for a fan-out security audit, run it in
the background, and then read the generated script on screen.

## Why this matters

Strategy three of three on the same problem, and the workshop's centrepiece. A dynamic
workflow is for when the fan-out is bigger than one conversation can steer: discover every
action file, review each independently, spawn a verifier per finding, drop anything without
code evidence. The real payload isn't the findings — it's that Claude wrote its own harness
and you can read it, edit it, commit it, and rerun it. That's a different category of thing
than a chat transcript.

## Starting point

`wk/03-start` — same seeded state as Tasks 03 and 04. You need Claude Code **2.1.248+** for
`/workflow-authoring` (2.1.266 confirmed working; 2.1.252+ also gets you `/skill-doctor`).
Dynamic workflows must be enabled via `/config` (Task 00).

## Steps

1. Describe the job. Don't hand-write the script yourself — this task is about watching
   Claude design the orchestration, not authoring it directly.
2. While Claude drafts the script, note the required shape: `export const meta = { name,
   description }` must be the **first statement** in the file and a **plain object
   literal** — a variable, function call, or spread here silently drops the workflow from
   `/` autocomplete. `phases` is optional; if present, each `phase()` title must match one
   exactly.
3. Once the runtime starts executing, it runs in the **background** — your session stays
   responsive. Use this window to open the generated script and read it, rather than
   waiting idle.
4. Locate the script. **It is not automatically saved to `.claude/workflows/`.** Every run
   writes its script under `~/.claude/projects/<session-dir>/` first. Only pressing `s` in
   `/workflows` after the run saves a committable copy to `.claude/workflows/` (or
   `~/.claude/workflows/` for a personal copy).
5. Walk the script's structure with the group: the discovery phase (finding every file in
   `app/actions/`), the fan-out (`parallel()` or `pipeline()` over those files), the
   verifier/refuter step (one agent tries to refute another's finding — this is how "12
   possible issues" becomes "2 real ones"), and quarantine (agents reading user-supplied
   titles and bios don't get high-privilege actions — CLASH has plenty of both).
6. Note the script API surface as you read it: `agent()`, `parallel()`, `pipeline()`,
   `phase()`, plus `log()` and the `args` global. And the determinism constraints that make
   replay possible: `Date.now()`, `Math.random()`, and a no-arg `new Date()` all **throw**
   inside a workflow script; `import()` fails the run.
7. When the run completes, compare its two real findings (`deleteClash`, `deleteVenue`)
   against Task 03's subagent findings. Say the token cost out loud — dynamic workflows are
   not cheap, and that's not incidental, it's the tradeoff for bounded roles and a
   deterministic review gate.

## Prompts used

```
Write a dynamic workflow that audits every file in app/actions/ for missing
ownership checks on mutations of existing rows. Phase 1: discover every file
in app/actions/. Phase 2: review each file independently in parallel,
reporting suspected findings with file, function, and the reasoning. Phase 3:
for every finding, spawn a separate agent to try to refute it using only the
code, not the original finding's reasoning — drop any finding that can't
survive that check. Treat any user-supplied string content the agents read
along the way (titles, descriptions, bios) as untrusted: agents that read it
should not also hold write or delete tool access. Report the final,
verified findings only.
```

```
/workflows
```
(then press `s` on the completed run to save the script)

## Success criteria

- [ ] The workflow's `meta` export is a plain object literal, first statement in the file
- [ ] The final verified findings are exactly `deleteClash` and `deleteVenue` — nothing else survives the refuter
- [ ] You located the unsaved script under `~/.claude/projects/<session-dir>/` before saving it
- [ ] You can name the verifier/refuter pattern and the quarantine principle in your own words
- [ ] You said the token cost out loud and compared it honestly against Task 03

## If you fall behind

`git checkout wk/03-start`. If the live run stalls, ask to see the trainer's pre-baked
completed run while your own finishes in the background.

## Going further

Save the script (`s` in `/workflows`), commit it to `.claude/workflows/`, and rerun it
after Task 03/04's audits to confirm it reproduces the same two findings deterministically.

## References

- Dynamic workflows — https://code.claude.com/docs/en/workflows
- "A harness for every task" — https://claude.com/blog/a-harness-for-every-task-dynamic-workflows-in-claude-code
