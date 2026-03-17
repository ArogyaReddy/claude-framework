$ErrorActionPreference = "SilentlyContinue"

$projectRoot = Split-Path $PSScriptRoot -Parent
$logsDir = Join-Path $projectRoot ".claude\logs"
$historyDir = Join-Path $projectRoot ".claude\history"
$compactLog = Join-Path $logsDir "compact.log"
$changeLog = Join-Path $logsDir "changes.log"
$snapshot = Join-Path $logsDir "pre-compact-state.md"
$sessionLog = Join-Path $projectRoot "SESSION_LOG.md"

New-Item -ItemType Directory -Path $logsDir -Force | Out-Null

$ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $compactLog -Value "[$ts] PRE-COMPACT triggered"

$changes = if (Test-Path $changeLog) { Get-Content $changeLog -Raw } else { "No change log found." }
$gitStatus = git status --short 2>$null
if (-not $gitStatus) { $gitStatus = "Not a git repo or git unavailable." }

# Capture last SESSION_LOG entry (first 25 lines after the first ### heading)
$lastSession = "SESSION_LOG.md not found."
if (Test-Path $sessionLog) {
    $lines = Get-Content $sessionLog
    $start = ($lines | Select-String -Pattern "^###" | Select-Object -First 1).LineNumber
    if ($start) {
        $lastSession = ($lines | Select-Object -Skip ($start - 1) -First 25) -join "`n"
    }
}

$content = @"
# Pre-Compact State Snapshot
Generated: $ts

## Files Changed This Session
$changes

## Current Git Status
$gitStatus

## Last Session Log Entry
$lastSession

## Reminder for Post-Compact
After compaction, Claude should:
1. Re-read CLAUDE.md
2. Re-read PROFILE.md
3. Re-read SESSION_LOG.md (last entry)
4. Check .claude/history/decisions.md before making architectural decisions
5. Check this snapshot for what was in progress
6. Ask the user to re-confirm the current task if unclear
"@

Set-Content -Path $snapshot -Value $content
Write-Output "HOOK: Pre-compact snapshot saved to $snapshot"

exit 0