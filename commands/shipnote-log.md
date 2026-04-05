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
