# Prompt: Session Pattern Analysis

Use this prompt to analyze your Claude usage history and decide what to promote into skills, CLAUDE.md, or agents.

---

```
Scrape all of my Claude sessions on this computer.

Analyze my usage patterns and give me a breakdown of:

- What I do most frequently
- What should become skills (reusable workflows/knowledge)
- What should become plugins (standalone tools)
- What should become agents (autonomous subagents)
- What belongs in CLAUDE.md (project-level instructions)
```

---

## How to Use the Output

| Category | What to Do |
|---|---|
| Repeated prompt patterns | Create a skill in `skills/` using `skills/_template.md` |
| Project context you re-explain | Add to `CLAUDE.md` |
| Multi-file analysis tasks | Create a skill with `agent: true` |
| One-off utilities | Create a standalone tool in `tools/` |
