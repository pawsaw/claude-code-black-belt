#!/usr/bin/env bash
# Prepares the wk/00-start .. wk/07-start reset branches on a local clone of
# pawsaw/clash. Run against .clash-ref/ from the repo root:
#
#   ./scripts/prepare-workshop-branches.sh /path/to/.clash-ref
#
# This script NEVER pushes. It creates local branches only, prints a diff for
# review, and leaves `git push` as an explicit, separate step for a human.
#
# Branch narrative:
#   wk/00-start  baseline handed to attendees at pre-flight (== main)
#   wk/01-start  start of context engineering            (== main)
#   wk/02-start  start of skills                          (== main)
#   wk/03-start  start of the delegation ladder — SEEDS the missing
#                ownership checks in deleteClash/updateVenue that the
#                security-auditor workflow is meant to find
#   wk/04-start  start of hooks — the auth fix from block 5 is merged in,
#                CLAUDE.md/AGENTS.md are the rewritten versions from block 3,
#                .agents/skills/clash-feature/ is installed
#   wk/05-start  start of MCP/browser — the typecheck + deny + Stop hooks
#                from block 4 are installed
#   wk/06-start  start of "letting go" — no state changes, checkpoint only
#   wk/07-start  finished state — the answer key (mirrors wk/06-start; the
#                worktree/CI/SDK segments are conceptual/config, not code)

set -euo pipefail

CLASH_DIR="${1:?usage: prepare-workshop-branches.sh /path/to/.clash-ref}"
WORKSHOP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACTS="$WORKSHOP_ROOT/workshop-artifacts"

cd "$CLASH_DIR"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: $CLASH_DIR has uncommitted changes. Commit, stash, or use a fresh clone." >&2
  exit 1
fi

git fetch origin --quiet
git checkout -B wk/00-start origin/main --quiet
echo "== wk/00-start == (baseline, identical to main)"

for b in wk/01-start wk/02-start; do
  git checkout -B "$b" wk/00-start --quiet
  echo "== $b == (identical to wk/00-start — no code changes before block 5)"
done

# --- wk/03-start: seed the missing ownership checks -------------------------
git checkout -B wk/03-start wk/02-start --quiet

python3 - "$CLASH_DIR/app/actions/clashes.ts" <<'PY'
import re, sys
path = sys.argv[1]
src = open(path).read()
needle = (
    '  if (!clash) return { ok: false, error: "Clash not found." };\n'
    '  if (clash.creatorId !== user.id) {\n'
    '    return { ok: false, error: "You can only delete clashes you created." };\n'
    '  }\n'
)
if needle not in src:
    sys.exit(f"error: expected deleteClash guard not found verbatim in {path}")
replacement = '  if (!clash) return { ok: false, error: "Clash not found." };\n'
src = src.replace(needle, replacement, 1)
open(path, "w").write(src)
PY

python3 - "$CLASH_DIR/app/actions/venues.ts" <<'PY'
import sys
path = sys.argv[1]
src = open(path).read()
needle = (
    '  if (!venue) return { ok: false, error: "Venue not found." };\n'
    '  if (venue.creatorId !== user.id) {\n'
    '    return { ok: false, error: "You can only delete venues you created." };\n'
    '  }\n'
)
if needle not in src:
    sys.exit(f"error: expected deleteVenue guard not found verbatim in {path}")
replacement = '  if (!venue) return { ok: false, error: "Venue not found." };\n'
src = src.replace(needle, replacement, 1)
open(path, "w").write(src)
PY

git add app/actions/clashes.ts app/actions/venues.ts
git commit --quiet -m "workshop: seed missing ownership checks for the security-audit block

deleteClash and deleteVenue no longer verify creatorId before deleting.
Any authenticated user can now delete any clash or venue by calling the
Server Action directly with someone else's id — exactly the class of bug
block 5 (the delegation ladder) exists to find and fix.

This state is intentional workshop content, not a real CLASH regression.
See workshop-artifacts/03-delegation-ladder/AUTH-FIX.md for the diff that
restores the guard, and docs/SPEC-DEVIATIONS.md item 1 for why this branch
exists."
echo "== wk/03-start == (seeded: deleteClash + deleteVenue missing ownership check)"

# --- wk/04-start: context/skills artifacts + the auth fix merged in --------
git checkout -B wk/04-start wk/03-start --quiet

python3 - "$CLASH_DIR/app/actions/clashes.ts" <<'PY'
import sys
path = sys.argv[1]
src = open(path).read()
needle = '  if (!clash) return { ok: false, error: "Clash not found." };\n\n  await prisma.clash.delete'
if needle not in src:
    sys.exit(f"error: expected patched deleteClash body not found in {path}")
fixed = (
    '  if (!clash) return { ok: false, error: "Clash not found." };\n'
    '  if (clash.creatorId !== user.id) {\n'
    '    return { ok: false, error: "You can only delete clashes you created." };\n'
    '  }\n\n  await prisma.clash.delete'
)
src = src.replace(needle, fixed, 1)
open(path, "w").write(src)
PY

python3 - "$CLASH_DIR/app/actions/venues.ts" <<'PY'
import sys
path = sys.argv[1]
src = open(path).read()
needle = '  if (!venue) return { ok: false, error: "Venue not found." };\n\n  // Clashes referencing'
if needle not in src:
    sys.exit(f"error: expected patched deleteVenue body not found in {path}")
fixed = (
    '  if (!venue) return { ok: false, error: "Venue not found." };\n'
    '  if (venue.creatorId !== user.id) {\n'
    '    return { ok: false, error: "You can only delete venues you created." };\n'
    '  }\n\n  // Clashes referencing'
)
src = src.replace(needle, fixed, 1)
open(path, "w").write(src)
PY

cp "$ARTIFACTS/02-context/CLAUDE.md" "$CLASH_DIR/CLAUDE.md"
mkdir -p "$CLASH_DIR/.claude/skills/clash-feature"
cp "$ARTIFACTS/03-skills/SKILL.md" "$CLASH_DIR/.claude/skills/clash-feature/SKILL.md"

git add -A
git commit --quiet -m "workshop: merge the delegation-ladder auth fix; ship the rewritten CLAUDE.md and clash-feature skill

Restores the creatorId ownership checks in deleteClash/deleteVenue found
during block 5. Also lands the CLAUDE.md authored during block 3 (context
engineering) and the clash-feature skill authored during block 4 (skills),
so that participants resuming from this branch are not missing artifacts
from earlier blocks they may have skipped."
echo "== wk/04-start == (auth fix merged; CLAUDE.md + clash-feature skill present)"

# --- wk/05-start: hooks from block 6 installed ------------------------------
git checkout -B wk/05-start wk/04-start --quiet
mkdir -p "$CLASH_DIR/.claude/hooks"
cp "$ARTIFACTS/04-hooks/typecheck-actions.sh" "$CLASH_DIR/.claude/hooks/typecheck-actions.sh"
chmod +x "$CLASH_DIR/.claude/hooks/typecheck-actions.sh"
cp "$ARTIFACTS/04-hooks/settings.json" "$CLASH_DIR/.claude/settings.json"

git add -A
git commit --quiet -m "workshop: install the block-6 hook set (typecheck, deny rules, Stop gate)

.claude/settings.json now runs npx tsc --noEmit on every edit under
app/actions/*, denies writes to prisma/migrations/*, rm, and reads of
.env*, and blocks Stop while npm run build is failing."
echo "== wk/05-start == (hook set installed)"

for b in wk/06-start wk/07-start; do
  git checkout -B "$b" wk/05-start --quiet
  echo "== $b == (no further code changes — worktrees/CI/SDK are config and conceptual)"
done

git checkout main --quiet

cat <<'EOF'

All branches created LOCALLY. Nothing has been pushed.

Review before pushing:
  git -C "$CLASH_DIR" log --oneline --all --graph
  git -C "$CLASH_DIR" diff main wk/03-start -- app/actions/
  git -C "$CLASH_DIR" diff wk/03-start wk/04-start

To publish (separate, explicit step — confirm with the trainer first):
  git -C "$CLASH_DIR" push origin wk/00-start wk/01-start wk/02-start \
    wk/03-start wk/04-start wk/05-start wk/06-start wk/07-start
EOF
