#!/opt/homebrew/bin/bash
set -euo pipefail

SEED="$1"

# Basic prompt template
FINAL_PROMPT="<task>$SEED</task>

<persona>
You are a senior software engineer with expertise in modern development practices.
</persona>

<context>
Working in a development environment.
</context>

<constraints>
- Write clean, maintainable code
- Follow best practices
- Test your work
</constraints>

<output-format>
Provide working code with explanations.
</output-format>"

echo "Generated prompt for: $SEED"
echo ""
echo "============== PROMPT =============="
echo "$FINAL_PROMPT"
echo "===================================="
echo ""
echo "Prompt length: ${#FINAL_PROMPT} characters"

# Copy to clipboard if possible
if command -v pbcopy &>/dev/null; then
    echo -n "$FINAL_PROMPT" | pbcopy
    echo "✓ Copied to clipboard"
else
    echo "• No clipboard tool available"
fi
