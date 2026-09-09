#!/usr/bin/env bash
# PostToolUse hook: after an Edit/Write, typecheck the project if the touched
# file is under app/actions/. Blocks (exit 2) on a typecheck failure so the
# error goes back to the agent; the `if` clause in settings.json already
# scopes this to app/actions/**, so the path check here is a second cheap
# guard, not the primary filter.
set -euo pipefail

file_path="$(jq -r '.tool_input.file_path // empty' <<<"${CLAUDE_HOOK_INPUT:-$(cat)}" 2>/dev/null || true)"

if [[ -n "$file_path" && "$file_path" != *"app/actions/"* ]]; then
  exit 0
fi

output="$(npx tsc --noEmit 2>&1)" && exit 0

echo "npx tsc --noEmit failed after editing $file_path:" >&2
echo "$output" >&2
exit 2
