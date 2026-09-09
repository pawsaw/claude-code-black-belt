# Task 00 — Setup

> **Block:** Pre-flight (before 00:00) · **Time-box:** ~15 min, before doors open · **Mode:** follow along
> **Reset branch:** `wk/00-start`

## Goal

Have CLASH running locally, Claude Code configured correctly, and MCP servers pre-installed
before the workshop starts.

## Why this matters

Conference wifi plus `npm install` plus `npx` MCP downloads will eat the first fifteen
minutes of a four-hour workshop if you do them live. Two settings in particular —
Dynamic workflows and the agent-teams experimental flag — are off by default and silently
degrade later blocks if you skip them. There is no silent work time in a code-along to catch
up on this later.

## Starting point

A machine with `git`, `node`, and `npm` installed. Nothing else.

## Steps

1. Clone CLASH and check out the workshop's starting branch — **not** `main`.
   ```bash
   git clone https://github.com/pawsaw/clash
   cd clash
   git checkout wk/00-start
   ```
   You should see a normal `git checkout` confirmation switching to `wk/00-start`.
2. Install dependencies. This also runs `prisma generate` as a `postinstall` step, writing
   the Prisma client to `lib/generated/prisma` (gitignored — nothing type-checks without it).
   ```bash
   npm install
   ```
3. Create `.env`. It's gitignored, so it never arrives with the clone, and the app throws on
   startup without it.
   ```bash
   cat > .env <<'EOF'
   DATABASE_URL="file:./dev.db"
   SESSION_SECRET="black-belt-workshop-secret"
   EOF
   ```
4. Create and seed the database.
   ```bash
   npm run db:migrate
   npm run db:seed
   ```
   You should see `Seed complete: 8 users, 8 venues, 8 clashes.`
5. Start the dev server and confirm you can log in.
   ```bash
   npm run dev
   ```
   Open `http://localhost:3000`, log in as `anna.schmidt@example.com` / `test`.
6. Check your Claude Code version.
   ```bash
   claude --version
   ```
   You need **2.1.252 or newer** — earlier builds are missing `/workflow-authoring` (needs
   2.1.248+) and `/skill-doctor` (needs 2.1.252). Upgrade now if you're behind.
7. Turn on **Dynamic workflows** — off by default on Pro.
   ```
   /config
   ```
   Find the Dynamic workflows row and enable it. This is the single most common thing people
   forget, and it silently breaks the block 5 centrepiece for anyone who skips it.
8. Enable agent teams (experimental, off by default). Add to `~/.claude/settings.json`:
   ```json
   { "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" } }
   ```
   If you'd rather not enable an experimental flag on your machine, that's fine — the agent
   teams segment (Task 04) is watch-only anyway.
9. Pre-install the MCP servers used in block 7.
   ```bash
   claude mcp add playwright -- npx -y @playwright/mcp@latest
   claude mcp add chrome-devtools -- npx -y chrome-devtools-mcp@latest
   npx -y playwright install chromium
   claude mcp list
   ```
   You should see both `playwright` and `chrome-devtools` listed.

## Prompts used

None — this task is pure environment setup, no prompting yet.

## Success criteria

- [ ] `npm run dev` serves `http://localhost:3000` and you can log in as Anna
- [ ] `claude --version` reports 2.1.252 or newer
- [ ] `/config` shows Dynamic workflows **on**
- [ ] `claude mcp list` shows `playwright` and `chrome-devtools`
- [ ] You know whether agent teams are enabled on your machine or you're planning to watch that segment

## If you fall behind

`git checkout wk/00-start` — this is the branch you should already be on; if setup goes
wrong, delete `node_modules` and `dev.db`, and repeat from step 2.

## Going further

Read `docs/SETUP.md` at the root of this workshop repository for the full pre-flight,
including the seeded-login table for all 8 users and a troubleshooting table for common
first-run errors.

## References

- Dynamic workflows — https://code.claude.com/docs/en/workflows
- Agent teams — https://code.claude.com/docs/en/agent-teams
- Settings reference — https://code.claude.com/docs/en/settings-reference
- CLASH — https://github.com/pawsaw/clash
