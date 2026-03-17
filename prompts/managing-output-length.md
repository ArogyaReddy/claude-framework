# Managing Claude Output Length and Format

> Reference guide — 5 techniques for controlling response length and structure.

---

## 5 Techniques

### 1. Be Explicit
State the exact length or format you want. Claude follows direct instructions precisely.

```xml
<role>Expert in AI ethics</role>
<task>Provide a five-sentence summary of ethical challenges in AI decision-making.</task>
<format>Exactly five sentences in a single paragraph.</format>
```

### 2. Imply Length via Task Type
Some tasks carry implicit format expectations. Use them.

```xml
<role>Social media strategist</role>
<task>Draft a tweet about renewable energy.</task>
<length>280 characters or less.</length>
```

### 3. Use Lists to Constrain Structure
Asking for a list naturally limits scope and imposes structure.

```xml
<role>Nutritionist</role>
<task>List five high-protein vegan foods.</task>
<response_format>Food name, protein content, one health benefit per item.</response_format>
```

### 4. Use Follow-up Prompts to Refine Length
Get depth first, then compress. Two-step approach.

**Step 1:**
```xml
<role>Blockchain expert</role>
<task>Explain blockchain and its core principles in detail.</task>
<format>Detailed paragraph-style response with technical depth.</format>
```

**Step 2 (follow-up):**
```
Condense your previous explanation into three simple sentences for a beginner.
```

### 5. System-Level Prompts for Session-Wide Control
Set a format rule that applies to the entire session.

```xml
<role>Technical writing assistant</role>
<task>Respond in concise bullet points unless otherwise instructed.</task>
<length>Maximum 100 words per response.</length>
```

---

## Quick XML Tag Reference for Output Control

| Tag | Controls |
|---|---|
| `<length>` | Word count, sentence count, character limit |
| `<format>` | Output structure (bullets, numbered list, paragraph, table) |
| `<response_format>` | Full output blueprint with labeled sections |
| `<response_structure>` | Tone, depth, persona style (not shape) |
