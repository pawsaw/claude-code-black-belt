# Claude Code: Black Belt — Run-Sheet

> **This delivery: 2026-09-09, 15:00–19:00 CEST**, remote via Zoom, React Day Berlin 2026
> (confirmed live via [GitNation](https://gitnation.com/contents/claude-code-black-belt-3) and
> [reactday.berlin](https://reactday.berlin/)). The `wk/*-start` branches this run-sheet
> depends on must be **pushed to `pawsaw/clash` before doors** — run
> [`scripts/prepare-workshop-branches.sh`](scripts/prepare-workshop-branches.sh) against a
> local clone, review the diff, then push explicitly. Nothing below auto-pushes.

**Format:** 4h code-along. No silent phases. You drive, they follow.
**Codebase:** `github.com/pawsaw/clash` — Next.js 16 / React 19 / Prisma 7 + SQLite / shadcn / Leaflet
**Spine:** *Ship CLASH v2 in four hours without typing a line of implementation.*

By 19:00 CLASH has: a test suite, an authorization audit plus merged fixes, real-time
notifications, a perf fix, and a reusable Skill + hook set that outlives the room.

**Audience calibration:** they use Claude Code daily; they are not experts in it. Assume
they know CLAUDE.md, plan mode, and roughly what a subagent is. Assume they have never
written a hook, never authored a skill, and have never seen a dynamic workflow. The risk
in this workshop is **volume, not difficulty** — so the last hour is deliberately narrow.

**Changes from v2:** added a toolkit map at 00:10, added a proper security-model setup
before the audit, rebuilt the hooks block to teach one hook slowly, cut the final hour
from five topics to two.

**Changes from v3 (this build):** every fact below was verified live against the real
`pawsaw/clash` repository, the real Claude Code docs (build `2.1.266`), and the real link
targets. Several things in the previous version of this run-sheet were wrong in ways that
would have broken a live demo — they are corrected in place below and flagged with
**⚠ CORRECTED**. Read those before you improvise on stage.

---

## 0. Pre-flight — send this to attendees NOW

Conference wifi plus `npm install` plus `npx` MCP downloads will eat 15 minutes of your
workshop if you don't front-load it. Full version with troubleshooting: `docs/SETUP.md`.

```bash
git clone https://github.com/pawsaw/clash && cd clash
git checkout wk/00-start
npm install
cat > .env <<'EOF'
DATABASE_URL="file:./dev.db"
SESSION_SECRET="black-belt-workshop-secret"
EOF
npm run db:migrate
npm run db:seed
npm run dev          # confirm http://localhost:3000 loads
claude --version
```

> ⚠ **CORRECTED — version floor.** The old run-sheet said "2.1.154+ for dynamic
> workflows." That's when dynamic workflows *shipped*, but the features you actually demo
> need more: `/workflow-authoring` needs **2.1.248+**, and `/skill-doctor` (used in block 3)
> needs **2.1.252+**. **Require 2.1.252+ from the room.** Your machine is on 2.1.266 — fine.

Then, inside Claude Code, **before the session starts**:

- `/config` → turn **Dynamic workflows** ON. Off by default on Pro.
  If half the room skips this, the centrepiece fails for half the room.
- ⚠ **CORRECTED — new step, not in v2.** Agent teams (block 5, 01:35) are **experimental
  and off by default**. Add to `~/.claude/settings.json`:
  ```json
  { "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
  ```
  Without this, the 01:35 demo silently spawns ordinary subagents — no team, no
  disagreement, no payoff, and you won't get an error telling you why.
- Pre-install the MCP servers for Block 6 so `npx` isn't downloading live:
  `claude mcp add playwright -- npx -y @playwright/mcp@latest` and the same for
  `chrome-devtools-mcp`. Also `npx -y playwright install chromium`.

Demo logins: `anna.schmidt@example.com` / `test` (8 seeded users, all password `test`).

**Reset branches.** `wk/00-start` … `wk/07-start` on `pawsaw/clash`, prepared by
`scripts/prepare-workshop-branches.sh`, so anyone who falls behind can
`git checkout wk/04-start` and rejoin. In a code-along with no catch-up time this is the
only recovery mechanism you have. **These branches also carry state changes between
blocks** (the auth fix, the CLAUDE.md rewrite, the hook set) — see
`docs/SPEC-DEVIATIONS.md` for exactly what each one contains.

**Say once, early:** the repo's `hooks/` folder is React hooks (one file,
`hooks/use-mobile.ts`). Claude Code hooks live in `.claude/settings.json`. Different
things. Both will be on screen today.

---

## 00:00 – 00:10 · Cold open: find the ceiling

Fresh session. The naive version of a real task:

> Add real-time notifications to Clash.

Let it read 40 files. Let it guess at the notification model. Let it drift.
Then open `/context` and show the burn.

**Do not fix it.** The thesis, demonstrated instead of asserted: the ceiling isn't the
model, it's uncontrolled context.

> **Fallback.** It might just succeed — the model is good and CLASH is well-structured.
> If it does, don't fake disappointment. Open `/context` anyway and make the point on
> cost instead of failure: *it worked, and it burned 60% of the window to do it. Now
> imagine the fourth feature in the same session.* Same thesis, different evidence.

---

## 00:10 – 00:15 · The map  (5 min, slide only)

Before the territory, the map. This is the question this room actually has:

> "I know CLAUDE.md and plan mode. When do I reach for a skill, a subagent, a hook, or MCP?"

| Primitive | What it is | Reach for it when |
|---|---|---|
| **Context** | the window itself | always — it's the constraint everything else works around |
| **Skill** | instructions loaded on demand | the work is repeatable and you keep re-explaining it |
| **Subagent** | a worker with its own context window | the work is noisy and would pollute your thread |
| **Agent team** | a lead supervising peer sessions | workers need to talk to each other over time |
| **Workflow** | a script that holds the plan | the fan-out is bigger than one conversation can steer |
| **Hook** | deterministic shell on a lifecycle event | the rule must hold whether or not the agent agrees |
| **MCP** | your systems as tools | the agent needs to reach outside the repo |

Tell them: we build every row of this table today, in this order, on one codebase.
Then leave it up. Refer back at each block boundary — it's their orientation all afternoon.

---

## 00:15 – 00:50 · Context engineering  (35 min)

- `/context` as an instrument, not a curiosity. Read the breakdown aloud.
- **Audit CLASH's existing `CLAUDE.md` and `AGENTS.md` live.**
  ⚠ **CORRECTED — this is not a slimming exercise.** In real CLASH, `CLAUDE.md` is 11
  bytes (`@AGENTS.md`) and `AGENTS.md` is 327 bytes of generic auto-injected Next.js
  boilerplate — there is nothing bloated to halve. **Reframe live as authoring**: write a
  real `CLAUDE.md` from scratch around the invariants that actually matter here: reads in
  `lib/data/*`, writes in `app/actions/*`, `lib/validation.ts` is the single source of
  truth for Zod, Next 16 `params`/`searchParams` are Promises, Prisma client generated to
  `lib/generated/prisma`, status fields are documented strings not enums. A finished
  version is at `workshop-artifacts/02-context/CLAUDE.md` and lands on `wk/04-start`
  onward — don't show it before the room writes their own.
  - If you want the "waste" narrative back, it's genuinely available elsewhere: run
    `/skill-doctor` on `.agents/skills/` and show that `react-best-practices` and
    `vercel-react-best-practices` are ~100KB near-duplicate vendored skills.
- `@`-reference discipline versus letting the agent grep its way in.
- **Plan Mode** on the SSE notifications feature. Review the approach before a byte moves.
- `/skill-doctor` — which loaded skills go unused, and what they cost. (Needs 2.1.252+.)

**Ships:** `docs/plans/realtime-notifications.md`, and a real, from-scratch `CLAUDE.md`.

---

## 00:50 – 01:18 · Skills  (28 min)

CLASH already has `.agents/skills/` and `skills-lock.json`, so you're not starting cold.

Write `clash-feature` — the recipe for adding a feature to *this* codebase:

> Prisma model → migration → Zod schema in `lib/validation.ts` → read helper in
> `lib/data/` → Server Action in `app/actions/` **with its own auth check** →
> RSC page → shadcn component → `revalidatePath` → notification emit

Then use it immediately to ship something small end to end (venue favourites, or clash
comments). Compare against the cold open. It should be visibly tighter.

Note that custom commands have merged into skills — but ⚠ **CORRECTED**: this does not
mean `.claude/commands/*.md` is deprecated. It keeps working identically; skills are just
the richer primitive for new work (bundled files, `allowed-tools`, `context: fork`).

**Ships:** `.claude/skills/clash-feature/SKILL.md` (reference copy:
`workshop-artifacts/03-skills/SKILL.md`) + one real feature.

---

## 01:18 – 02:30 · The delegation ladder  (72 min) ← centrepiece

**One problem. Three orchestration strategies. Run all three on stage.**

### 01:18 — Establish the problem (5 min, no agents yet)

Do not skip this. Many strong React developers do not know the following, and if it
doesn't land, the next hour is people watching agents audit something they don't
understand the danger of.

Open `app/(app)/layout.tsx` and show `requireUser()`. Then open any file in
`app/actions/`. Ask the room:

> This layout guard protects the page. Does it protect the action?

It does not. A Server Action compiles to a public POST endpoint with a generated ID.
Anyone with a session cookie can call any action directly, with any arguments, without
ever loading the page it lives behind. Authorization has to be re-established *inside
every single action*. Zod validates shape, not permission.

Now the task is obvious and urgent:

> Which actions in `app/actions/` let a logged-in user mutate someone else's clash?

> ⚠ **CORRECTED — say this explicitly, don't discover it live and get surprised.**
> Upstream CLASH's `main` branch has **no missing authorization checks** — all 18
> exported Server Actions are already guarded (verified against a fresh clone). The
> vulnerability this block finds is **deliberately seeded** on `wk/03-start`: the
> ownership check was removed from exactly two actions, `deleteClash` and `deleteVenue`
> (both normally check `existing.creatorId !== user.id` before mutating). This is
> workshop content, not a CLASH bug — say so if anyone asks, and reference
> `workshop-artifacts/03-delegation-ladder/AUTH-FIX.md` for the exact diff and a
> proof-of-concept POST. A small tell for a sharp auditor: `npm run lint` on
> `wk/03-start` reports an unused `user` variable warning in `deleteVenue` — the guard
> that used it is gone, but the binding wasn't cleaned up.

### 01:23 — Subagent (12 min) — *they follow along*

One `security-auditor`, isolated context, reports back. Then show `/context` on the main
thread: barely moved. That *is* the point of subagents.

Mention that subagent forking is now on by default in interactive sessions — a fork
inherits the parent's conversation and prompt cache, so it's cheaper than a cold subagent
when the shared context is genuinely needed. (Confirmed: OFF under `-p` and the Agent
SDK — worth naming if anyone asks about CI later.)

### 01:35 — Agent team (10 min) — *demo only, tell them to watch*

Say it explicitly: "hands off keyboards for ten minutes, just watch this one."

⚠ **CORRECTED — this segment needs a flag, and two claims in the old script were wrong.**
Agent teams are **experimental**; without `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` set
(see pre-flight above), this demo silently spawns plain subagents and there is no team to
watch. **Confirm the flag is set on your machine before doors.**

Lead plus peers, one auditor per domain (clashes, venues, participations, profile).
Teammates message each other **by name** through the `SendMessage` tool — not, as
previously written here, "`@`-mention messaging between live sessions"; there is no
`@`-mention syntax between peers. The moment worth waiting for is two peers reaching
**different conclusions about the same file** and the lead reconciling them. That
disagreement is the entire argument for teams over subagents — one screen of it teaches
more than twenty minutes of setup they'd fumble.

Also correct if it comes up: `claude agents` is **not** a team dashboard — it's the view
for parallel *background* sessions. The team's own panel lives inline below the prompt in
the session that started the team.

### 01:45 — Dynamic workflow (28 min) — *they follow along*

Describe the job; Claude writes the JavaScript orchestration script; the runtime executes
it in the background while your session stays responsive.

Fan-out: discover every action file → review each independently → spawn a verifier per
finding → drop findings with no code evidence.

**Then do the thing nobody does: open the generated script and read it on screen.**
This is the real payload. Claude wrote its own harness and you can inspect it, edit it,
commit it, rerun it. Walk the phases, the branching, the agent allocation, the budget.
Fifteen minutes reading generated orchestration code is worth more than a fourth framework.

⚠ **CORRECTED — where the script actually lives.** The per-run script first lands under
`~/.claude/projects/<session-dir>/` — that's what you read on screen. It is **not yet** in
`.claude/workflows/`. Only pressing **`s`** inside `/workflows` saves a committable copy
there. If you want the "commit it" beat to be literally true on stage, press `s` before
you say the word "commit."

⚠ **CORRECTED — determinism gotcha, worth saying out loud if anyone asks why their script
errored.** Workflow scripts run in a replay-safe sandbox: `Date.now()`, `Math.random()`,
and a no-arg `new Date()` **throw** inside a workflow script, and `import()` fails the
run. If a participant's generated script uses any of these, that's the fix, not a bug in
Claude Code.

While it runs, cover:
- **Verifier / refuter** — one agent tries to refute another's finding. This is how you get
  from "47 possible issues" to "6 real ones."
- **Quarantine** — agents reading untrusted input don't get high-privilege actions.
  Directly relevant: CLASH is full of user-supplied titles and bios.
- **Cost.** Workflows use a lot more tokens. Say the number out loud. "More agents" is not
  the point; bounded roles, clean context, and deterministic review gates are.

### 02:13 — Reconcile, decide, merge (17 min)

Three results side by side: findings, wall-clock, tokens, main-thread context burn.
Now go back to **the map from 00:10** and fill in the middle four rows from evidence
rather than assertion.

Then merge the real authorization fixes into CLASH — restore the `creatorId` check in
`deleteClash` and `deleteVenue`. The block ends with shipped code, landing (as prepared)
on `wk/04-start`.

**Dead-air mitigation — plan this explicitly.** Kick off the live workflow at 01:45, then
switch to a second terminal holding a completed run from this morning and narrate that
while the live one cooks. Return to the live result at 02:13. With 72 minutes the risk is
higher, not lower — you now have more time to fill if it stalls.

---

## 02:30 – 02:40 · Break

---

## 02:40 – 03:10 · Hooks: rules the agent cannot cross  (30 min)

**Assume nobody here has written one.** Build one slowly, then show three fast. Five
bullet points at speed will lose the room right after the break, which is already the
lowest-energy moment of the day.

### 02:40 — Anatomy (5 min)
Open `.claude/settings.json`. Name the three things they need: the **event**
(`PreToolUse`, `PostToolUse`, `Stop` — of 33 total events), the **matcher** (which tool),
and the **exit code**.

⚠ **CORRECTED — get this exactly right, it's the whole model.** Only **exit code 2**
blocks; other non-zero codes are non-blocking (shown in the transcript, not enforced).
And on `PreToolUse`/`PostToolUse`, plain exit-0 stdout goes to the **debug log only** —
Claude never sees it. What reaches the agent is **stderr on exit 2**, or structured JSON
on stdout at exit 0. Also: **`matcher` matches the tool name, not a file path.** This
matters enormously for the next 12 minutes — see below.

### 02:45 — Build one, together, slowly (12 min)

⚠ **CORRECTED — this is now the deliberate mistake, not an accident to avoid.** The old
plan was `PostToolUse` on edits to `app/actions/*` → `npx tsc --noEmit`, with an implied
path glob in `matcher`. **That would never fire** — `matcher` matches the tool name
(`Edit`, `Write`, …), and a path glob there is parsed as an unanchored JS regex against
the tool name, so it silently never matches. Do exactly this, on purpose:

1. Write `matcher: "Edit|Write"` with a bare path pattern crammed into it, or a matcher
   like `"app/actions/*"` — watch it never fire when you edit `app/actions/clashes.ts`.
2. Ask the room why nothing happened. Let it sit for a second.
3. Fix it with the sibling **`if`** field, which does take a path-scoped permission-rule
   expression:
   ```json
   {
     "hooks": {
       "PostToolUse": [
         {
           "matcher": "Edit|Write",
           "hooks": [
             {
               "type": "command",
               "if": "Edit(app/actions/**) or Write(app/actions/**)",
               "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/typecheck-actions.sh",
               "timeout": 60
             }
           ]
         }
       ]
     }
   }
   ```
4. Now watch it fire, get a type error wrong on purpose, watch the agent receive the
   failure (via stderr on exit 2) and fix its own code.

Reference implementation: `workshop-artifacts/04-hooks/settings.json` +
`typecheck-actions.sh`, landing on `wk/05-start`. The moment the agent reacts to a hook it
didn't know existed is the one they'll remember — and now the "why didn't it fire" moment
earns its own laugh line instead of being an off-script accident.

### 02:57 — Three more, fast (10 min)
- `PreToolUse` **deny**: no writes under `prisma/migrations/*`, no `rm`, no reading `.env`.
  Decision values are `allow`/`deny`/`ask` — reference: `workshop-artifacts/04-hooks/settings.json`.
- `PostToolUse` **output replacement** — confirmed real: `hookSpecificOutput.updatedToolOutput`
  now works for all tools, not just MCP. Collapse noisy `npm run build` output before it
  reaches the window. Direct callback to Block 2.
- `Stop`: refuse to end the turn while `npm run build` is failing — reference:
  `workshop-artifacts/04-hooks/build-gate.sh`.

### 03:07 — Frame it (3 min)
Skills are advice. Hooks are law. A skill is what you'd tell a new colleague; a hook is
what CI would reject. If you find yourself repeating a rule in CLAUDE.md and the agent
keeps drifting past it, that rule wanted to be a hook.

⚠ **CORRECTED — `hard_deny` is not a hooks feature.** Mention it in passing, but get the
subsystem right: it's `settings.autoMode.hard_deny`, a rule inside the separate **auto
mode** permission mode (a classifier model reviews actions instead of you) — not a
`PreToolUse` decision value. Don't configure it live; naming it is enough.

---

## 03:10 – 03:38 · MCP and the browser: closing the loop  (28 min)

- **Playwright MCP** against `localhost:3000` with the seeded accounts. Have the agent write
  the test suite the README says doesn't exist — join flow, host accept/reject, notification
  delivery.
- **Chrome DevTools MCP** on a perf bug already in the repo: avatars are base64 data URLs
  stored in the DB and inlined into responses (confirmed: `getCurrentUser()` selects
  `avatar` on every authenticated request, up to ~1.5 MB per page). Measure it, then fix it.
- The loop that matters: change → verify in a real browser → fix, no human in between.

Slide-only fourth option: Vercel's **Agent Browser**. Playwright MCP for E2E, DevTools MCP
for perf and network, Claude in Chrome for authenticated visual checks. ⚠ **CORRECTED**:
the oft-cited "~90% fewer tokens than Playwright MCP" is **not an official Vercel claim** —
it doesn't appear anywhere in the agent-browser README and third-party estimates disagree
with each other (82–93%). State the advantage qualitatively (compact accessibility-tree
snapshots vs. full MCP tool schemas + DOM), or measure it live if you have time.

---

## 03:38 – 03:52 · Letting go of the wheel  (14 min)

**Two things done properly, not five things listed.** This is minute 218 of 240 — a
firehose here undoes the afternoon.

### 03:38 — Worktrees (5 min)
`claude --worktree` (alias `-w`). Each background agent gets an isolated copy of the
repo under `.claude/worktrees/<name>/`, so parallel work stops colliding. This is the one
they'll use tomorrow morning, so give it the time.

### 03:43 — Headless in CI (5 min)
`claude -p` for headless mode. CLASH's Actions tab is empty (confirmed: no
`.github/workflows/`, zero runs) — fill it with the security audit from Block 4, now
running on every PR.

⚠ **CORRECTED — don't put `claude -p` directly in the YAML.** Use the official
**`anthropics/claude-code-action@v1`** (not `@beta`, which is legacy and had its `mode`
input removed) with `prompt` + `claude_args` inputs — the action runs headless for you.
The workshop's centrepiece becomes permanent infrastructure. That's the closing image for
the "autonomy" thread.

### 03:48 — The Agent SDK bridge (4 min, no build)
You've just run the agent headless in a pipeline. Say the true thing: that is the same
idea one level down. The Agent SDK is what you reach for when the agent lives *inside*
your software rather than beside it — imagine CLASH answering "find me something outdoors
in Kreuzberg this evening" over the map.

The point for this room: **every control primitive from today carries over unchanged.**
Context budget, subagent isolation, hooks as hard limits — same tools, new host. Show the
shape. Building it is a different workshop.

> **Moved to the closing slide, not demoed:** `/loop` for continuous triage, Remote Control
> and the `claude agents` dashboard, `/skill-doctor`. All worth knowing, none worth the
> minutes at this point in the day. Name them, link them, move on.

---

## 03:52 – 04:00 · Spec Kit vs BMAD, and close  (8 min)

Contractual — it's in your published abstract. Honest and short.

- **Spec Kit** — GitHub, MIT, agent-agnostic, `specify init`, low ceremony. Specs as
  version-controlled markdown any agent can consume. ⚠ **CORRECTED**: **~134k stars**, not
  ~90k — check `gh api repos/github/spec-kit` yourself if it's been a while since this run-sheet
  was written. Also: it's a **Python/`uv` tool**, not npm (`uv tool install specify-cli
  --from git+https://github.com/github/spec-kit.git`) — a real prerequisite if someone in
  the room only has Node installed.
- **BMAD v6** — ⚠ **CORRECTED**: current v6 (v6.12.0) ships **5 named agents** (Analyst,
  PM, Architect, Developer, UX Designer; a 6th, Technical Writer, is on hiatus), not
  "12+ personas" — that figure is from v4. Genuinely heavyweight regardless: reported
  real-world costs land around $800–2000 per developer per month on frontier models.
  Canonical repo is **`bmad-code-org/BMAD-METHOD`** (the older `bmadcode/BMAD-METHOD` now
  redirects there).

Rule of thumb: Spec Kit when you want spec discipline without process overhead. BMAD when
your organisation *already has* those roles and you're mapping onto them rather than
simulating them. BMAD won't conjure a process you don't have; it'll reproduce your chaos
across those roles.

**Say the honest thing:** both are greenfield methodologies and CLASH is brownfield. That's
why they came last, and why the four hours before were about control rather than ceremony.

**One slide: what we deliberately didn't cover.** `/loop`, Remote Control, `claude agents`,
`/skill-doctor`, output styles, the SDK hands-on. Naming these costs thirty seconds, respects
the room's intelligence, and pre-empts every "why didn't you show X" in the feedback form.

Close on your own two lines: *context is king*, and *you push it, you own it.*

---

## Risk register

| Risk | Mitigation |
|---|---|
| Dynamic workflows off by default on Pro | Everyone enables in `/config` during pre-flight |
| Agent teams demo does nothing | ⚠ **new** — confirm `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set on the trainer machine before doors, per `docs/SETUP.md` step 6b. It fails silently (plain subagents spawn, no error), so you will not get a warning if you forget. |
| Typecheck hook silently doesn't fire | ⚠ **new, but it's now scripted intentionally** — see the 02:45 correction above. Don't accidentally write the working `if`-based hook first; the room needs to see the naive `matcher`-only version fail before the fix lands. |
| 70-min block stalls on a slow workflow run | Second terminal with a pre-baked completed run; the generated-script read-through is your filler and it's the best content in the block |
| Token limits mid-workshop (teams + workflows are hungry) | Warn Pro users at minute one; keep a Max fallback on your machine |
| Conference wifi + `npx` MCP downloads | Pre-install before doors open |
| Attendees fall behind, no catch-up time | `wk/NN-start` reset branches, announced at every block boundary |
| Repo has only 3 commits | Nothing blame- or history-driven will work — don't plan any |
| Live audit finds nothing interesting | Not a risk anymore — the vulnerability is deliberately seeded on `wk/03-start`; see `workshop-artifacts/03-delegation-ladder/AUTH-FIX.md` |
| Someone asks why the SDK wasn't hands-on | Answer honestly: different mental model, orchestration depth was worth more. Offer a follow-up gist. |
| Room doesn't know Server Actions are public endpoints | The 5-min setup at 01:18 exists precisely for this — do not cut it for time |
| Post-break energy dip meets the hooks block | Build one hook slowly and let it fail on purpose; the agent reacting to a hook wakes people up |
| Cold open succeeds instead of drifting | Pivot the thesis from failure to cost — see the fallback note at 00:00 |
| Someone quotes an old doc URL or stat from memory | You have a corrected reference: `docs/LINK-AUDIT.md` lists every verified URL and every correction made during this build |

## Coverage check against your published abstract

Context engineering ✓ · Skills ✓ · Subagents in isolated context, several at once ✓ ·
Hooks as hard rules ✓ · MCP ✓ · Headless in a pipeline ✓ · Long task to a defined finish ✓ ·
Agent SDK ✓ *(covered conceptually, not built)* · Spec Kit and BMAD side by side ✓

Beyond the abstract: agent teams, dynamic workflows, generated-harness read-through,
verifier/refuter, quarantine, `/loop`, `/skill-doctor`, worktrees, Remote Control,
browser tooling.
