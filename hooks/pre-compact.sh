#!/bin/bash
# =============================================================================
# PRE-COMPACT HOOK
# Runs before Claude compacts the context window.
# Purpose: Preserve critical state before compaction wipes working memory.
# =============================================================================

COMPACT_LOG=".claude/logs/compact.log"
CHANGE_LOG=".claude/logs/changes.log"
STATE_SNAPSHOT=".claude/logs/pre-compact-state.md"
SESSION_LOG="SESSION_LOG.md"

mkdir -p .claude/logs

timestamp() { date '+%Y-%m-%d %H:%mm:%S'; }

echo "[$(timestamp)] PRE-COMPACT triggered" >> "$COMPACT_LOG"

# =============================================================================
# CAPTURE: Last SESSION_LOG entry (first ### block, up to 25 lines)
# =============================================================================

LAST_SESSION="SESSION_LOG.md not found."
if [ -f "$SESSION_LOG" ]; then
    START=$(grep -n "^###" "$SESSION_LOG" | head -1 | cut -d: -f1)
    if [ -n "$START" ]; then
        LAST_SESSION=$(tail -n +"$START" "$SESSION_LOG" | head -25)
    fi
fi

# =============================================================================
# SNAPSHOT: Write a state summary before compaction
# =============================================================================

cat > "$STATE_SNAPSHOT" << EOF
# Pre-Compact State Snapshot
Generated: $(timestamp)

## Files Changed This Session
$(cat "$CHANGE_LOG" 2>/dev/null || echo "No change log found.")

## Current Git Status
$(git status --short 2>/dev/null || echo "Not a git repo or git unavailable.")

## Last Session Log Entry
$LAST_SESSION

## Reminder for Post-Compact
After compaction, Claude should:
1. Re-read CLAUDE.md
2. Re-read PROFILE.md
3. Re-read SESSION_LOG.md (last entry)
4. Check .claude/history/decisions.md before making architectural decisions
5. Check this snapshot for what was in progress
6. Ask the user to re-confirm the current task if unclear
EOF

echo "HOOK: Pre-compact snapshot saved to $STATE_SNAPSHOT"

exit 0
