<script setup lang="ts">
// G16 — The verification loop: change -> browser -> observe -> fix, closed, no human inside it.
const steps = [
  { label: 'Change code', x: 480, y: 60 },
  { label: 'Browser (MCP)', x: 780, y: 210 },
  { label: 'Observe', x: 480, y: 360 },
  { label: 'Fix', x: 180, y: 210 },
]
</script>

<template>
  <div class="w-full flex flex-col items-center gap-4">
    <svg viewBox="0 0 960 420" width="960" height="420" class="w-full max-w-3xl h-auto max-h-full">
      <circle cx="480" cy="210" r="150" fill="none" stroke="var(--na-border)" stroke-width="1" stroke-dasharray="4 4" />

      <g v-for="(s, i) in steps" :key="s.label" v-click>
        <line
          :x1="steps[i].x" :y1="steps[i].y"
          :x2="steps[(i + 1) % 4].x" :y2="steps[(i + 1) % 4].y"
          stroke="var(--na-primary-400)" stroke-width="2.5" marker-end="url(#loopArrow)"
        />
      </g>

      <g v-for="s in steps" :key="'n' + s.label">
        <circle :cx="s.x" :cy="s.y" r="46" fill="var(--na-bg-raised)" stroke="var(--na-primary-400)" stroke-width="2" />
        <text :x="s.x" :y="s.y + 5" font-weight="600" fill="var(--na-fg)" text-anchor="middle" style="font-size:14px">{{ s.label }}</text>
      </g>

      <g v-click>
        <text x="480" y="216" font-weight="700" fill="var(--na-accent-500)" text-anchor="middle" style="font-size:15px">no human in the loop</text>
      </g>

      <defs>
        <marker id="loopArrow" markerWidth="9" markerHeight="9" refX="7" refY="4.5" orient="auto">
          <path d="M0,0 L9,4.5 L0,9 Z" fill="var(--na-primary-400)" />
        </marker>
      </defs>
    </svg>
  </div>
</template>
