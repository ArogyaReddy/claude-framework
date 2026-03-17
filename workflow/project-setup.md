# Project Setup Checklist

Run once at the start of every new project.
All additions are non-destructive — nothing existing is modified.

---

## Step 1 — Copy the Framework

```bash
# Copy this entire framework folder into your project root
cp -r claude-framework/. your-project/

# Verify what landed
ls -la | grep -E "CLAUDE|\.claude|skills|hooks|prompts|specs|workflow"
```

Expected output:
```
CLAUDE.md
.claudeignore
.claude/
skills/
hooks/
prompts/
specs/
workflow/
```

---

## Step 2 — Configure CLAUDE.md

Open `CLAUDE.md` and fill in the `[FILL IN]` sections:

```
[ ] Language/runtime (e.g. TypeScript, Node 20)
[ ] Framework (e.g. Express, Next.js, NestJS)
[ ] Test framework (e.g. Jest, Vitest)
[ ] Linter/formatter (e.g. ESLint + Prettier)
[ ] Error handler class name
[ ] Query builder / ORM name
[ ] File naming convention
[ ] Folder structure conventions
[ ] Any project-specific rules not already listed
```

### Optional: Split CLAUDE.md into Rule Files

For large projects, you can split CLAUDE.md into focused files under `.claude/rules/` — all are auto-loaded by Claude Code:

```
.claude/rules/
  output.md        ← output and format rules
  scope.md         ← scope and fence rules
  security.md      ← never-do rules
  conventions.md   ← code standards and naming
```

Each file works the same as CLAUDE.md — Claude loads all of them automatically. Keep CLAUDE.md as a short index pointing to the rule files, or remove it entirely once rules are split.

---

## Step 3 — Configure .claudeignore

Review `.claudeignore` and add project-specific entries:

```
[ ] Add any project-specific generated folders
[ ] Add any large data directories
[ ] Add any service directories Claude should never touch (e.g. legacy/)
[ ] Add any environment-specific files
[ ] Verify node_modules/ is listed (it always should be)
```

---

## Step 4 — Make Hooks Executable

```bash
chmod +x hooks/pre-tool-use.sh
chmod +x hooks/post-tool-use.sh
chmod +x hooks/pre-compact.sh
```

Verify hooks config is in place:
```bash
cat .claude/settings.json
```

### Optional: Project-Specific Hook Additions

Add these to the `PostToolUse` array in `.claude/settings.json` as needed:

**Auto-format on file write (Prettier):**
```json
{
  "matcher": "Write",
  "hooks": [{ "type": "command", "command": "prettier --write {filePath}" }]
}
```

**Run tests after TypeScript changes:**
```json
{
  "matcher": "Write",
  "hooks": [{ "type": "command", "command": "npm test -- {filePath}", "match": { "path": "src/**/*.ts" } }]
}
```

---

## Step 5 — Create First Spec (if starting a feature)

```bash
cp specs/_template.md specs/[your-feature-name].md
```

Fill in:
```
[ ] Problem statement
[ ] Goal (one sentence)
[ ] In scope / Out of scope
[ ] Behaviours
[ ] Files affected
[ ] Acceptance criteria
```

---

## Step 6 — Verify Logs Directory

```bash
mkdir -p .claude/logs
```

Add to `.gitignore`:
```
.claude/logs/
```

---

## Step 7 — First Session Sanity Check

Start Claude Code and run this prompt:

```
Read CLAUDE.md. Confirm you have loaded it by listing:
- The three most important output rules
- The two things you must never do
- Which skills are available
No other output.
```

Expected: Claude confirms the rules from your CLAUDE.md exactly.
If it paraphrases incorrectly → your CLAUDE.md needs to be more precise.

---

## Step 8 — Advanced: Parallel Sessions (Optional)

For complex work, run multiple Claude sessions on isolated branches using git worktrees — no conflicts, full parallelism:

```bash
# Session 1: Frontend work (main worktree)
cd ~/your-project && claude --add-dir src/components

# Session 2: Backend in a separate worktree
git worktree add ../your-project-api main
cd ../your-project-api && claude --add-dir src/api

# Session 3: Tests independently
git worktree add ../your-project-tests main
cd ../your-project-tests && claude --add-dir tests
```

Rules:
- Each worktree gets its own Claude session and its own context window
- Merge worktrees back to main branch when done
- Use `git worktree list` to see active worktrees
- Use `git worktree remove ../your-project-api` to clean up

---

## Folder Structure (Final)

```
your-project/
├── CLAUDE.md                    ← Master persistent instructions
├── .claudeignore                ← Token budget control
├── .claude/
│   ├── settings.json            ← Hook + permission configuration
│   ├── rules/                   ← Optional: split CLAUDE.md into focused files
│   │   ├── output.md
│   │   ├── scope.md
│   │   └── security.md
│   └── logs/                    ← Auto-generated session logs
├── skills/
│   ├── minimal-output.md
│   ├── debug-first.md
│   ├── scope-guard.md
│   ├── spec-to-task.md
│   ├── code-review.md
│   └── change-manifest.md
├── hooks/
│   ├── pre-tool-use.sh
│   ├── post-tool-use.sh
│   └── pre-compact.sh
├── prompts/
│   └── golden-prompts.md        ← Daily copy-paste reference
├── specs/
│   ├── _template.md
│   └── [your-features].md
└── workflow/
    ├── daily-checklist.md
    ├── token-discipline.md
    └── project-setup.md         ← This file
```
