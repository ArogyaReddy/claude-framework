# BEST-PRACTICES.md — Tutorials, How-To Guides, Reference & Explanation

*Structured using the Diataxis framework: Tutorial (learning by doing) → How-To (goal-oriented) → Reference (scannable facts) → Explanation (conceptual understanding).*

---

## Tutorials — Learn By Doing

### Tutorial 1: Your First Fully Managed Session

**Goal:** Complete one full session loop — open → work → close — with all framework components active.

**Assumes:** Framework is installed and healthcheck shows all PASS.

**Step 1 — Open Claude Code in your project**
```bash
cd /your-project && claude
```

**Step 2 — Start the session**
```
/resume
```
Expected output: Session Brief listing current focus, last decisions, and next action. On your very first session this will be sparse — that's normal.

**Step 3 — Scope your task**
```
Use scope-guard skill.
Add error handling to src/api/users.js — the fetchUser function only.
```
Claude will confirm the scope. If it attempts to touch any file other than `src/api/users.js`, it will trigger a SCOPE BLOCKER and stop.

**Step 4 — Do the work**
Ask Claude to make the change. Watch the output — it should be in file:line format with no preamble:
```
Changed:
- src/api/users.js:34 — Added try/catch around fetchUser call
- src/api/users.js:41 — Added error logging to catch block

Impact: fetchUser now returns null on network error instead of throwing
```

**Step 5 — Make a decision mid-work**
If during the task you and Claude decide something architectural (e.g., "we'll use null returns instead of throwing"), log it immediately:
```
/decide
```

**Step 6 — Close the session**
```
/wrap
```
Claude writes SCRATCHPAD.md and DECISIONS.md. Exit Claude Code.

**Step 7 — Verify the memory**
Open `SCRATCHPAD.md` in any text editor. It should contain today's work, the decision you logged, and the next step.

**Step 8 — Open tomorrow and prove it works**
```bash
claude
/resume
```
Claude outputs the session brief based on what it wrote yesterday. You're in the loop.

---

### Tutorial 2: Diagnose and Fix a Bug With Zero Guessing

**Goal:** Use the debug-first skill to produce a structured diagnosis before any code is changed.

**Step 1 — Invoke the skill first, describe the bug second**
```
Use debug-first skill.
The /api/users POST endpoint returns 403 for all requests including authenticated ones.
```

**Step 2 — Read Claude's output**
It must produce this structure before suggesting any fix:
```
EXPECTS: POST /api/users returns 201 with authenticated token
ACTUAL: Returns 403 for all POST requests, including valid tokens
CAUSE: [Claude's hypothesis — e.g., middleware auth check order]
FIX: [Specific change, specific file, specific line]
```

**Step 3 — Approve or redirect**
If the CAUSE is wrong, tell Claude. It will revise. No code has been written yet — this is intentional. You are debugging the hypothesis, not the code.

**Step 4 — Only after CAUSE is confirmed, allow the fix**
```
Confirmed. Apply the fix to src/middleware/auth.js only.
```

**Why this matters:** The most common agentic AI failure is writing a plausible-looking fix to the wrong problem. debug-first forces the diagnosis step before execution. It takes 60 more seconds and saves hours.

---

### Tutorial 3: Apply the Framework to a New Project

**Goal:** Install framework components into an existing project with no CLAUDE.md or skills.

**Step 1**
```bash
cd /path/to/existing-project && claude
```

**Step 2**
```
Use project-scan skill on .
```
Claude produces `PROJECT_SCAN.md` — a gap analysis listing every missing component.

**Step 3**
```
Use framework-apply skill.
```
Claude reads the scan report and installs: `CLAUDE.md` (project-specific), `.claudeignore`, memory files (`SCRATCHPAD.md`, `DECISIONS.md`, `SESSIONS.md`), and copies `skills/` directory.

**Step 4**
```
Use healthcheck skill.
```
All 12 points should show PASS. Fix any WARNs before starting real work.

---

## How-To Guides — Goal-Oriented

### How to Add a New Skill

**Prerequisites:** You have an invocation phrase in mind and know whether it should be `agent: true` or `agent: false`.

1. Create `skills/[your-skill-name].md`
2. Include these sections:
   - Skill name and one-line description
   - Invocation: `Use [name] skill.`
   - `agent: true` or `agent: false`
   - Full behavioral instructions (be specific — vague instructions produce inconsistent behavior)
   - Output format (show the exact structure Claude should produce)
   - Stop conditions (if Claude should pause and wait for input before proceeding)
3. Register it in `CLAUDE.md` → Core Skills section:
   ```
   * `skills/your-skill-name.md` — one-line description
   ```
4. Verify: `Use healthcheck skill.` — it should find the new skill and count it.

**Agent flag guidance:** Use `agent: false` for lightweight instruction injection (output format changes, behavioral constraints). Use `agent: true` for skills that read many files (code-review, project-scan) or produce independent output (spec-to-task). The `agent: true` skills protect your main context window by running in a subagent.

---

### How to Handle a Conflict Between Two CLAUDE.md Files

If a rule in `./CLAUDE.md` conflicts with `~/.claude/CLAUDE.md`, the project-level rule wins for that project. To resolve intentionally:

1. Identify the conflicting rule precisely (e.g., output format preference)
2. In `./CLAUDE.md`, write the override with a comment:
   ```
   ## Output Rules (Project Override — overrides global mono rule)
   * Prefer prose for explanations in this project
   ```
3. Leave the global rule unchanged — it applies to all other projects
4. Test: open Claude Code and ask it to describe its output format. It should cite the project rule.

---

### How to Recover From a Session With No /wrap

If you closed Claude Code without `/wrap`, the session context is gone — Claude's context was wiped. But you can partially reconstruct:

1. Open `SCRATCHPAD.md` — it contains the state from the previous successful `/wrap`
2. Check `.claude/logs/session-YYYY-MM-DD.log` — the post-tool-use hook logged every tool call, including file paths of every Write/Edit
3. Check `.claude/logs/changes.log` — lists files touched this session
4. Open a new Claude Code session and manually update SCRATCHPAD.md with what you know happened
5. Going forward: make `/wrap` the last thing you type. Always.

---

### How to Debug a Hook That Isn't Firing

1. Open `~/.claude/settings.json` in a text editor
2. Verify the hook path exists as an absolute path with forward slashes
3. Open PowerShell (Windows) and run the `.ps1` script directly:
   ```powershell
   & "C:/path/to/hooks/pre-tool-use.ps1"
   ```
4. Check the output — any error here is the failure mode
5. Common fixes:
   - Execution policy: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`
   - Path spaces: wrap in quotes in settings.json
   - Line endings: ensure `.ps1` files have Windows line endings if on Windows

---

### How to Reduce Token Costs for a Specific Project

1. **Audit your `.claudeignore`** — does it exclude `dist/`, `build/`, `coverage/`, `.git/`, and all `*.log` files? Each of these can add thousands of tokens if Claude reads them accidentally.
2. **Check your skills** — are you loading skills you're not using? Skills cost tokens only when invoked. If you're invoking `minimal-output skill` at session start, check if CLAUDE.md output rules already cover your needs without the skill.
3. **Run `/compact` earlier** — at 60% context, not 90%. Quality degrades before the meter is full.
4. **Use the 4-element prompt structure** — SCOPE + ACTION + FENCE + OUTPUT. Ambiguous prompts generate more back-and-forth. Each round-trip is 500–2,000 tokens.
5. **Use `agent: true` skills for file-heavy tasks** — subagents consume tokens in their own context, not yours.

---

## Reference

### Skill Invocations Quick Reference

| Skill | Invocation | Agent |
|---|---|---|
| debug-first | `Use debug-first skill.` | false |
| scope-guard | `Use scope-guard skill.` | false |
| code-review | `Use code-review skill on [file].` | true |
| spec-to-task | `Use spec-to-task skill on specs/[name].md` | true |
| change-manifest | `Use change-manifest skill.` | false |
| session-closer | `Use session-closer skill.` | false |
| minimal-output | `Use minimal-output skill.` | false |
| output-control | `Use output-control skill.` | false |
| structured-response | `Use structured-response skill.` | false |
| followup-refine | `Use followup-refine skill.` | false |
| safe-cleanup-with-backup | `Use safe-cleanup-with-backup skill.` | false |
| duplicate-structure-audit | `Use duplicate-structure-audit skill.` | true |
| jsx-to-standalone-html | `Use jsx-to-standalone-html skill.` | true |
| healthcheck | `Use healthcheck skill.` | true |
| decision-log | `Use decision-log skill.` | false |
| project-scan | `Use project-scan skill on [path].` | true |
| framework-apply | `Use framework-apply skill.` | true |

---

### Session Commands Quick Reference

| Command | When | What It Does |
|---|---|---|
| `/resume` | Session open | Reads memory files, outputs session brief |
| `/wrap` | Session close | Writes SCRATCHPAD, DECISIONS, SESSIONS |
| `/decide` | Mid-session | Logs one decision to DECISIONS.md immediately |
| `/plan` | Before multi-file feature | Architecture discussion, no code |
| `/spec` | After /plan | Writes specs/[name].md |
| `/chunk` | During build | Builds one scope-bounded set of changes |
| `/verify` | After /chunk | Claude interrogates its own output |
| `/update` | End of session | Improves CLAUDE.md with lessons learned |
| `/compact` | At ~60% context | Compresses conversation history |

---

### Blocked Commands Reference

These are blocked by `pre-tool-use.ps1` regardless of CLAUDE.md rules:

| Pattern | Reason Blocked |
|---|---|
| `rm -rf` | Recursive deletion without backup |
| `DROP TABLE`, `DROP DATABASE` | Destructive SQL — data loss |
| `TRUNCATE` | Destructive SQL — data loss |
| `git push --force` | Rewrites remote history |
| Write to `.env`, `.env.*` | Credential file exposure risk |
| `npm install`, `yarn add`, `pip install` | Unauthorized dependency changes |

---

### CLAUDE.md Required Sections Checklist

- [ ] Stack declaration (runtime, UI, build, language, test tools)
- [ ] Session Startup (read order: CLAUDE.md → PROFILE.md → SESSION_LOG.md → Active Specs)
- [ ] Session Closure trigger ("close the session" → session-closer skill)
- [ ] Always-Apply Rules (scope, file, dependency, refactor, commit constraints)
- [ ] Execution Protocol (plan → analyze → backup → validate)
- [ ] Output Rules (format, length, token efficiency, no preamble, no narration)
- [ ] Output Contracts (per-task-type format specifications)
- [ ] Project Conventions (naming, file organization)
- [ ] Environment Policy (OS, shell, standalone HTML option)
- [ ] Memory System block (/resume, /wrap, /decide + three-file schema)
- [ ] Phase Framework block (/plan, /spec, /chunk, /verify, /update rules)
- [ ] Core Skills (name → file mapping for all installed skills)

---

## Explanation — Conceptual Understanding

### Why File-Based Memory Works Better Than You'd Expect

The reaction most engineers have to "memory = markdown files written to disk" is skepticism. It sounds fragile. It sounds manual. It sounds like it would degrade. Here is why it actually outperforms the alternatives in practice.

First, **Claude writes its own session summaries from full context.** At `/wrap`, Claude reads the entire conversation — every decision, every change, every failure. It synthesizes that into a structured summary that captures the actual state, not a vague approximation. Compare that to a human writing their own notes at the end of a tired Friday: Claude's summaries are consistently more accurate and complete.

Second, **files don't hallucinate.** If DECISIONS.md says "we chose null returns over exceptions for the user API — decision DECISION-003," that is what it says. Claude reads it and reports it accurately. A vector-database-based memory system can retrieve semantically similar content that wasn't quite what you meant, and Claude can confabulate details around it. The file says what it says.

Third, **files are inspectable.** Open `SCRATCHPAD.md`. Read it. If something is wrong, fix it. You can't audit what's in a vector store without tooling. You can audit a markdown file in Notepad.

The weakness is real: no `/wrap` means no memory. But this is a discipline problem, not an architecture problem — and it's a discipline problem with an obvious, immediate consequence that trains the habit fast.

---

### Why the 5-Phase Protocol Matters for AI-Assisted Development

Without a phase protocol, AI-assisted development has a characteristic failure mode: Claude starts writing before the architecture is clear, produces code that looks correct but has fundamental structural issues, and then you spend more time fixing the structural issues than you would have spent planning. The code is fast to generate and slow to be right.

The 5-phase protocol forces a separation between thinking and typing. `/plan` is architecture only — Claude cannot write code during planning. `/spec` captures the plan in a file before any code exists. `/chunk` builds one bounded piece at a time, always followed by `/verify` before the next chunk. This is just good engineering discipline applied to AI pair programming, not a novel idea.

The insight that makes it work for AI specifically: Claude does not hold multi-session architectural intent in its head. If you plan on Monday and build on Tuesday without a spec file, Tuesday's Claude does not know Monday's plan. The spec file is not a document you write for yourself — it is the mechanism by which today's Claude knows what last session's Claude agreed to.

---

### How Claude's Context Window Limits What This Framework Can Guarantee

Everything in this framework — CLAUDE.md rules, skill instructions, memory file contents — is loaded into Claude's context window. The context window is finite. As a session progresses and the conversation grows, older content gets compressed or displaced.

This has two practical implications. First, rules stated in CLAUDE.md are most reliable early in a session, when they are still fully visible. As the context fills, their influence can diminish — which is why `/compact` at 60% (not 95%) is so important. Second, skill instructions injected mid-session have full effect immediately but become less dominant as the conversation grows. For long sessions involving skill-governed work, reinvoke the skill after compacting.

The framework does not claim to make Claude's behavior perfectly deterministic. It claims to make it reliably better — more consistent, more cost-efficient, and safer than unstructured use. That claim holds at reasonable session lengths with proper context management. At extreme session lengths without compacting, all bets are off.
