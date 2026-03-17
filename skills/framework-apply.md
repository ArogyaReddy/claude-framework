---
name: framework-apply
description: Installs recommended framework components based on a PROJECT_SCAN.md report.
invocation: manual
agent: true
---

# Skill: framework-apply

## Trigger
```
Use framework-apply skill.
```
Reads `PROJECT_SCAN.md` from the current project for target path and component list.

Or, to install specific components only:
```
Use framework-apply skill. Target: [/path/to/project] Components: scope-guard,debug-first,session-closer
```

## Purpose
Copy chosen framework components (skills, hooks, registries) from the framework
into a target project. Non-destructive — existing files are never overwritten.
The install report tells you exactly what to do manually (CLAUDE.md additions,
settings.json creation).

---

## Non-Negotiable Rules

1. **NEVER overwrite existing files.** If a target file already exists, skip it and log SKIPPED.
2. **NEVER modify CLAUDE.md.** Report exact lines to add — the user adds them.
3. **NEVER create settings.json.** Show the exact JSON — the user creates it.
4. **NEVER install packages or run build commands.**
5. **Report every file: INSTALLED / SKIPPED / FAILED.** No silent operations.
6. **If target path does not exist:** stop and ask before proceeding.

---

## Component Map

Each component name maps to source files in the framework:

| Component name | Source file(s) |
|---|---|
| scope-guard | skills/scope-guard.md |
| debug-first | skills/debug-first.md |
| minimal-output | skills/minimal-output.md |
| output-control | skills/output-control.md |
| structured-response | skills/structured-response.md |
| followup-refine | skills/followup-refine.md |
| session-closer | skills/session-closer.md |
| safe-cleanup-with-backup | skills/safe-cleanup-with-backup.md |
| duplicate-structure-audit | skills/duplicate-structure-audit.md |
| code-review | skills/code-review.md |
| change-manifest | skills/change-manifest.md |
| spec-to-task | skills/spec-to-task.md |
| jsx-to-standalone-html | skills/jsx-to-standalone-html.md |
| project-scan | skills/project-scan.md |
| framework-apply | skills/framework-apply.md |
| pre-tool-use | hooks/pre-tool-use.ps1 AND hooks/pre-tool-use.sh |
| post-tool-use | hooks/post-tool-use.ps1 AND hooks/post-tool-use.sh |
| pre-compact | hooks/pre-compact.ps1 AND hooks/pre-compact.sh |
| skills-registry | registry/skills-registry.md |
| hooks-registry | registry/hooks-registry.md |
| patterns-registry | registry/patterns-registry.md |
| session-files | PROFILE.md + SESSION_LOG.md + .claude/history/ skeleton |

---

## Steps

### Step 1 — Determine component list
- If components listed in trigger: use that list.
- Else: read `[TARGET_PATH]/PROJECT_SCAN.md` → extract all items from "High Priority" and "Medium Priority" in the "What's Missing" section.
- If `PROJECT_SCAN.md` does not exist: stop and say "Run 'Use project-scan skill.' first."

### Step 2 — Resolve FRAMEWORK_PATH
Read from `~/.claude/CLAUDE.md` `FRAMEWORK_PATH:` line, or ask the user.

### Step 3 — For each component to install
```
a. Resolve source:  [FRAMEWORK_PATH]/[mapped-path]
b. Resolve target:  [TARGET_PATH]/[mapped-path]
c. If target file already exists:  mark SKIPPED — do not copy
d. If target directory does not exist: create it
e. Copy source file to target
f. Verify: confirm target file now exists
g. If copy fails: mark FAILED, continue to next component
```

### Step 4 — Hooks post-install advisory
If any hooks were installed:
- **Unix:** Report: `Run: chmod +x [TARGET_PATH]/hooks/*.sh`
- **Windows:** No extra step needed for .ps1 files

If `.claude/settings.json` does not exist in target:
- Show the exact JSON from `registry/hooks-registry.md` "settings.json Configuration Template"
- Do NOT create the file — instruct the user to create it

### Step 5 — CLAUDE.md advisory
If any skills were installed AND CLAUDE.md exists in target:
- Report: "Add these lines to your CLAUDE.md Core Skills section:"
- Show exactly the lines in the standard format used by the framework's own CLAUDE.md
- Do NOT modify CLAUDE.md

If CLAUDE.md does not exist in target:
- Report: "No CLAUDE.md found. Consider creating one. Minimum content:"
- Show a minimal CLAUDE.md template with just the Core Skills section

### Step 6 — session-files special handling
If `session-files` is in the component list:
- Copy `PROFILE.md` from FRAMEWORK_PATH to TARGET_PATH (skip if exists)
- Create `SESSION_LOG.md` in TARGET_PATH with starter content (skip if exists)
- Create `.claude/history/decisions.md`, `learnings.md`, `patterns.md` stubs (skip if any exist)

---

## Output Format

```
FRAMEWORK APPLY REPORT
═══════════════════════════════════════════════════════
Target:    [/path/to/target]
Framework: [/path/to/framework]
Date:      YYYY-MM-DD

INSTALLED
  skills/scope-guard.md             ← copied
  skills/debug-first.md             ← copied
  hooks/pre-tool-use.ps1            ← copied
  hooks/pre-tool-use.sh             ← copied
  ...

SKIPPED (already present — not overwritten)
  CLAUDE.md
  skills/minimal-output.md
  ...

FAILED
  [none]

═══════════════════════════════════════════════════════
MANUAL STEPS REQUIRED

1. Add to [TARGET]/CLAUDE.md → Core Skills section:
   - `skills/scope-guard.md` to prevent scope creep.
   - `skills/debug-first.md` for bug diagnosis before fixing.
   [remaining skills...]

2. Create [TARGET]/.claude/settings.json:
   [exact JSON from hooks-registry.md]

3. Unix only:
   chmod +x [TARGET]/hooks/*.sh
═══════════════════════════════════════════════════════
[N] installed. [N] skipped. [N] failed.
Done. Review manual steps above before starting a Claude Code session in this project.
```
