<script setup lang="ts">
// G17 — Browser tool comparison, positioned by purpose and QUALITATIVE cost only.
// Do NOT put a numeric token-savings figure on Agent Browser — not an official claim.
const tools = [
  { name: 'Playwright MCP', x: 220, y: 100, purpose: 'E2E test authoring', cost: 'heavier — full DOM + schemas' },
  { name: 'Chrome DevTools MCP', x: 700, y: 100, purpose: 'perf / network debugging', cost: 'moderate' },
  { name: 'Claude in Chrome', x: 700, y: 300, purpose: 'authenticated visual checks', cost: 'moderate–heavy' },
  { name: 'Agent Browser', x: 220, y: 300, purpose: 'general automation', cost: 'leaner — a11y-tree snapshots, not DOM dumps' },
]
</script>

<template>
  <div class="w-full flex justify-center">
    <svg viewBox="0 0 960 420" width="960" height="420" class="w-full max-w-4xl h-auto max-h-full">
      <line x1="480" y1="20" x2="480" y2="380" stroke="var(--na-border)" stroke-width="1" />
      <line x1="40" y1="200" x2="920" y2="200" stroke="var(--na-border)" stroke-width="1" />
      <text x="15" y="205" fill="var(--na-fg-muted)" transform="rotate(-90 15 205)" style="font-size:12px">cost: lean ←→ heavy</text>

      <g v-for="t in tools" :key="t.name" v-click>
        <circle :cx="t.x" :cy="t.y" r="10" fill="var(--na-accent-500)" />
        <rect :x="t.x - 100" :y="t.y + 16" width="200" height="58" rx="8" class="na-card" style="fill: var(--na-bg-raised); stroke: var(--na-border)" />
        <text :x="t.x" :y="t.y + 36" font-weight="700" fill="var(--na-fg)" text-anchor="middle" style="font-size:14px">{{ t.name }}</text>
        <text :x="t.x" :y="t.y + 52" fill="var(--na-fg-muted)" text-anchor="middle" style="font-size:11px">{{ t.purpose }}</text>
        <text :x="t.x" :y="t.y + 66" fill="var(--na-fg-muted)" text-anchor="middle" style="font-size:11px">{{ t.cost }}</text>
      </g>
    </svg>
  </div>
</template>
