---
name: minimal-output
description: Strips all narration from responses. Returns code or output only — no commentary, no preamble.
invocation: manual
agent: false
---

# Skill: minimal-output

## Trigger
Say: Use minimal-output skill.

## Purpose
Return the smallest useful response for implementation tasks.

## Rules

- No preamble.
- No closing summary.
- Code first.
- Add comments only for non-obvious logic.
- If no code is required, answer in 1-3 short lines.

## Format

```text
[path/to/file]
```jsx
// changed code
```
