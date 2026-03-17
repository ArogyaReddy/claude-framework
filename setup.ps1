#Requires -Version 5.1
<#
.SYNOPSIS
    Claude Framework — Interactive Setup
.DESCRIPTION
    Sets up the Claude Code framework on this machine:
    1. Detects FRAMEWORK_PATH from this script's location
    2. Prompts for PROFILE.md fields (name, role, stack, etc.)
    3. Creates/updates: ~/.claude/CLAUDE.md, PROFILE.md, SESSION_LOG.md,
       .claude/history/, .claude/settings.json
    4. Never overwrites existing files
    5. Runs a verification check at the end
.NOTES
    Run from PowerShell: .\setup.ps1
    Safe to run multiple times — skips anything already present.
#>

param(
    [switch]$SkipProfile,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

# ─── Helpers ──────────────────────────────────────────────────────────

function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "  $('─' * ($Text.Length + 2))" -ForegroundColor DarkGray
}

function Write-Status {
    param([string]$File, [string]$Status)
    $color = if ($Status -like "CREATED*" -or $Status -like "UPDATED*") { "Green" }
             elseif ($Status -like "SKIPPED*" -or $Status -like "WOULD*") { "Yellow" }
             elseif ($Status -like "FAILED*") { "Red" }
             else { "Gray" }
    $padding = 42 - $File.Length
    if ($padding -lt 1) { $padding = 1 }
    Write-Host "  $File$(' ' * $padding)" -NoNewline
    Write-Host $Status -ForegroundColor $color
}

function Prompt-Field {
    param([string]$Label, [string]$Default)
    if ($Default) {
        Write-Host "  $Label " -NoNewline -ForegroundColor White
        Write-Host "[$Default]" -NoNewline -ForegroundColor DarkGray
        Write-Host ": " -NoNewline
    } else {
        Write-Host "  ${Label}: " -NoNewline -ForegroundColor White
    }
    $val = Read-Host
    if ([string]::IsNullOrWhiteSpace($val) -and $Default) { return $Default }
    if ([string]::IsNullOrWhiteSpace($val)) { return "" }
    return $val.Trim()
}

function Safe-WriteFile {
    param([string]$Path, [string]$Content, [switch]$Force)
    if ((Test-Path $Path) -and -not $Force) {
        Write-Status $Path "SKIPPED [exists]"
        return $false
    }
    if ($DryRun) {
        Write-Status $Path "WOULD CREATE [dry-run]"
        return $false
    }
    $dir = Split-Path $Path -Parent
    if ($dir -and -not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Content, [System.Text.Encoding]::UTF8)
    Write-Status $Path "CREATED"
    return $true
}

# ─── Banner ───────────────────────────────────────────────────────────

Clear-Host
Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "  ║       CLAUDE FRAMEWORK — SETUP                ║" -ForegroundColor Green
Write-Host "  ╚═══════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

# ─── Step 0 — Detect framework path ──────────────────────────────────

$FRAMEWORK_PATH = Split-Path $MyInvocation.MyCommand.Path -Parent

# Normalize to forward slashes for CLAUDE.md
$FRAMEWORK_PATH_UNIX = $FRAMEWORK_PATH -replace '\\', '/'

Write-Host "  Framework path: " -NoNewline -ForegroundColor Gray
Write-Host $FRAMEWORK_PATH_UNIX -ForegroundColor White
Write-Host ""

$GLOBAL_CLAUDE_DIR = Join-Path $env:USERPROFILE ".claude"
$GLOBAL_CLAUDE_MD  = Join-Path $GLOBAL_CLAUDE_DIR "CLAUDE.md"
$PROFILE_MD        = Join-Path $FRAMEWORK_PATH "PROFILE.md"
$SESSION_LOG       = Join-Path $FRAMEWORK_PATH "SESSION_LOG.md"
$HISTORY_DIR       = Join-Path $FRAMEWORK_PATH ".claude" "history"
$SETTINGS_JSON     = Join-Path $FRAMEWORK_PATH ".claude" "settings.json"
$ARCHIVE_DIR       = Join-Path $FRAMEWORK_PATH ".claude" "archive"

# ─── Step 1 — Collect profile info ───────────────────────────────────

if (-not $SkipProfile) {
    Write-Header "STEP 1/3 — YOUR PROFILE"
    Write-Host "  These answers fill in PROFILE.md — Claude uses this to" -ForegroundColor DarkGray
    Write-Host "  communicate in your style and make relevant recommendations." -ForegroundColor DarkGray
    Write-Host ""

    $userName      = Prompt-Field "Your name"
    $userRole      = Prompt-Field "Your role" "Software Engineer"
    $userStack     = Prompt-Field "Primary language/stack" "JavaScript, React, Node.js"
    $userProject   = Prompt-Field "Current project name" "General"
    $userProjectDesc = Prompt-Field "What are you building? (1 sentence)"
    $userTeam      = Prompt-Field "Team context" "Solo contributor"
    $userLevel     = Prompt-Field "Experience level" "Mid-level"
    $userStrongest = Prompt-Field "Strongest areas" "Frontend, debugging"
    $userLearning  = Prompt-Field "Currently learning" "AI tooling, system design"
    $userTone      = Prompt-Field "Preferred tone" "Peer-to-peer, concise"
} else {
    Write-Host "  Skipping profile collection (--SkipProfile)" -ForegroundColor Yellow
}

# ─── Step 2 — Install files ──────────────────────────────────────────

Write-Header "STEP 2/3 — INSTALLING"

# 2a. Global ~/.claude/CLAUDE.md
$globalContent = (Get-Content (Join-Path $FRAMEWORK_PATH "tools" "templates" "global-claude.md.template") -Raw -ErrorAction SilentlyContinue)
if (-not $globalContent) {
    # Build from scratch if template missing
    $globalContent = @'
# Global Claude Code Configuration
# Loaded by Claude Code for EVERY project on this machine.
# Project-level CLAUDE.md overrides these defaults where they conflict.
# Do not delete this file -- it activates the shared framework for all sessions.

---

## Framework Location

FRAMEWORK_PATH: __FRAMEWORK_PATH__

---

## Session Startup Protocol (Global)

At the start of every session, silently:

1. Check if this project has a local CLAUDE.md.
   - If YES: read it -- its rules override these defaults.
   - If NO: this project has no AI framework config.
     Immediately tell the user:
     "This project has no CLAUDE.md. Run `Use project-scan skill on [current path].` to analyse it and set up the framework."

2. If PROFILE.md exists in project root: read it silently.
   If NOT: read FRAMEWORK_PATH/PROFILE.md silently.

3. If SESSION_LOG.md exists in project root: read the most recent entry silently.

4. Do not announce what you have read. Just use the context.

---

## Security Floor (Cannot be Overridden by Any Project CLAUDE.md)

These rules apply in every session, on every project, always:

- Never write to `.env` files via any tool.
- Never execute: `rm -rf`, `DROP TABLE`, `DROP DATABASE`, `TRUNCATE` without explicit per-session approval.
- Never `git push --force` to main or master.
- Never install packages (`npm install`, `pip install`, `yarn add`, etc.) without explicit per-session approval.
- Never commit or push without explicit instruction.
- Never overwrite a file that already exists unless the user explicitly asks for it.

---

## Global Output Defaults

- Responses: concise and direct.
- Default format: bullet list for enumerations, prose for explanations -- never both unsolicited.
- Length: as short as correct allows.
- `<format>`, `<length>`, `<sections>` tags in any prompt override all defaults.

---

## Framework Skills (Available in Any Project)

All skills live at FRAMEWORK_PATH/skills/. Invoke by name from any project.

### Onboarding a new project
- `project-scan`     -- scan any project -> produce PROJECT_SCAN.md gap report
- `framework-apply`  -- install chosen components into the project

### Every session
- `scope-guard`      -- prevent scope creep (use on every coding task)
- `debug-first`      -- diagnose before fixing
- `session-closer`   -- capture session knowledge (say: "close the session")

### Code quality
- `code-review`           -- review against defined rules
- `change-manifest`       -- record exactly what changed and why
- `spec-to-task`          -- convert spec file -> sequenced task list

### Output control
- `output-control`        -- explicit length and format via XML tags
- `structured-response`   -- section-divided labeled output
- `followup-refine`       -- depth-then-condense for two audiences
- `minimal-output`        -- code-only, no narration

### Diagnostics
- `healthcheck`           -- 12-point framework health diagnostic
- `decision-log`          -- formal Architecture Decision Records

### Safety
- `safe-cleanup-with-backup`   -- backup before any destructive deletion
- `duplicate-structure-audit`  -- find and classify duplicate folders

---

## Onboarding Any New Project -- Quick Reference

```
Step 1:  "Use project-scan skill on [absolute path to project]"
Step 2:  Review PROJECT_SCAN.md written to that project's root
Step 3:  "Use framework-apply skill."
Step 4:  Follow manual steps in the apply report
```

---

## Registries (Reference These When Asked)

- Skills:   FRAMEWORK_PATH/registry/skills-registry.md
- Hooks:    FRAMEWORK_PATH/registry/hooks-registry.md
- Patterns: FRAMEWORK_PATH/registry/patterns-registry.md
- Prompts:  FRAMEWORK_PATH/prompts/golden-prompts.md
'@
}
$globalContent = $globalContent -replace '__FRAMEWORK_PATH__', $FRAMEWORK_PATH_UNIX

Safe-WriteFile -Path $GLOBAL_CLAUDE_MD -Content $globalContent

# 2b. PROFILE.md (update if profile was collected, skip if --SkipProfile)
if (-not $SkipProfile -and $userName) {
    $profileContent = @'
# PROFILE.md -- My Identity & Working Style

> This file is read by Claude at the start of every session.
> It tells Claude who I am, how I think, and how to write *as me* or *for me*.

---

## Who I Am

- **Name:** __NAME__
- **Role:** __ROLE__
- **Current Project:** __PROJECT__ -- __PROJECT_DESC__
- **Team context:** __TEAM__
- **Experience level:** __LEVEL__

---

## Technical Background

- **Primary languages:** __STACK__
- **Tools I use:** Claude Code, VS Code, Git
- **Strongest areas:** __STRONGEST__
- **Areas I'm actively learning:** __LEARNING__

---

## Communication Style

- **When explaining things to me:** Be direct and specific. Use examples over abstract descriptions.
- **Tone I prefer:** __TONE__
- **What I dislike:** Long preambles, over-cautious disclaimers, repeating what I just said back to me.
- **When I ask a question:** I want the answer first, context second.

---

## Decision Patterns

> Claude should check these before making architectural or approach recommendations.

- I prefer **simple solutions over clever ones** -- the minimum that is correct.
- I prefer **editing existing files** over creating new ones.
- I prefer **understanding the problem** before jumping to a fix.
- I am **cost-conscious with tokens** -- keep prompts lean, responses tight.
- I prefer **explicit over implicit** -- if something needs a decision, surface it to me.

---

## Writing Style (when Claude writes *for* me)

- First person, direct.
- Short sentences. No filler words.
- No "I believe" or "I think" -- just state the thing.
- No closing motivational statements.

---

## Current Focus Area

__PROJECT__ -- __PROJECT_DESC__

---

## Notes / Things Claude Should Always Remember

- (Add anything Claude keeps forgetting or getting wrong across sessions)
'@
    $profileContent = $profileContent -replace '__NAME__', $userName
    $profileContent = $profileContent -replace '__ROLE__', $userRole
    $profileContent = $profileContent -replace '__PROJECT__', $userProject
    $profileContent = $profileContent -replace '__PROJECT_DESC__', $userProjectDesc
    $profileContent = $profileContent -replace '__TEAM__', $userTeam
    $profileContent = $profileContent -replace '__LEVEL__', $userLevel
    $profileContent = $profileContent -replace '__STACK__', $userStack
    $profileContent = $profileContent -replace '__STRONGEST__', $userStrongest
    $profileContent = $profileContent -replace '__LEARNING__', $userLearning
    $profileContent = $profileContent -replace '__TONE__', $userTone

    if ($DryRun) {
        Write-Status "PROFILE.md" "WOULD UPDATE [dry-run]"
    } else {
        [System.IO.File]::WriteAllText($PROFILE_MD, $profileContent, [System.Text.Encoding]::UTF8)
        Write-Status "PROFILE.md" "UPDATED"
    }
} else {
    Write-Status "PROFILE.md" "SKIPPED [no input]"
}

# 2c. SESSION_LOG.md
$sessionLogContent = @'
# SESSION_LOG.md -- Running Session History

> Newest session first. Max 20 lines per entry.
> Updated by the session-closer skill at the end of each work block.
> Claude reads this at the start of each session to recover context instantly.
'@

Safe-WriteFile -Path $SESSION_LOG -Content $sessionLogContent

# 2d. .claude/history/ files
$decisionsContent = @'
# Decisions Log

> Architectural, tooling, and approach decisions made across sessions.
> Updated by the session-closer skill. Read by Claude before making similar decisions.
> Format: Date | Decision | Reason | Alternatives Rejected
'@

$learningsContent = @'
# Learnings Log

> Codebase facts, tool behaviours, and environment discoveries across sessions.
> Updated by the session-closer skill. Read by Claude to avoid re-discovering.
> Format: Date | Learning | Context | Applies To
'@

$patternsContent = @'
# Patterns Log

> Good/bad/watch patterns noticed across sessions.
> Updated by the session-closer skill. Claude references these for improvement.
> Format: Pattern | Classification (GOOD/BAD/WATCH) | First Seen | Action
'@

Safe-WriteFile -Path (Join-Path $HISTORY_DIR "decisions.md") -Content $decisionsContent
Safe-WriteFile -Path (Join-Path $HISTORY_DIR "learnings.md") -Content $learningsContent
Safe-WriteFile -Path (Join-Path $HISTORY_DIR "patterns.md") -Content $patternsContent

# 2e. .claude/archive/ directory
if (-not (Test-Path $ARCHIVE_DIR)) {
    if (-not $DryRun) {
        New-Item -ItemType Directory -Path $ARCHIVE_DIR -Force | Out-Null
    }
    Write-Status ".claude/archive/" "CREATED"
} else {
    Write-Status ".claude/archive/" "SKIPPED [exists]"
}

# 2f. .claude/settings.json (hook wiring)
$hooksRelPath = "hooks"
$settingsContent = @'
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"__FW_PATH__/hooks/pre-tool-use.ps1\""
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
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"__FW_PATH__/hooks/post-tool-use.ps1\""
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
            "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"__FW_PATH__/hooks/pre-compact.ps1\""
          }
        ]
      }
    ]
  }
}
'@
$settingsContent = $settingsContent -replace '__FW_PATH__', $FRAMEWORK_PATH_UNIX

Safe-WriteFile -Path $SETTINGS_JSON -Content $settingsContent

# ─── Step 3 — Verification ───────────────────────────────────────────

Write-Header "STEP 3/3 — VERIFICATION"

$pass = 0; $warn = 0; $fail = 0

function Check {
    param([string]$Name, [bool]$Condition)
    $padding = 40 - $Name.Length
    if ($padding -lt 1) { $padding = 1 }
    if ($Condition) {
        Write-Host "  $Name$(' ' * $padding)" -NoNewline
        Write-Host "[PASS]" -ForegroundColor Green
        $script:pass++
    } else {
        Write-Host "  $Name$(' ' * $padding)" -NoNewline
        Write-Host "[FAIL]" -ForegroundColor Red
        $script:fail++
    }
}

Check "~/.claude/CLAUDE.md exists"       (Test-Path $GLOBAL_CLAUDE_MD)
Check "PROFILE.md exists"                (Test-Path $PROFILE_MD)
Check "SESSION_LOG.md exists"            (Test-Path $SESSION_LOG)
Check ".claude/history/decisions.md"     (Test-Path (Join-Path $HISTORY_DIR "decisions.md"))
Check ".claude/history/learnings.md"     (Test-Path (Join-Path $HISTORY_DIR "learnings.md"))
Check ".claude/history/patterns.md"      (Test-Path (Join-Path $HISTORY_DIR "patterns.md"))
Check ".claude/settings.json exists"     (Test-Path $SETTINGS_JSON)
Check ".claude/archive/ exists"          (Test-Path $ARCHIVE_DIR)
Check "hooks/ has 6 scripts"            ((Get-ChildItem (Join-Path $FRAMEWORK_PATH "hooks") -Filter "*.ps1" -ErrorAction SilentlyContinue).Count + (Get-ChildItem (Join-Path $FRAMEWORK_PATH "hooks") -Filter "*.sh" -ErrorAction SilentlyContinue).Count -ge 6)
Check "skills/ has 5+ skills"          ((Get-ChildItem (Join-Path $FRAMEWORK_PATH "skills") -Filter "*.md" -ErrorAction SilentlyContinue).Count -ge 5)
Check "CLAUDE.md exists"                (Test-Path (Join-Path $FRAMEWORK_PATH "CLAUDE.md"))

# Check PROFILE.md is filled in (no [Your name] placeholder)
$profileText = ""
if (Test-Path $PROFILE_MD) { $profileText = Get-Content $PROFILE_MD -Raw }
$profileFilled = $profileText -notmatch '\[Your name\]'
Check "PROFILE.md configured"           $profileFilled

Write-Host ""
Write-Host "  ─────────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host "  PASS: $pass   FAIL: $fail" -ForegroundColor $(if ($fail -eq 0) { "Green" } else { "Yellow" })
Write-Host ""

# ─── Summary ──────────────────────────────────────────────────────────

if ($fail -eq 0) {
    Write-Host "  ╔═══════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "  ║  FRAMEWORK READY                              ║" -ForegroundColor Green
    Write-Host "  ╚═══════════════════════════════════════════════╝" -ForegroundColor Green
} else {
    Write-Host "  ╔═══════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "  ║  SETUP COMPLETE - $fail item(s) need attention   ║" -ForegroundColor Yellow
    Write-Host "  ╚═══════════════════════════════════════════════╝" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  NEXT STEPS:" -ForegroundColor Cyan
Write-Host "  1. Open Claude Code in any project" -ForegroundColor White
Write-Host "  2. Say: " -NoNewline -ForegroundColor White
Write-Host "`"Use project-scan skill on [path to your project]`"" -ForegroundColor Green
Write-Host "  3. Review the PROJECT_SCAN.md it creates" -ForegroundColor White
Write-Host "  4. Say: " -NoNewline -ForegroundColor White
Write-Host "`"Use framework-apply skill.`"" -ForegroundColor Green
Write-Host "  5. Say: " -NoNewline -ForegroundColor White
Write-Host "`"Use healthcheck skill.`"" -ForegroundColor Green
Write-Host "     to verify everything is wired correctly" -ForegroundColor White
Write-Host ""
Write-Host "  At the end of every work session, say: " -NoNewline -ForegroundColor DarkGray
Write-Host "`"close the session`"" -ForegroundColor Green
Write-Host ""
