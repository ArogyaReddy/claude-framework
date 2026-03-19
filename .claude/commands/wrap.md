# Session Wrap Protocol
# Triggered with: /wrap
# Use at the END of every session before closing.
# Cost: ~500-800 tokens. Investment that pays every future session.

You are closing this Claude Code session. Update the memory files as follows:

---

## Step 1 — Update SCRATCHPAD.md

Replace these sections entirely (overwrite, don't append):
- **Current Focus** — what we worked on this session, in 2-3 sentences with enough context for cold resume
- **Resume Here** — ONE sentence, the exact next action, specific enough that a fresh Claude instance knows precisely what to do (include file path and line number if applicable)
- **Active Files** — update to reflect files touched this session

Append to these sections (never overwrite):
- **What Was Tried and Failed** — anything attempted this session that didn't work, with brief reason why
- **Open Questions** — anything unresolved that needs an answer before proceeding
- **Context Claude Needs** — any business/team context shared this session that isn't in the codebase

Keep SCRATCHPAD.md under 300 lines total. If it exceeds this, summarise older "What Was Tried" entries into a single grouped paragraph.

Update the footer: `Last updated: [TODAY'S DATE] | Session: [INCREMENT SESSION NUMBER]`

---

## Step 2 — Update DECISIONS.md

For each architectural or significant decision made this session:
Append a new entry using the standard format:

```
### [DECISION-XXX] Short title
**Date:** [TODAY]
**Status:** Active
**Decision:** [One sentence]
**Reason:** [Why — the specific constraint or insight]
**Alternatives Considered:** [What else was evaluated]
**Revisit When:** [Condition for re-opening]
```

If no new decisions were made, skip this step.

---

## Step 3 — Update SESSIONS.md

Append one row to the session log table:
`| [SESSION NUMBER] | [TODAY'S DATE] | [Focus — 5 words max] | [Outcome — 5 words max] | [Next — 5 words max] |`

---

## Step 4 — CLAUDE.md Check

Review what was corrected or decided this session.
If anything should become a permanent project constraint, tell me:
"Suggested CLAUDE.md addition: [the rule]"
Do NOT edit CLAUDE.md automatically — surface it for my review.

---

After completing all steps, output:
"Session wrapped. [N] decisions logged. SCRATCHPAD updated. Resume point: [copy the Resume Here line]"
