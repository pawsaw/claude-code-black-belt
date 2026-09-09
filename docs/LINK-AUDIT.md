# Link audit

Every URL in the reference list was fetched live on 2026-09-09, the morning of delivery.

**Method note:** `code.claude.com/docs/en/*` is a client-rendered SPA shell that returns
HTTP 200 for nonexistent paths. Raw status codes are therefore meaningless for that host —
every docs URL below was verified by checking the resolved `<title>` and page content, not
the status code alone.

Legend: ✅ live and correct as written · 🔁 live but redirects (target given) · ⚠️ live but
the spec's original URL/claim was wrong (correction given) · ❌ dead.

## Workshop & delivery

| URL | Status | Notes |
|---|---|---|
| `https://gitnation.com/contents/claude-code-black-belt-3` | ✅ | Confirms React Day Berlin 2026, 09 Sep 2026, Pawel Sawicki (TuneTrain.ai). Carries the full published abstract used in `README.md`. |
| `https://reactday.berlin/` | ✅ | Lists the workshop as "September 9, 15:00–19:00 CET, Remote via Zoom", free. |
| `https://www.nextacademy.io` | ✅ (302 to trailing-slash form, harmless) | |
| `https://www.nextacademy.io/trainers/pawel-sawicki` | ✅ | ⚠️ Bio framing differs from the GitNation listing (ML-engineer framing vs. TuneTrain.ai) — noted in `slides/BRAND.md`, not treated as an error to fix. |
| `https://www.nextacademy.io/workshops/topics/650679ee-dea8-47ea-a08c-11f9986e1e05` | ✅ | Topic "Agentic Software Engineering". |

## Codebase

| URL | Status | Notes |
|---|---|---|
| `https://github.com/pawsaw/clash` | ✅ | Public, 3 commits, `main` only prior to this workshop's branch preparation. ⚠️ No LICENSE file upstream — this repo does not claim to license CLASH. |

## Claude Code docs

| Spec's URL/claim | Status | Corrected URL |
|---|---|---|
| Docs root `https://code.claude.com/docs/en/` | ✅ | — |
| Dynamic workflows `.../workflows` | ✅ correct as written | — |
| Subagents `[VERIFY]` | ⚠️ | `https://code.claude.com/docs/en/sub-agents` — **not** `/agents`, which is a different page ("Run agents in parallel"). |
| Skills `[VERIFY]` | ✅ | `https://code.claude.com/docs/en/skills` |
| Hooks `[VERIFY]` | ⚠️ split | Guide: `https://code.claude.com/docs/en/hooks-guide` · Reference: `https://code.claude.com/docs/en/hooks` |
| MCP `[VERIFY]` | ✅ | `https://code.claude.com/docs/en/mcp` |
| Headless / SDK `[VERIFY]` | ⚠️ split | Headless: `https://code.claude.com/docs/en/headless` · Agent SDK: `https://code.claude.com/docs/en/agent-sdk/overview` |
| Settings reference `[VERIFY]` | ✅ | `https://code.claude.com/docs/en/settings-reference` |
| — (spec didn't list; needed for the deck) | ⚠️ | **Plan mode has no dedicated page.** It's documented under `https://code.claude.com/docs/en/permission-modes`. |
| — (spec didn't list; needed for the deck) | ⚠️ | **`/slash-commands` is not canonical** — it resolves to the Skills page. Use `https://code.claude.com/docs/en/commands`. |
| — (spec didn't list; needed for the deck) | ⚠️ new | Agent teams: `https://code.claude.com/docs/en/agent-teams` · Worktrees: `https://code.claude.com/docs/en/worktrees` · GitHub Actions: `https://code.claude.com/docs/en/github-actions` |
| "A harness for every task" blog | 🔁 | Canonical title/URL is `https://claude.com/blog/introducing-dynamic-workflows-in-claude-code`. |
| "How Anthropic teams use Claude Code" (`anthropic.com/news/...`) | 🔁 | Redirects to `https://claude.com/blog/how-anthropic-teams-use-claude-code` — use that form directly. |

## Browser tooling

| URL | Status | Notes |
|---|---|---|
| `https://github.com/vercel-labs/agent-browser` | ✅ repo live | Rust CLI ✅, Apache-2.0 ✅, accessibility-tree snapshots ✅, `npx skills add vercel-labs/agent-browser` ✅. ⚠️ **"~90% fewer tokens than Playwright MCP" is not in the README or any official Vercel source** — it's a third-party blog claim, and the blogs don't even agree with each other (82/90/93%). The deck states this qualitatively, not as a cited statistic. |
| `https://github.com/microsoft/playwright-mcp` | ✅ | |
| `https://github.com/ChromeDevTools/chrome-devtools-mcp` | ✅ correct as written despite the spec's `[VERIFY]` flag | |
| `https://modelcontextprotocol.io` | 🔁 | Redirects to a date-versioned spec path; link the bare domain, don't hardcode the versioned target. |

## Methodologies

| URL | Status | Notes |
|---|---|---|
| `https://github.com/github/spec-kit` | ✅ | MIT ✅. ⚠️ Star count is now ~134k, not the spec's implied lower figure. ⚠️ It is a **Python/`uv`** tool (`specify init`), not npm-installed — a real prerequisite for attendees. |
| BMAD-METHOD `[VERIFY]` | ⚠️ | Canonical repo is **`https://github.com/bmad-code-org/BMAD-METHOD`** — `bmadcode/BMAD-METHOD` redirects there. ⚠️ v6 (current, v6.12.0) ships **5 named agents**, not "12+ personas" — that figure is v4-era. License is MIT (GitHub's API reports "Other"/`NOASSERTION` only because of an added attribution paragraph). |

## Stack docs

All live, no redirects: `https://nextjs.org/docs` · `https://www.prisma.io/docs` ·
`https://ui.shadcn.com` · `https://leafletjs.com` · `https://zod.dev` · `https://sli.dev`.

## Summary

Of the spec's 20-odd reference URLs and `[VERIFY]` markers, **8 required a correction** before
appearing on a slide or in the README — 4 wrong/non-canonical Claude Code doc paths, 2 wrong
factual claims about third-party tools (BMAD personas, agent-browser token savings), 1 wrong
star-count/install-method claim (Spec Kit), and 1 silent redirect worth resolving to its
canonical form (the Anthropic blog post). None were outright dead.
