$ErrorActionPreference = "SilentlyContinue"

$projectRoot = Split-Path $PSScriptRoot -Parent
$logsDir = Join-Path $projectRoot ".claude\logs"
$logFile = Join-Path $logsDir "tool-use.log"
$changeLog = Join-Path $logsDir "changes.log"
$sessionLog = Join-Path $logsDir ("session-" + (Get-Date -Format "yyyy-MM-dd") + ".log")

New-Item -ItemType Directory -Path $logsDir -Force | Out-Null

# Read hook data from stdin — Claude Code sends JSON via stdin, not env vars
$inputJson = [Console]::In.ReadToEnd()
$toolName = "unknown"
$toolInput = $null
$toolResult = $null
$toolExitCode = "0"

if ($inputJson -and $inputJson.Trim() -ne "") {
    try {
        $hookData = $inputJson | ConvertFrom-Json
        $toolName = if ($hookData.tool_name) { $hookData.tool_name } else { "unknown" }
        $toolInput = $hookData.tool_input
        $toolResult = $hookData.tool_result
        if ($toolResult -and $null -ne $toolResult.exit_code) {
            $toolExitCode = [string]$toolResult.exit_code
        }
    } catch { }
}

function Write-Log([string]$message) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "[$ts] POST | $toolName | $message"
    Add-Content -Path $sessionLog -Value "[$ts] $toolName | $message"
}

$command = if ($toolInput -and $toolInput.command) { $toolInput.command } else { "" }
$trimmedCmd = if ($command.Length -gt 120) { $command.Substring(0, 120) } else { $command }
Write-Log "exit=$toolExitCode | input=$trimmedCmd"

if ($toolName -eq "Write" -or $toolName -eq "Edit") {
    $filePath = if ($toolInput -and $toolInput.file_path) { $toolInput.file_path } else { "unknown" }
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $changeLog -Value "[$ts] CHANGED: $filePath"
    Write-Log "file changed: $filePath"
}

if ($toolName -eq "Bash" -and $toolExitCode -ne "0") {
    Write-Output "HOOK NOTICE: Command exited with code $toolExitCode"
    Write-Log "FAILED - exit $toolExitCode"
}

if ($toolName -eq "Bash") {
    $stdout = if ($toolResult -and $toolResult.stdout) { $toolResult.stdout } else { "" }
    if ($command -match 'jest|vitest|pytest|npm\s+test|yarn\s+test') {
        if ($stdout -match '(?i)failed|error') {
            Write-Output "HOOK NOTICE: Tests appear to have failures. Review output before continuing."
            Write-Log "TESTS FAILED"
        } else {
            Write-Log "TESTS PASSED"
        }
    }
}

exit 0
