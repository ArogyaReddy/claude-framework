# Claude Code Framework — Complete Rebuild Guide

> **Purpose:** If you ever need to rebuild this framework from zero — on a new machine, a new repo, or a new project — this document gives you everything you need. Every file, every setting, every skill, every rule.
>
> Read this once end-to-end. Then use it as a recipe when building.

---

## 1. What This Framework Is (The 60-Second Version)

Claude Code is an AI coding tool. Without guidance, it forgets everything between sessions, writes verbose responses, touches files you didn't ask it to, and costs you more tokens than necessary.

This framework is a **set of files that fix all of that** — permanently.

You set it up once. After that, every session Claude already knows:
- Who you are and how you communicate
- Your exact tech stack
- What it is and is not allowed to do
- Where you left off yesterday
- Which special behaviors to activate and when

**The framework does not change Claude's model. It changes Claude's context — what it can see.**

---

## ★ The Two-Layer Architecture (Read This Before Everything Else)

This is the most important concept in the entire framework. Most documentation gets this wrong.

**You do NOT copy this framework into every project.**

Instead, the framework works in two layers that load simultaneously for every session:

```
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER 1 — GLOBAL (fires in EVERY session, EVERY project)           │
│  Location: C:\Users\[You]\.claude\CLAUDE.md                         │
├─────────────────────────────────────────────────────────────────────┤
│  Contains:                                                           │
│  - Universal output rules (no preamble, no summary, etc.)           │
│  - Safety rules (never touch .env, never force push, etc.)          │
│  - FRAMEWORK_PATH pointing to C:/AROG/Claude-Free/claude-framework  │
│  - All 17 skills listed with their central path                     │
│  - Session startup protocol (read CLAUDE.md, read SESSION_LOG, etc.)│
│                                                                      │
│  Result: These rules apply automatically everywhere, always.        │
└─────────────────────────────────────────────────────────────────────┘
                              +
┌─────────────────────────────────────────────────────────────────────┐
│  LAYER 2 — PROJECT (loads only for THIS project folder)             │
│  Location: [your-project]/CLAUDE.md                                 │
├─────────────────────────────────────────────────────────────────────┤
│  Contains:                                                           │
│  - Tech stack (TypeScript, Express, PostgreSQL, etc.)               │
│  - Project file structure (/src/api, /src/components, etc.)         │
│  - Project-specific hard rules                                      │
│  - Any rules that override global defaults for this project only    │
│                                                                      │
│  Result: Claude also knows the specifics of this exact project.     │
└─────────────────────────────────────────────────────────────────────┘
```

Both files load together. Project rules extend or override global rules. If there is no project CLAUDE.md, only the global rules apply — and Claude still knows all 17 skills.

### What This Means Practically

| Situation | What You Need to Do |
|---|---|
| **New project (blank repo)** | Create a project CLAUDE.md with tech stack + rules. Skills work immediately. |
| **Existing project with existing CLAUDE.md** | Add a framework skills block to the bottom of the existing file. Do not overwrite. |
| **Existing project with no CLAUDE.md** | Create one with tech stack + rules. Global layer covers the rest. |
| **Just want skills available** | Nothing required. Global CLAUDE.md already makes all skills accessible. |

### Skills Are Available in Every Project — Without Copying

When you type `Use debug-first skill.` in any project, Claude reads:
```
C:/AROG/Claude-Free/claude-framework/skills/debug-first.md
```
It reads from the **central location**. No skill files need to be in your project. This works in any folder, on any repo.

### Per-Project Files (The Minimal Set)

The only files you create inside each project:

```
your-project/
├── CLAUDE.md          ← Project-specific rules only (tech stack + hard rules)
├── .claudeignore      ← What to hide in THIS project
├── SESSION_LOG.md     ← Auto-created by Claude. Never create manually.
└── .claude/
    └── settings.json  ← Project-specific permissions (optional)
```

PROFILE.md can live either globally (`~/.claude/PROFILE.md`) or per-project. If global, it applies everywhere.

---

## 2. The Complete File Map

Every file this framework uses, where it lives, and what it does:

```
YOUR-PROJECT/
│
├── CLAUDE.md                    ← AUTO-LOADED every session. The master rulebook.
├── PROFILE.md                   ← AUTO-LOADED every session. Who you are.
├── SESSION_LOG.md               ← AUTO-LOADED. Written by Claude at session end.
├── .claudeignore                ← Controls what Claude can/cannot see.
│
├── .claude/
│   ├── settings.json            ← Permissions: deny/ask/allow + budget cap.
│   ├── skills/                  ← Skills only for THIS repo's sessions (not copied out).
│   │   ├── simplify.md
│   │   ├── batch.md
│   │   ├── problem-solver.md
│   │   └── code-run-faster.md
│   ├── history/
│   │   ├── decisions.md         ← Written by decision-log skill.
│   │   ├── learnings.md         ← Written by session-closer skill.
│   │   └── patterns.md          ← Written by session-closer skill.
│   └── logs/
│       └── pre-compact-state.md ← Written by pre-compact hook.
│
├── skills/                      ← Central skills library. Read via FRAMEWORK_PATH — never copied to projects.
│   ├── _template.md             ← How to create a new skill.
│   ├── debug-first.md
│   ├── scope-guard.md
│   ├── code-review.md
│   ├── spec-to-task.md
│   ├── change-manifest.md
│   ├── session-closer.md
│   ├── minimal-output.md
│   ├── output-control.md
│   ├── structured-response.md
│   ├── followup-refine.md
│   ├── safe-cleanup-with-backup.md
│   ├── duplicate-structure-audit.md
│   ├── jsx-to-standalone-html.md
│   ├── healthcheck.md
│   ├── decision-log.md
│   ├── project-scan.md
│   └── framework-apply.md
│
├── hooks/                       ← Scripts auto-executed by Claude Code app.
│   ├── pre-tool-use.ps1         ← Runs BEFORE every tool action.
│   ├── post-tool-use.ps1        ← Runs AFTER every tool action.
│   └── pre-compact.ps1          ← Runs BEFORE context compression.
│
├── prompts/                     ← Reference prompt templates.
│   ├── golden-prompts.md        ← 12 copy-paste prompt patterns.
│   ├── mega-prompt-template.md  ← XML template for complex tasks.
│   ├── managing-output-length.md← Output control reference card.
│   └── prompt-decisions.md      ← Which prompt pattern for which situation.
│
├── specs/                       ← Feature blueprints (one per feature).
│   └── _template.md             ← Spec template.
│
├── workflow/                    ← Daily habits reference.
│   ├── daily-checklist.md
│   ├── token-discipline.md
│   └── project-setup.md
│
├── registry/                    ← Read by project-scan and framework-apply.
│   ├── skills-registry.md       ← All skills with metadata.
│   ├── hooks-registry.md        ← All hooks with metadata.
│   └── patterns-registry.md     ← Reusable code patterns.
│
├── README.md                    ← Framework overview and quick reference.
├── CLAUDE-TEMPLATE.md           ← Template to copy as CLAUDE.md on new projects.
├── BEGINNERS-GUIDE.md           ← Full beginner explanation (this framework explained).
└── FRAMEWORK-REBUILD-GUIDE.md   ← This rebuild guide.
```

---

## 3. Build Order (What to Create First)

> **This section is for rebuilding the CENTRAL framework repo at `C:/AROG/Claude-Free/claude-framework/`.**
> For applying the framework to an individual project (new or existing), go directly to Section 19.

Follow this sequence. Each step depends on the ones before it.

```
PHASE 1: Foundation (do these first — nothing works without them)
  Step 1  → Create CLAUDE.md
  Step 2  → Create PROFILE.md
  Step 3  → Create .claudeignore
  Step 4  → Create .claude/settings.json

PHASE 2: Skills (Claude's special behaviors)
  Step 5  → Create skills/ directory with all skill .md files
  Step 6  → Create .claude/skills/ for repo-specific skills

PHASE 3: Automation (hooks that fire automatically)
  Step 7  → Create hooks/ directory with 3 .ps1 scripts

PHASE 4: Reference Library (prompts, specs, workflow)
  Step 8  → Create prompts/ directory with 4 files
  Step 9  → Create specs/ with template
  Step 10 → Create workflow/ with 3 files

PHASE 5: Registry (for project-scan and framework-apply to work)
  Step 11 → Create registry/ with 3 files

PHASE 6: History (auto-created by Claude — just create the directories)
  Step 12 → Create .claude/history/ and .claude/logs/ directories

PHASE 7: Documentation
  Step 13 → Create README.md
  Step 14 → Create CLAUDE-TEMPLATE.md (blank rulebook for new projects)
```

SESSION_LOG.md is NOT created manually — Claude writes it the first time you run "Close the session."

---

## 4. CLAUDE.md — The Master Rulebook

**What it is:** Loaded into Claude's context window automatically at the start of every session. Every rule you write here applies without you typing it in prompts.

**Where it lives:** Project root (top level, next to package.json / src / etc.)

**Exact structure to use:**

```markdown
# CLAUDE.md — [Project Name]

## Identity
You are a precise senior software engineer.
Do only what is asked. Nothing more.
Do not add unrequested features, documentation, or refactors.

## Output Rules
- No preamble ("Sure!", "Of course!", "Here is...")
- No closing summary
- Return only the modified function or file, not the whole project
- Comments only where logic is non-obvious
- No type annotations on code I did not write

## Scope Rules
- Only touch the file(s) explicitly named in the prompt
- If a fix requires an unmentioned file, STOP and report it — do not touch it
- No drive-by refactors of nearby code
- No new dependencies without explicit approval

## Tech Stack
- Language: [e.g. TypeScript, Node 20]
- Frontend: [e.g. React 18, Tailwind CSS]
- Backend: [e.g. Express.js]
- Database: [e.g. PostgreSQL with Prisma ORM]
- Tests: [e.g. Jest + React Testing Library]
- Linter: [e.g. ESLint + Prettier]

## Project Structure
- /src/api        — [description]
- /src/components — [description]
- /src/services   — [description]
- /src/types      — [description]
- /tests          — [description]

## Hard Rules
- Never touch .env files
- Never run database migrations without explicit instruction
- Never commit or push without explicit per-session instruction
- Never install packages without asking first
- Never use rm -rf under any circumstance

## Skills Available
- skills/debug-first.md        → Any bug or error
- skills/scope-guard.md        → Multi-file or risky changes
- skills/code-review.md        → Pre-merge quality check
- skills/spec-to-task.md       → Before starting a feature
- skills/change-manifest.md    → After any multi-file edit
- skills/session-closer.md     → End of every session
- skills/minimal-output.md     → Code only, no narration
- skills/healthcheck.md        → When setup feels broken
- skills/decision-log.md       → Recording architectural decisions
```

**Key principle:** Vague rules get interpreted. Specific rules get followed.
- BAD: "Be concise"
- GOOD: "Responses must be under 5 sentences unless I explicitly ask for more"

---

## 5. PROFILE.md — Claude's Personal Notes About You

**What it is:** Companion to CLAUDE.md. Tells Claude about YOU — your communication style, experience level, preferences, and name. Loaded every session alongside CLAUDE.md.

**Where it lives:** Project root (same level as CLAUDE.md)

**Exact structure to use:**

```markdown
# PROFILE.md

## Who I Am
- Name: [Your name]
- Role: [e.g. Senior Software Engineer]
- Current Project: [Project name and one-line description]

## Technical Background
- Primary languages: [e.g. TypeScript, JavaScript]
- Strongest areas: [e.g. API design, React]
- Currently learning: [e.g. system architecture, DevOps]

## Communication Style
- When explaining: [e.g. Be direct. Use examples over abstract descriptions.]
- Tone I prefer: [e.g. Peer-to-peer, no fluff]
- What I dislike: [e.g. Long preambles, over-cautious disclaimers]
- When I ask a question: [e.g. Answer first, context second]

## Decision Patterns
- [e.g. I prefer simple solutions over clever ones]
- [e.g. I prefer editing existing files over creating new ones]
- [e.g. I am cost-conscious — keep responses tight]

## Project-Specific Notes
- [Any personal conventions, preferred patterns, things to remember]
```

**Critical warning:** PROFILE.md ships with placeholder text. Fill it in before your first real session. The session-closer skill checks for unfilled placeholders and warns you.

---

## 6. SESSION_LOG.md — The Session Memory

**What it is:** A running log of what happened in each work session. Claude writes this. You do not create or edit it manually.

**Where it lives:** Project root (auto-created by Claude the first time you run "Close the session.")

**How it's created:** You type `Close the session.` at the end of every session. Claude reads the session-closer skill, reviews the entire conversation, and writes a summary.

**What Claude writes in it (automatic):**
```markdown
## Session: [Date]

### What Was Done
- [Bullet list of completed tasks]

### Decisions Made
- [Any architectural or design decisions]

### Unfinished Work
- [What is still in progress]

### Next Session
- [What to do first next time]

### Warnings / Notices
- [Anything Claude flagged for attention]
```

**Why this matters:** Without SESSION_LOG.md, every session starts from zero. With it, Claude opens tomorrow and already knows exactly where you left off — no re-explaining.

---

## 7. .claudeignore — Token Budget Protector

**What it is:** Works exactly like .gitignore but controls what Claude can and cannot see. Files listed here are invisible to Claude — it cannot read them or waste tokens on them.

**Where it lives:** Project root

**Template to use:**
```
# Build output — Claude doesn't need compiled files
dist/
build/
.next/
out/

# Dependencies — NEVER let Claude read these
node_modules/

# Logs — not useful for coding tasks
*.log
logs/

# Environment files — extra protection (deny rules also block this)
.env
.env.*
.env.local
.env.production

# Lock files — auto-generated, irrelevant
package-lock.json
yarn.lock
pnpm-lock.yaml

# Media and large data — eats tokens with zero coding benefit
*.png
*.jpg
*.jpeg
*.gif
*.mp4
*.pdf
*.csv
seed-data/
fixtures/

# OS and editor files
.DS_Store
Thumbs.db
.vscode/
.idea/
```

**Rule:** When in doubt, ignore it. You can always add it back. The cost of accidentally reading a 10,000-line file is 30,000+ tokens.

---

## 8. .claude/settings.json — Safety Layer

**What it is:** Permission rules enforced by the Claude Code app. First matching rule wins. Deny always beats allow.

**Where it lives:** `.claude/settings.json` (create the `.claude/` directory first)

**Three tiers:**
- `deny` → Blocked permanently. Claude cannot do this even if you ask.
- `ask` → Claude pauses and asks permission first.
- `allowedTools` → Passes through automatically, no interruption.

**Template to use:**
```json
{
  "maxBudgetUsd": 50,

  "permissions": {
    "deny": [
      "Read(.env*)",
      "Write(.env*)",
      "Bash(rm -rf*)",
      "Bash(sudo *)",
      "Bash(git push --force*)",
      "Bash(DROP *)",
      "Bash(TRUNCATE *)"
    ],
    "ask": [
      "Bash(npm install*)",
      "Bash(pip install*)",
      "Bash(yarn add*)",
      "Bash(git push*)"
    ],
    "allowedTools": [
      "Read",
      "Write",
      "Edit",
      "Bash(git status)",
      "Bash(git diff*)",
      "Bash(git log*)",
      "Bash(git add*)",
      "Bash(git commit*)",
      "Bash(npm run *)",
      "Bash(npm test*)"
    ]
  },

  "hooks": {
    "PreToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -File hooks/pre-tool-use.ps1"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -File hooks/post-tool-use.ps1"
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "powershell -File hooks/pre-compact.ps1"
          }
        ]
      }
    ]
  }
}
```

**Key rule:** `deny` rules use pattern matching. `Write(.env*)` blocks writing to `.env`, `.env.local`, `.env.production`, etc. The `*` is a wildcard.

---

## 9. The 17 Skills — Complete Reference

A skill is a markdown file containing instructions. When you invoke a skill, Claude Code reads the file and adds its contents to Claude's context. No code runs. It is just text.

**Two types:**
- `agent: true` — Spawns a subagent (protects your main context window). Use for skills that read many files.
- `agent: false` — Instructions go directly into your current session. Use for behavior modifiers.

### Full Skills Table

| # | Skill | File | Invoke Phrase | When | Agent |
|---|---|---|---|---|---|
| 1 | debug-first | skills/debug-first.md | `Use debug-first skill.` | Any bug or error | false |
| 2 | scope-guard | skills/scope-guard.md | `Use scope-guard skill.` | Multi-file tasks | false |
| 3 | code-review | skills/code-review.md | `Use code-review skill on [file]` | Before merging | true |
| 4 | spec-to-task | skills/spec-to-task.md | `Use spec-to-task skill on [spec]` | Before building a feature | true |
| 5 | change-manifest | skills/change-manifest.md | `Use change-manifest skill.` | After multi-file changes | false |
| 6 | session-closer | skills/session-closer.md | `Close the session.` | End of every session | false |
| 7 | minimal-output | skills/minimal-output.md | `Use minimal-output skill.` | Want code only, no narration | false |
| 8 | output-control | skills/output-control.md | `Use output-control skill.` | Need exact format/length | false |
| 9 | structured-response | skills/structured-response.md | `Use structured-response skill.` | Need labeled sections | false |
| 10 | followup-refine | skills/followup-refine.md | `Use followup-refine skill.` | Two audiences (tech + non-tech) | false |
| 11 | safe-cleanup-with-backup | skills/safe-cleanup-with-backup.md | `Use safe-cleanup-with-backup skill.` | Before deleting files | false |
| 12 | duplicate-structure-audit | skills/duplicate-structure-audit.md | `Use duplicate-structure-audit skill.` | Suspect duplicate folders | true |
| 13 | jsx-to-standalone-html | skills/jsx-to-standalone-html.md | `Use jsx-to-standalone-html skill on [file]` | Share React component as demo | true |
| 14 | healthcheck | skills/healthcheck.md | `Use healthcheck skill.` | After setup / when broken | true |
| 15 | decision-log | skills/decision-log.md | `Use decision-log skill.` | After architectural decision | false |
| 16 | project-scan | skills/project-scan.md | `Use project-scan skill on [/path]` | Onboarding any new project | true |
| 17 | framework-apply | skills/framework-apply.md | `Use framework-apply skill.` | After project-scan | true |

### Skill File Format (How to Write a New Skill)

Every skill .md file follows this structure:

```markdown
---
name: skill-name
description: One sentence — what this skill does.
invocation: manual
agent: false
---

# [Skill Name]

## Trigger
"Use [skill-name] skill."

## Purpose
[What problem this solves and why it exists.]

## Rules
When this skill is active:
1. [Rule 1]
2. [Rule 2]
3. [Rule 3]

## Output Format
[Exactly what Claude should return when this skill is active.]

## Example Invocation
"Use [skill-name] skill. [Task description]."
```

---

## 10. Hooks — Automatic Scripts

Hooks are PowerShell scripts (`.ps1`) that the Claude Code **app** runs automatically. Claude the AI does not run them — the app does. This is deterministic automation, not AI behavior.

**The 3 hooks and what they do:**

### pre-tool-use.ps1
Runs BEFORE every tool call (Read, Write, Edit, Bash, etc.)

```powershell
# hooks/pre-tool-use.ps1
# Receives: tool name and parameters via stdin as JSON
param([string]$inputJson = "")

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logDir = ".claude/logs"

if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Log the action
Add-Content -Path "$logDir/tool-log.txt" -Value "[$timestamp] PRE: $inputJson"

# Exit 0 = allow the action
# Exit 1 = block the action (with error message)
exit 0
```

### post-tool-use.ps1
Runs AFTER every tool call completes.

```powershell
# hooks/post-tool-use.ps1
param([string]$inputJson = "")

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logDir = ".claude/logs"

Add-Content -Path "$logDir/tool-log.txt" -Value "[$timestamp] POST: $inputJson"

exit 0
```

### pre-compact.ps1
Runs BEFORE Claude compresses the context window (`/compact`).

```powershell
# hooks/pre-compact.ps1
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logDir = ".claude/logs"

if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

# Write a snapshot before compression
Add-Content -Path "$logDir/pre-compact-state.md" -Value "## Compact at $timestamp`n"

exit 0
```

**How hooks connect to settings.json:**
Hooks are registered in `.claude/settings.json` under the `hooks` key. The three lifecycle points are:
- `PreToolUse` — before any tool action
- `PostToolUse` — after any tool action
- `PreCompact` — before context compression

---

## 11. Prompts — The Reference Library

Four files in `prompts/`. These are reference documents — you copy from them, you don't invoke them as skills.

### golden-prompts.md
12 ready-to-use prompt patterns covering: fix, plan, build from spec, debug, review, refactor, output format, explain, compare, summarise, write tests, multi-requirement XML task.

### mega-prompt-template.md
Full XML template for complex multi-part tasks:
```xml
<task>
  <goal>[What done looks like]</goal>
  <requirements>
    - [Requirement 1]
    - [Requirement 2]
  </requirements>
  <constraints>
    - [What must not change]
  </constraints>
  <output>[Exactly which files]</output>
</task>
```

### managing-output-length.md
5 techniques for controlling output format and length:
- XML tags: `<format>`, `<length>`, `<sections>`
- Inline instructions: "Return only the function."
- Skill: minimal-output
- CLAUDE.md output rules (permanent)
- Prompt suffix: "No explanation. No summary."

### prompt-decisions.md
Decision table: given your situation, which prompt pattern to use.

---

## 12. Specs — Feature Blueprints

**What they are:** A spec is written BEFORE you build a feature. It defines exactly what to build so Claude doesn't interpret or guess.

**Where they live:** `specs/` directory. One file per feature.

**Naming convention:** `specs/feature-name.md`

### spec/_template.md — The Template

```markdown
# Spec: [Feature Name]

Status: Draft | Approved | In Progress | Done
Spec ID: SPEC-[number]

## 1. Problem
[What is broken or missing today? One paragraph.]

## 2. Goal
[What does "done" look like? One sentence.]

## 3. Scope

### In Scope
- [Exactly what will be built]
- [Keep this list short and specific]

### Out of Scope
- [What will NOT be built in this version]

## 4. Behavior

### 4.1 [Action Name]
Input:  [parameters and types]
Output: [return value and type]
Edge:   [edge cases and how to handle them]

## 5. Files Affected

| File | Change Type | Notes |
|---|---|---|
| [path/to/file.ts] | Create / Modify | [what changes] |

## 6. Acceptance Criteria

- [ ] [Testable condition 1]
- [ ] [Testable condition 2]
- [ ] [Testable condition 3]
```

**How the spec flows into work:**
```
Write spec → "Use spec-to-task skill on specs/feature.md"
           → Get ordered task list
           → Execute tasks one at a time with scope-guard
           → Run code-review on each file
           → Use change-manifest
           → Close the session
```

---

## 13. Workflow Files

Three reference files in `workflow/`:

### daily-checklist.md
A checklist to run every day. Covers:
- Session startup (check context, check session log)
- Before every task (scope, action, fence, output check)
- During session (context usage check, compact at 60%)
- End of session (change-manifest, close session)

### token-discipline.md
10 rules ranked by token impact. Every rule has:
- The problem (what wastes tokens)
- The rule (what to do instead)
- Bad/good example
- Estimated token savings

### project-setup.md
Complete setup guide for applying this framework to any new or existing project. Covers:
- Initial scan → apply → fill in → verify steps
- File structure to create
- CLAUDE.md sections to complete
- .claude/rules/ split pattern for large projects
- git worktrees for parallel sessions

---

## 14. Registry Files — The Framework's Index

Three files in `registry/`. These are read by `project-scan` and `framework-apply` skills to know what exists.

### skills-registry.md
Entry for every skill in `skills/`:
```markdown
### skill-name
- **File:** skills/skill-name.md
- **Trigger:** "Use skill-name skill."
- **Category:** [safety / debugging / quality / output / session / onboarding / audit]
- **Applies to:** All stacks / [specific stack]
- **When to add:** [condition]
- **Signs it's needed:** [observable problem it solves]
- **Priority:** HIGH / MEDIUM / LOW
- **Dependencies:** [other skills or files needed]
```

### hooks-registry.md
Entry for every hook. Same format as skills-registry.

### patterns-registry.md
Reusable code patterns for your stack. Referenced by framework-apply when generating CLAUDE.md for specific tech stacks.

---

## 15. Token-Saving Parameters — Everything That Reduces Cost

These are the exact levers that control token consumption:

### A. .claudeignore (biggest single impact)
Hides irrelevant files. node_modules alone = 50,000+ tokens if Claude reads it.
- **Impact:** 10,000–50,000 tokens per session saved.
- **Action:** Always list: node_modules/, dist/, build/, *.log, .env*, lock files.

### B. settings.json maxBudgetUsd
Hard spending cap.
- **Parameter:** `"maxBudgetUsd": 50`
- **Impact:** Prevents worst-case runaway costs.
- **Action:** Set to match your monthly budget / 30.

### C. CLAUDE.md output rules
Stops Claude writing 800 tokens of narration around 50 tokens of code.
- **Rules to add:**
  - "No preamble"
  - "No closing summary"
  - "Return only the modified function, not the whole file"
- **Impact:** 90% reduction per response when active.

### D. minimal-output skill
Overrides verbose behavior when you just want code.
- **Invoke:** `Use minimal-output skill.` at start of session.
- **Impact:** Same as output rules above but can be toggled per-session.

### E. 4-Element Prompts (SCOPE + ACTION + FENCE + OUTPUT)
Prevents back-and-forth clarification rounds.
- **Without:** 3–5 rounds × 500 tokens each = 1,500–2,500 tokens.
- **With:** One round = ~200 tokens.
- **Impact:** 80%+ reduction per ambiguous task.

### F. Specs before building
Prevents "that's not what I meant" rebuild cycles.
- **Without spec:** Average 3 rebuild rounds × 3,000 tokens = 9,000 tokens.
- **With spec:** ~400 tokens total.
- **Impact:** 3,000–8,000 tokens per feature.

### G. scope-guard skill
Stops Claude reading extra files "to understand context."
- **Invoke:** `Use scope-guard skill.` before any multi-file task.
- **Impact:** 500–5,000 tokens per task.

### H. /compact with preservation instructions
Compresses conversation history without losing key context.
- **When:** At 60% context usage. Do not wait until 90%+.
- **How:** `/compact Preserve: specs, file paths, open decisions. Discard: completed steps, raw tool output.`
- **Impact:** Extends session by 10–20× without quality loss.

### I. SESSION_LOG.md
Eliminates re-explaining context at the start of every session.
- **Without:** 200–500 tokens of re-explaining every day.
- **With:** Zero — Claude reads it automatically.

### J. Skills as 3-word shortcuts
Replaces 50–150 word explanations with a 3-word invocation.
- **Example:** "Use debug-first skill." (4 tokens) vs. a 100-word explanation of the same behavior (100 tokens).
- **Impact:** 90%+ per invocation.

---

## 16. The .claude/history/ Directory

Created automatically by the session-closer skill when it writes session summaries.

```
.claude/history/
├── decisions.md    ← Written by decision-log skill.
│                     Records: date, decision, reason, alternatives, who decided.
├── learnings.md    ← Written by session-closer.
│                     Records: patterns discovered, what worked, what to avoid.
└── patterns.md     ← Written by session-closer.
                      Records: recurring code patterns identified during sessions.
```

These files build compounding knowledge over time. The longer you use the framework, the more Claude understands about your codebase without you explaining.

---

## 17. CLAUDE-TEMPLATE.md — The Blank Rulebook

This is a ready-to-fill-in version of CLAUDE.md that you copy to every new project.

**How to use it:**
1. Copy CLAUDE-TEMPLATE.md to your new project root
2. Rename it to CLAUDE.md
3. Fill in: tech stack, project structure, team rules
4. Delete any sections that don't apply

**It ships with placeholder text in brackets:**
```markdown
## Tech Stack
- Language: [e.g. TypeScript Node 20 / Python 3.11 / Go 1.22]
- Framework: [e.g. Express / FastAPI / Gin]
```

Replace every `[...]` with your actual values before the first session.

---

## 18. What Makes the Difference (Key Insights)

These are the things that separate a framework that actually works from one that doesn't:

**1. CLAUDE.md specificity**
Vague rules get interpreted differently every session. Write rules as constraints, not suggestions. "Be concise" → "Responses under 5 sentences." "Be careful" → "Never touch these 3 files."

**2. PROFILE.md actually filled in**
A blank or placeholder PROFILE.md gives Claude no useful information. A filled-in PROFILE.md means Claude adapts its communication style to you — not to a generic user.

**3. SESSION_LOG.md after every session, without exception**
Even a 10-minute session. If you don't close properly, you lose continuity. The 30 seconds to close the session saves you 5 minutes of re-explaining tomorrow.

**4. .claudeignore set aggressively**
Most token waste comes from Claude reading files it shouldn't. Set `.claudeignore` before the first session. Start restrictive.

**5. Skills invoked at the start of a task, not in the middle**
"Use scope-guard skill. [task]." — not "[task, goes wrong], use scope-guard." Skills set behavior before the action. Invoking them after doesn't undo what already happened.

**6. Specs written before building, not while building**
A spec forces you to think through what you want before Claude starts writing code. The clarification happens in the spec — not in 5 rounds of correction after implementation.

**7. /compact at 60%, not 90%**
Context quality degrades above 80%. Compact early. The preservation instructions matter — always tell Claude what to keep and what to discard.

**8. skills/ vs .claude/skills/**
`skills/` — lives in the central framework repo. Read via absolute FRAMEWORK_PATH from any project. Never copied.
`.claude/skills/` — only available in Claude Code sessions on THIS repo. Use for framework-maintenance skills not relevant to other projects.

---

## 19. Applying to Any Project (New or Existing)

> **Reminder:** You do NOT copy the framework into projects. Skills, prompts, hooks — all live in the central repo. You only create a thin project-level CLAUDE.md and .claudeignore per project.

---

### Scenario A — New Project (Blank Repo)

**Step 1: Create the project CLAUDE.md**

Create `CLAUDE.md` in the project root. Fill in only project-specific information:

```markdown
# CLAUDE.md — [Project Name]

## Tech Stack
- Language: [e.g. TypeScript, Node 20]
- Frontend: [e.g. React 18]
- Backend: [e.g. Express.js]
- Database: [e.g. PostgreSQL with Prisma]
- Tests: [e.g. Jest]

## Project Structure
- /src/api        — [what lives here]
- /src/components — [what lives here]
- /src/services   — [what lives here]
- /src/types      — [what lives here]
- /tests          — [what lives here]

## Hard Rules
- Never touch .env files
- Never run migrations without explicit instruction
- Never install packages without asking first
- Never commit or push without explicit instruction

## Skills Available (via global framework)
- Use debug-first skill.           → Any bug or error
- Use scope-guard skill.           → Multi-file or risky changes
- Use code-review skill on [file]  → Before merging
- Use spec-to-task skill on [spec] → Before building a feature
- Use change-manifest skill.       → After multi-file changes
- Close the session.               → End of every session
```

**Step 2: Create .claudeignore**

Use the template from Section 7. Customize for this project's build output, data folders, and generated files.

**Step 3: Create .claude/settings.json (optional)**

Use the template from Section 8. Customize the deny/ask/allow rules for this project's tools and commands.

**Step 4: Run the sanity check**

```
Read CLAUDE.md. Confirm by listing:
- The 3 most important output rules
- The 2 hardest rules
- Which skills are available
No other output.
```

If Claude answers correctly → the global layer + project layer are both active and working.

**Step 5: Close first session properly**

```
Close the session.
```

This creates `SESSION_LOG.md` in the project root. Every future session starts by reading it.

---

### Scenario B — Existing Project That Already Has CLAUDE.md

**Do NOT overwrite the existing CLAUDE.md.** Add to it.

Open the existing `CLAUDE.md` and append this block at the bottom:

```markdown
## Framework Skills (via global framework at C:/AROG/Claude-Free/claude-framework/)
- Use debug-first skill.                      → Diagnose before fixing any bug
- Use scope-guard skill.                      → Lock scope before multi-file changes
- Use code-review skill on [file]             → Pre-merge quality check
- Use spec-to-task skill on [specs/file.md]  → Break spec into ordered tasks
- Use change-manifest skill.                  → Audit what changed after edits
- Close the session.                          → Save progress to SESSION_LOG.md
```

Then create `.claudeignore` if it does not exist. That is all.

The global CLAUDE.md already provides: output rules, safety rules, session startup protocol. You do not need to duplicate those in the project CLAUDE.md.

**If the existing project has conflicting rules** (e.g. it says "always write verbose explanations" but global says "no preamble"):
- Project rules take precedence
- Either remove the conflict from the project CLAUDE.md, or leave it — Claude will follow the project rule for that specific case

---

### Scenario C — Existing Project With No CLAUDE.md

Create a minimal one using Scenario A. The global layer already provides all the framework behaviors. The project CLAUDE.md only needs to add: tech stack, project structure, project-specific rules.

---

### Using project-scan for Any Scenario

If you are unsure what the project needs, run from the framework repo:

```
Use project-scan skill on /absolute/path/to/project
```

Claude reads the project and produces a `PROJECT_SCAN.md` gap report. It tells you:
- What framework files the project already has
- What is missing
- What tech stack it detected
- What rules to add to CLAUDE.md

Review the gap report. Then add only what is missing — do not copy files that aren't needed.

---

## 20. Verification Checklist — Is It Working?

Two checklists: one for the central framework, one for any project you add it to.

### A. Central Framework Verification (run once, at `C:/AROG/Claude-Free/claude-framework/`)

```
GLOBAL LAYER
[ ] C:\Users\[You]\.claude\CLAUDE.md exists
[ ] It contains: FRAMEWORK_PATH pointing to C:/AROG/Claude-Free/claude-framework
[ ] It lists all 17 skills with their full framework path

CENTRAL FRAMEWORK FILES
[ ] skills/ has all 17 .md files
[ ] hooks/ has all 3 .ps1 files
[ ] prompts/ has 4 files
[ ] workflow/ has 3 files
[ ] specs/ has _template.md
[ ] registry/ has 3 files
[ ] CLAUDE-TEMPLATE.md exists (blank rulebook for new projects)
[ ] PROFILE.md exists in framework root (filled in, no placeholder brackets)

FRAMEWORK VALIDATION
[ ] Run "Use healthcheck skill." from the framework folder → no missing files reported
```

### B. Per-Project Verification (run for each project you add the framework to)

```
PROJECT LAYER
[ ] [project]/CLAUDE.md exists with tech stack and hard rules
[ ] [project]/.claudeignore exists and includes node_modules/
[ ] Skills block appears somewhere in CLAUDE.md (or in global CLAUDE.md)

OPTIONAL BUT RECOMMENDED
[ ] [project]/.claude/settings.json exists with deny rules for .env files

SESSION MEMORY TEST
[ ] Type "Close the session." → SESSION_LOG.md is created in project root
[ ] Close and reopen Claude Code → Claude mentions the session log in first response

SKILLS TEST
[ ] Type "Use debug-first skill." → Claude follows the structured diagnosis format
    (If this works, all 17 skills work — they all read from the same central path)

TOKEN PROTECTION TEST
[ ] Type "What files are in node_modules?" → Claude says it cannot see that folder
    (If this works, .claudeignore is active)
```

Run `Use healthcheck skill.` from inside any project folder to get an automated report.

---

## Quick Rebuild Cheat Sheet

```
CENTRAL FRAMEWORK (built once, lives at C:/AROG/Claude-Free/claude-framework/)
──────────────────────────────────────────────────────────────────────────────────
skills/ (17 files)          ← Referenced by ALL projects, never copied
hooks/ (3 .ps1 files)       ← Referenced by ALL projects, never copied
prompts/ (4 files)          ← Manual reference library, never copied
workflow/ (3 files)         ← Manual reference library, never copied
specs/ (_template.md)       ← Copied once when setting up new project
registry/ (3 files)         ← Read by project-scan and framework-apply skills
CLAUDE-TEMPLATE.md          ← Copied+renamed as CLAUDE.md in each new project
PROFILE.md                  ← Can be global (~/.claude/) or per-project

GLOBAL LAYER (C:\Users\[You]\.claude\CLAUDE.md — loads in EVERYTHING)
──────────────────────────────────────────────────────────────────────────────────
Universal output rules      ← Applies to every project, always
Safety rules                ← Applies to every project, always
FRAMEWORK_PATH reference    ← Tells Claude where skills live
All 17 skills listed        ← Makes them invocable from any project
Session startup protocol    ← Loads CLAUDE.md and SESSION_LOG.md each session

PER-PROJECT (create only these 3-4 files inside each project)
──────────────────────────────────────────────────────────────────────────────────
[project]/CLAUDE.md         ← Tech stack + project structure + hard rules only
[project]/.claudeignore     ← What to hide in THIS project
[project]/SESSION_LOG.md    ← Auto-created by "Close the session." — never create manually
[project]/.claude/settings.json ← Optional: project-specific permissions

──────────────────────────────────────────────────────────────────────────────────
The 3 habits that make it work everywhere:
  → "Use scope-guard skill."  before every task
  → "Close the session."      after every session
  → /compact at 60%           during long sessions
```

---

*Claude Code Master Framework — Rebuild Guide*
*Framework version: March 2026*
