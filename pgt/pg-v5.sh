#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════════╗
# ║  UNIVERSAL PROMPT GENERATION ENGINE — pg v5.0 ENHANCED              ║
# ║  17 Layers · 10 PE Principles · 8 Modes · 5 AI Targets             ║
# ║  NEW: Quick Mode · Templates · Framework Integration · Windows      ║
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
TEMPLATE_NAME=""
USE_TEMPLATE=false
INCLUDE_FILES=()
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
# TEMPLATE PRESETS — NEW in v5.0
# ═══════════════════════════════════════════════════════════════
declare -A TEMPLATE_PRESETS=(
  [debug-root-cause]="mode:debug|persona:debugging-specialist|negatives:no shotgun debugging,no guessing,no unrelated changes"
  [feature-from-spec]="mode:spec|persona:scwa-reviewer|negatives:no scope creep,no spec violations"
  [refactor-safe]="mode:refactor|persona:senior-backend|negatives:no behavior changes,no new features"
  [pr-review]="mode:review|persona:senior-backend|negatives:no nitpicking,focus on logic and security"
  [quick-code]="mode:code|persona:senior-backend|speed:quick"
  [daily-email]="mode:email|persona:tech-writer|tone:professional"
  [architecture-decision]="mode:decide|persona:decision-advisor|framework:DECISION"
  [learn-concept]="mode:learn|persona:tech-writer|framework:FEYNMAN"
  [backend-feature]="mode:code|persona:senior-backend|framework:RISEN|negatives:no premature optimization"
  [documentation]="mode:document|persona:tech-writer|framework:STAR|tone:clear"
)

# ═══════════════════════════════════════════════════════════════
# INIT — Create vault + seed default personas + templates
# ═══════════════════════════════════════════════════════════════
init_vault() {
  mkdir -p "${HISTORY_DIR}" "${PERSONAS_DIR}" "${TEMPLATES_DIR}" \
           "${CHAINS_DIR}" "${PATTERNS_DIR}"

  # Seed personas
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

  # Seed templates — NEW in v5.0
  seed_templates
}

# ═══════════════════════════════════════════════════════════════
# SEED TEMPLATES — NEW in v5.0
# ═══════════════════════════════════════════════════════════════
seed_templates() {
  # Debug Root Cause Template
  if [[ ! -f "${TEMPLATES_DIR}/debug-root-cause.template" ]]; then
    cat > "${TEMPLATES_DIR}/debug-root-cause.template" <<'EOF'
<task>Debug and identify root cause</task>

<persona>
You are a debugging specialist with expertise in hypothesis-driven investigation. You isolate issues methodically without guessing or making shotgun changes.
</persona>

<problem>
{{SEED}}
</problem>

<current-state>
{{CURRENT_STATE}}
</current-state>

<desired-state>
System behaves correctly without the reported issue.
</desired-state>

<approach>
1. Reproduce the issue reliably
2. Form hypothesis about root cause
3. Test hypothesis with minimal changes
4. Confirm or discard hypothesis
5. Apply minimal fix only when root cause is confirmed
</approach>

<hard-constraints>
- NO shotgun debugging (changing multiple things at once)
- NO guessing — every change must test a specific hypothesis
- NO unrelated changes or "improvements" while debugging
- Mark [UNCERTAIN] if root cause is not yet confirmed
</hard-constraints>

<output-format>
1. Hypothesis: [Your theory about the root cause]
2. Test Plan: [How to confirm this hypothesis]
3. Expected Evidence: [What you expect to find if hypothesis is correct]
4. Fix (only if hypothesis confirmed): [Minimal code change]
</output-format>
EOF
  fi

  # Feature from Spec Template
  if [[ ! -f "${TEMPLATES_DIR}/feature-from-spec.template" ]]; then
    cat > "${TEMPLATES_DIR}/feature-from-spec.template" <<'EOF'
<task>Implement feature according to specification</task>

<persona>
You are a SCWA (Spec-Constrained Workflow Architecture) expert. You treat specifications as binding contracts and never deviate without explicit written approval.
</persona>

<specification>
{{SPEC_FILE_CONTENT}}
</specification>

<implementation-task>
{{SEED}}
</implementation-task>

<hard-constraints>
- Implement ONLY what is specified — nothing more, nothing less
- NO scope creep — flag any requirements not in the spec
- NO assumptions — ask if spec is ambiguous
- NO "improvements" or refactors outside stated scope
- Mark [OUT-OF-SPEC] if requested work is not specified
</hard-constraints>

<validation-checklist>
Before completing, verify:
□ Every requirement in spec is addressed
□ No extra features added
□ No behavior changed outside spec scope
□ All spec constraints honored
</validation-checklist>

<output-format>
Implementation: [Code changes]
Spec Coverage: [Checklist of spec items implemented]
Out-of-Scope Items: [Anything requested but not in spec]
</output-format>
EOF
  fi

  # Safe Refactor Template
  if [[ ! -f "${TEMPLATES_DIR}/refactor-safe.template" ]]; then
    cat > "${TEMPLATES_DIR}/refactor-safe.template" <<'EOF'
<task>Refactor code safely without changing behavior</task>

<persona>
You are a senior backend engineer. You refactor for readability and maintainability while preserving exact behavior.
</persona>

<refactor-target>
{{SEED}}
</refactor-target>

<refactor-principles>
- Preserve all existing behavior exactly
- Improve code structure and readability
- Reduce duplication where safe
- Maintain test coverage
</refactor-principles>

<hard-constraints>
- NO behavior changes
- NO new features
- NO changes to public API contracts
- NO performance optimizations (unless explicitly requested)
- Mark [BEHAVIOR-CHANGE] if refactor might affect external behavior
</hard-constraints>

<validation>
Before completing:
□ All existing tests still pass
□ No public API changes
□ Behavior identical to original
□ Code is more readable/maintainable
</validation>

<output-format>
Refactored Code: [Code]
What Changed: [Structure improvements]
What Stayed the Same: [Behavior guarantees]
</output-format>
EOF
  fi

  # PR Review Template
  if [[ ! -f "${TEMPLATES_DIR}/pr-review.template" ]]; then
    cat > "${TEMPLATES_DIR}/pr-review.template" <<'EOF'
<task>Review pull request for logic, security, and correctness</task>

<persona>
You are a senior engineer reviewing code for production deployment. You focus on logic errors, security vulnerabilities, and architectural concerns — not style nitpicks.
</persona>

<pr-context>
{{SEED}}
</pr-context>

<review-focus>
- Logic errors and edge cases
- Security vulnerabilities (injection, XSS, auth bypass, etc.)
- Performance bottlenecks
- Error handling gaps
- Breaking changes to API contracts
</review-focus>

<hard-constraints>
- NO nitpicking about formatting (assume linter handles it)
- Focus on HIGH and MEDIUM severity issues only
- Provide specific line numbers and fix suggestions
- Mark [BLOCKING] for critical issues that must be fixed before merge
</hard-constraints>

<output-format>
Summary: [Overall assessment]

Issues Found:
[BLOCKING] Issue 1: [Description + line number + fix suggestion]
[HIGH] Issue 2: [Description + line number + fix suggestion]

Recommendation: [APPROVE | REQUEST CHANGES | NEEDS DISCUSSION]
</output-format>
EOF
  fi

  # Quick Code Template
  if [[ ! -f "${TEMPLATES_DIR}/quick-code.template" ]]; then
    cat > "${TEMPLATES_DIR}/quick-code.template" <<'EOF'
<task>{{SEED}}</task>

<persona>Senior backend engineer. Write clean, production-quality code.</persona>

<context>
{{BOOT_CONTEXT}}
</context>

<hard-constraints>
- Write complete, tested, production-ready code
- Include error handling
- No TODO comments
- No placeholder implementations
</hard-constraints>

<output-format>
[Code only — no explanation unless asked]
</output-format>
EOF
  fi

  # Architecture Decision Template
  if [[ ! -f "${TEMPLATES_DIR}/architecture-decision.template" ]]; then
    cat > "${TEMPLATES_DIR}/architecture-decision.template" <<'EOF'
<task>Make architectural decision</task>

<persona>
You are a technology decision advisor. You evaluate options using weighted criteria and deliver a clear recommendation with stated confidence and trade-offs.
</persona>

<decision-needed>
{{SEED}}
</decision-needed>

<decision-framework>
1. Identify options (at least 3 if possible)
2. Define evaluation criteria (weighted by importance)
3. Score each option against criteria
4. Acknowledge trade-offs
5. Deliver ONE clear recommendation with confidence level
</decision-framework>

<hard-constraints>
- NO "it depends" without then making a choice
- NO false balance — pick the best option
- State confidence level (High 90%+ | Medium 70-90% | Low <70%)
- Acknowledge what you're sacrificing with your choice
</hard-constraints>

<output-format>
## Options Considered
[List 3+ options]

## Evaluation Criteria (Weighted)
[List criteria with weights]

## Scoring Matrix
[Table: Option vs Criteria with scores]

## Recommendation
**Choose: [Option X]**
Confidence: [High/Medium/Low - percentage]

Trade-offs Accepted:
- Sacrificing [Y] to gain [Z]

Why This Choice:
[2-3 sentences]
</output-format>
EOF
  fi

  # Learn Concept Template
  if [[ ! -f "${TEMPLATES_DIR}/learn-concept.template" ]]; then
    cat > "${TEMPLATES_DIR}/learn-concept.template" <<'EOF'
<task>Explain concept using Feynman Technique</task>

<persona>
You are a technical educator using the Feynman Technique: explain complex topics in simple language, use analogies, identify gaps, and refine until crystal clear.
</persona>

<concept-to-learn>
{{SEED}}
</concept-to-learn>

<feynman-method>
1. Explain in simple language (as if to a beginner)
2. Use concrete analogies from everyday life
3. Identify gaps in understanding
4. Refine explanation until no jargon remains
</feynman-method>

<hard-constraints>
- NO undefined jargon or acronyms
- NO hand-waving ("it just works")
- Use analogies grounded in physical world
- Mark [COMPLEX] if a prerequisite concept needs explanation first
</hard-constraints>

<output-format>
## Simple Explanation
[Explain in plain English]

## Analogy
[Real-world comparison]

## Key Insight
[The "aha!" moment in one sentence]

## Prerequisites
[What you need to know first, if anything]

## Common Misconceptions
[What people get wrong]
</output-format>
EOF
  fi

  # Daily Email Template
  if [[ ! -f "${TEMPLATES_DIR}/daily-email.template" ]]; then
    cat > "${TEMPLATES_DIR}/daily-email.template" <<'EOF'
<task>Compose professional email</task>

<persona>
You are a professional communicator. Your emails are clear, respectful, concise, and get to the point quickly.
</persona>

<email-purpose>
{{SEED}}
</email-purpose>

<tone>
{{TONE}}
</tone>

<structure>
1. Clear subject line
2. Greeting
3. Context (1 sentence if needed)
4. Main message (2-4 sentences)
5. Call to action (if applicable)
6. Professional closing
</structure>

<hard-constraints>
- Maximum 150 words for body
- No passive-aggressive language
- No unnecessary apologies
- Clear and direct
</hard-constraints>

<output-format>
Subject: [Clear, specific subject]

[Email body]
</output-format>
EOF
  fi

  # Backend Feature Template
  if [[ ! -f "${TEMPLATES_DIR}/backend-feature.template" ]]; then
    cat > "${TEMPLATES_DIR}/backend-feature.template" <<'EOF'
<task>Build backend feature using RISEN framework</task>

<persona>
Senior backend engineer with expertise in distributed systems, API design, and production-quality code.
</persona>

<feature-request>
{{SEED}}
</feature-request>

<risen-framework>
R — Requirements: What must this feature do?
I — Implementation: How will it work?
S — Security: What are the security implications?
E — Edge Cases: What can go wrong?
N — Next Steps: What happens after implementation?
</risen-framework>

<hard-constraints>
- Include input validation
- Include error handling
- Consider concurrency issues
- No premature optimization
- Mark [SECURITY-RISK] for any security-sensitive code
</hard-constraints>

<output-format>
## Requirements Analysis
[List functional requirements]

## Implementation
[Code with inline comments for key decisions]

## Security Considerations
[Auth, validation, injection risks, etc.]

## Edge Cases Handled
[List with code references]

## Tests Needed
[List test cases]
</output-format>
EOF
  fi

  # Documentation Template
  if [[ ! -f "${TEMPLATES_DIR}/documentation.template" ]]; then
    cat > "${TEMPLATES_DIR}/documentation.template" <<'EOF'
<task>Write clear technical documentation</task>

<persona>
You are a senior technical writer. You write documentation that developers actually want to read: clear, example-driven, jargon-free, and structured.
</persona>

<documentation-subject>
{{SEED}}
</documentation-subject>

<star-framework>
S — Situation: What is this? Why does it exist?
T — Task: What does it do?
A — Action: How do you use it?
R — Result: What outcome do you get?
</star-framework>

<hard-constraints>
- Include code examples for every major concept
- Define all acronyms on first use
- Use active voice
- Keep paragraphs under 4 sentences
- Include "Quick Start" section
</hard-constraints>

<output-format>
# [Title]

## What is this?
[1-2 sentence overview]

## Quick Start
[Code example that works immediately]

## How it works
[Explanation with examples]

## API Reference (if applicable)
[Methods/functions with signatures and examples]

## Common Pitfalls
[What to avoid]
</output-format>
EOF
  fi
}

# ═══════════════════════════════════════════════════════════════
# WINDOWS COMPATIBILITY — NEW in v5.0
# ═══════════════════════════════════════════════════════════════
detect_os() {
  if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" || "$OSTYPE" == "cygwin" ]]; then
    echo "windows"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "macos"
  else
    echo "linux"
  fi
}

OS_TYPE=$(detect_os)

# ═══════════════════════════════════════════════════════════════
# UI HELPERS
# ═══════════════════════════════════════════════════════════════
banner() {
  echo -e ""
  echo -e "${BOLD}${C}╔══════════════════════════════════════════════════════════════╗${NC}"
  printf "${BOLD}${C}║  🧠 PROMPT ENGINE v5.0  ·  %-34s  ║${NC}\n" "$1"
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
# CLIPBOARD — Windows-compatible in v5.0
# ═══════════════════════════════════════════════════════════════
copy_to_clipboard() {
  local content="$1"
  if [[ "$OS_TYPE" == "windows" ]]; then
    echo -n "$content" | clip.exe && log_ok "Copied to clipboard (clip.exe)"
  elif command -v pbcopy &>/dev/null; then
    echo -n "$content" | pbcopy && log_ok "Copied to clipboard (pbcopy)"
  elif command -v xclip &>/dev/null; then
    echo -n "$content" | xclip -selection clipboard && log_ok "Copied to clipboard (xclip)"
  elif command -v xsel &>/dev/null; then
    echo -n "$content" | xsel --clipboard --input && log_ok "Copied to clipboard (xsel)"
  elif command -v wl-copy &>/dev/null; then
    echo -n "$content" | wl-copy && log_ok "Copied to clipboard (wl-copy)"
  else
    log_warn "No clipboard tool found."
  fi
}

read_clipboard() {
  if [[ "$OS_TYPE" == "windows" ]]; then
    powershell.exe -command "Get-Clipboard" 2>/dev/null || echo ""
  elif command -v pbpaste &>/dev/null; then
    pbpaste
  elif command -v xclip &>/dev/null; then
    xclip -selection clipboard -o 2>/dev/null || echo ""
  elif command -v xsel &>/dev/null; then
    xsel --clipboard --output 2>/dev/null || echo ""
  elif command -v wl-paste &>/dev/null; then
    wl-paste 2>/dev/null || echo ""
  else
    echo ""
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 1 — BOOT INTELLIGENCE (Enhanced with framework integration)
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

  # Framework Integration — NEW in v5.0
  # Auto-read SESSION_LOG.md if present
  if [[ -f "SESSION_LOG.md" ]]; then
    log_info "SESSION_LOG.md found — injecting recent context"
    SESSION_CONTEXT=$(tail -50 SESSION_LOG.md 2>/dev/null || echo "")
  fi

  # Build boot context summary
  BOOT_CONTEXT="Env: ${BOOT_LANG}"
  [[ -n "$git_repo" ]]   && BOOT_CONTEXT="${BOOT_CONTEXT} | Repo: ${git_repo}"
  [[ -n "$git_branch" ]] && BOOT_CONTEXT="${BOOT_CONTEXT} | Branch: ${git_branch}"
  [[ -n "$git_dirty" ]]  && BOOT_CONTEXT="${BOOT_CONTEXT} | Status: ${git_dirty}"
  [[ -n "$claude_md" ]]  && BOOT_CONTEXT="${BOOT_CONTEXT} | ${claude_md}"
  [[ -n "$spec_hint" ]]  && BOOT_CONTEXT="${BOOT_CONTEXT} | ${spec_hint}"

  BOOT_BRANCH="$git_branch"
  BOOT_REPO="$git_repo"

  [[ "$SPEED" != "quick" ]] && log_info "$BOOT_CONTEXT"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 2 — SPEED SELECTOR
# ═══════════════════════════════════════════════════════════════
layer2_speed() {
  [[ -n "$SPEED" && "$SPEED" != "standard" ]] && return

  section "LAYER 2 — Speed"
  menu "How much time do you have?" \
    "Quick (30 sec)|Standard (2 min)|Deep (5 min)" \
    "speed_choice" "1"

  case "$speed_choice" in
    "Quick"*) SPEED="quick" ;;
    "Deep"*)  SPEED="deep" ;;
    *)        SPEED="standard" ;;
  esac

  log_info "Speed: ${SPEED}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 3 — TARGET (AI Selection)
# ═══════════════════════════════════════════════════════════════
layer3_target() {
  [[ "$TARGET_LOCKED" == true ]] && return

  if [[ "$SPEED" == "quick" ]]; then
    # Quick mode defaults
    TARGET="claude-code"
    [[ "$TARGET_LOCKED" == false ]] && log_info "Target: ${TARGET} (auto)"
    return
  fi

  section "LAYER 3 — AI Target"
  menu "Which AI are you prompting?" \
    "Claude (API/Chat)|Claude Code (Terminal)|Copilot (Inline)|Copilot Chat|Universal" \
    "target_choice" "2"

  case "$target_choice" in
    "Claude (API/Chat)")    TARGET="claude" ;;
    "Claude Code"*)         TARGET="claude-code" ;;
    "Copilot (Inline)")     TARGET="copilot" ;;
    "Copilot Chat"*)        TARGET="copilot-chat" ;;
    *)                      TARGET="universal" ;;
  esac

  log_info "Target: ${TARGET}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 4 — CLASSIFY (Mode + Framework)
# ═══════════════════════════════════════════════════════════════
layer4_classify() {
  if [[ -n "$MODE" ]]; then
    FRAMEWORK="${FRAMEWORK_MAP[$MODE]:-CARE}"
    log_info "Mode: ${MODE} | Framework: ${FRAMEWORK}"
    return
  fi

  if [[ "$SPEED" == "quick" ]]; then
    # Auto-classify in quick mode
    MODE="code"
    FRAMEWORK="RISEN"
    log_info "Mode: ${MODE} (auto) | Framework: ${FRAMEWORK}"
    return
  fi

  section "LAYER 4 — Mode Classification"
  menu "What type of task?" \
    "Code/Build|Debug|Refactor|Spec Implementation|Architecture/Planning|Review|Research/Analysis|Documentation|Decision|Learn|Daily/Email" \
    "mode_choice" "1"

  case "$mode_choice" in
    "Code/Build")           MODE="code" ;;
    "Debug")                MODE="debug" ;;
    "Refactor")             MODE="refactor" ;;
    "Spec Implementation")  MODE="spec" ;;
    "Architecture"*)        MODE="architect" ;;
    "Review")               MODE="review" ;;
    "Research"*)            MODE="research" ;;
    "Documentation")        MODE="document" ;;
    "Decision")             MODE="decide" ;;
    "Learn")                MODE="learn" ;;
    "Daily"*)               MODE="daily" ;;
  esac

  FRAMEWORK="${FRAMEWORK_MAP[$MODE]:-CARE}"
  log_info "Mode: ${MODE} | Framework: ${FRAMEWORK}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 5 — GAP FRAMING
# ═══════════════════════════════════════════════════════════════
layer5_gap() {
  [[ "$SPEED" == "quick" ]] && return

  section "LAYER 5 — Gap Framing"
  echo -e "  ${DIM}Current → Desired (what needs to change?)${NC}"

  if [[ "$SPEED" == "deep" ]]; then
    ask "Current state:" "CURRENT_STATE" "Unknown"
    ask "Desired state:" "DESIRED_STATE" "Complete the task successfully"
    ask "Main gap/blocker:" "GAP_DESCRIPTION" "Need implementation"
    ask "Risk if done wrong:" "RISK_STATEMENT" "Bugs or incorrect behavior"
  else
    CURRENT_STATE="Starting point"
    DESIRED_STATE="Task completed correctly"
    GAP_DESCRIPTION="Need implementation"
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 6 — CONTEXT INJECTION (Enhanced with framework integration)
# ═══════════════════════════════════════════════════════════════
layer6_context() {
  section "LAYER 6 — Context"

  # Spec file handling
  if [[ -n "$SPEC_FILE" && -f "$SPEC_FILE" ]]; then
    local spec_content
    spec_content=$(cat "$SPEC_FILE")
    EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<specification>\n${spec_content}\n</specification>"
    log_ok "Spec file loaded: ${SPEC_FILE}"
  fi

  # Include files — NEW in v5.0
  if [[ "${#INCLUDE_FILES[@]}" -gt 0 ]]; then
    for file in "${INCLUDE_FILES[@]}"; do
      if [[ -f "$file" ]]; then
        local file_content
        file_content=$(cat "$file")
        EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<file path=\"${file}\">\n${file_content}\n</file>"
        log_ok "Included file: ${file}"
      else
        log_warn "File not found: ${file}"
      fi
    done
  fi

  # Framework Integration — NEW in v5.0
  # Inject SESSION_LOG.md context if present
  if [[ -n "$SESSION_CONTEXT" ]]; then
    EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<session-history>\nRecent context from SESSION_LOG.md:\n${SESSION_CONTEXT}\n</session-history>"
  fi

  # Check for .claude/decisions.md
  if [[ -f ".claude/history/decisions.md" ]]; then
    local recent_decisions
    recent_decisions=$(tail -100 .claude/history/decisions.md 2>/dev/null || echo "")
    if [[ -n "$recent_decisions" ]]; then
      EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<architectural-decisions>\nRecent decisions to consider:\n${recent_decisions}\n</architectural-decisions>"
      log_info "Injected recent architectural decisions"
    fi
  fi

  # List available skills if Claude Code target — NEW in v5.0
  if [[ "$TARGET" == "claude-code" && -d "skills" ]]; then
    local skills_list
    skills_list=$(find skills -name "*.md" 2>/dev/null | sed 's|skills/||g' | sed 's|.md||g' | head -10 | paste -sd ',' -)
    if [[ -n "$skills_list" ]]; then
      EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<available-skills>\nYou can invoke these skills: ${skills_list}\n</available-skills>"
      log_info "Listed available skills"
    fi
  fi

  # Clipboard context
  if [[ "$FROM_CLIP" == true ]]; then
    CLIP_CONTENT=$(read_clipboard)
    if [[ -n "$CLIP_CONTENT" ]]; then
      EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<clipboard-context>\n${CLIP_CONTENT}\n</clipboard-context>"
      log_ok "Clipboard content loaded ($(echo "$CLIP_CONTENT" | wc -c | tr -d ' ') chars)"
    else
      log_warn "Clipboard is empty"
    fi
  fi

  # Interactive context (standard/deep mode)
  if [[ "$SPEED" != "quick" ]]; then
    if confirm "Add extra context?"; then
      ask "Context details:" "extra_context_input" ""
      [[ -n "$extra_context_input" ]] && EXTRA_CONTEXT="${EXTRA_CONTEXT}\n${extra_context_input}"
    fi
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 7 — PERSONA INJECTION
# ═══════════════════════════════════════════════════════════════
layer7_persona() {
  section "LAYER 7 — Persona"

  # Auto-select persona based on mode
  case "$MODE" in
    debug)      PERSONA_NAME="debugging-specialist" ;;
    spec)       PERSONA_NAME="scwa-reviewer" ;;
    decide)     PERSONA_NAME="decision-advisor" ;;
    document|write|communicate) PERSONA_NAME="tech-writer" ;;
    *)          PERSONA_NAME="senior-backend" ;;
  esac

  local persona_file="${PERSONAS_DIR}/${PERSONA_NAME}.persona"
  if [[ -f "$persona_file" ]]; then
    PERSONA_DEF=$(cat "$persona_file")
    [[ "$SPEED" != "quick" ]] && log_info "Persona: ${PERSONA_NAME}"
  else
    PERSONA_DEF="You are an expert AI assistant."
    log_warn "Persona file not found, using default"
  fi

  # Override option in standard/deep mode
  if [[ "$SPEED" == "deep" ]]; then
    if confirm "Use a different persona?"; then
      local available_personas
      available_personas=$(find "${PERSONAS_DIR}" -name "*.persona" 2>/dev/null | xargs -n1 basename | sed 's/.persona//g' | paste -sd '|')
      if [[ -n "$available_personas" ]]; then
        menu "Select persona:" "$available_personas" "PERSONA_NAME"
        persona_file="${PERSONAS_DIR}/${PERSONA_NAME}.persona"
        [[ -f "$persona_file" ]] && PERSONA_DEF=$(cat "$persona_file")
      fi
    fi
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 8 — CALIBRATION (Audience, Tone, Length)
# ═══════════════════════════════════════════════════════════════
layer8_calibration() {
  [[ "$SPEED" == "quick" ]] && return

  section "LAYER 8 — Calibration"

  menu "Audience:" \
    "Self (developer)|Team (peer review)|Public (docs/blog)" \
    "AUDIENCE"

  menu "Tone:" \
    "Technical|Professional|Casual|Educational" \
    "TONE"

  menu "Output length:" \
    "Concise|Standard|Detailed" \
    "LENGTH"

  log_info "Calibration: ${AUDIENCE} | ${TONE} | ${LENGTH}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 9 — FEW-SHOT EXAMPLE
# ═══════════════════════════════════════════════════════════════
layer9_fewshot() {
  [[ "$SPEED" != "deep" ]] && return

  section "LAYER 9 — Few-Shot Example"
  echo -e "  ${DIM}Provide an example of desired output format (optional)${NC}"

  if confirm "Include example?"; then
    ask "Example output:" "FEW_SHOT_EXAMPLE" ""
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 10 — NEGATIVE CONSTRAINTS
# ═══════════════════════════════════════════════════════════════
layer10_negative() {
  section "LAYER 10 — Negative Constraints"

  # Auto-populate based on mode
  case "$MODE" in
    debug)
      NEGATIVES="NO shotgun debugging, NO guessing, NO unrelated changes"
      ;;
    spec)
      NEGATIVES="NO scope creep, NO spec violations, NO undocumented changes"
      ;;
    refactor)
      NEGATIVES="NO behavior changes, NO new features, NO premature optimization"
      ;;
    code|build)
      NEGATIVES="NO TODO comments, NO placeholder code, NO magic numbers"
      ;;
    review)
      NEGATIVES="NO nitpicking, focus on logic and security only"
      ;;
    *)
      NEGATIVES="NO assumptions, NO guessing, ask if uncertain"
      ;;
  esac

  [[ "$SPEED" != "quick" ]] && log_info "Constraints: ${NEGATIVES}"

  if [[ "$SPEED" == "deep" ]]; then
    if confirm "Add more constraints?"; then
      ask "Additional constraints:" "extra_negatives" ""
      [[ -n "$extra_negatives" ]] && NEGATIVES="${NEGATIVES}, ${extra_negatives}"
    fi
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 11 — COMPLEXITY ASSESSMENT
# ═══════════════════════════════════════════════════════════════
layer11_complexity() {
  [[ "$SPEED" != "deep" ]] && return

  section "LAYER 11 — Complexity"
  menu "Task complexity:" \
    "Simple (1 file)|Medium (2-5 files)|Complex (6+ files or architecture)" \
    "complexity_level"

  log_info "Complexity: ${complexity_level}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 12 — PE TECHNIQUES INJECTION
# ═══════════════════════════════════════════════════════════════
layer12_techniques() {
  section "LAYER 12 — PE Techniques"

  PE_TECHNIQUES="Chain of Thought, Gap Framing, Negative Constraints, Uncertainty Flagging"

  # Add target-specific techniques
  case "$TARGET" in
    claude|claude-code)
      PE_TECHNIQUES="${PE_TECHNIQUES}, XML Structuring, Prefilling"
      ;;
    copilot*)
      PE_TECHNIQUES="${PE_TECHNIQUES}, Natural Language, Example-Driven"
      ;;
  esac

  # Add framework-specific techniques
  case "$FRAMEWORK" in
    RISEN)
      PE_TECHNIQUES="${PE_TECHNIQUES}, Requirements Analysis, Edge Case Enumeration"
      ;;
    SCWA)
      PE_TECHNIQUES="${PE_TECHNIQUES}, Spec Validation, Delta-Only Changes"
      ;;
    DECISION)
      PE_TECHNIQUES="${PE_TECHNIQUES}, Weighted Criteria, Confidence Scoring"
      ;;
  esac

  [[ "$SPEED" != "quick" ]] && log_info "PE Techniques: ${PE_TECHNIQUES}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 13 — QUALITY SCORING (Enhanced in v5.0)
# ═══════════════════════════════════════════════════════════════
layer13_score() {
  section "LAYER 13 — Quality Score"

  QUALITY_SCORE=0
  local checks=()

  # Basic checks (1 point each)
  [[ -n "$PERSONA_DEF" ]]     && ((QUALITY_SCORE++)) && checks+=("✓ Persona")     || checks+=("✗ Persona")
  [[ -n "$EXTRA_CONTEXT" ]]   && ((QUALITY_SCORE++)) && checks+=("✓ Context")     || checks+=("✗ Context")
  [[ -n "$NEGATIVES" ]]       && ((QUALITY_SCORE++)) && checks+=("✓ Constraints") || checks+=("✗ Constraints")
  [[ -n "$FRAMEWORK" ]]       && ((QUALITY_SCORE++)) && checks+=("✓ Framework")   || checks+=("✗ Framework")

  # Enhanced checks — NEW in v5.0 (2 points each)

  # Token count check
  local token_estimate
  token_estimate=$(echo "$FINAL_PROMPT" | wc -w | tr -d ' ')
  if [[ "$token_estimate" -lt 2000 ]]; then
    ((QUALITY_SCORE+=2))
    checks+=("✓ Token count OK (${token_estimate} words)")
  else
    checks+=("⚠ Token count high (${token_estimate} words)")
  fi

  # Ambiguity detection
  local ambiguous_words
  ambiguous_words=$(echo "$SEED" | grep -oiE '\b(better|improve|fix|enhance|optimize)\b' | wc -l | tr -d ' ')
  if [[ "$ambiguous_words" -eq 0 ]]; then
    ((QUALITY_SCORE+=2))
    checks+=("✓ No vague words")
  else
    checks+=("⚠ Contains ${ambiguous_words} vague term(s)")
  fi

  # Specificity check
  if echo "$SEED" | grep -qE '\.(js|py|go|rs|java|ts|jsx|tsx|md)'; then
    ((QUALITY_SCORE+=2))
    checks+=("✓ Specific files named")
  fi

  # Output format defined
  if echo "$FINAL_PROMPT" | grep -qi "output.*format\|<output-format>"; then
    ((QUALITY_SCORE++))
    checks+=("✓ Output format specified")
  fi

  # Max score: 10
  [[ "$QUALITY_SCORE" -gt 10 ]] && QUALITY_SCORE=10

  echo -e "  ${W}Score: ${QUALITY_SCORE}/10${NC}"
  for check in "${checks[@]}"; do
    echo -e "    ${DIM}${check}${NC}"
  done

  if [[ "$QUALITY_SCORE" -lt 6 ]]; then
    log_warn "Score below 6 — consider adding more context or constraints"
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 14 — REFINE LOOP
# ═══════════════════════════════════════════════════════════════
layer14_refine() {
  [[ "$SPEED" == "quick" ]] && return

  section "LAYER 14 — Refine"

  if confirm "Review and refine prompt?"; then
    menu "Action:" \
      "Accept (use as-is)|Edit (manual change)|Regenerate" \
      "refine_action"

    case "$refine_action" in
      "Edit"*)
        ask "What to change:" "edit_instruction" ""
        if [[ -n "$edit_instruction" ]]; then
          EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\nADJUSTMENT: ${edit_instruction}"
          layer15_render
          layer13_score
        fi
        ;;
      "Regenerate")
        log_info "Regenerating..."
        layer15_render
        layer13_score
        ;;
    esac
  fi
}

# ═══════════════════════════════════════════════════════════════
# LAYER 15 — RENDER (Target-specific prompt generation)
# ═══════════════════════════════════════════════════════════════
layer15_render() {
  section "LAYER 15 — Render"

  case "$TARGET" in
    claude)
      render_claude
      ;;
    claude-code)
      render_claude_code
      ;;
    copilot)
      render_copilot_inline
      ;;
    copilot-chat)
      render_copilot_chat
      ;;
    universal)
      render_universal
      ;;
  esac

  log_ok "Prompt rendered for ${TARGET}"
}

# ═══════════════════════════════════════════════════════════════
# RENDER: Claude (XML structured)
# ═══════════════════════════════════════════════════════════════
render_claude() {
  FINAL_PROMPT="<task>${SEED}</task>

<persona>
${PERSONA_DEF}
</persona>"

  [[ -n "$BOOT_CONTEXT" ]] && FINAL_PROMPT="${FINAL_PROMPT}

<context>
Environment: ${BOOT_CONTEXT}
${EXTRA_CONTEXT}
</context>"

  [[ -n "$CURRENT_STATE" ]] && FINAL_PROMPT="${FINAL_PROMPT}

<current-state>
${CURRENT_STATE}
</current-state>"

  [[ -n "$DESIRED_STATE" ]] && FINAL_PROMPT="${FINAL_PROMPT}

<desired-state>
${DESIRED_STATE}
</desired-state>"

  [[ -n "$FRAMEWORK" ]] && FINAL_PROMPT="${FINAL_PROMPT}

<framework>
Apply ${FRAMEWORK} framework to structure your approach.
</framework>"

  [[ -n "$NEGATIVES" ]] && FINAL_PROMPT="${FINAL_PROMPT}

<hard-constraints>
${NEGATIVES}
Mark [UNCERTAIN] if you need clarification.
</hard-constraints>"

  [[ -n "$FEW_SHOT_EXAMPLE" ]] && FINAL_PROMPT="${FINAL_PROMPT}

<example-output>
${FEW_SHOT_EXAMPLE}
</example-output>"

  FINAL_PROMPT="${FINAL_PROMPT}

<output-format>
Tone: ${TONE}
Length: ${LENGTH}
Audience: ${AUDIENCE}
</output-format>

<thinking>
Think step by step before responding.
</thinking>"
}

# ═══════════════════════════════════════════════════════════════
# RENDER: Claude Code (Agentic terminal format)
# ═══════════════════════════════════════════════════════════════
render_claude_code() {
  FINAL_PROMPT="${SEED}

CONTEXT:
${BOOT_CONTEXT}
${EXTRA_CONTEXT}"

  [[ -f "CLAUDE.md" ]] && FINAL_PROMPT="${FINAL_PROMPT}

NOTE: This project has a CLAUDE.md file. Follow its rules."

  [[ -n "$SPEC_FILE" ]] && FINAL_PROMPT="${FINAL_PROMPT}

SPEC: See specification at ${SPEC_FILE}. Implement exactly as specified."

  FINAL_PROMPT="${FINAL_PROMPT}

PERSONA:
${PERSONA_DEF}

CONSTRAINTS:
${NEGATIVES}

FRAMEWORK: ${FRAMEWORK}

VALIDATION CHECKLIST (before completing):
□ Task completed exactly as requested
□ No out-of-scope changes
□ All constraints honored
□ Tests pass (if applicable)
□ CLAUDE.md rules followed (if applicable)"
}

# ═══════════════════════════════════════════════════════════════
# RENDER: Copilot Inline (FIXED in v5.0 — natural language only)
# ═══════════════════════════════════════════════════════════════
render_copilot_inline() {
  # Copilot inline needs natural language comments, no frameworks
  local comment_prefix="//"
  [[ "$BOOT_LANG" == "Python" ]] && comment_prefix="#"
  [[ "$BOOT_LANG" == "Ruby" ]]   && comment_prefix="#"

  FINAL_PROMPT="${comment_prefix} ${SEED}
${comment_prefix}
${comment_prefix} Context: ${BOOT_CONTEXT}"

  if [[ -n "$EXTRA_CONTEXT" ]]; then
    local clean_context
    clean_context=$(echo "$EXTRA_CONTEXT" | head -3)
    FINAL_PROMPT="${FINAL_PROMPT}
${comment_prefix} ${clean_context}"
  fi

  [[ -n "$NEGATIVES" ]] && FINAL_PROMPT="${FINAL_PROMPT}
${comment_prefix} Constraints: ${NEGATIVES}"

  [[ -n "$FEW_SHOT_EXAMPLE" ]] && FINAL_PROMPT="${FINAL_PROMPT}
${comment_prefix}
${comment_prefix} Example:
${FEW_SHOT_EXAMPLE}"
}

# ═══════════════════════════════════════════════════════════════
# RENDER: Copilot Chat (Slash command style)
# ═══════════════════════════════════════════════════════════════
render_copilot_chat() {
  FINAL_PROMPT="${SEED}

Context:
${BOOT_CONTEXT}

Requirements:
- ${NEGATIVES}

Framework: ${FRAMEWORK}
Persona: ${PERSONA_NAME}"
}

# ═══════════════════════════════════════════════════════════════
# RENDER: Universal (Clean natural language)
# ═══════════════════════════════════════════════════════════════
render_universal() {
  FINAL_PROMPT="Task: ${SEED}

Context:
${BOOT_CONTEXT}
${EXTRA_CONTEXT}

Persona: ${PERSONA_DEF}

Constraints:
${NEGATIVES}

Framework to use: ${FRAMEWORK}

Output should be:
- Tone: ${TONE}
- Length: ${LENGTH}
- Audience: ${AUDIENCE}"
}

# ═══════════════════════════════════════════════════════════════
# LAYER 16 — DELIVER (Save + Copy + Display)
# ═══════════════════════════════════════════════════════════════
layer16_deliver() {
  section "LAYER 16 — Deliver"

  # Save to history
  local history_file="${HISTORY_DIR}/${TS}_${TARGET}_${MODE}.prompt"
  echo "$FINAL_PROMPT" > "$history_file"
  log_ok "Saved to vault: $(basename "$history_file")"

  # Copy to clipboard
  copy_to_clipboard "$FINAL_PROMPT"

  # Display
  print_prompt_box
}

# ═══════════════════════════════════════════════════════════════
# LAYER 17 — LEARN (Feedback loop)
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
# QUICK MODE — NEW in v5.0
# ═══════════════════════════════════════════════════════════════
quick_mode() {
  banner "QUICK MODE  ·  $(date +'%Y-%m-%d  %H:%M')"

  layer1_boot

  # Smart defaults
  TARGET="${TARGET:-claude-code}"
  MODE="${MODE:-code}"
  FRAMEWORK="${FRAMEWORK_MAP[$MODE]:-RISEN}"
  SPEED="quick"

  log_info "Seed: ${SEED}"
  log_info "Target: ${TARGET} | Mode: ${MODE} | Framework: ${FRAMEWORK}"

  layer7_persona
  layer10_negative
  layer12_techniques
  layer15_render
  layer13_score
  layer16_deliver

  echo -e "\n${BOLD}${G}  ✓ Quick mode complete. Prompt in clipboard.${NC}\n"
}

# ═══════════════════════════════════════════════════════════════
# TEMPLATE MODE — NEW in v5.0
# ═══════════════════════════════════════════════════════════════
template_mode() {
  banner "TEMPLATE MODE  ·  ${TEMPLATE_NAME}"

  if [[ ! "${TEMPLATE_PRESETS[$TEMPLATE_NAME]+isset}" ]]; then
    log_err "Template not found: ${TEMPLATE_NAME}"
    echo -e "\n${W}Available templates:${NC}"
    for tmpl in "${!TEMPLATE_PRESETS[@]}"; do
      echo -e "  ${C}·${NC} ${tmpl}"
    done
    exit 1
  fi

  # Parse template preset
  local preset="${TEMPLATE_PRESETS[$TEMPLATE_NAME]}"
  IFS='|' read -ra params <<< "$preset"

  for param in "${params[@]}"; do
    IFS=':' read -r key value <<< "$param"
    case "$key" in
      mode)     MODE="$value" ;;
      persona)  PERSONA_NAME="$value" ;;
      negatives) NEGATIVES="$value" ;;
      framework) FRAMEWORK="$value" ;;
      tone)     TONE="$value" ;;
      speed)    SPEED="$value" ;;
    esac
  done

  # Auto-set framework if not specified
  [[ -z "$FRAMEWORK" ]] && FRAMEWORK="${FRAMEWORK_MAP[$MODE]:-RISEN}"

  layer1_boot
  layer3_target

  # Load template file if exists
  local template_file="${TEMPLATES_DIR}/${TEMPLATE_NAME}.template"
  if [[ -f "$template_file" ]]; then
    local template_content
    template_content=$(cat "$template_file")

    # Replace placeholders
    template_content="${template_content//\{\{SEED\}\}/$SEED}"
    template_content="${template_content//\{\{BOOT_CONTEXT\}\}/$BOOT_CONTEXT}"
    template_content="${template_content//\{\{CURRENT_STATE\}\}/$CURRENT_STATE}"
    template_content="${template_content//\{\{TONE\}\}/$TONE}"

    # Handle SPEC_FILE_CONTENT
    if [[ -n "$SPEC_FILE" && -f "$SPEC_FILE" ]]; then
      local spec_content
      spec_content=$(cat "$SPEC_FILE")
      template_content="${template_content//\{\{SPEC_FILE_CONTENT\}\}/$spec_content}"
    fi

    FINAL_PROMPT="$template_content"
    log_ok "Template loaded: ${TEMPLATE_NAME}"
  else
    # Generate from preset params
    layer7_persona
    layer12_techniques
    layer15_render
  fi

  layer13_score
  layer16_deliver

  echo -e "\n${BOLD}${G}  ✓ Template mode complete. Prompt in clipboard.${NC}\n"
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
    [[ $i -gt 20 ]] && break
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

  echo -e "${W}Built-in Template Presets:${NC}"
  for tmpl in "${!TEMPLATE_PRESETS[@]}"; do
    echo -e "  ${C}·${NC} ${tmpl}"
  done
  echo ""

  local files=()
  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(find "${TEMPLATES_DIR}" -name "*.template" -print0 2>/dev/null | sort -z)

  if [[ "${#files[@]}" -gt 0 ]]; then
    echo -e "${W}Saved Templates:${NC}"
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
  else
    log_warn "No saved templates yet. Generate high-quality prompts (5/5 rating) to auto-save them."
  fi
}

browse_patterns() {
  echo -e "\n${BOLD}${C}  LEARNING PATTERNS LOG${NC}"
  echo -e "  ${DIM}~/.prompt-vault/patterns/what-worked.log${NC}\n"

  if [[ -f "${PATTERNS_DIR}/what-worked.log" ]]; then
    tail -100 "${PATTERNS_DIR}/what-worked.log"
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
║  UNIVERSAL PROMPT GENERATION ENGINE — pg v5.0 ENHANCED               ║
║  NEW: Quick Mode · Template Presets · Framework Integration          ║
║  17 Layers · 10 PE Principles · 8 Modes · 5 AI Targets              ║
╚══════════════════════════════════════════════════════════════════════╝

USAGE
  pg [options] "seed"

OPTIONS
  --target <ai>      AI output target:
                       claude        XML system+user blocks
                       claude-code   agentic spec-aware terminal format
                       copilot       IDE inline natural language (FIXED!)
                       copilot-chat  IDE slash command format
                       universal     clean natural language, any AI

  --mode <mode>      Task mode:
                       Software: code · debug · refactor · spec · architect
                                 review · document · test
                       Writing:  write · communicate
                       Analysis: research · analyze · decide · plan · create
                       Learning: learn
                       Life:     daily · email

  --quick            ⚡ NEW: 30 sec instant mode (smart defaults)
  --standard         2 min guided questions (default)
  --deep             5 min full interview

  --template <name>  ⚡ NEW: Use a template preset (see list below)

  --include <file>   ⚡ NEW: Include file content in context (repeat for multiple)

  --chain            Generate multi-prompt chain sequence
  --from-clipboard   Read seed context from clipboard
  --spec <file>      Reference a spec file (auto-enables SCWA mode)

  --history          Browse prompt history vault
  --personas         Browse persona vault
  --templates        Browse template vault
  --patterns         View feedback + learning log

  -h, --help         Show this help

TEMPLATE PRESETS (--template <name>)
  debug-root-cause        Hypothesis-driven debugging, no guessing
  feature-from-spec       SCWA spec-faithful implementation
  refactor-safe           Behavior-preserving refactors only
  pr-review               Code review for logic/security
  quick-code              Instant code generation
  architecture-decision   Weighted decision matrix
  learn-concept           Feynman technique explanations
  daily-email             Professional email composer
  backend-feature         RISEN framework backend tasks
  documentation           STAR framework docs

EXAMPLES
  # ⚡ NEW: Quick mode (instant)
  pg --quick "refactor auth module"

  # ⚡ NEW: Use template preset
  pg --template debug-root-cause "payment webhook failing"
  pg --template feature-from-spec --spec payment.md "implement retry logic"

  # ⚡ NEW: Include files in context
  pg --mode review --include src/auth.js --include src/middleware.js "review auth flow"

  # Standard guided mode
  pg --target claude --mode debug "fix webhook retry logic"

  # Deep session with spec
  pg --deep --target claude --mode spec --spec ./specs/payment.md

  # Decision making
  pg --mode decide "PostgreSQL vs MongoDB for time-series events"

  # Chain mode
  pg --chain --target claude "build complete payment gateway integration"

  # From clipboard
  pg --from-clipboard --target copilot

  # Vault tools
  pg --history
  pg --templates
  pg --patterns

VAULT STRUCTURE
  ~/.prompt-vault/
  ├── history/    — every prompt generated (timestamped)
  ├── personas/   — reusable AI role definitions
  ├── templates/  — built-in + winning prompts
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

CLAUDE CODE FRAMEWORK INTEGRATION (⚡ NEW in v5.0)
  - Auto-reads SESSION_LOG.md for recent context
  - Injects .claude/history/decisions.md constraints
  - Lists available skills/ directory
  - Respects CLAUDE.md project rules

WINDOWS COMPATIBILITY (⚡ NEW in v5.0)
  - Native clip.exe clipboard support
  - PowerShell Get-Clipboard for reading
  - Tested on Windows 11 + Git Bash

PE PRINCIPLES ALWAYS APPLIED
  1. Role Depth          — specific, experienced persona
  2. Chain of Thought    — "think step by step"
  3. Gap Framing         — current → desired → bridge
  4. Negative Space      — explicit walls and constraints
  5. Few-Shot Anchor     — example of good output (deep mode)
  6. Uncertainty Flag    — [UNCERTAIN] marking required
  7. Output Schema       — format, length, tone always defined
  8. Context Complete    — AI should never need to assume
  9. Constraint Clear    — hard limits stated early
  10. Anti-Hallucinate   — "ask, don't assume or invent"

QUALITY SCORING (⚡ ENHANCED in v5.0)
  - Persona presence
  - Context richness
  - Constraint clarity
  - Token count check (warns if >2000 words)
  - Ambiguity detection (flags vague words)
  - Specificity check (named files preferred)
  - Output format defined

DAILY WORKFLOW
  8AM  coding    →  pg --quick "add JWT refresh"
  1PM  research  →  pg --template learn-concept "CQRS pattern"
  3PM  review    →  pg --template pr-review --include PR-123
  9PM  deep work →  pg --deep --spec feature.md

HELP

}

# ═══════════════════════════════════════════════════════════════
# MAIN FLOW
# ═══════════════════════════════════════════════════════════════
main_flow() {
  banner "v5.0  ·  $(date +'%Y-%m-%d  %H:%M')"

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
      --template)   TEMPLATE_NAME="$2"; USE_TEMPLATE=true; shift 2 ;;
      --include)    INCLUDE_FILES+=("$2"); shift 2 ;;
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

  # Template mode
  if [[ "$USE_TEMPLATE" == true ]]; then
    [[ -z "$SEED" ]] && { log_err "Template mode requires a seed task"; exit 1; }
    template_mode
    exit 0
  fi

  # Chain mode
  if [[ "$IS_CHAIN" == true ]]; then
    [[ -z "$SEED" ]] && { log_err "Chain mode requires a seed task"; exit 1; }
    banner "CHAIN MODE  ·  $(date +'%Y-%m-%d  %H:%M')"
    layer1_boot
    layer3_target
    layer4_classify
    layer12_techniques
    generate_chain
    exit 0
  fi

  # Quick mode
  if [[ "$SPEED" == "quick" && -n "$SEED" ]]; then
    quick_mode
    exit 0
  fi

  # Standard/deep flow
  main_flow
}

main "$@"
