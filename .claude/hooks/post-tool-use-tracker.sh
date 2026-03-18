#!/bin/bash
set -e

# Post-tool-use hook that tracks edited files for session memory
# Runs after Edit, Write tools complete successfully

# Read tool information from stdin
tool_info=$(cat)

# Extract relevant data
tool_name=$(echo "$tool_info" | jq -r '.tool_name // empty')
file_path=$(echo "$tool_info" | jq -r '.tool_input.file_path // empty')
session_id=$(echo "$tool_info" | jq -r '.session_id // empty')

# Skip if not an edit tool or no file path
if [[ ! "$tool_name" =~ ^(Edit|Write)$ ]] || [[ -z "$file_path" ]]; then
    exit 0
fi

# Skip markdown files in .claude directory (to avoid tracking our own docs)
if [[ "$file_path" =~ \.claude/.*\.md$ ]]; then
    exit 0
fi

# Create session tracking directory
cache_dir="$CLAUDE_PROJECT_DIR/.claude/history/sessions/${session_id:-default}"
mkdir -p "$cache_dir"

# Log edited file with timestamp
timestamp=$(date +%s)
echo "$timestamp:$file_path" >> "$cache_dir/edited-files.log"

# Keep a simple list of unique files edited this session
if ! grep -F -q "$file_path" "$cache_dir/files-list.txt" 2>/dev/null; then
    echo "$file_path" >> "$cache_dir/files-list.txt"
fi

# Count total edits
edit_count=$(wc -l < "$cache_dir/edited-files.log" 2>/dev/null || echo "0")
echo "$edit_count" > "$cache_dir/edit-count.txt"

# Exit cleanly
exit 0
