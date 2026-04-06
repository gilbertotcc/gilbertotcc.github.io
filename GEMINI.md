# GEMINI.md

## Project Overview

This project is the source code for Gilberto Taccari's personal website and
blog, hosted at [gilbertotcc.github.io](https://gilbertotcc.github.io).
It is built using **Jekyll**, a static site generator, and utilizes the
**Minima** theme.

### Key Technologies

- **Jekyll**: Static site generator (Ruby-based).
- **Minima**: The default Jekyll theme (pinned via `Gemfile`).
- **GitHub Pages**: Hosting platform.
- **GitHub Actions**: Automated workflows for linting, link checking, and
  deployment.

## Building and Running

### Prerequisites

- **Ruby**: Version `3.3` (as specified in GitHub Actions).
- **Bundler**: `gem install bundler`.

### Commands

- **Install dependencies:**

  ```sh
  bundle install
  ```

- **Local development server:**

  ```sh
  bundle exec jekyll serve
  ```

  Access the site at `http://localhost:4000`. Use `--livereload` for automatic
  updates.

- **Build the site:**

  ```sh
  bundle exec jekyll build
  ```

  For production builds (which enable Cookiebot and Google Analytics), use:

  ```sh
  JEKYLL_ENV=production bundle exec jekyll build
  ```

## Development Conventions

### Documentation Routing

To minimise context usage, detailed operational instructions are delegated to
specific files. Always refer to these before proceeding with related tasks:

- **`README.md`**: Detailed prerequisites (e.g., `hunspell`), AI-assisted
  development (MCP) setup, and third-party services list.
- **`terraform/README.md`**: Infrastructure as Code (IaC) operations, OpenTofu
  rules, and cloud dependencies.

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

### Content Management

- **Pages:** Standard pages like `index.md` and `about.md` use Front Matter for
  layout and metadata.
- **Posts:** Although currently empty, a `_posts/` directory can be created for
  blog entries named `YYYY-MM-DD-title.md`.
- **Formatting:** Adhere to `.markdownlint-cli2.yaml` rules.
- **Links:** Verify all links using `lychee` (configured in `lychee.toml`).
- **LLM Context:** `llms.txt` provides a machine-readable summary of the site
  for LLMs, including site metadata, page links, and social information. It is
  dynamically generated using Jekyll.

### Theme Customisation

- **Theme:** The site uses the **Minima** theme. Configuration is in
  `_config.yml` under the `minima:` key.
- **Skins:** Supported skins include `light`, `dark`, and `auto` (detects system
  preference).
- **Overriding:** To override theme layouts or includes, create a local
  directory (e.g., `_layouts/` or `_includes/`) and copy the theme's file there.
  Use `bundle info minima --path` to find the source files.
- **Head Customisation:** The `_includes/head.html` file is overridden to inject
  Cookiebot (consent management) and Google Analytics 4 tracking. These are
  conditionally loaded based on the `jekyll.environment == 'production'` check.

### Configuration (`_config.yml`)

- **Metadata:** Title, author, description, and URL are set here.
- **Plugins:** `jekyll-feed` is used for RSS generation.
- **Social Links:** LinkedIn and GitHub links are configured under
  `minima.social_links`.
- **Analytics:** The `google_analytics` property holds the GA4 Measurement ID.

### CI/CD and Quality Assurance

- **Markdown Linting:** Pull requests trigger `markdownlint-cli2` via GitHub
  Actions (`check-markdown-files.yml`).
- **Link Checking:** `lychee` verifies links in Markdown files.
- **Spell Checking:** You MUST validate any changes to Markdown (`.md`) or HTML
  (`.html`) files by running `./scripts/run_spell_check.sh`. Note that this
  script currently excludes `_includes` (theme elements) and other technical
  directories (e.g., `vendor/`, `_site/`) from analysis.
  If it flags a correctly spelled word, add it to `hunspell/custom.dic` and
  update the word count on the first line.
- **Deployment:** Automatic deployment to GitHub Pages on pushes to the `main`
  branch (`jekyll-gh-pages.yml`).

## Project Structure

- `_config.yml`: Site-wide settings and plugin configuration.
- `_includes/`: Custom and overridden theme components (e.g., `head.html`,
  `cookiebot.html`).
- `index.md`: Homepage (uses `home` layout).
- `about.md`: About page (uses `page` layout).
- `404.html`: Custom error page.
- `hunspell/`: Custom dictionary and configuration for spell checking.
- `scripts/`: Utility scripts, including `run_spell_check.sh`.
- `terraform/`: Infrastructure as Code configuration.
- `Gemfile`: Ruby dependencies (Jekyll, Minima, plugins).
- `llms.txt`: LLM-friendly site summary.
- `.github/workflows/`: CI/CD pipeline definitions.
- `lychee.toml` & `.markdownlint-cli2.yaml`: QA tool configurations.
- `.gemini/settings.json`: Configuration for AI agents and MCP servers.
