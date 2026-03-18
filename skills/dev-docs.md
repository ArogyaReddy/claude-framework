---
name: dev-docs
description: Create comprehensive strategic plan with structured task breakdown for complex multi-session features. Use for refactoring, new features, or any work spanning multiple sessions. Creates three files (plan, context, tasks) that survive context resets.
---

# Dev-Docs: Strategic Planning Skill

## Purpose

Create a persistent 3-file documentation structure for complex tasks that:
- Survives context resets
- Enables instant session resumption
- Tracks progress across multiple days
- Documents decisions and context

## When to Use

**Use dev-docs for:**
- ✅ Complex multi-day tasks
- ✅ Features with many moving parts
- ✅ Tasks likely to span multiple sessions
- ✅ Work requiring careful planning
- ✅ Refactoring large systems

**Skip dev-docs for:**
- ❌ Simple bug fixes
- ❌ Single-file changes
- ❌ Quick updates
- ❌ Trivial modifications

**Rule of thumb:** If it takes >2 hours or spans multiple sessions, use dev-docs.

---

## The Three-File Structure

### 1. [task-name]-plan.md
**Purpose:** Strategic implementation plan (permanent reference)

**Contains:**
- Executive summary
- Current state analysis
- Proposed future state
- Implementation phases
- Detailed tasks with acceptance criteria
- Risk assessment
- Success metrics
- Timeline estimates

**When to create:** Start of task
**When to update:** When scope changes or new phases discovered

---

### 2. [task-name]-context.md
**Purpose:** Session state and key information (frequently updated)

**Contains:**
- **SESSION PROGRESS** section (CRITICAL - update constantly!)
- What's completed vs in-progress
- Key files and their purposes
- Important decisions made
- Technical constraints discovered
- Links to related files
- Quick resume instructions

**When to create:** Start of task
**When to update:** **FREQUENTLY** - after every major decision, completion, or discovery

---

### 3. [task-name]-tasks.md
**Purpose:** Checklist for tracking progress

**Contains:**
- Phases broken down by logical sections
- Tasks in checkbox format
- Status indicators (✅/🟡/⏳)
- Acceptance criteria
- Dependencies

**When to create:** Start of task
**When to update:** After completing or discovering tasks

---

## Usage Instructions

### Creating Dev Docs

```text
Use dev-docs skill for: [task description]

Example: "Use dev-docs skill for: refactor authentication system"
```

**Claude will:**
1. Analyze the request and determine scope
2. Examine relevant files in codebase
3. Create comprehensive plan
4. Generate context file with key information
5. Create task checklist
6. Write all three files to: `dev/active/[task-name]/`

---

## Execution Protocol

### Step 1: Analyze Request

Understand:
- What needs to be built/refactored/fixed
- Current state of the system
- Constraints and requirements
- Success criteria

### Step 2: Research Codebase

Examine:
- Relevant existing files
- Current patterns and conventions
- Dependencies and integrations
- Potential risks and blockers

### Step 3: Create Strategic Plan

Structure:
- **Executive Summary**: What and why (1 paragraph)
- **Current State**: Where we are now
- **Future State**: Where we're going
- **Implementation Phases**: Major sections of work
- **Detailed Tasks**: Actionable items with clear acceptance criteria
- **Risk Assessment**: What could go wrong
- **Success Metrics**: How to know it's done
- **Timeline Estimates**: Realistic effort estimates (S/M/L/XL)

### Step 4: Generate Context File

Include:
- **SESSION PROGRESS** (empty initially, for updates)
- **Key Files**: List of important files with explanations
- **Architectural Decisions**: Major choices and rationale
- **Technical Constraints**: Limitations discovered
- **Quick Resume**: "To continue: [steps]"

### Step 5: Create Task Checklist

Format:
```markdown
## Phase 1: Setup ⏳ NOT STARTED
- [ ] Task 1.1: Description (Acceptance: criteria)
- [ ] Task 1.2: Description (Acceptance: criteria)

## Phase 2: Implementation ⏳ NOT STARTED
- [ ] Task 2.1: Description (Acceptance: criteria)
```

### Step 6: Write Files

Create directory: `dev/active/[task-name]/`

Write files:
- [task-name]-plan.md
- [task-name]-context.md
- [task-name]-tasks.md

Include "Last Updated: YYYY-MM-DD" in each file.

---

## Context File Template

```markdown
# [Task Name] - Context

Last Updated: YYYY-MM-DD

## SESSION PROGRESS

### ✅ COMPLETED
[Initially empty - update during work]

### 🟡 IN PROGRESS
[Currently working on]

### ⚠️ BLOCKERS
[Things preventing progress]

---

## Key Files

**src/path/to/file.ts**
- Purpose: [what this file does]
- Relevance: [why it matters for this task]
- Status: [to be modified / to be created / reference only]

---

## Architectural Decisions

### Decision 1: [Title]
**Context:** [Why this decision was needed]
**Decision:** [What we decided]
**Rationale:** [Why this is the best approach]
**Alternatives Considered:** [Other options and why rejected]

---

## Technical Constraints

- [Constraint 1]: [description and impact]
- [Constraint 2]: [description and impact]

---

## Quick Resume

To continue this task:
1. Read this file (context.md)
2. Check tasks.md for current progress
3. Continue with next uncompleted task
4. Update SESSION PROGRESS after significant work
```

---

## Critical: Updating During Work

### Update context.md SESSION PROGRESS constantly

**Bad:** Update only at end of session
**Good:** Update after each major milestone

**The SESSION PROGRESS section must always reflect reality:**
```markdown
## SESSION PROGRESS (YYYY-MM-DD)

### ✅ COMPLETED
- Database schema created (User, Post models)
- PostController implemented
- Sentry integration working

### 🟡 IN PROGRESS
- Creating PostService business logic
- File: src/services/postService.ts
- Next: Add caching layer

### ⚠️ BLOCKERS
- Need to decide: Redis vs in-memory cache
```

---

## After Context Reset

**What Claude will do:**
1. Read all three dev-docs files
2. Understand complete state in <1 minute
3. Resume exactly where you left off

**No need to re-explain** - it's all documented!

---

## Integration with Other Skills

**Use dev-docs WITH:**
- **spec-to-task**: Convert spec → dev-docs plan
- **scope-guard**: Each phase becomes a scope boundary
- **decision-log**: Important decisions go in context.md
- **session-closer**: Update context before session end

**Workflow:**
1. Start: Create dev-docs
2. During: Update context frequently, check off tasks
3. End: Use dev-docs-update skill to capture session state
4. Resume: Read dev-docs, continue

---

## Example Directory Structure

```
dev/
├── README.md (explains dev-docs pattern)
├── active/
│   ├── refactor-auth-system/
│   │   ├── refactor-auth-system-plan.md
│   │   ├── refactor-auth-system-context.md
│   │   └── refactor-auth-system-tasks.md
│   └── add-notifications/
│       ├── add-notifications-plan.md
│       ├── add-notifications-context.md
│       └── add-notifications-tasks.md
└── archive/ (optional - for completed tasks)
    └── old-task/
```

---

## Quality Standards

Plans must be:
- Self-contained with all necessary context
- Written in clear, actionable language
- Include specific technical details where relevant
- Consider both technical and business perspectives
- Account for potential risks and edge cases

Tasks must have:
- Clear acceptance criteria
- Explicit dependencies
- Effort estimates (S/M/L/XL)
- Specific file and function names where applicable

---

## Reference Documentation

Check these files if they exist:
- `PROJECT_KNOWLEDGE.md` - Architecture overview
- `BEST_PRACTICES.md` - Coding standards
- `TROUBLESHOOTING.md` - Common issues
- `CLAUDE.md` - Project conventions

---

**Status:** Following progressive disclosure pattern ✅
**Line Count:** < 400 lines
**Part of:** Phase 2 integration from showcase repo
