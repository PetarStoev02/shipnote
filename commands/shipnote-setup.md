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
