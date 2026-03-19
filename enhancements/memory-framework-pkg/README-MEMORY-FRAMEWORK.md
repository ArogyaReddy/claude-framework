# Memory Framework — Installation Guide
# Zero-configuration persistent memory for Claude Code.

## What This Is

A three-file memory system + three slash commands + one hook that gives Claude Code
persistent memory across sessions — without relying on Claude's context window.

## File Map

```
your-project/
├── SCRATCHPAD.md              ← Rolling current-session state
├── DECISIONS.md               ← Permanent decision log (never truncated)
├── SESSIONS.md                ← Lightweight audit trail
├── CLAUDE-MD-ADDITION.md      ← Paste this block into your CLAUDE.md
└── .claude/
    ├── commands/
    │   ├── resume.md          ← /resume — session start ritual
    │   ├── wrap.md            ← /wrap   — session end ritual
    │   └── decide.md          ← /decide — log a decision mid-session
    └── hooks/
        └── post-session.sh    ← Auto-wrap on session end (optional)
```

## Installation — 5 Steps

### Step 1 — Copy files to your project root
```bash
cp SCRATCHPAD.md   /your-project/
cp DECISIONS.md    /your-project/
cp SESSIONS.md     /your-project/
```

### Step 2 — Copy commands to .claude/commands/
```bash
mkdir -p /your-project/.claude/commands
cp .claude/commands/resume.md  /your-project/.claude/commands/
cp .claude/commands/wrap.md    /your-project/.claude/commands/
cp .claude/commands/decide.md  /your-project/.claude/commands/
```

### Step 3 — Add hook (optional — for auto-wrap)
```bash
mkdir -p /your-project/.claude/hooks
cp .claude/hooks/post-session.sh /your-project/.claude/hooks/
chmod +x /your-project/.claude/hooks/post-session.sh
```

### Step 4 — Update your CLAUDE.md
Open CLAUDE-MD-ADDITION.md, copy the entire block,
paste it into your existing CLAUDE.md.

### Step 5 — Fill in SCRATCHPAD.md
Open SCRATCHPAD.md and fill in the "What We're Building" section.
That's the only section you need to fill manually — everything else
gets written by Claude via /wrap.

---

## Daily Usage

### Starting a session
```
/resume
```
Claude reads all memory files, outputs a brief, waits for your confirmation.
Costs ~600-900 tokens. Saves 3,000-6,000 tokens of re-explanation.

### During a session — when a decision is made
```
/decide
```
Claude logs it to DECISIONS.md immediately while context is fresh.
Costs ~200 tokens. Prevents the same decision being re-litigated in 3 months.

### Ending a session
```
/wrap
```
Claude updates SCRATCHPAD.md, DECISIONS.md, SESSIONS.md.
Costs ~500-800 tokens. Makes the next session start in 10 seconds.

---

## Token Cost Summary

| Action | Cost | Saves |
|--------|------|-------|
| /resume at session start | ~700 tokens | ~5,000 tokens of re-explanation |
| /wrap at session end | ~650 tokens | ~5,000 tokens next session |
| /decide mid-session | ~200 tokens | Hours of re-litigation later |
| Net per session pair | ~1,350 tokens | ~10,000 tokens |
| **Net saving ratio** | | **~7:1** |

The framework pays for itself in the first session.

---

## Maintenance Rules

- SCRATCHPAD.md: Keep under 300 lines. Claude summarises on /wrap if it grows.
- DECISIONS.md: Never delete entries. Mark as [REVERSED] if overturned.
- SESSIONS.md: Never edit manually. Append-only via /wrap.
- CLAUDE.md: Surface suggestions via /wrap. Never auto-edited by Claude.

---

## Compatibility

Works alongside any existing Claude Code setup.
No dependencies. No external services. No API keys.
Files are plain Markdown — readable, version-controllable, portable.

Add SCRATCHPAD.md and SESSIONS.md to .gitignore if you want them local-only.
Keep DECISIONS.md in version control — it is institutional memory.
