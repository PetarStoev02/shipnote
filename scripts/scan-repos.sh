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
