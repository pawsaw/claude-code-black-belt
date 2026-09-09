<script setup lang="ts">
// G9 — Dynamic workflow fan-out. The centrepiece graphic: script -> phases ->
// parallel review agents -> verifier/refuter gate -> convergence. Findings
// mirror the workshop's real seeded bug (deleteClash / deleteVenue), so the
// diagram and the live demo tell the same story.
const files = [
  { key: 'auth', label: 'auth.ts', x: 30 },
  { key: 'clashes', label: 'clashes.ts', x: 180 },
  { key: 'notifications', label: 'notifications.ts', x: 330 },
  { key: 'profile', label: 'profile.ts', x: 480 },
  { key: 'search', label: 'search.ts', x: 630 },
  { key: 'venues', label: 'venues.ts', x: 780 },
] as const
const confirmed = new Set(['clashes', 'venues'])
const boxW = 130
</script>

<template>
  <svg viewBox="0 0 960 560" width="960" height="560" class="w-full max-w-4xl h-auto max-h-full" font-family="Inter, sans-serif">
    <defs>
      <marker id="wf-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
        <path d="M0,0 L10,5 L0,10 z" fill="var(--na-zinc-500)" />
      </marker>
      <marker id="wf-arrow-accent" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
        <path d="M0,0 L10,5 L0,10 z" fill="var(--na-accent-500)" />
      </marker>
    </defs>

    <!-- stage 1: the script -->
    <g v-click>
      <rect x="380" y="10" width="200" height="46" rx="8" fill="var(--na-primary-700)" stroke="var(--na-primary-400)" stroke-width="2" />
      <text x="480" y="30" text-anchor="middle" fill="var(--na-fg)" font-weight="700" style="font-size:13px">script</text>
      <text x="480" y="46" text-anchor="middle" fill="var(--na-primary-100)" font-family="'JetBrains Mono', monospace" style="font-size:9px">
        agent() · parallel() · phase()
      </text>
    </g>

    <!-- stage 2: phase Review, parallel fan-out to one agent per action file -->
    <g v-click>
      <rect x="15" y="80" width="930" height="120" rx="8" fill="none" stroke="var(--na-zinc-700)" stroke-dasharray="4 3" />
      <text x="30" y="98" fill="var(--na-fg-muted)" font-weight="600" style="font-size:12px">Phase: Review</text>
      <g v-for="f in files" :key="f.key">
        <line x1="480" y1="56" :x2="f.x + boxW / 2" y2="120" stroke="var(--na-zinc-600)" stroke-width="1.5" marker-end="url(#wf-arrow)" />
        <rect :x="f.x" y="120" :width="boxW" height="60" rx="6" fill="var(--na-zinc-900)" stroke="var(--na-zinc-700)" />
        <text :x="f.x + boxW / 2" y="145" text-anchor="middle" fill="var(--na-fg)" font-family="'JetBrains Mono', monospace" style="font-size:11px">{{ f.label }}</text>
        <text :x="f.x + boxW / 2" y="163" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:9px">review agent</text>
      </g>
    </g>

    <!-- stage 3: phase Verify, one verifier per finding -->
    <g v-click>
      <rect x="15" y="230" width="930" height="120" rx="8" fill="none" stroke="var(--na-zinc-700)" stroke-dasharray="4 3" />
      <text x="30" y="248" fill="var(--na-fg-muted)" font-weight="600" style="font-size:12px">Phase: Verify (refuter)</text>
      <g v-for="f in files" :key="f.key">
        <line :x1="f.x + boxW / 2" y1="180" :x2="f.x + boxW / 2" y2="270" stroke="var(--na-zinc-600)" stroke-width="1.5" marker-end="url(#wf-arrow)" />
        <rect :x="f.x" y="270" :width="boxW" height="60" rx="6" fill="var(--na-zinc-900)" stroke="var(--na-zinc-700)" />
        <text :x="f.x + boxW / 2" y="295" text-anchor="middle" fill="var(--na-fg)" style="font-size:11px">verify finding</text>
        <text :x="f.x + boxW / 2" y="312" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:9px">try to refute it</text>
      </g>
    </g>

    <!-- stage 4: results — most findings dropped, two survive with code evidence -->
    <g v-click>
      <g v-for="f in files" :key="f.key">
        <template v-if="confirmed.has(f.key)">
          <rect :x="f.x" y="360" :width="boxW" height="46" rx="6" fill="var(--na-primary-900)" stroke="var(--na-accent-500)" stroke-width="2" />
          <text :x="f.x + boxW / 2" y="380" text-anchor="middle" fill="var(--na-accent-500)" font-weight="700" style="font-size:11px">CONFIRMED</text>
          <text :x="f.x + boxW / 2" y="396" text-anchor="middle" fill="var(--na-fg)" style="font-size:9px">missing ownership check</text>
        </template>
        <template v-else>
          <rect :x="f.x" y="360" :width="boxW" height="46" rx="6" fill="var(--na-zinc-900)" stroke="var(--na-zinc-800)" />
          <text :x="f.x + boxW / 2" y="384" text-anchor="middle" fill="var(--na-zinc-600)" text-decoration="line-through" style="font-size:11px">dropped</text>
        </template>
      </g>
      <text x="480" y="440" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:13px">6 findings reviewed → 2 confirmed with code evidence</text>
    </g>

    <!-- stage 5: convergence into the merge -->
    <g v-click>
      <line x1="245" y1="406" x2="420" y2="480" stroke="var(--na-accent-500)" stroke-width="2.5" marker-end="url(#wf-arrow-accent)" />
      <line x1="845" y1="406" x2="540" y2="480" stroke="var(--na-accent-500)" stroke-width="2.5" marker-end="url(#wf-arrow-accent)" />
      <rect x="360" y="485" width="240" height="50" rx="8" fill="var(--na-primary-700)" stroke="var(--na-primary-400)" stroke-width="2" />
      <text x="480" y="507" text-anchor="middle" fill="var(--na-fg)" font-weight="700" style="font-size:13px">merge</text>
      <text x="480" y="524" text-anchor="middle" fill="var(--na-primary-100)" font-family="'JetBrains Mono', monospace" style="font-size:10px">app/actions/clashes.ts · venues.ts</text>
    </g>
  </svg>
</template>
