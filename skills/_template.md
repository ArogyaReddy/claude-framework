# Skill: [skill-name]

<!--
FRONTMATTER (optional — add between --- delimiters if needed)

---
name: skill-name
description: One sentence — what this skill does and when to use it.
invocation: manual
agent: false
---

FRONTMATTER FIELDS:

name        — machine-readable identifier (kebab-case)
description — shown in skill discovery; used by subagent routing
invocation  — manual (user-invoked only) | auto (Claude may invoke it)
agent       — false = runs in main context (behaviour skills, scope guards)
              true  = spawns a subagent (analysis, review, research skills)
              Use agent: true for skills that read many files — protects context window.

WHEN TO USE agent: true:
  - code-review: reads full files to find violations
  - debug-first: traces through multiple files
  - duplicate-structure-audit: scans entire codebase

WHEN TO USE agent: false:
  - scope-guard: modifies Claude's in-session behaviour
  - minimal-output: changes how Claude formats responses
  - output-control: applies format rules in-context
-->

---

## Trigger

Say: `Use [skill-name] skill.`

---

## Purpose

[One sentence — what problem this skill solves.]

---

## Rules

- [Rule 1]
- [Rule 2]
- [Rule 3]

---

## Output Format

[What Claude returns when this skill is active. Be specific: code only / table / one sentence per finding / etc.]

---

## Example Invocation

```
Use [skill-name] skill on [target file or scope].
```
