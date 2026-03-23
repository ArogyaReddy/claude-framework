# STRUCTURE.md — Directory & File Guide

## Top-Level Map

```
claude-framework/
│
├── .claude/                    # Claude Code app-layer config — read by the tool, not by humans daily
│   ├── settings.json           # Hook registration. Contains absolute paths to hook scripts.
│   ├── skills/                 # Framework-repo-only skills. NOT copied to new projects.
│   │   ├── simplify.md         # Code quality review — verbosity and unnecessary complexity
│   │   ├── batch.md            # Parallel multi-agent orchestration
│   │   ├── code-run-faster.md  # Performance profiling and optimization
│   │   └── problem-solver.md   # Deep structured problem analysis
│   ├── logs/                   # Written by hook scripts — never commit these
│   │   ├── tool-use.log        # Every tool event logged by post-tool-use hook
│   │   ├── changes.log         # File paths of every Write/Edit this session
│   │   ├── session-YYYY-MM-DD.log  # Dated session log (one per day)
│   │   └── pre-compact-state.md    # State snapshot written before /compact
│   └── history/                # Archived past session knowledge
│       ├── decisions.md        # Historical decision log (rotated from DECISIONS.md)
│       └── patterns.md         # Patterns learned from past sessions
│
├── skills/                     # Framework template skills — COPIED to new projects
│   ├── debug-first.md          # Forces EXPECTS→ACTUAL→CAUSE→FIX before touching code
│   ├── scope-guard.md          # Locks changes to named files; SCOPE BLOCKER on violation
│   ├── code-review.md          # Reviews file against CLAUDE.md rules; violations only
│   ├── spec-to-task.md         # Converts spec file → ordered task list with dependencies
│   ├── change-manifest.md      # Produces file:line change report with spec references
│   ├── session-closer.md       # Writes SESSION_LOG.md and history files
│   ├── minimal-output.md       # Strips narration; code-only responses
│   ├── output-control.md       # Activates XML override tags for format/length
│   ├── structured-response.md  # Forces labeled section output
│   ├── followup-refine.md      # Two-step: technical depth then plain-English summary
│   ├── safe-cleanup-with-backup.md  # Backup + deletion with inventory report
│   ├── duplicate-structure-audit.md # Classifies duplicates: SAFE/CONFLICT/UNKNOWN
│   ├── jsx-to-standalone-html.md    # Converts .jsx/.tsx to single .html (no deps)
│   ├── healthcheck.md          # 12-point framework diagnostic: PASS/WARN/FAIL
│   ├── decision-log.md         # Writes structured ADR entry to DECISIONS.md
│   ├── project-scan.md         # Full project scan → PROJECT_SCAN.md gap report
│   └── framework-apply.md      # Installs framework components from scan report
│
├── hooks/                      # Safety automation — runs at Claude Code app layer
│   ├── pre-tool-use.ps1        # Blocks dangerous commands; logs tool events
│   ├── post-tool-use.ps1       # Logs outcomes, file paths, failures
│   └── pre-compact.ps1         # Saves state snapshot before /compact
│
├── workflow/                   # Human-facing reference docs — read these, don't invoke
│   ├── daily-checklist.md      # 5-phase checklist for every task
│   ├── token-discipline.md     # 10 rules for minimal token cost (with examples)
│   └── project-setup.md        # One-time per-project setup instructions
│
├── specs/                      # Feature specs — one file per planned feature
│   └── _template.md            # Copy this to start any spec
│
├── prompts/                    # Ready-to-use prompt templates
│   ├── golden-prompts.md       # 12 copy-paste templates with examples
│   ├── mega-prompt-template.md # Full XML mega-prompt reference guide
│   └── managing-output-length.md  # 5 techniques for output length control
│
├── registry/                   # Index of all framework components
│   ├── skills-registry.md      # Full skill list with invocations and descriptions
│   ├── hooks-registry.md       # Hook events, triggers, and log paths
│   └── patterns-registry.md    # Reusable Claude interaction patterns
│
├── templates/                  # Starter templates for common project types
│   └── [project-type].md       # Template per stack/domain
│
├── src/                        # React/Vite source (for UI reference components)
│   ├── main.jsx                # Entry point
│   └── App.jsx                 # Root component
│
├── docs/                       # Extended human-readable documentation
├── dev/                        # Development scratch and in-progress work
├── pgt/                        # Prompt generation tools
├── enhancements/               # Planned enhancements and proposals
├── tools/                      # Utility scripts and helper tools
│
├── CLAUDE.md                   # ★ Master persistent instructions. Loads every session.
├── CLAUDE-TEMPLATE.md          # Copy-paste starter version of CLAUDE.md
├── PROFILE.md                  # Developer identity — name, role, stack, comms style
├── SCRATCHPAD.md               # Current session state — rolling, replaced each /wrap
├── DECISIONS.md                # Permanent decision log — never truncated
├── SESSIONS.md                 # Lightweight audit trail — one row per session
├── FRAMEWORK-MECHANICS.md      # Honest technical explanation of what actually runs
├── FRAMEWORK-REBUILD-GUIDE.md  # Step-by-step rebuild from scratch
├── BEGINNERS-GUIDE.md          # Entry-level explanation for new Claude Code users
├── DECISIONS.md                # Permanent decision log
├── notes.md                    # Free-form scratch notes
│
├── .claudeignore               # Token budget — hides non-source files from Claude
├── .gitignore                  # Standard git ignores
│
├── setup.ps1                   # Windows installer — idempotent, prompts for profile
├── setup.sh                    # Unix/Mac installer — equivalent Bash version
│
├── package.json                # Node project config (React/Vite)
├── package-lock.json           # Lock file
├── vite.config.js              # Vite configuration
├── index.html                  # Vite HTML entry
│
├── claude-code-101-guide.html              # Reference: Claude Code 101
├── claude-code-101-architect-edition.html  # Reference: Architect-grade guide
├── claude-master-framework.html            # Reference: Framework overview
├── claude-master-framework.jsx             # React version of framework reference
├── memory-framework-reference.html        # Reference: Memory system guide
└── phase-framework-reference.html         # Reference: 5-phase protocol guide
```

---

## What to Touch for Common Tasks

| Task | Files to Edit |
|---|---|
| Change Claude's output format globally | `~/.claude/CLAUDE.md` → Output Rules section |
| Change output format for one project | `./CLAUDE.md` → Output Rules section |
| Update your developer profile | `PROFILE.md` |
| Add a new skill | New file in `skills/`, register in CLAUDE.md Core Skills |
| Add a new blocked command to hooks | `hooks/pre-tool-use.ps1` → blocked patterns list |
| Start a new feature spec | Copy `specs/_template.md` to `specs/[feature-name].md` |
| Change token budget (what Claude can read) | `.claudeignore` in project root |
| Debug why hooks aren't firing | `~/.claude/settings.json` → verify absolute paths |
| Review what decisions have been made | `DECISIONS.md` |
| See what happened last session | `SCRATCHPAD.md` |
| Add a new golden prompt template | `prompts/golden-prompts.md` |

---

## What Never to Edit Manually

| File | Why |
|---|---|
| `.claude/logs/*.log` | Written by hooks. Manual edits corrupt the audit trail. |
| `.claude/logs/pre-compact-state.md` | Written by hook before /compact. Overwritten automatically. |
| `SCRATCHPAD.md` | Written by session-closer skill. Manual edits will be overwritten at next /wrap. Edit between sessions only if needed. |
| `SESSIONS.md` | Append-only audit trail. Don't delete rows — they're your history. |
| `package-lock.json` | Generated by npm. Never hand-edit. |

---

## The Two Skill Directories Explained

This is the most common source of confusion.

**`skills/`** — the template library. When you run `Use framework-apply skill.` on a new project, skills from this directory are copied to the target. These are the operational skills you use daily.

**`.claude/skills/`** — framework-repo-only skills. These exist only here. They are NOT copied to new projects because they are introspective: they help you manage, improve, and orchestrate the framework itself. The `batch` skill is a good example — it orchestrates parallel Claude subagents, which is a framework-level concern, not a project-level one.

**Rule:** If a skill helps you work on any project → put it in `skills/`. If it only makes sense in the context of this framework repo → put it in `.claude/skills/`.

---

## The .claudeignore File

```gitignore
# Always ignore — framework root
node_modules/
dist/
build/
.next/
.git/
*.log
coverage/
.env
.env.*
__pycache__/
*.pyc
*.min.js
*.min.css
.claude/logs/
```

**Why it matters:** Without `.claudeignore`, Claude can accidentally attempt to read `node_modules/` when doing context exploration. A typical React project's `node_modules/` contains 50,000–200,000 lines of code. Reading even a fraction of that burns your token budget and produces no useful context. One wrong "let me check the project structure" call can cost $0.50–$2.00 in a single session.

The `.claudeignore` file is the single highest-ROI configuration in the framework. Write it once, save money every session.
