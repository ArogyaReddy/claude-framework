## Principal Engineer Assessment: PG v5.0

**Your Goals vs Reality**

| Goal | Status | Blocker |
|------|--------|---------|
| 1. Global/Best for any work | ❌ FAIL | Crashes on macOS default shell (Bash 3.2) |
| 2. Use before AI tools | ⚠️ PARTIAL | Concept correct, execution broken |
| 3. Save cost/tokens | ❌ FAIL | No truncation → cost explosion risk |
| 4. Global runner (dev/non-dev) | ❌ FAIL | Portability failures block all use |
| 5. Save/reuse prompts | ⚠️ PARTIAL | Vault exists, no smart retrieval |

**Bottom Line**: Not production-ready. Copilot's analysis is accurate. This is a promising prototype with fatal execution gaps.

---

## Critical Issues (Fix First)

**1. Runtime Failure (BLOCKER)**
- Script declares associative arrays with `set -u` on line 10
- macOS default Bash (3.2) doesn't support this
- Immediate crash: `unbound variable` at lines 80, 105
- **Impact**: Zero functionality on your primary platform

**2. Memory System Mismatch (HIGH)**
- Hard-coded to `SESSION_LOG.md` (doesn't exist in your repo)
- Should read: `SCRATCHPAD.md`, `DECISIONS.md`, `SESSIONS.md`
- **Impact**: Ignores your entire AI SDLC context → prompts lack critical memory

**3. Cost Explosion Risk (HIGH)**
- No truncation on `--include` file injection (line 937)
- No tail limits on decisions/session context (lines 952, 958, 968)
- **Impact**: Can inject 50K+ tokens uncontrolled, defeats Goal #3

**4. Weak Reuse (MEDIUM)**
- Vault saves prompts but no search/retrieval system
- No tagging, no "similar prompt" lookup
- **Impact**: Can't actually reuse past prompts effectively

---

## How I'd Build This (Principal Engineer Blueprint)

### Architecture: 5 Core Layers

```
┌─────────────────────────────────────────────────┐
│ 1. INPUT LAYER: Normalize user intent          │
│    • Natural language OR task ID OR template   │
│    • Validate syntax early                      │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│ 2. COMPILER: Canonical IR (not target-specific)│
│    Role | Goal | Context | Constraints | Output │
│    • Framework selection (RISEN/SCWA/etc)      │
│    • Memory integration (SCRATCHPAD/DECISIONS) │
│    • Token budget enforcement                   │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│ 3. CONTEXT MANAGER: Smart selection             │
│    • Auto-detect: git, language, stack         │
│    • Truncate intelligently (not dump raw)     │
│    • Priority ranking (spec > decision > file) │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│ 4. RENDERER: Target-specific output            │
│    • claude → XML tags                         │
│    • claude-code → agentic format              │
│    • copilot → inline comments                 │
│    • Universal → markdown                      │
└─────────────────────────────────────────────────┘
                      ↓
┌─────────────────────────────────────────────────┐
│ 5. VAULT: Learning + Retrieval                 │
│    • Tag: [task-type, repo, framework, score] │
│    • Semantic search (fuzzy match on goal)     │
│    • Auto-suggest "you did this before"        │
└─────────────────────────────────────────────────┘
```

### Key Design Principles

**Principle 1: POSIX First, Bash 4+ Optional**
- Fail fast with version check at startup
- Core logic must run on Bash 3.2 (macOS default)
- Advanced features (associative arrays) → optional helper script

**Principle 2: Memory-First Architecture**
- SCRATCHPAD.md → "Resume Here" section = immediate context
- DECISIONS.md → past architectural choices = constraints
- SESSIONS.md → audit trail = learning data
- Integration is not optional, it's the foundation

**Principle 3: Token Budget as First-Class Constraint**
```bash
estimate_tokens() {
  # Rough: 1 token ≈ 4 chars
  echo $(( ${#content} / 4 ))
}

enforce_budget() {
  local budget=8000  # Claude Code context window
  local used=$(estimate_tokens "$FINAL_PROMPT")
  
  if (( used > budget )); then
    truncate_intelligently  # Summarize, don't just cut
  fi
}
```

**Principle 4: Canonical IR Before Rendering**
```json
{
  "role": "Tech Lead debugging TypeScript",
  "goal": "Fix race condition in webhook handler",
  "context": {
    "repo": "ADP-ROLL",
    "stack": ["TypeScript", "Lambda", "GraphQL"],
    "files": ["api/webhooks/stripe.ts:47"],
    "decisions": ["DECISION-003: Use Redis for state"],
    "resume": "Race condition on concurrent webhook calls"
  },
  "constraints": [
    "No new dependencies without approval",
    "Maintain Lambda cold start <2s"
  ],
  "output": "Working code + test + decision log entry",
  "validation": "Passes concurrent load test (10 req/s)"
}
```

This IR can render to ANY target format. Separation of concerns.

**Principle 5: Retrieval > Storage**
Current: Saves prompts as timestamped files.
Needed: `pg --similar "debug webhook"` → shows past prompts with similarity score.

```bash
# Simple keyword-based first pass
search_vault() {
  local query="$1"
  rg -l "$query" "$HISTORY_DIR" | while read file; do
    local score=$(score_similarity "$query" "$file")
    echo "$score $file"
  done | sort -rn | head -5
}
```

---

## Gaps → Action Plan

| Gap | Severity | Fix |
|-----|----------|-----|
| Shell compatibility | CRITICAL | Add Bash version check; fallback to POSIX-safe arrays (indexed, not associative) |
| Memory integration | HIGH | Read SCRATCHPAD:29 ("Resume Here"), DECISIONS:tail-10, not SESSION_LOG |
| Token explosion | HIGH | Add `truncate_context()` with 8K hard limit before render |
| Arg parser crashes | HIGH | Guard all `$2` references: `${2:-}` with explicit error |
| Weak retrieval | MEDIUM | Implement `--similar` flag with keyword-based search |
| Duplicate scripts | LOW | Delete pg.sh and pg-01.sh (identical hashes) |

---

## Make It BEST: 6-Week Roadmap

### Week 1-2: Stability Foundation
- Fix Bash 3.2 compatibility (CRITICAL)
- Safe arg parsing
- Integration tests: run on macOS, Linux, Windows Git Bash

### Week 3: Memory Alignment
- Wire to SCRATCHPAD.md, DECISIONS.md, SESSIONS.md
- Test: Generate prompt mid-session, verify it includes "Resume Here" context
- Add `--no-memory` flag for standalone use outside framework repos

### Week 4: Cost Controls
- Token estimator function
- Auto-truncate context (with user warning)
- Budget enforcement: fail if prompt >20K tokens before sending to AI

### Week 5: Intelligent Retrieval
- Keyword-based search first (`--similar "debug webhook"`)
- Tag prompts: `task-type`, `framework`, `quality-score`
- Show top 3 past prompts before generating new one

### Week 6: Target Adapters
- Formalize IR-to-target rendering
- Add `claude-code-spec-driven` target (integrates with /plan, /spec, /chunk workflow)
- Test: same input → correct format for Claude, Copilot, Claude Code

---

## Immediate Next Steps (This Week)

**1. Fix Runtime (2 hours)**
```bash
# Add at top of pg-v5.sh after shebang
if (( BASH_VERSINFO[0] < 4 )); then
  echo "ERROR: Requires Bash 4+. macOS default is 3.2."
  echo "Install: brew install bash"
  exit 1
fi
```

**2. Memory Integration (1 hour)**
Replace lines 791, 952:
```bash
# OLD
if [[ -f "SESSION_LOG.md" ]]; then
  SESSION_CONTEXT=$(tail -50 "SESSION_LOG.md")
fi

# NEW
if [[ -f "SCRATCHPAD.md" ]]; then
  # Extract "Resume Here" section (line 29)
  RESUME_CONTEXT=$(sed -n '29,/^---/p' SCRATCHPAD.md | head -10)
  SESSION_CONTEXT="$RESUME_CONTEXT"
fi

if [[ -f "DECISIONS.md" ]]; then
  DECISION_CONTEXT=$(tail -50 DECISIONS.md)
  SESSION_CONTEXT="$SESSION_CONTEXT\n\n$DECISION_CONTEXT"
fi
```

**3. Add Token Limit (30 min)**
```bash
enforce_budget() {
  local budget=8000
  local used=$(( ${#FINAL_PROMPT} / 4 ))
  
  if (( used > budget )); then
    echo "⚠️  Prompt ${used} tokens > ${budget} limit. Truncating context..." >&2
    # Keep Role + Goal + Constraints, truncate Context
    FINAL_PROMPT=$(truncate_middle "$FINAL_PROMPT" "$budget")
  fi
}
```

**4. Delete Duplicates (1 min)**
```bash
rm pgt/pg.sh pgt/pg-01.sh
# Keep only pg-v5.sh, update docs
```

---

## What Good Looks Like

### Before (Current)
```bash
$ ./pg-v5.sh --quick "fix webhook bug"
./pg-v5.sh: line 80: FRAMEWORK_MAP: unbound variable
```

### After (Production-Ready)
```bash
$ pg --quick "fix webhook race condition in stripe handler"

📊 Context Detected:
  • Repo: ADP-ROLL
  • Stack: TypeScript + Lambda + GraphQL
  • Resume: "Race condition in api/webhooks/stripe.ts:47"
  • Decision: DECISION-003 (Redis for state)
  
⚡ Generating prompt (claude-code target)...
✅ Generated 1,847 tokens
📋 Copied to clipboard

Found similar past prompt (85% match):
  → 2026-03-15: "debug concurrent webhook issue" [Quality: 9/10]
  → Use: pg --load webhook-2026-03-15

Next: Paste into Claude Code
```

---

## My Take (Direct Answer)

**Does it match your goals?** No. It's 30% of the way there.

**Conceptually?** Solid. The 17-layer architecture and PE frameworks are strong.

**Execution?** Broken. Can't run on your Mac. Can't read your memory files. Will explode your token budget.

**Is it salvageable?** Yes. The foundation is good. Fix the 4 critical gaps (runtime, memory, cost, retrieval) and you have a production tool.

**Time to production-ready?** 6 weeks if you follow the roadmap above. 2 weeks if you just fix the critical blockers.

**Recommendation**: Don't build v6 from scratch. Fix v5's execution gaps first. The architecture is 80% right. You're debugging, not redesigning.


## Next Actions: 5 Critical Fixes

I've created a todo list for the 4 critical fixes from the review:

1. Bash compatibility (version check + Bash 3.2 support)
2. Memory integration (SCRATCHPAD.md, DECISIONS.md, SESSIONS.md)
3. Token budget enforcement
4. Delete duplicates (pg.sh, pg-01.sh)
5. Test everything

## Decision Point:

Do you want me to:
  Start fixing now (I'll work through the list, marking each complete as I go)
  Review the fix approach first (I'll show you the code changes before applying them)
