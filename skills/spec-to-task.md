---
name: spec-to-task
description: Converts a spec or feature brief into an ordered, dependency-sequenced task list.
invocation: manual
agent: true
---

# Skill: spec-to-task

## Trigger
Invoke at the start of any feature that has a spec file.
Say: "Use spec-to-task skill on specs/[feature].md"

## Purpose
Converts a spec section into a sequenced, scoped task list.
Ensures consistent task granularity across the team.
Prevents big-bang implementation attempts.

---

## Standing Instructions

Given a spec file or section:

### Rules for Task Generation
1. One task per file affected — never bundle multiple files into one task.
2. Each task must state: file path, what changes, what must not change.
3. Tasks must be sequenced by dependency — no task depends on an incomplete task above it.
4. No task should touch more than one concern (one function, one component, one schema change).
5. If a task requires a decision or has ambiguity, flag it — do not assume.
6. Do not generate tasks for things not described in the spec.

### What to Ignore
- Do not generate tasks for testing unless the spec explicitly requires it.
- Do not generate tasks for documentation.
- Do not add "nice to have" tasks.

---

## Output Format

```
FEATURE: [feature name]
SPEC:     [spec file path]
TASKS:

[ ] Task 1
    File:       src/[path]
    Change:     [one sentence — what changes]
    Preserve:   [what must not change]
    Depends on: none

[ ] Task 2
    File:       src/[path]
    Change:     [one sentence]
    Preserve:   [what must not change]
    Depends on: Task 1

[ ] Task N
    ...

FLAGS: [any ambiguities or decisions needed before starting]
```

---

## After Task List is Confirmed

Work through tasks one at a time.
Do not start Task N+1 until Task N is confirmed complete.
Use scope-guard rules for each task.
