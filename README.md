<p align="center">
  <img src="slides/public/brand/nalogo.svg" width="56" alt="nextacademy.io" />
</p>

<h1 align="center">Claude Code: Black Belt</h1>
<p align="center"><strong>Learn What's Next. <em>Today.</em></strong></p>

<p align="center">
  Pawel Sawicki · nextacademy.io · React Day Berlin 2026<br/>
  4 hours · code-along · no silent phases
</p>

---

> **Delivered today, 2026-09-09, 15:00–19:00 CEST**, remote via Zoom, React Day Berlin 2026.
> [Workshop listing on GitNation](https://gitnation.com/contents/claude-code-black-belt-3)

## Abstract

Stop prompting. Start orchestrating. In four intense hours you'll go from using Claude Code
like a faster autocomplete to commanding it like a senior engineer commands a team:
engineering its context, deploying fleets of subagents, locking it down with hooks, and
turning it loose on work that runs without you.

Every Claude Code user hits a ceiling where the easy wins run out. The agent handles small
stuff beautifully, then loses the thread on anything real. The difference between that
ceiling and real mastery isn't better prompts. It's control. This workshop is about control.

*(Full abstract: [GitNation listing](https://gitnation.com/contents/claude-code-black-belt-3).)*

## Who this is for

Engineers, tech leads, and architects who use Claude Code **daily** but are **not experts**
in it. This is an advanced session — we move fast and start in the deep end.

**Assumed known:** `CLAUDE.md`, plan mode, roughly what a subagent is.
**Assumed *not* known:** writing a hook, authoring a Skill, dynamic workflows. If any of
those are new to you, you're exactly the intended audience.

## Setup

Full pre-flight, with troubleshooting: **[`docs/SETUP.md`](docs/SETUP.md)**. Do this before
the session — conference wifi plus `npm install` plus MCP downloads will eat your first
fifteen minutes otherwise.

```bash
git clone https://github.com/pawsaw/clash
cd clash
git checkout wk/00-start
npm install
cat > .env <<'EOF'
DATABASE_URL="file:./dev.db"
SESSION_SECRET="black-belt-workshop-secret"
EOF
npm run db:migrate
npm run db:seed
npm run dev          # confirm http://localhost:3000 loads
claude --version     # need 2.1.252+
```

> **Two settings people forget, and both silently break a live block if skipped:**
> 1. `/config` → turn **Dynamic workflows** **ON**. Off by default on Pro — the 72-minute
>    delegation-ladder block depends on it.
> 2. Set `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in `~/.claude/settings.json`'s `env` block.
>    Agent teams are experimental and off by default — without this, the 01:35 team demo
>    silently spawns ordinary subagents instead of a team, and the whole point of that segment
>    (two peers disagreeing, the lead reconciling) never happens.

Seeded logins — 8 users, all password `test` — default to `anna.schmidt@example.com`.

### About the `wk/*` branches

Everything in this workshop happens on prepared branches of `pawsaw/clash`, **never on
`main`** — `wk/00-start` through `wk/07-start`. They are both the workshop's starting states
*and* your catch-up mechanism: fall behind, `git checkout wk/NN-start`, rejoin at the next
block boundary. See the [task index](#task-index) below for which branch backs which task,
and [`docs/SPEC-DEVIATIONS.md`](docs/SPEC-DEVIATIONS.md) for exactly what each branch changes
relative to upstream `main` and why.

> **On the authorization audit specifically:** upstream CLASH's `main` branch has no missing
> authorization checks — all 18 Server Actions are already guarded. The vulnerability the
> delegation-ladder block finds and fixes is **deliberately seeded** on `wk/03-start` for the
> exercise (two actions, `deleteClash` and `deleteVenue`, have their ownership check removed)
> and merged back in from `wk/04-start` onward. It is workshop content, not a real CLASH bug.
> Full diff and proof-of-concept: [`workshop-artifacts/03-delegation-ladder/AUTH-FIX.md`](workshop-artifacts/03-delegation-ladder/AUTH-FIX.md).
> The branches are prepared by [`scripts/prepare-workshop-branches.sh`](scripts/prepare-workshop-branches.sh),
> which never pushes without a separate, explicit step.

## Agenda

| Time | Block | What ships | Task(s) |
|---|---|---|---|
| 00:00–00:10 | Cold open: find the ceiling | — | — |
| 00:10–00:15 | The map | — | — |
| 00:15–00:50 | Context engineering | `docs/plans/realtime-notifications.md`, rewritten `CLAUDE.md` | [01](tasks/01-context-audit.md) |
| 00:50–01:18 | Skills | `.claude/skills/clash-feature/`, one shipped feature | [02](tasks/02-clash-feature-skill.md) |
| 01:18–02:30 | The delegation ladder *(centrepiece)* | authorization audit + merged fix | [03](tasks/03-subagent-audit.md) · [04](tasks/04-agent-team-audit.md) · [05](tasks/05-dynamic-workflow-audit.md) |
| 02:30–02:40 | Break | — | — |
| 02:40–03:10 | Hooks | typecheck / deny / build-gate hook set | [06](tasks/06-typecheck-hook.md) · [07](tasks/07-guardrail-hooks.md) |
| 03:10–03:38 | MCP and the browser | test suite, avatar perf fix | [08](tasks/08-browser-tests.md) · [09](tasks/09-perf-avatars.md) |
| 03:38–03:52 | Letting go | worktree flow, CI audit workflow | [10](tasks/10-worktrees.md) · [11](tasks/11-headless-ci.md) |
| 03:52–04:00 | Spec Kit vs BMAD, close | — | — |

**Total: 240 minutes.**

## Task index

| # | Title | Time-box | Task file | Reset branch |
|---|---|---|---|---|
| 00 | Setup | pre-flight | [`tasks/00-setup.md`](tasks/00-setup.md) | `wk/00-start` |
| 01 | Context audit | 35 min | [`tasks/01-context-audit.md`](tasks/01-context-audit.md) | `wk/01-start` |
| 02 | `clash-feature` skill | 28 min | [`tasks/02-clash-feature-skill.md`](tasks/02-clash-feature-skill.md) | `wk/02-start` |
| 03 | Subagent audit | 12 min | [`tasks/03-subagent-audit.md`](tasks/03-subagent-audit.md) | `wk/03-start` |
| 04 | Agent team audit | 10 min · watch only | [`tasks/04-agent-team-audit.md`](tasks/04-agent-team-audit.md) | `wk/03-start` |
| 05 | Dynamic workflow audit | 28 min | [`tasks/05-dynamic-workflow-audit.md`](tasks/05-dynamic-workflow-audit.md) | `wk/03-start` |
| 06 | Typecheck hook | 12 min | [`tasks/06-typecheck-hook.md`](tasks/06-typecheck-hook.md) | `wk/04-start` |
| 07 | Guardrail hooks | 10 min | [`tasks/07-guardrail-hooks.md`](tasks/07-guardrail-hooks.md) | `wk/04-start` |
| 08 | Browser tests | 14 min | [`tasks/08-browser-tests.md`](tasks/08-browser-tests.md) | `wk/05-start` |
| 09 | Perf: avatars | 14 min | [`tasks/09-perf-avatars.md`](tasks/09-perf-avatars.md) | `wk/05-start` |
| 10 | Worktrees | 5 min | [`tasks/10-worktrees.md`](tasks/10-worktrees.md) | `wk/06-start` |
| 11 | Headless in CI | 5 min | [`tasks/11-headless-ci.md`](tasks/11-headless-ci.md) | `wk/06-start` |

Standalone index, navigable on its own: [`tasks/README.md`](tasks/README.md).

## What you will have built by the end

- A **test suite** for CLASH's join flow, host accept/reject, and notification delivery —
  the suite the README says doesn't exist yet.
- An **authorization audit** across `app/actions/*`, with the real fix merged into the
  codebase (see the callout above on how the audited vulnerability was seeded).
- A **real-time notifications plan** — [`docs/plans/realtime-notifications.md`](docs/plans/realtime-notifications.md)
  — produced with Plan Mode, not yet implemented.
- A **performance fix** for the base64-avatar payload bloating every authenticated request.
- A reusable **Skill** (`clash-feature`) and **hook set** (typecheck, deny rules, build gate)
  that outlive the room.

## Resources

**Claude Code**
- [Docs root](https://code.claude.com/docs/en/) · [Dynamic workflows](https://code.claude.com/docs/en/workflows) · [Subagents](https://code.claude.com/docs/en/sub-agents) · [Agent teams](https://code.claude.com/docs/en/agent-teams) · [Skills](https://code.claude.com/docs/en/skills) · [Commands](https://code.claude.com/docs/en/commands)
- [Hooks guide](https://code.claude.com/docs/en/hooks-guide) · [Hooks reference](https://code.claude.com/docs/en/hooks) · [Permission modes (incl. Plan Mode)](https://code.claude.com/docs/en/permission-modes) · [Settings reference](https://code.claude.com/docs/en/settings-reference)
- [MCP](https://code.claude.com/docs/en/mcp) · [Headless mode](https://code.claude.com/docs/en/headless) · [Worktrees](https://code.claude.com/docs/en/worktrees) · [GitHub Actions](https://code.claude.com/docs/en/github-actions)
- [Introducing dynamic workflows](https://claude.com/blog/introducing-dynamic-workflows-in-claude-code) · [How Anthropic teams use Claude Code](https://claude.com/blog/how-anthropic-teams-use-claude-code)

**Codebase**
- [CLASH](https://github.com/pawsaw/clash) — the app we extend all afternoon

**Browser tooling**
- [Playwright MCP](https://github.com/microsoft/playwright-mcp) · [Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp) · [Agent Browser](https://github.com/vercel-labs/agent-browser) · [Model Context Protocol](https://modelcontextprotocol.io)

**Methodologies**
- [Spec Kit](https://github.com/github/spec-kit) · [BMAD-METHOD](https://github.com/bmad-code-org/BMAD-METHOD)

**Stack referenced by CLASH**
- [Next.js](https://nextjs.org/docs) · [Prisma](https://www.prisma.io/docs) · [shadcn/ui](https://ui.shadcn.com) · [Leaflet](https://leafletjs.com) · [Zod](https://zod.dev)

**Presentation**
- [Slidev](https://sli.dev)

Every URL above was verified live during this repo's build, including several corrections to
the originally planned links (wrong doc paths, a redirected blog post, a renamed GitHub org).
Full detail: [`docs/LINK-AUDIT.md`](docs/LINK-AUDIT.md).

## Licence and attribution

Workshop content — slides, task specs, and documentation in this repository — is licensed
under **[CC BY 4.0](LICENSE)**, attributed to nextacademy.io / Pawel Sawicki. Scripts and
configuration (hooks, the branch-preparation script, build tooling) are licensed under
**[MIT](LICENSE-CODE)**.

This licence covers this repository only. The CLASH codebase (`github.com/pawsaw/clash`)
ships no LICENSE file of its own and is used here under separate arrangement with its author
for workshop purposes — do not assume CC BY 4.0 or MIT applies to it.

© 2026 nextacademy.io. Trainer: Pawel Sawicki.
