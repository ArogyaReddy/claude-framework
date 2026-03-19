# ─────────────────────────────────────────────────────────────────────────────
# PHASE FRAMEWORK — Paste this block into your existing CLAUDE.md
# Works alongside the Memory Framework block (paste after it)
# ─────────────────────────────────────────────────────────────────────────────

## 5-Phase Development Protocol

Every non-trivial feature follows this sequence. Do not skip phases.
"Non-trivial" means: touches more than 2 files, or could have wrong architectural decisions.

| Phase | Command | What Happens | When Done |
|-------|---------|--------------|-----------|
| 1 · Plan | /plan | Architecture agreed, decisions resolved | Confirmed plan exists |
| 2 · Spec | /spec | plan.md written at /specs/[name].md | Spec file created |
| 3 · Build | /chunk | One chunk built, hooks run, commit | Chunk committed |
| 4 · Verify | /verify | Output interrogated before commit | Risk level assessed |
| 5 · Update | /update | CLAUDE.md improved, memory wrapped | Session closed clean |

## Active Specs
<!-- Managed by /spec and /update commands -->
<!-- Format: - /specs/[name].md — [status] -->

[No active specs yet]

## Phase Rules (Non-Negotiable)

- **Never build during /plan.** Planning phase is architecture-only. No code.
- **Never skip /spec for multi-file features.** "I'll remember the plan" is not a spec.
- **One /chunk at a time.** Build → verify → commit → next chunk. Never batch multiple chunks without committing.
- **Always run /verify before committing a chunk.** Post-edit hooks catch syntax. /verify catches logic.
- **Always run /update before ending a session with meaningful work.** Every correction should become a rule.

## Hooks Active
- `post-edit.sh` — type check + lint + format on every file Claude writes
- `pre-commit.sh` — type check + related tests before every commit

## Spec Protocol
- Active specs are read at session start (listed above under Active Specs)
- Locked decisions in specs are honoured without re-litigation
- Scope boundaries in specs are respected — flag before touching out-of-scope files
- Specs are updated (checklist, dates, session count) at each /chunk completion

## Agent Reviews
- Available via /agent-review for high-stakes features
- Requires Claude Code CLI (claude -p)
- Used for: security code, complex business logic, anything going to production fast

# ─────────────────────────────────────────────────────────────────────────────
