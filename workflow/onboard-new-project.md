# Onboarding a New Project with the Framework

> Use this guide every time you start working on a project that doesn't
> already have the framework installed.
> For first-time framework setup on THIS machine, see `workflow/project-setup.md`.

---

## The 4-Step Process

### Step 1 — Scan the project

Point the scanner at your project's root directory:

```
Use project-scan skill on C:/path/to/your/project
```

What happens:
- `tools/scan-project.ps1` runs on the target → writes `PROJECT_SCAN_RAW.md`
- Claude reads the raw data + the framework registries
- Claude writes `PROJECT_SCAN.md` to the project root

This takes under a minute. No files are modified in the project (only two files are created).

---

### Step 2 — Review the scan report

Open `PROJECT_SCAN.md` in the project root and check:

| Section | What to look for |
|---|---|
| **Summary** | Is the stack detection correct? |
| **What Exists** | Which framework components are already there? |
| **What's Missing** | High priority items to install now |
| **Gap Analysis** | Skills and hooks column — which ones matter for this project? |
| **Recommendations** | The exact commands and CLAUDE.md lines to add |

You don't need to install everything. Focus on **High Priority** items first.

---

### Step 3 — Apply the framework

Install the recommended components:

```
Use framework-apply skill.
```

Or install specific components only:

```
Use framework-apply skill. Target: C:/path/to/project Components: scope-guard,debug-first,session-closer,pre-tool-use,post-tool-use
```

The apply skill:
- Copies skill files from framework → project's `skills/` directory
- Copies hook files from framework → project's `hooks/` directory
- **Does NOT overwrite existing files**
- **Does NOT modify CLAUDE.md** — reports what lines to add
- **Does NOT create settings.json** — shows you the exact JSON to create

---

### Step 4 — Complete the manual steps

The apply skill ends with a "Manual Steps Required" section. Complete these:

**a) Add skill lines to the project's CLAUDE.md**

Open `CLAUDE.md` in the project and add the reported lines to the Core Skills section.
Example:
```
## Core Skills (Use By Name)
- `skills/scope-guard.md` to prevent scope creep.
- `skills/debug-first.md` for bug diagnosis before fixing.
- `skills/session-closer.md` — invoked by "close the session".
```

**b) Create `.claude/settings.json` (if not present)**

Copy the JSON from `registry/hooks-registry.md` "settings.json Configuration Template"
into `[project]/.claude/settings.json`. Adjust hook paths if needed.

**c) Unix only — make hooks executable**
```bash
chmod +x hooks/*.sh
```

---

## Re-scanning an Existing Project

Run project-scan again at any time to refresh the gap report:

```
Use project-scan skill on C:/path/to/project
```

Useful when:
- The project has grown significantly
- You suspect new framework components should be added
- You want to verify what's installed after `framework-apply`

`PROJECT_SCAN_RAW.md` is always overwritten on re-scan.
`PROJECT_SCAN.md` is always regenerated from fresh data.

---

## Minimum Viable Install (New Project, Fast Start)

If you want to get going immediately with just the essentials:

```
Use framework-apply skill. Target: [path] Components: scope-guard,debug-first,session-closer,pre-tool-use,post-tool-use,pre-compact
```

Then add these lines to CLAUDE.md:
```
- `skills/scope-guard.md` to prevent scope creep.
- `skills/debug-first.md` for bug diagnosis before fixing.
- `skills/session-closer.md` — invoked by "close the session".
```

And create `.claude/settings.json` from the template in `registry/hooks-registry.md`.

That's the minimum set for safe, session-persistent development on any project.

---

## What Gets Installed Where

```
[your-project]/
├── skills/
│   ├── scope-guard.md         ← from framework/skills/
│   ├── debug-first.md
│   ├── session-closer.md
│   └── [others per recommendations]
├── hooks/
│   ├── pre-tool-use.ps1       ← from framework/hooks/
│   ├── pre-tool-use.sh
│   ├── post-tool-use.ps1
│   ├── post-tool-use.sh
│   ├── pre-compact.ps1
│   └── pre-compact.sh
├── .claude/
│   ├── settings.json          ← you create from registry/hooks-registry.md template
│   └── history/               ← created if session-files component selected
├── CLAUDE.md                  ← you add skill lines manually
├── PROFILE.md                 ← copied from framework (if session-files selected)
├── SESSION_LOG.md             ← created stub (if session-files selected)
├── PROJECT_SCAN_RAW.md        ← scanner output (ephemeral, safe to gitignore)
└── PROJECT_SCAN.md            ← gap analysis report (commit or gitignore — your choice)
```

---

## Tips

- **Add to .gitignore:** `PROJECT_SCAN_RAW.md` — it's a scratch file, regenerated each scan
- **Optionally commit:** `PROJECT_SCAN.md` — useful as a project health snapshot for the team
- **Re-run monthly** or when the project structure changes significantly
- **The framework itself never changes** — components flow only outward from framework → project
