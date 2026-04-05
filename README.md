# Shipnote

Turn your daily dev activity into build-in-public posts. A Claude Code plugin.

## What it does

Run `/shipnote` in Claude Code and get a ready-to-post Threads update based on your actual git activity. No more staring at a blank post wondering what to write.

## Example

```
You: /shipnote

Shipnote:
---
Spent the morning wiring up a CLI plugin from scratch.
No framework. No boilerplate. Just markdown files and bash.
Sometimes the simplest tools are the hardest to build.
---
Post saved to ~/.shipnote/posts.md
```

## Install

Clone this repo and add it to your Claude Code plugins:

```bash
git clone https://github.com/petstoev/shipnote.git ~/.claude/plugins/shipnote
```

Or add the path in Claude Code settings under plugins.

## Commands

| Command | Description |
|---------|-------------|
| `/shipnote` | Generate a post from your recent git activity |
| `/shipnote-log` | View your past posts |
| `/shipnote-setup` | Configure tone, platform, repos path |

## First Run

The first time you run `/shipnote`, it walks you through setup:
- **Tone**: Raw/real, Educational, Hype, or Mix
- **Posts per run**: 1, 2, or 3
- **Repos path**: Where your projects live (default: `~/Code/`)
- **Platform**: Threads, X, or Both
- **Max length**: Character limit per post (default: 500)

Config saves to `~/.shipnote/config.json`. Reconfigure anytime with `/shipnote-setup`.

## How it works

1. Scans all git repos in your configured path for commits since your last post
2. Claude reads the activity and generates a human-sounding post
3. Post prints to console and saves to `~/.shipnote/posts.md`
4. Checkpoint updates so next run only covers new activity

## License

MIT
