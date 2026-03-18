# Post-tool-use hook that tracks edited files for session memory
# Runs after Edit, Write tools complete successfully

$ErrorActionPreference = "Stop"

# Read tool information from stdin
$toolInfo = [Console]::In.ReadToEnd() | ConvertFrom-Json

# Extract tool name, file path, and session ID
$toolName = $toolInfo.tool_name
$filePath = $toolInfo.tool_input.file_path
$sessionId = $toolInfo.session_id

# Skip if not an edit tool or no file path
if ($toolName -notmatch '^(Edit|Write)$' -or [string]::IsNullOrEmpty($filePath)) {
    exit 0
}

# Skip markdown files in .claude directory
if ($filePath -match '\.claude\\.*\.md$') {
    exit 0
}

# Create session tracking directory
$projectDir = $env:CLAUDE_PROJECT_DIR
$cacheDir = Join-Path $projectDir ".claude\history\sessions\$sessionId"
if (-not (Test-Path $cacheDir)) {
    New-Item -ItemType Directory -Path $cacheDir -Force | Out-Null
}

# Log edited file with timestamp
$timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
$logEntry = "$timestamp`:$filePath"
Add-Content -Path (Join-Path $cacheDir "edited-files.log") -Value $logEntry

# Keep a simple list of unique files edited this session
$filesListPath = Join-Path $cacheDir "files-list.txt"
if (Test-Path $filesListPath) {
    $existingFiles = Get-Content $filesListPath
    if ($existingFiles -notcontains $filePath) {
        Add-Content -Path $filesListPath -Value $filePath
    }
} else {
    Set-Content -Path $filesListPath -Value $filePath
}

# Count total edits
$editCount = (Get-Content (Join-Path $cacheDir "edited-files.log") | Measure-Object).Count
Set-Content -Path (Join-Path $cacheDir "edit-count.txt") -Value $editCount

# Exit cleanly
exit 0
