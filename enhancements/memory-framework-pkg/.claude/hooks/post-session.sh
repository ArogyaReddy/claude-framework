#!/bin/bash
# .claude/hooks/post-session.sh
# Automatic session wrap — runs when Claude Code session ends.
# Triggers the wrap protocol without manual /wrap command.
#
# SETUP:
#   chmod +x .claude/hooks/post-session.sh
#   Register in .claude/settings.json (see README-MEMORY-FRAMEWORK.md)
#
# COST: ~600-900 tokens per session end. Saves 3,000+ tokens next session.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

SCRATCHPAD="$PROJECT_ROOT/SCRATCHPAD.md"
DECISIONS="$PROJECT_ROOT/DECISIONS.md"
SESSIONS="$PROJECT_ROOT/SESSIONS.md"
WRAP_PROMPT="$PROJECT_ROOT/.claude/commands/wrap.md"

# Only run if memory files exist (framework is installed)
if [ ! -f "$SCRATCHPAD" ]; then
  echo "[memory-framework] SCRATCHPAD.md not found — skipping auto-wrap"
  exit 0
fi

echo "[memory-framework] Session ending — running wrap protocol..."

# Run wrap via headless Claude
# Requires Claude Code CLI to be available as 'claude'
if command -v claude &> /dev/null; then
  claude -p "$(cat "$WRAP_PROMPT")

  Context files available:
  - SCRATCHPAD.md: $(cat "$SCRATCHPAD")
  - DECISIONS.md: $(cat "$DECISIONS")
  - SESSIONS.md: $(cat "$SESSIONS")" \
  --output-format text \
  2>/dev/null

  echo "[memory-framework] Wrap complete. Memory files updated."
else
  echo "[memory-framework] Claude CLI not found. Run /wrap manually before closing."
fi
