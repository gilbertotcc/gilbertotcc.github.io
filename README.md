# gilbertotcc.github.io

This repository contains the source files for Gilberto’s personal website at
<https://gilbertotcc.github.io>, built with Jekyll.
Use is permitted under the license terms below.

## Usage

To set up the development environment, follow the instructions at
<https://jekyllrb.com/docs/>.

Then use the following command to build and preview the website locally:

```sh
bundle exec jekyll serve
```

## AI-Assisted Development (MCP)

This project is configured to work with AI agents using the
[Model Context Protocol (MCP)](https://modelcontextprotocol.io/).
MCP allows AI models to safely interact with local and remote tools and data
sources.

The configuration is stored in `.gemini/settings.json` and includes:

- **Context7**: Provides up-to-date documentation and code examples for
  libraries and frameworks.
- **GitHub Copilot**: Enables interaction with GitHub for pull requests, issues,
  and repository management.

### Configuration

To use these servers, create a `.env` file in the root directory with your credentials:

```env
CONTEXT7_API_KEY=your_api_key_here
GITHUB_PAT=your_github_personal_access_token_here
```

> **Note**: Never commit your `.env` file. It is already included in `.gitignore`.

## License

The content of this project itself is licensed under the
[Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/),
and the underlying source code used to format and display that content is
licensed under the [MIT License](LICENSE).
