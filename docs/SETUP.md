# Pre-flight — do this **before** the workshop starts

> **Claude Code: Black Belt** · nextacademy.io · React Day Berlin 2026
> Time needed: ~15 minutes. Do it on the wifi you trust, not the conference wifi.

Conference wifi plus `npm install` plus `npx` MCP downloads will eat the first fifteen
minutes of a four-hour workshop. Everything below is front-loaded so that at 15:00 we start
with the interesting part.

---

## 1. Get the codebase

We work inside **CLASH** — a fully built Next.js 16 / React 19 / Prisma 7 + SQLite
application. You are **not** building it. You are extending it.

The workshop runs on the `wk/*` branches, **never on `main`**. These branches carry the
workshop's starting state and are also your catch-up mechanism.

```bash
git clone https://github.com/pawsaw/clash
cd clash
git checkout wk/00-start
npm install
```

> `npm install` runs `prisma generate` as a `postinstall` step, which writes the Prisma
> client to `lib/generated/prisma`. That directory is gitignored, so this step is **not
> optional** — nothing type-checks until it has run.

## 2. Create your `.env`

`.env` is gitignored, so it does not arrive with the clone. **The app throws on startup
without it** (`SESSION_SECRET environment variable is not set.`).

```bash
cat > .env <<'EOF'
DATABASE_URL="file:./dev.db"
SESSION_SECRET="black-belt-workshop-secret"
EOF
```

## 3. Create and seed the database

```bash
npm run db:migrate
npm run db:seed
```

The seed is destructive and idempotent — rerun it any time you want a clean slate.

## 4. Start the app and log in

```bash
npm run dev          # confirm http://localhost:3000 loads
```

**Seeded logins — 8 users, all with password `test`:**

| Email | Name |
|---|---|
| `anna.schmidt@example.com` | Anna Schmidt |
| `lukas.mueller@example.com` | Lukas Müller |
| `sophie.weber@example.com` | Sophie Weber |
| `max.fischer@example.com` | Max Fischer |
| `emma.wagner@example.com` | Emma Wagner |
| `leon.becker@example.com` | Leon Becker |
| `mia.hoffmann@example.com` | Mia Hoffmann |
| `noah.schneider@example.com` | Noah Schneider |

Use **`anna.schmidt@example.com` / `test`** unless a task says otherwise.

## 5. Check your Claude Code version

```bash
claude --version
```

**You need `2.1.252` or newer.** Older versions will fail specific blocks:

| Feature | Minimum version |
|---|---|
| Dynamic workflows (introduced) | 2.1.154 |
| `/workflow-authoring` skill | 2.1.248 |
| `/skill-doctor` | **2.1.252** |

If you are behind, upgrade now — not at 15:00.

---

## 6. Two settings you must change — this is the part people skip

### 6a. Turn **Dynamic workflows** ON

Dynamic workflows are the centrepiece of the afternoon (block 5, 72 minutes). They are
available on all paid plans, but **off by default on Pro**.

Inside Claude Code:

```
/config
```

Find the **Dynamic workflows** row and turn it **on**.

> If half the room skips this, the centrepiece fails for half the room. Please do it now.

Verify: type `/` and confirm workflow-related entries appear, or run `/config` again and
check the row reads as enabled.

### 6b. Enable **agent teams** (experimental, off by default)

Block 5 also demos agent teams. They are **experimental and disabled by default** — without
this flag Claude silently spawns ordinary subagents instead, and the whole point of the demo
(two peers disagreeing, the lead reconciling) never happens.

Add to `~/.claude/settings.json`:

```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

If that file already has an `env` block, add the key to it rather than replacing the block.
Restart Claude Code afterwards.

> This one is *watch-only* in the room — if you'd rather not enable an experimental flag on
> your machine, you can simply watch this segment. Everything else is hands-on.

---

## 7. Pre-install the MCP servers

Block 8 uses two MCP servers. Install them **now** so `npx` isn't downloading over
conference wifi mid-demo.

```bash
claude mcp add playwright -- npx -y @playwright/mcp@latest
claude mcp add chrome-devtools -- npx -y chrome-devtools-mcp@latest
```

Warm the caches and confirm both register:

```bash
npx -y @playwright/mcp@latest --help >/dev/null 2>&1 || true
npx -y chrome-devtools-mcp@latest --help >/dev/null 2>&1 || true
claude mcp list
```

Playwright also needs a browser binary:

```bash
npx -y playwright install chromium
```

---

## 8. Know your reset branches

There is **no silent catch-up time** in a code-along. If you fall behind, don't debug — reset
and rejoin. Each branch is the state at the **start** of that block.

| Branch | State at start of | Covers tasks |
|---|---|---|
| `wk/00-start` | Workshop baseline | Task 00 |
| `wk/01-start` | Context engineering | Task 01 |
| `wk/02-start` | Skills | Task 02 |
| `wk/03-start` | The delegation ladder | Tasks 03, 04, 05 |
| `wk/04-start` | Hooks | Tasks 06, 07 |
| `wk/05-start` | MCP and the browser | Tasks 08, 09 |
| `wk/06-start` | Letting go | Tasks 10, 11 |
| `wk/07-start` | Finished state — the answer key | — |

```bash
git checkout wk/04-start      # rejoin at the hooks block
```

Your own work is on you — commit or stash before switching if you want to keep it.

---

## 9. One naming trap, said once, early

CLASH has a top-level **`hooks/`** directory. Those are **React hooks** (`hooks/use-mobile.ts`).

**Claude Code hooks** are something completely different — shell commands bound to lifecycle
events, configured in `.claude/settings.json`.

Both will be on screen today. We will always say *React hook* or *Claude Code hook*, never
just "hook".

---

## Pre-flight checklist

- [ ] `git checkout wk/00-start` succeeded
- [ ] `npm install` completed and `lib/generated/prisma` exists
- [ ] `.env` created with `DATABASE_URL` and `SESSION_SECRET`
- [ ] `npm run db:migrate` and `npm run db:seed` completed
- [ ] `npm run dev` serves http://localhost:3000 and you can log in as Anna
- [ ] `claude --version` reports **2.1.252+**
- [ ] `/config` → **Dynamic workflows** is **ON**
- [ ] `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is set (or you've opted to watch that segment)
- [ ] `claude mcp list` shows `playwright` and `chrome-devtools`

---

## A note for Pro-plan users

Agent teams and dynamic workflows are **token-hungry** — that is the honest tradeoff of the
delegation ladder, and we say the numbers out loud during block 5. If you are on Pro, you may
hit a usage limit during the afternoon. That is not a failure of your setup.

If it happens: stop running the fan-out, watch the trainer's screen for that segment, and
rejoin at the next reset branch. Nothing later in the workshop depends on you personally
having completed the workflow run.

---

## Trouble?

| Symptom | Fix |
|---|---|
| `SESSION_SECRET environment variable is not set.` | Step 2 — create `.env` |
| `Cannot find module '@/lib/generated/prisma'` | Re-run `npm install` (triggers `prisma generate`) |
| `npx tsc --noEmit` fails right after clone | Same — the Prisma client hasn't been generated yet |
| Login fails for every user | Re-run `npm run db:seed` |
| Map tiles blank | Expected without network; the rest of the app works offline |
| No workflow option in `/config` | Upgrade Claude Code to 2.1.252+ |

Still stuck at 15:00? Say so in the chat at the start — we will not leave you behind on setup.
