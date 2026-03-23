# STORY-BOARD.md — The Story of the Claude Code Master Framework

## How It Started

So here's the thing — we had a problem that sounds almost too small to matter, but it was burning real time every day. Claude Code is a brilliant tool. Open a terminal, type `claude`, and you have an AI pair programmer that can read your codebase, write code, run commands, and carry on a real technical conversation. The problem was that every morning, you'd open a new session and it was blank. Completely. No memory of what we were building, what decisions we'd made, what we'd tried that didn't work. You'd spend the first fifteen minutes just re-explaining: "We're building a TypeScript API, we use GraphQL not REST, last week we decided to use Lambda for this function because of cost constraints…" That's not pair programming. That's onboarding your own tool from scratch every day.

## What We Tried First (And Why It Didn't Work)

The obvious solution felt like: just keep a long system prompt that explains everything. And that worked — until the context window filled up. At about 60% capacity, Claude's response quality starts to visibly degrade. By 90%, it was dropping constraints it had been following all day. The expensive answer was "just use Claude Projects," which syncs a repository and gives persistent context. But Projects have their own limits, and more importantly, they don't give you surgical control over what gets loaded when.

The next idea was to write a big CLAUDE.md file. This is the right idea — Claude Code loads CLAUDE.md automatically at session start. But writing one file and calling it done misses the architecture. A CLAUDE.md file is not magic. It is text. The intelligence is in what that text contains and how it is structured.

## The Breakthrough

The breakthrough was realizing this is a file system problem, not a prompt engineering problem. Claude Code does not have memory — but your hard drive does. If you write what happened in a session to disk, and Claude reads that file the next morning, it "remembers" — not because it stored anything, but because it read the file you saved. Same mechanism as how a human colleague catches up after a vacation by reading last sprint's notes.

That realization unlocked everything else. Memory is a file. Identity is a file. Behavioral rules are a file. Skill instructions are a file. Skills become invocable by name because Claude reads the skill file when you say the invocation phrase. Safety guardrails become mechanical because the hook scripts run at the Claude Code app layer — below Claude's context, where Claude's own behavioral drift can't reach them.

## How It Works Today

Here's what happens when you open Claude Code in a project that has this framework installed. Before you type a single word, Claude has already read: the project's CLAUDE.md (its rules), the global CLAUDE.md (your identity and behavioral standards), PROFILE.md (who you are, how you like to communicate, what stack you use), and SESSION_LOG.md (exactly where you left off last time, what decisions were made, what to do next). It does this silently. You open a session and Claude already knows the context — not because it's smart about it, but because it read the files.

When you type `/resume`, you get a session brief: current focus, last decisions, next action. When you need structured bug diagnosis, you say "Use debug-first skill" and Claude produces EXPECTS / ACTUAL / CAUSE / FIX before touching a single file. When you finish, you say `/wrap` and Claude writes an accurate session summary to SCRATCHPAD.md and a decision entry to DECISIONS.md. Tomorrow it reads those files. The loop closes.

## The Challenges That Almost Stopped Us

Hooks were harder than expected. The idea is simple: run a script before Claude executes a dangerous tool call, block it if it matches a pattern. The reality is that PowerShell execution policies, absolute vs. relative paths in settings.json, and the difference between Windows and Unix path separators created a surprising number of silent failures. A hook registered with a relative path works exactly as long as you open Claude Code from the same directory. Open it from anywhere else and the hook doesn't fire and Claude Code doesn't tell you.

The second challenge was discipline. The entire memory system depends on one action: saying `/wrap` at the end of every session. If you don't, nothing gets written, and tomorrow's session starts blank. That's not a technical problem you can engineer around — it has to become habit.

## How We Overcame Them

For hooks: absolute paths everywhere, always. The setup script writes the full path to `settings.json`. And the healthcheck skill specifically verifies hook registration as one of its 12 diagnostic points.

For discipline: the framework was designed so that the cost of skipping `/wrap` is immediately obvious. Tomorrow's Claude says "no SESSION_LOG.md found — starting fresh." That is a painful enough consequence that it makes the habit.

## What We're Proud Of

The minimal footprint. Adding this framework to a project adds three hook scripts, a `.claudeignore`, one CLAUDE.md, and some markdown files. There is no build step. No server. No npm dependency. No SaaS subscription. It layers non-destructively on top of whatever project you're in. You can remove it by deleting the files and deregistering the hooks in settings.json.

The other thing: the skills genuinely work. "Use debug-first skill" produces real diagnostic structure that saves time. "Use scope-guard skill" has caught Claude trying to edit files outside the stated scope more than once. These are not aspirational — they're tested in real daily use.

## What We'd Do Differently

We'd write the skills before the memory system. The memory files (SCRATCHPAD, DECISIONS, SESSIONS) are important, but their value depends on Claude generating accurate, specific content for them — which depends on having a well-written session-closer skill. We built the memory schema first and the session-closer last. Should have been the other way.

We'd also document the hook paths problem on day one instead of discovering it after two weeks of wondering why the hooks seemed inconsistent.

## What's Coming Next

The next layer is agent orchestration. The `batch` skill in `.claude/skills/` is the prototype: describe a set of independent tasks, and Claude spawns parallel subagents to work on them simultaneously. The constraint right now is that subagent outputs need a review step before being merged. The `/verify` command is the mechanism — but making it work cleanly across multiple simultaneous subagents requires a coordination spec that doesn't exist yet.

There's also a conversation about publishing the skill library as a standalone npm package that teams could install, configure once, and inherit framework behavior across all their repos. The architecture supports it. The question is whether the skill format is stable enough to commit to a public API.
