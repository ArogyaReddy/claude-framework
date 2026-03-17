# Skills Registry

> Read by: `project-scan` skill (gap analysis) and `framework-apply` skill (installation).
> Update this file whenever a new skill is added to `skills/`.

---

## Quick Index

| Skill | File | Category | Stacks | Priority |
|---|---|---|---|---|
| scope-guard | skills/scope-guard.md | safety | all | HIGH |
| debug-first | skills/debug-first.md | debugging | all | HIGH |
| code-review | skills/code-review.md | quality | all | HIGH |
| change-manifest | skills/change-manifest.md | traceability | all | HIGH |
| spec-to-task | skills/spec-to-task.md | planning | all | HIGH |
| safe-cleanup-with-backup | skills/safe-cleanup-with-backup.md | safety | all | HIGH |
| session-closer | skills/session-closer.md | session | all | HIGH |
| project-scan | skills/project-scan.md | onboarding | all | HIGH |
| framework-apply | skills/framework-apply.md | onboarding | all | HIGH |
| minimal-output | skills/minimal-output.md | output | all | MEDIUM |
| output-control | skills/output-control.md | output | all | MEDIUM |
| structured-response | skills/structured-response.md | output | all | MEDIUM |
| duplicate-structure-audit | skills/duplicate-structure-audit.md | audit | all | MEDIUM |
| followup-refine | skills/followup-refine.md | output | all | LOW |
| jsx-to-standalone-html | skills/jsx-to-standalone-html.md | conversion | react,jsx,tsx | LOW |
| healthcheck | skills/healthcheck.md | onboarding | all | HIGH |
| decision-log | skills/decision-log.md | session | all | MEDIUM |

---

## Detail Entries

### scope-guard
- **File:** skills/scope-guard.md
- **Trigger:** "Use scope-guard skill."
- **Category:** safety
- **Applies to:** All stacks
- **When to add:** Always — add to every project, every session
- **Signs it's needed:** Claude modifies files outside the stated task; Claude adds features not requested
- **Priority:** HIGH
- **Dependencies:** none

---

### debug-first
- **File:** skills/debug-first.md
- **Trigger:** "Use debug-first skill on [file/error]"
- **Category:** debugging
- **Applies to:** All stacks
- **When to add:** Any project with active bug work
- **Signs it's needed:** Claude immediately rewrites code without explaining the root cause
- **Priority:** HIGH
- **Dependencies:** none

---

### code-review
- **File:** skills/code-review.md
- **Trigger:** "Use code-review skill on [file or directory]"
- **Category:** quality
- **Applies to:** All stacks
- **When to add:** Any project with code standards or pre-merge review requirements
- **Signs it's needed:** No review step before merges; inconsistent code standards across files
- **Priority:** HIGH
- **Dependencies:** none

---

### change-manifest
- **File:** skills/change-manifest.md
- **Trigger:** "Use change-manifest skill."
- **Category:** traceability
- **Applies to:** All stacks
- **When to add:** Any multi-file project where audit trail matters
- **Signs it's needed:** After a session you cannot tell what was changed or why
- **Priority:** HIGH
- **Dependencies:** none

---

### spec-to-task
- **File:** skills/spec-to-task.md
- **Trigger:** "Use spec-to-task skill on [spec file]"
- **Category:** planning
- **Applies to:** All stacks
- **When to add:** Any project with written specs or feature briefs
- **Signs it's needed:** Implementation starts before scope is fully defined; tasks span multiple files without a plan
- **Priority:** HIGH
- **Dependencies:** none

---

### safe-cleanup-with-backup
- **File:** skills/safe-cleanup-with-backup.md
- **Trigger:** "Use safe-cleanup-with-backup skill."
- **Category:** safety
- **Applies to:** All stacks
- **When to add:** Any project where destructive cleanup (file deletion, folder removal) may be needed
- **Signs it's needed:** Deletions have happened without backups; duplicate folder structures exist
- **Priority:** HIGH
- **Dependencies:** none

---

### session-closer
- **File:** skills/session-closer.md
- **Trigger:** "close the session"
- **Category:** session
- **Applies to:** All stacks
- **When to add:** Every project — this is the engine that builds compounding memory
- **Signs it's needed:** Each session starts from scratch; decisions are forgotten; patterns repeat
- **Priority:** HIGH
- **Dependencies:** SESSION_LOG.md, .claude/history/ directory must exist in project

---

### project-scan
- **File:** skills/project-scan.md
- **Trigger:** "Use project-scan skill on [/path/to/project]"
- **Category:** onboarding
- **Applies to:** All stacks
- **When to add:** Every project — enables future re-scanning and gap analysis at any time
- **Signs it's needed:** Starting a new project; unsure what framework components are missing
- **Priority:** HIGH
- **Dependencies:** registry/skills-registry.md, registry/hooks-registry.md, tools/scan-project.ps1 or .sh

---

### framework-apply
- **File:** skills/framework-apply.md
- **Trigger:** "Use framework-apply skill."
- **Category:** onboarding
- **Applies to:** All stacks
- **When to add:** Every project — the install mechanism after a scan
- **Signs it's needed:** After running project-scan and reviewing PROJECT_SCAN.md
- **Priority:** HIGH
- **Dependencies:** PROJECT_SCAN.md must exist in target (run project-scan first)

---

### minimal-output
- **File:** skills/minimal-output.md
- **Trigger:** "Use minimal-output skill."
- **Category:** output
- **Applies to:** All stacks
- **When to add:** Any project where Claude is writing or editing code
- **Signs it's needed:** Claude adds excessive narration around code output; responses contain preambles and summaries wrapping a simple code change
- **Priority:** MEDIUM
- **Dependencies:** none

---

### output-control
- **File:** skills/output-control.md
- **Trigger:** "Use output-control skill."
- **Category:** output
- **Applies to:** All stacks
- **When to add:** Projects generating content for fixed-format display (dashboards, reports, cards)
- **Signs it's needed:** Claude responses are unpredictable in length/format; downstream parsing is unreliable
- **Priority:** MEDIUM
- **Dependencies:** none

---

### structured-response
- **File:** skills/structured-response.md
- **Trigger:** "Use structured-response skill."
- **Category:** output
- **Applies to:** All stacks
- **When to add:** Projects requiring multi-section documents (specs, audits, onboarding docs, comparisons)
- **Signs it's needed:** Long single-block answers that need to be scannable by section
- **Priority:** MEDIUM
- **Dependencies:** none

---

### duplicate-structure-audit
- **File:** skills/duplicate-structure-audit.md
- **Trigger:** "Use duplicate-structure-audit skill."
- **Category:** audit
- **Applies to:** All stacks
- **When to add:** Any project with history of nested copies, migrations, or scaffolded duplicates
- **Signs it's needed:** Multiple folders with the same name at different paths; uncertainty about which copy is canonical
- **Priority:** MEDIUM
- **Dependencies:** safe-cleanup-with-backup (should be installed before any cleanup is done)

---

### followup-refine
- **File:** skills/followup-refine.md
- **Trigger:** "Use followup-refine skill."
- **Category:** output
- **Applies to:** All stacks
- **When to add:** Projects with multiple audiences (technical + stakeholder, dev + PM)
- **Signs it's needed:** Technical explanations need re-explaining in simpler form for a different reader
- **Priority:** LOW
- **Dependencies:** none

---

### jsx-to-standalone-html
- **File:** skills/jsx-to-standalone-html.md
- **Trigger:** "Use jsx-to-standalone-html skill."
- **Category:** conversion
- **Applies to:** React, JSX, TSX projects only
- **When to add:** React/JSX projects where browser-usable standalone deliverables are needed
- **Signs it's needed:** Stakeholders need to view UI without running Node; zero-dependency HTML demo needed
- **Priority:** LOW (stack-conditional)
- **Dependencies:** Project must have .jsx or .tsx files

---

### healthcheck
- **File:** skills/healthcheck.md
- **Trigger:** "Use healthcheck skill."
- **Category:** onboarding
- **Applies to:** All stacks
- **When to add:** After initial framework setup; run periodically to catch drift
- **Signs it's needed:** Unsure if all framework components are correctly wired; settings.json not verified; skills not loading correctly
- **Priority:** HIGH
- **Dependencies:** Requires FRAMEWORK_PATH/registry/ to compare against

---

### decision-log
- **File:** skills/decision-log.md
- **Trigger:** "Use decision-log skill."
- **Category:** session
- **Applies to:** All stacks
- **When to add:** Any project with architectural decisions, approach choices, or tech selections
- **Signs it's needed:** Decision history is scattered across SESSION_LOG entries; same decisions are being revisited; no record of why a pattern was chosen
- **Priority:** MEDIUM
- **Dependencies:** .claude/history/ directory should exist (created by session-closer)
