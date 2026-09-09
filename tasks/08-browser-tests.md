# Task 08 — Browser tests with Playwright MCP

> **Block:** MCP and the browser (03:10–03:38) · **Time-box:** 16 min · **Mode:** follow along
> **Reset branch:** `wk/05-start`

## Goal

Use Playwright MCP against a running CLASH to write the test suite the README says doesn't
exist: join flow, host accept/reject, notification delivery.

## Why this matters

MCP is for when the agent needs to reach outside the repo. A browser is the clearest version
of that: the agent can't verify a user-facing flow by reading source, it has to actually
click through it. CLASH's own README lists "automated test suite" under intentionally out of
scope — this task closes that gap for real, against the actual seeded data.

## Starting point

`wk/05-start`. `npm run dev` running at `localhost:3000`, seeded with the 8 standard logins
(password `test` for all). The `playwright` MCP server was added in Task 00:
```bash
claude mcp add playwright -- npx -y @playwright/mcp@latest
```

## Steps

1. Confirm the MCP server is connected: `claude mcp list` should show `playwright`.
2. Pick two seeded users who can exercise a join/accept flow — any user who doesn't already
   host a clash the other one can join. Anna (`anna.schmidt@example.com`) hosting, another
   seeded user joining, works.
3. Ask Claude to drive the browser through the join flow first, narrating what it sees at
   each step, before asking it to write anything down as a test.
4. Once the flow is confirmed manually, have it write a Playwright test file capturing: a
   user requesting to join a clash, the host seeing and accepting the request, and the
   joining user receiving a notification.
5. Add the rejection path as a second test.
6. Run the suite and fix anything that fails for reasons unrelated to the app itself
   (timing, selectors) before concluding the app has a real bug.

## Prompts used

```
Using the Playwright MCP tools, log in at localhost:3000 as
anna.schmidt@example.com / test, open a clash she doesn't host, and request
to join it. Then log in as the host in a second context, accept the request,
and confirm the joining user sees a notification. Narrate each step before
writing any test code.
```

```
Now write that flow as a Playwright test file: request to join, host accepts,
joining user is notified. Add a second test for the host rejecting instead.
Use the seeded accounts and passwords from docs/SETUP.md.
```

## Success criteria

- [ ] Playwright MCP is connected and was used to drive a real browser, not just generate test code blind
- [ ] A test file exists covering: join request, host accept, notification delivery
- [ ] A second test covers the reject path
- [ ] Both tests pass against the seeded dev database

## If you fall behind

`git checkout wk/05-start`

## Going further

Add a third test for the case where a host tries to join their own clash — CLASH already
rejects this in `joinClash` ("You host this clash — you're already in.") — and confirm the
UI surfaces that message.

## References

- Playwright MCP — https://github.com/microsoft/playwright-mcp
- MCP — https://code.claude.com/docs/en/mcp
- MCP specification — https://modelcontextprotocol.io
