# Shipnote Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Claude Code plugin that scans git activity across local repos and generates raw, human-sounding "build in public" posts for Threads.

**Architecture:** Claude Code plugin with 3 slash commands (`/shipnote`, `/shipnote-log`, `/shipnote-setup`), 1 skill (generate-post), and 1 bash script (scan-repos.sh). Data stored in `~/.shipnote/` (config, checkpoints, post log). No external dependencies — Claude is the AI layer.

**Tech Stack:** Markdown (commands/skills), Bash (repo scanning), JSON (config/state)

---

## File Structure

```
shipnote/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest
├── commands/
│   ├── shipnote.md              # /shipnote — generate a post
│   ├── shipnote-log.md          # /shipnote-log — view past posts
│   └── shipnote-setup.md        # /shipnote-setup — onboarding wizard
├── skills/
│   └── generate-post/
│       └── SKILL.md             # Core skill: scan git → craft post
├── scripts/
│   └── scan-repos.sh            # Scan all repos for recent git activity
├── README.md
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md
└── LICENSE
```

Data directory (created at runtime):
```
~/.shipnote/
├── config.json              # User preferences
├── last-checkpoint.json     # Last post timestamp + daily count
└── posts.md                 # Running log of generated posts
```

---

### Task 1: Repository Setup & Open Source Files

**Files:**
- Create: `LICENSE`
- Create: `CODE_OF_CONDUCT.md`
- Create: `CONTRIBUTING.md`
- Create: `README.md`

- [ ] **Step 1: Create MIT LICENSE**

```
MIT License

Copyright (c) 2026 Petar Stoev

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

- [ ] **Step 2: Create CODE_OF_CONDUCT.md**

Use the Contributor Covenant v2.1. Full text at https://www.contributor-covenant.org/version/2/1/code_of_conduct/. Write the standard file with contact method set to the GitHub repo issues.

- [ ] **Step 3: Create CONTRIBUTING.md**

```markdown
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
```

- [ ] **Step 4: Create README.md**

```markdown
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
git clone https://github.com/your-username/shipnote.git ~/.claude/plugins/shipnote
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
```

- [ ] **Step 5: Commit**

```bash
git add LICENSE CODE_OF_CONDUCT.md CONTRIBUTING.md README.md
git commit -m "Add open source files: LICENSE, README, contributing guide, code of conduct"
```

---

### Task 2: Plugin Manifest

**Files:**
- Create: `.claude-plugin/plugin.json`

- [ ] **Step 1: Create the plugin manifest**

```json
{
  "name": "shipnote",
  "version": "1.0.0",
  "description": "Turn your daily dev activity into build-in-public posts for Threads",
  "author": {
    "name": "Petar Stoev"
  },
  "repository": "https://github.com/your-username/shipnote",
  "license": "MIT",
  "keywords": ["build-in-public", "threads", "social", "developer", "content"]
}
```

- [ ] **Step 2: Commit**

```bash
git add .claude-plugin/plugin.json
git commit -m "Add plugin manifest"
```

---

### Task 3: Repo Scanner Script

**Files:**
- Create: `scripts/scan-repos.sh`

This is the data collection layer. It scans all git repos under a given path and outputs structured activity since a given timestamp.

- [ ] **Step 1: Write the scan script and test it**

```bash
#!/bin/bash
# scan-repos.sh — Scan git repos for activity since a given timestamp
#
# Usage: scan-repos.sh <repos_path> <since_timestamp>
# Example: scan-repos.sh ~/Code "2026-04-04T09:00:00Z"
#
# Output: Structured summary of git activity across all repos

REPOS_PATH="$1"
SINCE="$2"

if [ -z "$REPOS_PATH" ] || [ -z "$SINCE" ]; then
  echo "Usage: scan-repos.sh <repos_path> <since_timestamp>"
  exit 1
fi

# Expand tilde
REPOS_PATH="${REPOS_PATH/#\~/$HOME}"

found_activity=false

for dir in "$REPOS_PATH"/*/; do
  # Skip if not a git repo
  [ -d "$dir/.git" ] || continue

  repo_name=$(basename "$dir")

  # Get commits since timestamp
  commits=$(git -C "$dir" log --since="$SINCE" --pretty=format:"%s (%ar)" 2>/dev/null)

  # Skip repos with no recent activity
  [ -z "$commits" ] && continue

  found_activity=true

  # Get changed file stats
  commit_count=$(git -C "$dir" log --since="$SINCE" --oneline 2>/dev/null | wc -l | tr -d ' ')
  files_changed=$(git -C "$dir" log --since="$SINCE" --pretty=format:"" --name-only 2>/dev/null | sort -u | grep -v '^$' | wc -l | tr -d ' ')

  echo "## $repo_name"
  echo "Commits: $commit_count | Files changed: $files_changed"
  echo ""
  echo "$commits"
  echo ""
done

if [ "$found_activity" = false ]; then
  echo "NO_ACTIVITY"
fi
```

- [ ] **Step 2: Make the script executable and test it**

Run:
```bash
chmod +x scripts/scan-repos.sh
bash scripts/scan-repos.sh ~/Code "$(date -u -v-24H +%Y-%m-%dT%H:%M:%SZ)"
```

Expected: Output showing repo names, commit counts, and commit messages from the last 24 hours. If no repos have recent commits, output should be `NO_ACTIVITY`.

- [ ] **Step 3: Commit**

```bash
git add scripts/scan-repos.sh
git commit -m "Add repo scanner script"
```

---

### Task 4: Onboarding Command (`/shipnote-setup`)

**Files:**
- Create: `commands/shipnote-setup.md`

This command walks the user through configuration using AskUserQuestion. It writes `~/.shipnote/config.json`.

- [ ] **Step 1: Create the setup command**

```markdown
---
name: shipnote-setup
description: Configure Shipnote — set your tone, platform, repos path, and preferences
---

You are running the Shipnote setup wizard. Walk the user through configuration by asking questions one at a time using AskUserQuestion. Be conversational and friendly.

## Steps

1. First, create the ~/.shipnote directory if it doesn't exist:
   Run: `mkdir -p ~/.shipnote`

2. Check if config already exists by reading `~/.shipnote/config.json`. If it does, tell the user their current settings and ask if they want to reconfigure. If they say no, stop.

3. Ask each question one at a time using AskUserQuestion:

**Question 1 — Tone**
Ask: "What tone do you want for your posts?"
Options:
- a) Raw/real — "Spent 3 hours on a bug. Still counts."
- b) Educational — "TIL: Next.js env vars need NEXT_PUBLIC_ prefix"
- c) Hype — "Shipped auth today. One step closer."
- d) Mix — I'll pick the best tone based on the activity
Map: a→"raw", b→"educational", c→"hype", d→"mix"

**Question 2 — Posts per run**
Ask: "How many posts should I generate each time you run /shipnote?"
Options: a) 1, b) 2, c) 3
Map: a→1, b→2, c→3

**Question 3 — Repos path**
Ask: "Where are your project repos?"
Options:
- a) ~/Code (default)
- b) Let me type a custom path
If b, ask them to type the path.

**Question 4 — Platform**
Ask: "What platform are you posting on?"
Options: a) Threads, b) X (Twitter), c) Both
Map: a→"threads", b→"x", c→"both"

**Question 5 — Max post length**
Ask: "Max character limit per post?"
Options:
- a) 500 (Threads default)
- b) 280 (X/Twitter)
- c) Custom
If Threads was selected in Q4, default to 500. If X, default to 280. If both, default to 280.

4. Save the config to `~/.shipnote/config.json`:

```json
{
  "tone": "<selected tone>",
  "postsPerRun": <selected number>,
  "reposPath": "<selected path>",
  "platform": "<selected platform>",
  "maxLength": <selected length>
}
```

5. Also initialize the checkpoint file `~/.shipnote/last-checkpoint.json` with the current timestamp:

```json
{
  "lastRun": "<current ISO timestamp>",
  "postsToday": 0
}
```

6. Confirm: "You're all set! Run /shipnote to generate your first post."
```

- [ ] **Step 2: Commit**

```bash
git add commands/shipnote-setup.md
git commit -m "Add onboarding command /shipnote-setup"
```

---

### Task 5: Generate Post Skill

**Files:**
- Create: `skills/generate-post/SKILL.md`

This is the core skill — it scans repos, reads config/checkpoint, generates a post, saves it, and updates the checkpoint.

- [ ] **Step 1: Create the generate-post skill**

```markdown
---
name: generate-post
description: Generate a build-in-public post from recent git activity. Used by the /shipnote command. Scans git repos, crafts a human-sounding post, saves it, and updates the checkpoint.
---

You are generating a "build in public" post based on the user's recent development activity.

## Step 1: Check Config

Read `~/.shipnote/config.json`. If it doesn't exist, tell the user: "No config found. Run /shipnote-setup first to configure Shipnote." and stop.

Extract these values:
- `tone` (raw, educational, hype, mix)
- `postsPerRun` (1, 2, or 3)
- `reposPath` (path to scan)
- `platform` (threads, x, both)
- `maxLength` (character limit)

## Step 2: Read Checkpoint

Read `~/.shipnote/last-checkpoint.json`. Extract `lastRun` timestamp.

If the file doesn't exist, use the start of today (midnight) as the checkpoint.

## Step 3: Scan Repos

Run the scan script:
```
bash ${CLAUDE_PLUGIN_ROOT}/scripts/scan-repos.sh "<reposPath>" "<lastRun timestamp>"
```

If the output is `NO_ACTIVITY`, tell the user:
"No new commits since your last post. Keep building — run /shipnote again later!"
Do not generate a post. Do not update the checkpoint.

## Step 4: Generate Post

Using the git activity from the scan, generate post(s) following these rules:

**Voice rules:**
- Sound like a real person, not an AI
- Include the struggle, the surprise, or the small win
- No hashtags
- No emojis unless it genuinely fits
- Max {maxLength} characters per post
- Never say "just shipped", "excited to announce", "happy to share", or "proud to"
- Write like you're texting a dev friend about your day
- If the work was boring, say it was boring
- If it took too long, say it took too long
- Short paragraphs. Line breaks between thoughts.
- Don't mention specific file names or technical jargon unless it adds to the story

**Tone adjustments:**
- `raw`: Focus on the real experience. Struggles, time spent, honest reactions.
- `educational`: Pull out a lesson or tip from the work. "TIL:" or "Note to self:" style.
- `hype`: Focus on momentum and progress. Short, punchy, forward-looking.
- `mix`: Read the activity and pick whichever tone fits best for each post.

**Platform adjustments:**
- `threads`: Up to 500 characters. Can be multi-paragraph.
- `x`: Max 280 characters. Single tight paragraph.
- `both`: Generate one version for each platform.

Generate exactly {postsPerRun} post(s).

## Step 5: Display Posts

Print each post clearly separated:

```
---
[Post 1 content]
---
```

If multiple posts, number them.

## Step 6: Save Posts

Append the generated post(s) to `~/.shipnote/posts.md` in this format:

```markdown
## YYYY-MM-DD

### HH:MM AM/PM
[post content]
```

If today's date header already exists in the file, append under it. If not, add a new date header.

Create the file if it doesn't exist.

## Step 7: Update Checkpoint

Write `~/.shipnote/last-checkpoint.json`:

```json
{
  "lastRun": "<current ISO timestamp>",
  "postsToday": <previous postsToday + number of posts just generated>
}
```

## Step 8: Confirm

After displaying the post(s), add:
"Post saved to ~/.shipnote/posts.md — copy and paste to {platform}!"
```

- [ ] **Step 2: Commit**

```bash
git add skills/generate-post/SKILL.md
git commit -m "Add generate-post skill — core post generation logic"
```

---

### Task 6: Main Command (`/shipnote`)

**Files:**
- Create: `commands/shipnote.md`

This is the main entry point. It checks for config (triggers setup if missing) and invokes the generate-post skill.

- [ ] **Step 1: Create the shipnote command**

```markdown
---
name: shipnote
description: Generate a build-in-public post from your recent git activity. Scans all your repos and creates a ready-to-post Threads update.
---

You are Shipnote — a tool that turns dev activity into build-in-public posts.

## First Run Check

Check if `~/.shipnote/config.json` exists by trying to read it.

If it does NOT exist:
- Say: "Welcome to Shipnote! Let's set you up first."
- Run the full onboarding flow as described in the /shipnote-setup command:
  1. Create ~/.shipnote directory
  2. Ask tone preference (raw/educational/hype/mix) using AskUserQuestion
  3. Ask posts per run (1/2/3) using AskUserQuestion
  4. Ask repos path (default ~/Code) using AskUserQuestion
  5. Ask platform (threads/x/both) using AskUserQuestion
  6. Ask max length (500/280/custom) using AskUserQuestion
  7. Save config to ~/.shipnote/config.json
  8. Initialize checkpoint to current time
  9. Then continue to generate the first post

If config EXISTS, proceed directly to post generation.

## Post Generation

Use the generate-post skill to:
1. Read config and checkpoint
2. Scan repos using: `bash ${CLAUDE_PLUGIN_ROOT}/scripts/scan-repos.sh`
3. Generate post(s) based on activity
4. Display, save, and update checkpoint

Follow all rules in the generate-post skill exactly.
```

- [ ] **Step 2: Commit**

```bash
git add commands/shipnote.md
git commit -m "Add /shipnote command — main entry point"
```

---

### Task 7: Log Command (`/shipnote-log`)

**Files:**
- Create: `commands/shipnote-log.md`

- [ ] **Step 1: Create the log command**

```markdown
---
name: shipnote-log
description: View your past Shipnote posts. Shows today's posts by default.
---

You are showing the user their past Shipnote posts.

## Steps

1. Read `~/.shipnote/posts.md`.

If the file doesn't exist or is empty, say:
"No posts yet. Run /shipnote to generate your first one!"

2. If the user provided a date argument (e.g., `/shipnote-log 2026-04-03`), find and display only posts under that date's header (`## 2026-04-03`).

3. If no date argument, find today's date header and display all posts from today.

4. If no posts found for the requested date, say:
"No posts for [date]. Run /shipnote to generate one!"

5. Display the posts clearly formatted. At the end, show a count: "Showing N post(s) from [date]."
```

- [ ] **Step 2: Commit**

```bash
git add commands/shipnote-log.md
git commit -m "Add /shipnote-log command — view past posts"
```

---

### Task 8: End-to-End Test

No code to write — this is a manual verification task.

- [ ] **Step 1: Test the scan script standalone**

Run:
```bash
bash scripts/scan-repos.sh ~/Code "2026-04-01T00:00:00Z"
```

Verify: Output shows repo names and commits from the last few days. If no activity, output is `NO_ACTIVITY`.

- [ ] **Step 2: Test /shipnote-setup**

In Claude Code, run `/shipnote-setup`. Walk through all 5 questions. Verify:
- `~/.shipnote/config.json` was created with correct values
- `~/.shipnote/last-checkpoint.json` was created

- [ ] **Step 3: Test /shipnote**

Run `/shipnote`. Verify:
- It reads config correctly
- It runs the scan script
- It generates a post in the right tone
- It prints the post to console
- It appends to `~/.shipnote/posts.md`
- It updates `last-checkpoint.json`

- [ ] **Step 4: Test /shipnote with no activity**

Update `last-checkpoint.json` to the current time, then run `/shipnote`. Verify it says "No new commits" and does NOT create a post.

- [ ] **Step 5: Test /shipnote-log**

Run `/shipnote-log`. Verify it shows today's posts.

- [ ] **Step 6: Test first-run onboarding**

Delete `~/.shipnote/config.json` and run `/shipnote`. Verify it triggers the setup flow before generating a post.

- [ ] **Step 7: Final commit**

```bash
git add -A
git commit -m "Shipnote v1.0.0 — ready for use"
```

---

### Task 9: Create GitHub Repository

- [ ] **Step 1: Create the repo on GitHub**

```bash
cd /Users/petarstoev/Code/shipnote
gh repo create shipnote --public --description "Turn your daily dev activity into build-in-public posts. A Claude Code plugin." --source . --push
```

- [ ] **Step 2: Verify**

Check https://github.com/<username>/shipnote shows all files, README renders correctly, and license is detected.
