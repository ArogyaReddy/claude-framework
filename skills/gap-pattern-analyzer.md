---
description: Analyze gap patterns and evolve completion-audit skill triggers
argument-hint: Period to analyze (e.g., "last 30 days", "monthly", "all time")
---

You are a skill evolution specialist. Analyze gap patterns from completion-audits and improve the framework's verification capabilities.

For: $ARGUMENTS

## Analysis Process

1. **Load Gap Pattern Data**
   - Read .claude/logs/gap-patterns.jsonl
   - Parse JSON entries for specified time period
   - Extract gap types, contexts, and frequencies
   - Identify user request patterns that led to gaps

2. **Pattern Recognition Analysis**
   ```
   TOP GAP TYPES (by frequency):
   - error_handling: 15 occurrences (40% of audits)
   - validation: 12 occurrences (32% of audits)
   - testing: 8 occurrences (21% of audits)

   CONTEXT CLUSTERING:
   - authentication: [error_handling, validation, security]
   - forms: [validation, usability, edge_cases]
   - APIs: [error_handling, documentation, testing]

   SEVERITY ESCALATION PATTERNS:
   - validation gaps → security vulnerabilities (3 cases)
   - missing testing → critical bugs in production (2 cases)
   ```

3. **Trigger Effectiveness Review**
   - Map original user requests to gap outcomes
   - Identify request patterns that should trigger completion-audit but don't
   - Find false positives (triggers that don't lead to gaps)
   - Recommend new keywords/patterns

4. **Skill Enhancement Recommendations**
   - New trigger keywords for high-frequency gap contexts
   - Enhanced checklist items for recurring gap types
   - Updated priority levels based on severity patterns
   - Additional validation questions for common edge cases

## Output Format

```
GAP PATTERN EVOLUTION REPORT

📊 ANALYSIS SUMMARY (Last X Days)
Total Audits: N
Average Completion Rate: X%
Most Common Gaps: [gap_type_list]
Critical Gap Clusters: [context_list]

🔄 TRIGGER OPTIMIZATION

RECOMMENDED ADDITIONS to skill-rules.json:
```json
{
  "completion-audit": {
    "promptTriggers": {
      "keywords": [
        // Current keywords...
        "authentication system",    // New: catches auth context gaps
        "form handling",           // New: catches validation gaps
        "API endpoints",          // New: catches error_handling gaps
        "user input"              // New: catches validation gaps
      ],
      "intentPatterns": [
        // Current patterns...
        "(auth|login|signup).*?(system|flow)",     // New: auth context
        "(form|input).*?(validation|handling)",    // New: validation context
        "(api|endpoint).*?(create|implement)"      // New: API context
      ]
    }
  }
}
```

FALSE POSITIVE CLEANUP:
- Remove: ["keyword1"] - triggered 5 times with 0 gaps found
- Adjust priority: ["keyword2"] from high to medium

📋 SKILL CONTENT UPDATES

ENHANCE AUDIT CHECKLIST:
+ Add specific checks for [recurring_gap_type]
+ New validation questions for [context_cluster]
+ Severity upgrade rules for [escalation_pattern]

UPDATE GAP TYPE DEFINITIONS:
+ New gap subtype: [emerging_pattern]
+ Merge similar types: [redundant_types]
+ Clarify distinction: [confusing_types]

🎯 IMPLEMENTATION ROADMAP

IMMEDIATE (This Session):
[ ] Update .claude/skills/skill-rules.json with new triggers
[ ] Enhance completion-audit.md checklist sections
[ ] Add new gap type definitions

NEXT MONTH:
[ ] Monitor trigger effectiveness with new keywords
[ ] Collect data on new gap patterns
[ ] Refine severity escalation rules

QUARTERLY:
[ ] Comprehensive trigger pattern review
[ ] Cross-project gap pattern analysis
[ ] Framework-wide skill optimization

📈 EFFECTIVENESS METRICS

Expected Improvements:
- Gap detection rate: +X% (from better triggers)
- False positive reduction: -Y% (from pattern cleanup)
- Critical gap prevention: +Z% (from enhanced checklists)

Tracking KPIs:
- Completion rate trends
- Gap type distribution changes
- Time-to-audit improvements
- User satisfaction with verification accuracy
```

## Implementation Instructions

### Auto-Update Triggers
```bash
# After generating recommendations, update skill-rules.json:
cp .claude/skills/skill-rules.json .claude/skills/skill-rules.json.backup
# Apply JSON patches from recommendations
# Test trigger effectiveness

# Update completion-audit skill content:
cp skills/completion-audit.md skills/completion-audit.md.backup
# Apply recommended checklist enhancements
# Update gap type definitions
```

### Validation Process
1. **A/B Test Period:** Run both old and new triggers for 2 weeks
2. **Effectiveness Measurement:** Compare gap detection rates
3. **Rollback Safety:** Keep backups of previous configurations
4. **User Feedback:** Survey completion-audit usage satisfaction

### Continuous Learning Loop
- **Weekly:** Light pattern review (top 3 gap types)
- **Monthly:** Full evolution analysis and skill updates
- **Quarterly:** Cross-project pattern analysis and framework optimization
- **Annually:** Complete trigger system redesign based on accumulated data

## Integration Notes

- **Prerequisite:** Requires .claude/logs/gap-patterns.jsonl with >10 entries
- **Output:** Updated skill-rules.json and completion-audit.md
- **Safety:** Always backup before modifications
- **Measurement:** Track before/after effectiveness metrics
- **Scope:** Can analyze single project or cross-project patterns