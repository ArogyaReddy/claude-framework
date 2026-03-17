# Hooks Registry

> Read by: `project-scan` skill (gap analysis) and `framework-apply` skill (installation).
> Update this file whenever a new hook is added to `hooks/`.

---

## Quick Index

| Hook | PS1 File | SH File | Trigger Event | Priority |
|---|---|---|---|---|
| pre-tool-use | hooks/pre-tool-use.ps1 | hooks/pre-tool-use.sh | Before Bash, Write, Edit | HIGH |
| post-tool-use | hooks/post-tool-use.ps1 | hooks/post-tool-use.sh | After any tool | HIGH |
| pre-compact | hooks/pre-compact.ps1 | hooks/pre-compact.sh | Before context compaction | MEDIUM |

---

## Detail Entries

### pre-tool-use
- **Files:** hooks/pre-tool-use.ps1 / hooks/pre-tool-use.sh
- **Trigger event:** PreToolUse — Bash, Write, Edit
- **Purpose:** Block dangerous operations before they execute. Log all tool use.
- **Blocks:**
  - `rm -rf` (any form)
  - `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`
  - `git push --force` to main or master
  - Writes to `.env` files
  - `npm install`, `pip install`, `yarn add` without approval
- **Produces:** `.claude/logs/tool-use.log`
- **Priority:** HIGH — install on every project
- **Settings.json matchers:** `"Bash"`, `"Write"`, `"Edit"` (three separate entries)
- **Unix post-install:** `chmod +x hooks/pre-tool-use.sh`

---

### post-tool-use
- **Files:** hooks/post-tool-use.ps1 / hooks/post-tool-use.sh
- **Trigger event:** PostToolUse — all tools (`.*`)
- **Purpose:** Log every tool call outcome. Track file changes. Flag non-zero exits.
- **Produces:**
  - `.claude/logs/tool-use.log` (appends)
  - `.claude/logs/changes.log` (tracks files written/edited)
- **Priority:** HIGH — install on every project
- **Settings.json matcher:** `".*"` (catches all tools)
- **Unix post-install:** `chmod +x hooks/post-tool-use.sh`

---

### pre-compact
- **Files:** hooks/pre-compact.ps1 / hooks/pre-compact.sh
- **Trigger event:** PreCompact — before Claude compacts the context window
- **Purpose:** Save a state snapshot before compaction wipes working memory.
- **Produces:**
  - `.claude/logs/compact.log`
  - `.claude/logs/pre-compact-state.md` — includes last SESSION_LOG entry + git status
- **Priority:** MEDIUM — important for long sessions or complex work
- **Settings.json matcher:** `"PreCompact"` (special event, not a tool name)
- **Unix post-install:** `chmod +x hooks/pre-compact.sh`

---

## settings.json Configuration Template

> **Path rules:**
> - **Per-project** (`[PROJECT_ROOT]/.claude/settings.json`): use relative paths like `hooks/pre-tool-use.ps1` — they resolve from the project root.
> - **Global** (`C:/Users/[You]/.claude/settings.json`): **must use absolute paths.** Relative paths fail because there is no guaranteed working directory. Example: `C:/AROG/Claude-Free/claude-framework/hooks/pre-tool-use.ps1`

The global `~/.claude/settings.json` for this machine already uses absolute paths and is correctly wired.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File hooks/pre-tool-use.ps1"
          }
        ]
      },
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File hooks/pre-tool-use.ps1"
          }
        ]
      },
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File hooks/pre-tool-use.ps1"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File hooks/post-tool-use.ps1"
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File hooks/pre-compact.ps1"
          }
        ]
      }
    ]
  }
}
```

> **Unix note:** Replace `powershell -NoProfile -ExecutionPolicy Bypass -File hooks/X.ps1`
> with `bash hooks/X.sh` for each entry. Run `chmod +x hooks/*.sh` after installation.
