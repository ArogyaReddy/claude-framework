---
name: healthcheck
description: Audits current project for missing or misconfigured framework components.
invocation: manual
agent: true
---

# Skill: healthcheck

## Trigger
Say: `Use healthcheck skill.`

## Purpose
Run a structured diagnostic on the framework's own health.
Reports `[PASS]` / `[WARN]` / `[FAIL]` per check with remediation hints.
No check blocks another — all 12 run independently.

---

## Rules

- Run every check even if earlier ones fail.
- Never modify any file — read-only diagnostic only.
- `[FAIL]` = broken, must fix before framework works correctly.
- `[WARN]` = degraded, framework still works but at reduced effectiveness.
- `[PASS]` = healthy.

---

## The 12 Checks

### Check 1 — PROFILE.md filled in
Read `PROFILE.md`. Check if it contains any unfilled placeholders:
`[Your name]`, `[e.g.`, `[Add anything`
- If ANY placeholder found → `[FAIL]` PROFILE.md not configured. Run: fill in your name, role, and stack.
- If clean → `[PASS]`

### Check 2 — SESSION_LOG.md exists
Check if `SESSION_LOG.md` exists in project root.
- Missing → `[FAIL]` No session log. Run session-closer at end of next session to create it.
- Exists but empty → `[WARN]` SESSION_LOG.md exists but has no entries yet.
- Exists with entries → `[PASS]`

### Check 3 — SESSION_LOG.md freshness
Read SESSION_LOG.md. Find the date of the most recent `### YYYY-MM-DD` entry.
Compare against today's date.
- No entries → skip (covered by Check 2)
- Last entry > 7 days ago → `[WARN]` SESSION_LOG.md stale (last entry: {date}). Close sessions with "close the session".
- Last entry > 2 days ago → `[WARN]` SESSION_LOG.md not updated recently (last entry: {date}).
- Recent → `[PASS]`

### Check 4 — .claude/history/ exists and populated
Check `.claude/history/decisions.md`, `.claude/history/learnings.md`, `.claude/history/patterns.md`.
- Directory missing → `[FAIL]` .claude/history/ not initialised. Run framework-apply or create manually.
- Any file missing → `[WARN]` Missing: {filename}. Session-closer will create it on next close.
- All 3 present → `[PASS]`

### Check 5 — skills/ directory populated
List `skills/` directory. Count .md files.
- Directory missing → `[FAIL]` No skills/ directory found.
- Fewer than 5 skills → `[WARN]` Only {N} skills installed. Run project-scan for gap analysis.
- 5 or more skills → `[PASS]` {N} skills installed.

### Check 6 — Core hooks present
Check for existence of:
- `hooks/pre-tool-use.ps1` + `hooks/pre-tool-use.sh`
- `hooks/post-tool-use.ps1` + `hooks/post-tool-use.sh`
- `hooks/pre-compact.ps1` + `hooks/pre-compact.sh`

For each pair:
- Both missing → `[FAIL]` {hook-name} hook scripts missing.
- One of pair missing → `[WARN]` {hook-name}: only {ext} version present.
- Both present → `[PASS]`

### Check 7 — .claude/settings.json exists and hooks wired
Read `.claude/settings.json`.
- File missing → `[FAIL]` No .claude/settings.json — hooks are not registered. Claude safety rails are inactive.
- File exists but no `PreToolUse` entry → `[FAIL]` PreToolUse hook not registered in settings.json.
- File exists but no `PostToolUse` entry → `[WARN]` PostToolUse hook not registered.
- File exists but no `PreCompact` entry → `[WARN]` PreCompact hook not registered.
- All 3 registered → `[PASS]`

### Check 8 — CLAUDE.md has session startup
Read `CLAUDE.md`. Check for `## Session Startup` section.
- Missing → `[WARN]` CLAUDE.md has no Session Startup section. Claude won't auto-read PROFILE.md and SESSION_LOG.md.
- Present → `[PASS]`

### Check 9 — registry/ populated
Check `registry/skills-registry.md`, `registry/hooks-registry.md`, `registry/patterns-registry.md`.
- All missing → `[WARN]` registry/ not initialised. project-scan and framework-apply work at reduced accuracy.
- Some missing → `[WARN]` Missing: {filenames}.
- All present → `[PASS]`

### Check 10 — tools/ scanner present
Check `tools/scan-project.ps1` and `tools/scan-project.sh`.
- Both missing → `[WARN]` Scanner scripts missing. project-scan skill cannot collect raw data.
- One missing → `[WARN]` Only {ext} scanner present.
- Both present → `[PASS]`

### Check 11 — .claude/archive/ snapshot health
Check `.claude/archive/` directory.
- Directory missing → `[WARN]` No session archives yet. Snapshots are written by session-closer on first close.
- Present but empty → `[WARN]` Archive directory exists but no snapshots yet.
- Has snapshots → count them. If > 10 → `[WARN]` Archive has {N} snapshots (cap is 10). Session-closer prunes on next close.
- Has 1–10 snapshots → `[PASS]` {N} snapshots in archive.

### Check 12 — No orphan placeholder files
Check for any `.md` file in `skills/` that still contains `[FILL IN]` or `[YOUR` or `TODO`.
- Any found → `[WARN]` Placeholder text found in: {filenames}. These skills may not work correctly.
- None found → `[PASS]`

---

## Output Format

```
FRAMEWORK HEALTHCHECK
═══════════════════════════════════════════════════
Project: [project root path]
Date:    YYYY-MM-DD
─────────────────────────────────────────────────────
 1. PROFILE.md configured          [PASS/WARN/FAIL]
 2. SESSION_LOG.md exists          [PASS/WARN/FAIL]
 3. SESSION_LOG.md freshness       [PASS/WARN/FAIL]
 4. .claude/history/ populated     [PASS/WARN/FAIL]
 5. skills/ populated              [PASS/WARN/FAIL]
 6. Hook scripts present           [PASS/WARN/FAIL]
 7. settings.json wired            [PASS/WARN/FAIL]
 8. CLAUDE.md session startup      [PASS/WARN/FAIL]
 9. registry/ populated            [PASS/WARN/FAIL]
10. tools/ scanner present         [PASS/WARN/FAIL]
11. Archive snapshot health        [PASS/WARN/FAIL]
12. No orphan placeholders         [PASS/WARN/FAIL]
─────────────────────────────────────────────────────
PASS: N   WARN: N   FAIL: N
═══════════════════════════════════════════════════

FAILURES (must fix):
  [1] PROFILE.md not configured — fill in Name, Role, Stack before using framework.
  [7] .claude/settings.json missing — hooks are inactive. See registry/hooks-registry.md.

WARNINGS (should fix):
  [3] SESSION_LOG.md stale — last entry 2026-03-10. Say "close the session" after each work block.

All clear? Run: Use project-scan skill. to check for missing components.
```
