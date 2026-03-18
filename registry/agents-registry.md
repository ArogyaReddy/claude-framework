# Agents Registry

> Agents are specialized autonomous Claude instances that handle complex, multi-step tasks.
> They run as separate sub-processes with specialized tool access and return comprehensive reports.

---

## Quick Index

| Agent | File | Category | When to Use | Priority |
|---|---|---|---|---|
| code-architecture-reviewer | .claude/agents/code-architecture-reviewer.md | quality | After features, before merges | HIGH |
| documentation-architect | .claude/agents/documentation-architect.md | documentation | Creating comprehensive docs | HIGH |
| plan-reviewer | .claude/agents/plan-reviewer.md | planning | Review plans before implementation | HIGH |
| code-refactor-master | .claude/agents/code-refactor-master.md | refactoring | Comprehensive refactoring tasks | HIGH |
| refactor-planner | .claude/agents/refactor-planner.md | planning | Strategic refactoring planning | HIGH |
| web-research-specialist | .claude/agents/web-research-specialist.md | research | Autonomous web research | MEDIUM |

---

## Detail Entries

### code-architecture-reviewer
- **File:** .claude/agents/code-architecture-reviewer.md
- **Category:** quality
- **Purpose:** Review code for architectural consistency and best practices
- **When to use:**
  - After implementing a new feature
  - Before merging significant changes
  - When refactoring code
  - To validate architectural decisions
- **Integration:** ✅ Copy as-is to any project
- **Priority:** HIGH
- **Dependencies:** none

---

### documentation-architect
- **File:** .claude/agents/documentation-architect.md
- **Category:** documentation
- **Purpose:** Create comprehensive documentation for code, features, or systems
- **When to use:**
  - Need world-class developer documentation
  - Creating API documentation
  - Documenting architecture decisions
  - Building onboarding guides
- **Integration:** ✅ Copy as-is to any project
- **Priority:** HIGH
- **Dependencies:** none

---

### plan-reviewer
- **File:** .claude/agents/plan-reviewer.md
- **Category:** planning
- **Purpose:** Review implementation plans for completeness, risks, and alternatives
- **When to use:**
  - Before implementing high-stakes changes
  - When plan needs thorough review
  - For authentication integrations
  - Database migrations
  - API integrations
- **Integration:** ✅ Copy as-is to any project
- **Priority:** HIGH
- **Dependencies:** none

---

### code-refactor-master
- **File:** .claude/agents/code-refactor-master.md
- **Category:** refactoring
- **Purpose:** Plan and execute comprehensive refactoring tasks
- **When to use:**
  - Reorganizing file structures
  - Breaking down large components
  - Updating import paths after moves
  - Improving code maintainability
  - Large-scale code restructuring
- **Integration:** ✅ Copy as-is to any project
- **Priority:** HIGH
- **Dependencies:** none

---

### refactor-planner
- **File:** .claude/agents/refactor-planner.md
- **Category:** planning
- **Purpose:** Strategic refactoring planning before execution
- **When to use:**
  - Need to plan refactoring before execution
  - Multiple refactoring approaches possible
  - Want to assess risks before refactoring
  - Complements code-refactor-master
- **Integration:** ✅ Copy as-is to any project
- **Priority:** HIGH
- **Dependencies:** Works well with code-refactor-master agent

---

### web-research-specialist
- **File:** .claude/agents/web-research-specialist.md
- **Category:** research
- **Purpose:** Autonomous web research on technologies, patterns, or solutions
- **When to use:**
  - Need to research technologies or libraries
  - Comparing multiple solutions
  - Finding best practices for new patterns
  - Investigating error messages or issues
- **Integration:** ✅ Copy as-is to any project
- **Priority:** MEDIUM
- **Dependencies:** none

---

## Usage Notes

**How agents differ from skills:**
- **Skills:** Provide inline guidance, activated by keywords/patterns
- **Agents:** Run as separate sub-tasks, work autonomously, return reports

**Invoking agents:**
- Agents are invoked via the Agent tool by the main Claude instance
- They have their own specialized tool access
- They return comprehensive reports when complete

**Integration:**
- All agents are standalone — just copy the `.md` file to `.claude/agents/` in any project
- No configuration needed
- Works immediately after copying

---

## Adding New Agents

When adding new agents to `.claude/agents/`:
1. Copy agent `.md` file to `.claude/agents/`
2. Update this registry with agent details
3. Test agent invocation
4. Document any dependencies or special requirements
