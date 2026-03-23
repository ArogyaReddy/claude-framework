# Claude Code Master Framework

> Minimal tokens. Maximum precision. Zero guesswork.

A ready-to-copy operating system for Claude Code — built by a Principal Engineer who works with Claude daily and was tired of re-explaining context, fighting token costs, and watching AI sessions drift without discipline.

This framework is not a collection of tips. It is a structured, file-based runtime that gives Claude a persistent identity, enforced memory, skill invocation, automated safety hooks, and a 5-phase development protocol — all loaded into Claude's context before you type a single word.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/ArogyaReddy/claude-framework.git && cd claude-framework

# 2. Run the installer (Windows)
.\setup.ps1

# Or Unix
./setup.sh

# 3. Open Claude Code in any project folder
claude
```

The installer prompts for your profile, creates all config files, wires hooks, and runs a verification check. Safe to re-run — never overwrites existing files.

## Installation

### Prerequisites
- Node.js 20+
- Claude Code CLI installed and authenticated
- PowerShell 5+ (Windows) or Bash (Unix/Mac)

### Step-by-step

```bash
# Clone the framework
git clone https://github.com/ArogyaReddy/claude-framework.git
cd claude-framework

# Windows (recommended first-time)
.\setup.ps1

# With flags
.\setup.ps1 -SkipProfile   # Skip profile questions
.\setup.ps1 -DryRun        # Preview without writing

# Unix
./setup.sh
```

After setup, copy `CLAUDE.md`, `skills/`, `hooks/`, `.claudeignore`, and `workflow/` into any new project. Run `Use healthcheck skill.` to verify.

## Usage Examples

**Start any task with the daily checklist:**
```
Use scope-guard skill.
Now add authentication middleware to src/auth/middleware.js only.
```

**Diagnose any bug with structured diagnosis:**
```
Use debug-first skill.
The /api/users endpoint returns 403 for all POST requests.
```

**Convert a spec to an ordered task list:**
```
Use spec-to-task skill on specs/user-auth.md
```

## Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) — System design, C4 diagram, ADRs
- [DEVELOPMENT.md](DEVELOPMENT.md) — Local setup, hooks, project setup
- [WORKING-MODEL.md](WORKING-MODEL.md) — How to use it day-to-day
- [STRUCTURE.md](STRUCTURE.md) — Directory map and file purposes
- [QUESTIONS-BANK.md](QUESTIONS-BANK.md) — 20+ answered questions
- [SUMMARY-TABLE.md](SUMMARY-TABLE.md) — Full documentation index
