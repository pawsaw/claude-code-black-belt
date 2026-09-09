---
layout: section
heading: MCP and the browser — closing the loop
current: mcp
---

<template #map>
  <ToolkitMap current="mcp" />
</template>

<!--
Block 7, 03:10–03:38 (28 min). MCP is for when the agent needs to reach outside the repo — a
browser is the clearest version of that: it can't verify a user-facing flow by reading source,
it has to click through it. Two tasks here: Playwright MCP for correctness (Task 08, 16 min),
Chrome DevTools MCP for performance (Task 09, 12 min). Both close the same loop — change,
verify in a real browser, fix, no human in between.
-->

---
layout: concept
heading: Your systems, as tools
lines:
  - "Claude Code ↔ MCP servers ↔ browser / external systems"
  - "MCP is the protocol boundary — not the tool itself"
---

<G15McpTopology />

<!--
Pre-installed in Task 00 so npx isn't downloading live over conference wifi:

  claude mcp add playwright -- npx -y @playwright/mcp@latest
  claude mcp add chrome-devtools -- npx -y chrome-devtools-mcp@latest

Confirm both show up with `claude mcp list` before starting the block. Point out: MCP servers
are a protocol boundary between Claude Code and something external — Playwright MCP controls
a real browser against localhost:3000, Chrome DevTools MCP controls the DevTools protocol
directly. Neither is "the tool" — they're both bridges to something outside the repo.
-->

---
layout: code-live
heading: "Register the browser MCP servers"
filePath: "terminal — claude mcp add"
success: "claude mcp list shows both playwright and chrome-devtools before the block starts, so npx isn't downloading live over conference wifi."
---

```bash
# ⟵ LIVE: register both servers, then confirm they're listed.
claude mcp add playwright -- ___
claude mcp add chrome-devtools -- ___

claude mcp list
```

<!--
FULL WORKING SOLUTION (trainer only — this should already be done from Task 00's
pre-flight; if anyone in the room skipped it, this is the moment to catch up):

claude mcp add playwright -- npx -y @playwright/mcp@latest
claude mcp add chrome-devtools -- npx -y chrome-devtools-mcp@latest

claude mcp list
# should show both: playwright, chrome-devtools

Say plainly: MCP registration is a one-time terminal command, not a config
file you hand-author — that's why this slide is a command skeleton rather
than a JSON/YAML skeleton like the hooks block. Each server is a bridge to
something outside the repo: Playwright MCP drives a real browser against
localhost:3000, Chrome DevTools MCP speaks the DevTools protocol directly.
-->

---
layout: task
number: "08"
heading: Browser tests with Playwright MCP
goal: Use Playwright MCP against a running CLASH to write the test suite the README says doesn't exist — join flow, host accept/reject, notification delivery.
timebox: 16 min
mode: follow along
qrSlug: 08-browser-tests
repoUrl: github.com/pawsaw/claude-code-black-belt/tasks/08-browser-tests.md
success: Both tests pass against the seeded dev database, and Playwright MCP actually drove a real browser rather than generating test code blind.
---

<!--
Starting point: wk/05-start. npm run dev running at localhost:3000, all 8 seeded logins,
password "test" for all. Pick Anna (anna.schmidt@example.com) as host, another seeded user
joining.

First prompt — drive the browser manually, narrate before writing anything:
"Using the Playwright MCP tools, log in at localhost:3000 as anna.schmidt@example.com / test,
open a clash she doesn't host, and request to join it. Then log in as the host in a second
context, accept the request, and confirm the joining user sees a notification. Narrate each
step before writing any test code."

Second prompt — once the flow is confirmed manually:
"Now write that flow as a Playwright test file: request to join, host accepts, joining user
is notified. Add a second test for the host rejecting instead. Use the seeded accounts and
passwords from docs/SETUP.md."

Going further (mention, don't demo): CLASH already rejects a host trying to join their own
clash ("You host this clash — you're already in.") in joinClash — a third test could confirm
the UI surfaces that message.
-->

---
layout: code-live
heading: "Prompt: generate the join-flow test"
filePath: "prompt to Claude Code — after the manual walkthrough is confirmed"
success: "The prompt names both outcomes (accept and reject) and points at the real seeded accounts — Claude writes the spec file from this, not from a guess."
---

```txt
Now write that flow as a Playwright test file: request to join, host
accepts, joining user is notified.

<!-- ⟵ LIVE: add the second case and the account source before sending —
     a reject path, and where the seeded credentials actually live. -->
```

<!--
FULL WORKING SOLUTION (trainer only — verbatim from tasks/08-browser-tests.md):

"Now write that flow as a Playwright test file: request to join, host
accepts, joining user is notified. Add a second test for the host rejecting
instead. Use the seeded accounts and passwords from docs/SETUP.md."

This prompt only makes sense after the PRECEDING manual walkthrough
("Using the Playwright MCP tools, log in as anna.schmidt@example.com / test,
open a clash she doesn't host, and request to join it...") — say that
sequence out loud: drive it manually and narrate first, confirm the flow
works, THEN ask for the test file. Generating test code before confirming
the flow by hand is exactly the "blind test generation" this loop is meant
to avoid.

Going further, mention don't demo: CLASH already rejects a host trying to
join their own clash ("You host this clash — you're already in.") in
joinClash — a third test could confirm the UI surfaces that message.
-->

---
layout: task
number: "09"
heading: The avatar performance fix
goal: Use Chrome DevTools MCP to measure a real performance bug in CLASH, then fix it.
timebox: 12 min
mode: follow along
qrSlug: 09-perf-avatars
repoUrl: github.com/pawsaw/claude-code-black-belt/tasks/09-perf-avatars.md
success: Chrome DevTools MCP confirms a measured — not assumed — drop in payload size, and tsc/lint/build all still pass.
---

<!--
The bug is not hypothetical — read it before measuring it:
- prisma/schema.prisma: User.avatar is a String? documented "Base64 data URL of an uploaded
  avatar; null => render initials."
- app/actions/profile.ts: MAX_AVATAR_LENGTH = 1_500_000 — up to ~1.1MB decoded is allowed.
- lib/auth.ts: getCurrentUser() selects avatar: true on every call, wrapped in React's cache().
- app/(app)/layout.tsx: calls requireUser() -> getCurrentUser() on every authenticated page.

Put together: up to ~1.5MB of base64 rides in the RSC payload on every single page load, for
a value the layout itself never renders.

First prompt: "Using the Chrome DevTools MCP tools, log in at localhost:3000 and load the
dashboard. Capture the network payload size for the initial page load and identify how much
of it is the avatar field on the User selected via getCurrentUser in lib/auth.ts."

Second prompt (the fix): "getCurrentUser() in lib/auth.ts selects avatar on every call, and
it's called by requireUser() on every authenticated page via app/(app)/layout.tsx, even
though most pages never render the user's own avatar as an image. Fix this: stop selecting
avatar in the identity/session check, and load it separately only where it's actually
displayed."

Third prompt: "Re-measure the same page load with Chrome DevTools MCP and confirm the payload
size dropped."

Measure before touching code, fix, re-measure. This is the same "no human in the loop" close
that Task 08 demonstrates for correctness, now for performance.
-->

---
layout: concept
heading: The loop that matters
lines:
  - "Change → browser → observe → fix"
  - "No human in the loop"
---

<G16VerificationLoop />

<!--
Zoom out from both tasks: this is the general shape. Change the code, verify in a REAL
browser (not by reading source and hoping), observe what actually happened (screenshot,
network payload, console), fix based on evidence, and the loop closes without a human
manually re-checking every step in between. This is what "MCP reaches outside the repo"
actually buys you in practice.
-->

---
layout: concept
heading: Four browser tools, one comparison
lines:
  - "Playwright MCP — E2E test authoring"
  - "Chrome DevTools MCP — perf and network"
  - "Claude in Chrome / Agent Browser — visual checks, leaner output"
---

<G17BrowserToolComparison />

<!--
Slide-only, no live demo of Agent Browser today. Four tools, different jobs: Playwright MCP
for E2E test authoring (what we just did), Chrome DevTools MCP for perf/network debugging
(what we just did), Claude in Chrome for authenticated visual checks using your existing
browser login state, and Vercel's Agent Browser (a Rust CLI, Apache-2.0, accessibility-tree
snapshots) for general automation with a leaner token footprint than a full MCP DOM dump.

CORRECTED — say this carefully: the oft-cited "~90% fewer tokens than Playwright MCP" is NOT
an official Vercel claim. It does not appear anywhere in the agent-browser README, and
third-party estimates disagree with each other (82-93%). State the advantage qualitatively —
compact accessibility-tree snapshots vs. full MCP tool schemas plus DOM — or measure it live
if there's time. Don't cite a number you can't source.

Install, if anyone asks: npx skills add vercel-labs/agent-browser.
-->
