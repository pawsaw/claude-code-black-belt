---
layout: section
heading: "Skills"
current: skill
---

<template #map>
  <ToolkitMap current="skill" />
</template>

<!--
00:50–01:18, 28 min. Divider slide, "Skill" row highlighted. Say: "you don't start cold
here either — CLASH already ships nine vendored skills. We're adding one that's ours."
-->

---
layout: concept
heading: "Progressive disclosure"
lines:
  - "Every skill's name + description is scanned every session — cheap, always there"
  - "The body only loads when the description matches what you asked for"
---

<G05SkillLoading />

<!--
This is the mechanism that makes skills cheap at scale: the description lives in context
whether or not you use the skill, but the (often much larger) body only loads on a match,
and then persists for the rest of the session. Point back at /skill-doctor from the last
block — that's what it's actually measuring: how many descriptions you're paying for
versus how many bodies ever get pulled in.
-->

---
layout: concept
heading: "Commands merged into skills — but nothing broke"
lines:
  - ".claude/commands/deploy.md and .claude/skills/deploy/SKILL.md both create /deploy"
  - "Existing command files keep working identically — not deprecated"
---

<!--
Correct a common misconception here, explicitly: custom commands merging into skills does
NOT mean .claude/commands/*.md files stop working. They produce the exact same /command
today. Skills are the richer format for new work — bundled files, allowed-tools,
context: fork — but nobody needs to migrate existing commands to keep them working.
-->

---
layout: code-live
heading: "Author the clash-feature skill"
filePath: ".claude/skills/clash-feature/SKILL.md"
success: "The skill's steps trace to real CLASH files at every stage — no invented paths"
---

```md
---
name: clash-feature
description: <!-- ⟵ LIVE: one sentence, specific enough that /skill-doctor's
  matching has something real to key off -->
allowed-tools: Read, Edit, Write, Grep, Glob, Bash(npm run *) Bash(npx prisma *) Bash(npx tsc *)
---

# Adding a feature to CLASH

## Steps

<!-- ⟵ LIVE: the ten-step recipe — Prisma model, migration, constants,
     Zod schema, lib/data/ read helper, Server Action WITH ITS OWN AUTH CHECK,
     RSC page, shadcn component, revalidatePath, notification emit -->
```

<!--
FULL WORKING SOLUTION (trainer only): the complete file is at
workshop-artifacts/03-skills/SKILL.md in the workshop repo — read it onto the screen
step by step rather than pasting it whole, so the room sees it built rather than
revealed. Key beat, do not rush past it: when you reach the Server Action step, stop and
say out loud *why* it insists on its own ownership check even though requireUser() already
runs in the layout — restate the exact argument from block 5's setup, before block 5 has
even happened, as a plant: "a Server Action is a public POST endpoint with a generated ID;
the layout guard never sees a direct call to it." This is the single most important
sentence in the whole skill, and repeating it here means it lands twice.
-->

---
layout: concept
heading: "A skill is advice"
lines:
  - "Nothing stops an agent from skipping a step in a skill if it decides to"
  - "Keep that in mind — we come back to this in block 6"
---

<G12SkillsVsHooks />

<!--
Foreshadow only — don't fully develop this yet, that's block 6's job. One line is enough:
"a skill is what you'd tell a new colleague. It's advice, not law. Hold that thought."
-->

---
layout: concept
heading: "Ship something small, end to end"
lines:
  - "Venue favourites: a Favourite model, a toggle action, a list on the profile page"
  - "Compare the /context delta against the cold open — this should be visibly tighter"
---

<!--
Invoke the skill for real: "/clash-feature Add venue favourites: a user can favourite a
venue from its detail page and see a list of their favourites on their profile." Let it
run. When it's done, run /context again and put the two numbers next to each other —
this feature touched maybe 6 files versus the cold open's 40, on the same kind of task.
That contrast is the entire pitch for skills, made visible rather than asserted.
-->

---
layout: task
number: "02"
heading: "The clash-feature skill"
goal: "Author a clash-feature skill that encodes CLASH's end-to-end feature recipe, then use it to ship one small feature."
timebox: "28 min"
mode: "follow along"
qrSlug: "02-clash-feature-skill"
repoUrl: "github.com/pawsaw/claude-code-black-belt/tasks/02-clash-feature-skill.md"
success: "One real feature ships end-to-end using the skill, and tsc/lint/build all pass"
---

<!--
Task-02 recap slide. Reset branch if anyone's behind: wk/02-start (already has Task 01's
CLAUDE.md in place, so nobody restarts from zero context).
-->
