<script setup lang="ts">
// layout: concept — a graphic dominates; at most three short lines of text.
// Frontmatter:
//   heading?: string
//   lines?: string[]   up to 3 short supporting lines, shown below the graphic
withDefaults(defineProps<{ heading?: string; lines?: string[] }>(), {
  lines: () => [],
})
</script>

<template>
  <div class="slidev-layout w-full h-full flex flex-col px-16 py-12">
    <h1 v-if="heading" class="mb-6 shrink-0">{{ heading }}</h1>
    <div class="flex-1 min-h-0 flex items-center justify-center">
      <slot />
    </div>
    <ul v-if="lines.length" class="mt-6 shrink-0 space-y-1">
      <li
        v-for="(line, i) in lines.slice(0, 3)"
        :key="i"
        class="text-lg"
        :style="{ color: i === 0 ? 'var(--na-fg)' : 'var(--na-fg-muted)' }"
      >
        {{ line }}
      </li>
    </ul>
  </div>
</template>
