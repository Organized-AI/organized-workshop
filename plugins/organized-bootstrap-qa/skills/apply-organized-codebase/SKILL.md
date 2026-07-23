---
name: apply-organized-codebase
description: Applies the Organized Codebase template structure to the current project and enforces the phase-gated QA loop. Use at the start of any new project, or when the user says "bootstrap this project", "apply organized codebase", or "run the QA gate".
---

# Apply Organized Codebase

Scaffolds the standard Organized Codebase directory structure
(`.claude/`, `PLANNING/`, `ARCHITECTURE/`, `DOCUMENTATION/`, `SPECIFICATIONS/`,
`AGENT-HANDOFF/`, `CONFIG/`, `scripts/`, `.archive/`) into the current project,
then runs the QA gate to confirm it actually landed correctly before any
further phase work begins.

## When to use

- A brand-new project directory with nothing in it yet
- An existing project the user wants restructured onto the Organized Codebase
  pattern
- Any time a prior phase claimed "bootstrap complete" and you need to verify it

## Steps

1. Run the bundled scaffolding script against the target directory:
   ```bash
   "${CLAUDE_PLUGIN_ROOT}/scripts/apply-organized-codebase.sh" "${CLAUDE_PROJECT_DIR}"
   ```
2. Run the QA gate for Phase 0 specifically:
   ```bash
   "${CLAUDE_PLUGIN_ROOT}/scripts/qa/bootstrap-qa.sh" "${CLAUDE_PROJECT_DIR}" 0
   ```
3. If the gate fails, read the log it prints (`scripts/qa/bootstrap-qa-*.log`
   in the target project) and fix the missing pieces before telling the user
   bootstrap is done. Never report "bootstrap complete" on a failed gate.
4. If it passes, summarize what was created and what phase comes next
   (Cloudflare Workers scaffold, per the project's `PLANNING/` phased plan if
   one exists).

Note: this plugin's `Stop` hook re-runs the full QA gate automatically after
every turn, so a failure will also surface even if this skill isn't invoked
directly — but running it explicitly here gives a clean, scoped Phase 0 check
before moving on.
