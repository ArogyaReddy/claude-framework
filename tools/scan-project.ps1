# =============================================================================
# scan-project.ps1
# Scans a target project and writes PROJECT_SCAN_RAW.md with raw filesystem facts.
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File scan-project.ps1 -ProjectPath "C:/path/to/project"
# Optional: -FrameworkPath "C:/path/to/framework"
# =============================================================================

param(
    [Parameter(Mandatory=$true)]  [string]$ProjectPath,
    [Parameter(Mandatory=$false)] [string]$FrameworkPath = ""
)

$ErrorActionPreference = "SilentlyContinue"

# Validate
if (-not (Test-Path $ProjectPath)) {
    Write-Error "ERROR: ProjectPath does not exist: $ProjectPath"
    exit 1
}

$ProjectPath = (Resolve-Path $ProjectPath).Path
$OutputFile  = Join-Path $ProjectPath "PROJECT_SCAN_RAW.md"
$Timestamp   = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$ExcludeDirs = @("node_modules", ".git", "dist", "build", "out", "__pycache__", ".venv", "venv", "bin", "obj", ".next", ".nuxt", "coverage", ".cache", "target")

# Helper: build a regex exclude pattern
$ExcludePattern = ($ExcludeDirs | ForEach-Object { [regex]::Escape($_) }) -join "|"

# =============================================================================
# GIT INFO
# =============================================================================
$GitPresent    = "no"
$GitBranch     = "N/A"
$GitStatus     = "N/A"
$GitLastCommit = "N/A"

$rawGitStatus = git -C $ProjectPath status --short 2>$null
if ($null -ne $rawGitStatus) {
    $GitPresent = "yes"
    $GitBranch  = (git -C $ProjectPath rev-parse --abbrev-ref HEAD 2>$null) -replace "`n",""
    if ($rawGitStatus -eq "") {
        $GitStatus = "clean"
    } else {
        $fileCount = ($rawGitStatus | Measure-Object -Line).Lines
        $GitStatus = "dirty ($fileCount uncommitted file(s))"
    }
    $GitLastCommit = (git -C $ProjectPath log -1 --pretty="%h %s" 2>$null) -replace "`n",""
}

# =============================================================================
# TOP-LEVEL STRUCTURE
# =============================================================================
$topLevel = Get-ChildItem -Path $ProjectPath |
    Where-Object { $_.Name -notmatch $ExcludePattern } |
    ForEach-Object {
        if ($_.PSIsContainer) { "  [DIR]  $($_.Name)" }
        else                  { "  [FILE] $($_.Name)" }
    }
$topLevelText = $topLevel -join "`n"

# =============================================================================
# FILE EXTENSION COUNTS
# =============================================================================
$allFiles = Get-ChildItem -Path $ProjectPath -Recurse -File |
    Where-Object { $_.FullName -notmatch ($ExcludeDirs | ForEach-Object { [regex]::Escape($_) } | ForEach-Object { "\\$_\\" }) -and
                   $_.FullName -notmatch ($ExcludeDirs | ForEach-Object { [regex]::Escape($_) } | ForEach-Object { "\\$_$" }) }

# Simpler filter
$allFiles = Get-ChildItem -Path $ProjectPath -Recurse -File | Where-Object {
    $path = $_.FullName -replace "\\", "/"
    $skip = $false
    foreach ($d in $ExcludeDirs) {
        if ($path -match "/$d/") { $skip = $true; break }
    }
    -not $skip
}

$extCounts = $allFiles |
    Where-Object { $_.Extension -ne "" } |
    Group-Object Extension |
    Sort-Object Count -Descending |
    Select-Object -First 20 |
    ForEach-Object { "| $($_.Name.PadRight(12)) | $($_.Count) |" }
$extCountsText = $extCounts -join "`n"

$fileTotal = ($allFiles | Measure-Object).Count

# =============================================================================
# DEPENDENCY MANIFESTS
# =============================================================================
$manifests = @(
    "package.json","yarn.lock","pnpm-lock.yaml",
    "requirements.txt","Pipfile","pyproject.toml","setup.py",
    "go.mod","go.sum",
    "Cargo.toml","Cargo.lock",
    "pom.xml","build.gradle","build.gradle.kts",
    "Gemfile","Gemfile.lock",
    "composer.json",
    "pubspec.yaml",
    "Makefile","CMakeLists.txt"
)

$manifestLines = foreach ($m in $manifests) {
    $found = Test-Path (Join-Path $ProjectPath $m)
    $status = if ($found) { "YES" } else { "no" }
    "- $($m.PadRight(25)) $status"
}

# Check for .csproj and .sln
$csprojCount = (Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.csproj" -ErrorAction SilentlyContinue | Measure-Object).Count
$slnCount    = (Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.sln"    -ErrorAction SilentlyContinue | Measure-Object).Count
$manifestLines += "- *.csproj                   $(if ($csprojCount -gt 0) { "YES ($csprojCount found)" } else { "no" })"
$manifestLines += "- *.sln                      $(if ($slnCount -gt 0) { "YES ($slnCount found)" } else { "no" })"
$manifestText = $manifestLines -join "`n"

# =============================================================================
# AI CONFIG PRESENCE
# =============================================================================
function Check($path) { if (Test-Path $path) { "PRESENT" } else { "absent" } }
function CheckDir($path) {
    if (-not (Test-Path $path)) { return "absent" }
    $count = (Get-ChildItem -Path $path -File -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count
    return "PRESENT ($count file(s))"
}
function ListFiles($path) {
    if (-not (Test-Path $path)) { return "  (none)" }
    $files = Get-ChildItem -Path $path -File | Select-Object -ExpandProperty Name
    if ($files.Count -eq 0) { return "  (empty)" }
    return ($files | ForEach-Object { "  - $_" }) -join "`n"
}

$skillsDir = Join-Path $ProjectPath "skills"
$hooksDir  = Join-Path $ProjectPath "hooks"

$aiConfig = @"
- CLAUDE.md              $(Check (Join-Path $ProjectPath "CLAUDE.md"))
- PROFILE.md             $(Check (Join-Path $ProjectPath "PROFILE.md"))
- SESSION_LOG.md         $(Check (Join-Path $ProjectPath "SESSION_LOG.md"))
- .claude/               $(CheckDir (Join-Path $ProjectPath ".claude"))
  - settings.json        $(Check (Join-Path $ProjectPath ".claude/settings.json"))
  - history/             $(CheckDir (Join-Path $ProjectPath ".claude/history"))
- skills/                $(CheckDir (Join-Path $ProjectPath "skills"))
$(ListFiles $skillsDir)
- hooks/                 $(CheckDir (Join-Path $ProjectPath "hooks"))
$(ListFiles $hooksDir)
- registry/              $(CheckDir (Join-Path $ProjectPath "registry"))
- tools/                 $(CheckDir (Join-Path $ProjectPath "tools"))
- AGENTS.md              $(Check (Join-Path $ProjectPath "AGENTS.md"))
- .cursor/               $(CheckDir (Join-Path $ProjectPath ".cursor"))
- .github/copilot/       $(CheckDir (Join-Path $ProjectPath ".github/copilot"))
"@

# =============================================================================
# WRITE OUTPUT
# =============================================================================
$output = @"
# PROJECT_SCAN_RAW.md
Generated:  $Timestamp
Target:     $ProjectPath
Framework:  $(if ($FrameworkPath) { $FrameworkPath } else { "(not specified)" })
Total files scanned: $fileTotal (after excluding: $($ExcludeDirs -join ', '))

---

## GIT

- Present:     $GitPresent
- Branch:      $GitBranch
- Status:      $GitStatus
- Last commit: $GitLastCommit

---

## TOP-LEVEL STRUCTURE

$topLevelText

---

## FILE EXTENSIONS (top 20 by count)

| Extension   | Count |
|-------------|-------|
$extCountsText

---

## DEPENDENCY MANIFESTS

$manifestText

---

## AI CONFIG PRESENCE

$aiConfig

---

*Raw data only — no analysis. Run project-scan skill to produce PROJECT_SCAN.md.*
"@

Set-Content -Path $OutputFile -Value $output -Encoding UTF8
Write-Output "SCAN: PROJECT_SCAN_RAW.md written to $OutputFile"
Write-Output "SCAN: $fileTotal files found. Now run: Use project-scan skill."
exit 0
