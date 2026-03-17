# Learnings Log

> Things learned about the codebase, tools, APIs, or working patterns.
> Updated by the session-closer skill.
> Read by Claude before working in areas where past learnings are relevant.

---

## Format

```
### [YYYY-MM-DD] — [Learning title]
- **Learning:** [What was discovered or understood]
- **Context:** [Where/when this came up]
- **Applies to:** [Feature / File / Tool / Global]
```

---

<!-- LEARNINGS BELOW — newest first -->

### [2026-03-16] — XML tags override CLAUDE.md output defaults
- **Learning:** When `<format>`, `<length>`, or `<sections>` tags appear in a prompt, they override the system-level defaults set in CLAUDE.md. Per-prompt tags always win.
- **Context:** Implementing output-control skill and testing system-level defaults.
- **Applies to:** All prompts using structured output skills.

### [2026-03-16] — Session-closer is the compounding mechanism
- **Learning:** The value of PROFILE.md and SESSION_LOG.md is low without a session-closer skill. The closer is what converts raw session activity into structured, reusable knowledge files.
- **Context:** Analysis of "I stopped using Claude Code" architecture document.
- **Applies to:** Framework — session management.

### [2026-03-16] — ADP ROLL: e-sign is acknowledgement + signature step
- **Learning:** E-sign is not a separate system — it is an acknowledgement task with a digital signature requirement appended. Both share the same underlying task engine.
- **Context:** ADP ROLL project onboarding analysis.
- **Applies to:** ADP ROLL — Acknowledgement Tasks, E-Sign features.
