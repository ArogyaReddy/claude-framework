# Session Resume Protocol
# Triggered with: /resume
# Use at the START of every session before doing any work.
# Cost: ~600-900 tokens. Saves 3,000-6,000 tokens of context reconstruction.

Read the following files in this order, then give me a session brief:

1. **SCRATCHPAD.md** — current focus, resume point, failed attempts, open questions
2. **DECISIONS.md** — scan for any decisions relevant to current focus (don't read every entry, just the relevant ones)
3. **CLAUDE.md** — confirm active constraints and any active specs listed

Then output a **Session Brief** in this exact format:

---
## Session Brief

**Resuming:** [One sentence — what we're working on]
**Next action:** [Copy the "Resume Here" line from SCRATCHPAD verbatim]
**Watch out for:** [1-2 relevant failed attempts or open questions from SCRATCHPAD]
**Active constraints:** [1-3 most relevant rules from CLAUDE.md for this session's work]
**Decisions that apply:** [Any DECISIONS.md entries relevant to today's focus — just the decision, not full entry]

Ready to proceed. Confirm or redirect.
---

Do not start any work until I confirm the brief.
