# ARCHITECTURE.md — Claude Code Master Framework

## Overview

The Claude Code Master Framework is a **file-based runtime layer** for Claude Code. It operates entirely through Claude's context window — no servers, no databases, no build steps. Its architecture is deliberately minimal: files are loaded, Claude reads them, behavior changes.

---

## C4 Context Diagram

```mermaid
C4Context
  Person(dev, "Developer / Engineer", "Uses Claude Code daily for coding tasks")
  System(framework, "Claude Code Master Framework", "Persistent context layer — CLAUDE.md, skills, hooks, memory files")
  System_Ext(claude_code, "Claude Code CLI", "Anthropic's agentic coding tool")
  System_Ext(project, "Target Project", "Any code repository the developer is working in")
  System_Ext(hooks, "Hook Scripts", "PowerShell/Bash automation — pre-tool, post-tool, pre-compact")

  Rel(dev, claude_code, "Opens terminal session")
  Rel(claude_code, framework, "Reads CLAUDE.md, skills, memory files into context")
  Rel(claude_code, hooks, "Triggers on tool use events")
  Rel(framework, project, "Copied to / applied to")
  Rel(dev, framework, "Configures PROFILE.md, CLAUDE.md, skills")
```

---

## Component Architecture

```mermaid
graph TD
  A[Claude Code CLI opens] --> B[Loads ~/.claude/CLAUDE.md — Global Policy]
  A --> C[Loads ./CLAUDE.md — Project Policy]
  B --> D[Session Startup Protocol]
  C --> D
  D --> E[Reads PROFILE.md — Developer Identity]
  D --> F[Reads SESSION_LOG.md — Last Session State]
  D --> G[Reads Active Specs — /specs/*.md]

  H[Developer invokes skill] --> I{Skill type}
  I -->|agent: false| J[Inject skill into current context]
  I -->|agent: true| K[Spawn Claude Code subagent]

  L[Developer types prompt] --> M[4-Element Prompt: SCOPE + ACTION + FENCE + OUTPUT]
  M --> N[Claude executes within policy constraints]
  N --> O{Hook fires}
  O -->|pre-tool-use| P[Block dangerous commands]
  O -->|post-tool-use| Q[Log tool outcomes to .claude/logs/]
  O -->|pre-compact| R[Snapshot current state]

  N --> S[End of session: /wrap]
  S --> T[Claude writes SESSION_LOG.md]
  S --> U[Appends to DECISIONS.md]
  S --> V[Appends row to SESSIONS.md]
```

---

## 5-Phase Development Sequence

```mermaid
sequenceDiagram
  participant D as Developer
  participant C as Claude Code
  participant F as Framework Files
  participant H as Hooks

  D->>C: Opens new session
  C->>F: Reads CLAUDE.md (global + project)
  C->>F: Reads PROFILE.md
  C->>F: Reads SESSION_LOG.md
  C-->>D: Session Brief (last state, active specs)

  D->>C: /plan — architect the feature
  C-->>D: Architecture decisions, no code written

  D->>C: /spec — write the spec
  C->>F: Writes specs/[feature].md
  C-->>D: Spec confirmed

  loop Each chunk
    D->>C: /chunk — build one piece
    H->>C: pre-tool-use fires — validates action
    C->>F: Edits files within scope
    H->>C: post-tool-use fires — logs outcome
    D->>C: /verify — interrogate output
    C-->>D: Risk assessment, PASS or FLAG
  end

  D->>C: /wrap — close session
  C->>F: Writes SESSION_LOG.md
  C->>F: Appends to DECISIONS.md
  C-->>D: Session closed, context ready for tomorrow
```

---

## Architectural Decision Records

### ADR-001: File-Based Memory Over API/Database
- **Date**: March 2026
- **Status**: Accepted
- **Context**: Claude has no persistent memory between sessions. Options considered: external vector DB, Anthropic Projects feature, file-based text files.
- **Decision**: Three-file memory system (SCRATCHPAD.md, DECISIONS.md, SESSIONS.md) written to disk by Claude at session end.
- **Consequences**: Memory is durable, inspectable, and zero-cost. Requires discipline — developer must say "Close the session." every time.
- **Alternatives Rejected**: Vector DB (overkill for text summaries, adds infrastructure); Anthropic Projects (limited control over what gets stored).

---

### ADR-002: Skill Invocation by Name, Not Automation
- **Date**: March 2026
- **Status**: Accepted
- **Context**: Considered auto-loading all skills at session start vs. explicit invocation.
- **Decision**: Skills are invoked explicitly: `Use debug-first skill.` Each loads only when needed.
- **Consequences**: Zero token cost until skill is needed. Requires developer to remember skill names — mitigated by README skills quick-reference table.
- **Alternatives Rejected**: Auto-load all skills (would consume 5,000–15,000 tokens per session on skills not needed).

---

### ADR-003: Three Hook Points — Pre-Tool, Post-Tool, Pre-Compact
- **Date**: March 2026
- **Status**: Accepted
- **Context**: Needed automated safety enforcement that couldn't be bypassed by Claude's context drift.
- **Decision**: Three PowerShell hook scripts wired in `~/.claude/settings.json`. They fire at the Claude Code app layer — not in Claude's context — so CLAUDE.md rules can't override them.
- **Consequences**: `rm -rf`, `DROP TABLE`, `git push --force`, `.env` writes, and `npm install` are blocked at the app level regardless of what Claude wants to do.
- **Alternatives Rejected**: CLAUDE.md-only rules (Claude follows them but they are not enforced mechanically); no hooks (dangerous for agentic long-running sessions).

---

### ADR-004: Two Skill Directories — `skills/` and `.claude/skills/`
- **Date**: March 2026
- **Status**: Accepted
- **Context**: Some skills are universal (copy to every project); some are specific to this framework repo.
- **Decision**: `skills/` = template skills, copied to new projects via `framework-apply`. `.claude/skills/` = framework-repo-only skills (batch, simplify, problem-solver).
- **Consequences**: New projects only receive operational skills. Framework-level introspection skills don't pollute target projects.
- **Alternatives Rejected**: Single directory (would copy framework-management skills into unrelated projects).

---

### ADR-005: 5-Phase Protocol Enforced by Naming, Not Tooling
- **Date**: March 2026
- **Status**: Accepted
- **Context**: Phase gates (/plan, /spec, /chunk, /verify, /update) could have been implemented as Claude Code slash commands or hooks.
- **Decision**: Phases are defined in CLAUDE.md as behavioral rules. Developer invokes with natural language commands.
- **Consequences**: Zero tooling overhead. Any session inheriting CLAUDE.md gets the protocol. Risk: developer can skip phases — mitigated by explicit rule "Never build during /plan."
- **Alternatives Rejected**: Custom slash commands (requires CLI extension complexity); hook-enforced phases (hooks can't reason about semantic intent of a prompt).

---

### ADR-006: Windows-First Hook Paths with Unix Fallback
- **Date**: March 2026
- **Status**: Accepted
- **Context**: Framework author works on Windows. Hook scripts written as PowerShell `.ps1` with Bash equivalents.
- **Decision**: CLAUDE.md declares "Windows-first commands and script paths." `setup.ps1` / `setup.sh` are provided for both platforms.
- **Consequences**: Works natively on developer's machine. Unix teams must run `setup.sh` and verify hook paths.
- **Alternatives Rejected**: Unix-only (excludes the author's actual environment); cross-platform JS scripts (adds Node.js dependency to what should be a zero-dependency framework).
