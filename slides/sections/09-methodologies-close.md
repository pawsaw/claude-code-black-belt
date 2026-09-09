---
layout: concept
heading: Two methodologies, one honest caveat
---

<!--
Block 9, 03:52–04:00 (8 min). This is contractual — it's in the published abstract. Honest
and short: two greenfield methodologies, set side by side, on a codebase that is explicitly
brownfield. That's the whole point of putting it last.
-->

---
layout: concept
heading: Spec Kit vs BMAD
lines:
  - "Spec Kit — low ceremony, agent-agnostic, Python/uv tool"
  - "BMAD v6 — 5 named agents, heavyweight, maps onto roles you already have"
  - "Both are greenfield methods — CLASH is brownfield"
---

<G20SpecKitVsBmad />

<!--
Spec Kit — GitHub, MIT, ~134k stars (not ~90k — corrected against a live gh api check),
agent-agnostic, `specify init`, low ceremony. Specs as version-controlled markdown any agent
can consume. It's a Python/uv tool, not npm: `uv tool install specify-cli --from
git+https://github.com/github/spec-kit.git` — a real prerequisite if anyone in the room only
has Node installed.

BMAD v6 (current, v6.12.0) ships 5 named agents — Analyst, PM, Architect, Developer, UX
Designer (a 6th, Technical Writer, is on hiatus) — NOT "12+ personas," which is a stale
v4-era figure. Still genuinely heavyweight: reported real-world costs land around
$800–2000 per developer per month on frontier models. Canonical repo is
bmad-code-org/BMAD-METHOD (the older bmadcode/BMAD-METHOD now redirects there).

Rule of thumb: Spec Kit when you want spec discipline without process overhead. BMAD when
your organisation already has those roles and you're mapping onto them rather than
simulating them. BMAD won't conjure a process you don't have; it'll reproduce your chaos
across those roles.

Say the honest thing out loud: both are greenfield methodologies and CLASH is brownfield.
That's why they came last, and why the four hours before were about control rather than
ceremony.
-->

---
layout: concept
heading: What we deliberately didn't cover
lines:
  - "/loop, Remote Control, claude agents, /skill-doctor"
  - "Output styles, the SDK hands-on"
---

<!--
One slide, thirty seconds. Naming these respects the room's intelligence and pre-empts every
"why didn't you show X" in the feedback form: /loop, Remote Control, `claude agents`,
/skill-doctor (used once, in Block 3), output styles, the SDK hands-on (shown conceptually in
the previous section, not built). All worth knowing, none worth the minutes today.
-->

---
layout: concept
heading: Context is king. You push it, you own it.
---

<!--
The close. Two lines, said plainly, no diagram needed — this is the last thing the room sees,
keep it sparse and weighty. Everything today was one throughline: treated carelessly, the
context window fills with noise until the agent drifts; treated as a resource you engineer,
it becomes the biggest lever you have. Skills, subagents, hooks, MCP, workflows — every
primitive from the map at 00:10 was a different way of managing that one constraint. You push
the agent's context. You own what happens because of it.
-->
