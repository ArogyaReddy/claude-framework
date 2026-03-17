Your complete framework. 18 files, ready to drop into any project.

---

**What's inside:**

```
claude-framework/
├── README.md                     ← Start here. Master index.
├── CLAUDE.md                     ← Fill in your stack. Loads every session.
├── .claudeignore                 ← Token budget. Already aggressive.
├── .claude/
│   └── settings.json             ← Hooks wired up, ready to activate.
├── skills/
│   ├── minimal-output.md         ← Pure code, no narration
│   ├── debug-first.md            ← Diagnose before fix
│   ├── scope-guard.md            ← Hard fence on every task
│   ├── spec-to-task.md           ← Spec → sequenced task list
│   ├── code-review.md            ← Violations only, no opinions
│   └── change-manifest.md        ← Audit trail after edits
├── hooks/
│   ├── pre-tool-use.sh           ← Blocks dangerous commands, .env writes, package installs
│   ├── post-tool-use.sh          ← Logs all changes, flags failures
│   └── pre-compact.sh            ← Snapshots state before context compaction
├── prompts/
│   └── golden-prompts.md         ← 8 templates with real examples, copy-ready
├── specs/
│   └── _template.md              ← Spec format for every feature
└── workflow/
    ├── daily-checklist.md        ← 4-phase pre/post task checklist
    ├── token-discipline.md       ← 10 ranked rules with the why
    └── project-setup.md          ← One-time setup per project
```

---

**Three things to do after unzipping:**

1. Open `CLAUDE.md` and fill in the `[FILL IN]` sections — your stack, your conventions, your rules.
2. Run `chmod +x hooks/*.sh` to make the hooks executable.
3. Open `workflow/project-setup.md` and follow it step by step for your first project.

After that, `README.md` is your daily index and `prompts/golden-prompts.md` is your copy-paste companion.