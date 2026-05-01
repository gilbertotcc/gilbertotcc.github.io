# GEMINI.md

## Project Overview

This project is the source code for Gilberto Taccari's personal website and
blog, hosted at [gilbertotaccari.com](https://gilbertotaccari.com).
It is built using **Astro**, a modern web framework, utilising TypeScript
and standard web primitives.

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
  cd site && npm install
  ```

- **Local development server:**

  ```sh
  cd site && npm run dev
  ```

  Access the site at `http://localhost:4321`.

- **Build the site:**

  ```sh
  cd site && npm run build
  ```

- **Preview the production build locally:**

  ```sh
  cd site && npm run preview
  ```

- **Astro CLI:**

  ```sh
  cd site && npm run astro -- --help
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

- **Pages:** Astro uses file-based routing. Files in `site/src/pages/`
  automatically become routes (e.g., `src/pages/about.astro` is served at
  `/about`).
  - Use `.astro` files for pages with HTML structure or dynamic data (e.g.,
    `index.astro`, `thought-leadership.astro`).
  - Use `.md` files only for long-form prose with no dynamic content (e.g.,
    `privacy.md`).
  - All pages wrap their content with the `<BaseLayout>` component to ensure
    consistent structure, SEO, and analytics. Frontmatter props (like `title`
    and `description`) are passed to the layout.
- **Posts:** Although currently empty, a blog architecture can be added in the
  future using Astro's Content Collections.
- **Formatting:** Adhere to `.markdownlint-cli2.yaml` rules.
- **Links:** Verify all links using `lychee` (configured in `lychee.toml`).
- **Thought Leadership Data:** The data for the "Thought Leadership" page is stored
  in `site/src/data/publications.yml`, `site/src/data/reviews.yml`, and
  `site/src/data/speaking.yml`. These files are populated from the
  `curriculum-vitae` submodule. To update them:
  1. Sync the submodule: `git submodule update --remote curriculum-vitae` (done
     only during active editing, never in CI/CD).
  2. Read `curriculum-vitae/publications.bib` and
     `curriculum-vitae/knowledge/03-knowledge-base.md`.
  3. Extract the academic publications, speaking appearances, and manuscript
     reviews.
  4. Update the corresponding YAML files in `site/src/data/`.
- **Content Collections:** Astro uses Content Collections to manage the Thought
  Leadership data. The collections are defined in `site/src/content.config.ts`
  using Zod schemas for type-safe validation. The collections (`publications`,
  `reviews`, `speaking`) point directly to the YAML files in `site/src/data/`.
- **LLM Context:** `llms.txt` provides a machine-readable summary of the site
  for LLMs, including site metadata, page links, and social information.
  It is implemented as an API endpoint at `site/src/pages/llms.txt.ts`. It
  adheres to the `llmstxt.org` specification (H1 title, blockquote summary, H2
  file lists). To update its content, edit the string array in the `GET`
  function. Any `.ts` file in `src/pages/` exporting a `GET` function becomes a
  static file at build time.
- **AI Context Submodule:** A private submodule `curriculum-vitae` is used to
  provide personal data as context for LLM-assisted development.
  - **Privacy:** This directory is strictly local/private and is never processed
    by Astro or published to the website.

### Layout and Styling

- **Base Layout:** `site/src/layouts/BaseLayout.astro` is the single source of
  layout truth. All pages wrap their content with
  `<BaseLayout title="..." description="...">`.
- **CSS:** Global styles and design tokens (variables for typography, colours,
  spacing) are defined in `site/src/styles/global.css`.
- **Third-party Services:** Cookiebot (consent management) and Google Analytics
  4 tracking scripts are injected via `BaseLayout.astro`.
- **Environment:** The production environment is gated using
  `import.meta.env.PROD` (which is true during `npm run build`). This prevents
  analytics from running during local development.

### Configuration

- **Site Settings:** Site-wide values are typed TypeScript constants defined in
  `site/src/config.ts`, ensuring type safety and IDE autocompletion.
  - **Metadata:** Title, author, description, lang, and URL.
  - **Analytics:** Google Analytics 4 and Cookiebot IDs.
  - **Social Links:** LinkedIn and GitHub links.

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
