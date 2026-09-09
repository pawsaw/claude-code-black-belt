<script setup lang="ts">
// layout: code-live — a placeholder code slide. NEVER contains a finished
// solution: a skeleton with real surrounding CLASH code and `// ⟵ LIVE`
// markers where the trainer types. The full working solution belongs only
// in the slide's presenter note (HTML comment), for the trainer's eyes.
//
// Frontmatter:
//   heading: string           heading naming what is about to be built
//   filePath: string        real CLASH file path, shown as the code block title
//   success: string         one-line "what good looks like" criterion
defineProps<{ heading?: string; filePath?: string; success?: string }>()
</script>

<template>
  <div class="slidev-layout w-full h-full flex flex-col px-14 py-10">
    <div class="flex items-start justify-between gap-4 shrink-0 mb-1">
      <h1 class="min-w-0">{{ heading }}</h1>
      <span
        class="text-xs font-mono px-2 py-1 rounded shrink-0 mt-2"
        style="background: var(--na-accent-500); color: var(--na-zinc-950)"
      >SKELETON — TRAINER TYPES LIVE</span>
    </div>
    <div v-if="filePath" class="font-mono text-sm mb-3 shrink-0" style="color: var(--na-fg-muted)">
      {{ filePath }}
    </div>
    <div class="flex-1 min-h-0 overflow-auto na-card p-4">
      <slot />
    </div>
    <div v-if="success" class="mt-4 shrink-0 text-base flex items-center gap-2">
      <span style="color: var(--na-success, #16a34a)">✓</span>
      <span style="color: var(--na-fg-muted)">What good looks like:</span>
      <span>{{ success }}</span>
    </div>
  </div>
</template>

<style scoped>
:deep(.slidev-code) {
  font-size: 0.95rem;
}
/* `// ⟵ LIVE` markers get a soft highlight wherever they appear in the fence */
:deep(pre) {
  white-space: pre-wrap;
}
</style>
