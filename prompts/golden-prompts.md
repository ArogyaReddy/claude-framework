# Golden Prompts — Ready-to-Use Reference

Copy the template. Fill in the brackets. Remove the brackets.
Never send a prompt that still has [BRACKETS] in it.

---

## 1. Surgical Edit
**When:** Any code change where the scope is known.

```
In [FILE], [ONE THING TO CHANGE].
Do not touch [WHAT TO LEAVE ALONE].
Return only the modified [FUNCTION / SECTION / FILE].
No explanation.
```

**Example:**
```
In src/auth/session.ts, extract the token refresh logic into a standalone function.
Do not change function signatures or calling code.
Return only the modified file.
No explanation.
```

---

## 2. Plan Gate
**When:** Complex tasks, multi-file changes, anything irreversible.

```
Before writing any code, give me your step-by-step plan for:
[TASK DESCRIPTION]

Do not execute. Wait for my confirmation.
```

**Example:**
```
Before writing any code, give me your step-by-step plan for:
Migrating the user session store from Redis to Postgres.

Do not execute. Wait for my confirmation.
```

---

## 3. Spec-First Build
**When:** New feature or module with a spec already written.

```
Build [THING] according to specs/[SPEC FILE].
Constraints:
- [CONSTRAINT 1]
- [CONSTRAINT 2]
Output: [EXACTLY WHAT FILES]
Stop after that.
```

**Example:**
```
Build the notification service according to specs/notifications.md.
Constraints:
- No new dependencies
- Do not modify the existing event bus interface
Output: src/services/notifications.ts only.
Stop after that.
```

---

## 4. Diagnosis First
**When:** Any bug, error, test failure, or unexpected behavior.
**(Or just invoke: `Use debug-first skill.`)**

```
Look at [FILE] — specifically [FUNCTION / SECTION].
Tell me: what is wrong, why, and exactly where.
Do not fix it yet.
One sentence per finding.
```

**Example:**
```
Look at src/api/payments.ts — specifically the processBatch function.
Tell me: what is wrong, why, and exactly where.
Do not fix it yet.
One sentence per finding.
```

---

## 5. Constraint Check
**When:** Pre-merge, spec compliance, standards enforcement.
**(Or just invoke: `Use code-review skill on [file].`)**

```
Review [FILE] against these rules:
- [RULE 1]
- [RULE 2]
- [RULE 3]

List only violations. File, line number, rule violated. Nothing else.
```

**Example:**
```
Review src/services/auth.ts against these rules:
- No raw SQL, use the query builder only
- All errors must go through the AppError class
- No console.log in production code paths

List only violations. File, line number, rule violated. Nothing else.
```

---

## 6. Refactor Boundary
**When:** Cleanup where you're worried about regression.

```
Refactor [FILE / FUNCTION] for [ONE GOAL: readability / performance / simplicity].
Do not change behavior.
Do not change external interfaces or function signatures.
Show diff-style before/after for the key change only.
```

**Example:**
```
Refactor src/utils/dateHelpers.ts for readability.
Do not change behavior.
Do not change exported function signatures.
Show diff-style before/after for the key change only.
```

---

## 7. Output Contract
**When:** Any time output format matters — which is always.

```
[TASK].
Return:
- [WHAT THE OUTPUT LOOKS LIKE]
- [WHAT IT MUST NOT INCLUDE]
- Stop after [STOP CONDITION].
```

**Example:**
```
Write unit tests for the validateUser function in src/auth/validators.ts.
Return:
- Jest test blocks only
- No imports, I will add them
- Stop after the last test case. No summary.
```

---

## 8. Change Log Request
**When:** After any multi-file edit, for PR descriptions or audit trail.
**(Or just invoke: `Use change-manifest skill.`)**

```
Summarise what you just changed.
Format:
- Files modified
- What changed (one line per change)
- Why (reference spec section if applicable)
- What was explicitly not changed
No prose.
```

---

## 9. Explicit Format + Length Control
**When:** You need exact output length or format — summaries, cards, fixed-size content.
**(Or just invoke: `Use output-control skill.`)**

```xml
<role>[who Claude is acting as]</role>
<task>[what you need]</task>
<format>[paragraph | numbered-list | bullet-list | table | labeled-sections]</format>
<length>[exact constraint: e.g. "3 sentences" | "5 bullets" | "100 words max"]</length>
```

**Example:**
```xml
<role>Senior software engineer</role>
<task>Explain what React reconciliation does.</task>
<format>Single paragraph</format>
<length>50 words max</length>
```

---

## 10. Section-Divided Structured Output
**When:** The answer has multiple distinct sub-topics — comparisons, audits, onboarding, briefs.
**(Or just invoke: `Use structured-response skill.`)**

```xml
<role>[who Claude is acting as]</role>
<task>[what to produce]</task>
<response_format>
  <sections>[comma-separated section names]</sections>
  <section_length>[sentence count or word limit per section]</section_length>
</response_format>
```

**Example:**
```xml
<role>Staff engineer</role>
<task>Compare REST and GraphQL for a mobile app backend.</task>
<response_format>
  <sections>Overview, Pros, Cons, Best Fit</sections>
  <section_length>2–3 sentences per section</section_length>
</response_format>
```

---

## 11. Depth-Then-Condense (Two-Step)
**When:** You need the same content for two audiences — technical first, then simplified.
**(Or just invoke: `Use followup-refine skill.`)**

**Step 1 — Full depth:**
```xml
<role>[Expert role]</role>
<task>[Detailed explanation of topic]</task>
<format>Detailed prose. No length limit. Prioritise completeness.</format>
```

**Step 2 — Condense (send after Step 1 output):**
```xml
Condense your previous response:
<target_audience>[beginner | executive | non-technical | team lead]</target_audience>
<length>[1 sentence | 3 bullets | 50 words | one paragraph]</length>
<format>[plain language | bullet list | executive summary | numbered steps]</format>
```

**Example Step 2:**
```xml
Condense your previous response:
<target_audience>non-technical product manager</target_audience>
<length>3 bullets</length>
<format>plain language, no jargon</format>
```

---

## 12. Multi-Requirement Task (XML Structure)
**When:** One ACTION has multiple sub-requirements or constraints that would make a prose prompt ambiguous.

```xml
<task>
  <goal>[Single sentence — what done looks like]</goal>
  <requirements>
    - [Requirement 1]
    - [Requirement 2]
    - [Requirement 3]
  </requirements>
  <constraints>
    - [What must not change]
    - [What must be preserved]
  </constraints>
  <output>[Exactly which files or functions to return]</output>
</task>
```

**Example:**
```xml
<task>
  <goal>Add rate limiting to the login endpoint</goal>
  <requirements>
    - Max 5 attempts per IP per 15 minutes
    - Return 429 with Retry-After header on breach
    - Store attempt counts in existing Redis client
  </requirements>
  <constraints>
    - Do not modify the auth middleware
    - Do not change the response shape for successful logins
  </constraints>
  <output>src/api/routes/auth.ts only. No explanation.</output>
</task>
```

---

## Prompt Modifiers
Append these to any prompt to shape the output further.

| Add This | Effect |
|---|---|
| `No explanation.` | Strips all narration |
| `One sentence per item.` | Forces concise output |
| `Stop after [X].` | Hard stop condition |
| `Return only the function.` | Scope the output, not just the task |
| `Wait for my confirmation.` | Forces a plan/review gate |
| `Do not create new files.` | Explicit scope fence |
| `Do not change behavior.` | Safety rail for refactors |
| `Reference spec section [X].` | Ties output to spec |

## XML Tag Modifiers (for structured output control)
Use inside prompts to override output defaults set in CLAUDE.md.

| Tag | Example Value | Effect |
|---|---|---|
| `<format>` | `numbered-list` | Forces that exact output structure |
| `<length>` | `3 sentences` or `100 words max` | Hard length cap |
| `<sections>` | `Overview, Pros, Cons` | Divides output into named `##` sections |
| `<section_length>` | `2 sentences per section` | Length cap applied per section |
| `<target_audience>` | `non-technical executive` | Shapes vocabulary and complexity level |
| `<role>` | `Senior engineer` | Sets Claude's perspective and knowledge depth |
