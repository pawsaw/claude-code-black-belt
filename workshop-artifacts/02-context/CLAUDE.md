# CLASH — agent instructions

A geospatial social platform for spontaneous meetups across Berlin.
Next.js 16 (App Router) · React 19 · Prisma 7 + SQLite · Tailwind v4 · shadcn/ui · Leaflet.

@AGENTS.md

## Architecture invariants

These are the rules that actually prevent bugs in this codebase. Follow them.

**Reads go in `lib/data/*`.** RSC pages call a helper from `lib/data/` — they never call
Prisma directly. Each helper owns its own `select`/`include` shape and exports the inferred
type alongside it (`ClashListItem`, `VenueDetail`, …).

**Writes go in `app/actions/*`.** Every mutation is a Server Action marked `"use server"`.

**Every Server Action re-establishes authorization itself.** A Server Action compiles to a
public POST endpoint with a generated ID. The `requireUser()` guard in
`app/(app)/layout.tsx` protects the *page*, not the action — anyone with a session cookie
can invoke any action directly with any arguments. So:

- `await requireUser()` at the top of every action, and
- an explicit ownership check before any mutation of an existing row:
  ```ts
  if (existing.creatorId !== user.id) {
    return { error: "You can only edit clashes you created." };
  }
  ```

Zod validates **shape**, not **permission**. Never treat a passing schema as authorization.

**`lib/validation.ts` is the single source of truth for Zod schemas.** Never define a schema
inline in an action or a component. Export the inferred type next to the schema.

**Prisma client is generated to `lib/generated/prisma`** — not `@prisma/client`. It is
gitignored; `npm install` regenerates it via `postinstall`. Import through `lib/prisma.ts`.

**Status fields are documented strings, not enums.** SQLite has no enum support. The allowed
values live in `lib/constants.ts` (`PARTICIPATION_STATUS`, `NOTIFICATION_TYPE`) and are
mirrored in doc comments in `prisma/schema.prisma`. Use the constants, never string literals.

**Next 16: `params` and `searchParams` are Promises.** Always `await` them.
```ts
export default async function Page({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
}
```

**`next/dynamic` with `ssr: false` is only valid inside a `'use client'` module.** This is
why the Leaflet map is wrapped the way it is — don't "simplify" it.

**Mutations end with `revalidatePath`.** Use the existing `revalidateClashViews()` /
`revalidateVenueViews()` helpers rather than hand-listing paths.

## Commands

```bash
npm run dev          # dev server on :3000
npm run db:migrate   # prisma migrate dev
npm run db:seed      # destructive reseed; 8 users, password "test"
npm run db:reset     # full reset
```

## Quality gates — all three must pass before you call work done

```bash
npx tsc --noEmit     # no typecheck script exists; run it directly
npm run lint         # bare eslint, flat config
npm run build
```

## Local conventions

- Tailwind v4 is configured in `app/globals.css`. There is no `tailwind.config.js` — don't create one.
- `hooks/` holds **React** hooks. Claude Code hooks live in `.claude/settings.json`. Different things.
- Avatars are base64 data URLs stored in the `User.avatar` column. Known perf tradeoff, deliberately scoped in.
- Seeded dev logins: `anna.schmidt@example.com` … all 8 users have password `test`.

## Out of scope

Real-time/WebSocket notifications, OAuth, email delivery, external image hosting, and
deployment config are all intentionally not built. Don't add them speculatively.
