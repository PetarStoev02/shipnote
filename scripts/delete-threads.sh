#!/bin/bash
# Delete a Threads post by its media ID.
# Usage: bash delete-threads.sh "<post id>" "<access token>"
# Requires threads_delete permission on your Meta app.

set -euo pipefail

POST_ID="$1"
ACCESS_TOKEN="$2"

if [ -z "$POST_ID" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "ERROR: Missing arguments."
  echo "Usage: bash delete-threads.sh \"<post_id>\" \"<access_token>\""
  exit 1
fi

RESPONSE=$(curl -s -X DELETE \
  "https://graph.threads.net/v1.0/$POST_ID?access_token=$ACCESS_TOKEN")

SUCCESS=$(echo "$RESPONSE" | grep -o '"success":true' || true)

if [ -n "$SUCCESS" ]; then
  echo "SUCCESS:$POST_ID"
else
  echo "ERROR: Failed to delete post $POST_ID"
  echo "$RESPONSE"
  exit 1
fi
