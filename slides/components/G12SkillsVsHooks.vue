<script setup lang="ts">
// G12 — skills vs hooks: advice vs law, the same rule expressed both ways.
// Used twice: foreshadowed (skill card only) in the skills section, shown in
// full (both cards) in the hooks section.
</script>

<template>
  <div class="w-full h-full flex items-center justify-center gap-10 px-10">
    <!-- Skill (advice) -->
    <div
      class="flex-1 max-w-md rounded-xl p-6"
      style="border: 2px dashed var(--na-zinc-600); background: var(--na-bg-raised)"
    >
      <div class="text-sm font-semibold mb-3" style="color: var(--na-fg-muted)">SKILL — advice</div>
      <div class="rounded-lg p-4 mb-4" style="background: var(--na-zinc-900)">
        <p class="text-lg leading-snug">
          "Every Server Action must check
          <code class="font-mono text-base" style="color: var(--na-accent-500)">creatorId !== user.id</code>."
        </p>
      </div>
      <div class="text-sm" style="color: var(--na-fg-muted)">
        Written in CLAUDE.md / SKILL.md. The agent reads it, understands it —
        and can still forget, or choose not to follow it under pressure.
      </div>
    </div>

    <!-- Hook (law) — revealed second -->
    <div
      v-click
      class="flex-1 max-w-md rounded-xl p-6"
      style="border: 2px solid var(--na-primary-500); background: var(--na-bg-raised); box-shadow: var(--na-shadow-accent)"
    >
      <div class="text-sm font-semibold mb-3" style="color: var(--na-primary-400)">HOOK — law</div>
      <pre class="rounded-lg p-4 mb-4 font-mono text-sm overflow-auto" style="background: var(--na-zinc-900); color: var(--na-fg)"><code>PostToolUse: Edit(app/actions/**)
&#8594; npx tsc --noEmit
exit 2 &#8594; blocks, agent must fix it</code></pre>
      <div class="text-sm flex items-start gap-2">
        <span style="color: var(--na-accent-500)">&#128274;</span>
        <span style="color: var(--na-fg-muted)">
          Runs outside the model, every time. Cannot be reasoned around,
          persuaded, or forgotten.
        </span>
      </div>
    </div>
  </div>
</template>
