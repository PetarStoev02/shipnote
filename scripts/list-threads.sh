#!/bin/bash
# List recent Threads posts with their IDs, text, and timestamps.
# Usage: bash list-threads.sh "<threads user id>" "<access token>" [limit]

set -euo pipefail

USER_ID="$1"
ACCESS_TOKEN="$2"
LIMIT="${3:-10}"

if [ -z "$USER_ID" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "ERROR: Missing arguments."
  echo "Usage: bash list-threads.sh \"<user_id>\" \"<access_token>\" [limit]"
  exit 1
fi

RESPONSE=$(curl -s -X GET \
  "https://graph.threads.net/v1.0/$USER_ID/threads?fields=id,text,timestamp,permalink&limit=$LIMIT&access_token=$ACCESS_TOKEN")

ERROR=$(echo "$RESPONSE" | grep -o '"error"' || true)

if [ -n "$ERROR" ]; then
  echo "ERROR: Failed to list posts."
  echo "$RESPONSE"
  exit 1
fi

echo "$RESPONSE"
