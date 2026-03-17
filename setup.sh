#!/usr/bin/env bash
#
# Claude Framework — Interactive Setup (Unix/macOS)
#
# Sets up the Claude Code framework on this machine:
# 1. Detects FRAMEWORK_PATH from this script's location
# 2. Prompts for PROFILE.md fields (name, role, stack, etc.)
# 3. Creates/updates: ~/.claude/CLAUDE.md, PROFILE.md, SESSION_LOG.md,
#    .claude/history/, .claude/settings.json
# 4. Never overwrites existing files
# 5. Runs a verification check at the end
#
# Usage: chmod +x setup.sh && ./setup.sh
# Flags: --skip-profile  Skip profile questions
#        --dry-run       Show what would happen without writing files

set -euo pipefail

# ─── Parse flags ──────────────────────────────────────────────────────

SKIP_PROFILE=false
DRY_RUN=false
for arg in "$@"; do
    case "$arg" in
        --skip-profile) SKIP_PROFILE=true ;;
        --dry-run)      DRY_RUN=true ;;
    esac
done

# ─── Colors ───────────────────────────────────────────────────────────

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

# ─── Helpers ──────────────────────────────────────────────────────────

write_header() {
    echo ""
    echo -e "  ${CYAN}$1${NC}"
    printf "  ${GRAY}"; printf '─%.0s' $(seq 1 $((${#1} + 2))); echo -e "${NC}"
}

write_status() {
    local file="$1" status="$2"
    local color="$GRAY"
    case "$status" in
        CREATED|UPDATED) color="$GREEN" ;;
        SKIPPED*)        color="$YELLOW" ;;
        FAILED)          color="$RED" ;;
    esac
    printf "  %-42s" "$file"
    echo -e "${color}${status}${NC}"
}

prompt_field() {
    local label="$1" default="${2:-}"
    if [ -n "$default" ]; then
        printf "  ${WHITE}%s${NC} ${GRAY}[%s]${NC}: " "$label" "$default"
    else
        printf "  ${WHITE}%s${NC}: " "$label"
    fi
    read -r val
    val="${val:-$default}"
    echo "$val"
}

safe_write_file() {
    local path="$1" content="$2" force="${3:-false}"
    if [ -f "$path" ] && [ "$force" != "true" ]; then
        write_status "$path" "SKIPPED (exists)"
        return 1
    fi
    if [ "$DRY_RUN" = true ]; then
        write_status "$path" "WOULD CREATE (dry-run)"
        return 1
    fi
    local dir
    dir=$(dirname "$path")
    [ -d "$dir" ] || mkdir -p "$dir"
    echo "$content" > "$path"
    write_status "$path" "CREATED"
    return 0
}

# ─── Banner ───────────────────────────────────────────────────────────

clear 2>/dev/null || true
echo ""
echo -e "  ${GREEN}╔═══════════════════════════════════════════════╗${NC}"
echo -e "  ${GREEN}║       CLAUDE FRAMEWORK — SETUP                ║${NC}"
echo -e "  ${GREEN}╚═══════════════════════════════════════════════╝${NC}"
echo ""

# ─── Step 0 — Detect framework path ──────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_PATH="$SCRIPT_DIR"

echo -e "  ${GRAY}Framework path:${NC} ${WHITE}$FRAMEWORK_PATH${NC}"
echo ""

GLOBAL_CLAUDE_DIR="$HOME/.claude"
GLOBAL_CLAUDE_MD="$GLOBAL_CLAUDE_DIR/CLAUDE.md"
PROFILE_MD="$FRAMEWORK_PATH/PROFILE.md"
SESSION_LOG="$FRAMEWORK_PATH/SESSION_LOG.md"
HISTORY_DIR="$FRAMEWORK_PATH/.claude/history"
SETTINGS_JSON="$FRAMEWORK_PATH/.claude/settings.json"
ARCHIVE_DIR="$FRAMEWORK_PATH/.claude/archive"

# ─── Step 1 — Collect profile info ───────────────────────────────────

if [ "$SKIP_PROFILE" = false ]; then
    write_header "STEP 1/3 — YOUR PROFILE"
    echo -e "  ${GRAY}These answers fill in PROFILE.md — Claude uses this to${NC}"
    echo -e "  ${GRAY}communicate in your style and make relevant recommendations.${NC}"
    echo ""

    user_name=$(prompt_field "Your name")
    user_role=$(prompt_field "Your role" "Software Engineer")
    user_stack=$(prompt_field "Primary language/stack" "JavaScript, React, Node.js")
    user_project=$(prompt_field "Current project name" "General")
    user_project_desc=$(prompt_field "What are you building? (1 sentence)")
    user_team=$(prompt_field "Team context" "Solo contributor")
    user_level=$(prompt_field "Experience level" "Mid-level")
    user_strongest=$(prompt_field "Strongest areas" "Frontend, debugging")
    user_learning=$(prompt_field "Currently learning" "AI tooling, system design")
    user_tone=$(prompt_field "Preferred tone" "Peer-to-peer, concise")
else
    echo -e "  ${YELLOW}Skipping profile collection (--skip-profile)${NC}"
fi

# ─── Step 2 — Install files ──────────────────────────────────────────

write_header "STEP 2/3 — INSTALLING"

# 2a. Global ~/.claude/CLAUDE.md
global_content="# Global Claude Code Configuration
# Loaded by Claude Code for EVERY project on this machine.
# Project-level CLAUDE.md overrides these defaults where they conflict.
# Do not delete this file — it activates the shared framework for all sessions.

---

## Framework Location

FRAMEWORK_PATH: $FRAMEWORK_PATH

---

## Session Startup Protocol (Global)

At the start of every session, silently:

1. Check if this project has a local CLAUDE.md.
   - If YES: read it — its rules override these defaults.
   - If NO: this project has no AI framework config.
     Immediately tell the user:
     \"This project has no CLAUDE.md. Run \\\`Use project-scan skill on [current path].\\\` to analyse it and set up the framework.\"

2. If PROFILE.md exists in project root: read it silently.
   If NOT: read FRAMEWORK_PATH/PROFILE.md silently.

3. If SESSION_LOG.md exists in project root: read the most recent entry silently.

4. Do not announce what you have read. Just use the context.

---

## Security Floor (Cannot be Overridden by Any Project CLAUDE.md)

These rules apply in every session, on every project, always:

- Never write to \`.env\` files via any tool.
- Never execute: \`rm -rf\`, \`DROP TABLE\`, \`DROP DATABASE\`, \`TRUNCATE\` without explicit per-session approval.
- Never \`git push --force\` to main or master.
- Never install packages (\`npm install\`, \`pip install\`, \`yarn add\`, etc.) without explicit per-session approval.
- Never commit or push without explicit instruction.
- Never overwrite a file that already exists unless the user explicitly asks for it.

---

## Global Output Defaults

- Responses: concise and direct.
- Default format: bullet list for enumerations, prose for explanations — never both unsolicited.
- Length: as short as correct allows.
- \`<format>\`, \`<length>\`, \`<sections>\` tags in any prompt override all defaults.

---

## Framework Skills (Available in Any Project)

All skills live at FRAMEWORK_PATH/skills/. Invoke by name from any project.

### Onboarding a new project
- \`project-scan\`     — scan any project -> produce PROJECT_SCAN.md gap report
- \`framework-apply\`  — install chosen components into the project

### Every session
- \`scope-guard\`      — prevent scope creep (use on every coding task)
- \`debug-first\`      — diagnose before fixing
- \`session-closer\`   — capture session knowledge (say: \"close the session\")

### Code quality
- \`code-review\`           — review against defined rules
- \`change-manifest\`       — record exactly what changed and why
- \`spec-to-task\`          — convert spec file -> sequenced task list

### Output control
- \`output-control\`        — explicit length and format via XML tags
- \`structured-response\`   — section-divided labeled output
- \`followup-refine\`       — depth-then-condense for two audiences
- \`minimal-output\`        — code-only, no narration

### Diagnostics
- \`healthcheck\`           — 12-point framework health diagnostic
- \`decision-log\`          — formal Architecture Decision Records

### Safety
- \`safe-cleanup-with-backup\`   — backup before any destructive deletion
- \`duplicate-structure-audit\`  — find and classify duplicate folders

---

## Onboarding Any New Project — Quick Reference

\`\`\`
Step 1:  \"Use project-scan skill on [absolute path to project]\"
Step 2:  Review PROJECT_SCAN.md written to that project's root
Step 3:  \"Use framework-apply skill.\"
Step 4:  Follow manual steps in the apply report
\`\`\`

---

## Registries (Reference These When Asked)

- Skills:   FRAMEWORK_PATH/registry/skills-registry.md
- Hooks:    FRAMEWORK_PATH/registry/hooks-registry.md
- Patterns: FRAMEWORK_PATH/registry/patterns-registry.md
- Prompts:  FRAMEWORK_PATH/prompts/golden-prompts.md"

safe_write_file "$GLOBAL_CLAUDE_MD" "$global_content"

# 2b. PROFILE.md
if [ "$SKIP_PROFILE" = false ] && [ -n "${user_name:-}" ]; then
    profile_content="# PROFILE.md — My Identity & Working Style

> This file is read by Claude at the start of every session.
> It tells Claude who I am, how I think, and how to write *as me* or *for me*.

---

## Who I Am

- **Name:** $user_name
- **Role:** $user_role
- **Current Project:** $user_project — $user_project_desc
- **Team context:** $user_team
- **Experience level:** $user_level

---

## Technical Background

- **Primary languages:** $user_stack
- **Tools I use:** Claude Code, VS Code, Git
- **Strongest areas:** $user_strongest
- **Areas I'm actively learning:** $user_learning

---

## Communication Style

- **When explaining things to me:** Be direct and specific. Use examples over abstract descriptions.
- **Tone I prefer:** $user_tone
- **What I dislike:** Long preambles, over-cautious disclaimers, repeating what I just said back to me.
- **When I ask a question:** I want the answer first, context second.

---

## Decision Patterns

> Claude should check these before making architectural or approach recommendations.

- I prefer **simple solutions over clever ones** — the minimum that is correct.
- I prefer **editing existing files** over creating new ones.
- I prefer **understanding the problem** before jumping to a fix.
- I am **cost-conscious with tokens** — keep prompts lean, responses tight.
- I prefer **explicit over implicit** — if something needs a decision, surface it to me.

---

## Writing Style (when Claude writes *for* me)

- First person, direct.
- Short sentences. No filler words.
- No \"I believe\" or \"I think\" — just state the thing.
- No closing motivational statements.

---

## Current Focus Area

$user_project — $user_project_desc

---

## Notes / Things Claude Should Always Remember

- (Add anything Claude keeps forgetting or getting wrong across sessions)"

    if [ "$DRY_RUN" = true ]; then
        write_status "PROFILE.md" "WOULD UPDATE (dry-run)"
    else
        echo "$profile_content" > "$PROFILE_MD"
        write_status "PROFILE.md" "UPDATED"
    fi
else
    write_status "PROFILE.md" "SKIPPED (no input)"
fi

# 2c. SESSION_LOG.md
session_log_content="# SESSION_LOG.md — Running Session History

> Newest session first. Max 20 lines per entry.
> Updated by the session-closer skill at the end of each work block.
> Claude reads this at the start of each session to recover context instantly."

safe_write_file "$SESSION_LOG" "$session_log_content"

# 2d. .claude/history/ files
safe_write_file "$HISTORY_DIR/decisions.md" "# Decisions Log

> Architectural, tooling, and approach decisions made across sessions.
> Updated by the session-closer skill. Read by Claude before making similar decisions.
> Format: Date | Decision | Reason | Alternatives Rejected"

safe_write_file "$HISTORY_DIR/learnings.md" "# Learnings Log

> Codebase facts, tool behaviours, and environment discoveries across sessions.
> Updated by the session-closer skill. Read by Claude to avoid re-discovering.
> Format: Date | Learning | Context | Applies To"

safe_write_file "$HISTORY_DIR/patterns.md" "# Patterns Log

> Good/bad/watch patterns noticed across sessions.
> Updated by the session-closer skill. Claude references these for improvement.
> Format: Pattern | Classification (GOOD/BAD/WATCH) | First Seen | Action"

# 2e. .claude/archive/ directory
if [ ! -d "$ARCHIVE_DIR" ]; then
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$ARCHIVE_DIR"
    fi
    write_status ".claude/archive/" "CREATED"
else
    write_status ".claude/archive/" "SKIPPED (exists)"
fi

# 2f. .claude/settings.json
settings_content="{
  \"hooks\": {
    \"PreToolUse\": [
      {
        \"matcher\": \".*\",
        \"hooks\": [
          {
            \"type\": \"command\",
            \"command\": \"bash \\\"$FRAMEWORK_PATH/hooks/pre-tool-use.sh\\\"\"
          }
        ]
      }
    ],
    \"PostToolUse\": [
      {
        \"matcher\": \".*\",
        \"hooks\": [
          {
            \"type\": \"command\",
            \"command\": \"bash \\\"$FRAMEWORK_PATH/hooks/post-tool-use.sh\\\"\"
          }
        ]
      }
    ],
    \"PreCompact\": [
      {
        \"matcher\": \".*\",
        \"hooks\": [
          {
            \"type\": \"command\",
            \"command\": \"bash \\\"$FRAMEWORK_PATH/hooks/pre-compact.sh\\\"\"
          }
        ]
      }
    ]
  }
}"

safe_write_file "$SETTINGS_JSON" "$settings_content"

# 2g. Make hook scripts executable
if [ "$DRY_RUN" = false ]; then
    chmod +x "$FRAMEWORK_PATH/hooks/"*.sh 2>/dev/null && write_status "hooks/*.sh" "chmod +x" || true
    chmod +x "$FRAMEWORK_PATH/tools/"*.sh 2>/dev/null && write_status "tools/*.sh" "chmod +x" || true
fi

# ─── Step 3 — Verification ───────────────────────────────────────────

write_header "STEP 3/3 — VERIFICATION"

pass=0; fail=0

check() {
    local name="$1" condition="$2"
    printf "  %-40s" "$name"
    if [ "$condition" = "true" ]; then
        echo -e "${GREEN}[PASS]${NC}"
        ((pass++))
    else
        echo -e "${RED}[FAIL]${NC}"
        ((fail++))
    fi
}

check "~/.claude/CLAUDE.md exists"       "$([ -f "$GLOBAL_CLAUDE_MD" ] && echo true || echo false)"
check "PROFILE.md exists"                "$([ -f "$PROFILE_MD" ] && echo true || echo false)"
check "SESSION_LOG.md exists"            "$([ -f "$SESSION_LOG" ] && echo true || echo false)"
check ".claude/history/decisions.md"     "$([ -f "$HISTORY_DIR/decisions.md" ] && echo true || echo false)"
check ".claude/history/learnings.md"     "$([ -f "$HISTORY_DIR/learnings.md" ] && echo true || echo false)"
check ".claude/history/patterns.md"      "$([ -f "$HISTORY_DIR/patterns.md" ] && echo true || echo false)"
check ".claude/settings.json exists"     "$([ -f "$SETTINGS_JSON" ] && echo true || echo false)"
check ".claude/archive/ exists"          "$([ -d "$ARCHIVE_DIR" ] && echo true || echo false)"

hook_count=$(find "$FRAMEWORK_PATH/hooks" -name "*.sh" -o -name "*.ps1" 2>/dev/null | wc -l | tr -d ' ')
check "hooks/ has 6 scripts"            "$([ "$hook_count" -ge 6 ] && echo true || echo false)"

skill_count=$(find "$FRAMEWORK_PATH/skills" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
check "skills/ has 5+ skills"           "$([ "$skill_count" -ge 5 ] && echo true || echo false)"

check "CLAUDE.md exists"                "$([ -f "$FRAMEWORK_PATH/CLAUDE.md" ] && echo true || echo false)"

profile_filled="true"
if [ -f "$PROFILE_MD" ] && grep -q '\[Your name\]' "$PROFILE_MD" 2>/dev/null; then
    profile_filled="false"
fi
check "PROFILE.md configured"           "$profile_filled"

echo ""
echo -e "  ${GRAY}─────────────────────────────────────────────────${NC}"
if [ "$fail" -eq 0 ]; then
    echo -e "  ${GREEN}PASS: $pass   FAIL: $fail${NC}"
else
    echo -e "  ${YELLOW}PASS: $pass   FAIL: $fail${NC}"
fi
echo ""

# ─── Summary ──────────────────────────────────────────────────────────

if [ "$fail" -eq 0 ]; then
    echo -e "  ${GREEN}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "  ${GREEN}║  FRAMEWORK READY                              ║${NC}"
    echo -e "  ${GREEN}╚═══════════════════════════════════════════════╝${NC}"
else
    echo -e "  ${YELLOW}╔═══════════════════════════════════════════════╗${NC}"
    echo -e "  ${YELLOW}║  SETUP COMPLETE — $fail item(s) need attention  ║${NC}"
    echo -e "  ${YELLOW}╚═══════════════════════════════════════════════╝${NC}"
fi

echo ""
echo -e "  ${CYAN}NEXT STEPS:${NC}"
echo -e "  ${WHITE}1. Open Claude Code in any project${NC}"
echo -e "  ${WHITE}2. Say: ${GREEN}\"Use project-scan skill on [path to your project]\"${NC}"
echo -e "  ${WHITE}3. Review the PROJECT_SCAN.md it creates${NC}"
echo -e "  ${WHITE}4. Say: ${GREEN}\"Use framework-apply skill.\"${NC}"
echo -e "  ${WHITE}5. Say: ${GREEN}\"Use healthcheck skill.\"${NC}"
echo -e "     ${WHITE}to verify everything is wired correctly${NC}"
echo ""
echo -e "  ${GRAY}At the end of every work session, say: ${GREEN}\"close the session\"${NC}"
echo ""
