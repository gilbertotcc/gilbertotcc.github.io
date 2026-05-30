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

### npm workspaces

This repository is organised as a **monorepo** using npm workspaces. The `site/`
directory is the main website workspace.

- **Install all dependencies:** `npm install`
- **Install a dependency for the website:**
  `npm install <pkg> --workspace=site`
- **Install a dev dependency for the website:**
  `npm install <pkg> --save-dev --workspace=site`

### Working on the website (site/)

The website source code and Astro configuration live under `site/`. Common
tasks are exposed via root-level scripts:

- **Run local dev server:** `npm run site:dev` (access at `http://localhost:4321`)
- **Build the site:** `npm run site:build`
- **Preview production build:** `npm run site:preview`
- **Astro CLI:** `npm run site:astro -- <command>`
  - Example: `npm run site:astro -- add @astrojs/sitemap` (updates
    `site/astro.config.mjs` and `site/package.json`).

#### Adding content

- **New page:** To add `/about`, create `site/src/pages/about.astro`.
- **New reusable component:** Create `site/src/components/MyComponent.astro`
  and import it into a page or layout.
- **Astro-specific details:** For details about layouts, content collections,
  and configuration, see [`site/ANTIGRAVITY.md`](site/ANTIGRAVITY.md).

### First contribution (example workflow)

If you are new to the project, follow these steps to make your first change:

1. **Clone the repo** and install dependencies: `npm install`.
2. **Start the dev server:** `npm run site:dev` and open
   <http://localhost:4321>.
3. **Modify a page**, e.g., `site/src/pages/index.astro` or
   `site/src/pages/privacy.md`.
4. **Run the spell check** before committing: `./scripts/run_spell_check.sh`.
5. **Commit and push** your changes.

## Quality Assurance

### Spell Check

This project enforces spell checking on all Markdown (`.md`), HTML (`.html`),
and Astro (`.astro`) files using `hunspell` and a British English dictionary
(`en_GB`).

The check primarily targets content under `site/src/` and related
markdown/HTML/Astro files.

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

## AI-Assisted Development

This project is configured to work with AI agents using the Model Context
Protocol (MCP).
MCP allows AI models to safely interact with local and remote tools and data
sources.

The configuration is stored in `.antigravitycli/settings.json` and includes:

- **Context7**: Provides up-to-date documentation and code examples for
  libraries and frameworks.

For instructions on how Antigravity CLI should interact with GitHub (issues, pull
requests, commits), see [`ANTIGRAVITY.md`](./ANTIGRAVITY.md).

### Curriculum Vitae Context

The project includes a private submodule `curriculum-vitae` to provide personal
data for AI-assisted workflows. This directory is excluded from the build
process.

To update the submodule to the latest version:

```sh
git submodule update --remote curriculum-vitae
```

### Prerequisites

To use the AI assistant features, you need:

- **`gh` CLI** installed and authenticated (`gh auth status`).
- **`CONTEXT7_API_KEY`** environment variable set for library documentation
  lookups.

### Configuration

To use the MCP servers, create a `.env` file in the root directory with your
credentials:

```env
CONTEXT7_API_KEY=your_api_key_here
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

## Monorepo Overview

This repository is organised as a monorepo to manage multiple distinct but
interrelated concerns. The separation into directories ensures that different
domains have clear boundaries and isolated configurations.

| Path | Purpose | Safe operations |
| :--- | :--- | :--- |
| `site/` | Astro website source code and config | Full access (read/write) |
| `terraform/` | IaC for GitHub and DNS management | Read-only |
| `scripts/` | Maintenance and utility scripts | Read; write with care |
| `hunspell/` | Dictionaries for spell checking | Editable (esp. `custom.dic`) |
| `curriculum-vitae/` | Private submodule with personal context | Read-only |

## Tips & Tricks

**Use direnv.** To load the environment variables in `.env` file, you can use
[direnv](https://direnv.net/) that runs code in `.envrc` or, optionally, load
variables in `.env` files (see
[`load_dotenv`](https://direnv.net/man/direnv.toml.1.html#codeloaddotenvcode)
configuration parameter).

**Use `.node-version`.** The Node version to use in this project is configured
in `.node-version` file. To use it, install a tool that supports that file
(e.g., [fnm](https://github.com/Schniz/fnm)).
See [node-version-usage](https://github.com/shadowspawn/node-version-usage) for
additional information.

## License

The content of this project itself is licensed under the
[Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/),
and the underlying source code used to format and display that content is
licensed under the [MIT License](LICENSE).
