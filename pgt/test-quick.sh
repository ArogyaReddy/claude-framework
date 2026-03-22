#!/opt/homebrew/bin/bash
set -euxo pipefail

# Source the main script but don't run main
source pg-v5.sh 2>/dev/null || true

# Override main to prevent auto-execution
main() { :; }

# Set up minimal state
SEED="test bug fix"
SPEED="quick"
TARGET=""
MODE=""
FRAMEWORK=""

echo "=== STARTING QUICK_MODE TEST ==="
quick_mode
echo "=== QUICK_MODE COMPLETED ==="
