---
name: astro-visual-check
description: Visually verify every changed Astro page in the current branch by type-checking the site and taking headless-browser screenshots. Use when asked to check, verify, or review pages/files changed in a branch.
metadata:
  category: quality-assurance
---

# Astro Visual Check

Sweeps every Astro page changed in the current branch and visually reviews
it. Scoped strictly to the Astro website (`site/`).

The `screenshot-changed-page.sh` hook does the same thing per edit; use this
skill for a whole-branch sweep instead.

## Procedure

1. **Find changed files, scoped to `site/` only.** Union of:

   ```sh
   git diff --name-only --diff-filter=ACMRT $(git merge-base main HEAD) HEAD -- site/
   git diff --name-only --diff-filter=ACMRT HEAD -- site/
   ```

   Anything outside `site/` is out of scope for this skill.

2. **Identify what to screenshot.** Split the changed `site/` files:
   - Files under `site/src/pages/**` with a `.astro` or `.md` extension
     (`.ts` API-endpoint pages like `llms.txt.ts` have no visual output —
     skip them) map directly to a route: `index.astro` → `/`,
     `privacy.md` → `/privacy`, `thought-leadership.astro` →
     `/thought-leadership`, etc. A dynamic `[param]` route can't be mapped
     to a concrete URL automatically — report it as skipped rather than
     guessing a value.
   - Any other changed file under `site/src/` (components, data, layouts,
     etc.) means every real page needs screenshotting, not just the ones
     with a directly-changed page file — a shared file (e.g.
     `site/src/data/publications.yml`) can change how more than one page
     renders. In that case, enumerate every page under `site/src/pages/**`
     and map each to its route the same way.

3. **Gate.** If anything under `site/` changed, run `npm run site:check`
   (astro check). If it fails, report the failure and stop — don't
   screenshot a build that doesn't type-check.

4. **Screenshot.** If the gate passed and there are pages to screenshot
   (per step 2): check whether the dev server is already reachable on port
   4321. If not, start `npm run site:dev` in the background, poll until it
   responds, and remember that you started it — stop it once done, since it
   wasn't there before. If it was already running, reuse it and leave it
   running. For each page's route, run:

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
- If you started the dev server yourself, stop it when done; leave a
  pre-existing one running.
