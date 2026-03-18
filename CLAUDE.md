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
