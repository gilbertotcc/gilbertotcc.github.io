---
name: curriculum-vitae-sync
description: Sync the Thought Leadership YAML data (publications, reviews, speaking) from the curriculum-vitae submodule. Use when asked to update, refresh, or sync publications.yml, reviews.yml, speaking.yml, or the Thought Leadership page content from the CV.
metadata:
  category: content
---

# Curriculum Vitae Sync

Updates `site/src/data/publications.yml`, `site/src/data/reviews.yml`, and
`site/src/data/speaking.yml` from the private `curriculum-vitae` submodule.
The authoritative step-by-step process is documented in
[`site/CLAUDE.md`](../../../site/CLAUDE.md) under "Thought Leadership Data" —
follow those steps rather than duplicating them here, so this skill can't
drift out of sync with the canonical instructions.

## Boundaries

- `curriculum-vitae/` is read-only: read from it, never write to it (see root
  `CLAUDE.md` hard constraints).
- Only `site/src/data/*.yml` should be modified as a result of this workflow.
- The submodule sync (`git submodule update --remote curriculum-vitae`) is a
  manual, explicit step — never run it as a side effect of an unrelated task.
- After updating the YAML files, spot-check that they still validate against
  the Zod schemas in `site/src/content.config.ts`.
