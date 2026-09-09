<script setup lang="ts">
// G15 — MCP topology. Claude Code <-> MCP servers <-> browser / external systems.
</script>

<template>
  <div class="w-full flex justify-center">
    <svg viewBox="0 0 960 420" width="960" height="420" class="w-full max-w-4xl h-auto max-h-full">
      <!-- Claude Code hub -->
      <g v-click>
        <rect x="400" y="40" width="160" height="60" rx="10" fill="var(--na-primary-700)" stroke="var(--na-primary-400)" stroke-width="2" />
        <text x="480" y="76" font-weight="700" fill="var(--na-fg)" text-anchor="middle" style="font-size:18px">Claude Code</text>
      </g>

      <!-- MCP servers -->
      <g v-click>
        <line x1="440" y1="100" x2="260" y2="190" stroke="var(--na-zinc-500)" stroke-width="2" marker-end="url(#arrowM)" />
        <line x1="260" y1="190" x2="440" y2="100" stroke="var(--na-zinc-500)" stroke-width="2" marker-end="url(#arrowM)" />
        <rect x="180" y="190" width="160" height="56" rx="10" class="na-card" style="fill: var(--na-bg-raised); stroke: var(--na-border)" />
        <text x="260" y="222" font-weight="600" fill="var(--na-fg)" text-anchor="middle" style="font-size:15px">Playwright MCP</text>

        <line x1="520" y1="100" x2="700" y2="190" stroke="var(--na-zinc-500)" stroke-width="2" marker-end="url(#arrowM)" />
        <line x1="700" y1="190" x2="520" y2="100" stroke="var(--na-zinc-500)" stroke-width="2" marker-end="url(#arrowM)" />
        <rect x="620" y="190" width="160" height="56" rx="10" class="na-card" style="fill: var(--na-bg-raised); stroke: var(--na-border)" />
        <text x="700" y="222" font-weight="600" fill="var(--na-fg)" text-anchor="middle" style="font-size:15px">Chrome DevTools MCP</text>
      </g>

      <!-- Onward connections -->
      <g v-click>
        <line x1="260" y1="246" x2="260" y2="330" stroke="var(--na-accent-500)" stroke-width="2" marker-end="url(#arrowA)" />
        <rect x="150" y="330" width="220" height="50" rx="10" fill="var(--na-primary-900)" stroke="var(--na-accent-500)" stroke-width="1.5" />
        <text x="260" y="360" fill="var(--na-fg)" text-anchor="middle" style="font-size:14px">localhost:3000 (CLASH)</text>

        <line x1="700" y1="246" x2="700" y2="330" stroke="var(--na-accent-500)" stroke-width="2" marker-end="url(#arrowA)" />
        <rect x="590" y="330" width="220" height="50" rx="10" fill="var(--na-primary-900)" stroke="var(--na-accent-500)" stroke-width="1.5" />
        <text x="700" y="360" fill="var(--na-fg)" text-anchor="middle" style="font-size:14px">Chrome / DevTools protocol</text>
      </g>

      <defs>
        <marker id="arrowM" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto">
          <path d="M0,0 L8,4 L0,8 Z" fill="var(--na-zinc-500)" />
        </marker>
        <marker id="arrowA" markerWidth="8" markerHeight="8" refX="6" refY="4" orient="auto">
          <path d="M0,0 L8,4 L0,8 Z" fill="var(--na-accent-500)" />
        </marker>
      </defs>
    </svg>
  </div>
</template>
