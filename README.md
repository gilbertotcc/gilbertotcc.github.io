# gilbertotcc.github.io

This repository contains the source files for Gilberto’s personal website at
<https://gilbertotaccari.com>.
The project is built with Astro.
Use is permitted under the license terms below.

## Prerequisites

To build and run this project, you need:

- **Node.js**: Version `22+`.
- **npm**: Package manager.

## Usage

To set up and run the Astro site locally:

```sh
cd site && npm install
npm run dev
```

### Local verification

Before deploying, you can serve the final production build locally to verify
that production-only features (like analytics and consent banners) are working
correctly:

```sh
cd site
npm run build
npm run preview
```

Key paths and configuration:

- `/` (Home): Served from `site/src/pages/index.astro`.
- `/thought-leadership`: Dynamic collections using data from `site/src/data/`.
- `/privacy`: Prose content from `site/src/pages/privacy.md`.
- `/llms.txt`: Generated from the TypeScript endpoint at `site/src/pages/llms.txt.ts`.
- `site/src/config.ts`: Central configuration for site metadata and service IDs.
- `site/src/layouts/BaseLayout.astro`: The single source of layout truth for all
  pages.
- `/sitemap-index.xml`: Generated sitemap.

Additional commands:

- **Build:** `npm run build` (outputs to `./dist/`)
- **Preview:** `npm run preview`
- **Astro CLI:** `npm run astro ...` (e.g., `astro add`, `astro check`)

For more information, check the [Astro documentation](https://docs.astro.build).

## Quality Assurance

### Spell Check

This project enforces spell checking on all Markdown (`.md`), HTML (`.html`),
and Astro (`.astro`) files using `hunspell` and a British English dictionary
(`en_GB`).

The check covers the `site/src/` source files.

#### Prerequisites

To run the spell check locally, you must install `hunspell` and the British
English dictionary:

- **macOS** (using Homebrew):

  ```sh
  brew install hunspell
  # The en_GB dictionary may need to be downloaded manually, or use standard paths.
  # Usually, hunspell on macOS uses dictionaries from ~/Library/Spelling or /Library/Spelling
  ```

- **Ubuntu/Debian**:

  ```sh
  sudo apt-get install hunspell hunspell-en-gb
  ```

#### Running the checks

Run the following script from the root of the project:

```sh
./scripts/run_spell_check.sh
```

#### Custom Dictionary

If `hunspell` flags a valid word, you can add it to the project's custom
dictionary located at `hunspell/custom.dic`. Make sure to update the word count
on the first line of the file after adding new words.

## AI-Assisted Development (MCP)

This project is configured to work with AI agents using the Model Context
Protocol (MCP).
MCP allows AI models to safely interact with local and remote tools and data
sources.

The configuration is stored in `.gemini/settings.json` and includes:

- **Context7**: Provides up-to-date documentation and code examples for
  libraries and frameworks.
- **GitHub Copilot**: Enables interaction with GitHub for pull requests, issues,
  and repository management.

### Curriculum Vitae Context

The project includes a private submodule `curriculum-vitae` to provide personal
data for AI-assisted workflows. This directory is excluded from the build
process.

To update the submodule to the latest version:

```sh
git submodule update --remote curriculum-vitae
```

### Configuration

To use these servers, create a `.env` file in the root directory with your
credentials:

```env
CONTEXT7_API_KEY=your_api_key_here
GITHUB_PAT=your_github_personal_access_token_here
```

> **Note**: Never commit your `.env` file. It is already included in
> `.gitignore`.

## Third-party services

The website uses third-party services to accomplish certain use cases.

These services are conditionally loaded based on `import.meta.env.PROD`, which
is automatically set to true when running `npm run build`.

Here is a list of them as a reference to speed up website setup and maintenance.

- [Cookiebot](https://www.cookiebot.com/): Cookie consent management.
- [Google Analytics 4](https://developers.google.com/analytics?hl=en): Website
  traffic analytics.

## CI/CD and Deployment

The project uses GitHub Actions for continuous integration and deployment:

- **Quality Assurance**: Automated workflows for linting
  (`check-markdown-files.yml`), spell checking (`spell-check.yml`), and link
  checking.
- **Deployment**: Automatic deployment to GitHub Pages on pushes to the `main`
  branch (`deploy.yml`). It uses the official Astro deployment action to build
  and upload the site artifact.

## Infrastructure as Code

The infrastructure required to make the website work is configured using an
Infrastructure as Code (IaC) approach.
See [Infrastructure as Code](terraform/README.md) for details.

## Repository Structure

- `curriculum-vitae/`: Private submodule with personal context for AI agents.
- `site/`: Astro website source files.
  - `public/`: Static files copied verbatim to the build output.
  - `src/`: Source code including components, content collections, pages, and styles.
    - `components/`: Reusable Astro components.
    - `data/`: Source YAML files for content collections.
    - `layouts/`: Page layouts (e.g., `BaseLayout.astro`).
    - `pages/`: File-based routing (Astro, Markdown, and TypeScript endpoints).
- `terraform/`: Infrastructure as Code configuration.

## Tips & Tricks

**Use direnv.** To load the environment variables in `.env` file, you can use
[direnv](https://direnv.net/) that runs code in `.envrc` or, optionally, load
variables in `.env` files (see
[`load_dotenv`](https://direnv.net/man/direnv.toml.1.html#codeloaddotenvcode)
configuration parameter).

## License

The content of this project itself is licensed under the
[Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/),
and the underlying source code used to format and display that content is
licensed under the [MIT License](LICENSE).
