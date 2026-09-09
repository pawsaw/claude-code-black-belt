<script setup lang="ts">
// G3 — Same task, two approaches. Left: careless (grep-and-guess), tall
// stack, full/red context bar. Right: engineered (@-references + plan
// mode), short stack, mostly-empty/green context bar.
const careless = [
  'grep -r "notif" app/',
  'read 40 files',
  'guess the notification model',
  'guess the Server Action shape',
  'write code, hope it compiles',
]
const engineered = [
  '@lib/data/notifications.ts',
  '@app/actions/clashes.ts',
  '@prisma/schema.prisma',
  'Plan Mode: review before a byte moves',
]
</script>

<template>
  <div class="w-full grid grid-cols-2 gap-8">
    <!-- careless -->
    <div class="flex flex-col items-center gap-2">
      <div class="text-base font-semibold" style="color: var(--na-fg-muted)">Careless</div>
      <div class="flex flex-col-reverse gap-1 w-full">
        <div
          v-for="(step, i) in careless" :key="step"
          v-click="i + 1"
          class="na-card px-3 py-1.5 text-sm"
          style="border-color: var(--na-zinc-700)"
        >{{ step }}</div>
      </div>
      <div v-click="6" class="w-full h-5 rounded" style="background: var(--na-error-500); opacity: 0.85" />
      <div v-click="6" class="text-sm" style="color: var(--na-error-500)">context: ~85% consumed</div>
    </div>

    <!-- engineered -->
    <div class="flex flex-col items-center gap-2">
      <div class="text-base font-semibold" style="color: var(--na-fg-muted)">Engineered</div>
      <div class="flex flex-col-reverse gap-1 w-full">
        <div
          v-for="(step, i) in engineered" :key="step"
          v-click="i + 7"
          class="na-card px-3 py-1.5 text-sm font-mono"
          style="border-color: var(--na-primary-500)"
        >{{ step }}</div>
      </div>
      <div v-click="11" class="w-full rounded overflow-hidden flex" style="border: 1px solid var(--na-zinc-700)">
        <div class="h-5" style="width: 18%; background: var(--na-success-500, #16a34a)" />
        <div class="h-5 flex-1" style="background: var(--na-zinc-900)" />
      </div>
      <div v-click="11" class="text-sm" style="color: var(--na-success-500, #16a34a)">context: ~18% consumed</div>
    </div>

    <p v-click="11" class="col-span-2 text-base text-center mt-1">
      Same task. The difference is what you let into the window in the first place.
    </p>
  </div>
</template>
