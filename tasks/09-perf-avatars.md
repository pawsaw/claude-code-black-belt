# Task 09 — The avatar performance fix

> **Block:** MCP and the browser (03:10–03:38) · **Time-box:** 12 min · **Mode:** follow along
> **Reset branch:** `wk/05-start`

## Goal

Use Chrome DevTools MCP to measure a real performance bug in CLASH, then fix it.

## Why this matters

This closes the same loop as Task 08 — change, verify in a real browser, fix, no human in
between — but for performance rather than correctness. The bug is not hypothetical: it's
sitting in `lib/auth.ts` right now.

## Starting point

`wk/05-start`. `npm run dev` running. The `chrome-devtools` MCP server was added in Task 00:
```bash
claude mcp add chrome-devtools -- npx -y chrome-devtools-mcp@latest
```

## Steps

1. Confirm the server is connected: `claude mcp list` should show `chrome-devtools`.
2. Read the bug before measuring it, so you know what you're looking for:
   - `prisma/schema.prisma`: `User.avatar` is a `String?` documented as *"Base64 data URL of
     an uploaded avatar; null => render initials."*
   - `app/actions/profile.ts`: `MAX_AVATAR_LENGTH = 1_500_000` — up to ~1.1MB decoded is
     allowed per avatar.
   - `lib/auth.ts`: `getCurrentUser()` `select`s `avatar: true` on every call, wrapped in
     React's `cache()`.
   - `app/(app)/layout.tsx`: calls `requireUser()` — which calls `getCurrentUser()` — on
     **every authenticated page**.
   
   Put together: up to ~1.5MB of base64 can ride in the RSC payload on every single page
   load, for a value the layout itself never renders.
3. Use Chrome DevTools MCP to load an authenticated page as a user with a large avatar and
   capture the network/performance evidence — payload size, timing — before touching code.
4. Fix it: stop selecting `avatar` in the call path that only needs identity, not the image
   (the layout/session check), and load it only where it's actually rendered (e.g. the
   profile page, the sidebar avatar component with a dedicated fetch).
5. Re-measure with Chrome DevTools MCP and confirm the payload dropped.

## Prompts used

```
Using the Chrome DevTools MCP tools, log in at localhost:3000 and load the
dashboard. Capture the network payload size for the initial page load and
identify how much of it is the avatar field on the User selected via
getCurrentUser in lib/auth.ts.
```

```
getCurrentUser() in lib/auth.ts selects avatar on every call, and it's called
by requireUser() on every authenticated page via app/(app)/layout.tsx, even
though most pages never render the user's own avatar as an image. Fix this:
stop selecting avatar in the identity/session check, and load it separately
only where it's actually displayed.
```

```
Re-measure the same page load with Chrome DevTools MCP and confirm the
payload size dropped.
```

## Success criteria

- [ ] Chrome DevTools MCP captured a real "before" measurement, not an assumption
- [ ] The fix removes `avatar` from the hot, every-page code path (`getCurrentUser` /
      `requireUser`) without breaking anywhere the avatar is actually rendered
- [ ] `npx tsc --noEmit`, `npm run lint`, and `npm run build` all still pass
- [ ] Chrome DevTools MCP confirms a measured, not assumed, improvement

## If you fall behind

`git checkout wk/05-start`

## Going further

CLASH's README already lists "external image hosting / CDN" as intentionally out of scope.
At home, sketch (don't build) what moving avatars to blob storage would change about this
code path.

## References

- Chrome DevTools MCP — https://github.com/ChromeDevTools/chrome-devtools-mcp
- MCP — https://code.claude.com/docs/en/mcp
- Prisma — https://www.prisma.io/docs
