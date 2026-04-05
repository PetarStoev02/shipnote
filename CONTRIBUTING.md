# Contributing to Shipnote

Thanks for wanting to contribute! Shipnote is a Claude Code plugin — here's how to get involved.

## Getting Started

1. Fork this repo
2. Clone your fork
3. Install the plugin locally:
   - Copy or symlink this directory to your Claude Code plugins path
   - Or add it via Claude Code settings

## Project Structure

- `commands/` — Slash commands (`.md` files with YAML frontmatter)
- `skills/` — Skills that Claude auto-activates based on context
- `scripts/` — Bash scripts for data collection

## How to Contribute

### Bug Reports
Open an issue with:
- What you expected
- What happened
- Steps to reproduce

### Feature Requests
Open an issue describing the feature and why it would be useful.

### Pull Requests
1. Create a branch from `main`
2. Make your changes
3. Test the plugin locally by running the commands in Claude Code
4. Open a PR with a clear description

## Code Style

- Commands and skills: Markdown with YAML frontmatter
- Scripts: Bash, POSIX-compatible where possible
- Keep prompts focused and concise

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
