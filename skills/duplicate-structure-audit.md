---
name: duplicate-structure-audit
description: Finds and classifies duplicate folder structures as SAFE, CONFLICT, or UNKNOWN.
invocation: manual
agent: true
---

# Skill: duplicate-structure-audit

## Trigger
Say: Use duplicate-structure-audit skill.

## Purpose
Find duplicate folders/files and separate exact duplicates from divergent copies.

## Rules

- Compare using relative paths and file hashes.
- Report counts before recommending deletion.
- Mark divergent files explicitly and do not auto-delete them.
- Include suspicious literal folder names (for example brace-pattern names).

## Steps

1. Enumerate top-level and candidate nested directories.
2. Build relative-path map for each candidate file.
3. Compute hashes for files with matching relative paths.
4. Classify results:
- exact duplicate
- divergent duplicate
- unique in nested copy
5. Output actionable cleanup recommendation with risk level.

## Output Contract

```text
SUMMARY
- Candidate folder(s)
- Total compared files
- Exact duplicates
- Divergent duplicates
- Unique nested files

DETAILS
- Exact duplicate paths (list)
- Divergent path pairs (list)
- Unique nested paths (list)

RECOMMENDED ACTION
- Safe delete set
- Backup-required set
```
