---
name: structured-response
description: Forces labeled, section-divided output for scannable multi-part responses.
invocation: manual
agent: false
---

# Skill: structured-response

## Trigger
Say: `Use structured-response skill.`
Then specify the section labels you need.

## Purpose
Force Claude to divide output into labeled, self-contained sections.
Useful for specs, reports, comparisons, and onboarding docs where
a single prose block loses clarity and scannability.

Implements Technique 2 (Implied Format) and Technique 3 (List Structure)
from the Managing Claude Output Length and Form guide.

## Rules

- Output must be divided into labeled `##` sections — no freeform block of prose unless a section explicitly calls for it.
- Each section must be self-contained. No cross-referencing between sections.
- No preamble before the first section. No closing summary after the last.
- Every section must have content. Do not output an empty section.

## Prompt Structure

```xml
<role>[who Claude is acting as]</role>
<task>[what to produce]</task>
<response_format>
  <sections>[comma-separated list of section names]</sections>
  <section_length>[sentence count or word limit per section]</section_length>
</response_format>
```

## Examples

### Engineering comparison

```xml
<role>Staff engineer</role>
<task>Compare REST and GraphQL for a mobile app backend.</task>
<response_format>
  <sections>Overview, Pros, Cons, Best Fit</sections>
  <section_length>2–3 sentences per section</section_length>
</response_format>
```

### New developer onboarding

```xml
<role>Technical lead</role>
<task>Summarise the ADP ROLL project for a new developer joining the team.</task>
<response_format>
  <sections>What It Is, Key Features, Tech Stack, First Things to Know</sections>
  <section_length>3 sentences per section</section_length>
</response_format>
```

### Feature decision brief

```xml
<role>Product engineer</role>
<task>Evaluate adding e-signature support to the employee onboarding flow.</task>
<response_format>
  <sections>Problem, Proposed Solution, Trade-offs, Recommendation</sections>
  <section_length>2 sentences per section</section_length>
</response_format>
```

### Code audit summary

```xml
<role>Senior developer</role>
<task>Audit src/tasks/TaskService.js for correctness, performance, and security.</task>
<response_format>
  <sections>Correctness Issues, Performance Issues, Security Issues, Summary</sections>
  <section_length>Bullet list per section, one issue per bullet</section_length>
</response_format>
```

## When to Use

- Onboarding docs — new team members need scannable sections, not walls of text.
- Decision briefs — present context, options, and recommendation in distinct blocks.
- Feature comparisons — parallel structure makes trade-offs immediately visible.
- Code or system audits — categorise findings by type rather than by file.
- Any prompt where the answer has clearly distinct sub-topics.
