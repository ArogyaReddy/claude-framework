# /agent-review — Independent Code Review Agent
# Spawns a separate Claude instance with ZERO context from the current session.
# No attachment to decisions made. No familiarity bias. Fresh eyes.
#
# This is the closest thing to a real peer review available in Claude Code.
# Use for: high-stakes features, security-sensitive code, complex logic,
# any output where "it looks right to me" is not sufficient.
#
# REQUIRES: Claude Code CLI (claude -p available in shell)
# COST: ~1,500-3,000 tokens. Worth it for anything going to production.

You are coordinating an independent agent review of the current build output.

---

## Step 1 — Prepare the Review Package

Gather the following (do not include session conversation — that would bias the agent):

1. The spec file contents (what was supposed to be built)
2. The git diff of files changed this session (`git diff HEAD` or specific files)
3. Any relevant existing files the changed code interacts with

---

## Step 2 — Spawn the Agent

Run the following in the terminal (Claude Code CLI):

```bash
claude -p "
You are a senior engineer performing a code review.
You have NO context about how this code was written or why decisions were made.
Your job is to evaluate the code on its own merits.

SPEC (what was supposed to be built):
$(cat specs/[active-spec].md)

CODE DIFF (what was actually built):
$(git diff HEAD)

Review for:
1. Does the implementation match the spec's intent?
2. Are there correctness issues, edge cases, or bugs?
3. Are there security concerns (input validation, auth, data exposure)?
4. Is there anything added that wasn't in the spec scope?
5. What is the single most important change before this merges?

Output as:
VERDICT: APPROVE / REQUEST CHANGES / MAJOR ISSUES
CRITICAL (must fix): [list or none]
IMPORTANT (should fix): [list or none]  
MINOR (consider fixing): [list or none]
SCOPE DRIFT: [anything outside spec, or none]
SUMMARY: [2-3 sentences]
" 2>/dev/null
```

---

## Step 3 — Reconcile Findings

After the agent returns its verdict:

Compare agent findings with the /verify output from Phase 4.
Note agreements and disagreements.

If the agent found something /verify missed — that is a gap in the verify protocol.
Surface it: "Suggested /verify addition: [the check that was missed]"

If the agent and /verify agree → higher confidence to commit.
If they disagree → investigate before committing.

---

## When NOT to Use This

- Simple, low-risk chunks (rename, copy change, config update)
- When you are already past the 80% context usage threshold (agent will read stale context)
- When time pressure is real and /verify already returned LOW risk

The agent review is a quality multiplier, not a requirement. Use it when the cost
of a mistake exceeds the cost of the review.
