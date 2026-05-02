# Astro Website Workspace

This workspace contains the source code for the personal website and blog,
built with **Astro**.

## Content Management

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

## Layout and Styling

- **Base Layout:** `site/src/layouts/BaseLayout.astro` is the single source of
  layout truth. All pages wrap their content with
  `<BaseLayout title="..." description="...">`.
- **Third-party Services:** Cookiebot (consent management) and Google Analytics
  4 tracking scripts are modularised into dedicated components
  (`Cookiebot.astro`, `GoogleAnalytics.astro`) and injected via `BaseLayout.astro`.
- **Social Links:** Footer social media links are modularised into
  `SocialLinks.astro`.
- **Icons:** Icons (e.g., LinkedIn, GitHub) are managed as inline SVG components
  in `site/src/icons/` to avoid external CSS dependencies (like Font Awesome).
- **CSS:** Global styles and design tokens (variables for typography, colours,
  etc.)
- **Environment:** The production environment is gated using
  `import.meta.env.PROD` (which is true during `npm run build`). This prevents
  analytics from running during local development.

## Configuration

- **Site Settings:** Site-wide values are typed TypeScript constants defined in
  `site/src/config.ts`, ensuring type safety and IDE autocompletion.
  - **Metadata:** Title, author, description, lang, and URL.
  - **Analytics:** Google Analytics 4 and Cookiebot IDs.
  - **Social Links:** LinkedIn and GitHub links.
