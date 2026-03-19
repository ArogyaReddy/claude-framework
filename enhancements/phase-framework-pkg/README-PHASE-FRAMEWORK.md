# Phase Framework — Installation Guide
# The 5-phase AI-SDLC workflow for Claude Code.
# Plug-in alongside the Memory Framework.

## What This Is

A complete command + hook system that enforces the 5-phase development
workflow for every non-trivial feature built with Claude Code.

Plan → Spec → Build → Verify → Update

Each phase has a dedicated slash command. Hooks run automatically during build.
An agent is available for independent review on high-stakes features.

## File Map

```
your-project/
├── specs/                          ← Created by /spec command
│   └── [feature-name].md
├── templates/
│   └── spec-template.md            ← Used by /spec to generate specs
├── CLAUDE-MD-ADDITION.md           ← Paste into your CLAUDE.md
└── .claude/
    ├── commands/
    │   ├── plan.md                 ← /plan  — Phase 1
    │   ├── spec.md                 ← /spec  — Phase 2
    │   ├── chunk.md                ← /chunk — Phase 3
    │   ├── verify.md               ← /verify — Phase 4
    │   ├── update.md               ← /update — Phase 5
    │   └── agent-review.md         ← /agent-review — Independent review
    └── hooks/
        ├── post-edit.sh            ← Auto: type check + lint after every file
        └── pre-commit.sh           ← Auto: type check + tests before commit
```

## Installation — 4 Steps

### Step 1 — Copy commands
```bash
mkdir -p /your-project/.claude/commands
cp .claude/commands/*.md /your-project/.claude/commands/
```

### Step 2 — Copy and enable hooks
```bash
mkdir -p /your-project/.claude/hooks
cp .claude/hooks/post-edit.sh   /your-project/.claude/hooks/
cp .claude/hooks/pre-commit.sh  /your-project/.claude/hooks/
chmod +x /your-project/.claude/hooks/post-edit.sh
chmod +x /your-project/.claude/hooks/pre-commit.sh

# Also install pre-commit as a git hook
cp .claude/hooks/pre-commit.sh /your-project/.git/hooks/pre-commit
chmod +x /your-project/.git/hooks/pre-commit
```

### Step 3 — Copy spec template
```bash
mkdir -p /your-project/specs
mkdir -p /your-project/templates
cp templates/spec-template.md /your-project/templates/
```

### Step 4 — Update CLAUDE.md
Open CLAUDE-MD-ADDITION.md, copy the entire block, paste into your CLAUDE.md
(after the Memory Framework block if you have it).

---

## Daily Usage

### Starting a new feature
```
/plan          ← Describe intent, resolve architecture, agree approach
/spec          ← Write spec file — the contract for the build
```

### Building
```
/chunk         ← Build one chunk
               ← post-edit hook runs automatically (type check + lint)
/verify        ← Interrogate the output
               ← commit (pre-commit hook runs automatically)
/chunk         ← Next chunk
```

### Closing a session
```
/update        ← Harvest CLAUDE.md improvements + close spec if done
               ← Triggers /wrap from memory framework automatically
```

### High-stakes feature review
```
/verify full   ← Full spec verification
/agent-review  ← Independent Claude review (no session context bias)
```

---

## Skills vs Agents vs Hooks vs Commands — When to Use What

| Tool | What It Is | Best For |
|------|-----------|----------|
| **Command** (/plan, /spec etc.) | Prompt template — triggered by you | Structured phase transitions, workflows you initiate |
| **Hook** (post-edit, pre-commit) | Shell script — runs automatically | Automated quality checks that should ALWAYS run |
| **Agent** (/agent-review) | Separate Claude instance — no session bias | Independent review, parallel tasks, headless automation |
| **Skill** (SKILL.md) | Instruction set Claude reads | Reusable domain knowledge, style guides, output formats |

### The Decision Rule
- Should it run **automatically without prompting**? → Hook
- Should it run **when I decide to trigger it**? → Command
- Should it be done by **a Claude with no context from this session**? → Agent
- Should Claude **know how to do X consistently** across projects? → Skill

---

## Compatibility

Works alongside the Memory Framework.
Shares the same .claude/ folder structure — no conflicts.
/update triggers /wrap automatically — no double-wrap.

The two frameworks together cover the full session lifecycle:
Memory Framework → what Claude remembers
Phase Framework  → how Claude works
