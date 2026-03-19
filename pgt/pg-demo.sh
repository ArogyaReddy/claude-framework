#!/usr/bin/env bash
# Demo script showing exactly what pg v5.0 should output

echo -e "\033[1m\033[0;36m╔══════════════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1m\033[0;36m║  🧠 PROMPT ENGINE v5.0  ·  QUICK MODE  ·  2026-03-19  16:45   ║\033[0m"
echo -e "\033[1m\033[0;36m╚══════════════════════════════════════════════════════════════╝\033[0m"
echo ""

echo -e "\033[1m\033[1;33m  ▸ LAYER 1 — Boot Intelligence\033[0m"
echo -e "  \033[2m──────────────────────────────────────────────────────────\033[0m"
echo -e "  \033[0;36m·\033[0m Env: Node.js/TypeScript | Repo: claude-framework | Branch: main | Status: 1 uncommitted | ✓ CLAUDE.md present"
echo ""

echo -e "\033[1m\033[1;33m  ▸ LAYER 7 — Persona\033[0m"
echo -e "  \033[2m──────────────────────────────────────────────────────────\033[0m"
echo -e "  \033[0;36m·\033[0m Persona: senior-backend"
echo ""

echo -e "\033[1m\033[1;33m  ▸ LAYER 10 — Negative Constraints\033[0m"
echo -e "  \033[2m──────────────────────────────────────────────────────────\033[0m"
echo -e "  \033[0;36m·\033[0m Constraints: NO TODO comments, NO placeholder code, NO magic numbers"
echo ""

echo -e "\033[1m\033[1;33m  ▸ LAYER 12 — PE Techniques\033[0m"
echo -e "  \033[2m──────────────────────────────────────────────────────────\033[0m"
echo -e "  \033[0;36m·\033[0m PE Techniques: Chain of Thought, Gap Framing, Negative Constraints, Uncertainty Flagging, XML Structuring, Prefilling, Requirements Analysis, Edge Case Enumeration"
echo ""

echo -e "\033[1m\033[1;33m  ▸ LAYER 15 — Render\033[0m"
echo -e "  \033[2m──────────────────────────────────────────────────────────\033[0m"
echo -e "  \033[0;32m✓\033[0m Prompt rendered for claude-code"
echo ""

echo -e "\033[1m\033[1;33m  ▸ LAYER 13 — Quality Score\033[0m"
echo -e "  \033[2m──────────────────────────────────────────────────────────\033[0m"
echo -e "  \033[1;37mScore: 8/10\033[0m"
echo -e "    \033[2m✓ Persona\033[0m"
echo -e "    \033[2m✓ Context\033[0m"
echo -e "    \033[2m✓ Constraints\033[0m"
echo -e "    \033[2m✓ Framework\033[0m"
echo -e "    \033[2m✓ Token count OK (342 words)\033[0m"
echo -e "    \033[2m✓ No vague words\033[0m"
echo ""

echo -e "\033[1m\033[1;33m  ▸ LAYER 16 — Deliver\033[0m"
echo -e "  \033[2m──────────────────────────────────────────────────────────\033[0m"
echo -e "  \033[0;32m✓\033[0m Saved to vault: 2026-03-19_16-45-32_claude-code_code.prompt"
echo -e "  \033[0;32m✓\033[0m Copied to clipboard (clip.exe)"
echo ""

echo -e "\033[1m\033[0;32m╔══════════════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1m\033[0;32m║  GENERATED PROMPT — claude-code · code · RISEN\033[0m"
echo -e "\033[1m\033[0;32m╚══════════════════════════════════════════════════════════════╝\033[0m"
echo ""

cat << 'EOF'
Add error logging to authentication middleware

CONTEXT:
Env: Node.js/TypeScript | Repo: claude-framework | Branch: main | Status: 1 uncommitted | ✓ CLAUDE.md present

NOTE: This project has a CLAUDE.md file. Follow its rules.

PERSONA:
You are a senior backend engineer with 10+ years of experience in distributed systems, API design, and performance optimization. You write production-quality code, think about edge cases, and document your decisions.

CONSTRAINTS:
NO TODO comments, NO placeholder code, NO magic numbers

FRAMEWORK: RISEN

VALIDATION CHECKLIST (before completing):
□ Task completed exactly as requested
□ No out-of-scope changes
□ All constraints honored
□ Tests pass (if applicable)
□ CLAUDE.md rules followed (if applicable)
EOF

echo ""
echo -e "\033[1m\033[0;32m╔══════════════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1m\033[0;32m║  END  ·  Score: 8/10  ·  342 chars\033[0m"
echo -e "\033[1m\033[0;32m╚══════════════════════════════════════════════════════════════╝\033[0m"
echo ""

echo -e "\n\033[1m\033[0;32m  ✓ Quick mode complete. Prompt in clipboard.  Prompt in vault.\033[0m\n"
echo ""
echo -e "\033[1;37m📋 The generated prompt is now in your clipboard - paste it into Claude Code!\033[0m"
