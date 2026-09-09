<script setup lang="ts">
// layout: section — divider carrying G4 (the toolkit map) with the current
// primitive row highlighted. The real diagram is ToolkitMap.vue; this layout
// just frames it plus the section title.
//
// Frontmatter:
//   heading: string
//   current: string   one of the ToolkitMap row keys — see components/ToolkitMap.vue
defineProps<{ heading?: string; current?: string }>()
</script>

<template>
  <div class="slidev-layout w-full h-full flex flex-col justify-center px-16 py-10 gap-8">
    <h1 class="text-5xl">{{ heading }}</h1>
    <slot name="map" />
  </div>
</template>
