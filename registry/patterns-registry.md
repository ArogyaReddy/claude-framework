# Patterns Registry

> Full prompt templates live in: `prompts/golden-prompts.md`
> This file provides decision logic for when to use each pattern.

---

## Decision Tree — Which Pattern to Use?

```
Starting a new task?
├─ Is scope fully defined AND single-file? → §1 Surgical Edit
├─ Multi-file OR hard to reverse?          → §2 Plan Gate  (first)
└─ Have a written spec file?               → §3 Spec-First Build

Debugging something broken?                → §4 Diagnosis First

Pre-merge or code standards check?        → §5 Constraint Check

Cleanup with regression risk?             → §6 Refactor Boundary

Output format is critical?
├─ Need exact length/format?              → §9  Explicit Format + Length
├─ Multiple sub-topics?                   → §10 Section-Divided Output
└─ Two audiences (tech + non-tech)?       → §11 Depth-Then-Condense

After making multi-file changes?          → §8  Change Log Request

Output must be code-only, no narration?  → Use minimal-output skill
```

---

## Pattern Index

| § | Pattern Name | When | Skill Equivalent |
|---|---|---|---|
| 1 | Surgical Edit | Known-scope, single-file change | scope-guard |
| 2 | Plan Gate | Multi-file, irreversible, or unclear scope | spec-to-task |
| 3 | Spec-First Build | Building from a written spec file | spec-to-task |
| 4 | Diagnosis First | Bug investigation before any fix | debug-first |
| 5 | Constraint Check | Pre-merge, standards enforcement | code-review |
| 6 | Refactor Boundary | Cleanup with regression risk | scope-guard |
| 7 | Output Contract | Any time output format matters | output-control |
| 8 | Change Log Request | After multi-file edits | change-manifest |
| 9 | Explicit Format + Length | Fixed-format output (count, bullets, table) | output-control |
| 10 | Section-Divided Output | Multi-topic response needing sections | structured-response |
| 11 | Depth-Then-Condense | Same content, two audiences | followup-refine |

---

## Pattern Snapshots

### §1 Surgical Edit
```
Edit [filename] only.
Change: [exact description of what to change]
Do not modify anything else.
```
**Pairs with:** scope-guard skill

---

### §2 Plan Gate
```
Before making any changes:
1. List every file you will need to modify and why.
2. Describe your approach in one paragraph.
3. Flag any assumptions or risks.
Wait for my confirmation before writing any code.
```
**Pairs with:** spec-to-task skill

---

### §3 Spec-First Build
```
Use spec-to-task skill on [spec-file-path].
```

---

### §4 Diagnosis First
```
Use debug-first skill on [file or error message].
```

---

### §5 Constraint Check
```
Use code-review skill on [file or directory].
```

---

### §6 Refactor Boundary
```
Refactor [filename].
Rules:
- Do not change any public function signatures.
- Do not change behaviour — only internal structure.
- Do not touch any other file.
Report what you changed and why.
```
**Pairs with:** scope-guard skill

---

### §7 Output Contract
```
<role>[role]</role>
<task>[task]</task>
<format>[paragraph | numbered-list | bullet-list | table | labeled-sections]</format>
<length>[e.g. "3 sentences" | "5 bullets" | "100 words max"]</length>
```
**Pairs with:** output-control skill

---

### §8 Change Log Request
```
Use change-manifest skill.
```

---

### §9 Explicit Format + Length
Full template: `prompts/golden-prompts.md §9`
**Pairs with:** output-control skill

---

### §10 Section-Divided Output
Full template: `prompts/golden-prompts.md §10`
**Pairs with:** structured-response skill

---

### §11 Depth-Then-Condense (Two-Step)
Full template: `prompts/golden-prompts.md §11`
**Pairs with:** followup-refine skill

---

## XML Modifier Quick Reference

| Tag | Example | Effect |
|---|---|---|
| `<format>` | `numbered-list` | Forces exact output structure |
| `<length>` | `3 sentences` | Hard length cap |
| `<sections>` | `Overview, Pros, Cons` | Divides into named `##` sections |
| `<section_length>` | `2 sentences per section` | Length cap per section |
| `<target_audience>` | `non-technical executive` | Shapes vocabulary and complexity |
| `<role>` | `Senior engineer` | Sets Claude's perspective and depth |

---

## Modifier Stacking Examples

**Short, exact, sectioned:**
```xml
<role>Technical writer</role>
<task>Compare three approaches to API authentication.</task>
<sections>JWT, OAuth, API Keys</sections>
<section_length>2 sentences per section</section_length>
```

**Non-technical executive brief:**
```xml
<role>Engineering lead</role>
<task>Explain why we need a new onboarding task engine.</task>
<format>bullet list</format>
<length>4 bullets</length>
<target_audience>non-technical VP</target_audience>
```
