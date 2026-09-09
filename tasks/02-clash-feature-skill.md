# Task 02 — The `clash-feature` skill

> **Block:** Skills (00:50–01:18) · **Time-box:** 28 min · **Mode:** follow along
> **Reset branch:** `wk/02-start`

## Goal

Author a `clash-feature` skill that encodes CLASH's end-to-end feature recipe, then use it
to ship one small feature.

## Why this matters

Skills are for work you'd otherwise keep re-explaining. Adding a feature to CLASH is exactly
that: the same ten steps every time, in the same order, with the same easy step to skip
(the per-action ownership check). A skill turns "remember to add the auth check" into
"the recipe already has a slot for it." Custom slash commands have merged into skills — a
`.claude/commands/*.md` file and a `.claude/skills/<name>/SKILL.md` file both produce the
same `/command` and keep working; skills are simply the richer format going forward.

## Starting point

`wk/02-start` — CLASH at baseline, `CLAUDE.md` from Task 01 in place, no
`.claude/skills/` directory yet.

## Steps

1. Look at what already ships: `.agents/skills/` and `skills-lock.json`. These are vendored
   third-party skills (Prisma, shadcn, React best-practices) — you're not starting cold.
2. Create `.claude/skills/clash-feature/SKILL.md`. Write the frontmatter first:
   ```yaml
   ---
   name: clash-feature
   description: Add a complete feature to CLASH, from Prisma model through an
     authorized Server Action to a rendered page. Use when adding or extending
     a user-facing feature in this codebase.
   allowed-tools: Read, Edit, Write, Grep, Glob, Bash(npm run *) Bash(npx prisma *) Bash(npx tsc *)
   ---
   ```
3. Write the body as the ten-step recipe: Prisma model → migration → constants (if the
   feature has status/type values) → Zod schema in `lib/validation.ts` → read helper in
   `lib/data/` → Server Action in `app/actions/` **with its own auth check** → RSC page →
   shadcn component → `revalidatePath` → notification emit via `lib/notify.ts`.
4. For the Server Action step, be explicit about *why* the auth check is its own step, not
   an afterthought — restate the argument from the setup you'll formalize in block 5: a
   Server Action is a public POST endpoint with a generated ID, and the layout's
   `requireUser()` doesn't reach it.
5. Invoke the skill to ship one real feature end-to-end. Venue favourites is a good size:
   a `Favourite` model (`userId`, `venueId`, unique pair), a toggle action, a list on the
   venue detail page.
6. Compare the result against the cold open from 00:00. It should be visibly tighter — fewer
   files read, less drift, a shorter `/context` delta for the same class of work.

## Prompts used

```
/clash-feature Add venue favourites: a user can favourite a venue from its
detail page and see a list of their favourites on their profile.
```

```
Walk me through why the Server Action step in this skill insists on its own
authorization check, given the layout already calls requireUser().
```

## Success criteria

- [ ] `.claude/skills/clash-feature/SKILL.md` exists with `name`, `description`, and `allowed-tools` frontmatter
- [ ] The skill body's Server Action step explicitly calls out an ownership check, not just `requireUser()`
- [ ] One real feature (e.g. venue favourites) is shipped end-to-end using the skill
- [ ] `npx tsc --noEmit`, `npm run lint`, and `npm run build` all pass
- [ ] You can state, from memory, that `.claude/commands/*.md` still works and is not deprecated

## If you fall behind

`git checkout wk/02-start`

## Going further

Compare your skill against `workshop-artifacts/03-skills/SKILL.md` in this workshop
repository. Try a second feature (clash comments) using only the skill and no additional
prompting — see how much you need to say versus how much the skill already knows.

## References

- Skills — https://code.claude.com/docs/en/skills
- Commands — https://code.claude.com/docs/en/commands
