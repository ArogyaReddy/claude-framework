# SUMMARY-TABLE.md — Documentation Index

*This is the navigation hub for the Claude Code Master Framework documentation suite. Start here when you don't know which file to open.*

---

## Documentation Suite

| Category | File | Purpose | Primary Audience |
|---|---|---|---|
| **Core** | [README.md](README.md) | Project overview, quick start, installation, usage examples | Everyone — start here |
| **Architecture** | [ARCHITECTURE.md](ARCHITECTURE.md) | C4 context diagram, component flow, sequence diagram, 6 ADRs | Engineers, architects |
| **Interface** | [API.md](API.md) | Session commands, skill invocations, hook interface, XML override tags | Daily users, new team members |
| **Data** | [DATA-MODEL.md](DATA-MODEL.md) | Schema for every framework file (CLAUDE.md, PROFILE, memory files, specs, skills, hooks) | Engineers integrating or extending the framework |
| **Setup** | [DEVELOPMENT.md](DEVELOPMENT.md) | Prerequisites, step-by-step installation, hook verification, daily workflow, common failures | New developers, re-setup after machine change |
| **Rebuild** | [TO-RE-DO.md](TO-RE-DO.md) | Complete step-by-step guide to rebuild the framework from zero | Future maintainer, disaster recovery |
| **Narrative** | [STORY-BOARD.md](STORY-BOARD.md) | How the framework was built, why decisions were made, what didn't work | Anyone onboarding to the project |
| **Operations** | [WORKING-MODEL.md](WORKING-MODEL.md) | Plain-English usage guide: what it is, who uses it, daily workflows, expected outcomes | End users, new team members |
| **FAQ** | [QUESTIONS-BANK.md](QUESTIONS-BANK.md) | 25 Q&A pairs: installation, understanding, configuration, usage, troubleshooting, contributing | First-time users, anyone hitting a problem |
| **Help** | [SUPPORT.md](SUPPORT.md) | Self-service order, bug report format, feature request process, security disclosure | All users |
| **Map** | [STRUCTURE.md](STRUCTURE.md) | Full directory tree, file purposes, what to touch for which task, what never to edit | New developers, anyone debugging file-level issues |
| **Standards** | [BEST-PRACTICES.md](BEST-PRACTICES.md) | 3 tutorials, 5 how-to guides, full reference tables, conceptual explanations (Diataxis) | Contributors, power users |

---

## "I need to..." Quick Lookup

| Situation | Go To |
|---|---|
| First time here, just want to understand what this is | README.md |
| Setting up for the first time | DEVELOPMENT.md |
| Something is broken and I don't know why | QUESTIONS-BANK.md → Troubleshooting section |
| Hooks aren't firing | DEVELOPMENT.md → "Verifying Hooks Are Active" |
| I want to add a new skill | BEST-PRACTICES.md → "How to Add a New Skill" |
| I need to understand the memory system | WORKING-MODEL.md or ARCHITECTURE.md |
| I want to rebuild this from scratch | TO-RE-DO.md |
| I want to know the history of why something was built this way | STORY-BOARD.md |
| I need to apply this to a new project | BEST-PRACTICES.md → Tutorial 3 |
| I want to know what every directory does | STRUCTURE.md |
| I want to know the complete skill invocation list | API.md → Skill Invocation Interface |
| I need to understand why the 5-phase protocol matters | BEST-PRACTICES.md → Explanation section |
| I want to report a bug | SUPPORT.md |
| I want to understand the data schema of a framework file | DATA-MODEL.md |
| I want to understand how the whole system fits together | ARCHITECTURE.md |

---

## In-Repo Documentation (Pre-Existing)

These files exist in the repository root and contain the framework's own documentation, written by the framework author:

| File | Purpose |
|---|---|
| [FRAMEWORK-MECHANICS.md](../FRAMEWORK-MECHANICS.md) | Verified technical breakdown of what actually runs vs. what requires discipline |
| [FRAMEWORK-REBUILD-GUIDE.md](../FRAMEWORK-REBUILD-GUIDE.md) | Author's own rebuild reference |
| [BEGINNERS-GUIDE.md](../BEGINNERS-GUIDE.md) | Entry-level introduction for first-time Claude Code users |
| [CLAUDE-TEMPLATE.md](../CLAUDE-TEMPLATE.md) | Copy-paste CLAUDE.md starter |
| [PROFILE.md](../PROFILE.md) | Active developer profile (currently: Arogya Reddy) |
| [SCRATCHPAD.md](../SCRATCHPAD.md) | Live session state — updated by every /wrap |
| [DECISIONS.md](../DECISIONS.md) | Permanent decision log |
| [SESSIONS.md](../SESSIONS.md) | Audit trail — one row per session |

---

## Files Most Likely to Need Expansion

Based on the repository's current state, these three documents have the highest gap between current coverage and what would benefit users most:

1. **`BEST-PRACTICES.md` → Tutorial section** — a tutorial for the batch skill (parallel multi-agent orchestration) would be valuable as that capability matures. It's the most powerful and least-documented feature.

2. **`STRUCTURE.md` → `.claude/skills/` content** — the four framework-repo-only skills (`simplify`, `batch`, `code-run-faster`, `problem-solver`) are listed but not documented with the same detail as the 17 template skills. Each deserves a reference entry.

3. **`API.md` → Output contract examples** — the seven output contract types (audit, cleanup, conversion, code edit, error, analysis, change-manifest) each have a format specification in CLAUDE.md but no worked examples in the API docs. Real output examples would make the spec much clearer for new users calibrating Claude's responses.

---

*Documentation suite generated March 2026. Claude Code Master Framework — github.com/ArogyaReddy/claude-framework*
