---
layout: concept
---

<div class="flex flex-col items-center gap-8 text-center">
  <img src="/brand/nalogo.png" alt="nextacademy.io" class="w-20 h-20" />
  <div>
    <h1 class="!mb-2">Claude Code: Black Belt</h1>
    <p class="text-2xl" style="color: var(--na-fg-muted)">
      Learn What's Next. <span style="color: var(--na-primary-400); font-weight: 700">Today.</span>
    </p>
  </div>
  <div class="text-lg" style="color: var(--na-fg-muted)">
    <div>Pawel Sawicki · nextacademy.io</div>
    <div>React Day Berlin 2026</div>
    <div class="mt-2">4 hours · code-along · no silent phases</div>
  </div>
</div>

<!--
Welcome. This is a live, remote code-along delivered via Zoom as part of React Day Berlin
2026 — everyone follows along on their own machine, there is no "watch a recording later"
version of most of this. Say up front: this room uses Claude Code daily but is not full of
experts in it — you already know CLAUDE.md, plan mode, and roughly what a subagent is.
You've never written a hook, never authored a skill, never seen a dynamic workflow. That's
exactly the gap this workshop closes. The risk today is volume, not difficulty, so the last
hour is deliberately narrow — we are not trying to cover everything, we're trying to cover
the right seven things, in order, on one real codebase.
-->

---
layout: concept
heading: "Your trainer"
---

<div class="flex items-center gap-10 w-full justify-center">
  <img
    src="/brand/pawel-sawicki.webp"
    alt="Pawel Sawicki"
    class="w-40 h-40 rounded-lg object-cover shrink-0"
    style="border: 2px solid var(--na-accent-500)"
  />
  <div class="max-w-xl">
    <div class="text-3xl font-bold" style="color: var(--na-fg)">Pawel Sawicki</div>
    <div class="text-lg font-semibold mt-1" style="color: var(--na-accent-500)">
      Founder, nextacademy.io · Founder, TuneTrain.ai
    </div>
    <p class="text-lg mt-4" style="color: var(--na-fg-muted)">
      15+ years as an independent consultant, 5+ years focused on data
      science, machine learning, and deep learning.
    </p>
  </div>
  <div class="flex flex-col items-center gap-2 shrink-0">
    <div class="na-card p-2">
      <img src="/diagrams/qr/linkedin.svg" alt="QR code linking to LinkedIn" class="w-28 h-28" />
    </div>
    <span class="font-mono text-xs" style="color: var(--na-fg-muted)">linkedin.com/in/sawickipawel</span>
  </div>
</div>

<!--
30-second beat, not counted against the 240-minute block budget (same treatment as the title
slide itself — this is pre-00:00 framing, not block content). One breath: who you are, that
you founded both nextacademy.io and TuneTrain.ai, then move straight into the "by 19:00"
promise on the next slide. Don't linger — the room is here for CLASH, not a biography.
-->

---
layout: concept
heading: "By 19:00, CLASH has:"
---

<ul class="text-xl space-y-3">
  <li v-click>A real authorization audit — and merged fixes</li>
  <li v-click>A test suite, a perf fix, and a real-time notifications plan</li>
  <li v-click>A reusable Skill and hook set that outlives the room</li>
</ul>

<!--
This is the promise, stated plainly before anything else. Every one of these ships from
code you write live, on stage, on the real CLASH repository — not a toy. Say once, clearly:
you are not building CLASH today, CLASH is already fully built; you are extending it. If
that's not clear now, several slides later will feel like they assume knowledge you don't
have.
-->
