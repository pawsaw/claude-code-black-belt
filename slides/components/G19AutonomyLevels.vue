<script setup lang="ts">
// G19 — Interactive → headless → embedded. Same agent, three levels of
// autonomy, same control primitives carried across unchanged.
const stages = [
  {
    x: 30,
    title: 'Interactive',
    sub: 'you, in the loop',
    detail: 'claude — a human drives every turn',
  },
  {
    x: 320,
    title: 'Headless',
    sub: 'no human present',
    detail: 'claude -p via anthropics/claude-code-action@v1 in a GitHub Action',
  },
  {
    x: 610,
    title: 'Embedded',
    sub: 'living inside your app',
    detail: 'Agent SDK — the agent is a feature, not a session',
  },
]
</script>

<template>
  <svg viewBox="0 0 900 500" width="900" height="500" class="w-full max-w-4xl h-auto max-h-full" font-family="Inter, sans-serif">
    <g v-click>
      <g v-for="(s, i) in stages.slice(0, 1)" :key="s.title">
        <rect :x="s.x" y="30" width="260" height="150" rx="12" fill="var(--na-bg-raised)" stroke="var(--na-primary-400)" stroke-width="2" />
        <text :x="s.x + 130" y="70" text-anchor="middle" fill="var(--na-fg)" font-weight="700" style="font-size:20px">{{ s.title }}</text>
        <text :x="s.x + 130" y="94" text-anchor="middle" fill="var(--na-accent-500)" style="font-size:12px">{{ s.sub }}</text>
        <text :x="s.x + 130" y="135" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">{{ s.detail }}</text>
      </g>
    </g>

    <g v-click>
      <path d="M 290 105 L 320 105" stroke="var(--na-zinc-600)" stroke-width="2.5" marker-end="url(#arrow)" />
      <rect :x="stages[1].x" y="30" width="260" height="150" rx="12" fill="var(--na-bg-raised)" stroke="var(--na-primary-400)" stroke-width="2" />
      <text :x="stages[1].x + 130" y="70" text-anchor="middle" fill="var(--na-fg)" font-weight="700" style="font-size:20px">{{ stages[1].title }}</text>
      <text :x="stages[1].x + 130" y="94" text-anchor="middle" fill="var(--na-accent-500)" style="font-size:12px">{{ stages[1].sub }}</text>
      <foreignObject :x="stages[1].x + 15" y="105" width="230" height="60">
        <div style="color: var(--na-fg-muted); font-size: 11px; text-align: center; font-family: 'JetBrains Mono', monospace;">
          {{ stages[1].detail }}
        </div>
      </foreignObject>
    </g>

    <g v-click>
      <path d="M 580 105 L 610 105" stroke="var(--na-zinc-600)" stroke-width="2.5" marker-end="url(#arrow)" />
      <rect :x="stages[2].x" y="30" width="260" height="150" rx="12" fill="var(--na-bg-raised)" stroke="var(--na-primary-400)" stroke-width="2" />
      <text :x="stages[2].x + 130" y="70" text-anchor="middle" fill="var(--na-fg)" font-weight="700" style="font-size:20px">{{ stages[2].title }}</text>
      <text :x="stages[2].x + 130" y="94" text-anchor="middle" fill="var(--na-accent-500)" style="font-size:12px">{{ stages[2].sub }}</text>
      <text :x="stages[2].x + 130" y="135" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">{{ stages[2].detail }}</text>
    </g>

    <!-- persistent band: same primitives carry over -->
    <g v-click>
      <path d="M 160 180 L 160 350" stroke="var(--na-zinc-700)" stroke-width="1.5" stroke-dasharray="3 3" />
      <path d="M 450 180 L 450 350" stroke="var(--na-zinc-700)" stroke-width="1.5" stroke-dasharray="3 3" />
      <path d="M 740 180 L 740 350" stroke="var(--na-zinc-700)" stroke-width="1.5" stroke-dasharray="3 3" />
      <rect x="30" y="350" width="840" height="110" rx="12" fill="var(--na-primary-900)" stroke="var(--na-accent-500)" stroke-width="2" />
      <text x="450" y="378" text-anchor="middle" fill="var(--na-accent-500)" font-weight="700" style="font-size:14px">
        every control primitive from today carries over unchanged
      </text>
      <g fill="var(--na-fg)" style="font-size:12px">
        <text x="180" y="415" text-anchor="middle">Context budget</text>
        <text x="450" y="415" text-anchor="middle">Subagent isolation</text>
        <text x="720" y="415" text-anchor="middle">Hooks as hard limits</text>
      </g>
      <text x="450" y="440" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">
        same tools, new host — not a different toolkit at each level
      </text>
    </g>

    <defs>
      <marker id="arrow" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto">
        <path d="M0,0 L8,4 L0,8 Z" fill="var(--na-zinc-600)" />
      </marker>
    </defs>
  </svg>
</template>
