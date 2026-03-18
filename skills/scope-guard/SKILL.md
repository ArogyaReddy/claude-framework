---
name: scope-guard
description: Prevents scope creep and edits outside explicit task boundaries. Use before any multi-file change, refactoring, or feature implementation to stay focused on stated goals. Catches drive-by refactors, undeclared dependencies, and out-of-scope edits.
---

# Scope Guard Skill

## Purpose

Prevent scope creep by enforcing that changes stay within  explicitly defined task boundaries. Essential for complex projects where uncontrolled edits can introduce bugs or break working code.

## When to Use

**Auto-activates** when you mention:
- Multi-file edits
- Refactoring
- Feature implementation
- Changing multiple files

**Manually invoke** before:
- Any task affecting 2+ files
- Refactoring existing code
- Adding new features
- Making architectural changes

## Core Rules

### ✅ ALLOWED

- Change only **named files** and **named symbols**
- Make changes **directly related to stated task**
- Ask permission if blocked by scope limitations

### ❌ BLOCKED

- **No drive-by refactors** (renaming unrelated functions)
- **No new files** unless explicitly requested
- **No new dependencies** (npm install, package additions)
- **No changes to unmentioned files** even if "related"

---

## Quick Start Protocol

### 1. Define Scope

Before starting work, explicitly state:

```text
TASK SCOPE:
- Goal: [What we're achieving]
- Files: [Exact files to edit]
- Symbols: [Functions/classes to modify]
- Dependencies: [Any new packages needed]
```

### 2. During Work

**If you need to edit an out-of-scope file:**

STOP and report using this template:

```text
⚠️ SCOPE BLOCKER

Required change: path/to/file.js:42
Reason: Function signature changed, requires update to caller
Impact: [Low/Medium/High]

OPTIONS:
1. Expand scope to include this file
2. Skip this file and mark as TODO
3. Stop current task

User approval required.
```

### 3. After Work

Report actual scope:

```text
SCOPE SUMMARY:
✅ Modified: [list of files actually changed]
⚠️ Skipped: [files that needed changes but were out of scope]
📝 Follow-up: [tasks discovered but not completed]
```

---

## Common Scope Violations

### ❌ Drive-By Refactor
```typescript
// WRONG: While adding a feature, renaming unrelated code
export function getUserData() {  // <- Renamed from fetchUser()
  // ... (out of scope!)
}

export function newFeature() {
  // ... (in scope)
}
```

### ❌ Undeclared File Edit
```text
Task: "Fix login button styling"
Scope: src/components/LoginButton.jsx

Changes made:
- src/components/LoginButton.jsx ✅
- src/styles/theme.css ❌ (NOT in scope!)
```

### ❌ Dependency Creep
```bash
# WRONG: Installing packages not mentioned in task
npm install lodash moment  # ❌ Not approved
```

### ✅ Correct Approach
```text
Task: "Fix login button styling"

Change: src/components/LoginButton.jsx

Blocker encountered: theme.css needs update
Action: STOPPED and reported blocker
```

---

## Enforcement Checklist

Before making ANY edit, verify:

- [ ] File is explicitly mentioned in task scope
- [ ] Symbol (function/class/variable) is explicitly mentioned OR directly required by stated goal
- [ ] No new files created (unless task says "create X file")
- [ ] No new dependencies added (unless task says "add X package")
- [ ] No refactoring of unrelated code (even if it "looks wrong")

If ANY checkbox fails → **STOP and report blocker**

---

## Integration with Other Skills

**Use scope-guard WITH:**

- **debug-first**: Define scope before diagnosing bugs
- **spec-to-task**: Break specs into scoped tasks
- **code-review**: Review only in-scope changes
- **session-closer**: Report actual vs planned scope

**Example workflow:**
1. Start: Define scope explicitly
2. Middle: Use scope-guard to prevent drift
3. End: Report scope summary in session closer

---

## Reference Resources

For detailed examples and patterns, see:

### [resources/examples.md](resources/examples.md)
- Real-world scenario walkthroughs
- Before/after examples
- Scope blocker reports from actual tasks

### [resources/patterns.md](resources/patterns.md)
- Common scope creep patterns
- How to detect them early
- Recovery strategies when scope expands

---

## Quick Reference

**When in doubt:**
1. Ask: "Is this file/symbol explicitly in my task scope?"
2. If NO → Report blocker, don't edit
3. Document all scope expansions

**Golden Rule:** Touch only what's named. Report everything else.

---

**Status:** Following 500-line rule ✅
**Line Count:** < 200 lines
**Progressive Disclosure:** Detailed examples in resources/
