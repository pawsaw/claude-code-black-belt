<script setup lang="ts">
// G13 — CLASH request architecture. Real names throughout: lib/data/*,
// app/actions/*, requireUser(), revalidatePath. Sets up G14's point that the
// layout guard and an action's own check are different things.
</script>

<template>
  <div class="w-full h-full flex items-center justify-center">
    <svg viewBox="0 0 1100 380" width="1100" height="380" class="w-full max-w-5xl h-auto max-h-full">
      <defs>
        <marker id="a13" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto">
          <path d="M0,0 L8,3 L0,6 Z" fill="var(--na-fg-muted)" />
        </marker>
      </defs>

      <text x="10" y="30" font-weight="700" fill="var(--na-fg-muted)" style="font-size:13px">READ PATH</text>
      <!-- read path, stage 1 -->
      <g v-click="1" font-family="Inter, sans-serif">
        <g v-for="(n, i) in [
          { x: 10, label: 'Browser' },
          { x: 220, label: 'RSC page' },
          { x: 430, label: 'lib/data/*.ts', mono: true },
          { x: 660, label: 'Prisma Client', sub: 'lib/generated/prisma' },
          { x: 890, label: 'SQLite', sub: 'dev.db' },
        ]" :key="i">
          <rect :x="n.x" y="45" width="180" height="55" rx="8" fill="var(--na-bg-raised)" stroke="var(--na-primary-500)" stroke-width="2" />
          <text :x="n.x + 90" y="72" text-anchor="middle" fill="var(--na-fg)" :font-family="n.mono ? 'JetBrains Mono, monospace' : 'Inter, sans-serif'" style="font-size:14px">{{ n.label }}</text>
          <text v-if="n.sub" :x="n.x + 90" y="88" text-anchor="middle" fill="var(--na-fg-muted)" font-family="JetBrains Mono, monospace" style="font-size:10px">{{ n.sub }}</text>
        </g>
        <line v-for="x in [190, 400, 630, 860]" :key="x" :x1="x" y1="72" :x2="x+25" y2="72" stroke="var(--na-fg-muted)" stroke-width="2" marker-end="url(#a13)" />
      </g>

      <text x="10" y="170" font-weight="700" fill="var(--na-fg-muted)" style="font-size:13px">WRITE PATH</text>
      <!-- write path up to Server Action, stage 2 -->
      <g v-click="2" font-family="Inter, sans-serif">
        <rect x="10" y="185" width="180" height="55" rx="8" fill="var(--na-bg-raised)" stroke="var(--na-secondary-500)" stroke-width="2" />
        <text x="100" y="217" text-anchor="middle" fill="var(--na-fg)" style="font-size:14px">Client (form submit)</text>

        <rect x="220" y="185" width="200" height="55" rx="8" fill="var(--na-bg-raised)" stroke="var(--na-secondary-500)" stroke-width="2" />
        <text x="320" y="208" text-anchor="middle" fill="var(--na-fg)" style="font-size:14px">Server Action</text>
        <text x="320" y="224" text-anchor="middle" fill="var(--na-fg-muted)" font-family="JetBrains Mono, monospace" style="font-size:10px">app/actions/*.ts</text>

        <line x1="190" y1="212" x2="215" y2="212" stroke="var(--na-fg-muted)" stroke-width="2" marker-end="url(#a13)" />
      </g>

      <!-- auth-check node, stage 3, accent -->
      <g v-click="3" font-family="Inter, sans-serif">
        <rect x="450" y="180" width="220" height="65" rx="8" fill="var(--na-bg)" stroke="var(--na-accent-500)" stroke-width="3" />
        <text x="560" y="205" text-anchor="middle" fill="var(--na-accent-500)" font-weight="700" style="font-size:13px">requireUser() +</text>
        <text x="560" y="222" text-anchor="middle" fill="var(--na-accent-500)" font-weight="700" style="font-size:13px">creatorId check</text>
        <text x="560" y="238" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:10px">the action's OWN check</text>
        <line x1="420" y1="212" x2="445" y2="212" stroke="var(--na-fg-muted)" stroke-width="2" marker-end="url(#a13)" />
        <line x1="670" y1="212" x2="655" y2="72" stroke="var(--na-fg-muted)" stroke-width="2" marker-end="url(#a13)" />
      </g>

      <!-- revalidatePath loop-back, stage 4 -->
      <g v-click="4" font-family="Inter, sans-serif">
        <path d="M 890,100 C 950,150 950,300 400,300 C 250,300 220,270 220,245" fill="none" stroke="var(--na-primary-400)" stroke-width="2" stroke-dasharray="4,4" marker-end="url(#a13)" />
        <text x="600" y="320" text-anchor="middle" fill="var(--na-primary-400)" font-family="JetBrains Mono, monospace" style="font-size:12px">revalidatePath() &#8594; RSC page refreshes</text>
      </g>
    </svg>
  </div>
</template>
