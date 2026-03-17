import { useState } from "react";

const SECTIONS = ["Mental Model", "What I Need From You", "Golden Prompts", "Golden Skills", "Session Memory", "Daily Workflow", "Project Setup", "Token Discipline", "Framework Guide"];

const mentalModel = [
  {
    title: "What I Actually Am",
    content: "A next-token predictor given context. The quality of my output is almost entirely determined by the quality of what is already in my context window. Everything else is just how you control that context."
  },
  {
    title: "The Context Hierarchy",
    items: [
      { label: "CLAUDE.md", desc: "Persistent rules, org standards, constraints. Loads every session. Cheapest per-task cost." },
      { label: "Skills", desc: "Reusable instruction sets for repeated patterns. Write once, invoke many times." },
      { label: "Hooks", desc: "Automated guardrails that run without any prompt at all. PreToolUse / PostToolUse." },
      { label: ".claudeignore", desc: "A token budget tool. Files I can't see, I can't hallucinate about." },
      { label: "Prompt", desc: "Per-task instruction. Should be SCOPE + ACTION only. Fence and Output live in skills/CLAUDE.md." },
      { label: "Free Typing", desc: "Exploration only. Never use for known, repeatable tasks." }
    ]
  },
  {
    title: "The Four Elements of Every Good Prompt",
    items: [
      { label: "SCOPE", desc: "Exactly what I am touching — file, function, module." },
      { label: "ACTION", desc: "Exactly what I am doing to it — one thing." },
      { label: "FENCE", desc: "What I must not cross — what not to touch, change, or assume." },
      { label: "OUTPUT", desc: "Exactly what you get back — format, length, stop condition." }
    ],
    note: "The endgame: your prompts become SCOPE + ACTION only, because FENCE and OUTPUT are already loaded from skills and CLAUDE.md."
  }
];

const whatINeed = [
  {
    category: "Always Give Me",
    color: "green",
    items: [
      "Exact file paths, not vague references",
      "One task per prompt — not 'and also'",
      "What must NOT change, not just what should",
      "The stop condition — when am I done?",
      "A spec or reference file when one exists",
      "Your constraints before your request"
    ]
  },
  {
    category: "Never Give Me",
    color: "red",
    items: [
      "Open-ended asks when you know what you want",
      "Multi-step asks in one prompt",
      "Requests to explain while doing — it doubles cost",
      "'Make it better' without criteria",
      "Context I already have in CLAUDE.md",
      "Permission to make architectural decisions"
    ]
  },
  {
    category: "Use Plan Mode When",
    color: "amber",
    items: [
      "The task touches more than two files",
      "The change is hard to reverse",
      "You are not sure of the right approach",
      "You want to verify my reasoning before cost",
      "Starting a new feature from a spec"
    ]
  }
];

const goldenPrompts = [
  {
    name: "Surgical Edit",
    use: "Any code change where scope is known",
    template: `In [FILE], [ONE THING TO CHANGE].
Do not touch [WHAT TO LEAVE ALONE].
Return only the modified [FUNCTION / SECTION / FILE].
No explanation.`,
    example: `In auth/session.ts, extract the token refresh logic into a standalone function.
Do not change function signatures or calling code.
Return only the modified file.
No explanation.`
  },
  {
    name: "Plan Gate",
    use: "Complex tasks, multi-file changes, anything irreversible",
    template: `Before writing any code, give me your step-by-step plan for:
[TASK]

Do not execute. Wait for my confirmation.`,
    example: `Before writing any code, give me your step-by-step plan for:
Migrating the user session store from Redis to Postgres.

Do not execute. Wait for my confirmation.`
  },
  {
    name: "Spec-First Build",
    use: "New feature or module with a spec already written",
    template: `Build [THING] according to [SPEC FILE PATH].
Constraints:
- [CONSTRAINT 1]
- [CONSTRAINT 2]
Output: [EXACTLY WHAT FILES / FORMAT]
Stop after that.`,
    example: `Build the notification service according to specs/notifications.md.
Constraints:
- No new dependencies
- Do not modify the existing event bus
Output: src/services/notifications.ts only.
Stop after that.`
  },
  {
    name: "Diagnosis First",
    use: "Bugs, errors, performance issues — analysis before solution",
    template: `Look at [FILE / FUNCTION].
Tell me: what is wrong, why, and where exactly.
Do not fix it yet.
One sentence per finding.`,
    example: `Look at src/api/payments.ts processBatch function.
Tell me: what is wrong, why, and where exactly.
Do not fix it yet.
One sentence per finding.`
  },
  {
    name: "Constraint Check",
    use: "Code review, spec compliance, pre-merge checks",
    template: `Review [FILE] against these rules:
- [RULE 1]
- [RULE 2]
- [RULE 3]

List only violations. Line number and reason. Nothing else.`,
    example: `Review src/services/auth.ts against these rules:
- No raw SQL, use the query builder
- All errors must go through AppError class
- No console.log in production paths

List only violations. Line number and reason. Nothing else.`
  },
  {
    name: "Refactor Boundary",
    use: "Cleanup where you're worried about regression",
    template: `Refactor [FUNCTION / FILE] for [ONE GOAL: readability / performance / simplicity].
Do not change behavior.
Do not change external interfaces.
Show me a diff-style before/after for the key change only.`,
    example: `Refactor src/utils/dateHelpers.ts for readability.
Do not change behavior.
Do not change exported function signatures.
Show me a diff-style before/after for the key change only.`
  },
  {
    name: "Output Contract",
    use: "Any time output format matters — which is always",
    template: `[TASK].
Return format:
- [WHAT THE OUTPUT LOOKS LIKE]
- [WHAT IT MUST NOT INCLUDE]
- [WHERE IT STOPS]`,
    example: `Write unit tests for the validateUser function.
Return format:
- Jest test blocks only
- No imports, I will add them
- Stop after the last test case, no summary`
  },
  {
    name: "Change Log",
    use: "After edits — for PR descriptions, audit trail, spec traceability",
    template: `Summarise what you just changed.
Format:
- Files modified
- What changed (one line each)
- Why (reference spec section if applicable)
- What was explicitly not changed
No prose.`,
    example: `Summarise what you just changed.
Format:
- Files modified
- What changed (one line each)
- Why (reference spec section if applicable)
- What was explicitly not changed
No prose.`
  },
  {
    name: "Explicit Format + Length",
    use: "When output format and length must be exact — cards, summaries, fixed-size content",
    template: `<role>[who Claude is acting as]</role>
<task>[what you need]</task>
<format>[paragraph | numbered-list | bullet-list | table | labeled-sections]</format>
<length>[exact constraint: e.g. "3 sentences" | "5 bullets" | "100 words max"]</length>`,
    example: `<role>Senior software engineer</role>
<task>Explain what React reconciliation does.</task>
<format>Single paragraph</format>
<length>50 words max</length>`
  },
  {
    name: "Section-Divided Output",
    use: "Multi-topic responses — comparisons, audits, onboarding docs, decision briefs",
    template: `<role>[who Claude is acting as]</role>
<task>[what to produce]</task>
<response_format>
  <sections>[comma-separated section names]</sections>
  <section_length>[sentence count or word limit per section]</section_length>
</response_format>`,
    example: `<role>Staff engineer</role>
<task>Compare REST and GraphQL for a mobile app backend.</task>
<response_format>
  <sections>Overview, Pros, Cons, Best Fit</sections>
  <section_length>2-3 sentences per section</section_length>
</response_format>`
  },
  {
    name: "Depth-Then-Condense",
    use: "Same content for two audiences — technical first, then simplified",
    template: `Step 1 — Full depth:
<role>[Expert role]</role>
<task>[Detailed explanation]</task>
<format>Detailed prose. No length limit. Prioritise completeness.</format>

Step 2 — Condense (send after Step 1):
Condense your previous response:
<target_audience>[beginner | executive | non-technical | team lead]</target_audience>
<length>[1 sentence | 3 bullets | 50 words | one paragraph]</length>
<format>[plain language | bullet list | executive summary]</format>`,
    example: `Step 1:
<role>Distributed systems engineer</role>
<task>Explain how eventual consistency works, including trade-offs and examples.</task>
<format>Detailed technical prose. No length limit.</format>

Step 2:
Condense your previous response:
<target_audience>non-technical product manager</target_audience>
<length>3 bullets</length>
<format>plain language, no jargon</format>`
  }
];

const goldenSkills = [
  {
    name: "spec-to-task",
    trigger: "Start of every feature",
    why: "Consistent task granularity. Write once for the whole team.",
    instruction: `Given a spec section, output tasks as:
- One task per file affected
- Each task states: file, what changes, what must not change
- No task depends on an unfinished task above it
- Tasks ordered by dependency, not by document order
- No explanations, just the task list`
  },
  {
    name: "debug-first",
    trigger: "Any bug or error report",
    why: "Stops me jumping to fixes. Saves the token cost of wrong solutions.",
    instruction: `When given a bug or error:
1. State what the code expects
2. State what is actually happening
3. State the exact line and cause
4. Stop. Do not fix until told to proceed.`
  },
  {
    name: "minimal-output",
    trigger: "Any session where you want pure code, no narration",
    why: "Cuts response length 40-60% on code tasks.",
    instruction: `Output rules for this session:
- No preamble
- No explanation after code
- No "Here is the..." or "This function..."
- Code only, with inline comments where logic is non-obvious
- No closing summary`
  },
  {
    name: "code-review",
    trigger: "Pre-merge, spec compliance check",
    why: "Your standards live in the skill. Never re-explain per session.",
    instruction: `Review against org rules loaded in CLAUDE.md.
Output: violations only.
Format: file + line number + rule violated + one-line explanation.
Do not suggest style opinions outside defined rules.
Do not rewrite code unprompted.`
  },
  {
    name: "change-manifest",
    trigger: "After any multi-file edit",
    why: "PR descriptions, traceability, audit trail — automatic.",
    instruction: `After completing any code change, output:
- File(s) modified
- What changed (one line each)
- Why (reference spec section if applicable)
- What was explicitly not changed
Format: structured list, no prose`
  },
  {
    name: "scope-guard",
    trigger: "Any task with risk of scope creep",
    why: "Prevents me from touching things you didn't ask about.",
    instruction: `For this task:
- Touch only the files explicitly named
- If a fix requires changing an unmentioned file, stop and report it
- Do not refactor adjacent code even if it looks wrong
- Do not add imports, dependencies, or new abstractions unless specified`
  },
  {
    name: "output-control",
    trigger: "When output format and length must be exact",
    why: "Removes guesswork on format and length. Claude does exactly what the XML tags say, every time.",
    instruction: `Respond only in the format specified in <format> tag.
Respect the constraint in <length> tag exactly — not approximately.
No preamble before the answer. No closing remarks after.
XML tag structure:
<role>[role]</role>
<task>[task]</task>
<format>[paragraph | numbered-list | bullet-list | table | labeled-sections]</format>
<length>[exact count: e.g. "3 sentences" | "5 bullets" | "100 words max"]</length>`
  },
  {
    name: "structured-response",
    trigger: "Multi-topic responses needing clear sections",
    why: "Forces labeled ## sections. Scannable output instead of walls of text.",
    instruction: `Divide output into labeled ## sections only.
Each section must be self-contained. No cross-references.
No preamble before the first section. No closing summary after the last.
XML tag structure:
<role>[role]</role>
<task>[task]</task>
<response_format>
  <sections>[comma-separated section names]</sections>
  <section_length>[sentence count or word limit per section]</section_length>
</response_format>`
  },
  {
    name: "followup-refine",
    trigger: "Two-audience content — technical then simplified",
    why: "Same content, different depth. One session serves both technical and non-technical needs without re-explaining.",
    instruction: `Two-step pattern:
Step 1 — full depth: get complete technical explanation.
Step 2 — condense: send immediately after Step 1 output:
Condense your previous response:
<target_audience>[audience]</target_audience>
<length>[target length]</length>
<format>[target format]</format>
Step 2 does not re-read the codebase — only reformats Step 1 output.`
  },
  {
    name: "session-closer",
    trigger: "End of every work block — say: 'close the session'",
    why: "Captures decisions and learnings before context is lost. The system gets smarter every session instead of resetting to zero.",
    instruction: `When triggered, produce structured content blocks for:
1. SESSION_LOG.md — session summary (max 20 lines): what was done, decisions made, what is pending
2. .claude/history/decisions.md — any architectural or approach decisions made this session
3. .claude/history/learnings.md — any codebase facts, tool behaviours, or environment discoveries
4. .claude/history/patterns.md — any good/bad/watch patterns noticed
5. Workspace improvements — flag any recurring friction or improvement opportunities
Format each as a ready-to-paste markdown block.`
  },
  {
    name: "project-scan",
    trigger: "Onboarding any new project",
    why: "Detects stack, existing configs, and framework gaps in one pass. Takes seconds, saves a session of manual discovery.",
    instruction: `When triggered with a target project path:
1. Run tools/scan-project.ps1 (Windows) or tools/scan-project.sh (Unix) on the target
2. Read the output PROJECT_SCAN_RAW.md
3. Read registry/skills-registry.md and registry/hooks-registry.md
4. Analyse gaps: what exists vs what the framework offers
5. Write PROJECT_SCAN.md to the target with:
   - Stack detected, what exists, what's missing, priority recommendations
Trigger: "Use project-scan skill on [/path/to/project]"`
  },
  {
    name: "framework-apply",
    trigger: "After project-scan — to install framework components",
    why: "Installs chosen components into any project. Never overwrites existing files. Never touches CLAUDE.md — reports what to add manually.",
    instruction: `Read PROJECT_SCAN.md for target path and component list.
For each component: copy source from framework to target.
Rules:
- NEVER overwrite existing files (skip + log SKIPPED)
- NEVER modify CLAUDE.md (report lines to add instead)
- NEVER create settings.json (show JSON, user creates it)
- Report every file: INSTALLED / SKIPPED / FAILED
End with manual steps: CLAUDE.md lines + settings.json JSON + chmod instructions.`
  },
  {
    name: "safe-cleanup-with-backup",
    trigger: "Before any destructive deletion or cleanup",
    why: "Timestamped backup before anything is deleted. No accidental data loss, full recovery path.",
    instruction: `Before any deletion:
1. Create timestamped backup: cleanup-backup-YYYYMMDD-HHMMSS/
2. Copy all files to be deleted into backup, preserving relative paths
3. Confirm backup inventory (list every file)
4. Only proceed with deletion after backup is confirmed
5. Report: backup path, deleted paths, verification checks`
  },
  {
    name: "duplicate-structure-audit",
    trigger: "When duplicate folders or files are suspected",
    why: "Classifies duplicates before deletion — exact copies vs divergent copies with different content. Prevents deleting the wrong version.",
    instruction: `Scan for duplicate structures by relative path.
Classify each duplicate:
- EXACT: identical content (safe to delete directly)
- DIVERGENT: same path, different content (backup before deletion)
For EXACT: delete directly, report paths.
For DIVERGENT: backup first, then ask before deleting.
Never delete divergent duplicates without explicit confirmation.`
  },
  {
    name: "jsx-to-standalone-html",
    trigger: "Converting a React/JSX component to a browser-usable file",
    why: "No build step, no Node.js, no dependencies. The component runs directly in any browser.",
    instruction: `Convert the named JSX component to a standalone HTML file:
- Inline all styles (no external CSS)
- Replace all React imports with CDN links (React 18 + ReactDOM via unpkg)
- Replace JSX syntax with React.createElement() calls OR use Babel standalone CDN
- No build step required — file opens directly in browser
- Output: single .html file with all logic, styles, and markup inlined`
  },
  {
    name: "healthcheck",
    trigger: "Periodic framework health verification",
    why: "12-point diagnostic catches broken hooks, stale logs, missing files, and unfilled placeholders before they silently degrade your sessions.",
    instruction: `Run all 12 checks independently — never skip a check because another failed:
1. PROFILE.md configured (no [placeholder] text)
2. SESSION_LOG.md exists
3. SESSION_LOG.md freshness (last entry < 7 days)
4. .claude/history/ populated (decisions.md, learnings.md, patterns.md)
5. skills/ populated (>= 5 .md files)
6. Hook scripts present (pre-tool-use, post-tool-use, pre-compact — PS1 + SH pairs)
7. .claude/settings.json exists and hooks wired (PreToolUse, PostToolUse, PreCompact)
8. CLAUDE.md has Session Startup section
9. registry/ populated (skills-registry.md, hooks-registry.md, patterns-registry.md)
10. tools/ scanner present (scan-project.ps1, scan-project.sh)
11. .claude/archive/ snapshot health (1–10 snapshots, not over cap)
12. No orphan placeholders in skills/ ([FILL IN], [YOUR, TODO)
Output: PASS / WARN / FAIL per check, with remediation hints for failures.
Trigger: "Use healthcheck skill."`
  },
  {
    name: "decision-log",
    trigger: "After any significant architectural or tooling decision",
    why: "Formal Architecture Decision Records prevent re-litigating settled questions. Future sessions check decisions.md before recommending something already rejected.",
    instruction: `Capture a structured ADR entry for .claude/history/decisions.md:
- Decision: what was chosen (one sentence)
- Reason: why this over alternatives
- Alternatives rejected: what else was considered + one-line reason each
- Applies to: file, feature, module, or Global
- Reversibility: Easy / Moderate / Hard
For major decisions, optionally create a standalone file at .claude/decisions/NNN-slug.md with full Context, Rationale, Alternatives table, Consequences, and Related Decisions.
Trigger: "Use decision-log skill." or "Log this decision: [description]"`
  }
];

const dailyWorkflow = [
  { step: "1", phase: "Before You Start", actions: ["Is there a spec? Reference it, don't re-explain it.", "What must NOT change? State it first.", "Is this complex or multi-file? Use Plan Mode.", "Does a skill already cover this? Invoke it.", "New project? Run project-scan first."] },
  { step: "2", phase: "Write the Prompt", actions: ["SCOPE: exact file or function", "ACTION: one thing only", "FENCE: what not to touch", "OUTPUT: format and stop condition", "Remove every word that isn't one of those four things."] },
  { step: "3", phase: "Review the Plan (if used)", actions: ["Does the plan match your intent exactly?", "Does it touch anything it shouldn't?", "Is the sequence right?", "Confirm or correct before executing."] },
  { step: "4", phase: "After Output", actions: ["Did it stay in scope?", "Request a change-manifest if multi-file.", "If wrong: diagnose with Diagnosis First prompt, don't just re-ask.", "Encode any repeated correction into a skill or CLAUDE.md."] },
  { step: "5", phase: "End of Session", actions: ["Say: 'close the session'", "Session-closer updates SESSION_LOG.md automatically.", "Decisions and learnings are written to .claude/history/.", "Workspace improvements are flagged for review.", "Next session starts with full context — no re-explaining."] }
];

const projectSetup = [
  { item: "CLAUDE.md at root", detail: "Org standards, naming conventions, what I must never do, output format defaults" },
  { item: ".claudeignore configured", detail: "Exclude: node_modules, build output, generated files, large data files, irrelevant services" },
  { item: "Skills folder created", detail: "At minimum: scope-guard, debug-first, session-closer. Run project-scan for full gap analysis." },
  { item: "Hooks configured", detail: "PreToolUse: blocks dangerous ops + logs all tool use. PostToolUse: change tracking. Pre-compact: saves state before compaction." },
  { item: "PROFILE.md created", detail: "Your identity, background, tone, decision patterns, and current project focus. Filled in once, updated per project phase." },
  { item: "SESSION_LOG.md created", detail: "Running session history. Newest entry first. Max 20 lines per session. Written by session-closer automatically." },
  { item: ".claude/history/ initialised", detail: "decisions.md, learnings.md, patterns.md — knowledge that compounds over time. Updated by session-closer at end of every work block." },
  { item: "Spec format defined", detail: "Every feature gets a spec file. Prompts reference the spec, never re-state it." },
  { item: "Token budget set", detail: "Know your session limit. Use .claudeignore aggressively. Plan before execute." },
  { item: "project-scan on new repos", detail: "Run 'Use project-scan skill on [path]' before starting work on any new project. Detects stack, existing configs, and framework gaps instantly." }
];

const tokenRules = [
  { rule: "One concern per prompt", saving: "High", why: "Multi-step asks multiply error rate and token cost" },
  { rule: "Constraints before request", saving: "High", why: "Collapses my solution space before I start generating" },
  { rule: "No 'explain while doing'", saving: "High", why: "Doubles output length immediately" },
  { rule: "Specify output format", saving: "Medium", why: "I choose format when you don't — always verbosely" },
  { rule: "Plan Mode for complex tasks", saving: "High", why: "One wrong execution costs 3-5x a planning correction" },
  { rule: "Skills over re-explaining", saving: "Medium", why: "Context you repeat each session is waste" },
  { rule: "Reference specs, don't paste them", saving: "Medium", why: "File paths load on demand; pasted context loads always" },
  { rule: "Stop conditions in every prompt", saving: "Medium", why: "Without them I continue past done" }
];

const sessionMemory = {
  purpose: "Without a memory layer, every session starts from zero. These files are the context that persists — your identity, your history, your decisions. Claude reads them at the start of every session and gets smarter over time.",
  files: [
    {
      name: "PROFILE.md",
      location: "Project root",
      what: "Your identity, working style, decision patterns, and current focus area.",
      why: "Claude writes as you, not as a generic assistant. Tone, vocabulary, and recommendations are shaped by who you are.",
      howToUse: "Fill it in once. Update the 'Current Focus Area' section at the start of each major project phase.",
      tag: "Identity"
    },
    {
      name: "SESSION_LOG.md",
      location: "Project root",
      what: "Running log of every work session — what was done, what was decided, what is pending. Newest entry first. Max 20 lines per session.",
      why: "Claude starts every session knowing where you left off. No re-explaining the previous session's context.",
      howToUse: "Never write manually. The session-closer skill writes it automatically when you say 'close the session'.",
      tag: "History"
    },
    {
      name: ".claude/history/decisions.md",
      location: ".claude/history/",
      what: "Structured log of every architectural or approach decision made across sessions.",
      why: "Before making a new recommendation, Claude checks what was decided before. Prevents contradicting past decisions.",
      howToUse: "Updated automatically by session-closer. Review it when starting a new feature to check for prior art.",
      tag: "Decisions"
    },
    {
      name: ".claude/history/learnings.md",
      location: ".claude/history/",
      what: "Codebase facts, tool behaviours, and environment quirks discovered during sessions.",
      why: "Prevents re-discovering the same information. Claude knows your environment from day one.",
      howToUse: "Updated automatically by session-closer.",
      tag: "Learnings"
    },
    {
      name: ".claude/history/patterns.md",
      location: ".claude/history/",
      what: "Good/bad/watch patterns noticed across sessions — what works, what breaks, what to watch for.",
      why: "The system proposes its own improvements. Claude flags when a pattern is repeating.",
      howToUse: "Updated automatically by session-closer. Review weekly for workspace improvement suggestions.",
      tag: "Patterns"
    }
  ],
  sessionCloser: {
    trigger: "close the session",
    what: "A Claude skill that runs at the end of every work block. It writes SESSION_LOG.md, extracts decisions/learnings/patterns into .claude/history/, and flags any workspace improvements.",
    why: "This is the piece that turns a collection of files into a compounding knowledge system. Without it, you have shared files. With it, you have a system that gets smarter every session.",
    steps: [
      "Finish your work block",
      "Say: 'close the session'",
      "Claude produces structured text blocks to paste into each file",
      "Or paste them yourself — takes 30 seconds",
      "Next session, Claude reads the updated history automatically"
    ]
  },
  compound: "After ~20 sessions, .claude/history/ becomes the most valuable part of the setup. Ask Claude: 'What patterns do you see across my history?' — the system literally proposes its own improvements."
};

const frameworkGuide = {
  overview: {
    title: "What Is This Framework?",
    content: "A portable, file-based operating system for Claude Code. It uses Markdown files, shell scripts, and naming conventions to give Claude persistent memory, safety guardrails, and reusable skills across every session and every project. No database, no external API, no build step — just files that Claude reads automatically.",
    principles: [
      "Filesystem as protocol — all state lives in plain Markdown files that Claude reads natively",
      "Compounding knowledge — every session builds on previous ones via .claude/history/",
      "Portable — copy the framework folder to any machine, it works immediately",
      "Non-destructive — framework-apply never overwrites existing files",
      "Global + local — ~/.claude/CLAUDE.md activates skills everywhere, per-project CLAUDE.md overrides"
    ]
  },
  inventory: {
    title: "Full Framework Inventory",
    categories: [
      {
        name: "Skills (17)",
        path: "skills/",
        items: [
          { file: "scope-guard.md", purpose: "Prevent scope creep — touch only named files" },
          { file: "debug-first.md", purpose: "Diagnose before fixing — analyse, don't jump to solutions" },
          { file: "minimal-output.md", purpose: "Code only, no narration — cuts response length 40-60%" },
          { file: "code-review.md", purpose: "Review against org rules from CLAUDE.md" },
          { file: "change-manifest.md", purpose: "Structured change log after edits — for PRs and audit" },
          { file: "spec-to-task.md", purpose: "Convert spec file to sequenced task list" },
          { file: "output-control.md", purpose: "Exact format and length via XML tags" },
          { file: "structured-response.md", purpose: "Section-divided labeled output" },
          { file: "followup-refine.md", purpose: "Two-step: full depth then condensed version" },
          { file: "session-closer.md", purpose: "End-of-session knowledge capture + archive snapshots" },
          { file: "project-scan.md", purpose: "Scan any project → gap analysis report" },
          { file: "framework-apply.md", purpose: "Install framework components into any project" },
          { file: "healthcheck.md", purpose: "12-point PASS/WARN/FAIL diagnostic" },
          { file: "decision-log.md", purpose: "Formal Architecture Decision Records" },
          { file: "safe-cleanup-with-backup.md", purpose: "Timestamped backup before any deletion" },
          { file: "duplicate-structure-audit.md", purpose: "Find and classify exact vs divergent duplicates" },
          { file: "jsx-to-standalone-html.md", purpose: "Convert JSX to browser-runnable HTML file" }
        ]
      },
      {
        name: "Hooks (6 scripts)",
        path: "hooks/",
        items: [
          { file: "pre-tool-use.ps1 / .sh", purpose: "Blocks dangerous operations (rm -rf, force push, .env writes)" },
          { file: "post-tool-use.ps1 / .sh", purpose: "Logs all tool use for audit trail" },
          { file: "pre-compact.ps1 / .sh", purpose: "Saves session state before context compaction" }
        ]
      },
      {
        name: "Registries (3)",
        path: "registry/",
        items: [
          { file: "skills-registry.md", purpose: "Catalog of all skills with priority, stack match, category" },
          { file: "hooks-registry.md", purpose: "All hooks + settings.json template for wiring them" },
          { file: "patterns-registry.md", purpose: "Decision tree for which prompt pattern to use" }
        ]
      },
      {
        name: "Tools (2 scripts)",
        path: "tools/",
        items: [
          { file: "scan-project.ps1", purpose: "Windows project scanner — collects raw facts" },
          { file: "scan-project.sh", purpose: "Unix/macOS project scanner — same output format" }
        ]
      },
      {
        name: "Root Config Files (6)",
        path: "project root",
        items: [
          { file: "CLAUDE.md", purpose: "Persistent rules, skills list, conventions — loaded every session" },
          { file: "PROFILE.md", purpose: "User identity, working style, current focus area" },
          { file: "SESSION_LOG.md", purpose: "Running session history (newest first, max 20 lines each)" },
          { file: ".claude/history/decisions.md", purpose: "Architectural decisions across sessions" },
          { file: ".claude/history/learnings.md", purpose: "Codebase facts and discoveries" },
          { file: ".claude/history/patterns.md", purpose: "Good/bad/watch recurring patterns" }
        ]
      },
      {
        name: "Other Files",
        path: "various",
        items: [
          { file: "prompts/golden-prompts.md", purpose: "11 proven prompt templates + XML modifier table" },
          { file: "workflow/onboard-new-project.md", purpose: "Step-by-step guide: scan → review → apply → manual steps" },
          { file: "~/.claude/CLAUDE.md", purpose: "Global config — activates framework for ALL projects on this machine" }
        ]
      }
    ]
  },
  gettingStarted: {
    title: "Getting Started — Step by Step",
    steps: [
      {
        step: "1",
        name: "Copy the framework folder",
        detail: "Copy claude-framework/ to a permanent location on your machine (e.g. C:/AROG/Claude-Free/claude-framework or ~/claude-framework). This is your FRAMEWORK_PATH."
      },
      {
        step: "2",
        name: "Install the global CLAUDE.md",
        detail: "Copy the global config to ~/.claude/CLAUDE.md (on Windows: C:\\Users\\YourName\\.claude\\CLAUDE.md). Edit the FRAMEWORK_PATH line to match where you put the framework folder. This makes all skills available in every project."
      },
      {
        step: "3",
        name: "Fill in PROFILE.md",
        detail: "Open FRAMEWORK_PATH/PROFILE.md and replace all [placeholder] text with your real information: name, role, primary language, decision style, current project focus. This shapes how Claude communicates with you."
      },
      {
        step: "4",
        name: "Scan your first project",
        detail: "Open Claude Code in any project directory. Say: \"Use project-scan skill on [absolute path to project]\". Claude runs the scanner, detects the stack, and writes PROJECT_SCAN.md with a gap analysis."
      },
      {
        step: "5",
        name: "Apply the framework",
        detail: "After reviewing PROJECT_SCAN.md, say: \"Use framework-apply skill.\" Claude copies missing skills, hooks, and config files into your project. It never overwrites existing files."
      },
      {
        step: "6",
        name: "Wire the hooks",
        detail: "Create .claude/settings.json in your project (copy the template from registry/hooks-registry.md). This registers PreToolUse, PostToolUse, and PreCompact hooks so they run automatically."
      },
      {
        step: "7",
        name: "Run the healthcheck",
        detail: "Say: \"Use healthcheck skill.\" A 12-point diagnostic verifies everything is wired correctly: PASS, WARN, or FAIL per check with fix instructions."
      },
      {
        step: "8",
        name: "Start working — close every session",
        detail: "Use skills and prompts as you work. At the end of every work block, say: \"close the session\". This captures decisions, learnings, and patterns so the next session starts with full context."
      }
    ]
  },
  howToUseSkills: {
    title: "How to Use Skills",
    intro: "Skills are reusable instruction sets that live in skills/*.md. You invoke them by name — Claude reads the file and follows the instructions.",
    methods: [
      { method: "Say the trigger phrase", example: "\"Use healthcheck skill.\" or \"Use debug-first skill.\"" },
      { method: "Reference in CLAUDE.md", example: "List skills in ## Core Skills section — Claude loads them at session start and uses them automatically when context matches." },
      { method: "Chain with tasks", example: "\"Use scope-guard skill. Then fix the login bug in auth/session.ts.\" — The skill constrains how Claude approaches the task." },
      { method: "Create your own", example: "Any .md file in skills/ with a ## Trigger and ## What Claude Does section becomes an invocable skill." }
    ]
  },
  howToUseHooks: {
    title: "How to Use Hooks",
    intro: "Hooks are shell scripts that Claude Code runs automatically at specific lifecycle events. No prompt needed — they fire on every tool use.",
    hooks: [
      { name: "PreToolUse", fires: "Before Claude executes any tool", does: "Blocks dangerous operations: rm -rf, git push --force, .env writes, DROP TABLE. Logs every tool invocation.", config: "Register in .claude/settings.json under PreToolUse array." },
      { name: "PostToolUse", fires: "After Claude executes any tool", does: "Logs completed operations for audit trail. Tracks file modifications.", config: "Register in .claude/settings.json under PostToolUse array." },
      { name: "PreCompact", fires: "Before Claude compresses conversation context", does: "Saves current session state (last SESSION_LOG entry, key facts) so nothing is lost during compaction.", config: "Register in .claude/settings.json under PreCompact array." }
    ]
  },
  howToUsePrompts: {
    title: "How to Use Prompt Templates",
    intro: "Golden Prompts are proven templates for common tasks. Copy the template, fill in the brackets, and send. The four elements of every good prompt: SCOPE, ACTION, FENCE, OUTPUT.",
    categories: [
      { category: "Code Changes", prompts: "Surgical Edit, Refactor Boundary" },
      { category: "Planning", prompts: "Plan Gate, Spec-First Build" },
      { category: "Analysis", prompts: "Diagnosis First, Constraint Check" },
      { category: "Output Shape", prompts: "Output Contract, Explicit Format + Length, Section-Divided Output, Depth-Then-Condense" },
      { category: "Post-work", prompts: "Change Log" }
    ],
    xmlTags: "Use XML modifier tags (<format>, <length>, <sections>, <role>, <task>) to control Claude's output precisely. These override all default output settings."
  },
  scannerGuide: {
    title: "Scanning New Projects",
    intro: "The project scanner detects any project's stack and compares it against the full framework inventory. It produces a gap report showing what exists, what is missing, and what to install.",
    steps: [
      "Say: \"Use project-scan skill on [absolute path]\"",
      "Scanner runs tools/scan-project.ps1 (Windows) or .sh (Unix)",
      "Writes PROJECT_SCAN_RAW.md with raw facts: git status, file extensions, manifests, existing AI configs",
      "Claude reads raw data + registries → writes PROJECT_SCAN.md with prioritised gap analysis",
      "Review the report, then say: \"Use framework-apply skill.\" to install missing components",
      "Framework-apply NEVER overwrites — existing files are skipped and logged"
    ]
  },
  maintenance: {
    title: "Healthcheck and Maintenance",
    intro: "Run the healthcheck periodically to catch issues before they degrade your sessions.",
    checks: [
      "PROFILE.md filled in (no placeholders)",
      "SESSION_LOG.md exists and is fresh (last entry < 7 days)",
      ".claude/history/ files present (decisions, learnings, patterns)",
      "Skills directory populated (>= 5 skills)",
      "Hook scripts present (PS1 + SH pairs for all 3 hooks)",
      "settings.json wired (hooks registered)",
      "CLAUDE.md has Session Startup section",
      "Registries populated",
      "Scanner tools present",
      "Archive snapshots healthy (1-10, not over cap)",
      "No orphan placeholders in skills/"
    ],
    trigger: "Say: \"Use healthcheck skill.\" — runs all 12 checks, never stops on failure."
  },
  importantNotes: {
    title: "Things to Note",
    notes: [
      { note: "Always close your sessions", detail: "Say \"close the session\" at the end of every work block. This is how knowledge compounds. Without it, every session resets to zero." },
      { note: "CLAUDE.md is the most important file", detail: "It loads first, every session. It defines what Claude can and cannot do. Keep it concise — every line costs tokens on every task." },
      { note: "Skills replace repeated instructions", detail: "If you find yourself giving the same instruction twice, write a skill. One-time cost, infinite reuse." },
      { note: "Hooks run silently", detail: "Once wired in settings.json, hooks fire on every tool use without any prompt. They are your safety net." },
      { note: "Global config cannot be overridden for security", detail: "The security floor in ~/.claude/CLAUDE.md (no .env writes, no rm -rf, no force push) applies in every project, always." },
      { note: "Never overwrite files blindly", detail: "framework-apply skips existing files. If you need to update a skill, delete the old one first or merge manually." },
      { note: "The scanner works on ANY project", detail: "Python, Go, Rust, Java, TypeScript — the scanner detects stack from file extensions and manifests. Not Claude-specific." },
      { note: ".claudeignore saves tokens", detail: "Exclude node_modules, build output, large data files. Files Claude cannot see, it cannot hallucinate about." },
      { note: "Archive snapshots are capped at 10", detail: "session-closer creates a snapshot of .claude/history/ after each close. Older than 10 are pruned automatically." },
      { note: "PROFILE.md shapes Claude's tone", detail: "Fill it in once. Update the Current Focus Area when you switch projects. Claude writes as you, not as a generic assistant." }
    ]
  },
  quickRef: {
    title: "Quick Reference Commands",
    commands: [
      { cmd: "Use project-scan skill on [path]", does: "Scan any project and produce a gap analysis" },
      { cmd: "Use framework-apply skill.", does: "Install missing framework components into current project" },
      { cmd: "Use healthcheck skill.", does: "Run 12-point diagnostic on framework health" },
      { cmd: "close the session", does: "Capture decisions, learnings, patterns — update all history files" },
      { cmd: "Use debug-first skill.", does: "Diagnose a bug before fixing it" },
      { cmd: "Use scope-guard skill.", does: "Constrain Claude to only touch named files" },
      { cmd: "Use decision-log skill.", does: "Log an Architecture Decision Record" },
      { cmd: "Use code-review skill.", does: "Review code against CLAUDE.md rules" },
      { cmd: "Use output-control skill.", does: "Control exact format and length via XML tags" },
      { cmd: "Use minimal-output skill.", does: "Code only — no explanations, no narration" },
      { cmd: "Use safe-cleanup-with-backup skill.", does: "Backup before any destructive deletion" }
    ]
  }
};

function CopyButton({ text }) {
  const [copied, setCopied] = useState(false);
  const copy = () => {
    navigator.clipboard.writeText(text);
    setCopied(true);
    setTimeout(() => setCopied(false), 1500);
  };
  return (
    <button onClick={copy} style={{
      background: copied ? "#1a3a2a" : "#1e2a1e",
      color: copied ? "#4ade80" : "#6b7280",
      border: `1px solid ${copied ? "#4ade80" : "#2a3a2a"}`,
      borderRadius: 4, padding: "3px 10px", fontSize: 11,
      cursor: "pointer", transition: "all 0.2s", fontFamily: "monospace"
    }}>
      {copied ? "✓ copied" : "copy"}
    </button>
  );
}

function Tag({ label, color }) {
  const colors = {
    green: { bg: "#0d2a1a", text: "#4ade80", border: "#1a4a2a" },
    red: { bg: "#2a0d0d", text: "#f87171", border: "#4a1a1a" },
    amber: { bg: "#2a1f0d", text: "#fbbf24", border: "#4a3a1a" },
    blue: { bg: "#0d1a2a", text: "#60a5fa", border: "#1a2a4a" }
  };
  const c = colors[color] || colors.blue;
  return (
    <span style={{ background: c.bg, color: c.text, border: `1px solid ${c.border}`, borderRadius: 3, padding: "1px 7px", fontSize: 10, fontFamily: "monospace", fontWeight: 600 }}>
      {label}
    </span>
  );
}

export default function Framework() {
  const [active, setActive] = useState("Mental Model");
  const [expandedPrompt, setExpandedPrompt] = useState(null);
  const [expandedSkill, setExpandedSkill] = useState(null);
  const [showExample, setShowExample] = useState({});

  const bg = "#0a0f0a";
  const surface = "#111811";
  const surface2 = "#161e16";
  const border = "#1e2e1e";
  const accent = "#4ade80";
  const textPrimary = "#e2f0e2";
  const textSecondary = "#6b8a6b";
  const textMuted = "#3d5a3d";
  const mono = "'JetBrains Mono', 'Fira Code', 'Courier New', monospace";
  const sans = "'Inter', system-ui, sans-serif";

  return (
    <div style={{ background: bg, minHeight: "100vh", color: textPrimary, fontFamily: sans, fontSize: 13 }}>
      {/* Header */}
      <div style={{ borderBottom: `1px solid ${border}`, padding: "20px 28px 16px", background: surface }}>
        <div style={{ display: "flex", alignItems: "baseline", gap: 12 }}>
          <span style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 3 }}>MASTER FRAMEWORK</span>
          <span style={{ color: textMuted, fontSize: 10 }}>v2.0</span>
        </div>
        <h1 style={{ margin: "4px 0 0", fontSize: 22, fontWeight: 700, color: textPrimary, letterSpacing: -0.5 }}>
          Working with Claude
        </h1>
        <p style={{ margin: "4px 0 0", color: textSecondary, fontSize: 12 }}>
          Your daily reference for prompts, skills, workflow and token discipline
        </p>
      </div>

      {/* Nav */}
      <div style={{ display: "flex", gap: 0, borderBottom: `1px solid ${border}`, background: surface, overflowX: "auto" }}>
        {SECTIONS.map(s => (
          <button key={s} onClick={() => setActive(s)} style={{
            background: active === s ? surface2 : "transparent",
            color: active === s ? accent : textSecondary,
            border: "none",
            borderBottom: active === s ? `2px solid ${accent}` : "2px solid transparent",
            padding: "10px 16px", fontSize: 11, cursor: "pointer",
            fontFamily: mono, letterSpacing: 0.5, whiteSpace: "nowrap",
            transition: "all 0.15s"
          }}>{s}</button>
        ))}
      </div>

      <div style={{ padding: "24px 28px", maxWidth: 900 }}>

        {/* MENTAL MODEL */}
        {active === "Mental Model" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
            {mentalModel.map((section, i) => (
              <div key={i} style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 20 }}>
                <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 10 }}>
                  {section.title.toUpperCase()}
                </div>
                {section.content && (
                  <p style={{ color: textPrimary, lineHeight: 1.7, margin: 0, fontSize: 14 }}>{section.content}</p>
                )}
                {section.items && (
                  <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                    {section.items.map((item, j) => (
                      <div key={j} style={{ display: "flex", gap: 14, padding: "10px 14px", background: surface2, borderRadius: 4, border: `1px solid ${border}` }}>
                        <span style={{ fontFamily: mono, color: accent, fontSize: 12, minWidth: 140, fontWeight: 600 }}>{item.label}</span>
                        <span style={{ color: textSecondary, fontSize: 12, lineHeight: 1.5 }}>{item.desc}</span>
                      </div>
                    ))}
                  </div>
                )}
                {section.note && (
                  <div style={{ marginTop: 14, padding: "10px 14px", background: "#0d2a1a", border: `1px solid #1a4a2a`, borderRadius: 4 }}>
                    <span style={{ color: "#4ade80", fontSize: 12, lineHeight: 1.6 }}>→ {section.note}</span>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}

        {/* WHAT I NEED FROM YOU */}
        {active === "What I Need From You" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
            {whatINeed.map((group, i) => {
              const colors = { green: { accent: "#4ade80", bg: "#0d2a1a", border: "#1a4a2a" }, red: { accent: "#f87171", bg: "#2a0d0d", border: "#4a1a1a" }, amber: { accent: "#fbbf24", bg: "#2a1f0d", border: "#4a3a1a" } };
              const c = colors[group.color];
              return (
                <div key={i} style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 20 }}>
                  <div style={{ fontFamily: mono, color: c.accent, fontSize: 11, letterSpacing: 2, marginBottom: 14 }}>{group.category.toUpperCase()}</div>
                  <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                    {group.items.map((item, j) => (
                      <div key={j} style={{ display: "flex", gap: 10, alignItems: "flex-start", padding: "8px 12px", background: c.bg, border: `1px solid ${c.border}`, borderRadius: 4 }}>
                        <span style={{ color: c.accent, fontSize: 11, marginTop: 1 }}>▸</span>
                        <span style={{ color: textPrimary, fontSize: 13, lineHeight: 1.5 }}>{item}</span>
                      </div>
                    ))}
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* GOLDEN PROMPTS */}
        {active === "Golden Prompts" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
            <p style={{ color: textSecondary, fontSize: 12, margin: "0 0 8px" }}>Click any prompt to expand. Use the copy buttons to pull templates directly into your work.</p>
            {goldenPrompts.map((p, i) => (
              <div key={i} style={{ background: surface, border: `1px solid ${expandedPrompt === i ? accent : border}`, borderRadius: 6, overflow: "hidden", transition: "border 0.15s" }}>
                <div onClick={() => setExpandedPrompt(expandedPrompt === i ? null : i)}
                  style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "14px 18px", cursor: "pointer" }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
                    <span style={{ fontFamily: mono, color: accent, fontSize: 13, fontWeight: 700 }}>{p.name}</span>
                    <span style={{ color: textMuted, fontSize: 11 }}>— {p.use}</span>
                  </div>
                  <span style={{ color: textMuted, fontSize: 12 }}>{expandedPrompt === i ? "▲" : "▼"}</span>
                </div>
                {expandedPrompt === i && (
                  <div style={{ padding: "0 18px 18px", display: "flex", flexDirection: "column", gap: 14 }}>
                    <div>
                      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8 }}>
                        <span style={{ fontFamily: mono, color: textSecondary, fontSize: 10, letterSpacing: 1 }}>TEMPLATE</span>
                        <CopyButton text={p.template} />
                      </div>
                      <pre style={{ background: surface2, border: `1px solid ${border}`, borderRadius: 4, padding: 14, margin: 0, fontFamily: mono, fontSize: 12, color: textPrimary, lineHeight: 1.7, whiteSpace: "pre-wrap", overflowX: "auto" }}>{p.template}</pre>
                    </div>
                    <div>
                      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8 }}>
                        <button onClick={() => setShowExample(prev => ({ ...prev, [i]: !prev[i] }))}
                          style={{ background: "transparent", border: "none", color: textSecondary, fontSize: 11, cursor: "pointer", fontFamily: mono, padding: 0 }}>
                          {showExample[i] ? "▼ hide example" : "▶ show example"}
                        </button>
                        {showExample[i] && <CopyButton text={p.example} />}
                      </div>
                      {showExample[i] && (
                        <pre style={{ background: "#0d1a0d", border: `1px solid #1a3a1a`, borderRadius: 4, padding: 14, margin: 0, fontFamily: mono, fontSize: 12, color: "#86efac", lineHeight: 1.7, whiteSpace: "pre-wrap" }}>{p.example}</pre>
                      )}
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}

        {/* GOLDEN SKILLS */}
        {active === "Golden Skills" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
            <p style={{ color: textSecondary, fontSize: 12, margin: "0 0 8px" }}>Each skill is a standing instruction. Write it once. Every task in scope gets it automatically.</p>
            {goldenSkills.map((s, i) => (
              <div key={i} style={{ background: surface, border: `1px solid ${expandedSkill === i ? accent : border}`, borderRadius: 6, overflow: "hidden", transition: "border 0.15s" }}>
                <div onClick={() => setExpandedSkill(expandedSkill === i ? null : i)}
                  style={{ display: "flex", alignItems: "center", justifyContent: "space-between", padding: "14px 18px", cursor: "pointer" }}>
                  <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
                    <span style={{ fontFamily: mono, color: accent, fontSize: 13, fontWeight: 700 }}>{s.name}</span>
                    <Tag label={s.trigger} color="blue" />
                  </div>
                  <span style={{ color: textMuted, fontSize: 12 }}>{expandedSkill === i ? "▲" : "▼"}</span>
                </div>
                {expandedSkill === i && (
                  <div style={{ padding: "0 18px 18px", display: "flex", flexDirection: "column", gap: 14 }}>
                    <div style={{ padding: "8px 12px", background: "#0d1a2a", border: "1px solid #1a2a4a", borderRadius: 4 }}>
                      <span style={{ color: "#60a5fa", fontSize: 12 }}>Why a skill and not a prompt: </span>
                      <span style={{ color: textSecondary, fontSize: 12 }}>{s.why}</span>
                    </div>
                    <div>
                      <div style={{ display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 8 }}>
                        <span style={{ fontFamily: mono, color: textSecondary, fontSize: 10, letterSpacing: 1 }}>SKILL CORE INSTRUCTION</span>
                        <CopyButton text={s.instruction} />
                      </div>
                      <pre style={{ background: surface2, border: `1px solid ${border}`, borderRadius: 4, padding: 14, margin: 0, fontFamily: mono, fontSize: 12, color: textPrimary, lineHeight: 1.7, whiteSpace: "pre-wrap" }}>{s.instruction}</pre>
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}

        {/* SESSION MEMORY */}
        {active === "Session Memory" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 20 }}>
            <div style={{ padding: "12px 16px", background: "#0d1a2a", border: "1px solid #1a2a4a", borderRadius: 6 }}>
              <p style={{ color: "#60a5fa", fontSize: 13, lineHeight: 1.7, margin: 0 }}>{sessionMemory.purpose}</p>
            </div>

            {/* Files */}
            <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2 }}>PERSISTENT CONTEXT FILES</div>
            {sessionMemory.files.map((f, i) => (
              <div key={i} style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 18 }}>
                <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 10 }}>
                  <span style={{ fontFamily: mono, color: accent, fontSize: 13, fontWeight: 700 }}>{f.name}</span>
                  <span style={{ background: "#0d1a2a", color: "#60a5fa", border: "1px solid #1a2a4a", borderRadius: 3, padding: "1px 7px", fontSize: 10, fontFamily: mono }}>{f.tag}</span>
                  <span style={{ color: textMuted, fontSize: 11 }}>{f.location}</span>
                </div>
                <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                  <div style={{ display: "flex", gap: 10, padding: "8px 12px", background: surface2, borderRadius: 4, border: `1px solid ${border}` }}>
                    <span style={{ fontFamily: mono, color: textMuted, fontSize: 10, minWidth: 36, marginTop: 1 }}>WHAT</span>
                    <span style={{ color: textPrimary, fontSize: 12, lineHeight: 1.5 }}>{f.what}</span>
                  </div>
                  <div style={{ display: "flex", gap: 10, padding: "8px 12px", background: "#0d1a0d", borderRadius: 4, border: "1px solid #1a3a1a" }}>
                    <span style={{ fontFamily: mono, color: textMuted, fontSize: 10, minWidth: 36, marginTop: 1 }}>WHY</span>
                    <span style={{ color: "#86efac", fontSize: 12, lineHeight: 1.5 }}>{f.why}</span>
                  </div>
                  <div style={{ display: "flex", gap: 10, padding: "8px 12px", background: "#1a1a0d", borderRadius: 4, border: "1px solid #3a3a1a" }}>
                    <span style={{ fontFamily: mono, color: textMuted, fontSize: 10, minWidth: 36, marginTop: 1 }}>HOW</span>
                    <span style={{ color: "#fde68a", fontSize: 12, lineHeight: 1.5 }}>{f.howToUse}</span>
                  </div>
                </div>
              </div>
            ))}

            {/* Session Closer */}
            <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginTop: 4 }}>THE SESSION CLOSER</div>
            <div style={{ background: surface, border: `1px solid ${accent}`, borderRadius: 6, padding: 18 }}>
              <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 14 }}>
                <span style={{ fontFamily: mono, color: accent, fontSize: 13, fontWeight: 700 }}>session-closer</span>
                <span style={{ background: "#0d2a1a", color: accent, border: "1px solid #1a4a2a", borderRadius: 3, padding: "1px 7px", fontSize: 10, fontFamily: mono }}>Invoke: "close the session"</span>
              </div>
              <p style={{ color: textSecondary, fontSize: 12, lineHeight: 1.6, margin: "0 0 14px" }}>{sessionMemory.sessionCloser.what}</p>
              <div style={{ padding: "10px 14px", background: "#0d1a2a", border: "1px solid #1a2a4a", borderRadius: 4, marginBottom: 14 }}>
                <span style={{ color: "#60a5fa", fontSize: 12 }}>Why this is the most important skill: </span>
                <span style={{ color: textSecondary, fontSize: 12 }}>{sessionMemory.sessionCloser.why}</span>
              </div>
              <div style={{ fontFamily: mono, color: textMuted, fontSize: 10, letterSpacing: 1, marginBottom: 8 }}>HOW TO USE</div>
              <div style={{ display: "flex", flexDirection: "column", gap: 5 }}>
                {sessionMemory.sessionCloser.steps.map((s, i) => (
                  <div key={i} style={{ display: "flex", gap: 10, alignItems: "flex-start" }}>
                    <span style={{ fontFamily: mono, color: textMuted, fontSize: 11, minWidth: 18 }}>{i + 1}.</span>
                    <span style={{ color: textPrimary, fontSize: 12 }}>{s}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Compound effect */}
            <div style={{ padding: "14px 18px", background: "#0d2a1a", border: "1px solid #1a4a2a", borderRadius: 6 }}>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 8 }}>THE COMPOUND EFFECT</div>
              <p style={{ color: "#86efac", fontSize: 14, lineHeight: 1.7, margin: 0 }}>{sessionMemory.compound}</p>
            </div>
          </div>
        )}

        {/* DAILY WORKFLOW */}
        {active === "Daily Workflow" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
            {dailyWorkflow.map((phase, i) => (
              <div key={i} style={{ display: "flex", gap: 18 }}>
                <div style={{ display: "flex", flexDirection: "column", alignItems: "center", gap: 0 }}>
                  <div style={{ width: 32, height: 32, borderRadius: "50%", background: surface2, border: `2px solid ${accent}`, display: "flex", alignItems: "center", justifyContent: "center", fontFamily: mono, color: accent, fontSize: 13, fontWeight: 700, flexShrink: 0 }}>{phase.step}</div>
                  {i < dailyWorkflow.length - 1 && <div style={{ width: 1, flex: 1, background: border, marginTop: 4 }} />}
                </div>
                <div style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 16, flex: 1, marginBottom: i < dailyWorkflow.length - 1 ? 0 : 0 }}>
                  <div style={{ fontFamily: mono, color: accent, fontSize: 12, fontWeight: 600, marginBottom: 12 }}>{phase.phase}</div>
                  <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                    {phase.actions.map((a, j) => (
                      <div key={j} style={{ display: "flex", gap: 8, alignItems: "flex-start" }}>
                        <span style={{ color: textMuted, fontSize: 11, marginTop: 2, flexShrink: 0 }}>□</span>
                        <span style={{ color: textPrimary, fontSize: 13, lineHeight: 1.5 }}>{a}</span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* PROJECT SETUP */}
        {active === "Project Setup" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
            <p style={{ color: textSecondary, fontSize: 12, margin: "0 0 8px" }}>Run this checklist at the start of every project. Non-destructive additions only.</p>
            {projectSetup.map((p, i) => (
              <div key={i} style={{ display: "flex", gap: 14, padding: "12px 16px", background: surface, border: `1px solid ${border}`, borderRadius: 6, alignItems: "flex-start" }}>
                <span style={{ color: accent, fontSize: 13, marginTop: 1, flexShrink: 0 }}>◆</span>
                <div>
                  <div style={{ fontFamily: mono, color: accent, fontSize: 12, fontWeight: 600, marginBottom: 4 }}>{p.item}</div>
                  <div style={{ color: textSecondary, fontSize: 12, lineHeight: 1.5 }}>{p.detail}</div>
                </div>
              </div>
            ))}
          </div>
        )}

        {/* TOKEN DISCIPLINE */}
        {active === "Token Discipline" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 12 }}>
            <p style={{ color: textSecondary, fontSize: 12, margin: "0 0 8px" }}>Token cost is a direct function of prompt quality. These rules cut cost without cutting quality.</p>
            <div style={{ display: "grid", gap: 8 }}>
              {tokenRules.map((r, i) => {
                const savingColor = r.saving === "High" ? { bg: "#0d2a1a", text: "#4ade80", border: "#1a4a2a" } : { bg: "#2a1f0d", text: "#fbbf24", border: "#4a3a1a" };
                return (
                  <div key={i} style={{ display: "flex", gap: 14, padding: "12px 16px", background: surface, border: `1px solid ${border}`, borderRadius: 6, alignItems: "flex-start" }}>
                    <div style={{ display: "flex", alignItems: "center", flexShrink: 0, gap: 12 }}>
                      <span style={{ fontFamily: mono, color: textMuted, fontSize: 11 }}>{String(i + 1).padStart(2, "0")}</span>
                      <span style={{ background: savingColor.bg, color: savingColor.text, border: `1px solid ${savingColor.border}`, borderRadius: 3, padding: "2px 7px", fontSize: 10, fontFamily: mono, fontWeight: 600, width: 52, textAlign: "center" }}>{r.saving}</span>
                    </div>
                    <div>
                      <div style={{ color: textPrimary, fontSize: 13, fontWeight: 600, marginBottom: 3 }}>{r.rule}</div>
                      <div style={{ color: textSecondary, fontSize: 12 }}>{r.why}</div>
                    </div>
                  </div>
                );
              })}
            </div>
            <div style={{ marginTop: 8, padding: "14px 18px", background: "#0d2a1a", border: "1px solid #1a4a2a", borderRadius: 6 }}>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 8 }}>THE MASTER PRINCIPLE</div>
              <p style={{ color: "#86efac", fontSize: 14, lineHeight: 1.7, margin: 0 }}>
                Move as much intelligence as possible into persistent context — CLAUDE.md, skills, hooks — so your per-task prompts become tiny, cheap, and precise. The best prompt is the one that requires the least explanation because everything structural is already loaded.
              </p>
            </div>
          </div>
        )}

        {/* FRAMEWORK GUIDE */}
        {active === "Framework Guide" && (
          <div style={{ display: "flex", flexDirection: "column", gap: 24 }}>

            {/* Overview */}
            <div style={{ background: surface, border: `1px solid ${accent}`, borderRadius: 6, padding: 20 }}>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 10 }}>{frameworkGuide.overview.title.toUpperCase()}</div>
              <p style={{ color: textPrimary, fontSize: 14, lineHeight: 1.7, margin: "0 0 16px" }}>{frameworkGuide.overview.content}</p>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                {frameworkGuide.overview.principles.map((p, i) => (
                  <div key={i} style={{ display: "flex", gap: 10, alignItems: "flex-start", padding: "6px 12px", background: "#0d2a1a", border: "1px solid #1a4a2a", borderRadius: 4 }}>
                    <span style={{ color: accent, fontSize: 11, marginTop: 2 }}>▸</span>
                    <span style={{ color: "#86efac", fontSize: 12, lineHeight: 1.5 }}>{p}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Full Inventory */}
            <div>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 14 }}>{frameworkGuide.inventory.title.toUpperCase()}</div>
              <div style={{ display: "flex", flexDirection: "column", gap: 16 }}>
                {frameworkGuide.inventory.categories.map((cat, i) => (
                  <div key={i} style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 18 }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 12 }}>
                      <span style={{ fontFamily: mono, color: accent, fontSize: 12, fontWeight: 700 }}>{cat.name}</span>
                      <span style={{ color: textMuted, fontSize: 11 }}>{cat.path}</span>
                    </div>
                    <div style={{ display: "flex", flexDirection: "column", gap: 4 }}>
                      {cat.items.map((item, j) => (
                        <div key={j} style={{ display: "flex", gap: 14, padding: "6px 12px", background: surface2, borderRadius: 4, border: `1px solid ${border}` }}>
                          <span style={{ fontFamily: mono, color: "#60a5fa", fontSize: 11, minWidth: 200, flexShrink: 0 }}>{item.file}</span>
                          <span style={{ color: textSecondary, fontSize: 12, lineHeight: 1.4 }}>{item.purpose}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* Getting Started */}
            <div>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 14 }}>{frameworkGuide.gettingStarted.title.toUpperCase()}</div>
              <div style={{ display: "flex", flexDirection: "column", gap: 14 }}>
                {frameworkGuide.gettingStarted.steps.map((s, i) => (
                  <div key={i} style={{ display: "flex", gap: 18 }}>
                    <div style={{ width: 32, height: 32, borderRadius: "50%", background: surface2, border: `2px solid ${accent}`, display: "flex", alignItems: "center", justifyContent: "center", fontFamily: mono, color: accent, fontSize: 13, fontWeight: 700, flexShrink: 0 }}>{s.step}</div>
                    <div style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 14, flex: 1 }}>
                      <div style={{ fontFamily: mono, color: accent, fontSize: 12, fontWeight: 600, marginBottom: 6 }}>{s.name}</div>
                      <div style={{ color: textSecondary, fontSize: 12, lineHeight: 1.6 }}>{s.detail}</div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            {/* How to Use Skills */}
            <div style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 20 }}>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 8 }}>{frameworkGuide.howToUseSkills.title.toUpperCase()}</div>
              <p style={{ color: textSecondary, fontSize: 12, lineHeight: 1.6, margin: "0 0 14px" }}>{frameworkGuide.howToUseSkills.intro}</p>
              <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                {frameworkGuide.howToUseSkills.methods.map((m, i) => (
                  <div key={i} style={{ padding: "10px 14px", background: surface2, border: `1px solid ${border}`, borderRadius: 4 }}>
                    <div style={{ fontFamily: mono, color: textPrimary, fontSize: 12, fontWeight: 600, marginBottom: 4 }}>{m.method}</div>
                    <div style={{ color: textSecondary, fontSize: 12, lineHeight: 1.5 }}>{m.example}</div>
                  </div>
                ))}
              </div>
            </div>

            {/* How to Use Hooks */}
            <div style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 20 }}>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 8 }}>{frameworkGuide.howToUseHooks.title.toUpperCase()}</div>
              <p style={{ color: textSecondary, fontSize: 12, lineHeight: 1.6, margin: "0 0 14px" }}>{frameworkGuide.howToUseHooks.intro}</p>
              <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
                {frameworkGuide.howToUseHooks.hooks.map((h, i) => (
                  <div key={i} style={{ padding: "12px 16px", background: surface2, border: `1px solid ${border}`, borderRadius: 4 }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 10, marginBottom: 8 }}>
                      <span style={{ fontFamily: mono, color: accent, fontSize: 12, fontWeight: 700 }}>{h.name}</span>
                      <span style={{ color: textMuted, fontSize: 11 }}>{h.fires}</span>
                    </div>
                    <div style={{ color: textPrimary, fontSize: 12, lineHeight: 1.5, marginBottom: 6 }}>{h.does}</div>
                    <div style={{ color: "#fbbf24", fontSize: 11 }}>{h.config}</div>
                  </div>
                ))}
              </div>
            </div>

            {/* How to Use Prompts */}
            <div style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 20 }}>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 8 }}>{frameworkGuide.howToUsePrompts.title.toUpperCase()}</div>
              <p style={{ color: textSecondary, fontSize: 12, lineHeight: 1.6, margin: "0 0 14px" }}>{frameworkGuide.howToUsePrompts.intro}</p>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                {frameworkGuide.howToUsePrompts.categories.map((c, i) => (
                  <div key={i} style={{ display: "flex", gap: 14, padding: "8px 14px", background: surface2, borderRadius: 4, border: `1px solid ${border}` }}>
                    <span style={{ fontFamily: mono, color: accent, fontSize: 11, minWidth: 110, fontWeight: 600 }}>{c.category}</span>
                    <span style={{ color: textSecondary, fontSize: 12 }}>{c.prompts}</span>
                  </div>
                ))}
              </div>
              <div style={{ marginTop: 12, padding: "8px 14px", background: "#2a1f0d", border: "1px solid #4a3a1a", borderRadius: 4 }}>
                <span style={{ color: "#fbbf24", fontSize: 12 }}>{frameworkGuide.howToUsePrompts.xmlTags}</span>
              </div>
            </div>

            {/* Scanning New Projects */}
            <div style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 20 }}>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 8 }}>{frameworkGuide.scannerGuide.title.toUpperCase()}</div>
              <p style={{ color: textSecondary, fontSize: 12, lineHeight: 1.6, margin: "0 0 14px" }}>{frameworkGuide.scannerGuide.intro}</p>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                {frameworkGuide.scannerGuide.steps.map((s, i) => (
                  <div key={i} style={{ display: "flex", gap: 10, alignItems: "flex-start", padding: "6px 12px", background: surface2, borderRadius: 4, border: `1px solid ${border}` }}>
                    <span style={{ fontFamily: mono, color: accent, fontSize: 11, marginTop: 1, minWidth: 16 }}>{i + 1}.</span>
                    <span style={{ color: textPrimary, fontSize: 12, lineHeight: 1.5 }}>{s}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Healthcheck & Maintenance */}
            <div style={{ background: surface, border: `1px solid ${border}`, borderRadius: 6, padding: 20 }}>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 8 }}>{frameworkGuide.maintenance.title.toUpperCase()}</div>
              <p style={{ color: textSecondary, fontSize: 12, lineHeight: 1.6, margin: "0 0 12px" }}>{frameworkGuide.maintenance.intro}</p>
              <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 6 }}>
                {frameworkGuide.maintenance.checks.map((c, i) => (
                  <div key={i} style={{ display: "flex", gap: 8, alignItems: "flex-start", padding: "6px 10px", background: surface2, borderRadius: 4, border: `1px solid ${border}` }}>
                    <span style={{ fontFamily: mono, color: textMuted, fontSize: 10, marginTop: 2, minWidth: 16 }}>{String(i + 1).padStart(2, "0")}</span>
                    <span style={{ color: textPrimary, fontSize: 11, lineHeight: 1.4 }}>{c}</span>
                  </div>
                ))}
              </div>
              <div style={{ marginTop: 10, padding: "8px 14px", background: "#0d2a1a", border: "1px solid #1a4a2a", borderRadius: 4 }}>
                <span style={{ color: accent, fontSize: 12, fontFamily: mono }}>{frameworkGuide.maintenance.trigger}</span>
              </div>
            </div>

            {/* Things to Note */}
            <div>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 14 }}>{frameworkGuide.importantNotes.title.toUpperCase()}</div>
              <div style={{ display: "flex", flexDirection: "column", gap: 8 }}>
                {frameworkGuide.importantNotes.notes.map((n, i) => (
                  <div key={i} style={{ padding: "12px 16px", background: surface, border: `1px solid ${border}`, borderRadius: 6 }}>
                    <div style={{ fontFamily: mono, color: "#fbbf24", fontSize: 12, fontWeight: 600, marginBottom: 4 }}>{n.note}</div>
                    <div style={{ color: textSecondary, fontSize: 12, lineHeight: 1.5 }}>{n.detail}</div>
                  </div>
                ))}
              </div>
            </div>

            {/* Quick Reference */}
            <div style={{ background: surface, border: `1px solid ${accent}`, borderRadius: 6, padding: 20 }}>
              <div style={{ fontFamily: mono, color: accent, fontSize: 11, letterSpacing: 2, marginBottom: 14 }}>{frameworkGuide.quickRef.title.toUpperCase()}</div>
              <div style={{ display: "flex", flexDirection: "column", gap: 6 }}>
                {frameworkGuide.quickRef.commands.map((c, i) => (
                  <div key={i} style={{ display: "flex", gap: 14, padding: "8px 14px", background: surface2, borderRadius: 4, border: `1px solid ${border}`, alignItems: "flex-start" }}>
                    <div style={{ display: "flex", alignItems: "center", gap: 8, minWidth: 340, flexShrink: 0 }}>
                      <span style={{ fontFamily: mono, color: accent, fontSize: 11 }}>{c.cmd}</span>
                      <CopyButton text={c.cmd} />
                    </div>
                    <span style={{ color: textSecondary, fontSize: 12 }}>{c.does}</span>
                  </div>
                ))}
              </div>
            </div>

          </div>
        )}
      </div>
    </div>
  );
}
