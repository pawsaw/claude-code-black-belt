<script setup lang="ts">
// G7 — Subagent fork vs fresh. Fork inherits conversation + prompt cache;
// fresh starts clean. Cost implication must be visible.
</script>

<template>
  <svg viewBox="0 0 960 540" width="960" height="540" class="w-full max-w-3xl h-auto max-h-full" font-family="Inter, sans-serif">
    <!-- parent conversation, always visible -->
    <rect x="330" y="30" width="300" height="60" rx="10" fill="var(--na-bg-raised)" stroke="var(--na-zinc-700)" stroke-width="2" />
    <text x="480" y="55" text-anchor="middle" font-weight="700" fill="var(--na-fg)" style="font-size:14px">Parent conversation</text>
    <text x="480" y="74" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">full history + prompt cache</text>

    <!-- stage 1: fork branches off, inherits everything, cheap -->
    <g v-click>
      <path d="M 400 90 C 320 140, 260 160, 220 190" fill="none" stroke="var(--na-success-500)" stroke-width="3" marker-end="url(#arrowG7a)" />
      <rect x="60" y="200" width="320" height="260" rx="14" fill="var(--na-bg-raised)" stroke="var(--na-success-500)" stroke-width="2" />
      <text x="80" y="234" font-weight="700" fill="var(--na-fg)" style="font-size:18px">Fork</text>
      <text x="80" y="256" fill="var(--na-fg-muted)" style="font-size:12px">on by default in interactive sessions</text>
      <rect x="80" y="270" width="280" height="20" rx="10" fill="var(--na-success-500)" opacity="0.85" />
      <text x="220" y="284" text-anchor="middle" font-weight="700" fill="var(--na-zinc-950)" style="font-size:11px">inherits full history + tools + model</text>
      <rect x="80" y="300" width="280" height="20" rx="10" fill="var(--na-success-500)" opacity="0.6" />
      <text x="220" y="314" text-anchor="middle" font-weight="700" fill="var(--na-zinc-950)" style="font-size:11px">inherits prompt-cache TTL</text>
      <text x="80" y="410" font-weight="800" fill="var(--na-success-500)" style="font-size:28px">$</text>
      <text x="110" y="410" fill="var(--na-fg-muted)" style="font-size:13px">cache hit — cheap when shared context is genuinely needed</text>
    </g>

    <!-- stage 2: fresh subagent starts clean, cold, more expensive -->
    <g v-click>
      <path d="M 560 90 C 640 140, 700 160, 740 190" fill="none" stroke="var(--na-secondary-600)" stroke-width="3" marker-end="url(#arrowG7b)" />
      <rect x="580" y="200" width="320" height="260" rx="14" fill="var(--na-bg-raised)" stroke="var(--na-secondary-600)" stroke-width="2" />
      <text x="600" y="234" font-weight="700" fill="var(--na-fg)" style="font-size:18px">Fresh subagent</text>
      <text x="600" y="256" fill="var(--na-fg-muted)" style="font-size:12px">explicit, or fork mode disabled</text>
      <rect x="600" y="270" width="0" height="20" rx="10" fill="var(--na-zinc-700)" />
      <rect x="600" y="270" width="280" height="20" rx="10" fill="var(--na-zinc-800)" stroke="var(--na-zinc-600)" stroke-width="1" />
      <text x="740" y="284" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">clean context — own system prompt</text>
      <rect x="600" y="300" width="280" height="20" rx="10" fill="var(--na-zinc-800)" stroke="var(--na-zinc-600)" stroke-width="1" />
      <text x="740" y="314" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">no cache inheritance — cold start</text>
      <text x="600" y="410" font-weight="800" fill="var(--na-secondary-600)" style="font-size:28px">$$</text>
      <text x="640" y="410" fill="var(--na-fg-muted)" style="font-size:13px">full-price first call — worth it when isolation matters more than cost</text>
    </g>

    <defs>
      <marker id="arrowG7a" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="var(--na-success-500)" /></marker>
      <marker id="arrowG7b" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 Z" fill="var(--na-secondary-600)" /></marker>
    </defs>
  </svg>
</template>
