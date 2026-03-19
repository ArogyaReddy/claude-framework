# Decision Logger
# Triggered with: /decide
# Use MID-SESSION the moment an architectural or significant decision is made.
# Don't wait for /wrap — capture decisions while context is fresh.
# Cost: ~200 tokens. Worth it every time.

A decision was just made in this session. Log it immediately to DECISIONS.md.

Determine the next available decision number by reading the current DECISIONS.md.

Append the following entry:

```
### [DECISION-XXX] [Short descriptive title — 4-6 words]
**Date:** [TODAY'S DATE]
**Status:** Active
**Decision:** [What was decided — one clear sentence]
**Reason:** [Why — include the specific constraint, requirement, or insight. Be specific enough
             that someone reading this in 6 months understands the reasoning without needing context.]
**Alternatives Considered:** [What else was on the table. Why it lost.]
**Revisit When:** [The specific condition under which this should be re-evaluated.]
```

If I haven't fully stated all the fields, ask me:
- "What alternatives were considered?"
- "Under what conditions should we revisit this?"

Then confirm: "Decision [DECISION-XXX] logged."
