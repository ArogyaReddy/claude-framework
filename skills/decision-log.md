---
name: decision-log
description: Writes a structured decision entry (date, decision, reason, alternatives) to decisions.md.
invocation: manual
agent: false
---

# Skill: decision-log

## Trigger
Say: `Use decision-log skill.`
Or: `Log this decision: [brief description]`

## Purpose
Capture a formal Architecture Decision Record (ADR) for any significant
architectural, tooling, or approach decision made during a session.

Keeps decisions findable, traceable, and reversible.
Prevents re-litigating settled questions in future sessions.

---

## When to Use

Use this skill when you've decided:
- Which architecture, pattern, or design to use for a feature
- Which library, tool, or framework to adopt or reject
- How to handle a recurring problem (error handling, state management, data flow)
- What NOT to do and why
- A trade-off you've consciously accepted

Do not use for small implementation choices (variable names, minor formatting).
Use for anything you'd want a new team member to read before touching that area.

---

## What Claude Does

1. Ask (if not already provided):
   - **"What was decided?"** — one sentence
   - **"Why was this chosen over alternatives?"** — the key reason
   - **"What alternatives were rejected, and why?"** — even "we didn't consider any" is valid
   - **"What does this apply to?"** — file, feature, module, or "Global"

2. Produce a structured ADR block ready to append to `.claude/history/decisions.md`.

3. Optionally produce a standalone ADR file at `.claude/decisions/NNN-slug.md`
   if the decision is significant enough to deserve its own file.
   Ask: *"Is this a major decision worth its own file, or an append to decisions.md?"*

---

## Output Format

### Append block for `.claude/history/decisions.md`:

```markdown
### [YYYY-MM-DD] — [Decision title, 5–8 words]
- **Decision:** [One sentence — what was chosen]
- **Reason:** [Why this over the alternatives — the core rationale]
- **Alternatives rejected:** [What else was considered — name + one-line reason each. Or "None considered."]
- **Applies to:** [Feature / File(s) / Module / Global]
- **Reversibility:** [Easy / Moderate / Hard — how hard to undo if wrong]
```

---

### Standalone ADR file (`.claude/decisions/NNN-slug.md`) — only if major:

```markdown
# ADR-{NNN}: {Title}

**Date:** YYYY-MM-DD
**Status:** Accepted
**Applies to:** {scope}

## Context
{1–2 sentences: what problem or question prompted this decision}

## Decision
{1–2 sentences: what was decided}

## Rationale
{2–4 sentences: why this approach over alternatives — the core reasoning}

## Alternatives Considered

| Alternative | Why Rejected |
|---|---|
| {Option A} | {One-line reason} |
| {Option B} | {One-line reason} |

## Consequences
- **Good:** {what this enables or improves}
- **Trade-off:** {what this costs or constrains}
- **Reversibility:** {Easy / Moderate / Hard}

## Related Decisions
- {Link to other ADR if applicable, or "None"}
```

---

## Numbering Convention (if using standalone files)

Check `.claude/decisions/` for the highest existing NNN.
Increment by 1. If no files exist, start at 001.

Example: if `002-use-zustand.md` exists → next is `003-{slug}.md`

---

## Examples

### Simple append entry:
```markdown
### [2026-03-16] — Use TaskStatusManager for all task state
- **Decision:** All task status changes route through TaskStatusManager — no direct state mutations.
- **Reason:** Direct mutations caused the "status not updating" bug and made state unpredictable.
- **Alternatives rejected:** Local component state (too fragmented); Redux slice (unnecessary complexity).
- **Applies to:** ADP ROLL — TaskService.js, E-Sign, Acknowledge features.
- **Reversibility:** Moderate — would require touching every task-related component.
```

### Standalone ADR:
```markdown
# ADR-001: Use filesystem as the only persistence layer

**Date:** 2026-03-16
**Status:** Accepted
**Applies to:** Global — entire claude-framework

## Context
The framework needed a way to persist session knowledge, decisions, and
configuration across Claude Code sessions without adding external dependencies.

## Decision
All persistent state is stored in plain Markdown files on the local filesystem.
No database, no external service, no API.

## Rationale
Claude reads Markdown natively. Files are version-controllable, human-readable,
and require zero infrastructure. The cost of setup and maintenance of any
external system outweighs the benefits at this scale.

## Alternatives Considered

| Alternative | Why Rejected |
|---|---|
| SQLite database | Requires tooling, harder to inspect, no native Claude integration |
| External API (Notion, etc.) | Network dependency, auth overhead, not offline-capable |
| JSON files | Less readable than Markdown, no native Claude advantage |

## Consequences
- **Good:** Zero infrastructure, instant setup on any machine, human-readable.
- **Trade-off:** No query capability — finding specific decisions requires grep or manual scan.
- **Reversibility:** Easy — migrate files to any other format at any time.

## Related Decisions
- None
```
