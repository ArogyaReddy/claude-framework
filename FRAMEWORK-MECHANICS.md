# Framework Mechanics — How Claude Really Works With This Framework

> **This document is the honest technical answer to: "Does Claude really follow this?"**
>
> Not documentation showing how things *should* work.
> This documents what is *actually* happening — verified by reading every file — as of March 2026.

---

## The Short Answer

**Yes, Claude really does follow this framework.** But not everything is automatic. There is a clear split:

| Category | What Is Here | Active? |
|---|---|---|
| Skills | 17 `.md` files with instructions | Yes — fires when invoked |
| Session startup protocol | In global CLAUDE.md | Yes — runs every session |
| SESSION_LOG.md memory | File exists with real content | Yes — read at session start |
| PROFILE.md identity | Fully filled — Arogya Reddy | Active — loaded every session |
| Hooks (safety layer) | 3 `.ps1` scripts written | **YES — wired globally, active in every session** |
| `.claudeignore` | Must exist per-project | Only where it has been created |
| Token discipline | Workflow reference doc | Human-facing — requires your habits |

Both gaps are now fixed — see Section 7.

---

## Section 1 — What Actually Happens Every Time You Open Claude Code

This is not how it "should" work. This is the verified sequence, step by step.

```
YOU open Claude Code in any project folder
        ↓
Claude Code (the app) looks for CLAUDE.md in project folder
        ↓
If found: loads it into Claude's context window
        ↓
Claude Code (the app) looks for ~/.claude/CLAUDE.md (global)
        ↓
Loads global CLAUDE.md into same context window
        ↓
The global CLAUDE.md contains this startup protocol:
  → Read local CLAUDE.md if it exists (done)
  → Read PROFILE.md if it exists
  → Read SESSION_LOG.md (most recent entry) if it exists
        ↓
Claude now has: project rules + your identity + session history
ALL visible at once. Before you type a single word.
        ↓
You type your first message
        ↓
Claude responds knowing everything already
```

**What Claude is actually doing:** Reading files. Not running programs. Not accessing a database. The "intelligence" is just text loaded into its working memory (context window) so Claude can see it and follow it.

---

## Section 2 — How CLAUDE.md Really Drives Claude

### The mechanism
Claude Code loads `CLAUDE.md` into Claude's context before your first message. Every rule becomes part of what Claude can "see" for the entire session.

### What this actually changes
Rules in CLAUDE.md are not suggestions. They behave like **system instructions** — Claude follows them the same way it follows its training.

When CLAUDE.md says:
```
- No preamble (no "Sure!", "Of course!", "Here is...")
- No closing summary
- Return only the modified function or file
```

Claude does not add preambles because it literally sees the rule telling it not to.

### What CLAUDE.md cannot do
- It cannot override Claude's safety training (Claude will still refuse genuinely harmful requests)
- It only applies for the session duration. It is re-read next session but Claude does not "learn" from it
- Vague rules get interpreted. `"Be concise"` is vague. `"Responses under 5 sentences unless asked"` is not.

### Two layers loaded together
```
Global CLAUDE.md (~/.claude/CLAUDE.md)     —  fires in EVERY project, always
          +
Project CLAUDE.md (./CLAUDE.md)            —  fires only in THIS project

Both in context at once. Project rules override global rules where they conflict.
```

---

## Section 3 — How SESSION_LOG.md Really Gives Claude "Memory"

### The common misconception
Claude does NOT have persistent memory. There is no database. Nothing is stored in Claude's model between sessions.

### What actually happens

```
Session 1:
  You work all day on HireFlow
  You say: "Close the session."
  Claude reads its context (the whole conversation)
  Claude writes SESSION_LOG.md to your project folder
  Session ends. Claude's context is wiped completely.

Session 2 (next morning):
  Claude Code opens → reads SESSION_LOG.md from disk
  Loads that text into Claude's new context window
  Claude now "knows" what happened yesterday
  — not because it remembered
  — because it read the file you saved
```

### The real consequence
**If you close Claude Code without saying "Close the session." — there is no continuity.**
The ledger is never written. Tomorrow's Claude starts completely blank.

### What SESSION_LOG.md contains (real example from this framework)
The actual file at `C:/AROG/Claude-Free/claude-framework/SESSION_LOG.md` contains:
```
== SESSION 2026-03-16 ==
Built: output-control skills framework architecture analysis
Decisions: [specific decisions logged]
Status: [exact state of work]
Next: [exact next steps]
```

This is what gets loaded tomorrow. Specific, accurate, actionable — because Claude wrote it from real conversation context, not from a template.

### Why this matters for cost
Without SESSION_LOG.md: every session starts with you explaining "we're building a recruitment app, we use TypeScript, we finished the job listing page yesterday..."
With SESSION_LOG.md: Claude reads 300 tokens of summary → knows everything → you start working immediately.

---

## Section 4 — How PROFILE.md Really Changes Claude's Behavior

### The mechanism
PROFILE.md is read alongside CLAUDE.md at session start. It tells Claude who *you* are — not what the project is.

### What it actually changes
When PROFILE.md contains:
```
- When I ask a question: I want the answer first, context second.
- What I dislike: Long preambles, repeating what I just said back to me.
- I prefer simple solutions over clever ones.
- I am cost-conscious with tokens — keep responses tight.
```

Claude uses these preferences to shape every response. Not just response length — also:
- **Tone** — peer-to-peer vs teaching mode vs formal professional
- **Ordering** — answer first vs explanation first
- **Recommendation style** — "here are 5 options" vs "here is the best option, here is why"
- **Error explanations** — concise vs detailed
- **Code comments** — minimal vs fully documented

### Configured — all fields filled ✅
PROFILE.md is fully configured for Arogya Reddy. All fields active. See Section 7 for the full field listing.

The parts that ARE filled in (communication style, decision patterns, current project) are currently active and affecting Claude's responses.

---

## Section 5 — How Skills Really Work

### The mechanism
A skill is a `.md` file containing instructions. When you invoke it:

```
You type: "Use debug-first skill."
        ↓
Claude Code reads: C:/AROG/Claude-Free/claude-framework/skills/debug-first.md
        ↓
The file contents are injected into Claude's context
        ↓
Claude now "sees" the full set of debug-first instructions
        ↓
Claude follows them — because they are now visible to it
```

There is no code running. No compilation. No magic. Just a file being read and its text placed in front of Claude.

### Two types of skills

**`agent: false` — runs in your current session:**
```
Your session context:
  [your conversation so far]
  [CLAUDE.md rules]
  + [skill instructions added here]
Claude now behaves differently for the duration of this conversation.
```

**`agent: true` — Claude Code spawns a subagent:**
```
Your session context (unchanged):           Subagent session:
  [your conversation]                    →  [skill instructions]
                                            [the task]
                                            subagent does the work
                                         ←  result returned to you
```

The `agent: true` pattern protects your main context window. Use it for skills that read many files (code-review, project-scan). Use `agent: false` for lightweight instruction sets (scope-guard, change-manifest).

### Does Claude actually follow skill instructions?
Yes — reliably. The 4 most-used skills were audited and all contain clean, unambiguous structured instruction sets. Claude follows them consistently because:
1. The instructions are precise (not vague)
2. They use structured output formats (EXPECTS/ACTUAL/CAUSE/FIX, SCOPE BLOCKER, CHANGE MANIFEST)
3. They contain explicit stop conditions ("Stop. Wait for approval.")

### All 17 skills — verified to exist

| Skill | Agent | What it really does |
|---|---|---|
| `debug-first` | false | Forces EXPECTS→ACTUAL→CAUSE→FIX diagnosis before touching code |
| `scope-guard` | false | Locks changes to named files. Triggers SCOPE BLOCKER for anything else |
| `code-review` | true | Reviews file against CLAUDE.md rules. Returns violations only |
| `spec-to-task` | true | Converts spec → ordered task list, one file per task, dependencies stated |
| `change-manifest` | false | Produces CHANGE MANIFEST: modified/created/deleted with spec refs |
| `session-closer` | false | Writes SESSION_LOG.md from conversation context. Archives history |
| `minimal-output` | false | Strips all narration. Returns code only |
| `output-control` | false | Activates XML tag format for precise length/format control |
| `structured-response` | false | Forces labeled section output |
| `followup-refine` | false | Produces two versions: technical + plain English |
| `safe-cleanup-with-backup` | false | Creates backup before any destructive deletion |
| `duplicate-structure-audit` | true | Classifies duplicate folders as SAFE/CONFLICT/UNKNOWN |
| `jsx-to-standalone-html` | true | Converts .jsx/.tsx to single .html file with no dependencies |
| `healthcheck` | true | Scans project for missing framework components |
| `decision-log` | false | Writes structured decision entry: date/decision/reason/alternatives |
| `project-scan` | true | Full project scan → PROJECT_SCAN.md gap report |
| `framework-apply` | true | Installs framework components based on scan report |

---

## Section 6 — How Token Savings Really Work

### What actually reduces cost

**`.claudeignore` — the biggest single saving**
```
Without it:
  Claude can potentially read node_modules/ → 50,000+ tokens burned
  Claude reads dist/, build/, logs/ → thousands more
  One wrong "let me check for context" → $0.50–$2.00 wasted

With it:
  Claude sees only your ~50 real source files
  Token cost: minimal
```
This is mechanical. No discipline required. Write the file once, it works forever.

**CLAUDE.md and SESSION_LOG.md — removes re-explanation cost**
```
Without: You type "our stack is TypeScript, Node 20, Prisma..." every session → ~300–500 tokens
With: CLAUDE.md auto-loaded → 0 tokens of re-explanation
```
Also mechanical. Works automatically.

**Skills — replace long explanatory prompts**
```
Without skill: 80-word prompt explaining what diagnosis process you want
With skill:    "Use debug-first skill." → 6 tokens
```
The skill file itself costs tokens to load — but far fewer than typing the same instructions each time.

**`/compact` — extends session life**
```
Without compacting: Context fills at ~60% → quality degrades → more corrections needed
With compacting at 60%: Session resets to near-empty → work continues efficiently
```
This requires discipline. See the table below.

### What requires your discipline vs what is automatic

| Saving | Automatic? | What you must do |
|---|---|---|
| `.claudeignore` blocks node_modules | Yes, once created | Create it |
| CLAUDE.md rules apply | Yes, always | Nothing after initial setup |
| SESSION_LOG.md continuity | **No** | Say "Close the session." every time |
| `/compact` context management | **No** | Run at 60%, not 95% |
| Scope guard prevents file-sprawl | **No** | Remember to invoke the skill |
| Minimal-output saves output tokens | **No** | Remember to invoke the skill |
| 4-element prompts reduce back-and-forth | **No** | Write better prompts |

**The honest summary:** The framework removes the largest waste sources automatically. The remaining savings require habits. The habits in `workflow/daily-checklist.md` and `workflow/token-discipline.md` exist exactly because automatic enforcement is not possible for these.

### Token-discipline.md — what it actually contains
Located at `C:/AROG/Claude-Free/claude-framework/workflow/token-discipline.md`.
Contains 10 ranked rules, each with: the rule, a bad example, a good example, and the token impact.
It is a human-facing checklist — not a hook, not a script.
**Read it once at the start of a project. It changes how you write prompts.**

---

## Section 7 — The Two Gaps (Both Fixed)

### Gap 1: Hooks — FIXED ✅

All three hooks are now wired in `C:/Users/Princ/.claude/settings.json`.

**Active since:** March 2026

**What is now running in every session:**

- `pre-tool-use.ps1` — fires **before** every Bash, Write, and Edit call
  - Blocks: `rm -rf`, `DROP TABLE`, `DROP DATABASE`, `TRUNCATE`, `git push --force`, writes to `.env`, `npm install`, `pip install`, `yarn add`
  - Logs every tool use to `.claude/logs/tool-use.log`

- `post-tool-use.ps1` — fires **after** every tool call
  - Logs tool outcomes to `tool-use.log` and a dated `session-YYYY-MM-DD.log`
  - Tracks file paths of every Write/Edit to `changes.log`
  - Flags failed Bash commands

- `pre-compact.ps1` — fires **before** each `/compact`
  - Saves a state snapshot (`pre-compact-state.md`) with: files changed this session, git status, last SESSION_LOG entry
  - Prevents losing work during context compression

**Settings file wired:** `C:/Users/Princ/.claude/settings.json`
All paths are absolute — hooks fire correctly from any project folder on this machine.

**What you still have without hooks (the first safety layer — always was active):**
CLAUDE.md safety rules still instruct Claude not to do dangerous things. The hooks are the second enforcement layer — they block at the app level regardless of what Claude wants to do.

---

### Gap 2: PROFILE.md — FIXED ✅

All placeholders filled. PROFILE.md is fully configured for Arogya Reddy.

**Active since:** March 2026

Fields now set:
- Name: Arogya Reddy
- Role: Tech Lead
- Experience: Sr Lead Software Engineer — Intermediate
- Stack: TypeScript, Node.js, React, GraphQL, MySQL, Lambda, Jest, Playwright
- Team context: AI SDLC, Spec Driven Development
- Communication: Peer-to-peer, direct, answer first
- Decision patterns: simple over clever, edit over create, explicit over implicit
- Notes: GraphQL is the API layer (not REST), spec before building, Lambda constraints

---

## Section 8 — What Claude Can and Cannot Do on Its Own

### Claude genuinely does these (no user action required after setup)
- Reads CLAUDE.md and SESSION_LOG.md at session start
- Follows output rules (no preamble, concise responses, etc.)
- Uses the correct tech stack from CLAUDE.md
- Applies scope rules (but only if scope-guard is invoked)
- Writes SESSION_LOG.md when "Close the session." is said
- Reads skill files when invoked
- Follows structured output formats from skills

### Claude cannot do these without your action
- Remember anything without SESSION_LOG.md being written
- Protect context without `/compact` being run
- Activate hooks (settings.json must be configured)
- Know who you are if PROFILE.md has placeholders

### What "Close the session." actually triggers (step by step)
```
You say: "Close the session."
        ↓
Claude reads the session-closer skill file
        ↓
Claude looks at the full conversation currently in context
        ↓
Claude writes:
  SESSION_LOG.md    — what was done, decisions made, next steps
  decisions.md      — any architectural or approach decisions (if applicable)
        ↓
Claude generates the archive commands for .claude/history/
(You must run these — Claude outputs them but PowerShell runs them, not Claude)
        ↓
Session is done. Context cleared.

Next session:
  SESSION_LOG.md is re-read
  Claude says: "Continuing from [exactly where you left off]"
```

---

## Section 9 — The Reality of AI "Memory" (No Illusions)

Claude Code does not have persistent memory. No session history is stored in the AI model itself.

What you actually have:
```
"Memory" = FILES that Claude reads at session start

Session log         →  SESSION_LOG.md (written by Claude, read next session)
Your identity       →  PROFILE.md     (written by you, read every session)
Project rules       →  CLAUDE.md      (written by you, read every session)
Decision history    →  decisions.md   (written by Claude, read next session)
Pattern learnings   →  patterns.md    (written by Claude, read next session)
```

Each of these is just text written to disk. The "memory" is as good as what got written and how well it was written. This is why:
- "Close the session." matters — that's when the writing happens
- Specific, clear session logs produce better continuity than vague ones
- If you skip closing the session, that day's context is permanently lost

**This is not a weakness.** It is actually very reliable — file-based memory does not degrade, does not hallucinate previous sessions, and is inspectable. You can open SESSION_LOG.md and see exactly what Claude knows about your project.

---

## Section 10 — Verification: Is It Currently Working?

Run this check right now:

### Test 1: Session startup (30 seconds)
Open a new Claude Code session in any project. Type:
```
What do you know about this project? List: your output rules, the tech stack, what we did last session.
```
If Claude answers correctly from CLAUDE.md + SESSION_LOG.md without being told → working.

### Test 2: Skills (30 seconds)
```
Use debug-first skill.
The API returns 500 on every POST request.
```
If Claude produces EXPECTS/ACTUAL/CAUSE/FIX format and waits for approval → skill working.

### Test 3: Hooks (30 seconds)
Hooks are now wired. To verify:
1. Run any Bash command in a Claude Code session
2. Check `.claude/logs/tool-use.log` in the project folder — the command should be logged
3. Run `/compact` — check `.claude/logs/pre-compact-state.md` was created

### Test 4: PROFILE.md (30 seconds)
```
How would you describe me as a developer?
```
Claude should describe: Tech Lead, TypeScript/GraphQL/Lambda stack, AI SDLC context, direct communication style, spec-before-build discipline. If the description is accurate → PROFILE.md is loaded and working.

---

## Summary

The framework is fully operational. All components verified and active.

| Component | Status |
|---|---|
| CLAUDE.md session startup (reads log + profile) | Active |
| SESSION_LOG.md memory | Active |
| PROFILE.md — Arogya Reddy | Active — fully filled |
| All 17 skills | Active — invoke from any project |
| Hooks (pre-tool-use, post-tool-use, pre-compact) | Active — wired globally |
| `.claudeignore` | Active wherever created per-project |
| Token discipline | Human-facing habits (workflow/token-discipline.md) |

**The 3 habits that determine quality:**
1. `Close the session.` — every session, without exception
2. `/compact` at 60% context — not 95%
3. `Use scope-guard skill.` — before every multi-file task

---

*Claude Code Master Framework — Mechanics & Implementation Reality*
*Verified: March 2026*
