# Organized Workshop — Content Router Workshop Demo

Demo project for the *AI for Sales & Marketing* masterclass (Antler VC, Austin —
see https://1bfbc28a.workshops-4ig.pages.dev).

Builds the workshop's three systems:
- **Content Engine** — TwelveLabs indexing/highlights + HyperFrames export
- **Journey Capture** — GTM + GA4 + Meta CAPI (via Stape)
- **Content Router** — Guide/Wiki/Arch/Source/Building, five surfaces on Cloudflare Workers Assets

plus the **Loop Engineering module** (spec → build → review) that runs the
personalization/ingestion work autonomously once specced.

## Bootstrap

This repo was scaffolded from `Organized-AI/organized-codebase` on branch
`feature/bootstrap-qa-loop` (the branch with the QA-gated bootstrap — not yet
merged to `main` as of this commit). See `scripts/apply-organized-codebase.sh`
and `scripts/qa/bootstrap-qa.sh`.

Full phased build order: `PLANNING/organized-workshop-phased-plan.md`
