# Patterns Log

> Recurring patterns — good and bad — noticed across sessions.
> Updated by the session-closer skill.
> Read by Claude to avoid repeating mistakes and reinforce what works.

---

## Format

```
### [Pattern title] — [GOOD | BAD | WATCH]
- **Pattern:** [What keeps happening]
- **First seen:** [YYYY-MM-DD]
- **Last seen:** [YYYY-MM-DD]
- **Action:** [What to do / avoid / watch for]
```

---

<!-- PATTERNS BELOW -->

### Starting with structure before code — GOOD
- **Pattern:** Sessions where the problem is scoped in a spec or structured prompt before any code is written consistently produce better outcomes with fewer revisions.
- **First seen:** 2026-03-16
- **Last seen:** 2026-03-16
- **Action:** Always use Plan Gate prompt or spec-to-task skill before multi-file changes.

### Skipping PROFILE.md fill-in — WATCH
- **Pattern:** PROFILE.md created but left with placeholder values provides little benefit — Claude cannot personalise responses or remember context correctly.
- **First seen:** 2026-03-16
- **Last seen:** 2026-03-16
- **Action:** Fill in PROFILE.md fully before starting the next session. Treat it as a one-time setup task.

### Sessions without a close step — BAD
- **Pattern:** Sessions that end without invoking the session-closer skill produce no usable history entries. Context is lost and the next session starts from zero.
- **First seen:** 2026-03-16
- **Last seen:** 2026-03-16
- **Action:** Always end every work block with: "close the session".
