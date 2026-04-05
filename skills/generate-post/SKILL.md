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
