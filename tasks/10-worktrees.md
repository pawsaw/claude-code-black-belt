# Task 10 — Worktrees

> **Block:** Letting go (03:38–03:43) · **Time-box:** 5 min · **Mode:** follow along
> **Reset branch:** `wk/06-start`

## Goal

Run two agents on the same repository at the same time without them colliding, using
`claude --worktree`.

## Why this matters

This is the one thing from today most people will actually use tomorrow morning. Every
orchestration strategy so far shared one working tree; worktrees let you run several agents
on genuinely separate branches of the same repo in parallel, with no risk of one agent's
half-finished edit corrupting another's.

## Starting point

`wk/06-start` — the finished state of the delegation-ladder and hooks blocks, nothing new to
undo from earlier tasks.

## Steps

1. Start a worktree-isolated session with a name:
   ```bash
   claude --worktree avatar-followup
   ```
   (`-w` is the short flag.) This creates an isolated copy of the repo under
   `.claude/worktrees/avatar-followup/` on a new branch `worktree-avatar-followup`, and
   starts Claude Code inside it.
2. In a second terminal, start another worktree session for unrelated work — e.g. picking up
   the going-further extension from Task 09.
3. Make an edit in each session and confirm neither can see or interfere with the other's
   uncommitted changes — they're on different branches in different directories.
4. Note two related mechanisms without necessarily using them live: `isolation: worktree` in
   a subagent's frontmatter runs that subagent in its own worktree automatically, and the
   `EnterWorktree`/`ExitWorktree` tools let an agent manage this itself mid-session.

## Prompts used

```
claude --worktree avatar-followup
```

```
(inside that session) Pick up the avatar CDN sketch from Task 09's going-further
section and start roughing it out — don't worry about the main working tree.
```

## Success criteria

- [ ] `claude --worktree <name>` created an isolated directory and branch
- [ ] Two sessions ran in parallel without touching each other's uncommitted work
- [ ] You can name where the worktree lives (`.claude/worktrees/<name>/`) and its branch name (`worktree-<name>`)
- [ ] You know `isolation: worktree` exists as a subagent frontmatter option, even if you didn't use it here

## If you fall behind

`git checkout wk/06-start`

## Going further

Try `claude --worktree "#<pr-number>"` against an open pull request reference instead of a
plain name, and see how the worktree's starting point differs.

## References

- Worktrees — https://code.claude.com/docs/en/worktrees
