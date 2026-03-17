---
name: followup-refine
description: Produces two versions of a response — technical depth first, plain-English summary second.
invocation: manual
agent: false
---

# Skill: followup-refine

## Trigger
Say: `Use followup-refine skill.`

## Purpose
A two-step prompt pattern: get full depth first, then condense to a
specific length, format, or audience. Avoids starting over when an
initial response is too long, too technical, or misses the target reader.

Implements Technique 4 (Follow-up Questions to Control Response Length)
from the Managing Claude Output Length and Form guide.

## When to Use

- You want a detailed explanation first, then a shorter version for another audience.
- A response was returned but needs to be re-targeted (developer → executive, etc.).
- You want to extract a summary, a one-liner, or structured bullets from a long answer.
- You need the same content in multiple formats without re-explaining the context.

## Pattern

### Step 1 — Full depth (send first)

```xml
<role>[Expert role]</role>
<task>[Full explanation / detailed analysis of topic]</task>
<format>Detailed prose. No length limit. Prioritise completeness over brevity.</format>
```

### Step 2 — Condense (send immediately after Step 1 output)

```xml
Condense your previous response:
<target_audience>[beginner | executive | non-technical | team lead | client]</target_audience>
<length>[1 sentence | 3 bullets | 50 words | one paragraph]</length>
<format>[plain language | tweet | bullet list | executive summary | numbered steps]</format>
```

## Examples

### Distributed systems explanation → product manager summary

**Step 1:**
```xml
<role>Distributed systems engineer</role>
<task>Explain how eventual consistency works in distributed databases, including trade-offs and real-world examples.</task>
<format>Detailed technical prose. No length limit. Include examples.</format>
```

**Step 2:**
```xml
Condense your previous response:
<target_audience>non-technical product manager</target_audience>
<length>3 bullets</length>
<format>plain language, no jargon</format>
```

---

### ADP ROLL feature explanation → stakeholder brief

**Step 1:**
```xml
<role>Senior engineer on the ADP ROLL project</role>
<task>Explain how the acknowledgement tasks and e-sign features work together in the employee onboarding flow.</task>
<format>Detailed technical prose. Cover the data flow, user steps, and any edge cases.</format>
```

**Step 2:**
```xml
Condense your previous response:
<target_audience>non-technical stakeholder</target_audience>
<length>one short paragraph</length>
<format>plain language, business-focused</format>
```

---

### Codebase deep-dive → new developer onboarding bullet

**Step 1:**
```xml
<role>Senior engineer</role>
<task>Explain the full request lifecycle in src/tasks/TaskService.js — from API call to database write.</task>
<format>Detailed technical walkthrough. Reference file paths and function names.</format>
```

**Step 2:**
```xml
Condense your previous response:
<target_audience>junior developer joining the team today</target_audience>
<length>5 bullets</length>
<format>numbered steps, concrete and actionable</format>
```

## Notes

- Step 2 does not re-read the codebase — it only reformats what was returned in Step 1.
- If Step 1's output was incorrect, fix it before running Step 2, or Step 2 will condense wrong information.
- You can run Step 2 multiple times (for different audiences) without re-running Step 1.
