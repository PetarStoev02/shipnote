---
name: shipnote-schedule
description: Schedule, list, and manage draft posts for future publishing. Use /shipnote-schedule to see upcoming posts, add new ones with a date, or remove scheduled posts.
---

You are managing the user's scheduled Shipnote posts.

## Data File

All scheduled posts are stored in `~/.shipnote/scheduled.json` as a JSON array. Each entry has:

```json
{
  "id": "<unique numeric string>",
  "text": "<post content>",
  "scheduledFor": "YYYY-MM-DD",
  "createdAt": "<ISO timestamp>",
  "status": "pending | posted"
}
```

If the file doesn't exist, create it with an empty array `[]`.

## Subcommands

Parse the user's input after `/shipnote-schedule`:

### No arguments — List scheduled posts

1. Read `~/.shipnote/scheduled.json`
2. Filter to entries where `status` is `"pending"`
3. Sort by `scheduledFor` ascending
4. Display as a table:

```
📅 Scheduled Posts
─────────────────────────────────────
#1 | Apr 7, 2026 | "First 50 chars of post..."
#2 | Apr 8, 2026 | "First 50 chars of post..."
─────────────────────────────────────
2 post(s) scheduled
```

If no pending posts, say: "No scheduled posts. Use `/shipnote-schedule add` to queue one up."

### `add` — Schedule a new post

1. Ask the user using AskUserQuestion: "What should the post say?"
   - If they provide the text inline (e.g., `/shipnote-schedule add "my post text"`), use that instead of asking.

2. Ask the user using AskUserQuestion: "When should it go out?"
   - Options: a) Tomorrow, b) In 2 days, c) Pick a date (YYYY-MM-DD)
   - Calculate the absolute date from their choice.

3. Read the current `~/.shipnote/scheduled.json` array.

4. Generate a new ID by finding the highest existing numeric ID and adding 1. If no entries exist, start at "1".

5. Append the new entry:
```json
{
  "id": "<next id>",
  "text": "<post content>",
  "scheduledFor": "<calculated YYYY-MM-DD>",
  "createdAt": "<current ISO timestamp>",
  "status": "pending"
}
```

6. Write the updated array back to `~/.shipnote/scheduled.json`.

7. Confirm: "Scheduled for [date]. Run `/shipnote-schedule` to see all upcoming posts."

### `remove` — Remove a scheduled post

1. If no ID provided, first list all pending posts (same as no-arguments view), then ask using AskUserQuestion: "Which post number do you want to remove?"

2. Read `~/.shipnote/scheduled.json`.

3. Find the entry with the matching `id`.

4. Remove it from the array.

5. Write the updated array back.

6. Confirm: "Removed scheduled post #[id]."

### `edit` — Edit a scheduled post

1. If no ID provided, first list all pending posts, then ask using AskUserQuestion: "Which post number do you want to edit?"

2. Show the full text of the selected post.

3. Ask using AskUserQuestion: "What should the new text be?"

4. Update the entry's `text` field.

5. Write the updated array back.

6. Confirm: "Updated post #[id]. Scheduled for [date]."
