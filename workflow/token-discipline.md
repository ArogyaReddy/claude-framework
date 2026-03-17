# Token Discipline Rules

Token cost is a direct function of prompt quality and context hygiene.
These rules are ranked by impact.

---

## Rule 1 — Constraints First (Impact: High)

Put what I must NOT do before what I SHOULD do.
Constraints collapse my solution space before I start generating.
A constrained generation is shorter, cheaper, and more accurate.

❌ `Refactor the auth module.`
✅ `Refactor auth/session.ts for readability. Do not change function signatures. Do not touch the middleware. Return only the modified file.`

---

## Rule 2 — One Concern Per Prompt (Impact: High)

The moment you write "and also" — stop. Split it into two prompts.
Multi-step asks multiply error rate AND token cost.
A wrong multi-step execution costs 3-5x to unwind.

❌ `Fix the bug in processBatch and also add error handling and also write the tests.`
✅ Three separate prompts, in sequence, each confirmed before the next.

---

## Rule 3 — Plan Before Execute on Complex Tasks (Impact: High)

Cheap planning beats expensive wrong execution.
One course-correction in planning saves 3-5x tokens in execution.
Trigger: more than 2 files, or anything irreversible.

Cost of a planning prompt: ~500 tokens.
Cost of re-doing a wrong 3-file implementation: ~5,000-15,000 tokens.

---

## Rule 4 — Never Ask Me to Explain While Doing (Impact: High)

Adding "and explain what you did" doubles output length.
Ask for the code. Then ask for the explanation separately if you need it.
Or: trust that CLAUDE.md output rules cover this — no unsolicited explanation.

---

## Rule 5 — Specify the Output Format (Impact: Medium)

When you don't specify format, I choose. I always choose verbosely.
Always include a stop condition and output shape.

Add to any prompt:
- `Return only the function.`
- `No explanation.`
- `Stop after the last test case.`
- `Diff-style before/after only.`

---

## Rule 6 — Skills Over Re-Explaining (Impact: Medium)

Context you repeat in every session is waste.
If you've explained the same rule 3 times, it's a skill.
If you've stated the same constraint 5 times, it's CLAUDE.md.

Write it once. Load it for free.

---

## Rule 7 — Reference Specs, Don't Paste Them (Impact: Medium)

`Build according to specs/notifications.md` = near-zero token cost for the spec.
Pasting the spec contents into the prompt = full token cost every time.

Let the file system do the work.

---

## Rule 8 — .claudeignore Is a Token Budget Tool (Impact: Medium)

Every file I can read, I may try to read.
Every file I can't read, I can't waste tokens on.

Keep .claudeignore aggressive:
- All build output
- All generated files
- All lock files
- All media assets
- All large data files
- All documentation not relevant to current work

---

## Rule 9 — Stop Conditions in Every Prompt (Impact: Medium)

Without a stop condition, I continue past done.
I will summarise, suggest next steps, offer variations.
All of that costs tokens you didn't ask for.

Always end a prompt with: `Stop after [X].` or `No explanation.`

---

## Rule 10 — Don't Re-load What's Already Loaded (Impact: Low-Medium)

If it's in CLAUDE.md, don't repeat it in the prompt.
If it's in a skill, don't re-explain it.
CLAUDE.md loads every session. Trust it.

---

## The Cost Formula (Simplified)

```
Token Cost = (Prompt clarity) × (Output format control) × (Context hygiene)
```

- Low clarity prompt + no output format + bloated context = maximum cost
- Precise prompt + explicit format + tight .claudeignore = minimum cost

---

## Red Flags — Check These When Cost Feels High

```
[ ] Did I write "and also" anywhere?
[ ] Did I ask for explanation alongside execution?
[ ] Did I paste content that's already in a spec file?
[ ] Did I re-explain a rule that's in CLAUDE.md?
[ ] Did I skip Plan Mode on a complex task and then have to undo?
[ ] Is .claudeignore out of date?
[ ] Am I repeating a prompt I've used 3+ times — should be a skill?
```
