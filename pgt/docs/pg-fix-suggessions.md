
## Fix Approach Review

Here are the 4 critical fixes with exact code changes:

---

### **Fix 1: Bash Compatibility** (Line 10, 80, 105)

**Problem**: Associative arrays require Bash 4+, macOS default is Bash 3.2

**Approach**: Add version check early + convert to function-based lookups

```bash
# AFTER line 10 (after set -euo pipefail), ADD:

# ═══════════════════════════════════════════════════════════════
# BASH VERSION CHECK
# ═══════════════════════════════════════════════════════════════
if (( BASH_VERSINFO[0] < 4 )); then
  echo "ERROR: Requires Bash 4.0+"
  echo "macOS default is Bash 3.2. Install: brew install bash"
  echo "Then run with: /usr/local/bin/bash $(basename "$0") $@"
  exit 1
fi
```

**Alternative**: If you want Bash 3.2 support, replace associative arrays with case statements:

```bash
# REPLACE lines 80-100 (FRAMEWORK_MAP) with:
get_framework_for_mode() {
  local mode="$1"
  case "$mode" in
    code|debug|refactor|build|test) echo "RISEN" ;;
    spec) echo "SCWA" ;;
    architect|plan) echo "COAST" ;;
    review|research|analyze|create) echo "CARE" ;;
    document|write|communicate) echo "STAR" ;;
    decide) echo "DECISION" ;;
    learn) echo "FEYNMAN" ;;
    daily|email) echo "PREP" ;;
    *) echo "RISEN" ;;  # default
  esac
}

# Then in code, replace ${FRAMEWORK_MAP[$MODE]} with:
# FRAMEWORK=$(get_framework_for_mode "$MODE")
```

**Which do you prefer?**
- Option A: Version check + keep associative arrays (simpler fix, requires Bash 4+)
- Option B: Convert to functions (more work, supports Bash 3.2)

---

### **Fix 2: Memory Integration** (Lines 791-793, 951-952)

**Problem**: Reads `SESSION_LOG.md` (doesn't exist), should read `SCRATCHPAD.md`, `DECISIONS.md`, `SESSIONS.md`

**Replace lines 789-794**:
```bash
# OLD
if [[ -f "SESSION_LOG.md" ]]; then
  log_info "SESSION_LOG.md found — injecting recent context"
  SESSION_CONTEXT=$(tail -50 SESSION_LOG.md 2>/dev/null || echo "")
fi

# NEW
# Framework Integration — Memory System Alignment
if [[ -f "SCRATCHPAD.md" ]]; then
  log_info "SCRATCHPAD.md found — injecting resume context"
  # Extract "Resume Here" section (starts around line 29)
  local resume_section
  resume_section=$(sed -n '/^## Resume Here/,/^---/p' SCRATCHPAD.md | head -15)
  SESSION_CONTEXT="$resume_section"
fi

if [[ -f "DECISIONS.md" ]]; then
  log_info "DECISIONS.md found — injecting recent decisions"
  local recent_decisions
  recent_decisions=$(tail -30 DECISIONS.md)
  SESSION_CONTEXT="${SESSION_CONTEXT}\n\n--- Recent Decisions ---\n${recent_decisions}"
fi
```

**Replace lines 951-953**:
```bash
# OLD
if [[ -n "$SESSION_CONTEXT" ]]; then
  EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<session-history>\nRecent context from SESSION_LOG.md:\n${SESSION_CONTEXT}\n</session-history>"
fi

# NEW
if [[ -n "$SESSION_CONTEXT" ]]; then
  EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<memory-context>\nFrom SCRATCHPAD.md and DECISIONS.md:\n${SESSION_CONTEXT}\n</memory-context>"
fi
```

---

### **Fix 3: Token Budget Enforcement** (Lines 937-963)

**Problem**: No size limits on file injection, can blow up token count

**Add new function before line 937**:
```bash
# ═══════════════════════════════════════════════════════════════
# TOKEN BUDGET ENFORCEMENT
# ═══════════════════════════════════════════════════════════════
estimate_tokens() {
  local text="$1"
  # Rough estimate: 1 token ≈ 4 characters
  echo $(( ${#text} / 4 ))
}

truncate_to_budget() {
  local text="$1"
  local max_tokens="${2:-2000}"  # Default 2K token limit per section
  local char_limit=$(( max_tokens * 4 ))
  
  if (( ${#text} > char_limit )); then
    echo "${text:0:$char_limit}... [TRUNCATED - exceeded ${max_tokens} token budget]"
  else
    echo "$text"
  fi
}
```

**Wrap each context injection with truncation**:

```bash
# Line 941 - file inclusion
file_content=$(cat "$file")
file_content=$(truncate_to_budget "$file_content" 3000)  # ADD THIS LINE
EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<file path=\"${file}\">\n${file_content}\n</file>"

# Line 952 - session context
SESSION_CONTEXT=$(truncate_to_budget "$SESSION_CONTEXT" 1000)  # ADD THIS LINE
EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<memory-context>..."

# Line 958 - decisions
recent_decisions=$(tail -100 .claude/history/decisions.md 2>/dev/null || echo "")
recent_decisions=$(truncate_to_budget "$recent_decisions" 1500)  # ADD THIS LINE
```

**Also add final budget check before render** (add before line 1500+):
```bash
# Final token budget check
final_tokens=$(estimate_tokens "$FINAL_PROMPT")
if (( final_tokens > 8000 )); then
  log_warn "Prompt is ${final_tokens} tokens (>8K). Consider using --quick or fewer --include files."
fi
```

---

### **Fix 4: Safe Argument Parsing** (Lines 1975-1981)

**Problem**: `$2` unguarded, crashes if option has no value

**Replace lines 1973-1984**:
```bash
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --target|-t)
        [[ -z "${2:-}" ]] && { echo "ERROR: --target requires a value"; exit 1; }
        TARGET="$2"; TARGET_LOCKED=true; shift 2 ;;
      --mode|-m)
        [[ -z "${2:-}" ]] && { echo "ERROR: --mode requires a value"; exit 1; }
        MODE="$2"; shift 2 ;;
      --quick|-q)   SPEED="quick"; shift ;;
      --standard)   SPEED="standard"; shift ;;
      --deep|-d)    SPEED="deep"; shift ;;
      --template)
        [[ -z "${2:-}" ]] && { echo "ERROR: --template requires a value"; exit 1; }
        TEMPLATE_NAME="$2"; USE_TEMPLATE=true; shift 2 ;;
      --include)
        [[ -z "${2:-}" ]] && { echo "ERROR: --include requires a value"; exit 1; }
        INCLUDE_FILES+=("$2"); shift 2 ;;
      --chain)      IS_CHAIN=true; shift ;;
      --from-clipboard|--clip) FROM_CLIP=true; shift ;;
      --spec|-s)
        [[ -z "${2:-}" ]] && { echo "ERROR: --spec requires a value"; exit 1; }
        SPEC_FILE="$2"; shift 2 ;;
```

---

### **Fix 5: Delete Duplicates**

```bash
# Simple deletion
rm pgt/pg.sh pgt/pg-01.sh
```

---

## Summary

| Fix | Lines | Complexity | Risk |
|-----|-------|------------|------|
| 1. Bash compat | 10, 80, 105 | Medium | Low (version check) or High (function conversion) |
| 2. Memory | 791-794, 951-953 | Low | Low |
| 3. Token budget | 937-963 | Medium | Low |
| 4. Safe args | 1975-1984 | Low | None |
| 5. Duplicates | N/A | None | None |

**Your call**: 
- **Fix 1**: Version check (fast) or Bash 3.2 support (thorough)?
- **Fixes 2-5**: Approve as-is or adjustments needed?