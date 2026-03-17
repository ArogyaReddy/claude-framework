---
name: scope-guard
description: Prevents edits outside explicit task boundaries. Use before any multi-file or risky change.
invocation: manual
agent: false
---

# Skill: scope-guard

## Trigger
Say: Use scope-guard skill.

## Purpose
Prevent edits outside explicit task boundaries.

## Rules

- Change only named files and symbols.
- No drive-by refactors.
- No new files or dependencies unless requested.
- If blocked by out-of-scope changes, stop and report.

## Blocker Template

```text
SCOPE BLOCKER
Required change: path/file:line
Reason: ...
Need approval to proceed.
```
