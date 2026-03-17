$ErrorActionPreference = "SilentlyContinue"

$projectRoot = Split-Path $PSScriptRoot -Parent
$logsDir = Join-Path $projectRoot ".claude\logs"
$logFile = Join-Path $logsDir "tool-use.log"

New-Item -ItemType Directory -Path $logsDir -Force | Out-Null

# Read hook data from stdin — Claude Code sends JSON via stdin, not env vars
$inputJson = [Console]::In.ReadToEnd()
$toolName = "unknown"
$toolInput = $null

if ($inputJson -and $inputJson.Trim() -ne "") {
    try {
        $hookData = $inputJson | ConvertFrom-Json
        $toolName = if ($hookData.tool_name) { $hookData.tool_name } else { "unknown" }
        $toolInput = $hookData.tool_input
    } catch { }
}

function Write-Log([string]$message) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "[$ts] PRE  | $toolName | $message"
}

if ($toolName -eq "Bash") {
    $command = if ($toolInput -and $toolInput.command) { $toolInput.command } else { "" }

    $dangerousPatterns = @(
        'rm\s+-rf',
        'DROP\s+TABLE',
        'DROP\s+DATABASE',
        'TRUNCATE',
        'git\s+push\s+--force',
        'git\s+push\s+-f',
        'chmod\s+777',
        'sudo\s+rm',
        'mkfs',
        'dd\s+if=',
        'curl.*\|\s*bash',
        'wget.*\|\s*bash',
        'eval\s*\$\('
    )

    foreach ($pattern in $dangerousPatterns) {
        if ($command -match $pattern) {
            Write-Output "HOOK BLOCKED: Dangerous pattern detected: '$pattern'"
            Write-Log "BLOCKED - pattern: $pattern"
            exit 1
        }
    }

    if ($command -match 'NODE_ENV=production|--env=production|env\s+prod') {
        Write-Output "HOOK WARNING: Production environment operation detected."
        Write-Log "WARNED - production env operation"
    }

    if ($command -match 'npm\s+install|yarn\s+add|pnpm\s+add|pip\s+install') {
        Write-Output "HOOK BLOCKED: Package installation requires explicit approval."
        Write-Log "BLOCKED - package install attempt: $command"
        exit 1
    }

    Write-Log "ALLOWED - $command"
}

if ($toolName -eq "Write" -or $toolName -eq "Edit") {
    $filePath = if ($toolInput -and $toolInput.file_path) { $toolInput.file_path } else { "" }
    if ($filePath -match '\.env') {
        Write-Output "HOOK BLOCKED: Modifications to .env files are not permitted via Claude."
        Write-Log "BLOCKED - .env write attempt: $filePath"
        exit 1
    }
    Write-Log "ALLOWED - write to: $filePath"
}

exit 0
