#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════╗
# ║  UNIVERSAL PROMPT GENERATION ENGINE — pg v4.0                       ║
# ║  17 Layers · 10 PE Principles · 8 Modes · 5 AI Targets             ║
# ║  Lifecycle: SEED→CLASSIFY→FRAME→CONTEXT→CONSTRUCT→INJECT→           ║
# ║             SCORE→RENDER→DELIVER→LEARN                              ║
# ╚══════════════════════════════════════════════════════════════════════╝

set -euo pipefail

# ═══════════════════════════════════════════════════════════════
# VAULT PATHS
# ═══════════════════════════════════════════════════════════════
VAULT="${HOME}/.prompt-vault"
HISTORY_DIR="${VAULT}/history"
PERSONAS_DIR="${VAULT}/personas"
TEMPLATES_DIR="${VAULT}/templates"
CHAINS_DIR="${VAULT}/chains"
PATTERNS_DIR="${VAULT}/patterns"
SESSION_FILE="${VAULT}/.session"

# ═══════════════════════════════════════════════════════════════
# COLORS
# ═══════════════════════════════════════════════════════════════
R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
B='\033[0;34m'
C='\033[0;36m'
M='\033[0;35m'
W='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

# ═══════════════════════════════════════════════════════════════
# GLOBAL STATE
# ═══════════════════════════════════════════════════════════════
SEED=""
TARGET="claude"
TARGET_LOCKED=false
MODE=""
FRAMEWORK=""
SPEED="standard"
IS_CHAIN=false
FROM_CLIP=false
SPEC_FILE=""
PERSONA_NAME=""
PERSONA_DEF=""
AUDIENCE="self"
TONE="technical"
LENGTH="standard"
CURRENT_STATE=""
DESIRED_STATE=""
GAP_DESCRIPTION=""
RISK_STATEMENT=""
EXTRA_CONTEXT=""
FEW_SHOT_EXAMPLE=""
NEGATIVES=""
CHAIN_STEPS=3
CHAIN_DEPS=""
PE_TECHNIQUES=""
FINAL_PROMPT=""
QUALITY_SCORE=0
BOOT_CONTEXT=""
BOOT_LANG=""
BOOT_BRANCH=""
BOOT_REPO=""
CLIP_CONTENT=""
SESSION_CONTEXT=""
TS=$(date +%Y-%m-%d_%H-%M-%S)

# ═══════════════════════════════════════════════════════════════
# FRAMEWORK MAP: mode → framework
# ═══════════════════════════════════════════════════════════════
declare -A FRAMEWORK_MAP=(
  [code]="RISEN"
  [debug]="RISEN"
  [refactor]="RISEN"
  [build]="RISEN"
  [test]="RISEN"
  [spec]="SCWA"
  [architect]="COAST"
  [plan]="COAST"
  [review]="CARE"
  [research]="CARE"
  [analyze]="CARE"
  [create]="CARE"
  [document]="STAR"
  [write]="STAR"
  [communicate]="STAR"
  [decide]="DECISION"
  [learn]="FEYNMAN"
  [daily]="PREP"
  [email]="PREP"
)

# ═══════════════════════════════════════════════════════════════
# INIT — Create vault + seed default personas
# ═══════════════════════════════════════════════════════════════
init_vault() {
  mkdir -p "${HISTORY_DIR}" "${PERSONAS_DIR}" "${TEMPLATES_DIR}" \
           "${CHAINS_DIR}" "${PATTERNS_DIR}"

  if [[ ! -f "${PERSONAS_DIR}/senior-backend.persona" ]]; then
    cat > "${PERSONAS_DIR}/senior-backend.persona" <<'EOF'
NAME: Senior Backend Engineer
ROLE: You are a senior backend engineer with 10+ years of experience in distributed systems, API design, and performance optimization. You write production-quality code, think about edge cases, and document your decisions.
TRAITS: pragmatic, security-conscious, test-driven, documentation-aware, scalability-minded
AVOID: over-engineering, premature optimization, magic numbers, undocumented assumptions, scope creep
EOF
  fi

  if [[ ! -f "${PERSONAS_DIR}/scwa-reviewer.persona" ]]; then
    cat > "${PERSONAS_DIR}/scwa-reviewer.persona" <<'EOF'
NAME: SCWA Spec Reviewer
ROLE: You are an expert in spec-constrained workflow architecture. You implement precisely against formal specifications, never deviating from the spec without explicit written approval. You treat the spec as a contract.
TRAITS: spec-faithful, constraint-aware, delta-focused, validation-first, change-averse
AVOID: scope creep, undocumented changes, assumption-based decisions, spec violations
EOF
  fi

  if [[ ! -f "${PERSONAS_DIR}/debugging-specialist.persona" ]]; then
    cat > "${PERSONAS_DIR}/debugging-specialist.persona" <<'EOF'
NAME: Debugging Specialist
ROLE: You are a debugging and root cause analysis expert. You isolate issues systematically using hypothesis-driven investigation. You never guess — you form a hypothesis, test it, confirm or discard, then proceed.
TRAITS: methodical, hypothesis-driven, minimal-change, evidence-based, conservative
AVOID: shotgun debugging, unrelated changes, masking errors, guessing, premature fixes
EOF
  fi

  if [[ ! -f "${PERSONAS_DIR}/tech-writer.persona" ]]; then
    cat > "${PERSONAS_DIR}/tech-writer.persona" <<'EOF'
NAME: Technical Writer
ROLE: You are a senior technical writer who produces clear, accurate, and audience-calibrated documentation that developers actually want to read.
TRAITS: clarity-first, jargon-aware, example-driven, structured, concise
AVOID: passive voice overuse, undefined acronyms, wall-of-text, missing examples, vague instructions
EOF
  fi

  if [[ ! -f "${PERSONAS_DIR}/decision-advisor.persona" ]]; then
    cat > "${PERSONAS_DIR}/decision-advisor.persona" <<'EOF'
NAME: Decision Advisor
ROLE: You are an experienced technology decision advisor who evaluates options systematically using weighted criteria. You always deliver a concrete recommendation with stated confidence level and acknowledged trade-offs.
TRAITS: structured, data-driven, risk-aware, opinionated-when-asked, decisive
AVOID: analysis paralysis, false balance, vague trade-offs, uncommitted conclusions
EOF
  fi
}

# ═══════════════════════════════════════════════════════════════
# UI HELPERS
# ═══════════════════════════════════════════════════════════════
banner() {
  echo -e ""
  echo -e "${BOLD}${C}╔══════════════════════════════════════════════════════════════╗${NC}"
  printf "${BOLD}${C}║  🧠 PROMPT ENGINE  ·  %-38s  ║${NC}\n" "$1"
  echo -e "${BOLD}${C}╚══════════════════════════════════════════════════════════════╝${NC}"
  echo -e ""
}

section() {
  echo -e ""
  echo -e "${BOLD}${Y}  ▸ ${1}${NC}"
  echo -e "  ${DIM}──────────────────────────────────────────────────────────${NC}"
}

ask() {
  local question="$1"
  local varname="$2"
  local default="${3:-}"
  local prompt_suffix=""

  [[ -n "$default" ]] && prompt_suffix=" ${DIM}[${default}]${NC}"

  echo -e "  ${W}${question}${prompt_suffix}"
  echo -ne "  ${C}→ ${NC}"
  local input=""
  read -r input

  if [[ -z "$input" && -n "$default" ]]; then
    printf -v "$varname" '%s' "$default"
  else
    printf -v "$varname" '%s' "$input"
  fi
}

menu() {
  local title="$1"
  local opts_str="$2"
  local varname="$3"
  local default="${4:-1}"

  IFS='|' read -ra opts <<< "$opts_str"

  echo -e "  ${W}${title}"
  local i=1
  for opt in "${opts[@]}"; do
    local marker=""
    [[ "$i" -eq "$default" ]] && marker=" ${DIM}←${NC}"
    echo -e "    ${C}${i})${NC} ${opt}${marker}"
    ((i++))
  done
  echo -ne "  ${C}→ ${NC}[${default}] "
  local choice=""
  read -r choice

  [[ -z "$choice" ]] && choice="$default"

  if ! [[ "$choice" =~ ^[0-9]+$ ]] || \
     [[ "$choice" -lt 1 ]] || \
     [[ "$choice" -gt "${#opts[@]}" ]]; then
    choice="$default"
  fi

  printf -v "$varname" '%s' "${opts[$((choice-1))]}"
}

confirm() {
  local question="$1"
  local default="${2:-y}"
  echo -ne "  ${W}${question}${NC} ${DIM}[${default}]${NC} "
  local ans=""
  read -r ans
  [[ -z "$ans" ]] && ans="$default"
  [[ "$ans" =~ ^[Yy] ]]
}

log_ok()   { echo -e "  ${G}✓${NC} $*"; }
log_warn() { echo -e "  ${Y}⚠${NC} $*"; }
log_info() { echo -e "  ${C}·${NC} $*"; }
log_err()  { echo -e "  ${R}✗${NC} $*"; }

print_prompt_box() {
  echo -e ""
  echo -e "${BOLD}${G}╔══════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${G}║  GENERATED PROMPT — ${TARGET} · ${MODE} · ${FRAMEWORK}${NC}"
  echo -e "${BOLD}${G}╚══════════════════════════════════════════════════════════════╝${NC}"
  echo -e ""
  echo -e "${W}${FINAL_PROMPT}${NC}"
  echo -e ""
  echo -e "${BOLD}${G}╔══════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${G}║  END  ·  Score: ${QUALITY_SCORE}/10  ·  $(wc -c <<< "$FINAL_PROMPT" | tr -d ' ') chars${NC}"
  echo -e "${BOLD}${G}╚══════════════════════════════════════════════════════════════╝${NC}"
  echo -e ""
}

# ═══════════════════════════════════════════════════════════════
# CLIPBOARD
# ═══════════════════════════════════════════════════════════════
copy_to_clipboard() {
  local content="$1"
  if   command -v pbcopy  &>/dev/null; then echo -n "$content" | pbcopy  && log_ok "Copied to clipboard (pbcopy)"
  elif command -v xclip   &>/dev/null; then echo -n "$content" | xclip -selection clipboard && log_ok "Copied to clipboard (xclip)"
  elif command -v xsel    &>/dev/null; then echo -n "$content" | xsel --clipboard --input   && log_ok "Copied to clipboard (xsel)"
  elif command -v wl-copy &>/dev/null; then echo -n "$content" | wl-copy                   && log_ok "Copied to clipboard (wl-copy)"
  else log_warn "No clipboard tool found. Install pbcopy / xclip / xsel / wl-copy"
  fi
}

read_clipboard() {
  if   command -v pbpaste  &>/dev/null; then pbpaste
  elif command -v xclip    &>/dev/null; then xclip -selection clipboard -o 2>/dev/null || echo ""
  elif command -v xsel     &>/dev/null; then xsel --clipboard --output 2>/dev/null    || echo ""
  elif command -v wl-paste &>/dev/null; then wl-paste 2>/dev/null                     || echo ""
  else echo ""
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 1 — BOOT INTELLIGENCE
# ═══════════════════════════════════════════════════════════════
layer1_boot() {
  section "LAYER 1 — Boot Intelligence"

  # Git context
  local git_branch="" git_repo="" git_dirty=""
  if git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
    git_repo=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "")
    local dirty_count
    dirty_count=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    [[ "$dirty_count" -gt 0 ]] && git_dirty="${dirty_count} uncommitted" || git_dirty="clean"
  fi

  # Language detection
  BOOT_LANG="unknown"
  [[ -f "package.json" ]]                           && BOOT_LANG="Node.js/TypeScript"
  [[ -f "tsconfig.json" && -z "${BOOT_LANG//unknown/}" ]] && BOOT_LANG="TypeScript"
  [[ -f "Cargo.toml" ]]                             && BOOT_LANG="Rust"
  [[ -f "go.mod" ]]                                 && BOOT_LANG="Go"
  [[ -f "requirements.txt" || -f "pyproject.toml" ]] && BOOT_LANG="Python"
  [[ -f "pom.xml" || -f "build.gradle" ]]           && BOOT_LANG="Java/Kotlin"
  [[ -f "Gemfile" ]]                                && BOOT_LANG="Ruby"
  [[ -f "composer.json" ]]                          && BOOT_LANG="PHP"

  # Spec / CLAUDE.md sniff
  local claude_md="" spec_hint=""
  [[ -f "CLAUDE.md" ]]  && claude_md="✓ CLAUDE.md present"
  [[ -d "specs" ]]      && spec_hint="✓ specs/ directory found"
  [[ -d ".specs" ]]     && spec_hint="✓ .specs/ directory found"

  # Warm start
  [[ -f "${SESSION_FILE}" ]] && SESSION_CONTEXT=$(cat "${SESSION_FILE}")

  # Clipboard
  if [[ "${FROM_CLIP}" == true ]]; then
    CLIP_CONTENT=$(read_clipboard)
    [[ -n "$CLIP_CONTENT" ]] && log_ok "Clipboard loaded (${#CLIP_CONTENT} chars)"
  fi

  BOOT_BRANCH="$git_branch"
  BOOT_REPO="$git_repo"
  BOOT_CONTEXT="dir=$(pwd) | branch=${git_branch:-N/A} | lang=${BOOT_LANG} | repo=${git_repo:-N/A}"

  log_info "Directory : $(pwd)"
  [[ -n "$git_branch" ]] && log_info "Git        : ${git_branch} (${git_dirty})"
  [[ "$BOOT_LANG" != "unknown" ]] && log_info "Language   : ${BOOT_LANG}"
  [[ -n "$claude_md" ]] && log_ok "$claude_md"
  [[ -n "$spec_hint" ]] && log_ok "$spec_hint"
  [[ -n "$SESSION_CONTEXT" ]] && log_info "Warm start : prior session loaded"

  sleep 0.2
}

# ═══════════════════════════════════════════════════════════════
# LAYER 2 — SPEED MODE SELECT
# ═══════════════════════════════════════════════════════════════
layer2_speed() {
  if [[ "$SPEED" != "standard" ]]; then
    log_info "Speed mode : ${BOLD}${SPEED}${NC}"
    return
  fi

  section "LAYER 2 — Speed Mode"
  local choice
  menu "Select generation depth:" \
    "QUICK   — 30 sec : seed + target → instant prompt|STANDARD — 2 min  : guided key questions|DEEP     — 5 min  : full interview, maximum quality" \
    "choice" "2"

  case "$choice" in
    QUICK*)   SPEED="quick" ;;
    STANDARD*) SPEED="standard" ;;
    DEEP*)    SPEED="deep" ;;
  esac
}

# ═══════════════════════════════════════════════════════════════
# LAYER 3 — AI TARGET ROUTER
# ═══════════════════════════════════════════════════════════════
layer3_target() {
  if [[ "$TARGET_LOCKED" == true || "$SPEED" == "quick" ]]; then
    log_info "Target : ${BOLD}${TARGET}${NC}"
    return
  fi

  section "LAYER 3 — AI Target Router"
  local choice
  menu "Which AI receives this prompt?" \
    "claude       — chat/API : XML system+user blocks|claude-code  — terminal : agentic spec-aware format|copilot      — IDE inline : docstring comment format|copilot-chat — IDE chat : slash command format|universal    — any AI : clean natural language" \
    "choice" "1"

  TARGET=$(echo "$choice" | awk '{print $1}')
  log_ok "Target : ${TARGET}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 4 — TASK CLASSIFIER
# ═══════════════════════════════════════════════════════════════
layer4_classify() {
  section "LAYER 4 — Task Classifier"

  # Auto-classify from seed
  if [[ -z "$MODE" ]]; then
    local seed_lower
    seed_lower=$(echo "$SEED" | tr '[:upper:]' '[:lower:]')
    case "$seed_lower" in
      *debug*|*fix*|*error*|*bug*|*issue*|*broken*|*crash*) MODE="debug" ;;
      *refactor*|*clean*|*improve*|*optimiz*|*restructur*)   MODE="refactor" ;;
      *spec*|*specification*|*scwa*)                         MODE="spec" ;;
      *test*|*unit*|*integration*|*e2e*)                     MODE="test" ;;
      *document*|*readme*|*docs*|*comment*)                  MODE="document" ;;
      *email*|*slack*|*message*|*memo*|*comms*)              MODE="communicate" ;;
      *decide*|*choose*|*versus*|*compare*|*option*)          MODE="decide" ;;
      *learn*|*explain*|*understand*|*whatIs*|*howdoes*)     MODE="learn" ;;
      *plan*|*roadmap*|*schedule*|*sprint*|*milestone*)      MODE="plan" ;;
      *write*|*essay*|*article*|*blog*|*draft*)              MODE="write" ;;
      *research*|*survey*|*lookup*|*discover*)               MODE="research" ;;
      *architect*|*design*|*system*|*structure*)             MODE="architect" ;;
      *review*|*audit*|*check*|*assess*|*evaluate*)          MODE="review" ;;
      *analyz*|*analyse*|*analysis*|*insight*)               MODE="analyze" ;;
      *daily*|*personal*|*travel*|*health*|*financ*)         MODE="daily" ;;
      *build*|*implement*|*add*|*create*|*make*)             MODE="code" ;;
    esac

    if [[ -n "$MODE" ]]; then
      log_info "Auto-detected mode : ${BOLD}${MODE}${NC}"
      if [[ "$SPEED" != "quick" ]]; then
        confirm "Use '${MODE}'? (n to override)" "y" || MODE=""
      fi
    fi
  fi

  if [[ -z "$MODE" ]]; then
    local choice
    menu "Select task type:" \
      "code        — implement / build|debug       — fix / investigate|refactor    — improve / clean|spec        — SCWA spec-driven|review      — audit / assess|document    — write docs|write       — content / articles|research    — find / survey|decide      — compare / choose|learn       — explain / understand|plan        — roadmap / schedule|communicate — email / slack / comms|analyze     — data / systems|daily       — personal / life tasks" \
      "choice" "1"
    MODE=$(echo "$choice" | awk '{print $1}')
  fi

  FRAMEWORK="${FRAMEWORK_MAP[$MODE]:-RISEN}"
  log_ok "Mode : ${MODE}  →  Framework : ${BOLD}${FRAMEWORK}${NC}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 5 — GAP ARTICULATION ENGINE
# ═══════════════════════════════════════════════════════════════
layer5_gap() {
  [[ "$SPEED" == "quick" ]] && return

  section "LAYER 5 — Gap Articulation Engine"
  echo -e "  ${DIM}Precision contract: current state → desired state → bridge${NC}"
  echo ""

  ask "Current State — where are you now?:" \
    "CURRENT_STATE" "existing codebase / situation"
  ask "Desired State — where must you be?:" \
    "DESIRED_STATE" "outcome as described in task"
  ask "The Gap — what specifically needs to bridge these?:" \
    "GAP_DESCRIPTION" "infer from task description"
  ask "The Risk — what must NOT break or change?:" \
    "RISK_STATEMENT" "none stated"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 6 — CONTEXT ENGINE
# ═══════════════════════════════════════════════════════════════
layer6_context() {
  section "LAYER 6 — Context Engine"
  log_info "Auto-loaded : ${BOOT_CONTEXT}"

  # Spec file
  if [[ -n "$SPEC_FILE" && -f "$SPEC_FILE" ]]; then
    log_ok "Spec file loaded : ${SPEC_FILE}"
    EXTRA_CONTEXT="SPEC FILE (${SPEC_FILE}):\n$(cat "${SPEC_FILE}")\n\n"
  fi

  # Clipboard context
  if [[ -n "${CLIP_CONTENT}" ]]; then
    log_ok "Clipboard context included (${#CLIP_CONTENT} chars)"
    EXTRA_CONTEXT="${EXTRA_CONTEXT}CLIPBOARD CONTEXT:\n${CLIP_CONTENT}\n\n"
  fi

  # Prior session
  if [[ -n "${SESSION_CONTEXT}" ]]; then
    log_info "Prior session context loaded"
    EXTRA_CONTEXT="${EXTRA_CONTEXT}PRIOR SESSION CONTEXT:\n${SESSION_CONTEXT}\n\n"
  fi

  # Manual context injection (deep mode)
  if [[ "$SPEED" == "deep" ]]; then
    echo ""
    echo -e "  ${W}Paste additional context (file path, URL, code snippet, description)."
    echo -e "  ${DIM}Press Enter twice when done. Press Enter immediately to skip.${NC}"
    echo -ne "  ${C}→ ${NC}"
    local manual_ctx="" line
    while IFS= read -r line; do
      [[ -z "$line" ]] && break
      manual_ctx="${manual_ctx}${line}\n"
    done
    if [[ -n "$manual_ctx" ]]; then
      EXTRA_CONTEXT="${EXTRA_CONTEXT}ADDITIONAL CONTEXT:\n${manual_ctx}\n"
      log_ok "Manual context added"
    fi
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 7 — PERSONA ENGINE
# ═══════════════════════════════════════════════════════════════
layer7_persona() {
  [[ "$SPEED" == "quick" ]] && return

  section "LAYER 7 — Persona Engine"

  # Auto-suggest
  local suggested=""
  case "$MODE" in
    code|refactor|architect)  suggested="senior-backend" ;;
    spec|review)              suggested="scwa-reviewer" ;;
    debug)                    suggested="debugging-specialist" ;;
    document|write|communicate) suggested="tech-writer" ;;
    decide)                   suggested="decision-advisor" ;;
  esac

  # Collect available personas
  local personas=()
  while IFS= read -r -d '' f; do
    personas+=("$(basename "$f" .persona)")
  done < <(find "${PERSONAS_DIR}" -name "*.persona" -print0 2>/dev/null | sort -z)

  [[ -n "$suggested" ]] && log_info "Auto-suggested : ${BOLD}${suggested}${NC}"

  echo ""
  echo -e "  ${W}Available personas:"
  echo -e "    ${C}0)${NC} None"
  local i=1
  for p in "${personas[@]}"; do
    local tag=""
    [[ "$p" == "$suggested" ]] && tag=" ${Y}[suggested]${NC}"
    echo -e "    ${C}${i})${NC} ${p}${tag}"
    ((i++))
  done
  local new_idx=$i
  echo -e "    ${C}${i})${NC} Define new persona"
  echo -ne "  ${C}→ ${NC}[${suggested:-0}] "
  local pchoice
  read -r pchoice

  # Default to suggested or none
  if [[ -z "$pchoice" ]]; then
    pchoice="${suggested:-0}"
  fi

  if [[ "$pchoice" == "0" ]]; then
    PERSONA_DEF=""
    PERSONA_NAME="none"
  elif [[ "$pchoice" == "$new_idx" || "$pchoice" == "new" ]]; then
    local role_desc traits avoids
    ask "Role description (who is the AI):" "role_desc" "expert"
    ask "Key traits (comma-separated):" "traits" "precise, thorough"
    ask "Avoid (comma-separated):" "avoids" "assumptions, guessing"
    ask "Save as name:" "PERSONA_NAME" "custom"
    PERSONA_DEF="You are a ${role_desc}. Traits: ${traits}. Avoid: ${avoids}."
    cat > "${PERSONAS_DIR}/${PERSONA_NAME}.persona" <<EOF
NAME: ${PERSONA_NAME}
ROLE: ${role_desc}
TRAITS: ${traits}
AVOID: ${avoids}
EOF
    log_ok "New persona saved : ${PERSONA_NAME}"
  elif [[ "$pchoice" =~ ^[0-9]+$ ]]; then
    local idx=$((pchoice - 1))
    if [[ "$idx" -ge 0 && "$idx" -lt "${#personas[@]}" ]]; then
      PERSONA_NAME="${personas[$idx]}"
      PERSONA_DEF=$(cat "${PERSONAS_DIR}/${PERSONA_NAME}.persona")
    fi
  else
    # Treat as name
    PERSONA_NAME="$pchoice"
    [[ -f "${PERSONAS_DIR}/${PERSONA_NAME}.persona" ]] && \
      PERSONA_DEF=$(cat "${PERSONAS_DIR}/${PERSONA_NAME}.persona")
  fi

  [[ -n "$PERSONA_NAME" && "$PERSONA_NAME" != "none" ]] && \
    log_ok "Persona set : ${PERSONA_NAME}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 8 — AUDIENCE + OUTPUT CALIBRATION
# ═══════════════════════════════════════════════════════════════
layer8_calibration() {
  [[ "$SPEED" == "quick" ]] && return

  section "LAYER 8 — Audience + Output Calibration"

  local aud_choice tone_choice len_choice
  menu "Audience (who reads the AI's response):" \
    "self        — expert, maximum technical depth|junior      — early-career, explain concepts|senior      — peer, skip basics|stakeholder — non-technical, plain language" \
    "aud_choice" "1"
  AUDIENCE=$(echo "$aud_choice" | awk '{print $1}')

  menu "Output tone:" \
    "technical|plain-english|formal|conversational" \
    "TONE" "1"

  menu "Output length:" \
    "concise      — key points only|standard     — complete but focused|comprehensive — full detail + examples" \
    "len_choice" "2"
  LENGTH=$(echo "$len_choice" | awk '{print $1}')
}

# ═══════════════════════════════════════════════════════════════
# LAYER 9 — FEW-SHOT EXAMPLE INJECTOR
# ═══════════════════════════════════════════════════════════════
layer9_fewshot() {
  [[ "$SPEED" != "deep" ]] && return

  section "LAYER 9 — Few-Shot Example Injector"
  echo -e "  ${DIM}Showing the AI what good looks like dramatically improves quality${NC}"
  echo ""

  local choice
  menu "Example source:" \
    "Skip — no example needed|Describe in words what good output looks like|Load from saved template vault" \
    "choice" "1"

  case "$choice" in
    Skip*) FEW_SHOT_EXAMPLE="" ;;
    Describe*)
      echo -e "  ${W}Describe what a perfect response looks like (Enter twice to finish):"
      echo -ne "  ${C}→ ${NC}"
      local line
      while IFS= read -r line; do
        [[ -z "$line" ]] && break
        FEW_SHOT_EXAMPLE="${FEW_SHOT_EXAMPLE}${line}\n"
      done
      ;;
    Load*)
      local templates=()
      while IFS= read -r -d '' f; do
        templates+=("$(basename "$f" .template)")
      done < <(find "${TEMPLATES_DIR}" -name "*.template" -print0 2>/dev/null | sort -z)

      if [[ "${#templates[@]}" -eq 0 ]]; then
        log_warn "No templates saved yet"
      else
        echo -e "  ${W}Templates:"
        local i=1
        for t in "${templates[@]}"; do
          echo -e "    ${C}${i})${NC} ${t}"; ((i++))
        done
        echo -ne "  ${C}→ ${NC}"
        local tidx
        read -r tidx
        if [[ "$tidx" =~ ^[0-9]+$ ]] && \
           [[ "$tidx" -ge 1 && "$tidx" -le "${#templates[@]}" ]]; then
          FEW_SHOT_EXAMPLE=$(cat "${TEMPLATES_DIR}/${templates[$((tidx-1))]}.template")
          log_ok "Template loaded : ${templates[$((tidx-1))]}"
        fi
      fi
      ;;
  esac
}

# ═══════════════════════════════════════════════════════════════
# LAYER 10 — NEGATIVE SPACE (The Walls)
# ═══════════════════════════════════════════════════════════════
layer10_negative() {
  [[ "$SPEED" == "quick" ]] && return

  section "LAYER 10 — Negative Space (The Walls)"
  echo -e "  ${DIM}What must the AI NOT do? Walls prevent the most common failure modes.${NC}"
  echo ""

  if [[ "$SPEED" == "standard" ]]; then
    ask "What to avoid (comma-separated, Enter to skip):" "NEGATIVES" ""
  else
    echo -e "  ${W}List each constraint (one per line, Enter twice to finish):"
    echo -ne "  ${C}→ ${NC}"
    local line
    while IFS= read -r line; do
      [[ -z "$line" ]] && break
      NEGATIVES="${NEGATIVES}• ${line}\n"
    done
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 11 — COMPLEXITY ANALYZER
# ═══════════════════════════════════════════════════════════════
layer11_complexity() {
  [[ "$SPEED" == "quick" ]] && return
  [[ "$IS_CHAIN" == true ]] && return

  section "LAYER 11 — Complexity Analyzer"

  local word_count
  word_count=$(echo "$SEED $CURRENT_STATE $DESIRED_STATE" | wc -w | tr -d ' ')

  if [[ "$word_count" -gt 60 || "$SPEED" == "deep" ]]; then
    log_warn "Complex task detected. Prompt chaining recommended."
    echo ""
    if confirm "Break into a prompt chain (multi-step sequence)?"; then
      IS_CHAIN=true
      ask "Number of chain steps:" "CHAIN_STEPS" "3"
      echo -e "  ${W}Describe each step briefly:"
      local s
      for ((s=1; s<=CHAIN_STEPS; s++)); do
        echo -ne "  ${C}Step ${s} → ${NC}"
        local step_line
        read -r step_line
        CHAIN_DEPS="${CHAIN_DEPS}Step ${s}: ${step_line}\n"
      done
      log_ok "Chain configured : ${CHAIN_STEPS} steps"
    fi
  else
    log_ok "Complexity : single prompt"
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 12 — PE TECHNIQUE INJECTOR (10 Principles)
# ═══════════════════════════════════════════════════════════════
layer12_techniques() {
  # Core 3 — always applied
  PE_TECHNIQUES="• Think step by step before writing any output.\n"
  PE_TECHNIQUES="${PE_TECHNIQUES}• Mark anything below 90% confidence with [UNCERTAIN].\n"
  PE_TECHNIQUES="${PE_TECHNIQUES}• If critical information is missing, ask rather than assume or invent.\n"

  # Mode-specific additions
  case "$MODE" in
    code|refactor|build)
      PE_TECHNIQUES="${PE_TECHNIQUES}• Do not modify files or logic outside the stated scope.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• Validate your approach against all stated constraints before implementing.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• Begin with a brief plan. Show the plan before code.\n"
      ;;
    debug)
      PE_TECHNIQUES="${PE_TECHNIQUES}• State your hypothesis before investigating.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• Confirm the root cause before proposing a fix.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• Make the minimum change required to resolve the issue.\n"
      ;;
    spec)
      PE_TECHNIQUES="${PE_TECHNIQUES}• Treat the spec as a contract. No undocumented deviations.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• Flag all spec ambiguities before implementation begins.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• List every constraint you are operating under before starting.\n"
      ;;
    decide)
      PE_TECHNIQUES="${PE_TECHNIQUES}• Evaluate all options against all criteria before recommending.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• State your recommendation confidence level as a percentage.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• Acknowledge the trade-offs you are accepting in your recommendation.\n"
      ;;
    learn)
      PE_TECHNIQUES="${PE_TECHNIQUES}• Use the Feynman method: plain explanation first, technical precision second.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• Identify the single hardest concept and explain it with a concrete analogy.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• End with a one-sentence summary that a non-expert would remember.\n"
      ;;
    write|communicate|document)
      PE_TECHNIQUES="${PE_TECHNIQUES}• Lead with the most important point — no preamble.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• Match vocabulary and jargon level precisely to the stated audience.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• Conclude with a clear action, decision, or summary statement.\n"
      ;;
    analyze|research)
      PE_TECHNIQUES="${PE_TECHNIQUES}• Separate findings from conclusions. Label each clearly.\n"
      PE_TECHNIQUES="${PE_TECHNIQUES}• Quantify uncertainty. Say 'likely' or 'possibly' rather than stating as fact.\n"
      ;;
  esac
}

# ═══════════════════════════════════════════════════════════════
# FRAMEWORK CONTENT BUILDERS
# ═══════════════════════════════════════════════════════════════
build_risen() {
  cat <<EOF
## FRAMEWORK: RISEN — Role · Instructions · Steps · End · Narrowing

**Role:**
${PERSONA_DEF:-Senior engineer with deep domain expertise. Production-quality output. Think before acting.}

**Instructions:**
${SEED}

**Steps:**
1. Read all requirements and constraints before doing anything
2. State your implementation plan before writing any code or output
3. Execute step by step against the plan
4. Self-review output against all stated requirements
5. Document any decisions, trade-offs, or open questions

**End Goal:**
${DESIRED_STATE:-Complete the task with production-quality, tested, documented output}

**Narrowing Constraints:**
$(echo -e "${NEGATIVES:-- Do not introduce scope creep\n- Do not modify anything outside stated boundaries\n- Do not make undocumented assumptions\n- Do not hallucinate APIs or functions — verify first}")
EOF
}

build_care() {
  cat <<EOF
## FRAMEWORK: CARE — Context · Action · Result · Example

**Context:**
Current state: ${CURRENT_STATE:-as described}
Environment: ${BOOT_CONTEXT}
$(echo -e "${EXTRA_CONTEXT:+\n${EXTRA_CONTEXT}}")

**Action:**
${SEED}

**Result Expected:**
${DESIRED_STATE:-High-quality output meeting all requirements}
Quality bar: ${LENGTH} length · ${TONE} tone · for ${AUDIENCE} audience

**Example of Good Output:**
$(echo -e "${FEW_SHOT_EXAMPLE:-[No example provided — infer from context and task description]}")

**Constraints:**
$(echo -e "${NEGATIVES:-- Stay within stated scope\n- Prioritize clarity over cleverness\n- Flag any ambiguity before proceeding}")
EOF
}

build_coast() {
  cat <<EOF
## FRAMEWORK: COAST — Context · Objective · Actions · Scenario · Task

**Context:**
${CURRENT_STATE:-Current state as described}
Environment: ${BOOT_CONTEXT}

**Objective:**
${DESIRED_STATE:-Achieve the stated outcome fully and completely}

**Actions Required:**
$(echo -e "${CHAIN_DEPS:-Step 1: Analyze and understand requirements\nStep 2: Plan approach and validate against constraints\nStep 3: Implement and verify}")

**Scenario:**
Task: ${SEED}
Key risks: ${RISK_STATEMENT:-none stated}
Constraints: $(echo -e "${NEGATIVES:-none beyond stated requirements}")

**Task Deliverable:**
${LENGTH} ${TONE} output for ${AUDIENCE} audience.
$(echo -e "${FEW_SHOT_EXAMPLE:+\nExample of good output:\n${FEW_SHOT_EXAMPLE}}")
EOF
}

build_star() {
  cat <<EOF
## FRAMEWORK: STAR — Situation · Task · Action · Result

**Situation:**
${CURRENT_STATE:-The context as described in the task}

**Task:**
${SEED}
Target audience: ${AUDIENCE} | Tone: ${TONE} | Length: ${LENGTH}

**Action Approach:**
• Lead with the most important point — no preamble
• Support with evidence, examples, or reasoning where relevant
• Match vocabulary precisely to the stated audience
• Conclude with a clear action, decision, or summary statement

**Result Specification:**
Deliver: ${DESIRED_STATE:-Complete, polished content as specified}
Avoid: $(echo -e "${NEGATIVES:-jargon mismatch, passive voice overuse, filler content, vague conclusions}")
$(echo -e "${FEW_SHOT_EXAMPLE:+\nStyle reference:\n${FEW_SHOT_EXAMPLE}}")
EOF
}

build_decision() {
  cat <<EOF
## FRAMEWORK: DECISION MATRIX — Options · Criteria · Weights · Risk · Recommendation

**Decision Required:**
${SEED}

**Options to Evaluate:**
[Evaluate all relevant options. Surface additional alternatives if they are clearly superior to those stated.]

**Evaluation Criteria + Weights:**
| Criterion         | Weight |
|-------------------|--------|
| Performance       | High   |
| Maintainability   | High   |
| Implementation cost | Medium |
| Operational risk  | High   |
| Time-to-implement | Medium |
| Team familiarity  | Medium |
${GAP_DESCRIPTION:+\nAdditional criteria from context: ${GAP_DESCRIPTION}}

**Risk Assessment:**
For each option, explicitly state:
• What could go wrong
• Likelihood (low/medium/high)
• Mitigation strategy

**Required Output:**
1. Evaluation table (options × criteria)
2. Risk summary per option
3. Clear recommendation with confidence percentage
4. Trade-offs accepted in the recommendation
5. Conditions under which the recommendation would change

**Constraints:**
${NEGATIVES:-• Avoid analysis paralysis — deliver a concrete recommendation
• Do not give false balance — state which option is better and why
• Do not recommend "it depends" without specifying what it depends on}
EOF
}

build_feynman() {
  cat <<EOF
## FRAMEWORK: FEYNMAN — Concept · Simple · Gap · Rebuild

**Concept to Explain:**
${SEED}

**Step 1 — Explain Simply:**
Explain as if to someone intelligent but with no domain knowledge.
Use one concrete real-world analogy. Zero jargon. Maximum clarity.

**Step 2 — Identify the Hard Part:**
What is the single most commonly misunderstood aspect of this concept?
Why do people get it wrong?

**Step 3 — Bridge the Gap:**
${GAP_DESCRIPTION:-What does someone need to understand to go from surface knowledge to deep understanding?}

**Step 4 — Rebuild with Precision:**
Now explain with full technical accuracy for a ${AUDIENCE} audience.
Include:
• How it works mechanically
• Why it was designed this way
• Common failure modes or misuse patterns
• One concrete real-world example

**Output Requirements:**
Tone: ${TONE} | Length: ${LENGTH}
End with: one sentence a non-expert would still remember tomorrow.

**Avoid:**
${NEGATIVES:-• Assuming prior knowledge without stating it
• Using jargon without defining it first
• Abstract explanations without concrete anchors}
EOF
}

build_scwa() {
  local spec_content=""
  [[ -n "$SPEC_FILE" && -f "$SPEC_FILE" ]] && spec_content=$(cat "$SPEC_FILE")

  cat <<EOF
## FRAMEWORK: SCWA-NATIVE — Spec · Constraint · Delta · Validate

**Spec Reference:**
${spec_content:-${EXTRA_CONTEXT:-[No spec file provided. Derive constraints from task description. Flag all assumptions.]}}

**Constraint Declaration:**
You are operating under a spec-constrained workflow. This means:
• The spec is the single source of truth
• Never deviate from spec without explicit written approval
• Flag all spec ambiguities BEFORE implementation
• Scope is bounded strictly by the spec

**Delta Required:**
${SEED}

**Current State:**
${CURRENT_STATE:-As per spec baseline}

**Target State:**
${DESIRED_STATE:-Spec-compliant implementation of the stated delta}

**Walls:**
$(echo -e "${NEGATIVES:-- Never modify files outside spec scope\n- Never make undocumented architectural decisions\n- Never assume spec intent — ask when ambiguous\n- Never treat the spec as a suggestion}")

**Validation Checklist (complete before delivering output):**
□ All spec constraints verified and honored
□ Scope boundaries respected — no feature creep
□ All spec ambiguities surfaced and resolved or flagged
□ All decisions documented with rationale
□ Output is additive, non-destructive to existing infrastructure

**Environment:**
Branch: ${BOOT_BRANCH:-N/A} | Language: ${BOOT_LANG} | $(pwd)
EOF
}

build_prep() {
  cat <<EOF
## FRAMEWORK: PREP — Position · Reason · Example · Position

**Position (Initial Statement):**
${CURRENT_STATE:-The current situation that requires action}

**Reason:**
${SEED}
Why this matters: ${GAP_DESCRIPTION:-state the goal or outcome at stake}

**Example:**
$(echo -e "${FEW_SHOT_EXAMPLE:-Provide a concrete, realistic example that illustrates the ideal approach or outcome}")

**Position (Restated with Specificity):**
Deliver: ${DESIRED_STATE:-The exact output requested, in final form}
Audience: ${AUDIENCE} | Tone: ${TONE} | Length: ${LENGTH}
$(echo -e "${NEGATIVES:+\nAvoid:\n${NEGATIVES}}")
EOF
}

select_framework_content() {
  case "${FRAMEWORK}" in
    RISEN)    build_risen ;;
    CARE)     build_care ;;
    COAST)    build_coast ;;
    STAR)     build_star ;;
    DECISION) build_decision ;;
    FEYNMAN)  build_feynman ;;
    SCWA)     build_scwa ;;
    PREP)     build_prep ;;
    *)        build_risen ;;
  esac
}

# ═══════════════════════════════════════════════════════════════
# LAYER 15 — OUTPUT RENDERER (all 5 targets)
# ═══════════════════════════════════════════════════════════════
render_claude() {
  local fw
  fw=$(select_framework_content)

  local persona_block=""
  [[ -n "$PERSONA_DEF" ]] && persona_block="<persona>
${PERSONA_DEF}
</persona>
"

  local context_block=""
  [[ -n "$EXTRA_CONTEXT" ]] && context_block="<context>
$(echo -e "${EXTRA_CONTEXT}")
</context>
"

  local risk_block=""
  [[ -n "$RISK_STATEMENT" && "$RISK_STATEMENT" != "none stated" ]] && risk_block="<hard-constraint>
⚠ MUST NOT BREAK OR CHANGE: ${RISK_STATEMENT}
</hard-constraint>
"

  cat <<EOF
<system>
${persona_block}
You are a precise, constraint-aware assistant. Treat stated requirements as a contract.
Follow the task specification exactly. Mark uncertain content [UNCERTAIN].
Ask for clarification rather than inventing missing information.
</system>

<user>
${context_block}${risk_block}
<task>
${fw}
</task>

<pe-directives>
$(echo -e "${PE_TECHNIQUES}")
</pe-directives>

<output-format>
Audience : ${AUDIENCE}
Tone     : ${TONE}
Length   : ${LENGTH}
$(echo -e "${NEGATIVES:+\nDo NOT:\n${NEGATIVES}}")
</output-format>
</user>
EOF
}

render_claude_code() {
  local fw
  fw=$(select_framework_content)

  local claude_md_note=""
  [[ -f "CLAUDE.md" ]] && claude_md_note="# ⚠ CLAUDE.md present — honor ALL constraints defined there
"

  local spec_note=""
  [[ -n "$SPEC_FILE" ]] && spec_note="# Spec: ${SPEC_FILE}
"

  cat <<EOF
# ═══════════════════════════════════════════════════════════════
# AGENTIC TASK — Claude Code
# Generated : ${TS}
# Mode      : ${MODE}  |  Framework : ${FRAMEWORK}
# Target    : claude-code (terminal)
# Branch    : ${BOOT_BRANCH:-N/A}  |  Language: ${BOOT_LANG}
# Dir       : $(pwd)
# ═══════════════════════════════════════════════════════════════

${claude_md_note}${spec_note}
## TASK
${SEED}

## CURRENT STATE
${CURRENT_STATE:-Analyze the codebase to determine current state before acting}

## DESIRED STATE
${DESIRED_STATE:-Implement the changes described above}

## HARD CONSTRAINTS
$(echo -e "${NEGATIVES:-- Honor all existing architectural patterns\n- Do not modify files outside the stated scope\n- No undocumented changes\n- No scope creep\n- No assumptions — ask if unclear}")
${RISK_STATEMENT:+⚠ MUST NOT BREAK: ${RISK_STATEMENT}}

## IMPLEMENTATION
${fw}

## PE DIRECTIVES
$(echo -e "${PE_TECHNIQUES}")

## PRE-DELIVERY VALIDATION
□ All constraints respected
□ No unintended side effects
□ All changes documented
□ Uncertain points flagged [UNCERTAIN]
□ Scope boundary honored
EOF
}

render_copilot_inline() {
  local fw
  fw=$(select_framework_content)

  cat <<EOF
// ───────────────────────────────────────────────────────────────
// COPILOT INLINE PROMPT
// Task     : ${SEED}
// Language : ${BOOT_LANG:-infer from context}
// Mode     : ${MODE}  |  Framework : ${FRAMEWORK}
//
// CURRENT STATE : ${CURRENT_STATE:-see surrounding code}
// DESIRED STATE : ${DESIRED_STATE:-implement as described below}
//
// CONSTRAINTS:
$(echo -e "${NEGATIVES:-- Stay within this function/module scope\n- Match existing code style and patterns\n- No magic numbers\n- No undocumented changes}" | sed 's/^/\/\/ /')
//
// IMPLEMENTATION APPROACH:
$(echo "$fw" | sed 's/^/\/\/ /')
//
// PE: Think step by step. Mark anything uncertain [UNCERTAIN].
// Do not modify code outside the scope of this task.
// ───────────────────────────────────────────────────────────────
EOF
}

render_copilot_chat() {
  local fw
  fw=$(select_framework_content)

  local slash_cmd="/explain"
  case "$MODE" in
    debug|refactor) slash_cmd="/fix" ;;
    document)       slash_cmd="/doc" ;;
    test)           slash_cmd="/tests" ;;
    code|build)     slash_cmd="/explain" ;;
  esac

  cat <<EOF
${slash_cmd}

## Task
${SEED}

Mode: ${MODE} | Language: ${BOOT_LANG:-infer} | Framework: ${FRAMEWORK}

## Context
${CURRENT_STATE:-See selected code / active file}

## Requirements
${fw}

## Constraints
$(echo -e "${NEGATIVES:-- Stay within scope\n- Do not break existing tests\n- Match existing code style and patterns\n- No undocumented changes}")

## Output
Format for ${AUDIENCE} audience · ${TONE} tone · ${LENGTH} length
Think step by step. State [UNCERTAIN] if below 90% confidence.
EOF
}

render_universal() {
  local fw
  fw=$(select_framework_content)

  cat <<EOF
TASK: ${SEED}

ROLE: ${PERSONA_DEF:-Act as a highly experienced expert in the relevant domain. Prioritize accuracy, completeness, and clarity.}

CONTEXT:
- Current situation : ${CURRENT_STATE:-as described}
- Target outcome    : ${DESIRED_STATE:-complete the stated task}
- Environment       : ${BOOT_CONTEXT}
$(echo -e "${EXTRA_CONTEXT:+- Additional context : $(echo -e "${EXTRA_CONTEXT}" | head -5)}")

REQUIREMENTS:
${fw}

CONSTRAINTS:
$(echo -e "${NEGATIVES:-- Do not exceed the stated scope\n- Ask if critical information is missing\n- Do not make undocumented assumptions\n- Do not invent facts you are unsure of}")
${RISK_STATEMENT:+- MUST NOT BREAK: ${RISK_STATEMENT}}

OUTPUT SPECIFICATION:
- Audience : ${AUDIENCE}
- Tone     : ${TONE}
- Length   : ${LENGTH}

PROCESS: Think step by step. Show your reasoning. Flag uncertainty explicitly.
EOF
}

layer15_render() {
  section "LAYER 15 — Output Renderer"
  log_info "Rendering for : ${BOLD}${TARGET}${NC}"

  case "$TARGET" in
    claude)       FINAL_PROMPT=$(render_claude) ;;
    claude-code)  FINAL_PROMPT=$(render_claude_code) ;;
    copilot)      FINAL_PROMPT=$(render_copilot_inline) ;;
    copilot-chat) FINAL_PROMPT=$(render_copilot_chat) ;;
    universal)    FINAL_PROMPT=$(render_universal) ;;
    *)            FINAL_PROMPT=$(render_claude) ;;
  esac
}

# ═══════════════════════════════════════════════════════════════
# LAYER 13 — QUALITY SCORER
# ═══════════════════════════════════════════════════════════════
layer13_score() {
  section "LAYER 13 — Quality Scorer"

  local score=0
  local breakdown=""

  # [2pt] Role Clarity
  if echo "$FINAL_PROMPT" | grep -qi "you are\|role\|persona\|expert\|engineer\|specialist"; then
    score=$((score + 2))
    breakdown="${breakdown}  ${G}[2/2]${NC} Role Clarity ✓\n"
  else
    score=$((score + 1))
    breakdown="${breakdown}  ${Y}[1/2]${NC} Role Clarity — no explicit role defined\n"
  fi

  # [2pt] Objective Precision
  if [[ -n "$DESIRED_STATE" && "$DESIRED_STATE" != "outcome as described in task" ]] || \
     [[ ${#SEED} -gt 30 ]]; then
    score=$((score + 2))
    breakdown="${breakdown}  ${G}[2/2]${NC} Objective Precision ✓\n"
  else
    score=$((score + 1))
    breakdown="${breakdown}  ${Y}[1/2]${NC} Objective Precision — brief seed, consider more detail\n"
  fi

  # [2pt] Context Completeness
  if [[ -n "$EXTRA_CONTEXT" ]] || \
     [[ -n "$CURRENT_STATE" && "$CURRENT_STATE" != "existing codebase / situation" ]]; then
    score=$((score + 2))
    breakdown="${breakdown}  ${G}[2/2]${NC} Context Completeness ✓\n"
  else
    score=$((score + 1))
    breakdown="${breakdown}  ${Y}[1/2]${NC} Context Completeness — no supplemental context provided\n"
  fi

  # [2pt] Constraint Coverage
  if [[ -n "$NEGATIVES" ]] || \
     [[ -n "$RISK_STATEMENT" && "$RISK_STATEMENT" != "none stated" ]]; then
    score=$((score + 2))
    breakdown="${breakdown}  ${G}[2/2]${NC} Constraint Coverage ✓\n"
  else
    score=$((score + 1))
    breakdown="${breakdown}  ${Y}[1/2]${NC} Constraint Coverage — no explicit constraints defined\n"
  fi

  # [1pt] Output Schema
  if echo "$FINAL_PROMPT" | grep -qi "format\|length\|tone\|audience"; then
    score=$((score + 1))
    breakdown="${breakdown}  ${G}[1/1]${NC} Output Schema ✓\n"
  else
    breakdown="${breakdown}  ${R}[0/1]${NC} Output Schema — missing format specification\n"
  fi

  # [1pt] Uncertainty Handling
  if echo "$FINAL_PROMPT" | grep -qi "uncertain\|ask.*assume\|confidence\|UNCERTAIN"; then
    score=$((score + 1))
    breakdown="${breakdown}  ${G}[1/1]${NC} Uncertainty Handling ✓\n"
  else
    breakdown="${breakdown}  ${R}[0/1]${NC} Uncertainty Handling — missing anti-hallucination directive\n"
  fi

  QUALITY_SCORE=$score
  echo -e "$breakdown"
  echo -e "  ${DIM}──────────────────────────────────${NC}"

  local verdict
  if   [[ $score -ge 8 ]]; then verdict="${G}✓ READY TO SEND (${score}/10)${NC}"
  elif [[ $score -ge 5 ]]; then verdict="${Y}⚠ REFINE RECOMMENDED (${score}/10)${NC}"
  else                          verdict="${R}✗ REBUILD NEEDED (${score}/10)${NC}"
  fi
  echo -e "  Score : ${BOLD}${verdict}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 14 — REFINEMENT LOOP
# ═══════════════════════════════════════════════════════════════
layer14_refine() {
  [[ "$SPEED" == "quick" ]] && return
  [[ $QUALITY_SCORE -ge 8 ]] && return

  section "LAYER 14 — Refinement Loop"
  echo -e "  ${DIM}Score ${QUALITY_SCORE}/10. Refine before delivering?${NC}"
  echo ""

  local choice
  menu "Action:" \
    "Accept and deliver as-is|Refine a specific section|Full rebuild" \
    "choice" "1"

  case "$choice" in
    Accept*) return ;;
    Refine*)
      local section_choice
      menu "Which section to refine?" \
        "Role / Persona|Objective / Task seed|Context / Environment|Constraints / Negatives|Output format calibration" \
        "section_choice" "1"

      case "$section_choice" in
        Role*)
          layer7_persona
          ;;
        Objective*)
          ask "Revised task (current: ${SEED:0:50}...):" "SEED" "$SEED"
          ;;
        Context*)
          local extra
          ask "Additional context to inject:" "extra" ""
          EXTRA_CONTEXT="${EXTRA_CONTEXT}${extra}\n"
          ;;
        Constraints*)
          local more_neg
          ask "Additional constraints to add:" "more_neg" ""
          NEGATIVES="${NEGATIVES}• ${more_neg}\n"
          ;;
        Output*)
          layer8_calibration
          ;;
      esac

      # Re-render and re-score
      layer15_render
      layer13_score
      ;;
    Full*)
      log_warn "Full rebuild — restarting from Layer 4"
      MODE=""
      FRAMEWORK=""
      PERSONA_DEF=""
      EXTRA_CONTEXT=""
      NEGATIVES=""
      CURRENT_STATE=""
      DESIRED_STATE=""
      layer4_classify
      layer5_gap
      layer6_context
      layer7_persona
      layer8_calibration
      layer9_fewshot
      layer10_negative
      layer12_techniques
      layer15_render
      layer13_score
      ;;
  esac
}

# ═══════════════════════════════════════════════════════════════
# LAYER 16 — DELIVERY SYSTEM
# ═══════════════════════════════════════════════════════════════
layer16_deliver() {
  section "LAYER 16 — Delivery System"

  # Terminal preview — always
  print_prompt_box

  # Save to history
  local slug
  slug=$(echo "$SEED" | tr '[:upper:]' '[:lower:]' | \
         sed 's/[^a-z0-9]/-/g' | tr -s '-' | cut -c1-40)
  local hist_file="${HISTORY_DIR}/${TS}_${slug}_${TARGET}.prompt"
  echo "$FINAL_PROMPT" > "$hist_file"
  log_ok "Saved to history : ${DIM}${hist_file}${NC}"

  # Chain save
  if [[ "$IS_CHAIN" == true ]]; then
    local chain_file="${CHAINS_DIR}/${TS}_${slug}.chain"
    echo "$FINAL_PROMPT" > "$chain_file"
    log_ok "Chain saved : ${DIM}${chain_file}${NC}"
  fi

  # Clipboard — primary delivery
  copy_to_clipboard "$FINAL_PROMPT"

  # Save session context for warm start
  printf 'Last: %s | Mode: %s | Target: %s | Date: %s\n' \
    "$SEED" "$MODE" "$TARGET" "$(date)" > "$SESSION_FILE"

  # Offer to save as template
  if [[ "$SPEED" != "quick" ]]; then
    echo ""
    if confirm "Save as reusable template?"; then
      local tmpl_name
      ask "Template name:" "tmpl_name" "${MODE}-$(date +%m%d)"
      echo "$FINAL_PROMPT" > "${TEMPLATES_DIR}/${tmpl_name}.template"
      log_ok "Template saved : ${TEMPLATES_DIR}/${tmpl_name}.template"
    fi
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 17 — FEEDBACK + LEARNING ENGINE
# ═══════════════════════════════════════════════════════════════
layer17_learn() {
  [[ "$SPEED" == "quick" ]] && return

  section "LAYER 17 — Feedback + Learning Engine"
  echo -e "  ${DIM}Rate the prompt after you receive the AI's response${NC}"
  echo ""

  if ! confirm "Log feedback now? (skip = come back later)"; then
    echo -e "  ${DIM}Tip: run 'pg --patterns' to view your learning log anytime${NC}"
    return
  fi

  local feedback_result quality_rating what_worked what_improve
  menu "Did the prompt produce good output?" \
    "Yes — excellent result|Partial — needed clarification|No — AI missed the mark" \
    "feedback_result" "1"

  menu "Rate the AI response quality:" \
    "5 — Exceptional|4 — Good|3 — Adequate|2 — Poor|1 — Failed" \
    "quality_rating" "2"

  ask "What worked well? (optional):" "what_worked" "N/A"
  ask "What to improve next time? (optional):" "what_improve" "N/A"

  cat >> "${PATTERNS_DIR}/what-worked.log" <<EOF

────────────────────────────────────────────────────────────────
Date       : $(date)
Task       : ${SEED}
Mode       : ${MODE} | Target: ${TARGET} | Framework: ${FRAMEWORK}
Quality Gen: ${QUALITY_SCORE}/10
Feedback   : ${feedback_result}
AI Response: ${quality_rating}
Worked     : ${what_worked}
Improve    : ${what_improve}
────────────────────────────────────────────────────────────────
EOF

  log_ok "Feedback logged : ${PATTERNS_DIR}/what-worked.log"

  # Auto-save exceptional prompts as templates
  if [[ "$quality_rating" == "5"* ]]; then
    local winner_name="${MODE}-winner-$(date +%m%d%H%M)"
    echo "$FINAL_PROMPT" > "${TEMPLATES_DIR}/${winner_name}.template"
    log_ok "Winning prompt auto-saved as template : ${winner_name}"
  fi
}

# ═══════════════════════════════════════════════════════════════
# CHAIN GENERATOR
# ═══════════════════════════════════════════════════════════════
generate_chain() {
  section "CHAIN GENERATOR — Multi-Prompt Sequence"
  echo -e "  ${DIM}Build a sequence of connected prompts for complex tasks${NC}"
  echo ""

  ask "Number of prompts in chain:" "num_steps" "3"

  local all_prompts="" s
  for ((s=1; s<=num_steps; s++)); do
    echo -e "\n  ${BOLD}${C}─── STEP ${s} of ${num_steps} ───────────────────────────${NC}"
    local step_seed step_current step_desired
    ask "Step ${s} — task:" "step_seed" ""
    [[ $s -gt 1 ]] && step_current="[Input: output from Step $((s-1))]" || step_current=""
    ask "Step ${s} — desired output:" "step_desired" "complete step ${s}"

    SEED="$step_seed"
    CURRENT_STATE="$step_current"
    DESIRED_STATE="$step_desired"

    layer12_techniques
    layer15_render

    all_prompts="${all_prompts}
## ═══════════════════════════════════════════════════
## STEP ${s} of ${num_steps}
## ═══════════════════════════════════════════════════
${FINAL_PROMPT}

[→ Pass output of Step ${s} as context to Step $((s+1)) if applicable]
"
  done

  local chain_name="chain-$(date +%m%d-%H%M)"
  local chain_file="${CHAINS_DIR}/${TS}_${chain_name}.chain"
  {
    echo "# PROMPT CHAIN — ${chain_name}"
    echo "# Generated : $(date)"
    echo "# Steps     : ${num_steps}"
    echo "# Target    : ${TARGET}"
    echo ""
    echo "$all_prompts"
  } > "$chain_file"

  echo -e "\n${BOLD}${G}═══ CHAIN COMPLETE ═══${NC}"
  cat "$chain_file"
  echo -e "${BOLD}${G}═══════════════════════${NC}"

  log_ok "Chain saved : ${chain_file}"
  copy_to_clipboard "$(cat "$chain_file")"
}

# ═══════════════════════════════════════════════════════════════
# VAULT BROWSERS
# ═══════════════════════════════════════════════════════════════
browse_history() {
  echo -e "\n${BOLD}${C}  PROMPT HISTORY${NC}"
  echo -e "  ${DIM}~/.prompt-vault/history/${NC}\n"

  local files=()
  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(find "${HISTORY_DIR}" -name "*.prompt" -print0 2>/dev/null | sort -rz)

  if [[ "${#files[@]}" -eq 0 ]]; then
    log_warn "No prompts in history yet. Run 'pg' to generate your first prompt."
    return
  fi

  local i=1
  for f in "${files[@]}"; do
    local size
    size=$(wc -c < "$f" | tr -d ' ')
    echo -e "  ${C}${i})${NC} $(basename "$f")  ${DIM}[${size}b]${NC}"
    ((i++))
  done

  echo ""
  echo -ne "  Enter number to view (Enter to exit): "
  local choice
  read -r choice

  if [[ "$choice" =~ ^[0-9]+$ ]] && \
     [[ "$choice" -ge 1 && "$choice" -le "${#files[@]}" ]]; then
    local target_file="${files[$((choice-1))]}"
    echo ""
    echo -e "${W}$(cat "$target_file")${NC}"
    echo ""
    if confirm "Copy to clipboard?"; then
      copy_to_clipboard "$(cat "$target_file")"
    fi
  fi
}

browse_personas() {
  echo -e "\n${BOLD}${C}  PERSONA VAULT${NC}"
  echo -e "  ${DIM}~/.prompt-vault/personas/${NC}\n"

  local found=false
  while IFS= read -r -d '' f; do
    found=true
    echo -e "  ${BOLD}${Y}$(basename "$f" .persona)${NC}"
    echo -e "  ${DIM}$(cat "$f")${NC}"
    echo ""
  done < <(find "${PERSONAS_DIR}" -name "*.persona" -print0 2>/dev/null | sort -z)

  [[ "$found" == false ]] && log_warn "No personas found. They are created automatically when you run pg."
}

browse_templates() {
  echo -e "\n${BOLD}${C}  TEMPLATE VAULT${NC}"
  echo -e "  ${DIM}~/.prompt-vault/templates/${NC}\n"

  local files=()
  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(find "${TEMPLATES_DIR}" -name "*.template" -print0 2>/dev/null | sort -z)

  if [[ "${#files[@]}" -eq 0 ]]; then
    log_warn "No templates saved yet. Generate a high-quality prompt and choose to save it."
    return
  fi

  local i=1
  for f in "${files[@]}"; do
    echo -e "  ${C}${i})${NC} $(basename "$f" .template)"
    ((i++))
  done

  echo ""
  echo -ne "  Enter number to load (Enter to exit): "
  local choice
  read -r choice

  if [[ "$choice" =~ ^[0-9]+$ ]] && \
     [[ "$choice" -ge 1 && "$choice" -le "${#files[@]}" ]]; then
    local tmpl="${files[$((choice-1))]}"
    FINAL_PROMPT=$(cat "$tmpl")
    echo ""
    echo -e "${W}${FINAL_PROMPT}${NC}"
    echo ""
    if confirm "Copy to clipboard?"; then
      copy_to_clipboard "$FINAL_PROMPT"
    fi
  fi
}

browse_patterns() {
  echo -e "\n${BOLD}${C}  LEARNING PATTERNS LOG${NC}"
  echo -e "  ${DIM}~/.prompt-vault/patterns/what-worked.log${NC}\n"

  if [[ -f "${PATTERNS_DIR}/what-worked.log" ]]; then
    cat "${PATTERNS_DIR}/what-worked.log"
  else
    log_warn "No patterns logged yet."
    echo -e "  ${DIM}Use the feedback engine after running a prompt (Layer 17) to build your library.${NC}"
  fi
}

# ═══════════════════════════════════════════════════════════════
# HELP
# ═══════════════════════════════════════════════════════════════
show_help() {
  cat <<'HELP'

╔══════════════════════════════════════════════════════════════════════╗
║  UNIVERSAL PROMPT GENERATION ENGINE — pg v4.0                        ║
║  17 Layers · 10 PE Principles · 8 Modes · 5 AI Targets              ║
║  A prompt is a precision contract between you and an AI.             ║
╚══════════════════════════════════════════════════════════════════════╝

USAGE
  pg [options] "seed"

OPTIONS
  --target <ai>      AI output target:
                       claude        XML system+user blocks
                       claude-code   agentic spec-aware terminal format
                       copilot       IDE inline docstring format
                       copilot-chat  IDE slash command format
                       universal     clean natural language, any AI

  --mode <mode>      Task mode:
                       Software: code · debug · refactor · spec · architect
                                 review · document · test
                       Writing:  write · communicate
                       Analysis: research · analyze · decide · plan · create
                       Learning: learn
                       Life:     daily · email

  --quick            30 sec: seed + target → instant prompt
  --standard         2 min: guided key questions (default)
  --deep             5 min: full interview, maximum quality

  --chain            Generate multi-prompt chain sequence
  --from-clipboard   Read seed context from clipboard
  --spec <file>      Reference a spec file (auto-enables SCWA mode)

  --history          Browse prompt history vault
  --personas         Browse persona vault
  --templates        Browse template vault
  --patterns         View feedback + learning log

  -h, --help         Show this help

EXAMPLES
  # Quick code task
  pg --quick --target claude-code "refactor auth module"

  # Guided debug session
  pg --target claude --mode debug "fix webhook retry logic"

  # Full spec-driven deep session
  pg --deep --target claude --mode spec --spec ./specs/payment.md

  # Decision making
  pg --mode decide "PostgreSQL vs MongoDB for time-series events"

  # Learning
  pg --mode learn "explain JWT refresh token rotation"

  # Daily life
  pg --mode daily "write email declining the meeting politely"

  # Chain mode — complex task
  pg --chain --target claude "build complete payment gateway integration"

  # From clipboard
  pg --from-clipboard --target copilot

  # Vault tools
  pg --history
  pg --personas
  pg --templates
  pg --patterns

VAULT STRUCTURE
  ~/.prompt-vault/
  ├── history/    — every prompt generated (timestamped)
  ├── personas/   — reusable AI role definitions
  ├── templates/  — winning prompts as reusable templates
  ├── chains/     — multi-prompt sequences
  └── patterns/   — feedback and learning log

FRAMEWORK AUTO-SELECTION
  code / debug / refactor / test  →  RISEN
  spec                            →  SCWA-NATIVE
  architect / plan                →  COAST
  review / research / analyze     →  CARE
  write / document / communicate  →  STAR
  decide                          →  DECISION MATRIX
  learn                           →  FEYNMAN
  daily / email                   →  PREP

PE PRINCIPLES ALWAYS APPLIED
  1. Role Depth          — specific, experienced persona
  2. Chain of Thought    — "think step by step"
  3. Gap Framing         — current → desired → bridge
  4. Negative Space      — explicit walls and constraints
  5. Few-Shot Anchor     — example of good output (deep mode)
  6. Uncertainty Flag    — [UNCERTAIN] marking required
  7. Output Schema       — format, length, tone always defined
  8. Context Complete    — AI should never need to assume
  9. Constraint Clear    — hard limits stated early and explicitly
  10. Anti-Hallucinate   — "ask, don't assume or invent"

DAILY WORKFLOW
  8AM  coding    →  pg --mode code --target claude-code --quick
  1PM  research  →  pg --mode research --target claude --quick
  9PM  deep work →  pg --mode spec --target claude --deep

HELP

}

# ═══════════════════════════════════════════════════════════════
# MAIN FLOW
# ═══════════════════════════════════════════════════════════════
main_flow() {
  banner "v4.0  ·  $(date +'%Y-%m-%d  %H:%M')"

  layer1_boot

  # Seed collection
  if [[ -z "$SEED" ]]; then
    section "SEED — What do you need the AI to do?"
    echo -e "  ${DIM}Plain language. Brief or detailed — the engine handles both.${NC}"
    echo ""
    ask "Task:" "SEED" ""
    if [[ -z "$SEED" ]]; then
      log_err "A task seed is required. Try: pg \"your task here\""
      exit 1
    fi
  fi

  layer2_speed
  layer3_target
  layer4_classify
  layer5_gap
  layer6_context
  layer7_persona
  layer8_calibration
  layer9_fewshot
  layer10_negative
  layer11_complexity
  layer12_techniques
  layer15_render
  layer13_score
  layer14_refine
  layer16_deliver
  layer17_learn

  echo -e "\n${BOLD}${G}  ✓ Engine complete. Prompt in clipboard. Prompt in vault.${NC}\n"
}

# ═══════════════════════════════════════════════════════════════
# ARGUMENT PARSER
# ═══════════════════════════════════════════════════════════════
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --target|-t)  TARGET="$2"; TARGET_LOCKED=true; shift 2 ;;
      --mode|-m)    MODE="$2";     shift 2 ;;
      --quick|-q)   SPEED="quick"; shift ;;
      --standard)   SPEED="standard"; shift ;;
      --deep|-d)    SPEED="deep";  shift ;;
      --chain)      IS_CHAIN=true; shift ;;
      --from-clipboard|--clip) FROM_CLIP=true; shift ;;
      --spec|-s)    SPEC_FILE="$2"; shift 2 ;;
      --history)    init_vault; browse_history;  exit 0 ;;
      --personas)   init_vault; browse_personas; exit 0 ;;
      --templates)  init_vault; browse_templates; exit 0 ;;
      --patterns)   init_vault; browse_patterns;  exit 0 ;;
      --help|-h)    show_help; exit 0 ;;
      --*)
        echo -e "${R}Unknown option: $1${NC}"
        show_help
        exit 1
        ;;
      *)
        # Positional = seed
        if [[ -z "$SEED" ]]; then
          SEED="$1"
        fi
        shift
        ;;
    esac
  done
}

# ═══════════════════════════════════════════════════════════════
# ENTRY POINT
# ═══════════════════════════════════════════════════════════════
main() {
  parse_args "$@"
  init_vault

  # Chain-only entry point
  if [[ "$IS_CHAIN" == true && -z "$SEED" ]]; then
    banner "CHAIN MODE  ·  $(date +'%Y-%m-%d  %H:%M')"
    layer1_boot
    layer3_target
    layer4_classify
    layer12_techniques
    generate_chain
    exit 0
  fi

  main_flow
}

main "$@"
