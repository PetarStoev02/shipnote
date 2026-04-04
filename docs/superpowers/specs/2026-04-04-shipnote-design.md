# Shipnote — Design Spec

> A Claude Code plugin that turns your daily dev activity into raw, real "build in public" posts for Threads.

## Problem

Developers want to build in public but:
- Forget what they did
- Don't know what's interesting
- Don't want to write posts daily

## Solution

A Claude Code plugin that scans git activity across all your repos and generates human-sounding posts ready to copy/paste to Threads.

**One command: `/shipnote` → a ready-to-post Threads update.**

## Target User

Solo developer (personal tool first, open-sourceable).

## Core Features

### 1. Post Generation (`/shipnote`)

- Scans all git repos in configured path (default `~/Code/`) for commits since last checkpoint
- Claude generates a post using the user's configured tone and platform constraints
- Prints the post to console
- Saves the post to `~/.shipnote/posts.md` with timestamp
- Updates the checkpoint

### 2. Post Log (`/shipnote log`)

- Displays all posts from today (or a given date)
- Reads from `~/.shipnote/posts.md`

### 3. Onboarding (`/shipnote setup`)

Triggered automatically on first run if no config exists. Claude asks conversationally:

1. **Tone** — Raw/real, Educational, Hype, Mix
2. **Posts per run** — 1, 2, or 3
3. **Repos path** — Default `~/Code/`
4. **Platform** — Threads, X, Both
5. **Max post length** — Default 500 chars (Threads limit)

Saves to `~/.shipnote/config.json`. Re-run with `/shipnote setup` to reconfigure.

## Architecture

### Plugin Structure

```
shipnote/
  plugin.json              # Plugin manifest
  commands/
    shipnote.md            # /shipnote — generate a post
    shipnote-log.md        # /shipnote log — view past posts
    shipnote-setup.md      # /shipnote setup — onboarding wizard
  skills/
    generate-post.md       # Core: scan git → craft post
  scripts/
    scan-repos.sh          # Collect git activity across repos
```

### Data Flow

```
/shipnote
  → Read ~/.shipnote/config.json (preferences)
  → Read ~/.shipnote/last-checkpoint.json (last post time)
  → Run scan-repos.sh on configured repos path
    → For each repo: git log --since="<checkpoint>" --pretty=format:"%s|%an|%ar"
    → For each repo: git diff --stat (what changed)
    → Output structured summary
  → Claude generates post using prompt + config
  → Print post to console
  → Append post to ~/.shipnote/posts.md
  → Update last-checkpoint.json
```

### File System

```
~/.shipnote/
  config.json            # User preferences (tone, posts per run, etc.)
  last-checkpoint.json   # Timestamp of last post + postsToday count
  posts.md               # Running log of all generated posts
```

### Checkpoint Format

```json
{
  "lastRun": "2026-04-04T15:00:00Z",
  "postsToday": 2
}
```

### Config Format

```json
{
  "tone": "raw",
  "postsPerRun": 1,
  "reposPath": "~/Code",
  "platform": "threads",
  "maxLength": 500
}
```

## Prompt Engineering

Base prompt for post generation:

```
You are {{user's name}}, a developer building in public on Threads.

Based on the git activity below, write {{postsPerRun}} post(s).

Rules:
- Sound like a real person, not an AI
- Include the struggle, the surprise, or the small win
- No hashtags, no emojis unless it genuinely fits
- Max {{maxLength}} characters
- Don't say "just shipped" or "excited to announce"
- Write like you're texting a dev friend about your day
- If the work was boring, say it was boring
- If it took too long, say it took too long

Tone: {{tone}}

Activity since last checkpoint:
{{git_activity}}

Repos worked on: {{repo_names}}
```

### Post Quality Guidelines

| Avoid (Generic AI) | Target (Raw/Real) |
|---|---|
| "Excited to share I implemented auth today!" | "Auth took 4 hours. Half was figuring out why cookies weren't persisting. Typo." |
| "Made great progress on the API layer" | "Refactored the API layer. Deleted more code than I wrote. Best kind of day." |
| "Working hard on my side project!" | "3 commits, 1 bug fixed, 2 bugs introduced. Net negative." |

## Daily Workflow

```
Morning:   /shipnote          → generates post from overnight/early commits
Midday:    /shipnote          → generates post from morning work
Evening:   /shipnote          → generates post to close out the day

Anytime:   /shipnote log      → view today's posts
           /shipnote setup    → reconfigure
```

Run it whenever you feel like sharing. The checkpoint system ensures you never get duplicate content — it always knows what's new since your last post.

## Repository Setup (Open Source)

### Files

- **README.md** — Project description, installation, usage, examples
- **CODE_OF_CONDUCT.md** — Contributor Covenant
- **CONTRIBUTING.md** — How to contribute
- **LICENSE** — MIT

### GitHub Repo

- Name: `shipnote`
- Description: "Turn your daily dev activity into build-in-public posts. A Claude Code plugin."
- Public repo
- MIT license

## Edge Cases

- **No commits since last checkpoint** — Skip, no post generated
- **Multiple repos active** — Combine into one post, or split if distinct enough
- **Weekend** — Works if you're coding, no special handling
- **First run, no config** — Auto-triggers onboarding
- **Very long commit messages** — Truncate in summary, let Claude pick the interesting parts
- **Sensitive repo names or commit messages** — Respect .gitignore patterns, allow repo exclusion in config (future)

## Non-Goals (for v1)

- Auto-posting to Threads (copy/paste for now)
- Automatic reminders/scheduling (remote triggers can't access local repos)
- OS-level notifications
- VSCode extension
- Web dashboard
- Team features
