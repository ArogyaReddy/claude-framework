# API.md — Public Interface Reference

This framework has no HTTP API. Its public interface is the set of **invocation commands**, **skill names**, and **session commands** that a developer calls in Claude Code.

---

## Session Commands

These are typed directly into Claude Code in any session where CLAUDE.md is loaded.

### `/resume`
Triggers session startup protocol. Claude reads memory files and outputs a Session Brief.

**Triggers:**
- Reads `SCRATCHPAD.md` fully
- Scans `DECISIONS.md` for entries relevant to current focus
- Outputs: Current focus, last decisions, pending tasks, suggested next action

**When to use:** At the start of every session, or after returning from a long break mid-session.

**Output format:**
```
CURRENT FOCUS: [what we were working on]
LAST DECISIONS: [key decisions from DECISIONS.md]
PENDING: [unfinished tasks]
RESUME HERE: [exact next step]
```

---

### `/wrap`
Triggers session closure. Claude writes all memory files and outputs archive commands.

**Triggers:**
- Updates `SCRATCHPAD.md` — replaces Current Focus and Resume Here, appends failures/questions
- Appends new decisions to `DECISIONS.md` (if any were made)
- Appends one summary row to `SESSIONS.md`
- Surfaces `CLAUDE.md` improvement suggestions (does NOT auto-edit)

**When to use:** At the end of every session, without exception. Missing this loses all session context.

---

### `/decide`
Logs a single decision to `DECISIONS.md` immediately, mid-session.

**When to use:** Any time an architectural or significant decision is made. Do not wait for `/wrap` — context degrades.

**Output format:**
```
DECISION-XXX: [title]
Date: [date]
Decision: [what was chosen]
Reason: [why]
Alternatives rejected: [what else was considered]
```

---

### `/plan`
Phase 1 of the 5-Phase Protocol. Architecture only — no code written.

**Rules:**
- Claude proposes architecture and resolves open decisions
- No file edits occur during this phase
- Output: agreed plan, decisions to be logged

---

### `/spec`
Phase 2. Writes a spec file to `specs/[feature-name].md`.

**Uses:** `specs/_template.md` as the format base.

**Output:** A committed spec file with scope, decisions, constraints, and task checklist.

---

### `/chunk`
Phase 3. Builds one chunk of work: one scope-bounded set of changes.

**Rules:**
- One chunk per invocation. Build → verify → commit → next chunk.
- Hooks fire on every file write and Bash call
- Output: Change manifest (file:line format)

---

### `/verify`
Phase 4. Claude interrogates its own output before it is committed.

**Output format:**
```
SCOPE CHECK: [files touched vs. files permitted]
LOGIC CHECK: [does the output match the spec?]
RISK: LOW / MEDIUM / HIGH
COMMIT: APPROVED / FLAGGED
```

---

### `/update`
Phase 5. Claude improves CLAUDE.md with lessons learned, then closes.

---

## Skill Invocation Interface

All skills are invoked with: `Use [skill-name] skill.`

### Core Skills

| Invocation | Agent | Input | Output |
|---|---|---|---|
| `Use minimal-output skill.` | false | None | Strips narration; code-only responses for duration of session |
| `Use debug-first skill.` | false | Bug description | EXPECTS / ACTUAL / CAUSE / FIX format before any code is touched |
| `Use scope-guard skill.` | false | Task description | SCOPE BLOCKER triggers if Claude attempts out-of-scope file edits |
| `Use spec-to-task skill on specs/[name].md` | true | Spec file | Ordered task list, one item per chunk, with dependencies stated |
| `Use code-review skill on [file].` | true | File path | Violations against CLAUDE.md rules only — no praise, no padding |
| `Use change-manifest skill.` | false | None | CHANGE MANIFEST: modified / created / deleted files with spec refs |
| `Use session-closer skill.` | false | None | Writes SESSION_LOG.md and all `.claude/history/` knowledge files |
| `Use output-control skill.` | false | None | Activates `<format>`, `<length>`, `<sections>` XML override tags |

### Framework Skills

| Invocation | Agent | Input | Output |
|---|---|---|---|
| `Use project-scan skill on [path].` | true | Project path | `PROJECT_SCAN.md` — gap analysis against framework components |
| `Use framework-apply skill.` | true | Scan report | Installs missing framework components into target project |
| `Use healthcheck skill.` | true | None | 12-point diagnostic: PASS / WARN / FAIL per component |
| `Use safe-cleanup-with-backup skill.` | false | Target path | Timestamped backup + deletion with inventory report |
| `Use duplicate-structure-audit skill.` | true | Target path | Classifies duplicates: SAFE / CONFLICT / UNKNOWN |

### Session Skills (`.claude/skills/` — this repo only)

| Invocation | Agent | Input | Output |
|---|---|---|---|
| `Use simplify skill.` | false | Changed file | Code quality review — verbosity, unnecessary complexity |
| `Use batch skill.` | true | Task list | Parallel multi-agent orchestration plan |
| `Use code-run-faster skill.` | false | File path | Performance profile + optimization candidates |
| `Use problem-solver skill.` | false | Problem statement | Deep structured analysis with alternatives |

---

## Hook Interface

Hooks are scripts registered in `~/.claude/settings.json`. They are not invoked by the developer — they fire automatically at the Claude Code app layer.

### `pre-tool-use.ps1`

Fires **before** every Bash, Write, and Edit call.

**Blocks:**
- `rm -rf` — recursive deletion without backup
- `DROP TABLE`, `DROP DATABASE`, `TRUNCATE` — destructive SQL
- `git push --force` — force push to remote
- Writes to `.env` files — credential exposure risk
- `npm install`, `pip install`, `yarn add` — unauthorized dependency changes

**Logs:** Every tool use to `.claude/logs/tool-use.log`

### `post-tool-use.ps1`

Fires **after** every tool call.

**Logs:**
- Tool outcomes to `tool-use.log` and dated `session-YYYY-MM-DD.log`
- File paths of every Write/Edit to `changes.log`
- Failed Bash commands (flagged separately)

### `pre-compact.ps1`

Fires **before** each `/compact` context compression.

**Saves:** Pre-compact state snapshot to `.claude/logs/pre-compact-state.md` including:
- Files changed this session
- Current git status
- Last SESSION_LOG entry

---

## CLAUDE.md Override Tags

When `output-control skill` is active, these XML tags override default output rules:

| Tag | Effect |
|---|---|
| `<format>bullet</format>` | Force bullet-point output |
| `<format>prose</format>` | Force paragraph output |
| `<length>short</length>` | Responses under 100 words |
| `<length>detailed</length>` | Full detail, no compression |
| `<sections>yes</sections>` | Use `##` headers per section |
| `<sections>no</sections>` | Flat output, no headers |
