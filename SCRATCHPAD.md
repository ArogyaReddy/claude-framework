# SCRATCHPAD.md
# Current session state — rolling. Keep under 300 lines. Summarise, don't just append.
# Claude reads this at session start. Updated at session end via /wrap or hook.
# For permanent decisions, see DECISIONS.md. For session history, see SESSIONS.md.

---

## What We're Building
<!-- Written once. Updated only when scope fundamentally changes.
     One paragraph. The "why" as much as the "what". -->

[FILL IN: Describe the project — what it does, who uses it, what problem it solves.]

---

## Current Focus
<!-- Replace entirely each session. One specific thing, not a list of everything.
     Enough context that Claude can orient in under 30 seconds. -->

[FILL IN: The specific feature/bug/task being worked on right now.]

**Why this matters:** [Why is this the current priority?]
**Scope boundary:** [What is explicitly out of scope for this session?]

---

## Resume Here
<!-- One sentence. The exact next action. Overwrite every session.
     Be specific enough that a fresh Claude instance knows exactly what to do. -->

→ [FILL IN: e.g., "Fix the race condition in /api/webhooks/stripe.ts line 47 using Redis SET NX"]

---

## Active Files
<!-- The 3-6 files most relevant to current focus. Speeds up orientation. -->

- [ ]  [path/to/file.ts] — [what it does / why it matters now]
- [ ]  [path/to/file.ts] — [what it does / why it matters now]

---

## What Was Tried and Failed
<!-- Append only. Never delete. Prevents Claude from suggesting dead ends.
     Format: [date] — what was tried → why it failed -->

[No failed attempts recorded yet.]

---

## Open Questions
<!-- Things unresolved. Claude should know these exist but not try to resolve them
     without new information. -->

[No open questions yet.]

---

## Context Claude Needs
<!-- One-time context that isn't in CLAUDE.md or the codebase.
     Business constraints, client requirements, team decisions, etc. -->

[No additional context yet.]

---
<!-- Last updated: [DATE] | Session: [N] -->
