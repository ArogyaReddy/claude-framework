# Daily Workflow Checklist

Run through this before every task. Takes 60 seconds. Saves 60 minutes.

---

## Phase 1 — Before You Write the Prompt

```
[ ] Is there a spec for this? → Reference it. Do not re-explain it.
[ ] Do I know which file(s) are in scope? → Name them exactly.
[ ] Do I know what must NOT change? → State it first, before the request.
[ ] Is this task complex or multi-file? → Use Plan Gate prompt. Do not skip.
[ ] Does a skill already cover this pattern? → Invoke it instead of re-prompting.
[ ] Am I about to type "and also"? → Split into two prompts.
```

---

## Phase 2 — Writing the Prompt

Use the Four Elements. Every prompt must have all four:

```
[ ] SCOPE   — exact file or function name
[ ] ACTION  — one thing I am doing to it
[ ] FENCE   — what must not be touched or changed
[ ] OUTPUT  — format, what to exclude, stop condition
```

**Self-check before sending:**
```
[ ] Remove every word that isn't SCOPE, ACTION, FENCE, or OUTPUT.
[ ] Does the prompt still say exactly what I want? → Send it.
[ ] Did anything get removed that was actually important? → It belongs in CLAUDE.md.
```

---

## Phase 3 — Reviewing the Plan (if Plan Gate was used)

```
[ ] Does the plan match my intent exactly?
[ ] Does it touch anything outside the named scope?
[ ] Is the sequence correct — no step assumes an incomplete earlier step?
[ ] Are there any flags or ambiguities that need resolving first?
→ If all yes: confirm and execute.
→ If any no: correct the plan. Do not execute yet.
```

---

## Phase 4 — After Output

```
[ ] Did it stay in scope? (Check: did any unnamed file get touched?)
[ ] Is the output format what I asked for?
[ ] If multi-file: invoke change-manifest skill.
[ ] If wrong: use Diagnosis First — do not just re-ask the same prompt.
[ ] Did I repeat a constraint that should live in CLAUDE.md? → Add it.
[ ] Did I write the same prompt structure again? → It should be a skill.
```

---

## Context Management (Check Every Session)

```
[ ] Run /context — if usage is above 60%, compact now, not later.
[ ] Compact with preservation instructions:
      /compact Preserve: active specs, file paths touched, pending decisions, unresolved blockers. Discard: completed steps, tool output details.
[ ] Starting a completely unrelated task? Use /clear instead — don't carry dead context.
[ ] Added a new directory mid-session? Verify with /add-dir to bring it into context.
```

> Rule: compact with headroom. Waiting until context is full degrades summarisation quality.

---

## Weekly Maintenance (5 minutes)

```
[ ] Review .claude/logs/changes.log — anything unexpected?
[ ] Any constraint I repeated 3+ times this week? → Add to CLAUDE.md.
[ ] Any prompt I used 3+ times this week? → Add to skills/.
[ ] Is .claudeignore still aggressive enough? → Add any new noise.
[ ] Any spec that drifted from implementation? → Update the spec.
```

---

## The One Question to Ask Every Time

> *"Is what I'm about to type in this prompt, or should it already be loaded?"*

If it should already be loaded → put it in CLAUDE.md or a skill.
If it's task-specific → put it in the prompt.
