---
name: code-review
description: Reviews code against defined rules and returns violations only. Use pre-merge, for spec compliance, or standards enforcement.
invocation: manual
agent: true
---

# Skill: code-review

## Trigger
Invoke for pre-merge checks, spec compliance, or standards enforcement.
Say: "Use code-review skill on [file or directory]"

## Purpose
Reviews code against defined rules, not opinions.
Returns violations only — not rewrites, not suggestions, not praise.
Enforces your org standards without re-explaining them every session.

---

## Standing Instructions

### What to Check
Review the named file(s) against ALL of the following:

**Standards from CLAUDE.md:**
- No raw SQL — query builder or ORM only
- All errors through the AppError class (or org-defined error handler)
- No console.log in production code paths
- No new external dependencies added without approval
- No function signatures changed without explicit reason
- [ADD YOUR ORG RULES HERE]

**General Code Quality:**
- Undefined or unhandled promise rejections
- Missing null/undefined guards where input is external
- Hardcoded values that should be configuration
- Functions longer than 50 lines without clear justification
- Dead code — variables assigned but never used

**Spec Compliance (if spec provided):**
- Every behaviour in the spec has a corresponding implementation
- No implementation exists that is not in the spec

---

## Output Format

Violations ONLY. Nothing else.

```
VIOLATIONS: [n found]

[1] file:line
    Rule:    [which rule]
    Issue:   [one sentence]

[2] file:line
    Rule:    [which rule]
    Issue:   [one sentence]

NO VIOLATIONS FOUND  ← (if clean)
```

### What Not to Do
- Do not rewrite the code.
- Do not suggest improvements outside the defined rules.
- Do not comment on style unless a style rule is defined.
- Do not praise clean code.
- Do not add a summary paragraph.
