#!/bin/bash
# Post a text message to Threads via the Meta Graph API.
# Usage: bash post-threads.sh "<post text>" "<threads user id>" "<access token>"

set -euo pipefail

TEXT="$1"
USER_ID="$2"
ACCESS_TOKEN="$3"

if [ -z "$TEXT" ] || [ -z "$USER_ID" ] || [ -z "$ACCESS_TOKEN" ]; then
  echo "ERROR: Missing arguments."
  echo "Usage: bash post-threads.sh \"<text>\" \"<user_id>\" \"<access_token>\""
  exit 1
fi

# Step 1: Create media container
CREATE_RESPONSE=$(curl -s -X POST \
  -d "media_type=TEXT" \
  --data-urlencode "text=$TEXT" \
  -d "access_token=$ACCESS_TOKEN" \
  "https://graph.threads.net/v1.0/$USER_ID/threads")

CONTAINER_ID=$(echo "$CREATE_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$CONTAINER_ID" ]; then
  echo "ERROR: Failed to create media container."
  echo "$CREATE_RESPONSE"
  exit 1
fi

# Step 2: Publish the container
PUBLISH_RESPONSE=$(curl -s -X POST \
  -d "creation_id=$CONTAINER_ID" \
  -d "access_token=$ACCESS_TOKEN" \
  "https://graph.threads.net/v1.0/$USER_ID/threads_publish")

POST_ID=$(echo "$PUBLISH_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$POST_ID" ]; then
  echo "ERROR: Failed to publish post."
  echo "$PUBLISH_RESPONSE"
  exit 1
fi

echo "SUCCESS:$POST_ID"
