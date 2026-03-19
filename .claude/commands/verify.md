# /verify — Phase 4: Interrogate the Output
# Use AFTER a build chunk is complete, BEFORE committing.
# Also use after any significant Claude output you want stress-tested.
# This is Claude reviewing its own work with adversarial eyes.
#
# WHEN TO USE:
#   - After every /chunk completion (mandatory)
#   - After any architectural decision to stress-test it
#   - Before closing a spec (full feature verification)
#   - Whenever output feels "too easy" — fast output is a risk signal
#
# MODES:
#   /verify         → standard chunk verification
#   /verify full    → full spec verification (all chunks complete)
#   /verify [file]  → verify a specific file

You are entering Phase 4: Verification.
Switch mental models entirely. You are no longer the engineer who built this.
You are a senior reviewer who is skeptical, thorough, and has no attachment to the output.

---

## Standard Chunk Verification

Answer every question below. Do not skip. Do not be reassuring.
If the answer is "I don't know" — that is the answer. State it.

### 1. Assumptions I Made
List every assumption made while building this chunk.
For each: was it verified against the codebase, or inferred?
Flag any assumption that was NOT verified.

### 2. What Could Break
List every way this code could fail in production.
Include: edge cases, race conditions, null/undefined inputs, network failures,
concurrent access, large data volumes, unexpected user behaviour.
Rate each: [HIGH / MEDIUM / LOW] likelihood.

### 3. What I Added That Wasn't Asked For
List every file, function, abstraction, or dependency that was not
explicitly in the spec or requested in the prompt.
For each: was it necessary, or could it be removed?

### 4. What I Did Not Handle
List edge cases that exist but were not addressed in this chunk.
These are not bugs — they are known gaps. State them explicitly
so they can be tracked or deferred deliberately.

### 5. Type Safety and Error Handling
- Are there any implicit `any` types? (per CLAUDE.md — none allowed)
- Are all async operations wrapped in try/catch or have error boundaries?
- Are all external inputs validated before use?
- Are error messages meaningful or generic?

### 6. Spec Compliance Check
Re-read the active spec's "Out of Scope" section.
Did this chunk touch anything listed there? If yes — flag it now.
Re-read the "Decisions Locked" section.
Did this chunk contradict any locked decision? If yes — flag it now.

### 7. The One Thing Most Likely to Cause a PR Comment
If a senior engineer reviews this, what is the single most likely
thing they will push back on? State it directly.

---

## Full Spec Verification (/verify full)

Run all standard checks above, then additionally:

### Spec Completeness
- Is every item in the Implementation Checklist marked ✓?
- Is the success condition from the spec now met?
- Are there any TODOs or temporary code left in the implementation?

### Integration Risk
- Does this feature interact with any other active specs?
- Are there any shared interfaces that changed — and do all consumers still work?
- Does the feature work correctly at the boundaries (first call, last call, empty state, error state)?

### The Agent Review (Optional but Recommended)
For high-stakes features, spawn an independent review:
"I'm going to ask a fresh Claude instance to review this code without
any context from our session. It will have no attachment to the decisions we made.
Type: /agent-review to trigger this."

---

## Verification Output Format

End verification with:

```
## Verification Summary

Risk level: LOW / MEDIUM / HIGH
Blockers (must fix before commit): [list or "none"]
Warnings (should fix, non-blocking): [list or "none"]
Deferred gaps (known, tracked): [list or "none"]
Spec compliance: PASS / FAIL [detail if fail]

Recommendation: COMMIT / FIX FIRST / ESCALATE
```
