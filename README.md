# gilbertotcc.github.io

This repository contains the source files for Gilberto’s personal website at
<https://gilbertotaccari.com>, built with Jekyll.
Use is permitted under the license terms below.

## Usage

To set up the development environment, follow the instructions at
<https://jekyllrb.com/docs/>.

Then use the following command to build and preview the website locally:

```sh
bundle exec jekyll serve --source site
```

## Quality Assurance

### Spell Check

This project enforces spell checking on all Markdown (`.md`) and HTML (`.html`)
files using `hunspell` and a British English dictionary (`en_GB`).

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
data for AI-assisted workflows. This directory is excluded from the Jekyll build
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
These services are only active when the site is built with the
`JEKYLL_ENV=production` environment variable.

Here is a list of them as a reference to speed up website setup and maintenance.

- [Cookiebot](https://www.cookiebot.com/): Cookie consent management.
- [Google Analytics 4](https://developers.google.com/analytics?hl=en): Website
  traffic analytics.

## Infrastructure as Code

The infrastructure required to make the website work is configured using an
Infrastructure as Code (IaC) approach.
See [Infrastructure as Code](terraform/README.md) for details.

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
