# Organized Workshop — Demo Project Phased Plan

**Machine:** supabowl (M1 MacBook Pro)
**Default local path:** `/Users/supabowl/organized-workshop`
**GitHub repo:** `Organized-AI/organized-workshop`
**Template source:** `Organized-AI/organized-codebase` — branch `feature/bootstrap-qa-loop`
(latest bootstrap updates: `scripts/apply-organized-codebase.sh` +
`scripts/qa/bootstrap-qa.sh` QA gate. Not yet merged to `main`, no PR open —
copied directly into this repo as of the bootstrap commit.)

> Flag: `organized-codebase`'s `.env.example` on `main` has what look like live,
> non-placeholder `OPENROUTER_API_KEY` / `GLM_API_KEY` values checked in. Worth
> rotating/scrubbing before this repo (or that one) gets forked more widely.

---

## // ARCHITECTURE DIAGRAM

```
 LOCAL (supabowl / M1 Pro)
 ──────────────────────────
 /Users/supabowl/organized-workshop
        │
        │  1. organized-codebase @ feature/bootstrap-qa-loop scripts, applied here
        │  2. scripts/apply-organized-codebase.sh   (template application)
        │  3. scripts/qa/bootstrap-qa.sh            (QA gate — must pass)
        ▼
 ┌───────────────────────────────────────────────────────────┐
 │  .claude/{agents,commands,hooks,skills}                     │
 │  PLANNING/  ARCHITECTURE/  DOCUMENTATION/  SPECIFICATIONS/    │
 │  AGENT-HANDOFF/  CONFIG/  scripts/  .archive/                 │
 └───────────────────────────────────────────────────────────┘
        │
        ▼
 CONTENT ROUTER — FIVE SURFACES  (Cloudflare Workers Assets)
 ──────────────────────────────────────────────────────────
   Guide      guide.organizedai.vip/organized-workshop
   Wiki       wiki.organizedai.vip/organized-workshop
   Arch       arch.organizedai.vip/organized-workshop
   Source     source.organizedai.vip/organized-workshop
   Building   building.organizedai.vip/organized-workshop
        │
        │  registered in organizedai-vanity-router
        ▼
 LOOP ENGINEERING MODULE  (spec → build → review)
 ──────────────────────────────────────────────────
   TRACKER ADAPTER ──┬──► D1 "loop-tracker" Worker (default)
                       └──► Linear (optional)
   NOTIFY ADAPTER  ──┬──► Slack
                       └──► Discord
        │
        ▼
 CLOUDFLARE WORKERS BUILDS  (GitHub-connected)
   every PR  → preview URL
   on merge  → production deploy
        │
        ├── TRACK A: Content Engine ──► TwelveLabs (index/highlight) + HyperFrames (cut/export)
        └── TRACK B: Journey Capture ──► GTM + GA4 + Meta CAPI (via Stape)
```

---

## // PHASED BUILD ORDER (order only — no time estimates)

### Phase 0 — Bootstrap from Organized Codebase
1. Copy `scripts/apply-organized-codebase.sh` + `scripts/qa/bootstrap-qa.sh` from
   `organized-codebase@feature/bootstrap-qa-loop` into this repo (done in this commit).
2. Run `scripts/apply-organized-codebase.sh` locally against
   `/Users/supabowl/organized-workshop` to lay down the full template structure
   (`.claude/`, `PLANNING/`, etc. — some already present from this commit).
3. Run `scripts/qa/bootstrap-qa.sh . 0` as a gate — do not proceed to Phase 1 until
   it passes clean.
4. Confirm git remote points at `https://github.com/Organized-AI/organized-workshop`.

### Phase 1 — Cloudflare Workers scaffold
1. `wrangler.jsonc` with Worker Assets config (no CF Pages).
2. Bindings as needed: D1 (loop-tracker + router state), KV, R2 (content ingestion).
3. Confirm deploy target = Worker Assets.

### Phase 2 — Content Router surfaces (Guide/Wiki/Arch/Source/Building)
1. Static HTML for all five surfaces under the Organized Codebase doc-surface pattern.
2. Register each under `organizedai-vanity-router` at
   `{surface}.organizedai.vip/organized-workshop`.
3. GSAP wired in for interactivity.

### Phase 3 — Loop Engineering module (spec / build / review)
1. Install the three skill files (`spec`, `build`, `review`) into `.claude/skills/`.
2. Stand up `loop-tracker` Worker (D1-backed, default) per the adapter design already locked in.
3. Stand up `loop-notify` Worker — Slack path first, Discord path second.
4. Wire Workers Builds to this repo so `review` has real preview URLs to test against.

### Phase 4 — End-to-end loop smoke test
1. Run `/spec` once against the organized-workshop scope.
2. Run `/build` + `/review` once manually (not on a timer yet) — confirm PR, preview,
   notify, manual merge all work.

### Phase 5 — Track B: Journey Capture wiring
1. GTM container + GA4 + Meta CAPI via Stape — reuse existing containers or provision
   new ones if this demo needs to be isolated from production tracking.

### Phase 6 — Track A: Content Engine wiring
1. TwelveLabs indexing/highlight-finding connector.
2. HyperFrames for cut/caption/brand export.

### Phase 7 — (Optional) Cron-driven loop
Only after Phase 4 is proven manually — replace the live `/loop` timer with a
Cron Trigger so build/review survive a closed laptop lid.

---

## // OPEN DECISIONS

- Issue tracker: D1 (default, in-stack) vs Linear.
- Notify: Slack (matches existing GTM/CAPI relay pattern) vs Discord.
- Reaction-based 🚀-to-merge (needs a bot token) vs plain "merge when ready" notify message.
- Should `feature/bootstrap-qa-loop` get a PR into `organized-codebase`'s `main` before
  other projects depend on it, or is copying the scripts directly (as done here) fine for now?
