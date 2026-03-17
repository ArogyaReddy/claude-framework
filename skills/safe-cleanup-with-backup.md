---
name: safe-cleanup-with-backup
description: Creates a timestamped backup before any destructive deletion or folder cleanup.
invocation: manual
agent: false
---

# Skill: safe-cleanup-with-backup

## Trigger
Say: Use safe-cleanup-with-backup skill.

## Purpose
Perform destructive cleanup safely by backing up divergent files first.

## Rules

- Never delete before backup of divergent/uncertain files.
- Create timestamped backup folder at repository root.
- Keep backup structure aligned with original relative paths.
- Verify deletions and report post-cleanup state.

## Steps

1. Create backup folder: cleanup-backup-YYYYMMDD-HHMMSS.
2. Copy divergent files and uncertain files into backup.
3. Delete approved duplicate folders/files.
4. Validate deleted paths no longer exist.
5. Print backup inventory and remaining top-level structure.

## Output Contract

```text
BACKUP
- Backup folder path
- Backed-up file list

DELETIONS
- Deleted path list

VALIDATION
- Existence checks for deleted paths
- Remaining root directories/files summary
```
