<script setup lang="ts">
// G18 — Worktree parallelism. One repo, N isolated agent worktrees, converging
// at merge. Ground truth: `claude --worktree <name>` (alias -w) creates an
// isolated worktree under .claude/worktrees/<name>/ on its own branch
// (worktree-<name>), so parallel agents don't collide on the same files.
const worktrees = [
  { x: 120, label: 'worktree-notifications', file: 'lib/notify.ts' },
  { x: 430, label: 'worktree-avatar-fix', file: 'app/actions/profile.ts' },
  { x: 740, label: 'worktree-tests', file: 'e2e/join-flow.spec.ts' },
]
</script>

<template>
  <svg viewBox="0 0 900 520" width="900" height="520" class="w-full max-w-4xl h-auto max-h-full" font-family="Inter, sans-serif">
    <!-- main repo -->
    <g v-click>
      <rect x="330" y="10" width="240" height="60" rx="10" fill="var(--na-primary-700)" stroke="var(--na-primary-400)" stroke-width="1.5" />
      <text x="450" y="35" text-anchor="middle" fill="var(--na-fg)" font-weight="700" style="font-size:16px">pawsaw/clash</text>
      <text x="450" y="55" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:12px">one repo, one working tree — until now</text>
    </g>

    <!-- branch lines from repo to each worktree -->
    <g v-click>
      <path
        v-for="wt in worktrees" :key="'line-' + wt.label"
        :d="`M 450 70 C 450 140, ${wt.x + 90} 130, ${wt.x + 90} 190`"
        fill="none" stroke="var(--na-zinc-600)" stroke-width="2" stroke-dasharray="4 4"
      />
    </g>

    <!-- isolated worktree boxes -->
    <g v-click>
      <g v-for="wt in worktrees" :key="wt.label">
        <rect :x="wt.x" y="190" width="180" height="130" rx="10" fill="var(--na-bg-raised)" stroke="var(--na-border)" stroke-width="1.5" />
        <circle :cx="wt.x + 28" cy="222" r="10" fill="var(--na-secondary-500)" />
        <text :x="wt.x + 46" y="227" fill="var(--na-fg)" font-weight="600" style="font-size:12px">agent</text>
        <text :x="wt.x + 90" y="260" text-anchor="middle" fill="var(--na-fg)" font-weight="600" style="font-size:12px">{{ wt.label }}</text>
        <text :x="wt.x + 90" y="280" text-anchor="middle" fill="var(--na-fg-muted)" font-family="JetBrains Mono, monospace" style="font-size:11px">{{ wt.file }}</text>
        <rect :x="wt.x + 20" y="295" width="140" height="10" rx="3" fill="var(--na-zinc-800)" />
        <rect :x="wt.x + 20" y="295" width="90" height="10" rx="3" fill="var(--na-primary-400)" />
      </g>
      <text x="450" y="450" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:13px">
        isolated working directories — no file collisions, no shared lock
      </text>
    </g>

    <!-- convergence at merge -->
    <g v-click>
      <path
        v-for="wt in worktrees" :key="'merge-' + wt.label"
        :d="`M ${wt.x + 90} 330 C ${wt.x + 90} 400, 450 400, 450 460`"
        fill="none" stroke="var(--na-accent-500)" stroke-width="2.5"
      />
      <rect x="360" y="460" width="180" height="50" rx="10" fill="var(--na-accent-500)" />
      <text x="450" y="491" text-anchor="middle" fill="var(--na-zinc-950)" font-weight="700" style="font-size:15px">merge</text>
    </g>
  </svg>
</template>
