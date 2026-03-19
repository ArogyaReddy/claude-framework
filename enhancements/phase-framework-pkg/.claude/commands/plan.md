# /plan — Phase 1: Structured Planning
# Use at the START of any non-trivial feature or task.
# Before a single file is created. Before any code is written.
# This command activates structured planning mode.
#
# WHEN TO USE:
#   - Any feature that touches more than 2 files
#   - Any refactor that changes public interfaces
#   - Any task where the path is unclear
#   - Any task where a wrong architectural decision would be costly
#
# WHEN NOT TO USE:
#   - Simple bug fixes with an obvious single-file change
#   - Renaming variables, updating copy, trivial edits
#   - Tasks where you already have a spec (use /spec instead)

You are entering Phase 1: Planning. No code will be written in this phase.

## Your Role Right Now

You are an architect reviewing a brief, not an engineer starting to build.
Ask questions. Surface tradeoffs. Challenge assumptions.
Do not propose solutions until you fully understand the problem.

## Step 1 — Understand Intent

Ask me these questions (all of them, in one message):

1. **What are we building?** Describe the feature/change in one sentence.
2. **Why now?** What is the trigger — bug, requirement, technical debt, new feature?
3. **Who uses it?** End user, internal system, API consumer, or another service?
4. **What is the success condition?** How will we know this is done and correct?
5. **What is explicitly out of scope?** What are we NOT changing?
6. **What constraints exist?** Performance requirements, existing interfaces that must not change, dependencies we cannot add, etc.
7. **What do you already know about the approach?** Any strong opinions or prior decisions?

Wait for my answers before proceeding to Step 2.

---

## Step 2 — Propose Architecture

Based on my answers, propose an approach. Structure it as:

**Proposed Approach:**
[2-3 sentences describing the technical direction]

**File Map:**
[Which files will be created, modified, or deleted — and why each one]

**Key Decisions Required:**
[The 2-4 decisions that must be made before building begins — with tradeoffs for each]

**Risks:**
[What could go wrong, what is uncertain, what depends on something outside our control]

---

## Step 3 — Resolve Decisions

For each Key Decision, present options with honest tradeoffs.
No recommendation padding. State what you would choose and exactly why.
Wait for my decision on each before proceeding.

---

## Step 4 — Confirm Plan

Summarise the agreed approach in 5-7 bullet points.
Ask: "Ready to write the spec? Type /spec to proceed."

Do NOT write any code or create any files during this phase.
