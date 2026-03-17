#!/bin/bash
# =============================================================================
# POST-TOOL-USE HOOK
# Runs after Claude executes any tool.
# Purpose: Log all activity, capture output, flag unexpected results.
# =============================================================================

TOOL_NAME="${CLAUDE_TOOL_NAME:-unknown}"
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"
TOOL_OUTPUT="${CLAUDE_TOOL_OUTPUT:-}"
TOOL_EXIT_CODE="${CLAUDE_TOOL_EXIT_CODE:-0}"
LOG_FILE=".claude/logs/tool-use.log"
CHANGE_LOG=".claude/logs/changes.log"
SESSION_LOG=".claude/logs/session-$(date '+%Y-%m-%d').log"

mkdir -p .claude/logs

timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

log() {
  echo "[$(timestamp)] POST | $TOOL_NAME | $1" >> "$LOG_FILE"
  echo "[$(timestamp)] $TOOL_NAME | $1" >> "$SESSION_LOG"
}

# =============================================================================
# LOG: Every tool execution
# =============================================================================
log "exit=$TOOL_EXIT_CODE | input=$(echo "$TOOL_INPUT" | head -c 120)"

# =============================================================================
# LOG: File writes — track all changes
# =============================================================================
if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then
  FILENAME=$(echo "$TOOL_INPUT" | grep -o '"path":"[^"]*"' | cut -d'"' -f4)
  echo "[$(timestamp)] CHANGED: $FILENAME" >> "$CHANGE_LOG"
  log "file changed: $FILENAME"
fi

# =============================================================================
# FLAG: Non-zero exit codes from Bash
# =============================================================================
if [ "$TOOL_NAME" = "Bash" ] && [ "$TOOL_EXIT_CODE" != "0" ]; then
  echo "HOOK NOTICE: Command exited with code $TOOL_EXIT_CODE"
  echo "Output: $(echo "$TOOL_OUTPUT" | tail -5)"
  log "FAILED — exit $TOOL_EXIT_CODE"
fi

# =============================================================================
# LOG: Test results summary
# =============================================================================
if [ "$TOOL_NAME" = "Bash" ]; then
  if echo "$TOOL_INPUT" | grep -qE 'jest|vitest|pytest|npm test|yarn test'; then
    if echo "$TOOL_OUTPUT" | grep -qi "failed\|error"; then
      echo "HOOK NOTICE: Tests appear to have failures. Review output before continuing."
      log "TESTS FAILED"
    else
      log "TESTS PASSED"
    fi
  fi
fi

exit 0
