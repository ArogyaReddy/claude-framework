# TO-RE-DO.md — Rebuild From Scratch

*You need to recreate this framework tomorrow. Here is everything you need. No other context required.*

---

## What This Project Is

A file-based operating layer for Claude Code. It has no server, no database, no build step. Its entire value is a set of markdown files (CLAUDE.md, skills, memory files) that Claude reads at session start and follows as behavioral rules. Add three hook scripts wired via `settings.json` for app-level safety enforcement, and you have the complete framework.

The problem it solves: Claude Code sessions are stateless by default. Without this framework, every session starts blank, costs you 500–2,000 tokens re-explaining context, and has no guardrails against scope creep, dangerous commands, or lost decisions. This framework eliminates all three problems.

The tech stack is Node 20 / React 18 / Vite for the optional UI components. The framework itself runs on PowerShell (Windows) or Bash (Unix) with zero npm dependencies.

---

## What You'll Need Before Starting

- [ ] Claude Code CLI installed and authenticated
- [ ] Node.js 20+ installed
- [ ] PowerShell 5.1+ (Windows) or Bash 4+ (Unix)
- [ ] A GitHub account (to push the framework)
- [ ] 45–60 minutes of focused time

---

## Step-by-Step Rebuild Guide

### Step 1: Create the directory structure

```bash
mkdir claude-framework && cd claude-framework
mkdir -p .claude/skills .claude/logs .claude/history
mkdir -p skills hooks workflow specs prompts templates registry
mkdir -p src docs dev pgt enhancements tools
```

**Why:** Claude Code looks for `.claude/` and `skills/` at specific paths. The top-level directories hold the human-facing framework components.

**Verify:** `ls -la` shows all directories created.

---

### Step 2: Write CLAUDE.md (the most critical file)

This is the file that loads into Claude's context on every session. It must contain:

1. **Stack declaration** — Node 20, React 18, Vite, Vitest, Playwright
2. **Session startup protocol** — read order: CLAUDE.md → PROFILE.md → SESSION_LOG.md → Active Specs
3. **Session closure trigger** — "close the session" → invoke session-closer skill
4. **Always-apply rules** — implement only what's asked, touch only named files, no installs, no refactors, no commits without explicit request
5. **Execution protocol** — analyze before editing, plan before multi-file changes, backup before destructive ops, validate after
6. **Output rules** — bullets over prose, file:line format, no preamble, no emojis, no narration of tool use
7. **Token efficiency protocol** — lead with result, bullet by default, avoid repetition
8. **Project conventions** — PascalCase components, lowercase utilities, src/ entry points
9. **Environment policy** — Windows-first, PowerShell hook paths, standalone HTML option
10. **Memory System block** — three-file schema: SCRATCHPAD / DECISIONS / SESSIONS + /resume, /wrap, /decide commands
11. **Phase Framework block** — 5-phase protocol: /plan → /spec → /chunk → /verify → /update

See `CLAUDE-TEMPLATE.md` in this repo for a copy-paste version.

**Verify:** Open Claude Code. Type: `What are your output rules?` Claude should list the rules from CLAUDE.md.

---

### Step 3: Write PROFILE.md

Fields to fill:
- Name, role, experience level
- Stack (daily tools)
- Team context and methodology
- Communication style (peer-to-peer? answer first? formal?)
- Decision patterns (simple over clever? edit over create?)
- Special notes (e.g., "GraphQL is the API layer, not REST")

**Verify:** Type: `How would you describe me as a developer?` Claude's description should match PROFILE.md contents.

---

### Step 4: Create the three memory files

```bash
# SCRATCHPAD.md
cat > SCRATCHPAD.md << 'EOF'
# SCRATCHPAD — Current Session State

## Current Focus
[Not started — first session pending]

## Resume Here
Run healthcheck to verify framework installation.

## Failed Attempts
[None yet]

## Open Questions
[None yet]
EOF

# DECISIONS.md
cat > DECISIONS.md << 'EOF'
# DECISIONS — Permanent Decision Log

[No decisions logged yet]
EOF

# SESSIONS.md
cat > SESSIONS.md << 'EOF'
# SESSIONS — Audit Trail

| Date | Summary | Status |
|---|---|---|
[No sessions yet]
EOF
```

---

### Step 5: Write the 17 skills

Each skill is a markdown file in `skills/`. Each must contain:
- Skill name and invocation phrase
- `agent: true` or `agent: false`
- Full behavioral instructions
- Output format specification
- Stop conditions (if any)

**Priority order to write first:** `debug-first`, `scope-guard`, `session-closer`, `minimal-output`, `healthcheck`.

The remaining 12 can follow. See `skills/` directory in this repo for complete implementations.

---

### Step 6: Write the three hook scripts

**`hooks/pre-tool-use.ps1`** — must:
- Block: `rm -rf`, `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`, `git push --force`, writes to `.env`, `npm install`, `pip install`, `yarn add`
- Log every tool event to `.claude/logs/tool-use.log`
- Return exit code 1 when blocking (this is what Claude Code checks)

**`hooks/post-tool-use.ps1`** — must:
- Log tool name, outcome, and file path to `tool-use.log` and `session-YYYY-MM-DD.log`
- Track Write/Edit file paths to `changes.log`
- Flag failed Bash commands

**`hooks/pre-compact.ps1`** — must:
- Save git status output
- Save list of files changed this session (from `changes.log`)
- Save last SESSION_LOG entry
- Write to `.claude/logs/pre-compact-state.md`

---

### Step 7: Register hooks in settings.json

```json
// ~/.claude/settings.json
{
  "hooks": {
    "pre-tool-use": "C:/path/to/claude-framework/hooks/pre-tool-use.ps1",
    "post-tool-use": "C:/path/to/claude-framework/hooks/post-tool-use.ps1",
    "pre-compact": "C:/path/to/claude-framework/hooks/pre-compact.ps1"
  }
}
```

**Critical:** Use absolute paths. Relative paths fail when Claude Code is opened from a different directory.

**Verify:** Run `Use healthcheck skill.` — all three hooks should show PASS.

---

### Step 8: Write .claudeignore

```
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
```

**Why:** Without this, Claude can accidentally read 50,000+ tokens of `node_modules/`. One wrong context read costs $0.50–$2.00 per session.

---

### Step 9: Write workflow files

Three files in `workflow/`:
1. `daily-checklist.md` — 5-phase task checklist developers run before every task
2. `token-discipline.md` — 10 ranked rules for minimal token cost (with bad/good examples)
3. `project-setup.md` — one-time setup instructions per new project

---

### Step 10: Write the setup scripts

**`setup.ps1`** (Windows) must:
- Prompt for PROFILE.md fields
- Create all directories
- Copy files to correct locations
- Write hook paths to `~/.claude/settings.json`
- Run healthcheck
- Be idempotent (safe to re-run)

**`setup.sh`** (Unix) — same logic in Bash.

---

## The Tricky Parts

**Hook absolute paths.** The most common failure. If hooks are registered with relative paths, they silently fail when Claude Code is opened from any directory other than the framework root. Always use absolute paths in `settings.json`.

**Session closer discipline.** The entire memory system depends on one habit: typing "Close the session." or `/wrap` before exiting. There is no technical enforcement possible here. It must become reflexive.

**Global vs. project CLAUDE.md.** Rules in `~/.claude/CLAUDE.md` apply everywhere. Rules in `./CLAUDE.md` apply only here. If you put project-specific rules in global, every project gets them. Easy to do by accident.

**Skill agent flag.** Skills with `agent: true` spawn a subagent — they protect your main context window. Skills with `agent: false` inject directly. Use `agent: true` for skills that read many files (project-scan, code-review). Use `agent: false` for lightweight instruction sets. Getting this wrong won't break things but will inflate your context unnecessarily.

---

## What NOT to Do

- **Don't put sensitive data in PROFILE.md or CLAUDE.md.** These files are read into Claude's context and may appear in logs.
- **Don't auto-load all skills at session start.** Each skill file costs 200–800 tokens to load. Loading all 17 at startup wastes 3,000–5,000 tokens before you've done anything.
- **Don't use `/compact` at 95% context.** By then, Claude's quality has already degraded. Run it at 60%.
- **Don't skip `/plan` for multi-file features.** "I'll remember the plan" is not a spec, and Claude won't.
- **Don't write vague rules in CLAUDE.md.** "Be concise" gets interpreted loosely. "Responses under 300 words unless asked" is enforced.

---

## Time Estimate

| Phase | Time |
|---|---|
| Directory structure + CLAUDE.md + PROFILE.md | 60 minutes |
| Three memory files | 10 minutes |
| 5 priority skills | 90 minutes |
| Remaining 12 skills | 120 minutes |
| Three hook scripts | 60 minutes |
| Settings.json wiring + verification | 20 minutes |
| Workflow files | 30 minutes |
| Setup scripts | 45 minutes |
| **Total** | **~7 hours** |

The skills take the most time because quality matters — vague instructions produce inconsistent Claude behavior.
