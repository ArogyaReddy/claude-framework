# Dev Docs Pattern

A methodology for maintaining project context across Claude Code sessions and context resets.

---

## The Problem

**Context resets lose everything:**
- Implementation decisions
- Key files and their purposes
- Task progress
- Technical constraints
- Why certain approaches were chosen

**After a reset, Claude has to rediscover everything.**

---

## The Solution: Persistent Dev Docs

A three-file structure that captures everything needed to resume work:

```
dev/active/[task-name]/
├── [task-name]-plan.md      # Strategic plan
├── [task-name]-context.md   # Key decisions & files
└── [task-name]-tasks.md     # Checklist format
```

**These files survive context resets** - Claude reads them to get back up to speed instantly.

---

## Quick Start

### Create Dev Docs
```
Use dev-docs skill for: [task description]
```

Example:
```
Use dev-docs skill for: refactor authentication system
```

### Update Before Stopping
```
Use dev-docs-update skill
```

Or use session-closer (which automatically calls dev-docs-update).

---

## File Structure

### 1. [task-name]-plan.md
**Purpose:** Strategic implementation plan (permanent)

**Contains:**
- Executive summary
- Implementation phases
- Detailed tasks with acceptance criteria
- Risk assessment
- Timeline estimates

**Update when:** Scope changes or new phases discovered

---

### 2. [task-name]-context.md
**Purpose:** Current session state (update frequently!)

**Contains:**
- **SESSION PROGRESS** (CRITICAL - update constantly!)
  - ✅ COMPLETED
  - 🟡 IN PROGRESS
  - ⚠️ BLOCKERS
- Key files and their purposes
- Architectural decisions made
- Technical constraints
- Quick resume instructions

**Update when:** After every major decision, completion, or blocker

---

### 3. [task-name]-tasks.md
**Purpose:** Progress checklist

**Contains:**
- Phases with status indicators (⏳/🟡/✅)
- Tasks in checkbox format `- [ ]`
- Acceptance criteria
- Dependencies

**Update when:** Complete or discover tasks

---

## Directory Structure

```
dev/
├── README.md (this file)
├── active/
│   ├── task-1/
│   │   ├── task-1-plan.md
│   │   ├── task-1-context.md
│   │   └── task-1-tasks.md
│   └── task-2/
│       └── ...
└── archive/ (completed tasks)
    └── old-task/
```

**active/**: Current work in progress
**archive/**: Completed tasks (for reference)

---

## When to Use Dev Docs

**Use for:**
- ✅ Complex multi-day tasks
- ✅ Features with many moving parts
- ✅ Work spanning multiple sessions
- ✅ Tasks requiring planning
- ✅ Large refactorings

**Skip for:**
- ❌ Simple bug fixes
- ❌ Single-file changes
- ❌ Quick updates
- ❌ Trivial modifications

**Rule of thumb:** If >2 hours or multiple sessions → use dev-docs

---

## Workflow Example

### Day 1: Start Task
```
You: "Use dev-docs skill for: implement real-time notifications"

Claude:
1. Analyzes requirements
2. Examines codebase
3. Creates plan, context, tasks files
4. Writes to: dev/active/implement-real-time-notifications/

You start implementing...
```

### Day 1: End Session
```
You: "Use dev-docs-update skill"

Claude:
1. Updates SESSION PROGRESS with completed work
2. Marks completed tasks ✅
3. Documents current file:line
4. Captures decisions made
5. Notes blockers discovered
```

### Day 2: Resume
```
Claude (automatically):
1. Reads plan.md (overall strategy)
2. Reads context.md (current state)
3. Reads tasks.md (what's done/pending)
4. Resumes from exact stopping point

No re-explanation needed!
```

---

## Critical: SESSION PROGRESS

**Update constantly** - this is your resume point!

```markdown
## SESSION PROGRESS (2025-03-17 14:30)

### ✅ COMPLETED THIS SESSION
- WebSocket server setup (src/ws-server.ts)
- Redis pub/sub configured
- Database notifications table created

### 🟡 IN PROGRESS RIGHT NOW
- Implementing notification delivery service
- File: src/services/notificationService.ts:45
- Next: Add retry logic for failed deliveries

### ⚠️ BLOCKERS
- Decision needed: Store notifications in DB vs Redis
- Redis memory limit in production (512MB)

### 📝 NOTES FOR NEXT SESSION
- WebSocket connection stable in testing
- Considered socket.io but overhead too high
- Must test notification fanout at scale
```

---

## Benefits

**Before dev-docs:**
- Context reset = start over
- Forget decisions
- Lose progress tracking
- Repeat work

**After dev-docs:**
- Context reset = read 3 files, resume instantly
- Decisions documented
- Progress tracked
- No repeated work

**Time saved:** Hours per context reset

---

## Related Skills

- **dev-docs**: Create initial 3-file structure
- **dev-docs-update**: Update before session end or context reset
- **session-closer**: Automatically calls dev-docs-update
- **spec-to-task**: Convert spec → dev-docs plan
- **decision-log**: Log important decisions (also goes in context.md)

---

## Example Output Location

When you use dev-docs skill, files are created in:
```
C:/AROG/Claude-Free/claude-framework/dev/active/[your-task-name]/
```

---

**Questions?** See the dev-docs.md and dev-docs-update.md skill files in the skills/ directory.
