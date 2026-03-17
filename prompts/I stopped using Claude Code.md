I stopped using Claude Code alone. Now it orchestrates GPT-5.4 and Gemini in the same IDE and they notify me on Telegram when they're done.
Built with Claude
I use Claude Code every day for B2B sales and software development. For months I kept running into the same problem: every session started from scratch. Context gone. Decisions forgotten. The three AI models I use (Claude, GPT, Gemini) all lived in separate silos.

Took a while to get right. This is what I ended up with.

The context layer
The filesystem IS the protocol. No database, no external service. Markdown files that Claude reads at the start of every session.

CLAUDE.md is the main operating file. Projects, preferences, constraints, current session state. Claude reads this automatically.

PROFILE.md holds my professional identity: background, communication style, decision patterns. It's how Claude knows my tone when it writes for me.

SESSION_LOG.md logs every session. What was done, what was decided, what's pending. Newest first.

.claude/history/ is where the compounding happens. A session-closer agent captures learnings, decisions, research findings, and ideas into separate files. After 3 months I have 50+ knowledge files. When I'm about to make an architectural decision, Claude checks what I decided about similar things in January.

I say "close the session" at the end of every work block. The Session Closer sub-agent updates everything: session log, knowledge history, workspace improvements, ROI tracking. I don't touch any of it manually.

Three AIs, one workspace
I pay for three AI subscriptions. Sounds excessive. It's not.

Claude Code (Opus 4.6) is the orchestrator. Deep work, complex analysis, skill system, session management.

GPT-5.4 via Codex CLI handles code review, implementation, debugging. I named it Dario.

Gemini 3.1 Pro does web research, Google Workspace integration, multimodal analysis. I named it Irene.

Each model has its own SOUL.md file that defines identity, mission, strengths, and limits. Claude's sits in .claude/SOUL.md. GPT's in .codex/SOUL.md. Gemini's in .gemini/SOUL.md. They also have operational files (AGENTS.md for GPT, GEMINI.md for Gemini) that tell them what to read at session start, what rules to follow, who the other peers are.

What ties it together: they all read the same context files. CLAUDE.md, PROFILE.md, SESSION_LOG.md, the history directory. When I open a session with GPT, it already knows my projects, my constraints, and what happened in my last Claude session.

They can also call each other. No API. No middleware. CLI:

codex exec --skip-git-repo-check "Review this function for edge cases"

gemini -m gemini-3-flash-preview -p "Search for recent benchmarks on X"

claude -p "Summarize the last 3 session log entries"
All of this runs inside Gemini's Antigravity IDE. Three terminals, three models, same screen.

r/ClaudeAI - Codex GPT 5.4 + Claude Code Opus 4.6 + Antigravity Gemini Pro 3.1 in the same IDE with same context
Codex GPT 5.4 + Claude Code Opus 4.6 + Antigravity Gemini Pro 3.1 in the same IDE with same context
There's also an async layer. I run OpenClaw (on my OpenAI subscription) to handle scheduled jobs: recurring research tasks, data checks, content pipelines. Things that don't need me sitting in front of a terminal. All three models in the IDE can trigger or interact with those jobs.

And they share a custom MCP Server connected to a Telegram bot. When a task is complex and takes time, I tell the model to notify me when it's done. Ten minutes later my phone buzzes with the result. Sounds small, but it changes how you work. You stop babysitting terminals and start running parallel workstreams.

r/ClaudeAI - Claude Code Notify
Claude Code Notify
So what does this actually look like?
Last week I was building a publishing factory. Master orchestrator, 6 specialized sub-skills, agents, templates, validation scripts. The kind of system where bugs compound fast.

I used Claude Code to build and iterate. Then I called GPT-5.4 as an independent QA reviewer. Not a rubber stamp. A proper audit with severity classifications.

Five rounds of review:

Round 2: 2 Critical, 10 High

Round 3: 1 Critical, 5 High

Round 4: 0 Critical, 3 High

Round 5: 0 Critical, 0 High. READY FOR PILOT.

Claude builds. GPT reviews. Claude fixes. GPT reviews again. Two models from two different companies, reviewing each other's output. The only glue is shared files and CLI calls.

GPT flagged a manifest schema bug in round 3 that Claude had missed across two full sessions. That's exactly why you want a second model reviewing: it catches different things.

Two months in
259 sessions tracked

53 structured knowledge files (decisions, learnings)

66 entities in the Obsidian knowledge graph

Every session logs estimated hours saved

The workspace proposes its own improvements weekly. I review them, implement the good ones.

How to build this yourself
The whole thing runs on three primitives: shared markdown files, SOUL.md identity prompts, and CLI calls between runtimes.

Step 1: Context layer. Create CLAUDE.md (operating state), PROFILE.md (your identity), SESSION_LOG.md (history). Put them in a directory all three models can access. Claude Code reads CLAUDE.md automatically. For GPT and Gemini, you reference these files in their system prompts or operational docs.

Step 2: Identity files. Each model gets a SOUL.md with: who it is, what it's good at, what it should NOT do, who the other models are. This is the part that takes the most iteration. Without clear boundaries, models start hallucinating capabilities they don't have. Be specific about strengths and limits.

Step 3: Cross-runtime calls. Claude Code, Codex CLI, and Gemini CLI all support one-shot prompts from the terminal. That means any model can call any other model with a bash command. No API keys in your code, no middleware, no orchestration framework. Just claude -p "..." or codex exec "..." or gemini -p "...".

Step 4: Session closer. This is the piece that turns a collection of AI tools into a system that gets smarter over time. Without it, you have three models with shared files. With it, you have compounding knowledge.

At the end of each work block, the session closer agent does three things: updates SESSION_LOG.md with what happened, creates a structured session note (I use Obsidian-friendly markdown with wikilinks to entities like projects, tools, and people), and writes learnings and decisions into a history/ directory organized by type — decisions, research findings, patterns, ideas.

After a few weeks, that history directory becomes the most valuable part of the whole setup. Every model can reference past decisions before making new ones. And periodically, you can feed the entire history back into a model and ask: "What patterns do you see? What should I change about this workspace?" The system literally proposes its own improvements.

r/ClaudeAI - Multi-agent session logs mapped in Obsidian
Multi-agent session logs mapped in Obsidian
The hardest parts to get right: tuning SOUL.md prompts so models respect their boundaries (took me ~15 iterations), teaching Claude Code — the orchestrator — when to proactively engage the other models instead of trying to do everything itself, structuring the history files so they're useful without being noisy, and making the session closer extract signal instead of generating junk.

What I'd do differently
If I started over:

Start with two models, not three. Claude + one reviewer is enough. Adding Gemini for research was valuable but not essential on day one.

Keep SESSION_LOG.md lean. Mine got bloated before I added strict formatting rules. 20 lines per session max.

SOUL.md is bigger than you think. Mine are ~125 lines each. You need sections for identity, mission, strengths, hard limits, peer awareness, and operational rules. Starting with less sounds smart but you'll keep hitting edge cases. Write it thorough from day one, then refine based on actual misbehavior.

Ask me anything about the architecture, the prompt design, or the cross-runtime QA pattern. Happy to go deeper on any section.