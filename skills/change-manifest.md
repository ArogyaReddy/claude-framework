---
name: change-manifest
description: Produces a CHANGE MANIFEST table after multi-file edits — what changed, what file, and why.
invocation: manual
agent: false
---

# Skill: change-manifest

## Trigger
Invoke after any multi-file edit, or any task where traceability matters.
Say: "Use change-manifest skill." (after the work is done)

## Purpose
Produces a structured record of exactly what changed, why, and what was preserved.
Used for: PR descriptions, audit trails, spec traceability, handoff notes.

---

## Standing Instructions

After completing any code change, immediately produce the following manifest.
Do not wait to be asked if this skill is active.

### What to Record
- Every file that was modified, created, or deleted
- For each file: what specifically changed (one line per change)
- The reason for each change (reference the spec section if applicable)
- What was explicitly NOT changed (even if it looked like it needed it)
- Any scope blockers that were encountered and how they were resolved

---

## Output Format

```
CHANGE MANIFEST
═══════════════════════════════════

Modified:
  src/[file]
    + [what was added — one line]
    ~ [what was changed — one line]
    - [what was removed — one line]
    ✓ preserved: [what was explicitly left alone]

Created:
  src/[new file]
    Purpose: [one sentence]

Deleted:
  [none / filename]

Spec Reference:
  [spec section or "no spec"]

Scope Notes:
  [anything that was intentionally left alone and why]
  [any blockers encountered]

═══════════════════════════════════
```

### Rules
- One line per change. No prose paragraphs.
- If nothing changed in a category, omit that category.
- Reference spec sections as: specs/[file].md § [section heading]
