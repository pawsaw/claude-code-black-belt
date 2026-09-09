# Task 11 — Headless in CI

> **Block:** Letting go (03:43–03:48) · **Time-box:** 5 min · **Mode:** follow along
> **Reset branch:** `wk/06-start`

## Goal

Add a GitHub Action that runs the delegation ladder's security audit on every pull request,
using the official Claude Code Action rather than hand-scripting `claude -p`.

## Why this matters

You just ran the agent supervised, on stage, all afternoon. Headless is the same agent with
no one watching turn-by-turn — the control primitives from every earlier block (a scoped
prompt, the right tools, hooks as hard limits) carry over unchanged. CLASH's Actions tab is
genuinely empty right now; this task fills it with the one thing today has already earned:
the authorization audit, running automatically from now on.

## Starting point

`wk/06-start`. No `.github/workflows/` directory exists in CLASH yet — confirmed empty, not
a placeholder.

## Steps

1. Don't write `claude -p ...` directly into a workflow YAML. Use the maintained action,
   `anthropics/claude-code-action@v1` (not `@beta`, which is the legacy version — it dropped
   the `mode` input and renamed `direct_prompt` → `prompt`, `max_turns`/`model` →
   `claude_args`).
2. Create `.github/workflows/security-audit.yml` triggered on `pull_request`.
3. Pass the audit brief from Task 03/05 as the `prompt` input, and any model/turn overrides
   via `claude_args`, letting the action handle running headless for you.
4. Set up authentication — `anthropic_api_key` or a token from `claude setup-token` as
   `claude_code_oauth_token` — as a repository secret, and grant `id-token: write`.
5. Confirm the workflow is syntactically valid and would trigger correctly (you don't need a
   live API key to check the YAML shape).

## Prompts used

```
Write a GitHub Actions workflow at .github/workflows/security-audit.yml that
runs on every pull_request. Use anthropics/claude-code-action@v1 (not @beta).
Pass a prompt asking Claude to audit every exported Server Action in
app/actions/ changed by the PR for missing ownership checks on mutations of
existing rows, and to comment the findings on the PR. Authenticate with a
claude_code_oauth_token repository secret. Grant the permissions the action
needs, including id-token: write.
```

## Success criteria

- [ ] `.github/workflows/security-audit.yml` exists and targets `pull_request`
- [ ] It uses `anthropics/claude-code-action@v1`, not `@beta`, and not a raw `claude -p` shell step
- [ ] The `prompt` input restates the same ownership-check brief used in Task 03/05
- [ ] Authentication is via a repository secret, referenced by name, never a literal key in the YAML
- [ ] `id-token: write` is present in `permissions`

## If you fall behind

`git checkout wk/06-start`

## Going further

Extend the workflow to run the full dynamic-workflow fan-out from Task 05 instead of a
single prompt, and compare CI wall-clock and token cost against the single-prompt version.

## References

- Headless mode — https://code.claude.com/docs/en/headless
- GitHub Actions — https://code.claude.com/docs/en/github-actions
