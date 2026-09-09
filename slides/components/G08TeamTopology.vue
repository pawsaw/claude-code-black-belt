<script setup lang="ts">
// G8 — Agent team topology. Lead + one peer per CLASH domain, messaging by
// name via SendMessage (NOT @-mentions — that syntax does not exist between
// team peers). Payoff: two peers reach different conclusions about the same
// file; the lead reconciles.
const peers = [
  { key: 'clashes', label: 'clashes peer', x: 140 },
  { key: 'venues', label: 'venues peer', x: 380 },
  { key: 'participations', label: 'participations peer', x: 580 },
  { key: 'profile', label: 'profile peer', x: 820 },
] as const
const leadX = 480
const leadY = 90
const peerY = 400
</script>

<template>
  <svg viewBox="0 0 960 540" width="960" height="540" class="w-full max-w-4xl h-auto max-h-full" font-family="Inter, sans-serif">
    <defs>
      <marker id="arrow-idle" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
        <path d="M0,0 L10,5 L0,10 z" fill="var(--na-zinc-600)" />
      </marker>
      <marker id="arrow-accent" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
        <path d="M0,0 L10,5 L0,10 z" fill="var(--na-accent-500)" />
      </marker>
      <marker id="arrow-primary" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse">
        <path d="M0,0 L10,5 L0,10 z" fill="var(--na-primary-400)" />
      </marker>
    </defs>

    <!-- stage 1: lead + peers with idle bidirectional links -->
    <g v-click>
      <rect :x="leadX - 90" :y="leadY - 30" width="180" height="60" rx="10"
        fill="var(--na-primary-700)" stroke="var(--na-primary-400)" stroke-width="2" />
      <text :x="leadX" :y="leadY + 6" text-anchor="middle" fill="var(--na-fg)" font-weight="700" style="font-size:18px">Lead</text>

      <g v-for="p in peers" :key="p.key">
        <line :x1="leadX" :y1="leadY + 30" :x2="p.x" :y2="peerY - 35"
          stroke="var(--na-zinc-600)" stroke-width="2" marker-end="url(#arrow-idle)" marker-start="url(#arrow-idle)" />
        <rect :x="p.x - 85" :y="peerY - 30" width="170" height="55" rx="10" class="na-card" fill="var(--na-zinc-900)" stroke="var(--na-zinc-700)" />
        <text :x="p.x" :y="peerY + 3" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:14px">{{ p.label }}</text>
      </g>
    </g>

    <!-- stage 2: two peers raise conflicting findings via SendMessage -->
    <g v-click>
      <line :x1="380" :y1="peerY - 35" :x2="leadX - 20" :y2="leadY + 32"
        stroke="var(--na-accent-500)" stroke-width="3" marker-end="url(#arrow-accent)" />
      <line :x1="580" :y1="peerY - 35" :x2="leadX + 20" :y2="leadY + 32"
        stroke="var(--na-accent-500)" stroke-width="3" marker-end="url(#arrow-accent)" />
      <text x="330" y="290" fill="var(--na-accent-500)" font-family="'JetBrains Mono', monospace" style="font-size:12px">SendMessage(lead):</text>
      <text x="330" y="308" fill="var(--na-fg)" style="font-size:12px">"venue delete looks safe"</text>
      <text x="600" y="290" fill="var(--na-accent-500)" font-family="'JetBrains Mono', monospace" style="font-size:12px">SendMessage(lead):</text>
      <text x="600" y="308" fill="var(--na-fg)" style="font-size:12px">"venue delete is missing a check"</text>
      <text :x="leadX" :y="leadY - 45" text-anchor="middle" fill="var(--na-accent-500)" font-weight="700" style="font-size:16px">⚠ disagreement</text>
    </g>

    <!-- stage 3: lead reconciles -->
    <g v-click>
      <line :x1="leadX - 25" :y1="leadY + 35" :x2="390" :y2="peerY - 40"
        stroke="var(--na-primary-400)" stroke-width="3" marker-end="url(#arrow-primary)" />
      <line :x1="leadX + 25" :y1="leadY + 35" :x2="570" :y2="peerY - 40"
        stroke="var(--na-primary-400)" stroke-width="3" marker-end="url(#arrow-primary)" />
      <text :x="leadX" :y="leadY + 65" text-anchor="middle" fill="var(--na-primary-400)" font-weight="600" style="font-size:13px">
        "confirmed missing — reviewed the diff myself"
      </text>
    </g>
  </svg>
</template>
