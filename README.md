# Claude Code Master Framework

A ready-to-copy framework for working with Claude Code.
Minimal tokens. Maximum precision. Zero guesswork.

---

## What's in This Framework

| File / Folder | Purpose |
|---|---|
| `CLAUDE.md` | Master persistent instructions. Loads every session. |
| `.claudeignore` | Token budget. Hides everything Claude doesn't need. |
| `.claude/settings.json` | Permissions, budget cap, and hook configuration. |
| `skills/` | Skill library — operational patterns for repeated tasks. |
| `.claude/skills/` | Session skills — available only in this repo's sessions. |
| `hooks/` | Three automation scripts: pre-tool, post-tool, pre-compact. |
| `prompts/golden-prompts.md` | 12 ready-to-use prompt templates with examples. |
| `prompts/mega-prompt-template.md` | Full XML mega-prompt reference guide. |
| `prompts/managing-output-length.md` | 5 techniques for controlling output length and format. |
| `specs/_template.md` | Spec format for every feature. |
| `workflow/daily-checklist.md` | Five-phase checklist for every task. |
| `workflow/token-discipline.md` | Ten rules for minimal token cost. |
| `workflow/project-setup.md` | One-time setup instructions per project. |
| `registry/` | Skills, hooks, and patterns registries — full index. |

---

## Start Here

**New project:** Follow `workflow/project-setup.md` step by step.

**Every task:** Run `workflow/daily-checklist.md` Phase 1 and 2 before sending any prompt.

**Need a prompt now:** Open `prompts/golden-prompts.md`, copy the template, fill the brackets.

**Debugging:** Type `Use debug-first skill.` before describing the bug.

**About to touch multiple files:** Type `Use scope-guard skill.` before starting.

**About to start a feature:** Type `Use spec-to-task skill on specs/[feature].md`

---

## The Master Principle

> Move as much intelligence as possible into persistent context —
> CLAUDE.md, skills, hooks — so your per-task prompts become tiny, cheap, and precise.
> The best prompt is the one that requires the least explanation
> because everything structural is already loaded.

---

## Skills Quick Reference

### Core Skills (`skills/`) — copy these to every project

| Invoke With | When |
|---|---|
| `Use minimal-output skill.` | Any session — strips all narration |
| `Use debug-first skill.` | Any bug or unexpected behavior |
| `Use scope-guard skill.` | Any multi-file or risky change |
| `Use spec-to-task skill on specs/[name].md` | Start of any feature |
| `Use code-review skill on [file].` | Pre-merge or compliance check |
| `Use change-manifest skill.` | After any multi-file edit |
| `Use session-closer skill.` | End of any session — captures knowledge |
| `Use output-control skill.` | Explicit length and format control |

### Framework Skills (`skills/`) — onboarding and safety

| Invoke With | When |
|---|---|
| `Use project-scan skill on [path].` | Starting a new project — gap analysis |
| `Use framework-apply skill.` | After project-scan — install components |
| `Use healthcheck skill.` | Verify framework is wired correctly |
| `Use safe-cleanup-with-backup skill.` | Before any destructive deletion |
| `Use duplicate-structure-audit skill.` | Find and classify duplicate folders |

### Session Skills (`.claude/skills/`) — this repo only

| Invoke With | When |
|---|---|
| `Use simplify skill.` | Review changed code for quality |
| `Use batch skill.` | Parallel multi-agent work orchestration |
| `Use code-run-faster skill.` | Profile and optimize slow code |
| `Use problem-solver skill.` | Deep structured problem analysis |

---

## Skill Directories — What Goes Where

| Directory | Scope | Purpose |
|---|---|---|
| `skills/` | Framework template | Gets copied to new projects. Operational skills that users invoke daily. |
| `.claude/skills/` | This repo only | Skills available in sessions on this framework repo. Not copied to projects. |

When you `framework-apply` a new project, only `skills/` is copied. `.claude/skills/` stays here.

---

## The Four Elements (Every Prompt Must Have All Four)

```
SCOPE   — exactly what file or function
ACTION  — exactly one thing being done
FENCE   — what must not be touched
OUTPUT  — format, exclusions, stop condition
```

When FENCE and OUTPUT live in CLAUDE.md and skills,
your prompts are only SCOPE + ACTION.
That is the goal.
