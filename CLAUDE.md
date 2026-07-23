# CLAUDE.md — Organized Workshop

## Project
Demo project for the Content Router Workshop module (Antler VC masterclass).
Follows the Organized Codebase structure (`.claude/`, `PLANNING/`, `ARCHITECTURE/`,
`DOCUMENTATION/`, `SPECIFICATIONS/`, `AGENT-HANDOFF/`, `CONFIG/`, `scripts/`).

## Deploy target
Cloudflare Workers Assets — never Cloudflare Pages. Deploy locally via `wrangler`
from supabowl (M1 Pro) or jordaaan (M4 Mini); this repo is not deployable from a
hosted sandbox.

## Read first
1. `PLANNING/organized-workshop-phased-plan.md` — full phased build order + ASCII architecture
2. `scripts/qa/bootstrap-qa.sh` — run after any phase reports complete, before advancing

## Standing conventions
- GitHub org: `Organized-AI`
- Local default path: `/Users/supabowl/organized-workshop`
- Vanity routing: `{guide,wiki,arch,source,building}.organizedai.vip/organized-workshop`,
  registered in `organizedai-vanity-router`
- Tracker (Loop Engineering): D1-backed `loop-tracker` Worker (default), Linear optional
- Notify (Loop Engineering): Slack default, Discord optional
