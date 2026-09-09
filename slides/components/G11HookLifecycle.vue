<script setup lang="ts">
// G11 — the hook lifecycle. PreToolUse -> Tool -> PostToolUse -> Stop, with
// the exit-code branch that blocks. Only exit code 2 blocks; every other
// exit code (including plain non-zero) continues, and exit-0 stdout on
// PreToolUse/PostToolUse never reaches the agent (debug log only).
</script>

<template>
  <div class="w-full h-full flex items-center justify-center">
    <svg viewBox="0 0 1000 460" width="1000" height="460" class="w-full max-w-5xl h-auto max-h-full">
      <defs>
        <marker id="arrow" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto">
          <path d="M0,0 L8,3 L0,6 Z" fill="var(--na-fg-muted)" />
        </marker>
        <marker id="arrow-error" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto">
          <path d="M0,0 L8,3 L0,6 Z" fill="var(--na-error-500)" />
        </marker>
      </defs>

      <!-- main lifecycle row -->
      <g font-family="Inter, sans-serif">
        <!-- Agent -->
        <rect x="10" y="90" width="130" height="60" rx="10" fill="var(--na-bg-raised)" stroke="var(--na-primary-500)" stroke-width="2" />
        <text x="75" y="125" text-anchor="middle" fill="var(--na-fg)" font-weight="600" style="font-size:18px">Agent</text>

        <!-- PreToolUse -->
        <rect x="210" y="90" width="170" height="60" rx="10" fill="var(--na-bg-raised)" stroke="var(--na-zinc-600)" stroke-width="2" />
        <text x="295" y="125" text-anchor="middle" fill="var(--na-fg)" font-weight="600" style="font-size:17px">PreToolUse</text>

        <!-- Tool -->
        <rect x="450" y="90" width="130" height="60" rx="10" fill="var(--na-bg-raised)" stroke="var(--na-zinc-600)" stroke-width="2" />
        <text x="515" y="125" text-anchor="middle" fill="var(--na-fg)" font-weight="600" style="font-size:18px">Tool</text>

        <!-- PostToolUse -->
        <rect x="650" y="90" width="180" height="60" rx="10" fill="var(--na-bg-raised)" stroke="var(--na-zinc-600)" stroke-width="2" />
        <text x="740" y="125" text-anchor="middle" fill="var(--na-fg)" font-weight="600" style="font-size:17px">PostToolUse</text>

        <!-- Stop -->
        <rect x="880" y="90" width="100" height="60" rx="10" fill="var(--na-bg-raised)" stroke="var(--na-zinc-600)" stroke-width="2" transform="translate(-10,0)" />
        <text x="930" y="125" text-anchor="middle" fill="var(--na-fg)" font-weight="600" transform="translate(-10,0)" style="font-size:18px">Stop</text>

        <!-- connecting arrows, always visible -->
        <line x1="140" y1="120" x2="205" y2="120" stroke="var(--na-fg-muted)" stroke-width="2" marker-end="url(#arrow)" />
        <line x1="380" y1="120" x2="445" y2="120" stroke="var(--na-fg-muted)" stroke-width="2" marker-end="url(#arrow)" />
        <line x1="580" y1="120" x2="645" y2="120" stroke="var(--na-fg-muted)" stroke-width="2" marker-end="url(#arrow)" />
        <line x1="830" y1="120" x2="875" y2="120" stroke="var(--na-fg-muted)" stroke-width="2" marker-end="url(#arrow)" />

        <!-- exit-0 continues labels, stage 1 -->
        <g v-click="1">
          <text x="295" y="75" text-anchor="middle" fill="var(--na-primary-400)" style="font-size:12px">exit 0 → continues</text>
          <text x="740" y="75" text-anchor="middle" fill="var(--na-primary-400)" style="font-size:12px">exit 0 → continues</text>
          <text x="295" y="168" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">stdout: debug log only</text>
          <text x="740" y="168" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">stdout: debug log only</text>
        </g>

        <!-- PreToolUse block branch, stage 2 -->
        <g v-click="2">
          <path d="M 295,150 C 295,240 120,240 90,155" fill="none" stroke="var(--na-error-500)" stroke-width="2" stroke-dasharray="5,4" marker-end="url(#arrow-error)" />
          <rect x="180" y="255" width="230" height="55" rx="8" fill="var(--na-bg)" stroke="var(--na-error-500)" stroke-width="2" />
          <text x="295" y="278" text-anchor="middle" fill="var(--na-error-500)" font-weight="700" style="font-size:13px">exit 2 → BLOCKS</text>
          <text x="295" y="296" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">stderr returns to agent</text>
          <line x1="295" y1="150" x2="295" y2="255" stroke="var(--na-error-500)" stroke-width="2" />
        </g>

        <!-- PostToolUse block branch, stage 3 -->
        <g v-click="3">
          <path d="M 740,150 C 740,260 300,260 90,160" fill="none" stroke="var(--na-error-500)" stroke-width="2" stroke-dasharray="5,4" marker-end="url(#arrow-error)" />
          <rect x="630" y="330" width="230" height="70" rx="8" fill="var(--na-bg)" stroke="var(--na-error-500)" stroke-width="2" />
          <text x="745" y="352" text-anchor="middle" fill="var(--na-error-500)" font-weight="700" style="font-size:13px">exit 2 → BLOCKS (informational)</text>
          <text x="745" y="370" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">tool already ran — stderr</text>
          <text x="745" y="385" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">surfaces as a warning only</text>
          <line x1="740" y1="150" x2="745" y2="330" stroke="var(--na-error-500)" stroke-width="2" />
        </g>

        <!-- Stop's own gate, stage 4 -->
        <g v-click="4">
          <path d="M 900,150 C 900,190 890,190 887,220" fill="none" stroke="var(--na-error-500)" stroke-width="2" marker-end="url(#arrow-error)" />
          <rect x="770" y="225" width="220" height="55" rx="8" fill="var(--na-bg)" stroke="var(--na-accent-500)" stroke-width="2" />
          <text x="880" y="248" text-anchor="middle" fill="var(--na-accent-500)" font-weight="700" style="font-size:13px">Stop: exit 2 → BLOCKS</text>
          <text x="880" y="266" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">turn cannot end while failing</text>
        </g>
      </g>
    </svg>
  </div>
</template>
