---
name: astro-visual-check
description: Visually verify every Astro page changed in the current branch (vs main) by type-checking the site and taking headless-browser screenshots. Use when asked to check, verify, or review all pages/files changed in a branch before opening or merging a PR.
metadata:
  category: quality-assurance
---

# Astro Visual Check

Sweeps every Astro page changed in the current branch and visually reviews
it. Scoped strictly to the Astro website (`site/`) — this does not run
spelling, markdown-lint, or link checks, which already exist as separate CI
workflows (`spell-check.yml`, `check-markdown-files.yml`, link checking via
`lychee`).

An automatic, per-edit version of the same idea also runs via the
`screenshot-changed-page.sh` PostToolUse hook whenever an AI agent edits a
single page file. This skill is for a broader, whole-branch sweep instead
(e.g. before opening a PR), so it doesn't miss pages edited earlier in the
branch's history.

## Procedure

1. **Find changed files, scoped to `site/` only.** Union of:

   ```sh
   git diff --name-only --diff-filter=ACMRT $(git merge-base main HEAD) HEAD -- site/
   git diff --name-only --diff-filter=ACMRT HEAD -- site/
   ```

   Anything outside `site/` is out of scope for this skill.

2. **Identify changed pages.** Filter to files under `site/src/pages/**`
   with a `.astro` or `.md` extension (`.ts` API-endpoint pages like
   `llms.txt.ts` have no visual output — skip them). Map each file to its
   route: `index.astro` → `/`, `privacy.md` → `/privacy`,
   `thought-leadership.astro` → `/thought-leadership`, etc. A dynamic
   `[param]` route can't be mapped to a concrete URL automatically — report
   it as skipped rather than guessing a value.

3. **Gate.** If anything under `site/` changed, run `npm run site:check`
   (astro check). If it fails, report the failure and stop — don't
   screenshot a build that doesn't type-check.

4. **Screenshot changed pages.** If the gate passed and any page files
   changed: ensure the dev server is reachable on port 4321 (reuse one
   already running; otherwise start `npm run site:dev` in the background
   and poll until it responds). For each changed page's route, run:

   ```sh
   node scripts/screenshot_page.mts <url> tmp/<page-slug>
   ```

   This captures a desktop and a mobile screenshot plus any browser console
   errors. Output goes to `tmp/` at the repo root (git-ignored).

5. **Review.** Read each screenshot with the Read tool and visually assess
   it — layout, overflow, contrast, obviously broken rendering. Cross-check
   against any console errors the script reported.

6. **Report.** One chat summary: the astro-check result, which pages were
   screenshotted (or why none were, e.g. no page files changed), a short
   visual note per page, and — for any page with a warning or error — the
   path to its saved screenshot(s) under `tmp/` so it can be opened
   directly. Nothing is posted to the PR.

## Boundaries

- Never screenshot or check anything outside `site/`.
- Don't duplicate spelling/markdown-lint/link-check work; those are CI's job.
- Leave the dev server running after the check (for reuse); don't kill it.
