<script setup lang="ts">
// layout: task — one per entry in tasks/. QR + short URL to the task's
// markdown file, generated at build time by scripts/generate-qr.mjs into
// public/diagrams/qr/<slug>.svg.
//
// Frontmatter:
//   number: string        e.g. "03"
//   heading: string
//   goal: string           one sentence
//   timebox: string        e.g. "12 min"
//   mode: string            "follow along" | "watch only"
//   qrSlug: string          matches the generated QR filename, e.g. "03-subagent-audit"
//   repoUrl: string         short URL printed under the QR
//   success: string         one-line success criterion
const props = defineProps<{
  number?: string
  heading?: string
  goal?: string
  timebox?: string
  mode?: string
  qrSlug?: string
  repoUrl?: string
  success?: string
}>()
</script>

<template>
  <div class="slidev-layout w-full h-full flex px-14 py-12 gap-12 items-center">
    <div class="flex-1">
      <div class="flex items-center gap-3 mb-4">
        <span
          class="font-mono text-sm px-2 py-1 rounded"
          style="background: var(--na-primary-700); color: var(--na-primary-100)"
        >TASK {{ number }}</span>
        <span
          class="text-sm px-2 py-1 rounded"
          :style="mode === 'watch only'
            ? 'background: var(--na-accent-600); color: var(--na-zinc-950)'
            : 'background: var(--na-zinc-800); color: var(--na-fg-muted)'"
        >{{ mode }}</span>
        <span class="text-sm" style="color: var(--na-fg-muted)">{{ timebox }}</span>
      </div>
      <h1 class="mb-6">{{ heading }}</h1>
      <p class="text-xl mb-8" style="color: var(--na-fg)">{{ goal }}</p>
      <div v-if="success" class="flex items-start gap-2 text-base">
        <span style="color: var(--na-success, #16a34a)">✓</span>
        <span>{{ success }}</span>
      </div>
    </div>
    <div class="flex flex-col items-center gap-3 shrink-0">
      <div class="na-card p-3">
        <img
          v-if="qrSlug"
          :src="`/diagrams/qr/${qrSlug}.svg`"
          :alt="`QR code linking to tasks/${qrSlug}.md`"
          class="w-40 h-40"
        />
      </div>
      <span class="font-mono text-xs" style="color: var(--na-fg-muted)">{{ repoUrl }}</span>
    </div>
  </div>
</template>
