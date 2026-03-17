#!/bin/bash
# =============================================================================
# scan-project.sh
# Scans a target project and writes PROJECT_SCAN_RAW.md with raw filesystem facts.
# Usage: bash scan-project.sh /path/to/project [/path/to/framework]
# =============================================================================

set -euo pipefail

PROJECT_PATH="${1:-}"
FRAMEWORK_PATH="${2:-}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
EXCLUDE_DIRS="node_modules|\.git|dist|build|out|__pycache__|\.venv|venv|bin|obj|\.next|\.nuxt|coverage|\.cache|target"

if [ -z "$PROJECT_PATH" ]; then
    echo "ERROR: ProjectPath argument is required." >&2
    echo "Usage: bash scan-project.sh /path/to/project [/path/to/framework]" >&2
    exit 1
fi

if [ ! -d "$PROJECT_PATH" ]; then
    echo "ERROR: ProjectPath does not exist: $PROJECT_PATH" >&2
    exit 1
fi

PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd)"
OUTPUT_FILE="$PROJECT_PATH/PROJECT_SCAN_RAW.md"

# =============================================================================
# GIT INFO
# =============================================================================
GIT_PRESENT="no"
GIT_BRANCH="N/A"
GIT_STATUS="N/A"
GIT_LAST_COMMIT="N/A"

if git -C "$PROJECT_PATH" status --short &>/dev/null; then
    GIT_PRESENT="yes"
    GIT_BRANCH=$(git -C "$PROJECT_PATH" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    RAW_STATUS=$(git -C "$PROJECT_PATH" status --short 2>/dev/null)
    if [ -z "$RAW_STATUS" ]; then
        GIT_STATUS="clean"
    else
        FILE_COUNT=$(echo "$RAW_STATUS" | wc -l | tr -d ' ')
        GIT_STATUS="dirty ($FILE_COUNT uncommitted file(s))"
    fi
    GIT_LAST_COMMIT=$(git -C "$PROJECT_PATH" log -1 --pretty="%h %s" 2>/dev/null || echo "N/A")
fi

# =============================================================================
# TOP-LEVEL STRUCTURE
# =============================================================================
TOP_LEVEL=$(ls -1 "$PROJECT_PATH" | grep -vE "^($EXCLUDE_DIRS)$" | while read -r item; do
    if [ -d "$PROJECT_PATH/$item" ]; then
        echo "  [DIR]  $item"
    else
        echo "  [FILE] $item"
    fi
done)

# =============================================================================
# FILE EXTENSION COUNTS (top 20)
# =============================================================================
EXT_COUNTS=$(find "$PROJECT_PATH" -type f \
    | grep -vE "/($EXCLUDE_DIRS)/" \
    | awk -F. 'NF>1{print "."$NF}' \
    | sort | uniq -c | sort -rn \
    | head -20 \
    | awk '{printf "| %-12s | %s |\n", $2, $1}')

FILE_TOTAL=$(find "$PROJECT_PATH" -type f | grep -vE "/($EXCLUDE_DIRS)/" | wc -l | tr -d ' ')

# =============================================================================
# DEPENDENCY MANIFESTS
# =============================================================================
check_manifest() {
    local name="$1"
    if [ -f "$PROJECT_PATH/$name" ]; then echo "YES"; else echo "no"; fi
}

# Count .csproj and .sln
CSPROJ_COUNT=$(find "$PROJECT_PATH" -name "*.csproj" 2>/dev/null | wc -l | tr -d ' ')
SLN_COUNT=$(find "$PROJECT_PATH" -name "*.sln" 2>/dev/null | wc -l | tr -d ' ')

# =============================================================================
# AI CONFIG PRESENCE
# =============================================================================
check_item() {
    local path="$1"
    if [ -e "$path" ]; then echo "PRESENT"; else echo "absent"; fi
}

check_dir_count() {
    local path="$1"
    if [ ! -d "$path" ]; then
        echo "absent"
        return
    fi
    local count
    count=$(find "$path" -type f 2>/dev/null | wc -l | tr -d ' ')
    echo "PRESENT ($count file(s))"
}

list_files() {
    local path="$1"
    if [ ! -d "$path" ]; then echo "  (none)"; return; fi
    local files
    files=$(ls -1 "$path" 2>/dev/null | head -20)
    if [ -z "$files" ]; then echo "  (empty)"; return; fi
    echo "$files" | while read -r f; do echo "  - $f"; done
}

# =============================================================================
# WRITE OUTPUT
# =============================================================================
cat > "$OUTPUT_FILE" << EOF
# PROJECT_SCAN_RAW.md
Generated:  $TIMESTAMP
Target:     $PROJECT_PATH
Framework:  ${FRAMEWORK_PATH:-(not specified)}
Total files scanned: $FILE_TOTAL (after excluding: node_modules, .git, dist, build, etc.)

---

## GIT

- Present:     $GIT_PRESENT
- Branch:      $GIT_BRANCH
- Status:      $GIT_STATUS
- Last commit: $GIT_LAST_COMMIT

---

## TOP-LEVEL STRUCTURE

$TOP_LEVEL

---

## FILE EXTENSIONS (top 20 by count)

| Extension   | Count |
|-------------|-------|
$EXT_COUNTS

---

## DEPENDENCY MANIFESTS

- package.json             $(check_manifest "package.json")
- yarn.lock                $(check_manifest "yarn.lock")
- pnpm-lock.yaml           $(check_manifest "pnpm-lock.yaml")
- requirements.txt         $(check_manifest "requirements.txt")
- Pipfile                  $(check_manifest "Pipfile")
- pyproject.toml           $(check_manifest "pyproject.toml")
- setup.py                 $(check_manifest "setup.py")
- go.mod                   $(check_manifest "go.mod")
- go.sum                   $(check_manifest "go.sum")
- Cargo.toml               $(check_manifest "Cargo.toml")
- pom.xml                  $(check_manifest "pom.xml")
- build.gradle             $(check_manifest "build.gradle")
- Gemfile                  $(check_manifest "Gemfile")
- composer.json            $(check_manifest "composer.json")
- pubspec.yaml             $(check_manifest "pubspec.yaml")
- Makefile                 $(check_manifest "Makefile")
- CMakeLists.txt           $(check_manifest "CMakeLists.txt")
- *.csproj                 $(if [ "$CSPROJ_COUNT" -gt 0 ]; then echo "YES ($CSPROJ_COUNT found)"; else echo "no"; fi)
- *.sln                    $(if [ "$SLN_COUNT" -gt 0 ]; then echo "YES ($SLN_COUNT found)"; else echo "no"; fi)

---

## AI CONFIG PRESENCE

- CLAUDE.md              $(check_item "$PROJECT_PATH/CLAUDE.md")
- PROFILE.md             $(check_item "$PROJECT_PATH/PROFILE.md")
- SESSION_LOG.md         $(check_item "$PROJECT_PATH/SESSION_LOG.md")
- .claude/               $(check_dir_count "$PROJECT_PATH/.claude")
  - settings.json        $(check_item "$PROJECT_PATH/.claude/settings.json")
  - history/             $(check_dir_count "$PROJECT_PATH/.claude/history")
- skills/                $(check_dir_count "$PROJECT_PATH/skills")
$(list_files "$PROJECT_PATH/skills")
- hooks/                 $(check_dir_count "$PROJECT_PATH/hooks")
$(list_files "$PROJECT_PATH/hooks")
- registry/              $(check_dir_count "$PROJECT_PATH/registry")
- tools/                 $(check_dir_count "$PROJECT_PATH/tools")
- AGENTS.md              $(check_item "$PROJECT_PATH/AGENTS.md")
- .cursor/               $(check_dir_count "$PROJECT_PATH/.cursor")
- .github/copilot/       $(check_dir_count "$PROJECT_PATH/.github/copilot")

---

*Raw data only — no analysis. Run project-scan skill to produce PROJECT_SCAN.md.*
EOF

echo "SCAN: PROJECT_SCAN_RAW.md written to $OUTPUT_FILE"
echo "SCAN: $FILE_TOTAL files found. Now run: Use project-scan skill."
exit 0
