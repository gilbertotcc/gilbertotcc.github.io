# GEMINI.md

## AI Quick Reference

- **Workspace and commands**
  - Website code and Astro config live under `site/`.
  - Use `npm run site:<task>` (e.g. `site:dev`, `site:build`, `site:preview`)
    for website workflows.
  - Install website dependencies with `npm install <pkg> --workspace=site`.
- **Writable paths for AI**
  - `site/src/`, `hunspell/` → read/write allowed.
  - `site/public/`, `scripts/` → read, write with care.
- **Read-only paths for AI**
  - `terraform/`, `.github/workflows/`, `curriculum-vitae/` → must not be
    modified.

### Hard constraints

- Do not run `tofu apply`.
- Do not modify files under `terraform/`.
- Do not modify files under `.github/workflows/`.
- Do not modify files under `curriculum-vitae/`.

## Project Overview

This is a personal website and blog monorepo for gilbertotaccari.com. It
consists of multiple distinct concerns — an Astro website, infrastructure
as code, utility scripts, and AI agent context.

### Repository Structure

See [Monorepo Overview](README.md#monorepo-overview) in `README.md` for a
breakdown of the paths and their purposes.

### Agent Boundaries

The following table defines the blast radius for AI agent actions:

| Directory | Agent access |
| :--- | :--- |
| `site/src/`, `hunspell/` | Free to read and write |
| `site/public/`, `scripts/` | Read; write with care |
| `terraform/` | Read-only — never run `tofu apply` |
| `curriculum-vitae/` | Read-only — private submodule, never modify |
| `.github/workflows/` | Read-only — changes require human review |

### Key Technologies

- **Astro**: Static site generator and web framework.
- **TypeScript**: Static typing for configuration and endpoints.
- **Node.js**: JavaScript runtime environment (v22+).
- **GitHub Pages**: Hosting platform.
- **GitHub Actions**: Automated workflows for linting, link checking, and
  deployment.

## Building and Running

For full website workflow and QA steps, see
[Working on the website (site/)](README.md#working-on-the-website-site) and
[Quality Assurance](README.md#quality-assurance) in `README.md`.

### Minimal commands

- **Install dependencies:** `npm install`
- **Local development server:** `npm run site:dev`
- **Build the site:** `npm run site:build`
- **Preview production build:** `npm run site:preview`

## Development Conventions

### Documentation Routing

To minimise context usage, detailed operational instructions are delegated to
specific files. Always refer to these before proceeding with related tasks:

- **`README.md`**: Detailed prerequisites, AI-assisted development (MCP) setup,
  and repository structure.
- **`terraform/README.md`**: Infrastructure as Code (IaC) operations, OpenTofu
  rules, and cloud dependencies.
- **`site/GEMINI.md`**: Astro-specific content management, layout, and
  configuration.

### Environment and Secrets

- All credentials (e.g., API keys, PATs) must be stored in a local `.env` file.
- **Never** commit the `.env` file; it is protected by `.gitignore`.
- The project uses `direnv` as the standard approach to load environment
  variables locally.

### Infrastructure as Code

- The project uses **OpenTofu** for IaC to manage GitHub repository settings
  and Porkbun DNS.
- For rules, state management, and execution details, always consult
  `terraform/README.md`.

### CI/CD and Quality Assurance

- **Markdown Linting:** Pull requests trigger `markdownlint-cli2` via GitHub
  Actions (`check-markdown-files.yml`).
- **Link Checking:** `lychee` verifies links in Markdown, HTML, and Astro files.
- **Spell Checking:** You MUST validate any changes by running
  `./scripts/run_spell_check.sh`. See `README.md` for more details.
- **Dependabot:** Automated dependency updates are managed by Dependabot,
  covering the `npm` ecosystem under the `site/` directory.
- **Deployment:** Automatic deployment to GitHub Pages on pushes to the `main`
  branch (`deploy.yml`).

## Project Structure

- `.agents/settings.json` & `.agents/mcp_config.json`: Configuration for AI
  agents and MCP servers.
- `.github/workflows/`: CI/CD pipeline definitions.
- `.markdownlint-cli2.yaml` & `lychee.toml`: QA tool configurations.
- `hunspell/`: Custom dictionary and configuration for spell checking.
- `scripts/`: Utility scripts, including `run_spell_check.sh`.
- `site/`: Astro website source files.
- `curriculum-vitae/`: Private submodule with personal context for AI agents.
- `terraform/`: Infrastructure as Code configuration.

## GitHub Operations

Use the `gh` CLI for all GitHub operations. Before running any `gh` command,
verify authentication:

```bash
gh auth status
```

If not authenticated, run `gh auth login` and follow the prompts.

---

### Commits and Pushing

```bash
# Stage all changes and commit
git add .
git commit -m "type(scope): description"

# Push current branch
git push

# Push and set upstream for a new branch
git push --set-upstream origin <branch-name>
```

---

### Pull Requests

```bash
# Create a PR (interactive)
gh pr create --base main --title "Title" --body "Description"

# Create a PR with a draft flag
gh pr create --base main --title "Title" --draft

# List open PRs
gh pr list

# View a specific PR
gh pr view <pr-number>

# Check out a PR locally
gh pr checkout <pr-number>

# Merge a PR (squash recommended for this repo)
gh pr merge <pr-number> --squash --delete-branch

# Request a review
gh pr edit <pr-number> --add-reviewer <username>

# Add a review comment
gh pr review <pr-number> --comment --body "Your comment"

# Approve a PR
gh pr review <pr-number> --approve

# Request changes on a PR
gh pr review <pr-number> --request-changes --body "Explanation"

# Close a PR without merging
gh pr close <pr-number>
```

---

### Issues

```bash
# Create an issue
gh issue create --title "Title" --body "Description"

# Create an issue and assign to yourself
gh issue create --title "Title" --body "Description" --assignee @me

# List open issues
gh issue list

# View a specific issue
gh issue view <issue-number>

# Add a comment to an issue
gh issue comment <issue-number> --body "Your comment"

# Edit issue title or body
gh issue edit <issue-number> --title "New title"
gh issue edit <issue-number> --body "New body"

# Add or remove labels
gh issue edit <issue-number> --add-label "bug"
gh issue edit <issue-number> --remove-label "bug"

# Close an issue
gh issue close <issue-number>

# Reopen an issue
gh issue reopen <issue-number>
```

---

### Repository and CI

```bash
# View repository details
gh repo view

# List recent workflow runs
gh run list

# View a specific workflow run
gh run view <run-id>

# Watch a running workflow in real time
gh run watch <run-id>
```
