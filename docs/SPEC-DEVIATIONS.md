# Deviations from the build spec

`input/spec/WORKSHOP-BUILD-SPEC.md` states the curriculum is fixed and not to be redesigned.
Every deviation below is a **factual correction**, not a curriculum change — the timing,
topics, and block structure of §6 are unchanged. Each row exists because research against
the real CLASH repository, the real nextacademy.io site, or the real current Claude Code
docs contradicted something the spec assumed. Full research trails are in this repo's build
history; this file is the durable, human-readable record.

| # | Spec assumption | What's actually true | Resolution |
|---|---|---|---|
| 1 | `app/actions/` contains a Server Action missing an ownership check, for the delegation-ladder audit to find | All 18 exported actions in `pawsaw/clash@main` already carry `creatorId !== user.id` (or an equivalent scoped `where`) checks. There is nothing to find on `main`. | The check is **seeded** — removed from `deleteClash` and `deleteVenue` — on `wk/03-start` via `scripts/prepare-workshop-branches.sh`, and restored on `wk/04-start`. This mirrors the build spec's own risk-register mitigation ("seed one deliberate missing auth check on a workshop branch"). See `workshop-artifacts/03-delegation-ladder/AUTH-FIX.md` for the exact diff and proof-of-concept. |
| 2 | The vulnerable column is `hostId` | CLASH's actual ownership column, on both `Clash` and `Venue`, is `creatorId` | All slides, tasks, and hook examples use `creatorId`. |
| 3 | Block 3 audits and halves CLASH's existing `CLAUDE.md` | CLASH's `CLAUDE.md` is 11 bytes (`@AGENTS.md`); `AGENTS.md` is 327 bytes of generic, auto-injected Next.js boilerplate with nothing project-specific. There is no bloat to halve. | Block 3 is reframed as **authoring from scratch** around the real invariants (reads in `lib/data/*`, writes in `app/actions/*` with their own ownership checks, `lib/validation.ts`, Next 16 async params, `lib/generated/prisma`, string-typed status fields). The "context as a cost" narrative moves to `/skill-doctor` run against `.agents/skills/`, which genuinely does hold two ~100KB near-duplicate skills (`react-best-practices` and `vercel-react-best-practices`). |
| 4 | `hooks/` is described as a meaningful React-hooks layer worth a disambiguation slide | `hooks/` holds exactly one file, `use-mobile.ts` (a shadcn boilerplate hook) | The disambiguation slide still runs (React hooks vs. Claude Code hooks is a real naming collision worth flagging once, early) but describes `hooks/` accurately as a single small file rather than implying a larger layer. |
| 5 | `wk/00-start` … `wk/07-start` reset branches already exist on the CLASH repo | No branches beyond `main` existed before this build | Created by `scripts/prepare-workshop-branches.sh`, run locally against a gitignored reference clone (`.clash-ref/`), reviewed, and pushed to `pawsaw/clash` only after separate, explicit confirmation — never as a silent side effect of this build. |
| 6 | agent-browser is "~90% fewer tokens than Playwright MCP" | Not a claim made anywhere in the agent-browser README or any official Vercel source; only inconsistent third-party blog estimates (82–93%) | The slide states the efficiency point qualitatively (compact accessibility-tree output vs. full MCP tool schemas + DOM dumps) instead of citing an unverifiable number. |
| 7 | BMAD has "12+ personas" | BMAD v6 (current, v6.12.0) ships 5 named agent personas; 12+ is a v4-era figure | Corrected on the methodologies slide and in `README.md`. |
| 8 | Spec Kit is implied lightweight/npm-adjacent, ~lower star count | ~134k stars; it's a Python/`uv` tool (`specify init`), not npm | Corrected, and flagged as a real attendee prerequisite (Python 3.11+, `uv`/`pipx`) if anyone tries it live. |

## Claude Code feature corrections (apply across the deck, not one block)

These aren't spec deviations about CLASH or nextacademy.io — they're corrections to how
current Claude Code actually behaves, found by checking the live docs against the run-sheet's
technical claims. Recorded here because several would have produced a **broken live demo**,
not just a wrong slide.

- **Hooks: only exit code 2 blocks**, not "any non-zero exit." Exit-0 plain stdout on
  `PreToolUse`/`PostToolUse` goes to the debug log only — it never reaches the agent.
- **`matcher` in a hook config matches the tool name, not a file path.** A path glob placed
  directly in `matcher` is parsed as an unanchored JS regex and silently never fires. Path
  scoping requires the sibling `if` field (e.g. `"if": "Edit(app/actions/**)"`). This is now
  used deliberately as the "get it wrong once on purpose" moment in Block 6.
- **`hard_deny` is not a `PreToolUse` decision value** (those are `allow`/`deny`/`ask`). It's
  `settings.autoMode.hard_deny`, part of the separate auto-mode classifier subsystem.
- **Agent teams are experimental and off by default**, requiring
  `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. Without it, the Block 5 team demo silently runs as
  plain subagents and the intended "two peers disagree, the lead reconciles" payoff never
  happens.
- **There is no `@`-mention messaging between agent-team peers.** Teammates address each
  other by name via the `SendMessage` tool, backed by per-agent JSON mailboxes.
  `claude agents` is the view for parallel background sessions, not a team dashboard.
- **Dynamic workflow scripts don't land in `.claude/workflows/` on first run.** Every run's
  script is written under `~/.claude/projects/<session-dir>/` first; a committable copy only
  reaches `.claude/workflows/` after pressing `s` in `/workflows`.
- **Workflow scripts are non-deterministic-unsafe by design**: `Date.now()`, `Math.random()`,
  and a no-arg `new Date()` all throw inside a workflow script (so replay stays deterministic).
- **Version floors matter**: dynamic workflows exist from 2.1.154, but `/workflow-authoring`
  needs 2.1.248+ and `/skill-doctor` needs 2.1.252+. `docs/SETUP.md` states 2.1.252+ as the
  room's floor rather than the spec's original 2.1.154.
- **The GitHub Action for headless CI is `anthropics/claude-code-action@v1`**, configured via
  `prompt` + `claude_args` inputs — not a hand-written `claude -p` line in the workflow YAML.
  `@beta` is the legacy, deprecated form.

## What was not changed

The 240-minute structure, the ten section headings, the block order, the four required
`layout:` types, and the 20 required diagrams (G1–G20) are all unchanged from §6/§5.3 of the
build spec. One structural addition was necessary and is noted rather than hidden: this
repo's `slides/` directory includes a `layouts/` folder (alongside the spec's listed
`components/`, `styles/`, `public/`) because Slidev's four required custom `layout:` values
can only be implemented as files under `slides/layouts/*.vue` — there is no other mechanism
in current Slidev to define them.
