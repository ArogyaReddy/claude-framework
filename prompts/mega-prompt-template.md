# Claude Mega-Prompt Template

> Reference guide — copy sections into your prompts as needed.
> XML tags give Claude structural boundaries. Use only the tags your task actually requires.

---

## The 8 Tags

| Tag | Use When... | Skip When... |
|---|---|---|
| `<role>` | You need specialized expertise | The task is general knowledge |
| `<goal>` | **Always use this one** | Never skip it |
| `<key_tasks>` | Multi-step work with a specific order | Simple, single-action tasks |
| `<response_structure>` | You care about tone, depth, or persona | Default Claude tone works fine |
| `<session_structure>` | You want a multi-turn guided flow | You want everything in one shot |
| `<examples>` | You have a specific output style in mind | You're exploring and want Claude's take |
| `<information_about_me>` | Claude needs your specific context | The task is hypothetical or generic |
| `<response_format>` | You need a specific output shape | You're fine with Claude choosing |

---

## The Full Template

```xml
<role>
[What expert role should Claude adopt? Include expertise, specialization, and industry context.]
</role>

<goal>
[What is the single outcome you want? Keep it to 1-2 sentences.]
</goal>

<key_tasks>
Step 1: [First action]
Step 2: [Second action]
Step 3: [Third action]
</key_tasks>

<response_structure>
- [Tone and depth guidance]
- [Persona or perspective to adopt]
- [Any stylistic constraints]
</response_structure>

<session_structure>
- [Interaction approach: single response vs. multi-turn]
- [Who leads: you or Claude?]
- [Any checkpoints or approvals needed]
</session_structure>

<examples>
Example 1:
Input: [Sample input]
Output: [The exact output you'd want to see]
</examples>

<information_about_me>
- [Relevant detail #1]
- [Relevant detail #2]
- [Relevant detail #3]
</information_about_me>

<response_format>
[Exact output structure: list, table, narrative, code block, etc.]
[Any length or formatting constraints]
</response_format>
```

---

## Tag Notes

- `<role>` — Include: the expertise, the specialization, and the context (industry/audience). Weak: "You are a marketing expert." Strong: "You are a conversion-focused email copywriter specializing in SaaS onboarding for B2B products."
- `<goal>` — Big-picture outcome only. Not steps, not format. If it needs more than 2 sentences, split into two separate prompts.
- `<examples>` — Most powerful steering tool. One strong example beats a paragraph of instructions. Always give input AND output.
- `<response_format>` — Controls output **shape**. `<response_structure>` controls output **character** (tone, depth, persona). Don't confuse them.
- Tag names are flexible — Claude reads structure, not exact tag names. `<brand_info>` works identically to `<information_about_me>`.

---

## Full Example — Business Idea Validator

```xml
<role>
You are a pragmatic business strategist with expertise in dissecting
business ideas for real-world applicability.
</role>

<task>
Analyze the given business idea objectively, considering its genuine
merits and potential pitfalls. Create 3 theoretical customer personas
and have each give realistic feedback. End with a blunt validation
and recommendation.
</task>

<business_idea>
A mobile app connecting dog owners with vetted local dog walkers,
featuring real-time GPS tracking and automated scheduling.
</business_idea>

<response_format>
Structure your response as:
1. Business idea overview (2-3 sentences)
2. Potential target markets
3. Three personas, each with: age, occupation, pain points, and their
   honest reaction to this product (written in first person)
4. Market risks
5. Alternative business models worth considering
6. Final validation and recommendation (be direct, not diplomatic)
</response_format>
```
