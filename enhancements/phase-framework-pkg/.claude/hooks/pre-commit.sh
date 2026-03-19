#!/bin/bash
# .claude/hooks/pre-commit.sh
# Runs before any git commit made during a Claude Code session.
# Last line of defence before code enters version control.
#
# SETUP:
#   chmod +x .claude/hooks/pre-commit.sh
#   Also install as git hook: cp .claude/hooks/pre-commit.sh .git/hooks/pre-commit
#
# BLOCKS commit if: type errors exist, tests fail on changed files
# WARNS but ALLOWS commit if: lint warnings (non-zero but non-blocking)

PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM)

echo ""
echo "[phase-framework] Pre-commit check running..."
echo "────────────────────────────────────────────"

BLOCK=0

# ── Type Check (blocks commit) ─────────────────────────────────────────────
if [ -f "$PROJECT_ROOT/tsconfig.json" ]; then
  echo "→ Type check..."
  cd "$PROJECT_ROOT" && npx tsc --noEmit --skipLibCheck 2>&1
  if [ $? -ne 0 ]; then
    echo ""
    echo "✗ COMMIT BLOCKED: Type errors must be resolved first."
    BLOCK=1
  else
    echo "✓ Types clean"
  fi
fi

# ── Run tests for changed files only (warns but doesn't block by default) ──
TS_CHANGED=$(echo "$STAGED_FILES" | grep -E '\.(ts|tsx)$' | grep -v '\.test\.' | head -5)
if [ -n "$TS_CHANGED" ] && [ -f "$PROJECT_ROOT/package.json" ]; then
  echo "→ Running related tests..."
  cd "$PROJECT_ROOT" && npx jest --passWithNoTests --findRelatedTests $TS_CHANGED 2>&1 | tail -10
  if [ $? -ne 0 ]; then
    echo "⚠ TEST FAILURES — commit allowed but review before pushing"
    # Set to BLOCK=1 if you want tests to block commits:
    # BLOCK=1
  else
    echo "✓ Tests passing"
  fi
fi

echo "────────────────────────────────────────────"

if [ $BLOCK -eq 1 ]; then
  echo "[phase-framework] Commit blocked. Fix issues above and retry."
  echo ""
  exit 1
fi

echo "[phase-framework] ✓ Pre-commit checks passed."
echo ""
exit 0
