# ─────────────────────────────────────────────────────────────────
# MEMORY FRAMEWORK — Paste this block into your existing CLAUDE.md
# ─────────────────────────────────────────────────────────────────

## Memory System (Non-Negotiable)

This project uses a three-file memory system. You MUST honour it.

### The Three Files

| File | Purpose | When to Read | When to Write |
|------|---------|--------------|---------------|
| SCRATCHPAD.md | Current session state — rolling | Session start (always) | Session end via /wrap |
| DECISIONS.md | Permanent decision log — never truncated | When making architectural decisions | Via /decide or /wrap |
| SESSIONS.md | Lightweight audit trail | Never at session start (noise) | Via /wrap only |

### Session Start Protocol (Every Single Session)

When the session opens OR when /resume is called:
1. Read SCRATCHPAD.md fully
2. Scan DECISIONS.md for entries relevant to current focus
3. Output a Session Brief (see /resume command for format)
4. Wait for confirmation before starting work

Do not start work without completing this protocol.
The cost is ~600 tokens. It saves 3,000-6,000 tokens of reconstruction.

### Session End Protocol

When /wrap is called (or session ends):
1. Update SCRATCHPAD.md — replace Current Focus and Resume Here, append failures/questions
2. Append new decisions to DECISIONS.md (if any were made)
3. Append one row to SESSIONS.md
4. Surface any CLAUDE.md suggestions — do NOT auto-edit CLAUDE.md

### Mid-Session Rules

- When ANY architectural or significant decision is made → immediately run /decide
- Do not wait for /wrap to capture decisions — context degrades fast
- If SCRATCHPAD.md exceeds 300 lines → summarise old "Failed" entries before appending
- If a DECISIONS.md entry is being contradicted → flag it before proceeding:
  "This conflicts with [DECISION-XXX]. Confirm you want to proceed differently."

### Commands Available

| Command | Use |
|---------|-----|
| /resume | Session start — read memory, output brief, wait for confirmation |
| /wrap | Session end — update all memory files |
| /decide | Mid-session — log a decision immediately to DECISIONS.md |

# ─────────────────────────────────────────────────────────────────
