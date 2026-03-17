#!/bin/bash
# =============================================================================
# PRE-TOOL-USE HOOK
# Runs before Claude executes any tool.
# Purpose: Validate scope, block dangerous operations, log intent.
# =============================================================================

TOOL_NAME="${CLAUDE_TOOL_NAME:-unknown}"
TOOL_INPUT="${CLAUDE_TOOL_INPUT:-}"
LOG_FILE=".claude/logs/tool-use.log"

mkdir -p .claude/logs

timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

log() {
  echo "[$(timestamp)] PRE  | $TOOL_NAME | $1" >> "$LOG_FILE"
}

# =============================================================================
# BLOCK: Dangerous bash commands
# =============================================================================
if [ "$TOOL_NAME" = "Bash" ]; then

  DANGEROUS_PATTERNS=(
    "rm -rf"
    "rm -f /"
    "DROP TABLE"
    "DROP DATABASE"
    "TRUNCATE"
    "git push --force"
    "git push -f"
    "chmod 777"
    "sudo rm"
    "> /dev/sda"
    "mkfs"
    "dd if="
    "curl.*| bash"
    "wget.*| bash"
    "eval \$("
  )

  for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$TOOL_INPUT" | grep -qi "$pattern"; then
      echo "HOOK BLOCKED: Dangerous pattern detected: '$pattern'"
      echo "If this is intentional, run it manually outside Claude Code."
      log "BLOCKED — pattern: $pattern"
      exit 1
    fi
  done

  # Warn on production env operations
  if echo "$TOOL_INPUT" | grep -qi "NODE_ENV=production\|--env=production\|env prod"; then
    echo "HOOK WARNING: Production environment operation detected."
    echo "Confirm this is intentional before proceeding."
    log "WARNED — production env operation"
  fi

  log "ALLOWED — $TOOL_INPUT"
fi

# =============================================================================
# BLOCK: Writing to .env files
# =============================================================================
if [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "Edit" ]; then

  if echo "$TOOL_INPUT" | grep -q '\.env'; then
    echo "HOOK BLOCKED: Modifications to .env files are not permitted via Claude."
    echo "Edit .env files manually."
    log "BLOCKED — .env write attempt"
    exit 1
  fi

  # Warn on writing to config files
  if echo "$TOOL_INPUT" | grep -qE '\.(yml|yaml|json)' | grep -qE 'config|settings'; then
    log "WARNED — config file write: $TOOL_INPUT"
  fi

  log "ALLOWED — write to: $TOOL_INPUT"
fi

# =============================================================================
# BLOCK: Package installation without approval
# =============================================================================
if [ "$TOOL_NAME" = "Bash" ]; then
  if echo "$TOOL_INPUT" | grep -qE 'npm install|yarn add|pnpm add|pip install' | grep -v '\-\-help'; then
    echo "HOOK BLOCKED: Package installation requires explicit approval."
    echo "State the package and reason first. Confirm, then run manually."
    log "BLOCKED — package install attempt: $TOOL_INPUT"
    exit 1
  fi
fi

exit 0
