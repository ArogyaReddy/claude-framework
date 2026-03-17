---
name: debug-first
description: Diagnose a bug — identifies cause, file, and line before any fix. Use on any error or unexpected behavior.
invocation: manual
agent: false
---

# Skill: debug-first

## Trigger
Say: Use debug-first skill.

## Purpose
Diagnose before editing to avoid wrong fixes.

## Steps

1. State expected behavior in one line.
2. State actual behavior in one line.
3. Point to likely cause with file and line.
4. State minimum fix scope.
5. Stop and wait for confirmation before editing.

## Output Template

```text
EXPECTS: ...
ACTUAL: ...
CAUSE: path/file:line ...
FIX SCOPE: ...
STATUS: Waiting for approval to implement.
```
