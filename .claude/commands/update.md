# /update — Phase 5: Make the Next Session Smarter
# Use at the END of a feature or significant session milestone.
# This is the compounding step — every correction becomes a permanent improvement.
# Works in conjunction with /wrap from the memory framework.
#
# WHEN TO USE:
#   - After a feature spec is fully complete
#   - After any session where you corrected Claude on something
#   - After any session where a new constraint or pattern was discovered
#   - Before closing a long session even if the feature isn't done

You are entering Phase 5: Update.
The work is done. Now make the system smarter than it was before this session.

---

## Step 1 — CLAUDE.md Harvest

Review everything that happened this session.
Identify corrections, constraints, and patterns that should be permanent project rules.

For each candidate, state:
```
Candidate: [The rule in one sentence]
Trigger:   [What happened that surfaced this rule]
Scope:     [Does this apply to this project only, or all projects?]
Recommend: ADD TO CLAUDE.md / SKIP (already covered) / DISCUSS
```

Do NOT add to CLAUDE.md automatically. Surface candidates only.
I will press # to add the ones I approve.

---

## Step 2 — Spec Closure (if feature complete)

If the active spec's Implementation Checklist is fully checked:

1. Update spec status to: `**Status:** Complete`
2. Update spec's **Last Updated** date
3. Add a closing note: `## Completion Notes` with 2-3 sentences on what was built
   and any deviations from the original plan (with reasons)
4. Suggest removing it from CLAUDE.md active specs section (do not auto-edit)
5. Archive note: "Spec complete. Consider moving to /specs/archive/ to reduce CLAUDE.md noise."

---

## Step 3 — Pattern Library Check

Did this session produce any reusable pattern worth documenting?
Examples: a hook structure, an error handling approach, a testing pattern, an API shape.

If yes:
```
New Pattern Identified: [Name]
File: /patterns/[name].md (suggest creating)
Content: [Brief description of the pattern and when to use it]
```

Only flag genuinely novel patterns — not standard practice.

---

## Step 4 — Trigger Memory Wrap

After completing Steps 1-3, trigger the memory framework wrap:

Run the full /wrap protocol now:
- Update SCRATCHPAD.md
- Append any new decisions to DECISIONS.md
- Append session row to SESSIONS.md
- Surface CLAUDE.md suggestions (combined with Step 1 above)

---

## Step 5 — Session Close Statement

Output:

```
## Session Close

Feature progress: Chunk [N] of [total] complete / Feature COMPLETE
CLAUDE.md candidates: [N] surfaced for your review
New decisions logged: [N]
Patterns identified: [N]

Next session starts at: [Resume Here line]

System is [X]% smarter than when this session opened.
```

The last line is not a number. It is a reminder that this step matters.
