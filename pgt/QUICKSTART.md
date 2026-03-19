# Quick Start Guide — pg v5.0

**Copy-paste examples for common workflows. Get started in 30 seconds.**

---

## Installation (10 seconds)

```bash
# Download (or copy pg-v5.sh to your machine)
chmod +x pg-v5.sh

# Optional: Add to PATH
sudo mv pg-v5.sh /usr/local/bin/pg
```

---

## Daily Workflows

### 1. Quick Code Task (Most Common)

```bash
# Morning: Fix a bug
pg --quick "fix authentication timeout in middleware/auth.js"

# Result in clipboard → Paste into Claude Code → Done
```

**When:** 80% of your coding tasks
**Time:** 30 seconds
**Quality:** 8/10

---

### 2. Debug a Failing Test

```bash
pg --template debug-root-cause "test_payment_webhook fails with 'signature mismatch' error"
```

**Output:**
```
<task>Debug and identify root cause</task>

<persona>
You are a debugging specialist with expertise in hypothesis-driven investigation...
</persona>

<problem>
test_payment_webhook fails with 'signature mismatch' error
</problem>

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
- Mark [UNCERTAIN] if root cause is not yet confirmed
</hard-constraints>
```

**Result:** Hypothesis-driven debugging, no wild guesses.

---

### 3. Implement from Specification

```bash
# You have: specs/payment-retry.md

pg --template feature-from-spec --spec specs/payment-retry.md "implement exponential backoff retry logic"
```

**Output:**
- Spec content injected
- SCWA framework applied
- Hard constraint: NO scope creep, NO spec violations
- Validation checklist included

**Result:** Implementation exactly as specified, nothing more.

---

### 4. Code Review

```bash
# Review a PR with files
pg --template pr-review --include services/payment.js --include tests/payment.test.js "review payment service for security and edge cases"
```

**Output:**
- Both files injected into context
- Focus: Logic errors, security vulnerabilities, edge cases
- No nitpicking about formatting
- Specific line numbers + fix suggestions

**Result:** Production-ready code review.

---

### 5. Refactor Safely

```bash
pg --template refactor-safe "refactor UserController.js to extract validation logic into separate middleware"
```

**Output:**
- Hard constraint: NO behavior changes
- Validation checklist: All tests must pass
- Clear "what changed" vs "what stayed the same"

**Result:** Confident refactoring without breaking production.

---

### 6. Architecture Decision

```bash
pg --template architecture-decision "Choose database: PostgreSQL vs MongoDB for e-commerce order history"
```

**Output:**
```
## Options Considered
1. PostgreSQL (relational)
2. MongoDB (document)
3. Hybrid (Postgres + Redis cache)

## Evaluation Criteria (Weighted)
- Query complexity (30%)
- Scalability (25%)
- Developer familiarity (20%)
- Operational cost (15%)
- Ecosystem maturity (10%)

## Scoring Matrix
[Table with scores]

## Recommendation
**Choose: PostgreSQL**
Confidence: High (90%)

Trade-offs Accepted:
- Sacrificing schema flexibility to gain transaction guarantees and complex query support

Why This Choice:
E-commerce order history requires ACID transactions, complex joins (orders

 + line items + products), and well-defined schema. MongoDB's advantages (flexible schema) are not needed here.
```

**Result:** Clear decision with justification and confidence level.

---

### 7. Learn a New Concept

```bash
pg --template learn-concept "Explain the CQRS pattern and when to use it"
```

**Output:**
```
## Simple Explanation
CQRS means using different models to read and write data. Instead of one database that does everything, you have a "write database" (for creating/updating) and a "read database" (optimized for queries).

## Analogy
Think of a restaurant kitchen:
- Write side (kitchen): Chefs modify orders, complex processes
- Read side (menu board): Customers see simple, pre-computed options

## Key Insight
Reads and writes have different requirements, so optimize them separately.

## Prerequisites
- Understand basic database CRUD operations
- Familiarity with event-driven architecture helps

## Common Misconceptions
- "CQRS means event sourcing" — No, they're separate patterns often used together
- "CQRS is for all apps" — No, only use it when read/write patterns differ significantly
```

**Result:** Crystal-clear explanation with no jargon.

---

### 8. Draft a Professional Email

```bash
pg --template daily-email "Decline Friday's 2pm meeting politely, suggest async update via Slack instead, mention tight deadline on payment feature"
```

**Output:**
```
Subject: Re: Friday 2pm Sync — Async Update Suggested

Hi [Name],

I'm on a tight deadline for the payment feature launch and need to stay focused. Can we do an async update via Slack instead of the Friday 2pm meeting?

I'll post a summary of progress and blockers by end of Thursday. Let me know if that works.

Thanks,
[Your Name]
```

**Result:** Professional, concise, actionable.

---

### 9. Complex Multi-Step Task (Chain Mode)

```bash
pg --chain "Build complete Stripe payment integration with webhooks"

# Interactive:
Number of prompts in chain: 4

Step 1 — task: Set up Stripe API client with error handling
Step 1 — desired output: Working API client, config validation

Step 2 — task: Implement payment intent creation POST /api/payments
Step 2 — desired output: Endpoint with input validation and idempotency

Step 3 — task: Add webhook handler for payment.succeeded event
Step 3 — desired output: Webhook with signature verification

Step 4 — task: Add database logging of payment events
Step 4 — desired output: Payment event audit log table + insert logic
```

**Output:** Single file with 4 prompts, dependencies noted between steps.

**Result:** Step-by-step implementation plan.

---

### 10. Research a Topic

```bash
pg --mode research --deep "Compare Next.js App Router vs Pages Router for SEO and performance"
```

**Output:**
- Deep mode: Full 5-minute interview
- CARE framework applied (Comprehensive Analysis and Reasoned Evaluation)
- Sources and evidence required

**Result:** Thorough analysis with recommendations.

---

## Power User Workflows

### Workflow 1: Morning Standup Prep

```bash
# Generate daily standup summary from git log
git log --since="yesterday" --oneline > /tmp/git-yesterday.txt

pg --quick --from-clipboard "Summarize yesterday's commits as 3 bullet points for standup"
# (Copy /tmp/git-yesterday.txt to clipboard first)
```

---

### Workflow 2: PR Review Automation

```bash
#!/bin/bash
# review-pr.sh — Automate PR reviews

PR_NUMBER=$1
gh pr diff $PR_NUMBER > /tmp/pr-${PR_NUMBER}.diff

pg --template pr-review --include /tmp/pr-${PR_NUMBER}.diff "Review PR #${PR_NUMBER} for security, logic errors, and edge cases"
```

**Usage:** `./review-pr.sh 123`

---

### Workflow 3: Spec-Driven Development

```bash
# Step 1: Write spec
vim specs/user-roles.md

# Step 2: Generate implementation prompt
pg --template feature-from-spec --spec specs/user-roles.md "Implement role-based access control middleware"

# Step 3: Paste into Claude Code

# Step 4: Validate against spec
pg --mode review --spec specs/user-roles.md --include src/middleware/rbac.js "Verify implementation matches spec exactly"
```

---

### Workflow 4: Daily Knowledge Capture

```bash
# End of day: Log what you learned
pg --quick "Summarize what I learned today about JWT token rotation and store in KNOWLEDGE.md"
```

---

### Workflow 5: Onboarding New Team Member

```bash
# Generate onboarding prompt for new codebase
pg --mode document "Generate onboarding guide for our Node.js API backend: folder structure, conventions, testing approach, deployment process"
```

---

## Keyboard Shortcuts (Shell Aliases)

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# Quick mode (most common)
alias pgq='pg --quick'

# Templates
alias pgd='pg --template debug-root-cause'
alias pgr='pg --template pr-review'
alias pgs='pg --template feature-from-spec'

# Vault browsers
alias pgh='pg --history'
alias pgt='pg --templates'
```

**Usage:**
```bash
pgq "fix login timeout"
pgd "webhook fails intermittently"
pgr --include src/auth.js "review auth flow"
pgh  # Browse history
```

---

## Common Patterns

### Pattern 1: Context from Git

```bash
# Include recent commits as context
git log --oneline -10 > /tmp/git-context.txt
pg --quick --include /tmp/git-context.txt "Explain why the authentication flow was refactored"
```

### Pattern 2: Multi-File Context

```bash
# Review entire feature
pg --template pr-review \
  --include src/services/payment.js \
  --include src/controllers/payment.js \
  --include src/routes/payment.js \
  "Review payment feature for completeness and consistency"
```

### Pattern 3: Spec + Implementation

```bash
# Ensure spec compliance
pg --mode review \
  --spec specs/api-v2.md \
  --include src/api/v2/index.js \
  "Verify API implementation matches spec"
```

### Pattern 4: From Error Log

```bash
# Copy error from logs
tail -100 /var/log/app.log | grep ERROR > /tmp/error.log

pg --template debug-root-cause --include /tmp/error.log "Diagnose this error"
```

### Pattern 5: Documentation Update

```bash
# Update README after feature
pg --mode document "Update README.md to document the new webhook retry feature with examples"
```

---

## First Day Checklist

- [ ] **Morning:** Install pg → `chmod +x pg-v5.sh`
- [ ] **Try Quick Mode:** `pg --quick "hello world"`
- [ ] **Browse Templates:** `pg --templates`
- [ ] **Set Up Alias:** Add `alias pgq='pg --quick'` to shell config
- [ ] **First Real Task:** Fix one real bug using `pg --template debug-root-cause`
- [ ] **Rate Prompt:** Complete Layer 17 (feedback loop) to start learning
- [ ] **Save Winner:** Generate a 5/5 prompt → auto-saves as template

---

## First Week Goals

| Day | Goal | Command |
|-----|------|---------|
| **Mon** | Install + quick mode | `pg --quick "task"` |
| **Tue** | Try debug template | `pg --template debug-root-cause "bug"` |
| **Wed** | Code review template | `pg --template pr-review --include file.js` |
| **Thu** | Learn mode | `pg --template learn-concept "CQRS"` |
| **Fri** | Chain mode | `pg --chain "complex task"` |
| **Sat** | Create custom template | Edit `~/.prompt-vault/templates/my-template.template` |
| **Sun** | Review feedback log | `pg --patterns` |

---

## Integration with Your Workflow

### With Claude Code

```bash
# In your Claude Code project:
cd my-project

# pg auto-reads:
# - CLAUDE.md
# - SESSION_LOG.md
# - .claude/history/decisions.md
# - skills/

pg --quick "add rate limiting to API"
# Prompt includes session context automatically
```

### With GitHub Copilot

```bash
# Generate inline comment prompt
pg --target copilot "implement binary search in this function"

# Paste into your code as comment:
# implement binary search in this function
# [Copilot generates code]
```

### With CI/CD

```bash
# In .github/workflows/review.yml
- name: Generate code review prompt
  run: |
    pg --template pr-review --include $(git diff --name-only HEAD~1) "Review changes for security and quality" > review-prompt.txt
    # Send to Claude API or post as PR comment
```

---

## Troubleshooting Quick Reference

| Problem | Solution |
|---------|----------|
| "No clipboard tool" | Install xclip (Linux) or use clip.exe (Windows) |
| "Permission denied" | `chmod +x pg-v5.sh` |
| "Template not found" | Check `pg --templates` for exact names |
| "Low quality score" | Add `--include` files or use `--spec` |
| "Output too long" | Use `--include` only for necessary files |
| "Wrong target format" | Check `--target claude` vs `claude-code` vs `copilot` |

---

## Next Steps

1. **Read ARCHITECTURE.md** — Understand how it works (what/why/how/where/when)
2. **Read INTEGRATION-GUIDE.md** — Set up with Claude Code framework
3. **Create your first custom template** — For your team's specific patterns
4. **Set up shell aliases** — Make it fast to use daily
5. **Enable feedback loop** — Always complete Layer 17 to improve over time

---

## Success Metrics (Track Your Progress)

After 1 week:
- [ ] Used pg 10+ times
- [ ] Quality score average > 7/10
- [ ] At least 1 template saved from feedback loop
- [ ] Zero prompts sent without pg (100% coverage)

After 1 month:
- [ ] Quality score average > 8/10
- [ ] 5+ custom templates created
- [ ] < 30 seconds average time to prompt
- [ ] Team members asking "what tool is that?"

---

## Community Patterns (Share Yours!)

**Pattern: Morning Git Summary**
```bash
alias git-summary='git log --since="yesterday" --author="$(git config user.name)" --pretty=format:"%h %s" | pg --quick --from-clipboard "Summarize as standup bullet points"'
```

**Pattern: API Endpoint Generator**
```bash
api-gen() {
  pg --template backend-feature "Create REST endpoint $1 with validation, error handling, and tests"
}
# Usage: api-gen "POST /api/users"
```

**Pattern: Doc-on-Commit**
```bash
# Git hook: post-commit
pg --mode document "Update CHANGELOG.md with this commit: $(git log -1 --pretty=%B)"
```

---

## FAQ

**Q: Do I need to use all 17 layers?**
A: No. Quick mode uses ~7 layers. Standard uses ~12. Deep uses all 17.

**Q: Can I skip the feedback loop?**
A: Yes, but you won't improve over time. Feedback auto-saves winning prompts.

**Q: Does this work offline?**
A: Yes — pg is 100% local. It generates prompts, doesn't call AI APIs.

**Q: Can I use this with GPT-4?**
A: Yes — use `--target universal` for clean natural language output.

**Q: How do I update templates?**
A: Edit files in `~/.prompt-vault/templates/` directly.

---

## Cheat Sheet (Print This!)

```
QUICK START
  pg --quick "task"                    30-second prompts

TEMPLATES
  pg --template debug-root-cause       Debugging
  pg --template feature-from-spec      Spec implementation
  pg --template pr-review              Code review
  pg --template architecture-decision  Make decisions

MODES
  --quick          30s, auto-defaults
  --standard       2min, guided
  --deep           5min, full interview

TARGETS
  --target claude       XML structured
  --target claude-code  Agentic terminal
  --target copilot      Inline comments
  --target universal    Any AI

OPTIONS
  --spec file.md        Include spec
  --include file.js     Include file (repeat for multiple)
  --from-clipboard      Read from clipboard
  --chain               Multi-step sequence

VAULT
  pg --history          View past prompts
  pg --templates        Browse templates
  pg --patterns         View feedback log
```

---

**Ready to 10x your AI prompting? Start with: `pg --quick "your first task"`**

---

**Version:** 5.0
**Last Updated:** 2026-03-19
**Next:** Read INTEGRATION-GUIDE.md for Claude Code framework setup
