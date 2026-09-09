<script setup lang="ts">
// G1 — The agent loop. prompt → model → tool call → result → back into
// context, and where context accumulates on every pass. First diagram in
// the deck (cold open, 00:00–00:10).
const nodes = [
  { key: 'prompt', label: 'Prompt', x: 480, y: 90 },
  { key: 'model', label: 'Model', x: 800, y: 270 },
  { key: 'tool', label: 'Tool call', x: 480, y: 450 },
  { key: 'result', label: 'Result', x: 160, y: 270 },
] as const
</script>

<template>
  <div class="w-full flex flex-col items-center gap-6">
    <svg viewBox="0 0 960 540" width="960" height="540" class="w-full max-w-3xl h-auto max-h-full" role="img" aria-label="The agent loop">
      <!-- racetrack connectors -->
      <g fill="none" stroke="var(--na-zinc-700)" stroke-width="2.5">
        <path d="M 560 110 A 340 190 0 0 1 780 230" marker-end="url(#arrow)" />
        <path d="M 790 320 A 340 190 0 0 1 570 440" marker-end="url(#arrow)" />
        <path d="M 400 450 A 340 190 0 0 1 175 330" marker-end="url(#arrow)" />
        <path d="M 165 220 A 340 190 0 0 1 400 100" marker-end="url(#arrow)" />
      </g>
      <defs>
        <marker id="arrow" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto">
          <path d="M0,0 L0,6 L8,3 z" fill="var(--na-zinc-700)" />
        </marker>
      </defs>

      <!-- context window, ring around the loop, thickens per pass -->
      <circle
        cx="480" cy="270" r="230"
        fill="none" stroke="var(--na-primary-700)" stroke-width="10" stroke-dasharray="4 10"
        opacity="0.5"
      />
      <g v-click="1">
        <circle cx="480" cy="270" r="230" fill="none" stroke="var(--na-primary-500)" stroke-width="14" stroke-dasharray="720 1600" />
      </g>
      <g v-click="2">
        <circle cx="480" cy="270" r="230" fill="none" stroke="var(--na-primary-400)" stroke-width="18" stroke-dasharray="1200 1600" />
      </g>
      <g v-click="3">
        <circle cx="480" cy="270" r="230" fill="none" stroke="var(--na-accent-500)" stroke-width="22" stroke-dasharray="1550 1600" />
      </g>

      <!-- nodes -->
      <g v-for="n in nodes" :key="n.key">
        <circle :cx="n.x" :cy="n.y" r="70" fill="var(--na-bg-raised)" stroke="var(--na-zinc-600)" stroke-width="2" />
        <text :x="n.x" :y="n.y + 6" text-anchor="middle" font-weight="600" fill="var(--na-fg)" style="font-size:20px">{{ n.label }}</text>
      </g>

      <!-- center label, appears with the loop nearing full -->
      <g v-click="3">
        <text x="480" y="264" text-anchor="middle" fill="var(--na-accent-500)" font-weight="700" style="font-size:16px">context window</text>
        <text x="480" y="286" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:14px">filling on every pass</text>
      </g>
    </svg>
    <p v-click="3" class="text-lg" style="color: var(--na-accent-500)">
      Three passes in — the window is nearly full, and nothing has been fixed yet.
    </p>
  </div>
</template>
