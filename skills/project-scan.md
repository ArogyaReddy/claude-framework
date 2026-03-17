---
name: project-scan
description: Scans a project directory and produces PROJECT_SCAN.md identifying framework gaps.
invocation: manual
agent: true
---

# Skill: project-scan

## Trigger
```
Use project-scan skill on [/absolute/path/to/project]
```
Or, if already inside the target project:
```
Use project-scan skill.
```
If path is ambiguous, ask the user before proceeding.

## Purpose
Scan any project — new or existing — and produce `PROJECT_SCAN.md`:
a clear gap report showing what framework components exist, what's missing,
and prioritised recommendations for what to add.

Works on any language, any stack, any project size.

---

## Prerequisites (verify before starting)

1. `registry/skills-registry.md` exists in FRAMEWORK_PATH
2. `registry/hooks-registry.md` exists in FRAMEWORK_PATH
3. `tools/scan-project.ps1` (Windows) or `tools/scan-project.sh` (Unix) exists in FRAMEWORK_PATH
4. FRAMEWORK_PATH is known — read from `~/.claude/CLAUDE.md` or ask the user

---

## Steps

### Step 1 — Resolve paths
- TARGET_PATH: from trigger argument, current directory, or ask
- FRAMEWORK_PATH: from `~/.claude/CLAUDE.md` `FRAMEWORK_PATH:` line, or ask
- OS: detect Windows vs Unix

### Step 2 — Run scanner script

**Windows:**
```
powershell -NoProfile -ExecutionPolicy Bypass -File "[FRAMEWORK_PATH]/tools/scan-project.ps1" -ProjectPath "[TARGET_PATH]" -FrameworkPath "[FRAMEWORK_PATH]"
```

**Unix:**
```
bash "[FRAMEWORK_PATH]/tools/scan-project.sh" "[TARGET_PATH]" "[FRAMEWORK_PATH]"
```

If the script fails: report the error clearly. Ask the user to verify the path exists
and the script is accessible. Do not proceed without scan data.

### Step 3 — Read raw scan output
Read `[TARGET_PATH]/PROJECT_SCAN_RAW.md`

### Step 4 — Read registries
Read `[FRAMEWORK_PATH]/registry/skills-registry.md`
Read `[FRAMEWORK_PATH]/registry/hooks-registry.md`

### Step 5 — Infer stack from raw scan
Use FILE EXTENSIONS and DEPENDENCY MANIFESTS from the raw scan:

| Signal | Inferred stack |
|---|---|
| .ts + .tsx + package.json | TypeScript / React |
| .ts + package.json (no .tsx) | TypeScript / Node |
| .js + package.json | JavaScript / Node |
| .py + requirements.txt or pyproject.toml | Python |
| .go + go.mod | Go |
| .rs + Cargo.toml | Rust |
| .java + pom.xml | Java / Maven |
| .java + build.gradle | Java / Gradle |
| .rb + Gemfile | Ruby / Rails |
| .cs + *.csproj | C# / .NET |
| No manifests + .sh/.bash files | Shell / Bash scripts |

Note: infer only from evidence present. Do not guess.

### Step 6 — Gap analysis

For each skill in `registry/skills-registry.md` Quick Index:
- Check if `[TARGET_PATH]/skills/[skill-file]` exists
- Mark: PRESENT | ABSENT
- If stack conditional (e.g. jsx-to-standalone-html): only flag as missing if stack matches

For each hook in `registry/hooks-registry.md` Quick Index:
- Check if `[TARGET_PATH]/hooks/[hook-file.ps1]` exists → PS1 status
- Check if `[TARGET_PATH]/hooks/[hook-file.sh]` exists → SH status
- Check if `[TARGET_PATH]/.claude/settings.json` exists → wired status

Check knowledge files:
- PROFILE.md present?
- SESSION_LOG.md present?
- .claude/history/ present?
- .claude/history/decisions.md, learnings.md, patterns.md present?

### Step 7 — Write PROJECT_SCAN.md
Write to `[TARGET_PATH]/PROJECT_SCAN.md` using the Output Format below.

### Step 8 — Report to user
```
PROJECT_SCAN.md written to [TARGET_PATH].
[N] HIGH priority items missing. [N] components already present.
Review PROJECT_SCAN.md, then run: "Use framework-apply skill."
```

---

## Output Format — PROJECT_SCAN.md

```markdown
# PROJECT_SCAN.md
Generated:  YYYY-MM-DD HH:MM
Target:     /absolute/path/to/project
Framework:  /absolute/path/to/framework

---

## Summary
[One sentence: inferred project type, primary language, approx scale, existing framework coverage.]
Example: "TypeScript/React frontend (~200 source files) — no framework components installed."

---

## Stack Detected
- Primary language: [language + file count evidence]
- Runtime: [e.g. Node.js (package.json present)]
- Framework: [e.g. React (inferred from .tsx files + package.json)]
- Build tool: [if detectable]
- Tests: [if detectable from manifest or test file patterns]
- Other manifests: [list or "none detected"]

*Detection is file-based only. Verify against actual dependency file contents.*

---

## What Exists

| Component | Status | Notes |
|---|---|---|
| CLAUDE.md | PRESENT / ABSENT | — |
| PROFILE.md | PRESENT / ABSENT | — |
| SESSION_LOG.md | PRESENT / ABSENT | — |
| .claude/settings.json | PRESENT / ABSENT | — |
| .claude/history/ | PRESENT / ABSENT | — |
| skills/ | PRESENT (N files) / ABSENT | — |
| hooks/ | PRESENT (N files) / ABSENT | — |
| registry/ | PRESENT / ABSENT | — |
| tools/ | PRESENT / ABSENT | — |

### Skills Present
| Skill | File |
|---|---|
| [name] | skills/[file].md |

### Skills Absent
| Skill | File |
|---|---|
| [name] | skills/[file].md |

---

## What's Missing

### High Priority (install now)
1. [skill/hook name] — [one-line reason]
2. ...

### Medium Priority
1. [skill/hook name] — [one-line reason]
2. ...

### Low Priority / Optional
1. [skill/hook name] — [condition or reason]
2. ...

---

## Gap Analysis

### Skills
| Skill | Reason to Add | Stack Match | Priority |
|---|---|---|---|
| [name] | [reason] | all / [specific] | HIGH/MED/LOW |

### Hooks
| Hook | PS1 | SH | Wired in settings.json |
|---|---|---|---|
| pre-tool-use | PRESENT/absent | PRESENT/absent | YES/no |
| post-tool-use | PRESENT/absent | PRESENT/absent | YES/no |
| pre-compact | PRESENT/absent | PRESENT/absent | YES/no |

### Knowledge Files
| File | Status |
|---|---|
| PROFILE.md | PRESENT / ABSENT |
| SESSION_LOG.md | PRESENT / ABSENT |
| .claude/history/decisions.md | PRESENT / ABSENT |
| .claude/history/learnings.md | PRESENT / ABSENT |
| .claude/history/patterns.md | PRESENT / ABSENT |

---

## Recommendations

Run this to install all recommended components:
  Use framework-apply skill.

Or install specific components only:
  Use framework-apply skill. Target: [TARGET_PATH] Components: scope-guard,debug-first,session-closer

After installation, add these lines to your CLAUDE.md Core Skills section:
  - `skills/scope-guard.md` to prevent scope creep.
  - `skills/debug-first.md` for bug diagnosis before fixing.
  [... exact lines per skill installed]

If hooks were not previously wired:
  Create .claude/settings.json — see registry/hooks-registry.md for exact JSON.

---

*Generated by project-scan skill — [FRAMEWORK_PATH]/skills/project-scan.md*
```

---

## Rules

- Never modify any target project file except `PROJECT_SCAN_RAW.md` and `PROJECT_SCAN.md`.
- Never infer stack beyond what scanner data explicitly shows.
- If a check result is ambiguous, mark: `uncertain — verify manually`.
- Only recommend `jsx-to-standalone-html` if `.jsx` or `.tsx` file count > 0.
- If FRAMEWORK_PATH cannot be determined, stop and ask before writing anything.
