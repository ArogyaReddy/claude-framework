# Decisions Log

> Architectural, tooling, and approach decisions made across sessions.
> Updated by the session-closer skill. Read by Claude before making similar decisions.
> Format: Date | Decision | Reason | Alternatives Rejected

---

## Format

```
### [YYYY-MM-DD] — [Decision title]
- **Decision:** [What was decided]
- **Reason:** [Why this was chosen]
- **Alternatives rejected:** [What else was considered and why it lost]
- **Applies to:** [Project / Feature / Global]
```

---

<!-- DECISIONS BELOW — newest first -->

### [2026-03-16] — Filesystem-only context protocol
- **Decision:** Use markdown files (PROFILE.md, SESSION_LOG.md, history/) as the sole context persistence layer — no database, no external service.
- **Reason:** Zero new dependencies, Claude reads markdown natively, works across tools.
- **Alternatives rejected:** External memory DB (overkill), per-session manual notes (doesn't scale).
- **Applies to:** Global — all sessions and projects.

### [2026-03-16] — Output format defaults in CLAUDE.md
- **Decision:** Set system-level output defaults in CLAUDE.md rather than repeating format instructions in every prompt.
- **Reason:** Reduces per-prompt token cost, enforces consistency across all sessions.
- **Alternatives rejected:** Per-prompt XML tags only (requires user to always remember to add them).
- **Applies to:** Global — all Claude sessions in this framework.
