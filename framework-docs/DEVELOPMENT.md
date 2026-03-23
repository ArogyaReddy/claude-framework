# DEVELOPMENT.md — Local Setup Guide

## Prerequisites

| Tool | Minimum Version | Why |
|---|---|---|
| Node.js | 20+ | React/Vite dev server, Vitest tests |
| Claude Code CLI | Latest | The tool this framework wraps |
| PowerShell | 5.1+ (Windows) | Hook scripts are `.ps1` |
| Bash | 4+ (Unix/Mac) | `setup.sh` + Unix hook variants |
| Git | 2.30+ | Hooks verify git status pre-compact |

---

## Step-by-Step Local Setup

```bash
# 1. Clone the framework
git clone https://github.com/ArogyaReddy/claude-framework.git
cd claude-framework

# 2. Install Node dependencies (minimal — for Vite dev server only)
npm install

# 3. Run the installer
# Windows:
.\setup.ps1

# Unix/Mac:
./setup.sh

# 4. Verify hooks are wired
# Check that ~/.claude/settings.json contains hook paths
# Windows path example:
# C:/Users/[YourName]/.claude/settings.json

# 5. Open Claude Code in this project
claude

# 6. Run healthcheck
# Inside Claude Code, type:
# Use healthcheck skill.
```

The installer:
- Prompts for your name, role, stack, and preferences → writes `PROFILE.md`
- Creates `SCRATCHPAD.md`, `DECISIONS.md`, `SESSIONS.md` (empty shells)
- Copies hook scripts to `hooks/` and registers absolute paths in `~/.claude/settings.json`
- Creates `.claudeignore` if not present
- Verifies all 17 skills are present in `skills/`

**Flags:**
- `-SkipProfile` — skip profile questions (useful when re-running setup)
- `-DryRun` — preview all actions without writing any files

---

## Applying the Framework to a New Project

```bash
# 1. Open Claude Code in the target project
cd /path/to/your-project
claude

# 2. Run project scan to see what's missing
Use project-scan skill on .

# 3. Install missing components
Use framework-apply skill.

# 4. Verify installation
Use healthcheck skill.
```

The healthcheck returns a 12-point report: PASS / WARN / FAIL per component. Aim for all PASS before starting real work.

---

## Running Tests

```bash
# All tests
npm test

# Unit tests only (Vitest)
npm run test:unit

# With coverage
npm run test:coverage

# End-to-end (when Playwright is added)
npm run test:e2e
```

---

## Verifying Hooks Are Active

After setup, verify hooks fire correctly:

**Test 1 — pre-tool-use logging:**
```bash
# Open Claude Code in any project
claude

# Run any Bash command (e.g., ask Claude to list files)
# Then check:
cat .claude/logs/tool-use.log
# Should show the tool event logged
```

**Test 2 — pre-compact snapshot:**
```bash
# Inside Claude Code, run /compact
# Then check:
cat .claude/logs/pre-compact-state.md
# Should show files changed, git status, last session entry
```

**Test 3 — block verification:**
```bash
# Ask Claude to run: rm -rf /tmp/test
# Hook should block it. Claude Code will report the block.
```

---

## Common Setup Failures

| Error | Cause | Fix |
|---|---|---|
| `hook not found` in settings.json | Absolute path wrong — spaces or backslashes | Use forward slashes in path; no trailing slash |
| `PROFILE.md has placeholders` | Setup was skipped or `-SkipProfile` used | Run `.\setup.ps1` again without flags |
| `healthcheck: 17 skills expected, found 14` | Partial clone or corrupted copy | Re-clone; verify `skills/` has all 17 `.md` files |
| `SESSION_LOG.md not found` | Normal on first run | Run a full session and use `/wrap` to generate it |
| Hooks fire but don't block | PowerShell execution policy | Run: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` |
| `.claudeignore` not found in project | Framework applied but file skipped | Manually copy `.claudeignore` from framework root |

---

## Linting and Formatting

```bash
# No lint/format tools are installed by the framework.
# The framework enforces code quality via:
# - CLAUDE.md output rules (format rules applied to Claude's output)
# - code-review skill (applies rules on request)
# - post-tool-use hook (can be extended to run lint)

# For the Vite/React src/ files:
npm run lint       # ESLint (if configured in project)
npm run format     # Prettier (if configured in project)
```

---

## Wiring Global vs. Per-Project Settings

The framework operates at two scopes:

**Global** (`~/.claude/CLAUDE.md` + `~/.claude/settings.json`):
- Applies in every project, always
- Contains: PROFILE, output rules, hook registration, memory system block, phase framework block
- Modify with care — changes affect all projects

**Per-project** (`./CLAUDE.md` + `./.claudeignore`):
- Applies only in this project
- Contains: project-specific stack, conventions, active specs
- Project rules override global rules where they conflict

To update a rule everywhere: edit `~/.claude/CLAUDE.md`.
To override for one project only: add the override to `./CLAUDE.md`.

---

## Development Workflow (Daily)

```
Morning:
  1. cd /your-project
  2. claude
  3. /resume  ← reads memory, outputs session brief
  4. Confirm brief, start working

During work:
  5. Use scope-guard skill.  ← before any multi-file task
  6. /plan → /spec → /chunk → /verify → /chunk → /verify...
  7. /decide  ← immediately when making any architectural choice

End of day:
  8. /wrap  ← writes all memory files
  9. Exit Claude Code
```

Never close Claude Code without `/wrap`. That's the only rule that matters for memory continuity.
