/Users/arog/Library/Mobile Documents/com~apple~CloudDocs/AROG/2026-03-22/claude-framework/claude-framework/pgt

My Goals and Intensions of this PG:
1. Global and BEST prompt genetor for any kind of work, anytime, for any repo, any task, for any projest.
2. Before using any AI, claude code, copilot, use this "PG" as the base prompt generator and get the required, suitable PROMPT and then use that in the AI for better and acurate results, and for 100% best results.
3. This should be used, before touchung claude code, copilot, to save cost and takens.
4. It's a global runner and help any time for any task, development and non-development
5. Save the prompts generated and so user can use them again and again, if needed.

ROLE :
You are a principla engineer. My mentor and guide.

Tasks:
1. Your job is to review this PG and see if it's matching the GOALs and serving the prupose. 
2. If not, what's your taken on?
3. As a principla engineer, how do you build this as GOLBAL PROMPT GENERATOR.
4. Any gaps that need to be addressed
5. how can we make this the BEST and GLOBAL PROMPT GENERATOR for any tasks, day to day work, SPEC driven development, in my AI SDLC, for coding and development and for non-development.

=================



# Synthesize the principal engineer review:

## Goal Assessment: Does it match the 5 goals?

Goal 1 (Global/Best): NO - Critical runtime failures on macOS, not portable
Goal 2 (Use before AI): PARTIAL - Concept is right, execution broken
Goal 3 (Save cost/tokens): NO - Actually risks cost explosion (no truncation)
Goal 4 (Global runner): NO - Fails on default macOS shell
Goal 5 (Save/reuse): PARTIAL - Has vault but no semantic retrieval

## Principal Engineer Take:

Solid conceptual architecture (17 layers, PE frameworks)
Fatal execution gaps block production use
Not integrated with user's actual workflow (SCRATCHPAD, DECISIONS, SESSIONS)
Missing core infrastructure for "global" use case

## How to Build as Global PG:

Layered architecture: Compiler → Validator → Renderer → Vault
Canonical IR (intermediate representation) before target rendering
Memory-aligned with user's framework
Token budget controls
Semantic retrieval system

## Gaps:

Runtime reliability (Critical)
Memory integration (High)
Cost controls (High)
Retrieval quality (Medium)
Portability (Critical)

## Make it BEST:

Fix stability first
Align with user's AI SDLC workflow
Add intelligent context selection
Build prompt learning system
Create adapters for all AI tools
Let me structure this as a direct, minimal-output principal engineer assessment.