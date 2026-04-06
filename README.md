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

```bash
claude plugins marketplace add https://github.com/PetarStoev02/shipnote.git
claude plugins install shipnote
```

Works globally from any directory after install. Restart Claude Code to activate.

## Commands

| Command | Description |
|---------|-------------|
| `/shipnote` | Generate a post from your recent git activity |
| `/shipnote-schedule` | Schedule, list, edit, and remove future posts |
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

## Auto-Post to Threads

Shipnote can post directly to your Threads account. After generating a post, it asks "Ship it to Threads?" — confirm and it's live.

### Setup (one-time, ~5 minutes)

1. Go to [Meta Developer Portal](https://developers.facebook.com) and create a new app
2. Select **"Other"** as the use case, then **"Business"** as the app type
3. In your app dashboard, go to **Add Products** → find **Threads API** → click **Set Up**
4. Go to **Threads API** → **Settings** and add your Threads account as a tester
5. Open Threads, go to **Settings** → **Account** → **Website permissions** → accept the invite
6. Back in the developer portal, go to **Threads API** → **Get Started**:
   - Copy your **Threads User ID** (numeric)
   - Click **Generate Token**, select your account, and copy the **Access Token**
7. Run `/shipnote-setup` in Claude Code and enter your credentials when prompted

Your credentials are stored locally in `~/.shipnote/config.json` and never leave your machine.

> **Note:** Access tokens expire after 60 days. If posting starts failing, regenerate your token in the Meta Developer Portal and run `/shipnote-setup` again.

## Post Scheduling

Schedule posts for future dates instead of publishing immediately:

```
You: /shipnote-schedule add
Shipnote: What should the post say?
You: "Just automated my entire deploy pipeline..."
Shipnote: When should it go out?
  a) Tomorrow  b) In 2 days  c) Pick a date
You: a
Shipnote: Scheduled for 2026-04-08.
```

When you run `/shipnote` on the scheduled date, it prompts you to ship the post before generating a new one. You can also list, edit, or remove scheduled posts with `/shipnote-schedule`.

Scheduled posts are stored in `~/.shipnote/scheduled.json`.

## Post Management

Shipnote includes scripts for managing your Threads posts via the API:

| Script | Description |
|--------|-------------|
| `scripts/list-threads.sh` | List your posts with IDs, text, and timestamps |
| `scripts/delete-threads.sh` | Delete a post by ID |

```bash
# List your recent posts
bash scripts/list-threads.sh "<user_id>" "<access_token>"

# Delete a post
bash scripts/delete-threads.sh "<post_id>" "<access_token>"
```

> **Note:** Deleting posts requires the `threads_delete` permission enabled in your Meta Developer Portal app.

## How it works

1. Checks for scheduled posts due today — offers to ship them first
2. Scans all git repos in your configured path for commits since your last post
3. Claude reads the activity and generates a human-sounding post
4. Post prints to console and saves to `~/.shipnote/posts.md`
5. If Threads is configured, asks "Ship it?" — confirm to post directly
6. Checkpoint updates so next run only covers new activity

## License

MIT
