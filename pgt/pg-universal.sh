#!/opt/homebrew/bin/bash
# ═══════════════════════════════════════════════════════════════
# 🎯 UNIVERSAL PROMPT GENERATOR — Professional Edition
# One command, perfect prompts. Built for Claude & Copilot.
# ═══════════════════════════════════════════════════════════════
set -euo pipefail

# Configuration
VAULT_DIR="${HOME}/.prompt-vault"
HISTORY_FILE="${VAULT_DIR}/history.log"

# Colors for professional output
readonly BLUE='\033[0;34m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly NC='\033[0m'

# Initialize vault
init_vault() {
    mkdir -p "$VAULT_DIR"
    touch "$HISTORY_FILE"
}

# Smart context detection
detect_context() {
    local context=""

    # Git context
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        local repo=$(basename "$(git rev-parse --show-toplevel)" 2>/dev/null)
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        context+="Repository: $repo, Branch: $branch"
    fi

    # Language detection
    if [[ -f "package.json" ]]; then
        context+=", Stack: Node.js/React"
    elif [[ -f "requirements.txt" || -f "pyproject.toml" ]]; then
        context+=", Stack: Python"
    elif [[ -f "go.mod" ]]; then
        context+=", Stack: Go"
    elif [[ -f "Cargo.toml" ]]; then
        context+=", Stack: Rust"
    fi

    echo "$context"
}

# Generate professional prompt
generate_prompt() {
    local task="$1"
    local target="${2:-claude}"
    local context=$(detect_context)

    # Smart prompt based on task type
    local persona=""
    local constraints=""
    local output_format=""

    # Detect task type and set appropriate settings
    if [[ $task =~ (bug|fix|debug|error|issue) ]]; then
        persona="You are a senior debugging specialist with expertise in root cause analysis and systematic problem-solving."
        constraints="- Identify the root cause, not just symptoms
- Provide step-by-step debugging approach
- Include prevention strategies
- No speculation without evidence"
        output_format="1. Root cause analysis 2. Step-by-step fix 3. Prevention measures"

    elif [[ $task =~ (create|build|develop|implement|make) ]]; then
        persona="You are a senior software architect with expertise in modern development practices and clean code principles."
        constraints="- Write production-ready, maintainable code
- Follow best practices and patterns
- Include proper error handling
- Add clear documentation"
        output_format="1. Working code with explanations 2. Usage examples 3. Testing approach"

    elif [[ $task =~ (test|testing|spec|specification) ]]; then
        persona="You are a senior QA engineer specializing in comprehensive test strategy and test automation."
        constraints="- Cover edge cases and error conditions
- Use appropriate testing frameworks
- Include both unit and integration tests
- Ensure good test coverage"
        output_format="1. Test strategy 2. Complete test code 3. Coverage analysis"

    elif [[ $task =~ (document|doc|explain|guide) ]]; then
        persona="You are a technical writing expert who creates clear, comprehensive documentation."
        constraints="- Write for the intended audience level
- Include practical examples
- Use clear, concise language
- Structure information logically"
        output_format="1. Clear explanation 2. Code examples 3. Usage scenarios"

    elif [[ $task =~ (review|analyze|audit|check) ]]; then
        persona="You are a senior code reviewer with expertise in security, performance, and maintainability."
        constraints="- Focus on critical issues first
- Provide specific, actionable feedback
- Consider security implications
- Suggest concrete improvements"
        output_format="1. Critical issues 2. Improvement suggestions 3. Best practice recommendations"

    else
        # General purpose
        persona="You are a senior software engineer with expertise in modern development practices."
        constraints="- Provide clear, actionable solutions
- Follow industry best practices
- Consider maintainability and scalability
- Include relevant examples"
        output_format="1. Clear solution 2. Implementation details 3. Best practices"
    fi

    # Generate the prompt
    if [[ $target == "claude" || $target == "claude-code" ]]; then
        # Claude XML format
        cat << EOF
<task>$task</task>

<persona>$persona</persona>

<context>
$context
Current working directory: $(pwd)
</context>

<constraints>
$constraints
Mark [UNCERTAIN] if you need clarification.
</constraints>

<output-format>
$output_format
Provide working, tested solutions.
</output-format>

<thinking>
Analyze the request step-by-step before responding.
</thinking>
EOF
    elif [[ $target == "copilot" ]]; then
        # Copilot natural language format
        cat << EOF
# Task: $task

**Context:** $context, Working in: $(pwd)

**Role:** $persona

**Requirements:**
$constraints

**Expected Output:** $output_format

**Instructions:** Provide a complete, working solution with clear explanations.
EOF
    else
        # Universal format
        cat << EOF
**Task:** $task

**Context:** $context

**Approach:** $persona

**Requirements:**
$constraints

**Output Format:** $output_format

Please provide a comprehensive solution with working code and clear explanations.
EOF
    fi
}

# Copy to clipboard
copy_to_clipboard() {
    local content="$1"
    if command -v pbcopy &>/dev/null; then
        echo -n "$content" | pbcopy
        echo -e "${GREEN}✓${NC} Copied to clipboard"
    elif command -v xclip &>/dev/null; then
        echo -n "$content" | xclip -selection clipboard
        echo -e "${GREEN}✓${NC} Copied to clipboard"
    else
        echo -e "${YELLOW}⚠${NC} No clipboard tool available"
    fi
}

# Save to history
save_to_history() {
    local task="$1"
    local target="$2"
    local prompt_length="$3"
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $target | $task | ${prompt_length} chars" >> "$HISTORY_FILE"
}

# Show usage
show_usage() {
    cat << 'EOF'
🎯 Universal Prompt Generator

USAGE:
  pg "your task description"              # Generate prompt for Claude
  pg "your task" --target copilot         # Generate for GitHub Copilot
  pg "your task" --target universal       # Generate universal format

EXAMPLES:
  pg "create a React login component"
  pg "fix authentication bug in user.js"
  pg "write unit tests for payment API"
  pg "document the database schema"

OPTIONS:
  --target claude      XML format for Claude (default)
  --target copilot     Natural language for Copilot
  --target universal   Works with any AI tool
  --history           Show recent prompts
  --help              Show this help

The generated prompt is automatically copied to your clipboard.
EOF
}

# Show history
show_history() {
    if [[ ! -f "$HISTORY_FILE" ]]; then
        echo -e "${YELLOW}No history yet.${NC}"
        return
    fi

    echo -e "${BOLD}Recent Prompts:${NC}"
    tail -20 "$HISTORY_FILE" | while IFS='|' read -r timestamp target task length; do
        echo -e "${DIM}$timestamp${NC} ${BLUE}$target${NC} $task ${DIM}($length)${NC}"
    done
}

# Main function
main() {
    init_vault

    local task=""
    local target="claude"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --target)
                target="$2"
                shift 2
                ;;
            --history)
                show_history
                exit 0
                ;;
            --help|-h)
                show_usage
                exit 0
                ;;
            -*)
                echo -e "${RED}Unknown option: $1${NC}"
                show_usage
                exit 1
                ;;
            *)
                task="$1"
                shift
                ;;
        esac
    done

    # Validate task
    if [[ -z "$task" ]]; then
        echo -e "${RED}Error: Task description required${NC}"
        echo ""
        show_usage
        exit 1
    fi

    # Generate prompt
    echo -e "${BOLD}🎯 Generating prompt for $target...${NC}"

    local prompt
    prompt=$(generate_prompt "$task" "$target")

    # Calculate stats
    local char_count=${#prompt}
    local token_estimate=$((char_count / 4))

    # Display result
    echo ""
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${BOLD}Generated Prompt (${char_count} chars, ~${token_estimate} tokens)${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo ""
    echo "$prompt"
    echo ""
    echo -e "${BLUE}════════════════════════════════════════${NC}"

    # Copy and save
    copy_to_clipboard "$prompt"
    save_to_history "$task" "$target" "$char_count"

    echo -e "${GREEN}✓ Ready to paste into $target${NC}"
}

# Run main function
main "$@"