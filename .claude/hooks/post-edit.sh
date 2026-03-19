#!/bin/bash
# .claude/hooks/post-edit.sh
# Runs automatically after Claude creates or modifies any file.
# Catches type errors and lint violations immediately — before they accumulate.
#
# SETUP: chmod +x .claude/hooks/post-edit.sh
# COST: Zero tokens. Pure shell execution.
# PRINCIPLE: Problems caught in 0 seconds beat problems caught in code review.

FILE="${CLAUDE_FILE_PATH:-}"
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# Only run on code files — skip markdown, json config, etc.
if [[ "$FILE" =~ \.(ts|tsx|js|jsx|mts|cts)$ ]]; then

  echo "[phase-framework] Post-edit check: $FILE"

  # ── Type Check (TypeScript projects) ──────────────────────────────────────
  if [ -f "$PROJECT_ROOT/tsconfig.json" ]; then
    echo "[phase-framework] Running type check..."
    cd "$PROJECT_ROOT" && npx tsc --noEmit --skipLibCheck 2>&1 | head -20
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
      echo "[phase-framework] ⚠ TYPE ERRORS FOUND — fix before committing"
    else
      echo "[phase-framework] ✓ Types clean"
    fi
  fi

  # ── ESLint ─────────────────────────────────────────────────────────────────
  if [ -f "$PROJECT_ROOT/.eslintrc.js" ] || \
     [ -f "$PROJECT_ROOT/.eslintrc.json" ] || \
     [ -f "$PROJECT_ROOT/eslint.config.js" ]; then
    echo "[phase-framework] Running lint on $FILE..."
    cd "$PROJECT_ROOT" && npx eslint "$FILE" --fix --max-warnings 0 2>&1 | tail -5
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
      echo "[phase-framework] ⚠ LINT ISSUES — check output above"
    else
      echo "[phase-framework] ✓ Lint clean (auto-fixed where possible)"
    fi
  fi

  # ── Prettier ───────────────────────────────────────────────────────────────
  if [ -f "$PROJECT_ROOT/.prettierrc" ] || \
     [ -f "$PROJECT_ROOT/.prettierrc.js" ] || \
     [ -f "$PROJECT_ROOT/prettier.config.js" ]; then
    npx prettier --write "$FILE" 2>/dev/null
    echo "[phase-framework] ✓ Formatted"
  fi

fi

# ── Python projects ────────────────────────────────────────────────────────
if [[ "$FILE" =~ \.py$ ]]; then
  echo "[phase-framework] Post-edit check: $FILE"

  if command -v ruff &>/dev/null; then
    ruff check "$FILE" --fix 2>&1 | tail -5
    echo "[phase-framework] ✓ Ruff done"
  fi

  if command -v mypy &>/dev/null; then
    mypy "$FILE" --ignore-missing-imports 2>&1 | tail -10
  fi
fi

exit 0
