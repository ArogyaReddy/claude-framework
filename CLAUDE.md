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

## Output Rules

- Keep responses concise and direct.
- Use short explanations unless asked for detail.
- For code edits, return changed files and key impact only.

## Output Format Defaults (System-Level)

- Default format: bullet list for enumerations, prose for explanations — never both unsolicited.
- For structured tasks (comparisons, audits, specs, onboarding), use labeled `##` sections.
- Length default: as short as correct allows. Expand only when explicitly asked.
- When a `<format>` or `<length>` tag appears in a prompt, it overrides all defaults here.
- When a `<sections>` tag appears, divide the full response into those labeled sections only.

## Output Contracts

- For audits: report findings first, ordered by severity.
- For cleanup tasks: report backup inventory, deleted paths, and verification checks.
- For conversion tasks: return runnable artifact path and shortest run/open instruction.

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
