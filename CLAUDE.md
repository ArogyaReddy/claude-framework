# CLAUDE.md — Minimal Project Policy (React + Vite)

This file is the persistent policy for this repository.

## Stack

- Runtime: Node 20+
- UI: React 18
- Build tool: Vite
- Language: JavaScript (ES modules)
- Tests: Vitest preferred, Playwright for end-to-end when added

## Session Startup

At the start of every session, silently read in this order:
1. `CLAUDE.md` (this file) — rules and policies
2. `PROFILE.md` — who the user is, their style, their current focus
3. `SESSION_LOG.md` — what happened last session, what is pending
4. `.claude/history/decisions.md` — past decisions to check before making new ones

Do not announce that you have read them. Just use the context.

## Session Closure

When the user says "close the session", invoke `Use session-closer skill.`
This updates SESSION_LOG.md and all `.claude/history/` knowledge files.

## Always-Apply Rules

- Implement only what the prompt asks.
- Touch only named files. If another file is required, stop and report.
- No dependency installs unless explicitly requested.
- No refactors outside requested scope.
- No commits or pushes unless explicitly requested.

## Execution Protocol

- Analyze requested scope before editing files.
- Use a plan before executing multi-file or hard-to-reverse changes.
- Before any destructive cleanup, create a timestamped backup of non-identical files.
- Validate outcomes after execution (existence checks, diff checks, and error checks).

## Cleanup Policy

- For duplicate structures, compare by relative path and file hash.
- Classify duplicates as exact duplicates or divergent duplicates before deletion.
- Remove exact duplicates directly.
- Backup divergent duplicates, then remove only after backup inventory is confirmed.
- Always report backup path and deleted paths.

## Output Rules (Token Efficiency Priority)

**Default to MINIMAL output:**
- ✅ Bullet points over prose
- ✅ File paths and line numbers over long explanations
- ✅ Summary tables over paragraphs
- ✅ Action results over process descriptions
- ❌ No emojis unless explicitly requested
- ❌ No narration of tool use ("Let me read...", "I'll now...")
- ❌ No celebratory language unless warranted

**For code changes:**
```
✅ Changed Files:
  - path/to/file.js:45 - Added error handling
  - path/to/other.js:12 - Updated import

❌ Wordy version:
"I've successfully modified the authentication system by reading the login file,
analyzing the code, and then making the following changes..."
```

**For multi-file work:**
```
Summary:
- Files changed: 3
- Lines modified: ~45
- Key changes:
  • auth/login.js:23 - JWT validation added
  • middleware/auth.js:67 - Token expiry check
  • config/jwt.js - New config (created)
```

## Output Format Defaults (System-Level)

- **Default format:** Bullet lists for everything except when prose is explicitly better
- **For structured tasks:** Use `##` sections with bullet point content
- **Length default:** As short as correct allows (target: <300 words unless complex)
- **Override tags:** `<format>`, `<length>`, `<sections>` override all defaults
- **Change summaries:** Always use file:line format

## Token Efficiency Protocol

**Every response should:**
1. Lead with the answer/result (not the process)
2. Use bullet points by default
3. List files changed with paths (file:line format)
4. Avoid repetition and filler phrases
5. Skip process narration ("I will now...", "Let me...")

**Template for code changes:**
```
Changed:
- file.js:45 - What changed
- other.js:12 - What changed

Impact: [One line summary]
```

**Template for analysis:**
```
Findings:
- [Key finding 1]
- [Key finding 2]

Recommendation: [Action]
```

## Output Contracts

- **Audits:** Findings first (severity-ordered), bullet format
- **Cleanup tasks:** Backup path, deleted paths, verification (bullet format)
- **Conversion tasks:** Output path + one-line run instruction
- **Code edits:** File:line changes + impact summary (bullet format)
- **Errors:** Error message + fix suggestion (bullet format, no preamble)

## Project Conventions

- Component files: PascalCase (example: `Header.jsx`).
- Utility files: lowercase when practical.
- App entry points stay in `src/` (`main.jsx`, `App.jsx`).
- Prefer local component-level state unless shared state is clearly required.

## Environment Policy

- Use Windows-first commands and script paths for this repository.
- Prefer PowerShell hook paths in local configuration.
- If a browser-usable deliverable is requested, provide a standalone HTML option.

## First-Time Setup

- Run `.\setup.ps1` (Windows) or `./setup.sh` (Unix) from the framework root.
- The installer prompts for profile info, creates all config files, wires hooks, and runs verification.
- Safe to re-run — never overwrites existing files.
- Flags: `-SkipProfile` to skip profile questions, `-DryRun` to preview without writing.

## Core Skills (Use By Name)

- `skills/project-scan.md` — scan any project and produce a gap analysis report.
- `skills/framework-apply.md` — install framework components into a target project.
- `skills/healthcheck.md` — 12-point diagnostic for framework health (PASS/WARN/FAIL).
- `skills/decision-log.md` — structured Architecture Decision Record for important decisions.
- `skills/minimal-output.md` for code-only output.
- `skills/debug-first.md` for bug diagnosis before fixing.
- `skills/scope-guard.md` to prevent scope creep.
- `skills/jsx-to-standalone-html.md` for JSX-to-browser conversion tasks.
- `skills/duplicate-structure-audit.md` for duplicate folder/file audits.
- `skills/safe-cleanup-with-backup.md` for destructive cleanup with safety rails.
- `skills/output-control.md` for explicit length and format constraints using XML tags.
- `skills/structured-response.md` for section-divided, labeled structured output.
- `skills/followup-refine.md` for two-step depth-then-condense pattern.
- `skills/session-closer.md` — invoked by "close the session" to capture knowledge and update history.

# ─────────────────────────────────────────────────────────────────
# MEMORY FRAMEWORK — Paste this block into your existing CLAUDE.md
# ─────────────────────────────────────────────────────────────────

## Memory System (Non-Negotiable)

This project uses a three-file memory system. You MUST honour it.

### The Three Files

| File | Purpose | When to Read | When to Write |
|------|---------|--------------|---------------|
| SCRATCHPAD.md | Current session state — rolling | Session start (always) | Session end via /wrap |
| DECISIONS.md | Permanent decision log — never truncated | When making architectural decisions | Via /decide or /wrap |
| SESSIONS.md | Lightweight audit trail | Never at session start (noise) | Via /wrap only |

### Session Start Protocol (Every Single Session)

When the session opens OR when /resume is called:
1. Read SCRATCHPAD.md fully
2. Scan DECISIONS.md for entries relevant to current focus
3. Output a Session Brief (see /resume command for format)
4. Wait for confirmation before starting work

Do not start work without completing this protocol.
The cost is ~600 tokens. It saves 3,000-6,000 tokens of reconstruction.

### Session End Protocol

When /wrap is called (or session ends):
1. Update SCRATCHPAD.md — replace Current Focus and Resume Here, append failures/questions
2. Append new decisions to DECISIONS.md (if any were made)
3. Append one row to SESSIONS.md
4. Surface any CLAUDE.md suggestions — do NOT auto-edit CLAUDE.md

### Mid-Session Rules

- When ANY architectural or significant decision is made → immediately run /decide
- Do not wait for /wrap to capture decisions — context degrades fast
- If SCRATCHPAD.md exceeds 300 lines → summarise old "Failed" entries before appending
- If a DECISIONS.md entry is being contradicted → flag it before proceeding:
  "This conflicts with [DECISION-XXX]. Confirm you want to proceed differently."

### Commands Available

| Command | Use |
|---------|-----|
| /resume | Session start — read memory, output brief, wait for confirmation |
| /wrap | Session end — update all memory files |
| /decide | Mid-session — log a decision immediately to DECISIONS.md |

# ─────────────────────────────────────────────────────────────────

# ─────────────────────────────────────────────────────────────────────────────
# PHASE FRAMEWORK — Paste this block into your existing CLAUDE.md
# Works alongside the Memory Framework block (paste after it)
# ─────────────────────────────────────────────────────────────────────────────

## 5-Phase Development Protocol

Every non-trivial feature follows this sequence. Do not skip phases.
"Non-trivial" means: touches more than 2 files, or could have wrong architectural decisions.

| Phase | Command | What Happens | When Done |
|-------|---------|--------------|-----------|
| 1 · Plan | /plan | Architecture agreed, decisions resolved | Confirmed plan exists |
| 2 · Spec | /spec | plan.md written at /specs/[name].md | Spec file created |
| 3 · Build | /chunk | One chunk built, hooks run, commit | Chunk committed |
| 4 · Verify | /verify | Output interrogated before commit | Risk level assessed |
| 5 · Update | /update | CLAUDE.md improved, memory wrapped | Session closed clean |

## Active Specs
<!-- Managed by /spec and /update commands -->
<!-- Format: - /specs/[name].md — [status] -->

[No active specs yet]

## Phase Rules (Non-Negotiable)

- **Never build during /plan.** Planning phase is architecture-only. No code.
- **Never skip /spec for multi-file features.** "I'll remember the plan" is not a spec.
- **One /chunk at a time.** Build → verify → commit → next chunk. Never batch multiple chunks without committing.
- **Always run /verify before committing a chunk.** Post-edit hooks catch syntax. /verify catches logic.
- **Always run /update before ending a session with meaningful work.** Every correction should become a rule.

## Hooks Active
- `post-edit.sh` — type check + lint + format on every file Claude writes
- `pre-commit.sh` — type check + related tests before every commit

## Spec Protocol
- Active specs are read at session start (listed above under Active Specs)
- Locked decisions in specs are honoured without re-litigation
- Scope boundaries in specs are respected — flag before touching out-of-scope files
- Specs are updated (checklist, dates, session count) at each /chunk completion

## Agent Reviews
- Available via /agent-review for high-stakes features
- Requires Claude Code CLI (claude -p)
- Used for: security code, complex business logic, anything going to production fast

# ─────────────────────────────────────────────────────────────────────────────
