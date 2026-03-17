---
name: output-control
description: Activates XML tag control (format, length, sections) for precise response shaping.
invocation: manual
agent: false
---

# Skill: output-control

## Trigger
Say: `Use output-control skill.`
Then specify: `length=[N sentences/words/bullets]` and `format=[paragraph|list|table|sections]`

## Purpose
Constrain Claude's response to an exact length and format using explicit XML tags.
Implements Technique 1 (Explicit Instructions) and Technique 3 (List Structure)
from the Managing Claude Output Length and Form guide.

## Rules

- Respond in the format specified in `<format>` tag only.
- Respect the constraint in `<length>` tag exactly — not approximately.
- No content beyond what fits the stated length constraint.
- No preamble before the answer. No closing remarks after.

## Prompt Structure

Wrap your request with these XML tags:

```xml
<role>[who Claude is acting as]</role>
<task>[what you need]</task>
<format>[paragraph | numbered-list | bullet-list | table | labeled-sections]</format>
<length>[exact count: e.g. "3 sentences" | "5 bullets" | "100 words max"]</length>
```

## Examples

### Paragraph with word limit

```xml
<role>Senior software engineer</role>
<task>Explain what React reconciliation does.</task>
<format>Single paragraph</format>
<length>50 words max</length>
```

### Numbered list

```xml
<role>Technical writer</role>
<task>List the steps to set up a Vite project from scratch.</task>
<format>Numbered list</format>
<length>5 items, one sentence each</length>
```

### Markdown table

```xml
<role>Engineering lead</role>
<task>Compare Redux, Zustand, and Context API for state management.</task>
<format>Markdown table — columns: Library | Best For | Drawbacks</format>
<length>3 rows, one phrase per cell</length>
```

### Code summary

```xml
<role>Code reviewer</role>
<task>Summarise what the AuthService class does in src/auth/AuthService.js</task>
<format>Bullet list</format>
<length>3–5 bullets, one sentence each</length>
```

## When to Use

- Generating content with a fixed display space (dashboards, cards, tooltips).
- Producing summaries that must fit a word count.
- Getting structured output that a downstream process will parse.
- Any time a freeform answer would be too long or unpredictable.
