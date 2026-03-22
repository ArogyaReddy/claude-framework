#!/opt/homebrew/bin/bash
set -euo pipefail

echo "=== TESTING PG STEP BY STEP ==="

# Source all functions
source pg-v5.sh 2>/dev/null || {
    echo "Failed to source pg-v5.sh"
    exit 1
}

# Set up minimal state
SEED="test task"
SPEED="quick"
TARGET=""
MODE=""
FRAMEWORK=""
BOOT_CONTEXT=""
PERSONA_DEF=""
EXTRA_CONTEXT=""
NEGATIVES=""
PE_TECHNIQUES=""
FINAL_PROMPT=""
QUALITY_SCORE=0
TS=$(date +%Y-%m-%d_%H-%M-%S)

# Initialize vault
echo "1. Initializing vault..."
init_vault
echo "   ✓ Vault initialized"

echo "2. Testing layer1_boot..."
layer1_boot
echo "   ✓ layer1_boot completed"

echo "3. Setting defaults..."
TARGET="${TARGET:-claude-code}"
MODE="${MODE:-code}"
FRAMEWORK="${FRAMEWORK_MAP[$MODE]:-RISEN}"
echo "   ✓ Defaults set: TARGET=$TARGET, MODE=$MODE, FRAMEWORK=$FRAMEWORK"

echo "4. Testing layer7_persona..."
layer7_persona
echo "   ✓ layer7_persona completed"

echo "5. Testing layer10_negative..."
layer10_negative
echo "   ✓ layer10_negative completed"

echo "6. Testing layer12_techniques..."
layer12_techniques
echo "   ✓ layer12_techniques completed"

echo "7. Testing layer15_render..."
layer15_render
echo "   ✓ layer15_render completed"

echo "8. Testing layer13_score..."
layer13_score
echo "   ✓ layer13_score completed"

echo "9. Testing layer16_deliver..."
layer16_deliver
echo "   ✓ layer16_deliver completed"

echo ""
echo "=== ALL TESTS PASSED ==="
echo "Generated prompt length: ${#FINAL_PROMPT} characters"
echo "Quality score: $QUALITY_SCORE"

# Show first 200 chars of prompt
echo ""
echo "=== PROMPT PREVIEW ==="
echo "${FINAL_PROMPT:0:200}..."