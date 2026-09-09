# Task index — Claude Code: Black Belt

Standalone index of every hands-on task in this workshop. Every task is one click away.

For the full workshop entry point (agenda, abstract, setup, resources), see the
[repository README](../README.md). For pre-flight, see [`docs/SETUP.md`](../docs/SETUP.md).

| # | Title | Block | Time-box | Mode | Reset branch |
|---|---|---|---|---|---|
| 00 | [Setup](00-setup.md) | Pre-flight | ~15 min | follow along | `wk/00-start` |
| 01 | [Context audit](01-context-audit.md) | Context engineering | 35 min | follow along | `wk/01-start` |
| 02 | [`clash-feature` skill](02-clash-feature-skill.md) | Skills | 28 min | follow along | `wk/02-start` |
| 03 | [Subagent audit](03-subagent-audit.md) | The delegation ladder | 12 min | follow along | `wk/03-start` |
| 04 | [Agent team audit](04-agent-team-audit.md) | The delegation ladder | 10 min | **watch only** | `wk/03-start` |
| 05 | [Dynamic workflow audit](05-dynamic-workflow-audit.md) | The delegation ladder | 28 min | follow along | `wk/03-start` |
| 06 | [Typecheck hook](06-typecheck-hook.md) | Hooks | 12 min | follow along | `wk/04-start` |
| 07 | [Guardrail hooks](07-guardrail-hooks.md) | Hooks | 10 min | follow along | `wk/05-start` |
| 08 | [Browser tests](08-browser-tests.md) | MCP and the browser | 16 min | follow along | `wk/05-start` |
| 09 | [Perf avatars](09-perf-avatars.md) | MCP and the browser | 12 min | follow along | `wk/05-start` |
| 10 | [Worktrees](10-worktrees.md) | Letting go | 5 min | follow along | `wk/06-start` |
| 11 | [Headless CI](11-headless-ci.md) | Letting go | 5 min | follow along | `wk/06-start` |

## Falling behind?

Each task names its own reset branch. Jump to the start of any block without waiting:

```bash
git checkout wk/04-start      # e.g. rejoin at the hooks block
```

`wk/07-start` is the finished state — the answer key for everything through hooks.

## Answer keys

Rehearsed, working versions of what each block produces live alongside this workshop
repository under `workshop-artifacts/`:

- `workshop-artifacts/02-context/CLAUDE.md` — Task 01
- `workshop-artifacts/03-skills/SKILL.md` — Task 02
- `workshop-artifacts/03-delegation-ladder/AUTH-FIX.md` — Tasks 03–05
- `workshop-artifacts/04-hooks/` — Tasks 06–07
