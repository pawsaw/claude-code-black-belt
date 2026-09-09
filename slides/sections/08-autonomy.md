---
layout: concept
heading: Letting go of the wheel
lines:
  - "Two things done properly, not five things listed"
  - "Minute 218 of 240 — a firehose here undoes the afternoon"
---

<!--
Block 8, 03:38–03:52 (14 min). Say this framing explicitly: this is the lowest-attention
point in the room all day. Worktrees (5 min) and headless CI (5 min) get full treatment,
follow-along. The Agent SDK gets 4 minutes, conceptual only, no build. Everything else named
today gets one slide at the very end, not demoed.
-->

---
layout: concept
heading: One repo, N isolated agents
lines:
  - "claude --worktree <name> (alias -w)"
  - "Isolated copy under .claude/worktrees/<name>/, on branch worktree-<name>"
---

<G18WorktreeParallelism />

<!--
This is the one thing from today most people will actually use tomorrow morning. Every
orchestration strategy in Block 5 shared one working tree; worktrees let you run several
agents on genuinely separate branches of the same repo in parallel, with no risk of one
agent's half-finished edit corrupting another's. Give it the time — don't rush past it.
-->

---
layout: task
number: "10"
heading: Worktrees
goal: Run two agents on the same repository at the same time without them colliding, using claude --worktree.
timebox: 5 min
mode: follow along
qrSlug: 10-worktrees
repoUrl: github.com/pawsaw/claude-code-black-belt/tasks/10-worktrees.md
success: Two sessions ran in parallel without touching each other's uncommitted work, and you can name where the worktree lives and its branch name.
---

<!--
Starting point: wk/06-start — the finished state of the delegation-ladder and hooks blocks.

Prompt 1 (first terminal): `claude --worktree avatar-followup`
This creates an isolated copy of the repo under .claude/worktrees/avatar-followup/ on a new
branch worktree-avatar-followup, and starts Claude Code inside it.

Prompt 2 (second terminal, separate worktree): pick up the Task 09 going-further extension
("Pick up the avatar CDN sketch from Task 09's going-further section and start roughing it
out — don't worry about the main working tree.")

Make an edit in each session and confirm neither can see or interfere with the other's
uncommitted changes — they're on different branches in different directories.

Mention without demoing live: `isolation: worktree` in a subagent's frontmatter runs that
subagent in its own worktree automatically, and the EnterWorktree/ExitWorktree tools let an
agent manage this itself mid-session. Going further at home: `claude --worktree "#<pr-number>"`
against an open PR reference changes the worktree's starting point.
-->

---
layout: concept
heading: Headless in CI
lines:
  - "CLASH's Actions tab is empty — zero workflows, zero runs"
  - "anthropics/claude-code-action@v1, not @beta, not a raw claude -p in the YAML"
---

<!--
"Headless" means no human watching — the same agent that just paired with you on stage,
running unattended, triggered by an event instead of a keystroke. CLASH's .github/workflows/
is confirmed empty — no directory at all, zero Actions runs. Fill it with the security audit
from Block 5, now running on every PR. The workshop's centrepiece becomes permanent
infrastructure — that's the closing image for the autonomy thread.

CORRECTED, and the whole point of the next slide: don't put `claude -p` directly in a
workflow YAML. Use the maintained action, anthropics/claude-code-action@v1 — NOT @beta,
which is legacy and dropped the `mode` input, renaming direct_prompt -> prompt and
max_turns/model -> claude_args. You pass `prompt` and `claude_args`; the action runs
headless for you.
-->

---
layout: code-live
heading: "GitHub Action: audit on every PR"
filePath: ".github/workflows/security-audit.yml"
success: "The workflow targets pull_request, uses anthropics/claude-code-action@v1 (not @beta), and authenticates via a named repository secret — never a bare claude -p."
---

```yaml
name: Security audit
on:
  pull_request:

jobs:
  audit:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      id-token: write
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          # ⟵ LIVE: this is NOT `claude -p` in a run: step — the action
          # supplies headless mode. Fill in the prompt and the auth secret.
          prompt: "___"
          claude_args: "___"
```

<!--
FULL WORKING SOLUTION (trainer only — verbatim brief from tasks/11-headless-ci.md):

      - uses: anthropics/claude-code-action@v1
        with:
          prompt: |
            Audit every exported Server Action in app/actions/ changed by
            this PR for missing ownership checks on mutations of existing
            rows. Comment the findings on the PR.
          claude_args: "--model claude-sonnet-5"
        env:
          CLAUDE_CODE_OAUTH_TOKEN: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}

Same audit brief as Task 03/05, now running automatically instead of live on
stage. Say the correction plainly while typing: there is no `run: claude -p
"..."` step here — `@beta` was the legacy form that worked that way; `@v1`
is a proper action with typed inputs, and the action itself invokes Claude
headlessly. Authenticate via a named repository secret
(CLAUDE_CODE_OAUTH_TOKEN, via `claude setup-token`), never a hardcoded key.
`id-token: write` is required for OIDC.

Confirm the YAML shape is valid — a live token isn't required to check that
it would trigger correctly on a real PR. Going further at home: swap the
single prompt for the full dynamic-workflow fan-out from Task 05 and compare
CI wall-clock and token cost.
-->

---
layout: task
number: "11"
heading: Headless in CI
goal: Add a GitHub Action that runs the delegation ladder's security audit on every pull request, using the official Claude Code Action rather than hand-scripting claude -p.
timebox: 5 min
mode: follow along
qrSlug: 11-headless-ci
repoUrl: github.com/pawsaw/claude-code-black-belt/tasks/11-headless-ci.md
success: ".github/workflows/security-audit.yml exists, targets pull_request, uses anthropics/claude-code-action@v1 (not @beta), and authenticates via a named repository secret."
---

<!--
Prompt: "Write a GitHub Actions workflow at .github/workflows/security-audit.yml that runs on
every pull_request. Use anthropics/claude-code-action@v1 (not @beta). Pass a prompt asking
Claude to audit every exported Server Action in app/actions/ changed by the PR for missing
ownership checks on mutations of existing rows, and to comment the findings on the PR.
Authenticate with a claude_code_oauth_token repository secret. Grant the permissions the
action needs, including id-token: write."

Same audit brief as Task 03/05, now running automatically instead of live on stage. Confirm
the YAML shape is valid — a live API key isn't required to check that it would trigger
correctly. Going further at home: swap the single prompt for the full dynamic-workflow
fan-out from Task 05 and compare CI wall-clock and token cost.
-->

---
layout: concept
heading: The Agent SDK bridge
lines:
  - "Same idea, one level down — the agent lives inside your software, not beside it"
  - "Every control primitive from today carries over unchanged"
---

<G19AutonomyLevels />

<!--
4 minutes, conceptual only, no build — say that up front so nobody expects a demo. You just
ran the agent headless in a pipeline; the Agent SDK is the same idea one level further in:
the agent lives inside your application instead of beside it. Imagine CLASH answering "find
me something outdoors in Kreuzberg this evening" over its own map, live, as a feature.

The point for this room: context budget, subagent isolation, hooks as hard limits — every
primitive from today carries over unchanged, just hosted differently. Show the shape.
Building it is a different workshop.
-->

---
layout: concept
heading: Named but not demoed
lines:
  - "/loop, Remote Control, claude agents dashboard, /skill-doctor"
  - "Worth knowing, none worth the minutes at this point in the day"
---

<!--
Moved to a slide, not demoed: /loop for continuous triage, Remote Control and the
`claude agents` dashboard, /skill-doctor (already used once, back in Block 3). All worth
knowing, none worth the minutes at minute 222 of 240. Name them, link them, move on — the
final "what we deliberately didn't cover" slide in the next section reinforces this same
point once more before the close.
-->
