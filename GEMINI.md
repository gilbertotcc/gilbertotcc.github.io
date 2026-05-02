# GEMINI.md

## Project Overview

This is a personal website and blog monorepo for gilbertotaccari.com. It
consists of multiple distinct concerns — an Astro website, infrastructure
as code, utility scripts, and AI agent context.

### Repository Structure

- `site/`: The Astro website source code and configuration.
- `terraform/`: Infrastructure as Code (IaC) for GitHub and DNS management.
- `scripts/`: Utility scripts for maintenance tasks.
- `curriculum-vitae/`: Private submodule providing personal data as context.

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

### Prerequisites

- **Node.js**: Version `22+`.
- **npm**: Package manager.

### Commands

- **Install dependencies:**

  ```sh
  npm install
  ```

- **Local development server:**

  ```sh
  npm run site:dev
  ```

  Access the site at `http://localhost:4321`.

- **Build the site:**

  ```sh
  npm run site:build
  ```

- **Preview the production build locally:**

  ```sh
  npm run site:preview
  ```

- **Astro CLI:**

  ```sh
  npm run site:astro -- --help
  ```

## Development Conventions

### Documentation Routing

To minimise context usage, detailed operational instructions are delegated to
specific files. Always refer to these before proceeding with related tasks:

- **`README.md`**: Detailed prerequisites (e.g., `hunspell`), AI-assisted
  development (MCP) setup, and third-party services list.
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
- **Spell Checking:** You MUST validate any changes to Markdown (`.md`), HTML
  (`.html`), or Astro (`.astro`) files by running
  `./scripts/run_spell_check.sh`. Note that this script currently excludes
  technical directories (e.g., `dist/`) from analysis and smartly ignores
  code snippets. If it flags a correctly spelled word, add it to
  `hunspell/custom.dic` and update the word count on the first line.
- **Dependabot:** Automated dependency updates are managed by Dependabot,
  covering the `npm` ecosystem under the `site/` directory.
- **Deployment:** Automatic deployment to GitHub Pages on pushes to the `main`
  branch (`deploy.yml`). It uses the official Astro deployment action,
  uploading an artifact and bypassing branch-based deployment.
  **Manual Step Required:** In GitHub repository Settings → Pages, the Source
  must be set to "GitHub Actions".

## Project Structure

- `.gemini/settings.json`: Configuration for AI agents and MCP servers.
- `.github/workflows/`: CI/CD pipeline definitions.
- `.markdownlint-cli2.yaml` & `lychee.toml`: QA tool configurations.
- `hunspell/`: Custom dictionary and configuration for spell checking.
- `scripts/`: Utility scripts, including `run_spell_check.sh`.
- `site/`: Astro website source files.
  - `public/`: Static files copied verbatim to the build output.
  - `src/`: Source code including components, content collections, pages, and styles.
  - `dist/`: Build output directory (generated).
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

---

### Re-enabling Disabled Features

Apply these changes to file `.gemini/settings.json`.

**Checkpointing** (re-enable for long multi-session tasks):

```json
"general": { "checkpointing": { "enabled": true } }
```

Remember to disable it again after the task to avoid accumulating context across
unrelated sessions.

**Agents** (re-enable for fully autonomous multi-step tasks):

```json
"experimental": { "enableAgents": true }
```

Use this only when you need Gemini to autonomously plan and execute a complex
multi-step task (e.g., full feature scaffolding). Disable again after use.
