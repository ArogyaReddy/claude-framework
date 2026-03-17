---
name: jsx-to-standalone-html
description: Converts a .jsx or .tsx file to a single standalone .html with no build dependencies.
invocation: manual
agent: true
---

# Skill: jsx-to-standalone-html

## Trigger
Say: Use jsx-to-standalone-html skill.

## Purpose
Convert a JSX-driven view into a standalone browser-usable HTML file.

## Rules

- Preserve user-facing content and section structure.
- Implement interactivity with plain JavaScript when feasible.
- Keep CSS in-file unless user asks for external stylesheets.
- Avoid adding framework dependencies.
- Ensure responsive behavior for desktop and mobile.

## Steps

1. Identify source JSX component and core sections.
2. Recreate layout in semantic HTML.
3. Port interactions (tabs, expand/collapse, copy buttons) to vanilla JavaScript.
4. Add concise CSS tokens and responsive rules.
5. Verify the page can open directly in browser.

## Output Contract

```text
- Created/updated file path(s)
- What behavior is preserved
- How to open/run in browser (one short instruction)
```
