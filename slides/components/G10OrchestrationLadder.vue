<script setup lang="ts">
// G10 — Orchestration ladder compared across four axes. Revealed row by row,
// as if being filled in from the evidence gathered at 02:13, not shown
// finished.
const cols = ['Subagent', 'Agent team', 'Workflow'] as const
const rows = [
  {
    axis: 'Who decides next',
    values: ['You, each time', 'The lead, autonomously', 'The script, deterministically'],
  },
  {
    axis: 'Parallelism',
    values: ['One at a time (or a few you launch)', 'Several peers concurrently', 'Up to 16 concurrent, 1,000/run'],
  },
  {
    axis: 'Token cost',
    values: ['Low – moderate', 'Moderate – high', 'Highest — many agents, verifier passes'],
  },
  {
    axis: 'Main-thread context burn',
    values: ['Minimal — summary only returns', 'Minimal — team runs in its own session', 'Minimal — runs in background'],
  },
] as const
</script>

<template>
  <div class="w-full na-card overflow-hidden">
    <div
      class="grid text-sm font-semibold px-4 py-2"
      style="grid-template-columns: 13rem repeat(3, 1fr); background: var(--na-zinc-900); color: var(--na-fg-muted)"
    >
      <div></div>
      <div v-for="c in cols" :key="c" class="text-center" style="color: var(--na-fg)">{{ c }}</div>
    </div>
    <div
      v-for="row in rows"
      :key="row.axis"
      v-click
      class="grid px-4 py-3 text-sm items-center"
      style="grid-template-columns: 13rem repeat(3, 1fr); border-top: 1px solid var(--na-border)"
    >
      <div class="font-semibold" style="color: var(--na-fg)">{{ row.axis }}</div>
      <div v-for="(v, i) in row.values" :key="i" class="text-center px-2" style="color: var(--na-fg-muted)">{{ v }}</div>
    </div>
  </div>
</template>
