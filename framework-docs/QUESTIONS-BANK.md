# QUESTIONS-BANK.md — 25 Q&A Pairs

---

## Getting Started

**Q: How do I install this framework?**
A: Clone the repo, run `.\setup.ps1` (Windows) or `./setup.sh` (Unix). The installer asks for your profile details, creates all required files, wires hooks into `~/.claude/settings.json`, and runs verification. Takes about 5 minutes.

---

**Q: Do I need to install it in every project?**
A: Not the full framework. The global CLAUDE.md (`~/.claude/CLAUDE.md`) applies everywhere automatically. For new projects, run `Use project-scan skill on .` then `Use framework-apply skill.` to install project-specific components (CLAUDE.md, .claudeignore, memory files, specs/).

---

**Q: How do I verify the framework is working correctly?**
A: Open Claude Code in any project and type `Use healthcheck skill.` It runs a 12-point diagnostic and returns PASS / WARN / FAIL for each component: CLAUDE.md present, PROFILE.md filled, SESSION_LOG.md exists, all 17 skills present, hooks registered, .claudeignore present, and more.

---

**Q: Is this Windows-only?**
A: No. Hook scripts are PowerShell `.ps1` files because the author works on Windows, but `setup.sh` provides equivalent Bash hooks for Unix/Mac. All markdown files and CLAUDE.md content are platform-agnostic.

---

## Understanding the Project

**Q: What problem does this solve?**
A: Three problems. First: Claude Code sessions are stateless — this framework adds file-based memory so Claude knows context on open. Second: token waste — `.claudeignore` and structured prompts cut per-session token cost by 40–60%. Third: safety — the hook scripts block dangerous commands at the app layer where Claude's behavioral drift can't reach.

---

**Q: How is this different from just writing a good CLAUDE.md file?**
A: A CLAUDE.md file is one component of this framework. The full framework adds: a memory system (3 files), a skill library (17 invocable behaviors), 3 hook scripts (app-layer safety), a 5-phase development protocol, a session management system (/resume, /wrap, /decide), and setup automation. A single CLAUDE.md gives you behavioral rules. The framework gives you a full operating layer.

---

**Q: Does Claude actually follow these rules, or is it just suggestions?**
A: CLAUDE.md rules behave like system instructions — Claude follows them the same way it follows its training. The rules are not suggestions; they are visible text that Claude actively reads and applies. The hooks add a second enforcement layer that operates below Claude's context entirely — those blocks are mechanical, not behavioral.

---

**Q: Does this cost more to use because of all the files Claude reads?**
A: No — it saves tokens overall. CLAUDE.md and PROFILE.md loaded automatically eliminate 300–2,000 tokens of re-explanation per session. Skills cost tokens only when invoked. `.claudeignore` prevents Claude from accidentally reading node_modules and other high-volume non-source content. The net effect is lower token consumption than unstructured use.

---

## Configuration

**Q: What environment variables do I need?**
A: None. The framework is entirely file-based. Your Claude Code CLI handles Anthropic API authentication separately. The framework reads and writes only local markdown files and shell scripts.

---

**Q: Can I use this without the hook scripts?**
A: Yes. The hooks are the second safety layer. CLAUDE.md rules are the first. Without hooks, Claude still follows the rules in CLAUDE.md — it just isn't mechanically blocked at the app layer if its context drifts. For low-risk projects, CLAUDE.md-only is fine. For agentic long-running sessions or anything touching production, wire the hooks.

---

**Q: Can I use this without the memory system?**
A: Yes, but you lose the main value proposition — cross-session continuity. If you only use Claude for isolated single-session tasks, the memory files are overhead without benefit. The skills, hooks, and CLAUDE.md output rules still provide value independently.

---

**Q: How do I customize CLAUDE.md for my project?**
A: Edit `./CLAUDE.md` in your project. Project rules override global (`~/.claude/CLAUDE.md`) rules where they conflict. Don't edit the global CLAUDE.md for project-specific things — those rules will bleed into every project you open.

---

**Q: What's the difference between `skills/` and `.claude/skills/`?**
A: `skills/` contains the framework template skills that get copied to new projects when you run `framework-apply`. `.claude/skills/` contains skills that only apply to this framework repository itself (batch, simplify, problem-solver, code-run-faster). When you apply the framework to a new project, only `skills/` is copied.

---

## Usage

**Q: How do I start a session correctly?**
A: Open Claude Code (`claude`) and type `/resume`. Claude reads SCRATCHPAD.md and DECISIONS.md, outputs a session brief (current focus, last decisions, pending tasks, next action), and waits for confirmation before starting work. Do not skip this — it costs ~600 tokens but saves 3,000–6,000 tokens of reconstruction.

---

**Q: How do I close a session correctly?**
A: Type `/wrap`. Claude writes SCRATCHPAD.md (current state), DECISIONS.md (any new decisions), and SESSIONS.md (one audit row). Then exit Claude Code. Never close without `/wrap` — there is no other way to preserve session context.

---

**Q: What's the difference between `Use scope-guard skill.` and just telling Claude what files to touch?**
A: scope-guard injects structured rules that cause Claude to trigger a SCOPE BLOCKER response if it attempts to edit any file not explicitly named in your prompt. Telling Claude "only edit auth.js" is a suggestion. scope-guard makes that instruction mechanical — Claude reports the violation and stops instead of proceeding.

---

**Q: When should I use `/decide` vs. waiting for `/wrap`?**
A: Use `/decide` immediately when you make any significant architectural decision mid-session. Don't wait for `/wrap`. By the time you close the session, the context of why you made the decision may be diluted or incorrect. DECISIONS.md entries written mid-session are always more accurate.

---

**Q: What does `/compact` do and when should I run it?**
A: `/compact` compresses the context window — it summarizes the conversation history to free up token space. Run it when your context meter hits approximately 60%, not 95%. By 90%+, Claude's quality has already degraded. The `pre-compact` hook saves a state snapshot before compressing so nothing important is lost.

---

**Q: How many skills can I have?**
A: No hard limit. The framework ships with 17. Adding more is as simple as writing a new markdown file in `skills/` and registering it in CLAUDE.md's Core Skills section. The cost is only paid when you invoke the skill — unused skills consume zero tokens.

---

## Troubleshooting

**Q: Claude isn't following my CLAUDE.md rules. What's wrong?**
A: Three common causes. (1) You have both a global and project CLAUDE.md and they conflict — check both files. (2) The rule is vague ("be concise" instead of "responses under 300 words"). Rewrite it with specifics. (3) Claude's context is very full and quality has degraded — run `/compact`.

---

**Q: Hooks aren't firing. How do I debug?**
A: Check `~/.claude/settings.json` — are the hook paths absolute? Do they use forward slashes (Windows paths with backslashes fail silently)? Open PowerShell and manually run the `.ps1` script to verify it executes without errors. On Windows, verify execution policy: `Get-ExecutionPolicy -Scope CurrentUser` should be `RemoteSigned` or `Unrestricted`.

---

**Q: SESSION_LOG.md isn't being updated at session end. Why?**
A: The session-closer skill only runs when you say "Close the session." or `/wrap` explicitly. Closing Claude Code without this command does not trigger any write. Make `/wrap` the last thing you type before closing.

---

**Q: The healthcheck shows WARN for a missing skill. How do I fix it?**
A: The skill file is either missing or not named correctly. Check `skills/` directory — compare what's there against the skills table in README.md. Missing files: copy from the framework root. Wrong name: rename to match the invocation phrase (e.g., `debug-first.md` for `Use debug-first skill.`).

---

## Contributing

**Q: How do I add a new skill?**
A: Create a markdown file in `skills/[skill-name].md`. Include: skill name, invocation phrase, agent flag (true/false), full behavioral instructions, output format, and any stop conditions. Register the skill in CLAUDE.md's Core Skills section. Run `Use healthcheck skill.` to verify it's recognized.

---

**Q: How do I run the tests?**
A: `npm test` for all tests, `npm run test:unit` for Vitest unit tests only. The framework's own correctness is verified via `Use healthcheck skill.` rather than automated tests — the skill does 12-point verification of all framework components. Playwright end-to-end tests are scaffolded but not yet written (contribution opportunity).
