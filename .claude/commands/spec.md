# /spec — Phase 2: Write the Specification
# Use AFTER /plan is complete and architecture is agreed.
# Generates plan.md — the source of truth for the entire build phase.
# This file persists across sessions and prevents scope drift.
#
# WHEN TO USE:
#   - Immediately after /plan resolves all key decisions
#   - When resuming a planned feature that needs a spec before building
#   - When formalising a verbal/chat agreement into a written spec
#
# OUTPUT: Creates /specs/[feature-name].md in the project

You are entering Phase 2: Specification. You are writing the contract for the build.

## Your Role Right Now

Convert the agreed plan into a precise, unambiguous specification.
This document will be read by Claude in every subsequent session that touches this feature.
Write it so that a Claude instance with zero context from this conversation can implement
correctly and stay within bounds.

---

## Generate the Spec File

Ask me: "What should this spec file be named?" (e.g., `auth-refresh`, `billing-v2`, `user-search`)
Then create the file at: `/specs/[name].md`

Use this exact structure:

```markdown
# SPEC: [Feature Name]
**Status:** In Progress | Complete | Paused
**Created:** [DATE]
**Last Updated:** [DATE]
**Sessions:** [increment each session that touches this spec]

---

## Intent
[One paragraph. What this feature does and why it exists.
Enough context that someone unfamiliar with the project understands the value.]

## Success Condition
[How we know this is done and correct. Specific, testable where possible.
"The user can do X" or "The endpoint returns Y within Z ms".]

## Scope
### In Scope
- [Explicit list of what WILL be built]

### Out of Scope
- [Explicit list of what will NOT be touched — as important as in-scope]

---

## Technical Approach
[2-4 paragraphs describing the implementation strategy.
Not pseudocode — decisions and reasoning.
Why this approach over the alternatives that were considered.]

## File Map
| File | Action | Purpose |
|------|--------|---------|
| path/to/file.ts | CREATE | What it does |
| path/to/file.ts | MODIFY | What changes and why |
| path/to/file.ts | DELETE | Why it's being removed |

## Dependencies
- [External packages, internal services, or other specs this depends on]
- [Note: no new npm dependencies without explicit approval per CLAUDE.md]

---

## Decisions Locked
[Decisions made during /plan that must not be revisited without architecture review.
For each: what was decided + the reason it was chosen.]

| Decision | Reason | Revisit When |
|----------|--------|--------------|
| [What] | [Why] | [Condition] |

---

## Implementation Checklist
[Break the build into logical chunks — each should be committable independently]

- [ ] Chunk 1: [Description — ~30-60 min of work]
- [ ] Chunk 2: [Description]
- [ ] Chunk 3: [Description]
- [ ] Tests: [What tests are required]
- [ ] Verification: [Run /verify before closing spec]

---

## Known Risks
- [What could go wrong]
- [What is uncertain]
- [What external dependencies could block progress]

---

## Notes
[Anything else Claude needs to know when working on this feature.
Edge cases, business context, related specs, relevant DECISIONS.md entries.]
```

---

## After Creating the Spec

1. Tell me: "Spec created at /specs/[name].md"
2. Add the spec to CLAUDE.md active specs section (surface as suggestion, don't auto-edit)
3. Log the spec creation in DECISIONS.md as a new entry
4. Say: "Phase 2 complete. Type /chunk to begin building."
