<script setup lang="ts">
// G5 — Skill loading. Progressive disclosure: description scanned every
// session -> body pulled in only on match.
const cards = [
  { name: 'clash-feature', desc: 'Add a feature: model -> action -> page.' },
  { name: 'code-review', desc: 'Review the current diff for bugs.' },
  { name: 'security-auditor', desc: 'Audit Server Actions for missing checks.' },
]
</script>

<template>
  <svg viewBox="0 0 960 420" width="960" height="420" class="w-full max-w-2xl h-auto max-h-full" font-family="Inter, sans-serif">
    <!-- stage 1: description-only cards, always in context -->
    <g v-click>
      <g v-for="(c, i) in cards" :key="c.name">
        <rect
          :x="140 + i * 260" y="20" width="220" height="90" rx="10"
          fill="var(--na-bg-raised)" stroke="var(--na-zinc-700)" stroke-width="2"
        />
        <text :x="150 + i * 260" y="48" font-weight="600" fill="var(--na-fg)" style="font-size:14px">name: {{ c.name }}</text>
        <text :x="150 + i * 260" y="72" fill="var(--na-fg-muted)" style="font-size:12px">description:</text>
        <foreignObject :x="150 + i * 260" y="78" width="200" height="28">
          <div style="font-size:12px; color: var(--na-fg-muted); line-height:1.3">{{ c.desc }}</div>
        </foreignObject>
      </g>
      <text x="480" y="140" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:15px">
        always in context — cheap, scanned on every prompt
      </text>
    </g>

    <!-- stage 2: one card matches and expands -->
    <g v-click>
      <line x1="270" y1="110" x2="270" y2="180" stroke="var(--na-accent-500)" stroke-width="2" marker-end="url(#arrowG5)" />
      <rect x="140" y="20" width="220" height="90" rx="10" fill="none" stroke="var(--na-accent-500)" stroke-width="3" />
      <rect x="110" y="190" width="740" height="180" rx="12" fill="var(--na-primary-900)" stroke="var(--na-accent-500)" stroke-width="2" />
      <text x="130" y="222" font-weight="700" fill="var(--na-accent-500)" style="font-size:16px">
        SKILL.md body — loaded now (match found)
      </text>
      <text x="130" y="255" fill="var(--na-fg)" style="font-size:13px">1. Prisma model  2. Migration  3. Zod schema in lib/validation.ts</text>
      <text x="130" y="280" fill="var(--na-fg)" style="font-size:13px">4. Read helper in lib/data/  5. Server Action + its own auth check</text>
      <text x="130" y="305" fill="var(--na-fg)" style="font-size:13px">6. RSC page  7. shadcn component  8. revalidatePath  9. notify</text>
      <text x="130" y="340" fill="var(--na-fg-muted)" style="font-size:13px">full checklist, examples, edge cases — only pulled in because this one matched</text>
    </g>

    <!-- stage 3: persists for the session -->
    <g v-click>
      <rect x="700" y="200" width="140" height="28" rx="14" fill="var(--na-success-500)" />
      <text x="770" y="219" text-anchor="middle" font-weight="600" fill="var(--na-zinc-950)" style="font-size:12px">stays loaded</text>
      <text x="480" y="400" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:13px">
        the other two cards never expanded — their token cost stayed at one line each
      </text>
    </g>

    <defs>
      <marker id="arrowG5" markerWidth="8" markerHeight="8" refX="4" refY="4" orient="auto">
        <path d="M0,0 L8,4 L0,8 Z" fill="var(--na-accent-500)" />
      </marker>
    </defs>
  </svg>
</template>
