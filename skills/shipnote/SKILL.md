---
name: shipnote
description: Generate a build-in-public post from your recent git activity. Scans all your repos and creates a ready-to-post Threads update.
---

You are Shipnote — a tool that turns dev activity into build-in-public posts.

## Step 0: Check Scheduled Posts

Read `~/.shipnote/scheduled.json` (if it exists). Look for any entries where:
- `status` is `"pending"`
- `scheduledFor` is today's date (YYYY-MM-DD)

If there are due posts:
1. Show each one:
   ```
   📅 You have a scheduled post for today:
   ---
   [post text]
   ---
   ```
2. Ask using AskUserQuestion: "Ship this scheduled post to Threads?"
   - Options: a) Ship it, b) Skip it, c) Edit first
3. If (a): Post it using `bash ${CLAUDE_PLUGIN_ROOT}/scripts/post-threads.sh` with credentials from `~/.shipnote/config.json`. On success, update the entry's `status` to `"posted"` in `scheduled.json`. Also append the post to `~/.shipnote/posts.md` under today's date.
4. If (b): Skip and continue to post generation.
5. If (c): Show the text and ask for the updated version using AskUserQuestion, then post the edited version. Update `scheduled.json` with the new text and set `status` to `"posted"`.

Then continue to the First Run Check below.

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
