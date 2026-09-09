# Task 06 — The typecheck hook

> **Block:** Hooks (02:45–02:57) · **Time-box:** 12 min · **Mode:** follow along
> **Reset branch:** `wk/04-start`

## Goal

Build a `PostToolUse` hook that runs `npx tsc --noEmit` after every edit to `app/actions/*`,
and watch the agent receive and fix a failure it didn't know was coming.

## Why this matters

This is the whole hook model, built slowly instead of shown as a slide: an **event**, a
**matcher**, and an **exit code**. Everything else is detail. The moment worth remembering
today is the agent reacting to a rule it never agreed to — a hook is law, not a suggestion in
`CLAUDE.md` that a busy agent might drift past.

## Starting point

`wk/04-start` — CLASH with the delegation-ladder auth fix merged, the Task 01 `CLAUDE.md`,
and the Task 02 `clash-feature` skill in place. No `.claude/settings.json` yet.

## Steps

1. Name the three things a hook needs: the **event** (`PostToolUse`, one of 33 available
   events), the **matcher** (which tool it fires on), and the **exit code** (what happens
   next).
2. Get it wrong once, on purpose. Write the matcher as a path glob, the way it looks like it
   should work:
   ```json
   { "hooks": { "PostToolUse": [
     { "matcher": "app/actions/*.ts", "hooks": [ { "type": "command",
       "command": "npx tsc --noEmit" } ] }
   ] } }
   ```
   Edit a file under `app/actions/` and watch: **nothing fires.** `matcher` matches the
   **tool name** (`Edit`, `Write`, `Bash`, …), not a path — a path glob there is parsed as an
   unanchored JS regex against the tool name and will never match.
3. Fix it. Match the tool, and scope the path with the sibling `if` field:
   ```json
   { "hooks": { "PostToolUse": [
     { "matcher": "Edit|Write", "hooks": [ { "type": "command",
       "if": "Edit(app/actions/**) or Write(app/actions/**)",
       "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/typecheck-actions.sh",
       "timeout": 60 } ] }
   ] } }
   ```
4. Write `.claude/hooks/typecheck-actions.sh` to run `npx tsc --noEmit` and exit accordingly.
   The exit code is the only thing that matters for blocking: **only exit code 2 blocks** —
   any other non-zero code is non-blocking and just gets logged. On `PostToolUse`, plain
   stdout at exit 0 goes to the debug log only, not to the agent; what reaches Claude on a
   block is **stderr at exit 2**.
5. Introduce a real bug into a Server Action — a type mismatch is enough — and let the agent
   edit the file. Watch the hook fire, watch `tsc` fail, watch the agent receive the error and
   fix its own code without you typing the fix.

## Prompts used

```
Set up a PostToolUse hook in .claude/settings.json that runs npx tsc --noEmit
whenever a file under app/actions/ is edited or written. If typecheck fails,
the hook should block with exit code 2 and put the tsc output on stderr so I
see it as the reason. Use the "if" field to scope to app/actions/**, not the
matcher — the matcher only matches the tool name.
```

```
Now introduce a type error into app/actions/venues.ts on purpose — for
example, pass a number where updateVenue expects a string — and make the
edit through Claude Code so the hook fires. Then fix it.
```

## Success criteria

- [ ] You reproduced the broken path-glob-in-`matcher` version and confirmed it silently doesn't fire
- [ ] The working hook uses `"matcher": "Edit|Write"` with a sibling `"if"` field for path scoping
- [ ] The hook script exits 2 on typecheck failure and 0 on success
- [ ] You watched the agent receive a blocked edit and self-correct
- [ ] You can state that only exit 2 blocks, not "any non-zero code"

## If you fall behind

`git checkout wk/04-start`

## Going further

Compare your hook against `.claude/settings.json` and `.claude/hooks/typecheck-actions.sh` on
`wk/05-start`, or the source copies at `workshop-artifacts/04-hooks/` in this workshop
repository.

## References

- Hooks guide — https://code.claude.com/docs/en/hooks-guide
- Hooks reference — https://code.claude.com/docs/en/hooks
