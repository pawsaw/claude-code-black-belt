<script setup lang="ts">
// G6 — Subagent isolation. Parent thread and child with separate context
// windows; only a summary crosses back.
const noise = [0, 1, 2, 3, 4, 5]
</script>

<template>
  <svg viewBox="0 0 960 540" width="960" height="540" class="w-full max-w-3xl h-auto max-h-full" font-family="Inter, sans-serif">
    <!-- idle frames -->
    <rect x="60" y="80" width="360" height="380" rx="14" fill="var(--na-bg-raised)" stroke="var(--na-zinc-700)" stroke-width="2" />
    <text x="80" y="115" font-weight="700" fill="var(--na-fg)" style="font-size:18px">Parent session</text>
    <rect x="80" y="130" width="320" height="18" rx="9" fill="var(--na-zinc-800)" />
    <rect x="80" y="130" width="30" height="18" rx="9" fill="var(--na-primary-500)" />

    <rect x="540" y="80" width="360" height="380" rx="14" fill="var(--na-bg-raised)" stroke="var(--na-zinc-700)" stroke-width="2" />
    <text x="560" y="115" font-weight="700" fill="var(--na-fg)" style="font-size:18px">Subagent</text>
    <text x="560" y="136" fill="var(--na-fg-muted)" style="font-size:13px">its own context window</text>

    <!-- stage 1: subagent fills with noisy tool calls -->
    <g v-click>
      <rect x="560" y="150" width="320" height="18" rx="9" fill="var(--na-zinc-800)" />
      <rect x="560" y="150" width="300" height="18" rx="9" fill="var(--na-secondary-600)" />
      <g v-for="i in noise" :key="i">
        <rect
          :x="560 + (i % 3) * 108" :y="190 + Math.floor(i / 3) * 50"
          width="98" height="38" rx="6"
          fill="var(--na-zinc-800)" stroke="var(--na-zinc-600)" stroke-width="1.5"
        />
        <text :x="570 + (i % 3) * 108" :y="214 + Math.floor(i / 3) * 50" fill="var(--na-fg-muted)" style="font-size:11px">
          grep / read / edit
        </text>
      </g>
      <text x="560" y="310" fill="var(--na-fg-muted)" style="font-size:13px">40 files read, dead ends explored, retries — all of it stays in here</text>
    </g>

    <!-- stage 2: thin summary crosses back, parent barely moves -->
    <g v-click>
      <path d="M 540 480 C 400 480, 300 480, 420 460" fill="none" stroke="var(--na-accent-500)" stroke-width="3" marker-end="url(#arrowG6)" />
      <rect x="150" y="440" width="200" height="30" rx="15" fill="var(--na-accent-500)" />
      <text x="250" y="460" text-anchor="middle" font-weight="700" fill="var(--na-zinc-950)" style="font-size:13px">summary only</text>

      <!-- parent context bar barely moves -->
      <rect x="80" y="400" width="320" height="18" rx="9" fill="var(--na-zinc-800)" />
      <rect x="80" y="400" width="45" height="18" rx="9" fill="var(--na-primary-500)" />
      <text x="80" y="395" fill="var(--na-fg-muted)" style="font-size:12px">/context on the main thread — barely moved</text>
    </g>

    <defs>
      <marker id="arrowG6" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto">
        <path d="M0,0 L8,4 L0,8 Z" fill="var(--na-accent-500)" />
      </marker>
    </defs>
  </svg>
</template>
