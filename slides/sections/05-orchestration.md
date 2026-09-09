---
layout: section
heading: "The delegation ladder"
current: subagent
---

<template #map>
<ToolkitMap current="subagent" />
</template>

<!--
01:18. This is the centrepiece block — 72 minutes, three orchestration strategies run
on stage against the same problem. Say it plainly: "one problem, three strategies, we
run all three." The map is up because we're about to fill in three of its rows from
lived experience, not assertion — remind the room we'll come back to it at 02:13 with
real numbers.
-->

---
layout: code-live
heading: "Does the layout guard protect the action?"
filePath: "app/(app)/layout.tsx"
success: "The room can state, unprompted, that a Server Action is a public POST endpoint with a generated id — not just a function guarded by the page it's called from."
---

```tsx
import type { ReactNode } from "react";
import { requireUser } from "@/lib/auth";
import { getNotifications, getUnreadCount } from "@/lib/data/notifications";
import { SidebarInset, SidebarProvider } from "@/components/ui/sidebar";
import { AppSidebar } from "@/components/app-sidebar";
import { TopBar } from "@/components/top-bar";

export default async function AppLayout({ children }: { children: ReactNode }) {
  const user = await requireUser();
  // ⟵ LIVE: this guards every page under (app). Now open any file in
  // app/actions/ and ask the room — does this guard protect the action too?
  const [notifications, unreadCount] = await Promise.all([
    getNotifications(user.id),
    getUnreadCount(user.id),
  ]);

  return (
    <SidebarProvider>
      <AppSidebar user={user} />
      <SidebarInset>
        <TopBar notifications={notifications} unreadCount={unreadCount} />
        <div className="flex flex-1 flex-col">{children}</div>
      </SidebarInset>
    </SidebarProvider>
  );
}
```

<!--
Do not skip this — FACILITATOR.md is explicit that many strong React developers do not
know this, and if it doesn't land, the room spends the next hour watching agents audit
something they don't understand the danger of.

Open the real file, show requireUser() guarding the page. Then open ANY file in
app/actions/ — e.g. app/actions/clashes.ts — and ask the room the question directly:
"this layout guard protects the page. Does it protect the action?"

It does not. A Server Action compiles to a public POST endpoint with a generated ID.
Anyone holding a session cookie can call any action directly, with any arguments,
without ever loading the page it lives behind. Authorization has to be re-established
INSIDE every single action. Zod validates shape, not permission.

Now the task is obvious and urgent: "Which actions in app/actions/ let a logged-in user
mutate someone else's clash?" Land that question, then move to the next slide (G14) for
the visual version of exactly this argument.
-->

---
layout: concept
heading: "The attack surface"
---

<G14AttackSurface />

<!--
This is the workshop's centrepiece graphic — make it unmistakable. Walk it exactly as
built: left side is the safe-looking path (Browser → guarded page → requireUser() →
button → action). Right side is the bypass — a direct POST to the action's generated id,
arriving at the exact same Server Action, having never loaded the guarded page at all.
Close on the label: "Zod validates shape, not permission." That's the line to leave
hanging before naming the actual task.
-->

---
layout: concept
heading: "Find it"
lines:
  - "Which actions in app/actions/ let a logged-in user mutate someone else's clash?"
  - "Two specific actions, not a broad sweep — this branch seeds one real, findable flaw"
---

<!--
State the task exactly as written on the slide, then say the correction OUT LOUD before
anyone starts auditing — do not let this surface as a surprise mid-block:

Upstream CLASH's real main branch has NO missing authorization checks — all 18 exported
Server Actions are already correctly guarded (verified against a fresh clone as part of
building this workshop). The vulnerability this block finds is DELIBERATELY SEEDED on
wk/03-start: the ownership check was removed from exactly two actions, deleteClash
(app/actions/clashes.ts) and deleteVenue (app/actions/venues.ts) — both normally check
`existing.creatorId !== user.id` before mutating. This is workshop content, not a CLASH
bug. Say so plainly if anyone asks. Reference
workshop-artifacts/03-delegation-ladder/AUTH-FIX.md for the exact diff and a
proof-of-concept direct POST.

A small tell for a sharp auditor, worth mentioning if nobody finds it themselves:
`npm run lint` on wk/03-start reports an unused `user` variable warning in deleteVenue —
the guard that used it is gone, but the binding wasn't cleaned up. The quality gates
still pass (it's a warning, not an error), which is itself worth a beat: green gates
don't mean safe code.
-->

---
layout: code-live
heading: "Define the security-auditor subagent"
filePath: ".claude/agents/security-auditor.md"
success: "The subagent's brief names the exact falsifiable check — ownership on mutation of an existing row — not a vague 'find security bugs.'"
---

```md
---
name: security-auditor
description: Audit Server Actions in app/actions/ for missing ownership checks on mutations of existing rows. Use when reviewing authorization in CLASH.
tools: Read, Grep, Glob
---

<!-- ⟵ LIVE: write the brief as a falsifiable property, not a vibe. For every
     exported Server Action that mutates an EXISTING row, does the code check
     that the current user owns it (e.g. `existing.creatorId !== user.id`)
     before mutating — not just that requireUser() ran? Report file, function
     name, and PASS/FAIL with the exact line that decides it. -->
```

<!--
FULL WORKING SOLUTION (trainer only — do not reveal before the room writes their own):

---
name: security-auditor
description: Audit Server Actions in app/actions/ for missing ownership checks on mutations of existing rows. Use when reviewing authorization in CLASH.
tools: Read, Grep, Glob
---

# Security auditor

Audit every exported Server Action in `app/actions/*.ts`. For each one that
mutates an EXISTING row (update or delete — not create), check: does the code
verify the current user owns the row (e.g. `existing.creatorId !== user.id`
or an equivalent scoped `where` clause) before mutating, not just that
`requireUser()` ran?

Report one line per action: file, function name, PASS or FAIL, and the exact
line that decides it. Do not report actions that only create new rows or that
scope their own `where` clause to `userId: user.id` — those are safe by
construction.

Talking points while typing this live: the `tools:` field matters — Read,
Grep, Glob only, no Edit/Write/Bash. This subagent reads and reports; it does
not fix. Narrowing tools is itself a control primitive worth naming. Contrast
the brief with a vague "find security bugs" prompt — a falsifiable property
("ownership check present, yes/no") is what makes the subagent's report
checkable rather than a wall of prose.
-->

---
layout: task
number: "03"
heading: "Subagent security audit"
goal: "Run a single, isolated security-auditor subagent against app/actions/ and watch the main thread's context barely move."
timebox: "12 min"
mode: "follow along"
qrSlug: "03-subagent-audit"
repoUrl: "github.com/pawsaw/claude-code-black-belt/tasks/03-subagent-audit.md"
success: "The subagent flags exactly deleteClash and deleteVenue as FAIL, and nothing else."
---

<!--
Strategy one of three. Note your /context reading before launching. Launch one
security-auditor subagent with a narrow, falsifiable brief (verbatim prompt is in
tasks/03-subagent-audit.md) — not "find security bugs" but the specific property to
check: for every exported Server Action, does a mutation of an EXISTING row check
ownership, not just authentication?

Let it read every file in app/actions/, report back per action. Then read /context
again — it should have moved only slightly. That IS the point of subagents: the noisy
file-reading happened in the subagent's own window, not yours.

Cover fork-by-default here: in current Claude Code, fork mode is ON by default in
interactive sessions (confirmed OFF under -p and the Agent SDK — worth naming if
headless CI comes up later). A fork inherits the entire parent conversation, tools,
model, and the parent's prompt-cache TTL — cheaper than a cold subagent when shared
context is genuinely useful, but also less isolated than a fresh subagent. This audit
works either way; the point is knowing which one you're invoking and why.
-->

---
layout: concept
heading: "Two ways to isolate"
---

<div class="grid grid-cols-2 gap-8 w-full">
  <G06SubagentIsolation />
  <G07ForkVsFresh />
</div>

<!--
Left: subagent isolation — the subagent's own context window fills with noisy tool
calls; only a thin summary crosses back, which is why the main thread barely moved.

Right: fork vs. fresh. A fork branches off the parent, inheriting the full conversation
and — critically — the parent's prompt-cache TTL, so it's cheap when the shared context
is genuinely needed. A fresh subagent starts cold: no shared history, filtered tools, no
cache inheritance, so the first call is a full cache-miss and costs more. Neither is
"better" — they trade isolation against cost, and today's audit could be run either way.
-->

---
layout: section
heading: "Strategy two: agent teams"
current: team
---

<template #map>
<ToolkitMap current="team" />
</template>

<!--
Same problem, same seeded branch (wk/03-start) — a different orchestration strategy.
Say explicitly: "hands off keyboards for ten minutes, just watch this one."

Before this segment: confirm CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 is actually set on
your machine. Agent teams are experimental and off by default — without the flag this
demo silently spawns plain subagents, no team, no disagreement, no payoff, and you get
no error telling you why. Check this before doors, not on stage.
-->

---
layout: code-live
heading: "Configure the audit team"
filePath: "prompt to Claude Code — natural language, not a config file"
success: "The room can name the four peer domains before the lead assigns them, and knows teammates message by name, never by @mention."
---

```txt
Set up an agent team to audit app/actions/ for missing ownership checks.

Lead: coordinate four peers, one per domain — clashes, venues,
participations, profile. Each peer audits only the actions in its own
domain file. Peers report findings to you by name; reconcile any
disagreement between peers about the same file before reporting up.

<!-- ⟵ LIVE: there is no YAML/JSON file to fill in here — a team is
     configured by describing it in natural language, same as this skeleton.
     Confirm CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 is set before running
     this, or the lead silently spawns plain subagents instead of a team. -->
```

<!--
FULL WORKING NOTE FOR THE TRAINER: unlike a subagent or a hook, there is no
frontmatter file to author here — a team is stood up by describing its shape
to Claude in prose, which is itself worth saying out loud: "notice this isn't
a config file. You're describing an org chart, not writing YAML."

The four domain peers map onto CLASH's actual action files: app/actions/
clashes.ts, venues.ts (participation lives in the Participation model but is
mutated via clash join/leave actions), and profile.ts. Naming them concretely
before launching is what makes "watch this one" land — the room should be
able to predict the shape of the team before it appears on screen.

Correct twice, on this slide specifically, since it's the one most likely to
get misremembered from an older deck: teammates message each other BY NAME
through the SendMessage tool — there is no @-mention syntax between peers.
And confirm the experimental flag is set before you press enter; if you
forget, the demo produces plain subagents with no error explaining why.
-->

---
layout: task
number: "04"
heading: "Agent team audit (watch only)"
goal: "Watch a lead supervise four domain auditors, and see two peers disagree about the same file before the lead reconciles them."
timebox: "10 min"
mode: "watch only"
qrSlug: "04-agent-team-audit"
repoUrl: "github.com/pawsaw/claude-code-black-belt/tasks/04-agent-team-audit.md"
success: "The room can describe one message sent by name between teammates, and the moment the lead reconciled a disagreement."
---

<!--
"Hands off keyboards for ten minutes, just watch this one." One auditor per domain:
clashes, venues, participations, profile.

Two corrections to get right on stage, both from the run-sheet's own errata: teammates
message each other BY NAME through the SendMessage tool, backed by per-agent JSON
mailboxes — there is no @-mention syntax between peers, despite what older material
(including an earlier version of this run-sheet) claimed. And `claude agents` is NOT a
team dashboard — it's the view for parallel BACKGROUND sessions. The team's own panel is
inline, below the prompt input, in the session that started the team.

The moment worth waiting for: two peers reaching different conclusions about the same
file — most likely around app/actions/venues.ts, since deleteVenue is one of the two
seeded findings and its neighbor updateVenue is correctly guarded, exactly the kind of
near-miss that produces genuine disagreement. Watch the lead reconcile it. That
disagreement is the entire argument for teams over a single subagent — one screen of it
teaches more than twenty minutes of setup they'd fumble through themselves.
-->

---
layout: concept
heading: "Lead, peers, and a disagreement"
---

<G08TeamTopology />

<!--
Walk the topology as built: one lead, four peers (clashes / venues / participations /
profile), bidirectional SendMessage links — labeled explicitly as "SendMessage" or
"message by name," never "@mention," since that syntax doesn't exist between peers.
The payoff frame: two peers raise conflicting findings about the same file, converging
on the lead, who sends back a single reconciling message to both. That reconciliation
step is the entire argument for a team over a lone subagent.
-->

---
layout: section
heading: "Strategy three: dynamic workflows"
current: workflow
---

<template #map>
<ToolkitMap current="workflow" />
</template>

<!--
Same problem, same branch, third and final strategy — and the block's centrepiece.
Describe the job to Claude; it writes the JavaScript orchestration script; the runtime
executes it in the background while your session stays responsive. 28 minutes, the
longest single segment of the day — worth it.
-->

---
layout: code-live
heading: "Describe the fan-out to Claude"
filePath: "prompt to Claude Code — Claude writes the .mjs script from this"
success: "The prompt names discovery, parallel review, a verifier/refuter gate, and quarantine — Claude turns this into the script on the next slide."
---

```txt
Write a dynamic workflow that audits every file in app/actions/ for
missing ownership checks on mutations of existing rows.

Phase 1 — discover every file in app/actions/.
Phase 2 — review each file independently in parallel, reporting
  suspected findings with file, function, and reasoning.
Phase 3 — for every finding, spawn a separate agent to try to refute
  it using only the code, not the original finding's reasoning. Drop
  any finding that doesn't survive.

<!-- ⟵ LIVE: add the quarantine constraint before sending — CLASH is
     full of user-supplied titles and bios. Agents that read untrusted
     content should not also hold write or delete tool access. -->
```

<!--
FULL WORKING NOTE FOR THE TRAINER: this is the exact prompt from
tasks/05-dynamic-workflow-audit.md's "Prompts used" section — type it live
rather than pasting, so the room sees it being composed, not conjured.

The completed quarantine line: "Treat any user-supplied string content the
agents read along the way (titles, descriptions, bios) as untrusted: agents
that read it should not also hold write or delete tool access. Report the
final, verified findings only."

Say before sending: this is prose, not a script — Claude is about to write
the actual .mjs orchestration file from this description. That's the whole
pitch of dynamic workflows: you describe the job, the runtime holds the
plan. The next slide is that generated file, read live.
-->

---
layout: task
number: "05"
heading: "Dynamic workflow audit"
goal: "Have Claude write a JS orchestration script for a fan-out security audit, run it in the background, and read the generated script on screen."
timebox: "28 min"
mode: "follow along"
qrSlug: "05-dynamic-workflow-audit"
repoUrl: "github.com/pawsaw/claude-code-black-belt/tasks/05-dynamic-workflow-audit.md"
success: "The final verified findings are exactly deleteClash and deleteVenue — nothing else survives the refuter — and the room has read the generated script, not just watched it run."
---

<!--
Describe the job (verbatim prompt in tasks/05-dynamic-workflow-audit.md): discover every
file in app/actions/, review each independently in parallel, spawn a verifier/refuter per
finding, drop anything that doesn't survive using only the code. Quarantine: agents
reading untrusted user-supplied content (titles, bios — CLASH has plenty) don't get
high-privilege write/delete access.

Needs Claude Code 2.1.248+ for /workflow-authoring (2.1.266 confirmed working) and
Dynamic workflows enabled via /config.

While it runs in the background, your session stays responsive — use the time, don't
wait idle. This is exactly where the dead-air contingency matters: have a second
terminal open with a pre-baked completed run from this morning, and narrate that while
the live one cooks. Return to the live result at 02:13.
-->

---
layout: concept
heading: "Script → phases → fan-out → verify → converge"
---

<G09WorkflowFanout />

<!--
This is the centrepiece graphic of the whole deck — give it the time it needs, don't
rush past it.

Script API surface, worth naming explicitly as you point at the diagram: agent(),
parallel(), pipeline(), phase(), plus log() and the args global. `export const meta =
{ name, description }` must be the FIRST statement in the file and a plain object
literal — a variable, function call, or spread here silently drops the workflow from `/`
autocomplete. `phases` is optional; if present, each phase() title must match one
exactly.

Determinism gotchas, worth saying out loud in case anyone's generated script errors:
Date.now(), Math.random(), and a no-arg new Date() all THROW inside a workflow script,
and import() fails the run — this is what makes replay safe, not a bug.

Verifier/refuter: one agent tries to refute another's finding using only the code, not
the original reasoning — this is how "several possible issues" becomes "two real ones."
On this branch specifically, the two survivors are deleteClash and deleteVenue; nothing
else should make it through the refuter gate.

Say the token cost out loud here. Workflows are the most expensive strategy of the
three — that's not incidental, it's the tradeoff for bounded roles, clean context per
agent, and a deterministic review gate instead of one long noisy conversation.
-->

---
layout: code-live
heading: "Read the generated script on screen"
filePath: ".claude/workflows/<generated-name>.mjs"
success: "The room can point at the file's meta export, name one phase, and explain what the verifier agents are for — before you explain it for them."
---

```js
export const meta = {
  name: 'audit-actions',
  description: 'Fan-out security audit of app/actions/ with a verifier/refuter gate',
  // phases is optional — include it only if every phase() title below matches exactly
}

// ⟵ LIVE: read whatever Claude actually generated here. Walk phase-by-phase:
// discovery → parallel review → verifier/refuter → converge. Do not pre-write
// this — the entire point of this slide is reading Claude's own harness live.

const findings = await pipeline(
  actionFiles,
  file => agent(/* review prompt for `file` */, { phase: 'Review' }),
)

const verified = await parallel(
  findings.flat().map(f => () => agent(/* refute `f` using only the code */, { phase: 'Verify' }))
)

return { verified: verified.filter(Boolean) }
```

<!--
FULL WORKING NOTE FOR THE TRAINER: there is no single "correct" script here — this
slide's skeleton is illustrative of the shape (meta first, discovery phase, a
parallel/pipeline fan-out, a verifier pass, a filtered return), not a fill-in-the-blank
answer. The real content of this slide is whatever Claude generates live for your actual
prompt from tasks/05-dynamic-workflow-audit.md.

CRITICAL correction to say out loud: the script does NOT land in .claude/workflows/
automatically. Every run's script is written under ~/.claude/projects/<session-dir>/
first — that's what you're reading right now. Only pressing `s` inside /workflows after
the run saves a committable copy to .claude/workflows/ (project) or
~/.claude/workflows/ (personal). If you want the "commit it" beat from the run-sheet to
be literally true on stage, press `s` before you say the word "commit."

Walk: the phases, the branching, the agent allocation, the budget. Fifteen minutes
reading generated orchestration code is worth more than a fourth framework — this is the
real payload of the block, not the findings themselves.
-->

---
layout: concept
heading: "Reconcile, decide, merge"
---

<G10OrchestrationLadder />

<!--
02:13, 17 minutes. Three results side by side: findings, wall-clock, tokens, main-thread
context burn, across all three strategies run today. Now go back to the map from 00:10
and fill in the middle four rows from evidence rather than assertion — this diagram is
that evidence, laid out as a comparison grid across the three approaches.

Land the real numbers you actually observed today, not the placeholders on the diagram —
this is the one moment in the deck where the trainer's live data matters more than the
slide.
-->

---
layout: concept
heading: "Ship the fix"
lines:
  - "Restore creatorId !== user.id in deleteClash and deleteVenue"
  - "Lands on wk/04-start — the block ends with shipped code"
---

<!--
Merge the real authorization fixes into CLASH — restore the creatorId check in
deleteClash (app/actions/clashes.ts) and deleteVenue (app/actions/venues.ts). The exact
diff is in workshop-artifacts/03-delegation-ladder/AUTH-FIX.md if you want it on hand.
The block ends with shipped code, landing (as prepared ahead of time) on wk/04-start —
say this explicitly so the room understands the branch model isn't just for catch-up,
it's also how today's own progress is checkpointed.
-->
