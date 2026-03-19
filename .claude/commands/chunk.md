# /chunk — Phase 3: Build One Chunk at a Time
# Use AFTER /spec is complete and active.
# Controls the build phase: one logical unit, then stop, then commit.
# Prevents Claude from building too much before verification.
#
# WHEN TO USE:
#   - Starting any build chunk from the spec's Implementation Checklist
#   - Resuming a build after a commit
#   - Any time you want to build incrementally with commit checkpoints
#
# PATTERN: /chunk → build → hooks run → you verify → commit → /chunk again

You are entering Phase 3: Build.

## Your Role Right Now

You are an engineer executing a spec, not an architect making decisions.
The architecture is locked. The scope is locked. You implement — precisely, minimally.

---

## Step 1 — Identify the Chunk

Read the active spec (ask me which one if not clear from SCRATCHPAD.md).
Identify the next unchecked item in the Implementation Checklist.
State it: "Building Chunk [N]: [Description]"

Ask me: "Confirm this is the right chunk, or redirect me."
Wait for confirmation.

---

## Step 2 — Pre-Build Check

Before writing a single line of code, state:

**Files I will touch:** [list every file — create/modify/delete]
**Files I will NOT touch:** [explicit boundary — what is adjacent but out of scope]
**Estimated output:** [rough sense of what this produces — 1 file, 3 functions, etc.]

If anything about this chunk seems to require touching files outside the spec's File Map,
STOP and flag it: "This chunk may require touching [file] which is not in the spec.
Do you want to expand scope or find an alternative approach?"

---

## Step 3 — Build

Implement the chunk. Rules that apply:

- **Minimal.** Build exactly what the spec describes. No extras.
- **No new dependencies** without explicit approval (check CLAUDE.md).
- **No new abstractions** that weren't in the spec.
- **One file at a time** where possible — easier to review.
- **Consistent with existing patterns** in the codebase — look before introducing new ones.

If you encounter something unexpected mid-build (a dependency that's missing,
an interface that's different than expected, a conflict with existing code),
STOP and report: "Blocked: [what was found]. Options: [list options]. Your call."

---

## Step 4 — Post-Build Report

After completing the chunk, output:

```
## Chunk [N] Complete

Files created:   [list]
Files modified:  [list]
Files deleted:   [list]

What was built:  [2-3 sentences]
What was NOT built: [anything deferred from this chunk]
Hooks will run:  type-check, lint [via post-edit hook]

Ready to commit? Suggested message:
"feat: [chunk description] — per spec/[name].md chunk [N]"

Type /verify to interrogate before committing.
Or confirm commit and I'll mark chunk [N] ✓ in the spec.
```

---

## Step 5 — Spec Update

After confirmed commit:
- Mark chunk [N] as ✓ in the spec's Implementation Checklist
- Update spec's **Last Updated** date and **Sessions** count
- Say: "Chunk [N] committed. Next: Chunk [N+1] — [description]. Type /chunk to continue."
