<script setup lang="ts">
// G14 — THE centrepiece graphic. requireUser() guards the page; a direct
// POST to the action's generated ID bypasses it entirely. Ground truth:
// app/(app)/layout.tsx calls requireUser() for every page under it, but
// app/actions/*.ts Server Actions (e.g. deleteClash, deleteVenue) are their
// own public POST endpoints, reachable without ever loading a guarded page.
</script>

<template>
  <div class="w-full h-full flex items-center justify-center">
    <svg viewBox="0 0 1000 460" width="1000" height="460" class="w-full max-w-5xl h-auto max-h-full">
      <defs>
        <marker id="a14" markerWidth="10" markerHeight="10" refX="8" refY="3" orient="auto">
          <path d="M0,0 L8,3 L0,6 Z" fill="var(--na-fg-muted)" />
        </marker>
        <marker id="a14-danger" markerWidth="12" markerHeight="12" refX="9" refY="4" orient="auto">
          <path d="M0,0 L9,4 L0,8 Z" fill="var(--na-error-500)" />
        </marker>
      </defs>

      <!-- safe path, stage 1 -->
      <g v-click="1" font-family="Inter, sans-serif">
        <text x="20" y="35" font-weight="700" fill="var(--na-primary-400)" style="font-size:13px">THE INTENDED ROUTE</text>
        <rect x="20" y="55" width="150" height="55" rx="8" fill="var(--na-bg-raised)" stroke="var(--na-primary-500)" stroke-width="2" />
        <text x="95" y="88" text-anchor="middle" fill="var(--na-fg)" style="font-size:14px">Browser</text>

        <rect x="230" y="55" width="190" height="55" rx="8" fill="var(--na-bg-raised)" stroke="var(--na-primary-500)" stroke-width="2" />
        <text x="325" y="80" text-anchor="middle" fill="var(--na-fg)" style="font-size:13px">Page 🛡️ requireUser()</text>
        <text x="325" y="96" text-anchor="middle" fill="var(--na-fg-muted)" font-family="JetBrains Mono, monospace" style="font-size:10px">app/(app)/layout.tsx</text>

        <line x1="170" y1="82" x2="225" y2="82" stroke="var(--na-fg-muted)" stroke-width="2" marker-end="url(#a14)" />
      </g>

      <!-- shared action node -->
      <g font-family="Inter, sans-serif">
        <rect x="480" y="180" width="230" height="65" rx="8" fill="var(--na-bg)" stroke="var(--na-primary-500)" stroke-width="2" />
        <text x="595" y="205" text-anchor="middle" fill="var(--na-fg)" font-weight="700" style="font-size:13px">Server Action</text>
        <text x="595" y="222" text-anchor="middle" fill="var(--na-fg-muted)" font-family="JetBrains Mono, monospace" style="font-size:11px">deleteClash / deleteVenue</text>
        <text x="595" y="237" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:10px">a public POST endpoint, generated id</text>
      </g>

      <g v-click="1">
        <path d="M 325,110 C 325,150 480,150 570,178" fill="none" stroke="var(--na-primary-400)" stroke-width="2" marker-end="url(#a14)" />
      </g>

      <!-- bypass path, stage 2, dramatic -->
      <g v-click="2" font-family="Inter, sans-serif">
        <text x="780" y="35" font-weight="700" fill="var(--na-error-500)" style="font-size:13px">THE BYPASS</text>
        <rect x="770" y="55" width="200" height="55" rx="8" fill="var(--na-bg-raised)" stroke="var(--na-error-500)" stroke-width="2" />
        <text x="870" y="80" text-anchor="middle" fill="var(--na-fg)" style="font-size:13px">Any authenticated user</text>
        <text x="870" y="96" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:10px">valid session cookie only</text>

        <path d="M 870,110 C 870,150 750,160 640,178" fill="none" stroke="var(--na-error-500)" stroke-width="3" stroke-dasharray="6,4" marker-end="url(#a14-danger)" />
        <rect x="620" y="120" width="270" height="45" rx="6" fill="var(--na-bg)" stroke="var(--na-error-500)" stroke-width="2" />
        <text x="755" y="140" text-anchor="middle" fill="var(--na-error-500)" font-weight="700" style="font-size:12px">requireUser() never runs</text>
        <text x="755" y="156" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:10px">this request never loaded a page</text>
      </g>

      <!-- convergence + closing label, stage 3 -->
      <g v-click="3" font-family="Inter, sans-serif">
        <text x="595" y="280" text-anchor="middle" fill="var(--na-accent-500)" font-weight="700" style="font-size:13px">both routes reach the same code</text>
        <text x="595" y="300" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:12px">only the action's OWN check decides what happens next</text>
      </g>

      <g v-click="4" font-family="Inter, sans-serif">
        <rect x="345" y="335" width="500" height="55" rx="8" fill="var(--na-bg)" stroke="var(--na-accent-500)" stroke-width="2" />
        <text x="595" y="358" text-anchor="middle" fill="var(--na-accent-500)" font-weight="700" style="font-size:16px">Zod validates shape, not permission.</text>
        <text x="595" y="378" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">the ownership check is the only thing standing between the two paths</text>
      </g>
    </svg>
  </div>
</template>
