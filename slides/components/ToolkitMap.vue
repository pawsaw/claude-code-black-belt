<script setup lang="ts">
// G4 — The toolkit map. The deck's spine: shown in full at 00:10, then
// re-shown at every section divider (layout: section) with the current
// primitive's row highlighted.
//
// Prop `current` — the row to highlight on a divider re-show (all seven rows
// stay visible; only the highlight moves).
// Prop `revealRows` — true only on the 00:10 intro slide, where the table
// hasn't been seen yet and builds up one row per click. Divider re-shows
// leave this false so a 20-second beat doesn't cost seven clicks.
const props = withDefaults(
  defineProps<{
    current?:
      | 'context'
      | 'skill'
      | 'subagent'
      | 'team'
      | 'workflow'
      | 'hook'
      | 'mcp'
    revealRows?: boolean
  }>(),
  { revealRows: false },
)

const rows = [
  { key: 'context', primitive: 'Context', what: 'the window itself', when: 'always — the constraint everything else works around' },
  { key: 'skill', primitive: 'Skill', what: 'instructions loaded on demand', when: 'the work is repeatable and you keep re-explaining it' },
  { key: 'subagent', primitive: 'Subagent', what: 'a worker with its own context window', when: 'the work is noisy and would pollute your thread' },
  { key: 'team', primitive: 'Agent team', what: 'a lead supervising peer sessions', when: 'workers need to talk to each other over time' },
  { key: 'workflow', primitive: 'Workflow', what: 'a script that holds the plan', when: 'the fan-out is bigger than one conversation can steer' },
  { key: 'hook', primitive: 'Hook', what: 'deterministic shell on a lifecycle event', when: 'the rule must hold whether or not the agent agrees' },
  { key: 'mcp', primitive: 'MCP', what: 'your systems as tools', when: 'the agent needs to reach outside the repo' },
] as const
</script>

<template>
  <div class="w-full na-card overflow-hidden">
    <div
      class="grid text-sm font-semibold px-4 py-2"
      style="grid-template-columns: 9rem 14rem 1fr; background: var(--na-zinc-900); color: var(--na-fg-muted)"
    >
      <div>Primitive</div>
      <div>What it is</div>
      <div>Reach for it when</div>
    </div>
    <template v-if="revealRows">
      <div
        v-for="row in rows"
        :key="row.key"
        v-click
        class="grid px-4 py-2.5 text-sm items-center toolkit-row"
        :class="{ 'toolkit-row--active': current === row.key }"
        style="grid-template-columns: 9rem 14rem 1fr; border-top: 1px solid var(--na-border)"
      >
        <div class="font-semibold" :style="{ color: current === row.key ? 'var(--na-accent-500)' : 'var(--na-fg)' }">
          {{ row.primitive }}
        </div>
        <div style="color: var(--na-fg-muted)">{{ row.what }}</div>
        <div>{{ row.when }}</div>
      </div>
    </template>
    <template v-else>
      <div
        v-for="row in rows"
        :key="row.key"
        class="grid px-4 py-2.5 text-sm items-center toolkit-row"
        :class="{ 'toolkit-row--active': current === row.key }"
        style="grid-template-columns: 9rem 14rem 1fr; border-top: 1px solid var(--na-border)"
      >
        <div class="font-semibold" :style="{ color: current === row.key ? 'var(--na-accent-500)' : 'var(--na-fg)' }">
          {{ row.primitive }}
        </div>
        <div style="color: var(--na-fg-muted)">{{ row.what }}</div>
        <div>{{ row.when }}</div>
      </div>
    </template>
  </div>
</template>

<style scoped>
.toolkit-row {
  transition: background var(--na-duration-normal) var(--na-ease-out);
}
.toolkit-row--active {
  background: var(--na-primary-900);
  box-shadow: inset 3px 0 0 var(--na-accent-500);
}
</style>
