<script setup lang="ts">
// G2 — Context window as a budget. A filling vertical bar, bottom to top:
// system prompt, CLAUDE.md, skills, tool results, conversation, then the
// drift zone where things go wrong.
const bands = [
  { key: 'system', label: 'System prompt', h: 30, color: 'var(--na-zinc-600)' },
  { key: 'claude-md', label: 'CLAUDE.md', h: 24, color: 'var(--na-zinc-500)' },
  { key: 'skills', label: 'Skills loaded', h: 46, color: 'var(--na-primary-700)' },
  { key: 'tool-results', label: 'Tool results', h: 110, color: 'var(--na-primary-500)' },
  { key: 'conversation', label: 'Conversation', h: 130, color: 'var(--na-primary-400)' },
] as const
const barWidth = 260
const barX = 350
const bottomY = 480
</script>

<template>
  <div class="w-full flex flex-col items-center">
    <svg viewBox="0 0 960 540" width="960" height="540" class="w-full max-w-2xl h-auto max-h-full" role="img" aria-label="Context window as a budget">
      <!-- outer container -->
      <rect :x="barX" y="60" :width="barWidth" :height="420" fill="none" stroke="var(--na-zinc-700)" stroke-width="2" rx="6" />

      <!-- drift zone at the very top -->
      <g v-click="5">
        <rect :x="barX" y="60" :width="barWidth" height="46" fill="var(--na-error-500)" opacity="0.85" rx="4" />
        <text :x="barX + barWidth / 2" y="88" text-anchor="middle" font-weight="700" fill="white" style="font-size:14px">drift zone</text>
      </g>

      <!-- bands, bottom to top -->
      <g v-for="(band, i) in bands" :key="band.key" v-click="i + 1">
        <rect
          :x="barX"
          :y="bottomY - bands.slice(0, i + 1).reduce((s, b) => s + b.h, 0)"
          :width="barWidth"
          :height="band.h"
          :fill="band.color"
        />
        <text
          :x="barX - 16"
          :y="bottomY - bands.slice(0, i).reduce((s, b) => s + b.h, 0) - band.h / 2 + 5"
          text-anchor="end"
          fill="var(--na-fg)"
          style="font-size:15px"
        >{{ band.label }}</text>
      </g>

      <!-- variable-size callout on the two growth bands -->
      <g v-click="5">
        <text :x="barX + barWidth + 20" y="330" fill="var(--na-fg-muted)" style="font-size:13px">tool results &amp;</text>
        <text :x="barX + barWidth + 20" y="348" fill="var(--na-fg-muted)" style="font-size:13px">conversation grow —</text>
        <text :x="barX + barWidth + 20" y="366" fill="var(--na-fg-muted)" style="font-size:13px">everything else is fixed</text>
        <text :x="barX + barWidth + 20" y="400" fill="var(--na-error-500)" font-weight="700" style="font-size:13px">uncontrolled, these</text>
        <text :x="barX + barWidth + 20" y="418" fill="var(--na-error-500)" font-weight="700" style="font-size:13px">push you into the</text>
        <text :x="barX + barWidth + 20" y="436" fill="var(--na-error-500)" font-weight="700" style="font-size:13px">drift zone</text>
      </g>
    </svg>
  </div>
</template>
