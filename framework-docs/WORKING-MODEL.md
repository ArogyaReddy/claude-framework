# WORKING-MODEL.md — How to Use This Framework

## What This Is (Plain English)

Imagine Claude Code is a very capable contractor who shows up to your office every morning with no memory of what they worked on yesterday. No notes, no context, no idea what decisions you've made. Every morning you have to re-brief them from scratch. That's Claude Code without this framework.

This framework gives that contractor a briefing folder that's already on their desk when they arrive. It contains: who you are, what the project is, what you decided last week, what you tried that didn't work, and exactly what task comes next. The contractor reads it silently, and when you walk in, they're ready to work.

The "briefing folder" is a set of plain markdown files. The discipline is writing them consistently. The framework handles the rest.

---

## Who Should Use This

**Solo developers who use Claude Code daily.** If you're the only person on a project and you use Claude every day, the session-to-session memory loss is your biggest friction point. This framework solves it.

**Engineering leads who set up AI tooling for their team.** The framework-apply and project-scan skills let you install this consistently across multiple repos. The healthcheck skill gives you a 12-point verification that every team member's setup is complete.

**Engineers working on regulated or sensitive projects.** The hook scripts block dangerous commands at the app layer — not just in Claude's context. This matters when you're working with production databases, deployment scripts, or credentials.

---

## When to Use It

- You use Claude Code on the same project across multiple days or weeks
- You find yourself re-explaining project context at the start of every session
- You've had Claude accidentally touch files you didn't want it to touch
- You want a structured development protocol (/plan → /spec → /chunk → /verify) instead of ad-hoc prompting
- You're setting up Claude Code for a team and want consistent behavior across all installations

---

## When NOT to Use It

- One-off tasks where you don't need continuity (quick scripts, isolated questions, throwaway experiments)
- Projects where you never need more than one Claude Code session to complete them
- Environments where you can't install hook scripts (restricted enterprise machines, some CI environments)
- If your team uses Anthropic Projects with full repo sync — some of the memory system overlaps

---

## First Time? Start Here

1. **Clone the framework** to your machine: `git clone https://github.com/ArogyaReddy/claude-framework.git`

2. **Run the installer**: `.\setup.ps1` (Windows) or `./setup.sh` (Unix). Answer the prompts — this builds your PROFILE.md.

3. **Open Claude Code in your project**: `cd /your-project && claude`

4. **Run healthcheck**: Type `Use healthcheck skill.` — Claude will report PASS / WARN / FAIL for all 12 components.

5. **Fix any WARNs**: The most common is a missing `.claudeignore`. Copy it from the framework root.

6. **Run your first session start**: Type `/resume`. Claude will output a session brief (short on first session — the memory files are empty).

7. **Do your first real task**: Try `Use scope-guard skill.` then ask Claude to make a change. Notice how scope violations get caught.

8. **Close clean**: Type `/wrap` before exiting. This is the most important habit to build. Claude will write SESSION_LOG.md.

9. **Open Claude tomorrow**: Type `/resume`. Claude will know where you left off.

10. **You're in the loop**: From here, the framework maintains itself as long as you `/wrap` every session.

---

## Day-to-Day Usage

**Every morning:**
```
/resume                          ← reads memory, outputs brief
```
Confirm the brief is accurate. If something seems wrong, check SCRATCHPAD.md directly — it's a plain text file.

**Before any multi-file task:**
```
Use scope-guard skill.
Now [describe the task].
```

**When debugging:**
```
Use debug-first skill.
[Describe the symptom]
```
Claude will produce EXPECTS / ACTUAL / CAUSE / FIX format before touching any code.

**For new features:**
```
/plan    ← architecture discussion, no code
/spec    ← writes specs/[feature].md
/chunk   ← builds first chunk
/verify  ← Claude interrogates its own output
/chunk   ← next chunk (repeat)
/wrap    ← close session
```

**When something important is decided:**
```
/decide
```
Don't wait until `/wrap` — decisions fade from context.

---

## Features

| Feature | What It Does | When to Use |
|---|---|---|
| Session memory (SCRATCHPAD + DECISIONS) | Claude knows last session's state on open | Always — core loop |
| PROFILE.md identity | Claude knows your communication style and stack | Always — loaded at startup |
| `/resume` command | Outputs session brief on open | Start of every session |
| `/wrap` command | Writes memory files on close | End of every session |
| `/decide` command | Logs decisions mid-session | Any significant architectural choice |
| `scope-guard` skill | Blocks Claude from editing out-of-scope files | Before any multi-file task |
| `debug-first` skill | Forces EXPECTS/ACTUAL/CAUSE/FIX diagnosis | Any bug investigation |
| `session-closer` skill | Writes complete session state to disk | Invoked by `/wrap` |
| `healthcheck` skill | 12-point framework verification | New project setup, troubleshooting |
| `project-scan` + `framework-apply` skills | Install framework on new repos | New project onboarding |
| Pre-tool-use hook | Blocks dangerous commands at app level | Automatic — always active |
| Post-tool-use hook | Logs all tool calls | Automatic — always active |
| Pre-compact hook | Saves state before context compression | Automatic — fires on `/compact` |
| `.claudeignore` | Hides non-source files from Claude | Per-project — copy from framework |
| 5-phase protocol | Enforces Plan → Spec → Build → Verify discipline | Non-trivial features (2+ files) |

---

## Outcomes You Can Expect

**Session continuity:** Open Claude the next day and it knows the project state, last decisions, and next action — without any re-explanation from you.

**Token savings:** The combination of `.claudeignore`, CLAUDE.md auto-load, and skill invocation typically reduces per-session token consumption by 40–60% compared to unstructured Claude use.

**Scope discipline:** The scope-guard skill and pre-tool-use hook together prevent the most common agentic AI failure mode: touching files you didn't ask it to touch.

**Structured bug diagnosis:** debug-first forces Claude to think before it writes. EXPECTS/ACTUAL/CAUSE/FIX is the output — not a guess at a fix that might work.

**Decision audit trail:** DECISIONS.md is a permanent log. Every architectural choice, every time something unexpected was discovered, every time an approach was rejected — it's there. When you revisit a project after three months and wonder "why did we do it this way?", the answer is in the file.
