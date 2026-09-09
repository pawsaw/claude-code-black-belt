<script setup lang="ts">
// G20 — Spec Kit vs BMAD, positioned on ceremony (x) and org-role-fit (y).
// Ground truth: Spec Kit — GitHub, MIT, ~134k stars, agent-agnostic,
// `specify init` (Python/uv, not npm), low ceremony. BMAD v6 (v6.12.0) —
// 5 named agent personas (Analyst/Mary, PM/John, Architect/Winston,
// Developer/Amelia, UX/Sally) — NOT "12+ personas" (that's stale v4).
// Heavyweight, MIT, canonical repo bmad-code-org/BMAD-METHOD.
</script>

<template>
  <svg viewBox="0 0 900 540" width="900" height="540" class="w-full max-w-3xl h-auto max-h-full" font-family="Inter, sans-serif">
    <!-- axes -->
    <g v-click>
      <line x1="100" y1="440" x2="820" y2="440" stroke="var(--na-zinc-600)" stroke-width="2" />
      <line x1="100" y1="440" x2="100" y2="40" stroke="var(--na-zinc-600)" stroke-width="2" />
      <text x="460" y="480" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:13px">ceremony →</text>
      <text x="460" y="500" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:11px">low (specs as markdown)  ·  high (12+ artifacts, gated phases)</text>
      <text x="60" y="240" text-anchor="middle" fill="var(--na-fg-muted)" transform="rotate(-90 60 240)" style="font-size:13px">org-role-fit →</text>
      <text x="30" y="420" fill="var(--na-fg-muted)" style="font-size:11px">generic</text>
      <text x="10" y="60" fill="var(--na-fg-muted)" style="font-size:11px">matches existing roles</text>
    </g>

    <!-- Spec Kit: low ceremony, generic fit -->
    <g v-click>
      <circle cx="230" cy="360" r="14" fill="var(--na-primary-400)" />
      <rect x="140" y="380" width="180" height="98" rx="10" fill="var(--na-bg-raised)" stroke="var(--na-primary-400)" stroke-width="1.5" />
      <text x="230" y="402" text-anchor="middle" fill="var(--na-fg)" font-weight="700" style="font-size:14px">Spec Kit</text>
      <text x="230" y="420" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:10px">GitHub · MIT · ~134k ★</text>
      <text x="230" y="435" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:10px">agent-agnostic · specify init</text>
      <text x="230" y="450" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:10px">Python / uv, not npm</text>
      <text x="230" y="465" text-anchor="middle" fill="var(--na-accent-500)" font-weight="600" style="font-size:10px">low ceremony</text>
    </g>

    <!-- BMAD: high ceremony, role fit -->
    <g v-click>
      <circle cx="690" cy="110" r="14" fill="var(--na-secondary-500)" />
      <rect x="590" y="120" width="220" height="128" rx="10" fill="var(--na-bg-raised)" stroke="var(--na-secondary-500)" stroke-width="1.5" />
      <text x="700" y="142" text-anchor="middle" fill="var(--na-fg)" font-weight="700" style="font-size:14px">BMAD v6</text>
      <text x="700" y="160" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:10px">bmad-code-org/BMAD-METHOD · MIT</text>
      <text x="700" y="176" text-anchor="middle" fill="var(--na-fg)" font-weight="600" style="font-size:10px">5 named agents</text>
      <text x="700" y="191" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:9px">Analyst · PM · Architect · Dev · UX</text>
      <text x="700" y="206" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:9px">(not "12+ personas" — that's v4)</text>
      <text x="700" y="224" text-anchor="middle" fill="var(--na-secondary-500)" font-weight="600" style="font-size:10px">heavyweight · maps onto real org roles</text>
      <text x="700" y="240" text-anchor="middle" fill="var(--na-fg-muted)" style="font-size:9px">reproduces your process, doesn't invent one</text>
    </g>

    <!-- closing honesty banner -->
    <g v-click>
      <rect x="80" y="10" width="740" height="40" rx="10" fill="var(--na-accent-500)" />
      <text x="450" y="35" text-anchor="middle" fill="var(--na-zinc-950)" font-weight="700" style="font-size:14px">
        Both are greenfield methodologies — CLASH is brownfield
      </text>
    </g>
  </svg>
</template>
