---
name: session-closer
description: Writes SESSION_LOG.md and archives session knowledge. Trigger by saying "Close the session."
invocation: phrase
agent: false
---

# Skill: session-closer

## Trigger
Say: `close the session`

## Purpose
End-of-session knowledge capture. Converts raw session activity into structured,
persistent knowledge that every future session can use.
This is the mechanism that makes the framework compound over time.

Without this, each session resets to zero.
With this, each session builds on all previous ones.

---

## Pre-flight Check

Before running, verify PROFILE.md is configured:
- Read `PROFILE.md`. If it contains `[Your name]` or any `[placeholder]` text:
  → Warn: *"PROFILE.md has not been filled in. Session knowledge won't be attributed correctly. Fill in your details, then close the session again."*
  → Still run — don't block. Just flag the issue.

---

## What It Does (in order)

1. **Updates SESSION_LOG.md** — prepends a new entry for this session (newest first).
2. **Writes decisions** — any architectural, tooling, or approach decisions made → `.claude/history/decisions.md`.
3. **Writes learnings** — anything new discovered about the codebase, tools, or patterns → `.claude/history/learnings.md`.
4. **Writes patterns** — recurring behaviors noticed (good or bad) → `.claude/history/patterns.md`.
5. **Snapshots history** — archives current `.claude/history/` to `.claude/archive/YYYYMMDD-HHMMSS/`.
6. **Prunes archive** — keeps only the 10 most recent snapshots. Older ones are deleted.
7. **Proposes improvements** — if any workspace improvement was noticed, surface it as a one-line suggestion.

## Rules

- Be specific. Vague entries ("worked on some stuff") are useless.
- Decisions require a reason and rejected alternatives.
- Learnings require the context where they came up and the file/feature they apply to.
- Patterns require a GOOD / BAD / WATCH classification and an action.
- SESSION_LOG.md entries must be 20 lines max. Cut mercilessly.
- Do not invent decisions or learnings that didn't happen. Only log what actually occurred.

## Output Format

Produce the exact text blocks to be prepended/appended. Present each file update clearly labelled.

---

### SESSION_LOG.md — prepend this entry:

```markdown
### [YYYY-MM-DD] — [Session topic in 5 words or less]
- **Done:** [What was completed — one bullet per distinct outcome]
- **Decided:** [Key decisions made, or "None"]
- **Pending:** [What was explicitly deferred or left unfinished, or "None"]
- **Next:** [Recommended first action for the next session]
```

---

### .claude/history/decisions.md — append if any decisions were made:

```markdown
### [YYYY-MM-DD] — [Decision title]
- **Decision:** [What was decided]
- **Reason:** [Why]
- **Alternatives rejected:** [What else was considered and why it lost, or "None"]
- **Applies to:** [Feature / File / Global]
- **Reversibility:** [Easy / Moderate / Hard]
```

---

### .claude/history/learnings.md — append if anything new was learned:

```markdown
### [YYYY-MM-DD] — [Learning title]
- **Learning:** [What was discovered or understood]
- **Context:** [Where this came up — file, feature, or task]
- **Applies to:** [Feature / File / Tool / Global]
```

---

### .claude/history/patterns.md — append if a recurring pattern was noticed:

```markdown
### [Pattern title] — [GOOD | BAD | WATCH]
- **Pattern:** [What keeps happening]
- **First seen:** [YYYY-MM-DD]
- **Last seen:** [YYYY-MM-DD]
- **Action:** [What to do / avoid / watch for next time]
```

---

### Workspace improvement (optional):
> If something about the framework, a skill, or a workflow could be improved, state it in one sentence.

---

### Archive snapshot instruction:

After all blocks above are written, produce this instruction:

> **Archive step:** Snapshot this session's history state:
>
> **Windows (PowerShell):**
> ```powershell
> $ts = Get-Date -Format "yyyyMMdd-HHmmss"
> $dest = ".claude/archive/$ts"
> New-Item -ItemType Directory -Path $dest -Force | Out-Null
> Copy-Item .claude/history/*.md $dest/
> Get-ChildItem .claude/archive/ -Directory | Sort-Object Name -Descending | Select-Object -Skip 10 | Remove-Item -Recurse -Force
> Write-Output "Snapshot saved: $dest"
> ```
>
> **Unix (bash):**
> ```bash
> ts=$(date +%Y%m%d-%H%M%S)
> dest=".claude/archive/$ts"
> mkdir -p "$dest"
> cp .claude/history/*.md "$dest/"
> ls -1d .claude/archive/*/ | sort -r | tail -n +11 | xargs rm -rf
> echo "Snapshot saved: $dest"
> ```

---

## Example

**After a session debugging a React component:**

**SESSION_LOG.md entry:**
```
### [2026-03-17] — Debug task completion status bug
- **Done:** Fixed incorrect task status not updating after e-sign completion in TaskService.js.
- **Decided:** All task status updates must go through the central TaskStatusManager — no direct state mutations.
- **Pending:** Unit tests for the fix not yet written.
- **Next:** Write unit tests for TaskStatusManager.updateStatus() covering e-sign and acknowledge flows.
```

**decisions.md entry:**
```
### [2026-03-17] — Centralise task status updates
- **Decision:** All task status changes must route through TaskStatusManager.
- **Reason:** Direct state mutations caused the "status not updating" bug and made state unpredictable.
- **Alternatives rejected:** Local component state (too fragmented), Redux slice (unnecessary complexity for this scope).
- **Applies to:** ADP ROLL — TaskService, E-Sign, Acknowledge features.
```

**learnings.md entry:**
```
### [2026-03-17] — TaskService.js owns all task lifecycle events
- **Learning:** TaskService.js is the single point of truth for task creation, status, and completion. Any feature touching tasks must import and use it — do not bypass it.
- **Context:** Debugging task status bug in e-sign flow.
- **Applies to:** ADP ROLL — all task-related features.
```
