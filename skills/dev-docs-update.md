---
name: dev-docs-update
description: Update dev documentation before context compaction or session end. Updates SESSION PROGRESS, marks completed tasks, captures decisions made, and documents current state for seamless continuation.
---

# Dev-Docs-Update: Session State Capture

## Purpose

Update dev-docs files before:
- Context compaction (approaching token limit)
- Session end (finishing for the day)
- Major milestone completion
- Context reset (switching conversations)

Ensures seamless continuation by capturing current state.

---

## When to Use

**Trigger moments:**
- Approaching context limits (>150k tokens)
- Ending work session for the day
- Completed major milestone/phase
- About to switch to different conversation
- Just before creating git commit for complex feature

**User says:**
- "Update dev docs"
- "Close session" (triggers session-closer which calls this)
- "Save progress"
- "Approaching context limit"

---

## What This Skill Does

### 1. **Update Context Files**

For each task in `dev/active/`:

**Update [task-name]-context.md:**
- Refresh SESSION PROGRESS section
  - Mark completed work as ✅
  - Update in-progress items with current state
  - Add new blockers discovered
  - Add timestamp
- Add new key files discovered
- Document decisions made this session
- Update technical constraints
- Refresh quick resume instructions

### 2. **Update Task Checklists**

**Update [task-name]-tasks.md:**
- Mark completed tasks: `- [x]` with ✅
- Update in-progress tasks with status notes
- Add new tasks discovered during work
- Reorder priorities if needed
- Update phase status (⏳ → 🟡 → ✅)

### 3. **Capture Session Knowledge**

Document:
- Complex problems solved
- Architectural decisions made
- Tricky bugs found and fixed
- Integration points discovered
- Testing approaches used
- Performance optimizations made

### 4. **Document Unfinished Work**

Record:
- What was being worked on when stopped
- Exact state of partially completed features
- Exact file and line being edited
- Commands to run on resume
- Temporary workarounds needing permanent fixes

### 5. **Create Handoff Notes**

If switching conversations:
- Exact location in code (file:line)
- Goal of current changes
- Uncommitted changes that need attention
- Test commands to verify work
- Next immediate steps

---

## Execution Protocol

### Step 1: Scan Active Tasks

```bash
ls dev/active/
```

Identify all active tasks with dev-docs.

### Step 2: For Each Active Task

Read:
- [task-name]-plan.md (understand overall plan)
- [task-name]-context.md (current state)
- [task-name]-tasks.md (task list)

### Step 3: Determine Session Changes

Analyze:
- Which files were edited this session
- Which tasks were completed
- Which decisions were made
- What blockers were discovered
- What's currently in-progress

Use `.claude/history/sessions/[session-id]/files-list.txt` if available.

### Step 4: Update SESSION PROGRESS

**Template:**
```markdown
## SESSION PROGRESS (YYYY-MM-DD HH:MM)

### ✅ COMPLETED THIS SESSION
- [List everything completed]
- [Include file paths and what changed]
- [Mark decisions made]

### 🟡 IN PROGRESS RIGHT NOW
- [What you're actively working on]
- [Exact file and line]
- [Next immediate step]

### ⚠️ BLOCKERS / ISSUES
- [What's preventing progress]
- [Decisions needed]
- [External dependencies]

### 📝 NOTES FOR NEXT SESSION
- [Things to remember]
- [Alternative approaches considered]
- [Things to avoid]
```

### Step 5: Update Task Checklist

Mark completed tasks:
```markdown
## Phase 1: Setup ✅ COMPLETE
- [x] Create database schema ✅ Done 2025-03-17
- [x] Set up controllers ✅ Done 2025-03-17

## Phase 2: Implementation 🟡 IN PROGRESS
- [x] Create PostController ✅ Done 2025-03-17
- [ ] Create PostService (IN PROGRESS - 60% complete)
      Next: Add caching layer
      File: src/services/postService.ts:45
- [ ] Create PostRepository (pending)
```

### Step 6: Capture Important Context

Add to context.md if discovered:

**New Architectural Decisions:**
```markdown
### Decision 3: Cache Strategy (2025-03-17)
**Context:** Posts query was slow (2s response time)
**Decision:** Use Redis with 5-minute TTL
**Rationale:** In-memory too memory-intensive, Redis gives persistence
**Alternatives Considered:**
- In-memory cache (rejected - memory limits)
- Database query optimization (tried - still too slow)
```

**New Technical Constraints:**
```markdown
- Redis max memory: 512MB (production limit)
- Must handle cache misses gracefully
- Cache invalidation on post update/delete
```

### Step 7: Document Unfinished Work Clearly

```markdown
## RESUME POINT (2025-03-17 14:30)

**Currently editing:** src/services/postService.ts:45
**Goal:** Implement Redis caching for getPosts()
**Progress:**
- ✅ Redis client initialized
- ✅ Cache key structure defined
- 🟡 IN PROGRESS: Writing cache-aside pattern
- ⏳ TODO: Add cache invalidation

**To continue:**
1. Open src/services/postService.ts:45
2. Complete the cachePost() method
3. Add cache invalidation in updatePost() and deletePost()
4. Test cache hit/miss scenarios
5. Update tests in tests/postService.test.ts

**Uncommitted changes:**
- src/services/postService.ts (cache implementation)
- src/config/redis.ts (new file)

**Commands to run after resume:**
```bash
npm test -- postService.test.ts
npm run dev  # Test cache in action
```
```

### Step 8: Save All Updates

Write updated files:
- [task-name]-context.md (with new SESSION PROGRESS)
- [task-name]-tasks.md (with checked tasks)

### Step 9: Report Summary

Output:
```text
📝 DEV-DOCS UPDATED

Tasks updated: 2
- refactor-auth-system
- add-notifications

Session progress captured:
✅ 8 tasks completed
🟡 2 tasks in progress
⚠️ 1 blocker documented

Resumption status: READY
Next session can continue from exact stopping point
```

---

## Context Update Checklist

Before finishing update, verify:

- [ ] SESSION PROGRESS has today's date
- [ ] All completed work marked ✅
- [ ] Current in-progress item clearly stated
- [ ] Exact file and line documented
- [ ] Blockers/decisions needed captured
- [ ] Task checklist has [x] for completed
- [ ] New tasks added if discovered
- [ ] Architectural decisions documented
- [ ] Technical constraints updated
- [ ] Quick resume instructions accurate
- [ ] Uncommitted changes noted
- [ ] Test commands provided

---

## Integration with Other Skills

**Call from:**
- **session-closer**: Always runs dev-docs-update before closing
- **Manual**: User says "update dev docs" when stopping work

**Works with:**
- **decision-log**: Major decisions go in both places
- **change-manifest**: What changed per session
- **scope-guard**: Documents scope expansions

---

## Special Cases

### Approaching Context Limit

**Priority:** Capture ONLY critical information
- Current file:line
- Next immediate step
- Critical decisions
- Skip: Nice-to-have details, long explanations

### No Active Dev-Docs

If no `dev/active/` directory found:
```text
ℹ️ NO ACTIVE DEV-DOCS

No dev-docs found to update.

Create dev-docs with:
  Use dev-docs skill for: [task description]

Or document session with:
  Use session-closer skill
```

### Multiple Active Tasks

Update ALL active tasks found in `dev/active/`.
Prioritize the task most worked on this session.

---

## Example: Before/After

### BEFORE (Stale context.md)
```markdown
## SESSION PROGRESS (2025-03-16)

### ✅ COMPLETED
- Database schema created

### 🟡 IN PROGRESS
- Creating controllers

### ⚠️ BLOCKERS
- None
```

### AFTER (Updated context.md)
```markdown
## SESSION PROGRESS (2025-03-17 14:30)

### ✅ COMPLETED THIS SESSION
- PostController implemented (src/controllers/PostController.ts)
- Redis integration added (src/config/redis.ts)
- Sentry error tracking configured
- Unit tests passing (tests/postController.test.ts)

### 🟡 IN PROGRESS RIGHT NOW
- Implementing cache-aside pattern in PostService
- File: src/services/postService.ts:45
- Next: Complete cachePost() method and add invalidation

### ⚠️ BLOCKERS / ISSUES
- Decision needed: Cache TTL (5min vs 10min for post data)
- Redis memory limit in production (512MB max)

### 📝 NOTES FOR NEXT SESSION
- Cache hit rate good in local testing (85%)
- Considered GraphQL DataLoader but overhead too high
- Must test cache invalidation thoroughly before deploy
```

---

**Status:** Following progressive disclosure pattern ✅
**Line Count:** < 400 lines
**Companion to:** dev-docs.md skill
