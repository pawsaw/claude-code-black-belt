#!/usr/bin/env bash
# Stop hook: refuse to end the turn while `npm run build` is failing.
# Exit 2 on failure blocks Stop and returns stderr to the agent, which then
# has to fix the build before the turn can end.
set -euo pipefail

if npm run build >/tmp/clash-build.log 2>&1; then
  exit 0
fi

echo "npm run build is failing — the turn cannot end until it passes:" >&2
tail -n 40 /tmp/clash-build.log >&2
exit 2
