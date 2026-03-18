---
description: Verify task completion against original requirements
argument-hint: Original request or requirement statement
---

You are a completion auditor. Compare what was delivered vs. what was requested.

For: $ARGUMENTS

## Audit Process

1. **Extract Original Requirements**
   - List each explicit requirement from the original request
   - Identify implicit expectations (industry standards, framework conventions)
   - Note success criteria or acceptance conditions
   - Flag any conditional requirements ("if X then Y")

2. **Inventory Actual Deliverables**
   - What files were created/modified (with paths)
   - What functionality was implemented
   - What was skipped, deferred, or marked as TODO
   - What was added beyond the original scope

3. **Cross-Reference Analysis**
   - Map each requirement to deliverable(s)
   - Identify requirements with no corresponding deliverable
   - Identify partial implementations
   - Check for scope creep (deliverables without requirements)

4. **Gap Classification**
   - **Critical gaps:** Block core functionality, must fix immediately
   - **Medium gaps:** Reduce quality/usability, should fix soon
   - **Minor gaps:** Nice-to-have, can defer
   - **Missing validation:** No tests, error handling, edge cases covered

## Output Format

```
COMPLETION AUDIT REPORT

📊 SUMMARY
Requirements Met: X/Y (Z%)
Critical Gaps: N
Status: COMPLETE | PARTIAL | MISSING_CRITICAL

🚨 CRITICAL GAPS (Fix Immediately)
- Requirement: [Original requirement text]
  Missing: [What's missing]
  Impact: [Why this blocks success]
  Action: [Specific fix needed]
  Gap Type: [error_handling | validation | testing | documentation | integration | security]

⚠️ MEDIUM GAPS (Address Soon)
- Requirement: [Original requirement]
  Issue: [Partial implementation/quality issue]
  Impact: [Reduced functionality/user experience]
  Suggestion: [How to improve]
  Gap Type: [performance | usability | maintainability | configuration | edge_cases]

💡 MINOR GAPS (Optional)
- Requirement: [Nice-to-have requirement]
  Status: [Not implemented]
  Rationale: [Why deferring is acceptable]
  Gap Type: [enhancement | optimization | convenience | future_proofing]

✅ FULLY DELIVERED
- Requirement 1: [What was asked] → [What was delivered]
- Requirement 2: [What was asked] → [What was delivered]

🔄 SCOPE ADDITIONS (Delivered Beyond Request)
+ Extra Feature 1: [Added value explanation]
+ Extra Feature 2: [Proactive enhancement rationale]

📈 GAP PATTERN LOGGING (Auto-captured for skill improvement)
```json
{
  "session_id": "$(date +%Y%m%d-%H%M%S)",
  "audit_timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "requirements_total": X,
  "requirements_met": Y,
  "completion_rate": Z,
  "critical_gaps": [
    {"type": "error_handling", "context": "login endpoint", "frequency": 1},
    {"type": "validation", "context": "form inputs", "frequency": 1}
  ],
  "medium_gaps": [
    {"type": "performance", "context": "database queries", "frequency": 1}
  ],
  "common_gap_types": ["error_handling", "validation", "testing"],
  "verdict": "NEEDS_CRITICAL_FIXES"
}
```

📋 NEXT STEPS
[ ] Fix critical gaps (estimated effort: X minutes)
[ ] Address medium gaps (estimated effort: Y minutes)
[ ] Log gap patterns to .claude/logs/gap-patterns.jsonl
[ ] Validate with user requirements interpretation
[ ] Update documentation if scope expanded

VERDICT: [READY_TO_USE | NEEDS_CRITICAL_FIXES | NEEDS_MAJOR_WORK]
```

## Gap Type Classification

### Critical Gap Types (Fix Immediately)
- **error_handling:** Missing try-catch, validation, or error responses
- **validation:** Missing input validation, sanitization, or bounds checking
- **testing:** No way to test/validate implementation
- **documentation:** Missing setup/usage instructions for new features
- **integration:** Feature works in isolation but breaks in system context
- **security:** Potential security vulnerabilities or exposed endpoints

### Medium Gap Types (Address Soon)
- **performance:** Inefficient queries, missing caching, slow operations
- **usability:** Poor user experience, confusing interfaces, missing feedback
- **maintainability:** Hard to read/modify code, missing abstractions
- **configuration:** Missing environment variables, config files, or setup
- **edge_cases:** Boundary conditions, empty states, invalid inputs not handled

### Minor Gap Types (Optional)
- **enhancement:** Nice-to-have features beyond requirements
- **optimization:** Code could be cleaner/faster but functions correctly
- **convenience:** Quality-of-life improvements not in original scope
- **future_proofing:** Extensibility features not currently needed

### Pattern Analysis Categories
- **Recurring Types:** Gap types that appear in >30% of audits
- **Context Patterns:** Gaps that cluster around specific features (auth, forms, API)
- **Severity Trends:** Gap types that frequently escalate from medium to critical
- **Prevention Opportunities:** Gap types that could be caught with better triggers

## Gap Pattern Tracking Workflow

### 1. After Each Audit
```bash
# Auto-append gap data to tracking log
echo '{"session":"'$(date +%Y%m%d-%H%M%S)'","gaps":["error_handling","validation"],"context":"user_auth"}' >> .claude/logs/gap-patterns.jsonl
```

### 2. Weekly Pattern Review (Manual)
```bash
# Analyze recent patterns
tail -50 .claude/logs/gap-patterns.jsonl | grep -o '"[^"]*"' | sort | uniq -c | sort -nr
```

### 3. Monthly Skill Evolution
When pattern analysis shows:
- **>3 occurrences of same gap type:** Add specific trigger keywords
- **>50% audits have same gap category:** Enhance audit checklist
- **New gap pattern emerging:** Update gap type definitions
- **Trigger patterns missing common cases:** Refine skill-rules.json

## Audit Guidelines

### Focus Areas
- **Functional completeness:** Does it do what was asked?
- **Integration points:** Does it work with existing systems?
- **Error handling:** What happens when things go wrong?
- **Edge cases:** Boundary conditions, empty states, invalid inputs
- **Documentation:** Can someone else use/maintain this?

### Red Flags (Always Critical)
- Security vulnerabilities introduced
- Breaking existing functionality
- Missing error handling for user-facing features
- Incomplete database migrations
- Missing configuration for new features
- No way to test/validate the implementation

### Quality Thresholds
- **COMPLETE (90%+):** All requirements met, minor gaps only
- **PARTIAL (70-89%):** Core functionality present, some medium gaps
- **INCOMPLETE (<70%):** Major requirements missing or broken

### Common Gap Patterns
1. **Setup/Configuration:** Code works but setup steps missing
2. **Error States:** Happy path implemented, error handling skipped
3. **Integration:** Feature works in isolation, breaks in context
4. **Documentation:** Implementation complete, usage unclear
5. **Testing:** Feature complete, no validation approach provided
6. **Performance:** Functional requirements met, non-functional ignored

## Usage Examples

```bash
# After implementing authentication
"Use completion-audit skill on: Add user authentication with JWT tokens, login/logout endpoints, and protected routes"

# After complex refactor
"Use completion-audit skill on: Refactor the payment system to use Stripe webhooks, update database schema, and migrate existing data"

# After feature implementation
"Use completion-audit skill on: Build a dashboard showing user analytics with charts, filters by date range, and export to CSV functionality"
```

## Integration Notes

- **Run after:** Multi-step implementations, framework changes, user stories with multiple acceptance criteria
- **Skip for:** Single file edits, trivial bug fixes, simple configuration changes
- **Combine with:** `change-manifest` (what changed) and `session-closer` (lessons learned)
- **Trigger patterns:** "make sure", "complete", "everything", "all requirements", multiple "and" clauses in requests