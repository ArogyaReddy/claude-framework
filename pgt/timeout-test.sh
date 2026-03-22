#!/opt/homebrew/bin/bash

# Simple direct test without sourcing
set -e

echo "Testing direct execution..."
cd "/Users/arog/Library/Mobile Documents/com~apple~CloudDocs/AROG/2026-03-22/claude-framework/claude-framework/pgt"

# Test with a timeout and capture both output streams
timeout 30s /opt/homebrew/bin/bash pg-v5.sh --quick "test task" >test.out 2>test.err || {
    echo "Script timed out or failed"
    echo "EXIT CODE: $?"
    echo "=== STDOUT ==="
    cat test.out
    echo "=== STDERR ==="
    cat test.err
    exit 1
}

echo "Script completed successfully!"
echo "=== OUTPUT ==="
cat test.out