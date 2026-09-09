---
layout: section
heading: "Hooks: rules the agent cannot cross"
current: hook
---

<template #map>
<ToolkitMap current="hook" />
</template>

<!--
02:40, straight after the break. Assume nobody in the room has written a hook. Build one
slowly, then show three fast — five bullet points at speed would lose the room right
after the break, already the lowest-energy moment of the day. Say the disambiguation
again if it's been a while since 00:15: CLASH's hooks/ folder is React hooks (one file,
use-mobile.ts); Claude Code hooks live in .claude/settings.json. Different things.
-->

---
layout: concept
heading: "Event · matcher · exit code"
lines:
  - "PreToolUse, PostToolUse, Stop — three of 33 total events"
  - "Only exit code 2 blocks. Other non-zero codes are non-blocking."
---

<G11HookLifecycle />

<!--
Open .claude/settings.json. Name the three things a hook needs: the EVENT
(PreToolUse, PostToolUse, Stop, out of 33 total), the MATCHER (which tool it fires on),
and the EXIT CODE. That's the whole model — everything else is detail.

Get this exactly right, it matters for the next 12 minutes: only exit code 2 blocks;
other non-zero codes are non-blocking (shown in the transcript, not enforced). On
PreToolUse/PostToolUse, plain exit-0 stdout goes to the DEBUG LOG ONLY — Claude never
sees it. What reaches the agent is stderr on exit 2, or structured JSON on stdout at
exit 0. And: matcher matches the TOOL NAME, not a file path — that's exactly what the
next slide turns into a deliberate lesson rather than an accident.
-->

---
layout: code-live
heading: "Build a PostToolUse typecheck hook — slowly"
filePath: ".claude/settings.json"
success: "Editing app/actions/clashes.ts automatically triggers npx tsc --noEmit, and a failure blocks with the error visible to the agent."
---

```json
{
  "hooks": {
    "PostToolUse": [
      {
        // ⟵ LIVE: write this the way it looks like it should work first —
        // a path glob directly in "matcher". Watch it silently never fire.
        "matcher": "app/actions/*.ts",
        "hooks": [
          {
            "type": "command",
            "command": "npx tsc --noEmit"
          }
        ]
      }
    ]
  }
}
```

<!--
This is now the DELIBERATE mistake, not an accident to avoid — say so to yourself, not
necessarily to the room yet. Write it exactly as shown: matcher: "app/actions/*.ts".
Edit a file under app/actions/ through Claude Code. Nothing fires. Let it sit for a
second. Ask the room why.

The answer: matcher matches the TOOL NAME (Edit, Write, Bash, …), not a path — a path
glob placed there is parsed as an unanchored JS regex against the tool name, so it
silently never matches "Edit" or "Write". This is exactly why nothing happened.

Now fix it live, using the sibling "if" field, which DOES take a path-scoped
permission-rule expression:

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

Then write .claude/hooks/typecheck-actions.sh (full reference:
workshop-artifacts/04-hooks/typecheck-actions.sh):

  #!/usr/bin/env bash
  set -euo pipefail
  file_path="$(jq -r '.tool_input.file_path // empty' <<<"${CLAUDE_HOOK_INPUT:-$(cat)}" 2>/dev/null || true)"
  if [[ -n "$file_path" && "$file_path" != *"app/actions/"* ]]; then exit 0; fi
  output="$(npx tsc --noEmit 2>&1)" && exit 0
  echo "npx tsc --noEmit failed after editing $file_path:" >&2
  echo "$output" >&2
  exit 2

Introduce a real type error into app/actions/venues.ts on purpose (e.g. pass a number
where updateVenue expects a string) and make the edit THROUGH Claude Code so the hook
fires. Watch tsc fail, watch the agent receive the failure via stderr on exit 2, and fix
its own code without you typing the fix. This is the moment they'll remember.

Reference implementation lands on wk/05-start; source copies in
workshop-artifacts/04-hooks/settings.json + typecheck-actions.sh.
-->

---
layout: task
number: "06"
heading: "The typecheck hook"
goal: "Build a PostToolUse hook that runs npx tsc --noEmit after every edit to app/actions/*, and watch the agent receive and fix a failure it didn't know was coming."
timebox: "12 min"
mode: "follow along"
qrSlug: "06-typecheck-hook"
repoUrl: "github.com/pawsaw/claude-code-black-belt/tasks/06-typecheck-hook.md"
success: "You can state that only exit 2 blocks, not 'any non-zero code' — and you watched the agent self-correct."
---

<!--
This task IS the previous two slides, formalized with success criteria. Confirm the
room actually reproduced the broken matcher-only version before moving to the fix — the
"why didn't it fire" beat only lands if they saw the silence themselves, not just heard
about it.
-->

---
layout: concept
heading: "Three more, fast"
lines:
  - "PreToolUse deny: prisma/migrations/*, rm, .env reads"
  - "PostToolUse output replacement — now all tools, not just MCP"
  - "Stop: refuse to end the turn while npm run build is failing"
---

<!--
10 minutes, three hooks, move quickly — the model is already installed in their heads.
Frame all three here, then the next two slides type the first and third live.

Output replacement (no dedicated slide — cover it here, in passing): PostToolUse now
supports hookSpecificOutput.updatedToolOutput for ALL tools, not just MCP-sourced ones —
confirmed in the current docs. Use it to collapse a noisy `npm run build` log into a
one-line pass/fail summary before it reaches context. Direct callback to block 2
(context engineering): this is the same "context is a budget" argument, applied to a
hook instead of a CLAUDE.md rule.
-->

---
layout: code-live
heading: "PreToolUse deny rules"
filePath: ".claude/settings.json"
success: "Editing prisma/migrations/*, running rm, or reading .env* all get denied with a clear reason on stderr — before the tool ever runs."
---

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            // ⟵ LIVE: deny writes under prisma/migrations/** — it's
            // generated, use npm run db:migrate instead of hand-editing.
            "if": "___",
            "command": "___"
          }
        ]
      }
    ]
  }
}
```

<!--
FULL WORKING SOLUTION (trainer only — reference: workshop-artifacts/04-hooks/settings.json):

{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [{
          "type": "command",
          "if": "Edit(prisma/migrations/**) or Write(prisma/migrations/**)",
          "command": "echo 'Denied: prisma/migrations/* is generated. Run npm run db:migrate instead of hand-editing.' >&2; exit 2",
          "timeout": 5
        }]
      },
      {
        "matcher": "Bash",
        "hooks": [{
          "type": "command",
          "if": "Bash(rm *)",
          "command": "echo 'Denied: rm is blocked in this workshop sandbox.' >&2; exit 2",
          "timeout": 5
        }]
      },
      {
        "matcher": "Read",
        "hooks": [{
          "type": "command",
          "if": "Read(.env) or Read(.env.*)",
          "command": "echo 'Denied: .env holds SESSION_SECRET.' >&2; exit 2",
          "timeout": 5
        }]
      }
    ]
  }
}

Three separate matcher blocks, not one — each targets a different tool
(Edit/Write for the migrations guard, Bash for rm, Read for .env). Decision
values for hookSpecificOutput.permissionDecision are allow/deny/ask; the
reference implementation uses the simpler plain exit-2 form throughout, which
works identically. Demo live: try editing a file under prisma/migrations/,
watch it deny with the message on screen.
-->

---
layout: code-live
heading: "Stop: block while the build is red"
filePath: ".claude/hooks/build-gate.sh"
success: "The turn cannot end while npm run build fails — the agent sees the last lines of the failure and keeps working."
---

```bash
#!/usr/bin/env bash
set -euo pipefail

# ⟵ LIVE: run the build; exit 2 with the failure tail on stderr if it's red.
# This is a Stop hook — it gates the END of the turn, not a single tool call.
```

<!--
FULL WORKING SOLUTION (trainer only — reference: workshop-artifacts/04-hooks/build-gate.sh):

#!/usr/bin/env bash
set -euo pipefail

if npm run build >/tmp/clash-build.log 2>&1; then
  exit 0
fi

echo "npm run build is failing — the turn cannot end until it passes:" >&2
tail -n 40 /tmp/clash-build.log >&2
exit 2

Wire it in .claude/settings.json under "Stop" (no matcher needed — Stop has
no tool to match on):

  { "hooks": { "Stop": [{ "hooks": [{ "type": "command",
      "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/build-gate.sh",
      "timeout": 180 }] }] } }

Demo live: break the build on purpose (a stray type error is fine), try to
end the turn, watch Stop refuse and hand the agent the failure tail via
stderr on exit 2. Fix it, end the turn again, watch it succeed. This is the
one hook in the whole block that gates a TURN rather than a tool call —
worth naming that distinction explicitly.
-->

---
layout: task
number: "07"
heading: "Three more guardrail hooks"
goal: "Add a PreToolUse deny set, a noise-collapsing PostToolUse output replacement, and a Stop hook that blocks while the build is failing."
timebox: "10 min"
mode: "follow along"
qrSlug: "07-guardrail-hooks"
repoUrl: "github.com/pawsaw/claude-code-black-belt/tasks/07-guardrail-hooks.md"
success: "All three hooks fire correctly, and you can explain why hard_deny doesn't belong in this file."
---

<!--
Fast block — verify each of the three behaviors live if time allows (deny a migrations
edit, deny rm, deny reading .env, show collapsed build output, show a red Stop being
blocked then a green Stop succeeding), but don't let any one of them eat the other two's
time. This is a "show it works" task, not a "build it slowly" one — that was Task 06.
-->

---
layout: concept
heading: "Advice vs. law"
---

<G12SkillsVsHooks />

<!--
This is where the foreshadow from block 4 (00:50–01:18) pays off — if you showed this
diagram's skill side back then, this is the reveal of its other half.

Skills are advice. Hooks are law. A skill is what you'd tell a new colleague; a hook is
what CI would reject. If you find yourself repeating a rule in CLAUDE.md and the agent
keeps drifting past it anyway, that rule wanted to be a hook, not another paragraph.

3 minutes only. Mention auto mode and hard_deny in passing — get the subsystem right:
hard_deny lives in settings.autoMode, part of auto mode (a classifier model reviews
actions instead of you), not a PreToolUse decision. Name it, don't configure it live.
-->
