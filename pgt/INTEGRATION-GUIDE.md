# Integration Guide — pg v5.0 + Claude Code Framework

**How to integrate the Universal Prompt Generation Engine with your existing Claude Code framework for maximum productivity.**

---

## 📋 Overview

pg v5.0 has **built-in integration** with the Claude Code framework. It automatically:

✅ Reads `SESSION_LOG.md` for recent context
✅ Injects `.claude/history/decisions.md` architectural constraints
✅ Lists available `skills/` directory
✅ Respects `CLAUDE.md` project rules
✅ Detects `specs/` directory for spec-driven work

**Result:** Contextually-aware prompts without manual copy-paste.

---

## 🚀 Quick Setup (2 Minutes)

### Step 1: Copy pg to Your Framework

```bash
cd C:/AROG/Claude-Free/claude-framework

# Copy pg-v5.sh into your framework
cp pgt/pg-v5.sh ./pg

# Make executable
chmod +x pg
```

### Step 2: Test Integration

```bash
# Should auto-detect CLAUDE.md, SESSION_LOG.md, etc.
./pg --quick "add error logging to auth middleware"
```

**Expected output** (in generated prompt):

```
CONTEXT:
Env: Node.js/TypeScript | Repo: claude-framework | Branch: main | ✓ CLAUDE.md present

<session-history>
Recent context from SESSION_LOG.md:
[Last 50 lines of your session log]
</session-history>

<architectural-decisions>
DECISION-003: Use JWT with 15min access + 7day refresh
DECISION-005: All API errors return RFC 7807 problem+json
</architectural-decisions>

<available-skills>
You can invoke these skills: debug-first, scope-guard, session-closer, jsx-to-standalone-html
</available-skills>

NOTE: This project has CLAUDE.md — follow its rules.
```

---

## 📂 Framework Structure Detection

### What pg Auto-Detects

| File/Directory | What pg Does | When |
|----------------|--------------|------|
| `CLAUDE.md` | Adds "Follow CLAUDE.md rules" note | Always |
| `SESSION_LOG.md` | Injects last 50 lines as context | Layer 6 (Context) |
| `.claude/history/decisions.md` | Injects recent decisions | Layer 6 (Context) |
| `skills/*.md` | Lists available skills | Layer 6 (Context), Claude Code target only |
| `specs/*.md` | Suggests using `--spec` flag | Layer 1 (Boot) |
| `PROFILE.md` | Future: Will inject user preferences | v5.1 |

### Example Project Structure

```
claude-framework/
├── CLAUDE.md                    ← pg reads: "Follow these rules"
├── PROFILE.md                   ← pg reads: User preferences
├── SESSION_LOG.md               ← pg reads: Recent context (last 50 lines)
├── .claude/
│   └── history/
│       └── decisions.md         ← pg reads: Architectural decisions
├── skills/
│   ├── debug-first.md           ← pg lists: Available skills
│   ├── scope-guard.md
│   └── session-closer.md
├── specs/
│   └── payment-flow.md          ← pg suggests: Use --spec flag
└── pg                           ← Universal Prompt Generator
```

---

## 🔗 Integration Modes

### Mode 1: Standalone (pg in framework root)

**Best for:** Quick tasks, framework-wide prompts

```bash
cd claude-framework
./pg --quick "refactor session-closer skill"

# Auto-includes:
# - SESSION_LOG.md context
# - decisions.md constraints
# - Available skills list
```

### Mode 2: Project-Specific (pg per project)

**Best for:** Multiple projects using the framework

```bash
# Copy pg to each project
cp claude-framework/pg ~/my-app/pg
cd ~/my-app

# pg reads:
# - my-app/CLAUDE.md (project-specific rules)
# - my-app/SESSION_LOG.md
# - my-app/.claude/history/decisions.md
```

### Mode 3: Global (pg in PATH)

**Best for:** Use pg everywhere

```bash
# Add to PATH
sudo cp claude-framework/pg /usr/local/bin/pg

# Use from any directory
cd ~/my-app
pg --quick "task"

# Still reads local CLAUDE.md, SESSION_LOG.md if present
```

---

## 🎯 Workflow Integration

### Workflow 1: Start-of-Session

```bash
# 1. Read session resume
cat SESSION_LOG.md | tail -20

# 2. Generate prompt with context
pg --quick "continue work on payment webhook retry logic"

# pg automatically includes:
# - Last 50 lines of SESSION_LOG.md
# - Recent decisions from decisions.md
# - Available skills
```

### Workflow 2: Mid-Session (Using Skills)

```bash
# You need to use a skill
pg --quick "Use scope-guard skill to validate if adding rate limiting is in scope for payment feature"

# Prompt includes:
# "Available skills: debug-first, scope-guard, session-closer"
```

### Workflow 3: End-of-Session

```bash
# 1. Generate session-closer prompt
pg --template daily-email "Wrap up session: completed auth middleware, pending: add tests"

# 2. Run session-closer skill manually (or via prompt)
# Use session-closer skill.

# 3. SESSION_LOG.md updated → next session will have context
```

### Workflow 4: Spec-Driven Development

```bash
# specs/ directory detected

# 1. Generate implementation prompt
pg --template feature-from-spec --spec specs/payment-retry.md "implement exponential backoff retry"

# 2. Verify against spec later
pg --mode review --spec specs/payment-retry.md --include src/services/payment.js "verify spec compliance"
```

### Workflow 5: Decision Logging

```bash
# 1. Make architectural decision
pg --template architecture-decision "Choose error handling strategy: try-catch vs middleware"

# 2. After decision, log it
# Use decision-log skill to add to .claude/history/decisions.md

# 3. Future prompts auto-include this decision
pg --quick "implement error handling for webhook endpoint"
# Prompt will include: "DECISION-XYZ: Use middleware error handling pattern"
```

---

## 🔧 Configuration

### Custom Persona for Framework

Create framework-specific persona:

```bash
# ~/.prompt-vault/personas/claude-framework-expert.persona

NAME: Claude Framework Expert
ROLE: You are an expert in the Claude Code master framework. You understand CLAUDE.md rules, skills system, session management, and phase-based development. You follow framework patterns strictly.
TRAITS: framework-aware, CLAUDE.md-faithful, skill-invoker, session-conscious, spec-driven
AVOID: violating CLAUDE.md rules, ignoring available skills, forgetting session context
```

**Usage:**

```bash
# In deep mode, select this persona when prompted
pg --deep "refactor the skills system to add skill dependencies"
# → Select "claude-framework-expert" persona
```

### Custom Template for Framework Tasks

Create framework-specific template:

```bash
# ~/.prompt-vault/templates/framework-skill.template

<task>{{SEED}}</task>

<persona>
You are a Claude Framework Expert. You create skills following the framework's skill-rules.json patterns.
</persona>

<framework-context>
This is a Claude Code master framework project with:
- CLAUDE.md for project rules
- skills/ directory for reusable AI patterns
- SESSION_LOG.md for session continuity
- .claude/history/decisions.md for architectural constraints
</framework-context>

<skill-requirements>
1. Skill must have clear trigger pattern (keyword, intent, or file path)
2. Skill must use YAML frontmatter with name, description, category
3. Skill must output structured prompts (not prose)
4. Skill should be 100-500 lines
5. Skill must integrate with hooks if needed
</skill-requirements>

<hard-constraints>
- Follow framework naming conventions
- Add skill to skills-registry.md
- NO breaking changes to existing skills
- Mark [FRAMEWORK-VIOLATION] if request contradicts CLAUDE.md
</hard-constraints>

<output-format>
1. Skill file content (Markdown with YAML frontmatter)
2. Registry entry
3. Usage example
4. Test cases
</output-format>
```

**Usage:**

```bash
pg --template framework-skill "Create a new skill: code-quality-gate that runs before commits"
```

---

## 📊 Framework-Aware Features

### Feature 1: Session Context Injection

**How it works:**

```bash
# Layer 6 — Context Injection (pg-v5.sh:629-694)

if [[ -f "SESSION_LOG.md" ]]; then
  SESSION_CONTEXT=$(tail -50 SESSION_LOG.md 2>/dev/null || echo "")
  EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<session-history>\nRecent context from SESSION_LOG.md:\n${SESSION_CONTEXT}\n</session-history>"
fi
```

**What you get:**

```xml
<session-history>
Recent context from SESSION_LOG.md:
## Session: 2026-03-19 14:30

### Current Focus
- Implementing payment webhook retry logic
- Using exponential backoff pattern

### Completed This Session
- Added retry middleware to Express app
- Created RetryService class

### Resume Here
- Add tests for RetryService
- Update documentation
</session-history>
```

### Feature 2: Architectural Decisions Injection

**How it works:**

```bash
# Layer 6 — Context Injection (pg-v5.sh:651-659)

if [[ -f ".claude/history/decisions.md" ]]; then
  local recent_decisions
  recent_decisions=$(tail -100 .claude/history/decisions.md 2>/dev/null || echo "")
  EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<architectural-decisions>\nRecent decisions to consider:\n${recent_decisions}\n</architectural-decisions>"
fi
```

**What you get:**

```xml
<architectural-decisions>
Recent decisions to consider:
# DECISION-003: Error Handling Strategy
Date: 2026-03-15
Decision: Use middleware-based error handling, not try-catch in routes
Rationale: Centralized error handling, consistent responses
Status: ACTIVE

# DECISION-005: API Response Format
Date: 2026-03-16
Decision: All errors return RFC 7807 problem+json
Rationale: Industry standard, machine-readable
Status: ACTIVE
</architectural-decisions>
```

### Feature 3: Available Skills Listing

**How it works:**

```bash
# Layer 6 — Context Injection (pg-v5.sh:662-669)

if [[ "$TARGET" == "claude-code" && -d "skills" ]]; then
  local skills_list
  skills_list=$(find skills -name "*.md" 2>/dev/null | sed 's|skills/||g' | sed 's|.md||g' | head -10 | paste -sd ',' -)
  EXTRA_CONTEXT="${EXTRA_CONTEXT}\n\n<available-skills>\nYou can invoke these skills: ${skills_list}\n</available-skills>"
fi
```

**What you get:**

```xml
<available-skills>
You can invoke these skills: debug-first, scope-guard, session-closer, decision-log, jsx-to-standalone-html, code-review, gap-pattern-analyzer
</available-skills>
```

**Why this matters:** Claude knows which skills it can use → better prompts.

---

## 🎓 Training: Teaching Your Team

### Week 1: Introduction

**Day 1 (30 min):**
```bash
# Team training script

# 1. Show quick mode
./pg --quick "add logging to payment webhook"

# 2. Show framework integration
cat SESSION_LOG.md | tail -10
./pg --quick "continue payment work"
# → Point out: "See how it includes session context?"

# 3. Show template usage
./pg --template debug-root-cause "webhook fails intermittently"
```

**Day 2-5:** Each team member uses pg for at least 1 task/day.

### Week 2: Advanced Usage

**Day 8:**
```bash
# Show spec-driven workflow
./pg --template feature-from-spec --spec specs/api-v2.md "implement user roles endpoint"
```

**Day 9:**
```bash
# Show decision logging integration
./pg --template architecture-decision "Choose caching layer: Redis vs Memcached"
# → After decision, use decision-log skill
```

**Day 10:**
```bash
# Show chain mode for complex features
./pg --chain "Build complete authentication system with JWT refresh"
```

### Week 3: Customization

**Day 15:**
```bash
# Create team-specific template
vim ~/.prompt-vault/templates/api-endpoint.template
# → Team reviews and approves template

# Use it
./pg --template api-endpoint "POST /api/users endpoint with validation"
```

---

## 🐛 Troubleshooting Framework Integration

### Problem: "SESSION_LOG.md not being read"

**Check:**

```bash
# Verify file exists
ls -la SESSION_LOG.md

# Verify pg can read it
tail -50 SESSION_LOG.md

# Debug:
./pg --quick "test" 2>&1 | grep -i "session"
```

**Solution:** Ensure SESSION_LOG.md is in project root (where you run pg).

### Problem: "Skills not listed"

**Check:**

```bash
# Verify skills directory
ls -la skills/

# Verify target is claude-code
./pg --target claude-code --quick "test"
```

**Solution:** Skills are only listed when `--target claude-code` (not for `claude` or `copilot`).

### Problem: "Decisions not injected"

**Check:**

```bash
# Verify decisions file exists
ls -la .claude/history/decisions.md

# Verify it's readable
tail -100 .claude/history/decisions.md
```

**Solution:** Ensure `.claude/history/decisions.md` exists and is not empty.

### Problem: "CLAUDE.md rules not mentioned"

**Check:**

``bash
# Verify CLAUDE.md exists
ls -la CLAUDE.md

# Check prompt output
./pg --quick "test" | grep -i "CLAUDE.md"
```

**Solution:** CLAUDE.md note is only added for `--target claude-code`.

---

## 📈 Measuring Integration Success

### Metrics to Track

| Metric | Target | How to Measure |
|--------|--------|----------------|
| **Framework awareness** | 100% | Prompts mention CLAUDE.md rules |
| **Session context usage** | 80%+ | Prompts include SESSION_LOG.md |
| **Decision compliance** | 100% | No prompts contradict decisions.md |
| **Skill invocation** | 50%+ | Prompts reference available skills |

### Weekly Review

```bash
# 1. Check prompt history
pg --history

# 2. Verify framework integration
for prompt in ~/.prompt-vault/history/*.prompt; do
  if grep -q "CLAUDE.md" "$prompt"; then
    echo "✓ $(basename $prompt) — framework-aware"
  else
    echo "✗ $(basename $prompt) — missing framework context"
  fi
done

# 3. Review feedback log
pg --patterns | grep "Framework Integration"
```

---

## 🔮 Future Enhancements (Roadmap)

### v5.1 (Planned)

- **PROFILE.md integration**: Auto-inject user preferences
- **Skill dependency detection**: "This skill requires project-scan to run first"
- **Auto-resume**: `pg --resume` reads last SESSION_LOG.md entry and continues

### v5.2 (Planned)

- **Multi-project context**: pg reads SCRATCHPAD.md, DECISIONS.md, SESSIONS.md (full memory system)
- **Phase-aware prompts**: Auto-detect current phase (/plan, /spec, /chunk, /verify, /update)
- **Hook integration**: pg can trigger hooks directly

### v6.0 (Vision)

- **Bi-directional sync**: pg updates SESSION_LOG.md after prompt execution
- **Agent-like behavior**: pg monitors code changes, suggests prompts automatically
- **Template marketplace**: Share templates across teams/organizations

---

## 📞 Support & Community

### Getting Help

1. **Check ARCHITECTURE.md** — Deep technical details
2. **Check QUICKSTART.md** — Copy-paste examples
3. **Check this file** — Framework-specific integration
4. **Open GitHub issue** — Reproduction steps + logs

### Contributing Templates

Have a great framework-specific template? Share it!

```bash
# Submit your template
# 1. Create template file
vim ~/.prompt-vault/templates/my-pattern.template

# 2. Test it
./pg --template my-pattern "test task"

# 3. Submit PR with:
# - Template file
# - Documentation (when to use, example output)
# - Test cases
```

---

## ✅ Integration Checklist

Use this when setting up pg in a new project:

- [ ] Copy pg-v5.sh to project root
- [ ] Make executable (`chmod +x pg`)
- [ ] Verify CLAUDE.md exists
- [ ] Verify SESSION_LOG.md exists
- [ ] Verify .claude/history/decisions.md exists
- [ ] Verify skills/ directory exists
- [ ] Test quick mode: `./pg --quick "test"`
- [ ] Check prompt includes session context
- [ ] Check prompt includes decisions
- [ ] Check prompt lists available skills
- [ ] Add to .gitignore: `~/.prompt-vault/`  (if using shared vault)
- [ ] Train team (30-minute demo)
- [ ] Create team-specific templates
- [ ] Set up shell alias: `alias pgq='./pg --quick'`
- [ ] Document team workflow in CLAUDE.md

---

## 🎉 You're Ready!

**pg is now fully integrated with your Claude Code framework.**

**Next:**
- Use `./pg --quick` for daily tasks
- Let framework context enhance your prompts automatically
- Create team-specific templates
- Train your team

**Start now:** `./pg --quick "your first framework-integrated task"`

---

**Version:** 5.0
**Framework Compatibility:** Claude Code Master Framework v1.0+
**Last Updated:** 2026-03-19
**Status:** Production-ready
