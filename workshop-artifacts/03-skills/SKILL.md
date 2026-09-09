---
name: clash-feature
description: Add a complete feature to the CLASH codebase, from Prisma model through migration, Zod schema, data helper, authorized Server Action, RSC page, shadcn component, revalidation and notification emit. Use whenever adding or extending a user-facing feature in CLASH.
allowed-tools: Read, Edit, Write, Grep, Glob, Bash(npm run *) Bash(npx prisma *) Bash(npx tsc *)
---

# Adding a feature to CLASH

The recipe for this codebase. Follow the order — each step depends on the one before it.
Skipping the authorization step is the single most common way to ship a vulnerability here.

## 1. Prisma model

Edit `prisma/schema.prisma`. Match the existing conventions:

- `id String @id @default(cuid())`
- `createdAt DateTime @default(now())`
- Ownership column is **`creatorId`**, relation to `User`, `onDelete: Cascade`
- Status-like fields are `String`, **not** enums (SQLite) — document allowed values in a `///` comment
- Add `@@unique([...])` where a pair must be unique (see `Participation`)

## 2. Migration

```bash
npm run db:migrate
```

Never hand-edit files under `prisma/migrations/`.

## 3. Constants

If the feature has status/type values, add them to `lib/constants.ts` as a frozen object and
export the union type. Mirror the values in the schema doc comment.

## 4. Zod schema

Add to **`lib/validation.ts`** — the single source of truth. Never inline a schema elsewhere.

```ts
export const favouriteSchema = z.object({
  venueId: z.string().min(1),
  note: z.string().max(280).optional(),
});
export type FavouriteInput = z.infer<typeof favouriteSchema>;
```

Zod 4 idioms: `z.email()` via `.pipe()`, not the deprecated `z.string().email()`.

## 5. Read helper in `lib/data/`

One file per domain. The helper owns its `select`/`include` shape and exports the inferred type.

```ts
export async function getFavourites(userId: string) {
  return prisma.favourite.findMany({
    where: { userId },
    select: { id: true, note: true, venue: { select: { id: true, title: true } } },
    orderBy: { createdAt: "desc" },
  });
}
export type FavouriteListItem = Awaited<ReturnType<typeof getFavourites>>[number];
```

**Never call Prisma from a page or component.** Reads come through here.

## 6. Server Action in `app/actions/` — with its own auth check

This is the step that matters most.

```ts
"use server";

export async function updateFavourite(
  _prev: FormState,
  formData: FormData,
): Promise<FormState> {
  const user = await requireUser();                    // 1. authenticate

  const id = String(formData.get("id") ?? "");
  if (!id) return { error: "Missing id." };

  const existing = await prisma.favourite.findUnique({ // 2. load
    where: { id },
    select: { userId: true },
  });
  if (!existing) return { error: "Not found." };
  if (existing.userId !== user.id) {                   // 3. AUTHORIZE
    return { error: "You can only edit your own favourites." };
  }

  const parsed = favouriteSchema.safeParse({ /* … */ }); // 4. validate shape
  if (!parsed.success) return { fieldErrors: getFieldErrors(parsed.error) };

  await prisma.favourite.update({ where: { id }, data: parsed.data });

  revalidateFavouriteViews(id);                        // 5. revalidate
  return { ok: true };
}
```

**Why step 3 is not optional:** a Server Action compiles to a public POST endpoint with a
generated ID. The `requireUser()` in `app/(app)/layout.tsx` guards the *page*; it does
nothing for a direct call to the action. Zod validates shape, not permission.

Actions scoped by a `where` clause that already includes `userId` (see
`markNotificationRead`) are safe by construction — that pattern is fine, and is *not* a
missing check.

## 7. RSC page

```ts
export default async function Page({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;          // Next 16: params is a Promise
  const user = await requireUser();
  const data = await getFavourites(user.id);
  return <FavouriteList items={data} />;
}
```

## 8. Component

Reuse `components/ui/*` (shadcn) before writing anything new. Client components only where
interactivity demands it. `next/dynamic` with `ssr: false` must live inside a `'use client'`
module.

## 9. Revalidate

Add a `revalidate<Domain>Views(id?)` helper next to the actions, mirroring
`revalidateClashViews`. Call it after every mutation.

## 10. Notification emit

If the feature affects another user, emit through `lib/notify.ts`:

```ts
await createNotification({
  userId: venue.creatorId,
  actorId: user.id,
  type: NOTIFICATION_TYPE.VENUE_CLASH,
  message: `${user.name} favourited your venue ${venue.title}.`,
  venueId: venue.id,
});
```

Add any new type to `NOTIFICATION_TYPE` in `lib/constants.ts` first.

## 11. Verify

```bash
npx tsc --noEmit && npm run lint && npm run build
```

All three must pass. There is no `typecheck` script — run `tsc` directly.

## Checklist

- [ ] Model added, ownership column is `creatorId` (or `userId` for per-user rows)
- [ ] Migration generated, not hand-edited
- [ ] Status values in `lib/constants.ts`, mirrored in the schema comment
- [ ] Schema in `lib/validation.ts`, type exported
- [ ] Read helper in `lib/data/`, type exported, no Prisma outside it
- [ ] Action: `requireUser()` **and** an explicit ownership check
- [ ] `params`/`searchParams` awaited
- [ ] `revalidatePath` via the domain helper
- [ ] Notification emitted if another user is affected
- [ ] `tsc`, `lint`, `build` all green
