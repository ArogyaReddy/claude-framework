# Spec: Claude Framework Bootstrap

> **Status:** Done
> **Author:** Project Setup Automation
> **Last Updated:** 2026-03-15
> **Spec ID:** SPEC-001

---

## 1. Problem

The repository needed an isolated, non-destructive setup for the Claude framework workflow so prompt discipline, hooks, skills, and specs are available without changing the existing application behavior.

---

## 2. Goal

Add all framework scaffolding files to the project root, configure baseline instructions/ignore settings, and keep the React app runnable at the end.

---

## 3. Scope

### In Scope
- Copy framework assets into project root without overwriting existing app files.
- Configure `CLAUDE.md` placeholders for this React + Vite project.
- Ensure `.claude/logs/` exists and is ignored by git.
- Keep app startup/build working.

### Out of Scope
- Refactoring application UI logic.
- Adding new runtime dependencies.
- Modifying existing `src` business logic beyond wiring already done.

---

## 4. Behaviour

### 4.1 Framework Scaffolding
System copies missing framework files/folders into project root.
Input: nested `claude-framework/` source directory.
Output: root-level `CLAUDE.md`, `.claudeignore`, `.claude/`, `skills/`, `hooks/`, `prompts/`, `specs/`, `workflow/`.
Edge cases: existing files are preserved and not overwritten.

### 4.2 Runtime Verification
System runs build/dev commands to validate no setup regression.
Input: current project `package.json` scripts.
Output: successful Vite build and runnable dev server URL.
Edge cases: port conflicts can shift to another port.

---

## 5. Data

### Input
```
Project files and framework template folders.
```

### Output
```
Configured repository structure and validated runnable app.
```

### Persistence
Configuration stored as markdown/json/shell files in repository root and subfolders.

---

## 6. Constraints

- Must not modify existing typing-tutor project files.
- Must remain compatible with Windows development environment.
- Must not introduce secrets or environment values into tracked files.
- No new external packages for setup tasks.

---

## 7. Files Affected

| File | Change Type | Notes |
|---|---|---|
| CLAUDE.md | Modify | Filled project-specific placeholders |
| .claudeignore | Modify | Added project-specific ignore entries |
| .gitignore | Create/Modify | Added `.claude/logs/` |
| .claude/logs/ | Create | Added logs directory |
| specs/project-bootstrap.md | Create/Modify | Created and populated bootstrap spec |

---

## 8. Acceptance Criteria

- [x] Framework folders/files exist in project root.
- [x] `CLAUDE.md` no longer contains placeholder fill-in entries for core project metadata.
- [x] `.claude/logs/` exists and is git-ignored.

---

## 9. Open Questions

| # | Question | Owner | Status |
|---|---|---|---|
| 1 | Should unused nested source folder be cleaned after setup? | Maintainer | Open |

---

## 10. Notes

WSL/bash permission step could not be completed due local WSL corruption; hooks remain present and configured in `.claude/settings.json`.
