# GEMINI.md

## Project Overview

This project is the source code for Gilberto Taccari's personal website and
blog, hosted at [gilbertotaccari.com](https://gilbertotaccari.com).
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
  bundle exec jekyll serve --source site
  ```

  Access the site at `http://localhost:4000`. Use `--livereload` for automatic
  updates.

- **Build the site:**

  ```sh
  bundle exec jekyll build --source site
  ```

  For production builds (which enable Cookiebot and Google Analytics), use:

  ```sh
  JEKYLL_ENV=production bundle exec jekyll build --source site
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

- **Pages:** Standard pages like `index.md` and `privacy.md` use
  Front Matter for layout and metadata.
- **Posts:** Although currently empty, a `_posts/` directory can be created for
  blog entries named `YYYY-MM-DD-title.md`.
- **Formatting:** Adhere to `.markdownlint-cli2.yaml` rules.
- **Links:** Verify all links using `lychee` (configured in `lychee.toml`).
- **Thought Leadership Data:** The data for the "Thought Leadership" page is stored
  in `site/_data/publications.yml`, `site/_data/speaking.yml`, and
  `site/_data/reviews.yml`. These files are populated from the
  `curriculum-vitae` submodule. To update them:
  1. Sync the submodule: `git submodule update --remote curriculum-vitae`.
  2. Read `curriculum-vitae/publications.bib` and
     `curriculum-vitae/knowledge/03-knowledge-base.md`.
  3. Extract the academic publications, speaking appearances, and manuscript
     reviews.
  4. Update the corresponding YAML files in `site/_data/`.
- **LLM Context:** `llms.txt` provides a machine-readable summary of the site
  for LLMs, including site metadata, page links, and social information. It is
  dynamically generated using Jekyll.
- **AI Context Submodule:** A private submodule `curriculum-vitae` is used to
  provide personal data as context for LLM-assisted development.
  - **Syncing:** The submodule tracks the `main` branch. Use
    `git submodule update --remote curriculum-vitae` to sync.
  - **Privacy:** This directory is outside the `site/` directory to
    ensure it is never processed by Jekyll or published to the website.

### Theme Customisation

- **Theme:** The site uses the **Minima** theme. Configuration is in
  `_config.yml` under the `minima:` key.
- **Skins:** Supported skins include `light`, `dark`, and `auto` (detects system
  preference).
- **Overriding:** To override theme layouts or includes, create a local
  directory (e.g., `site/_layouts/` or `site/_includes/`) and copy the theme's
  file there.
  Currently, `footer.html`, `head.html`, and `google-analytics.html` are
  overridden. Use `bundle info minima --path` to find the source files.
- **Head Customisation:** The `site/_includes/head.html` file is overridden to
  inject Cookiebot (consent management) and Google Analytics 4 tracking.
- **Privacy & Analytics:** Google Analytics 4
  (`site/_includes/google-analytics.html`) is strictly controlled by Cookiebot.
  Scripts use `type="text/plain"` and `data-cookieconsent="statistics"` to
  prevent execution until explicit consent is granted, ensuring GDPR compliance
  regarding international data transfers.

### Configuration (`site/_config.yml`)

- **Metadata:** Title, author, description, and URL are set here.
- **Navigation:** Main header links are explicitly defined in
  `header_pages` to exclude administrative pages like the Privacy Policy.
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
  script currently excludes technical directories (e.g., `vendor/`, `_site/`)
  from analysis.
  If it flags a correctly spelled word, add it to `hunspell/custom.dic` and
  update the word count on the first line.
- **Deployment:** Automatic deployment to GitHub Pages on pushes to the `main`
  branch (`jekyll-gh-pages.yml`).

## Project Structure

- `.gemini/settings.json`: Configuration for AI agents and MCP servers.
- `.github/workflows/`: CI/CD pipeline definitions.
- `.markdownlint-cli2.yaml` & `lychee.toml`: QA tool configurations.
- `Gemfile`: Ruby dependencies (Jekyll, Minima, plugins).
- `hunspell/`: Custom dictionary and configuration for spell checking.
- `scripts/`: Utility scripts, including `run_spell_check.sh`.
- `site/404.html`: Custom error page.
- `site/_config.yml`: Site-wide settings and plugin configuration.
- `site/_includes/`: Custom and overridden theme components (e.g., `head.html`,
  `footer.html`, `google-analytics.html`, `cookiebot.html`).
- `site/index.md`: Homepage (uses `home` layout).
- `site/llms.txt`: LLM-friendly site summary.
- `site/privacy.md`: GDPR-compliant Privacy Policy page.
- `terraform/`: Infrastructure as Code configuration.
