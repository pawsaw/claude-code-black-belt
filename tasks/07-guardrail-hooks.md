# Task 07 — Three more guardrail hooks

> **Block:** Hooks (02:57–03:07) · **Time-box:** 10 min · **Mode:** follow along
> **Reset branch:** `wk/05-start`

## Goal

Add a `PreToolUse` deny set, a noise-collapsing `PostToolUse` output replacement, and a
`Stop` hook that blocks while the build is failing.

## Why this matters

Task 06 built one hook slowly. These three move fast because the model is already installed
in your head — event, matcher, exit code. What's new here is the range of what a hook can do:
refuse an action outright, rewrite what an agent sees, or refuse to let a turn end at all.

## Starting point

`wk/05-start` — the Task 06 typecheck hook is already installed in `.claude/settings.json`.

## Steps

1. **Deny writes to `prisma/migrations/*`, `rm`, and reads of `.env*`.** These are
   `PreToolUse` hooks with `hookSpecificOutput.permissionDecision: "deny"`, or a plain exit-2
   block with a reason on stderr:
   ```json
   { "matcher": "Edit|Write", "hooks": [ { "type": "command",
     "if": "Edit(prisma/migrations/**) or Write(prisma/migrations/**)",
     "command": "echo 'Denied: migrations are generated, run npm run db:migrate.' >&2; exit 2" } ] }
   ```
   Note: `hard_deny` is a real thing, but it's **not** a `PreToolUse` decision value — decisions
   here are `allow`/`deny`/`ask`. `hard_deny` lives under `settings.autoMode.hard_deny`, a
   different subsystem (auto mode's classifier). Mention it, don't wire it up here.
2. **Collapse noisy `npm run build` output.** `PostToolUse` output replacement now works for
   **all tools**, not just MCP — set `hookSpecificOutput.updatedToolOutput` on exit 0 to
   replace what the agent sees with a summary instead of the full log. Direct callback to
   block 2: this is the same "context is a budget" argument, applied to a hook instead of a
   `CLAUDE.md` rule.
3. **Block `Stop` while the build is failing.** Run `npm run build`; if it fails, exit 2 with
   the tail of the log on stderr so the agent can't end the turn until it's green.

## Prompts used

```
Add PreToolUse hooks that deny: writing under prisma/migrations/, running rm,
and reading any .env* file. Use exit code 2 with a clear reason on stderr for
each.
```

```
Add a PostToolUse hook that replaces the output of npm run build with just
the pass/fail line and error count, using hookSpecificOutput.updatedToolOutput,
so the full build log doesn't land in context on every successful build.
```

```
Add a Stop hook that runs npm run build and blocks (exit 2) if it fails,
putting the last 40 lines of the failure on stderr.
```

## Success criteria

- [ ] Attempting to edit a file under `prisma/migrations/` is denied with a clear reason
- [ ] `rm` is denied
- [ ] Reading `.env` is denied
- [ ] A successful `npm run build` shows collapsed output, not the full log
- [ ] Ending a turn while the build is red is blocked; ending it once the build is green succeeds
- [ ] You can explain why `hard_deny` doesn't belong in this file

## If you fall behind

`git checkout wk/05-start`

## Going further

Compare against `.claude/settings.json` and `.claude/hooks/build-gate.sh` on that branch, or
`workshop-artifacts/04-hooks/` in this workshop repository. At home, look up
`settings.autoMode.hard_deny` and auto mode's default status on your plan.

## References

- Hooks reference — https://code.claude.com/docs/en/hooks
- Permission modes (auto mode) — https://code.claude.com/docs/en/permission-modes
