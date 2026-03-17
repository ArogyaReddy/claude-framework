# PROFILE.md — My Identity & Working Style

> This file is read by Claude at the start of every session.
> It tells Claude who I am, how I think, and how to write *as me* or *for me*.
> Fill in your own details. The more specific, the better.

---

## Who I Am

- **Name:** Arogya Reddy
- **Role:** Tech Lead
- **Current Project:** ADP ROLL — working on Acknowledgement Tasks, Task Creation, Acknowledge, E-Sign, Employee Onboarding features
- **Team context:** AI SDLC, Spec Driven Development
- **Experience level:** Sr Lead Software Engineer — Intermediate

---

## Technical Background

- **Primary languages:** TypeScript, Node.js, React, GraphQL, MySQL, Lambda functions, Jest, Playwright
- **Stack I work in daily:** TypeScript, Node.js, React, GraphQL, MySQL, Lambda — every day, every hour
- **Tools I use:** Claude Code, VS Code, Git
- **Strongest areas:** Full-stack TypeScript, GraphQL API design, serverless (Lambda), test automation (Jest, Playwright)
- **Areas I'm actively learning:** AI SDLC, Spec Driven Development, AI tooling integration

---

## Communication Style

- **When explaining things to me:** Be direct and specific. Use examples over abstract descriptions.
- **Tone I prefer:** Peer-to-peer, direct, no fluff
- **What I dislike:** Long preambles, over-cautious disclaimers, repeating what I just said back to me.
- **When I ask a question:** I want the answer first, context second.

---

## Decision Patterns

> Claude should check these before making architectural or approach recommendations.

- I prefer **simple solutions over clever ones** — the minimum that is correct.
- I prefer **editing existing files** over creating new ones.
- I prefer **understanding the problem** before jumping to a fix.
- I am **cost-conscious with tokens** — keep prompts lean, responses tight.
- I prefer **explicit over implicit** — if something needs a decision, surface it to me.

---

## Writing Style (when Claude writes *for* me)

- First person, direct.
- Short sentences. No filler words.
- No "I believe" or "I think" — just state the thing.
- No closing motivational statements.

---

## Current Focus Area

ADP ROLL project — understanding and implementing:
- **Acknowledgement tasks**: task assignment, status tracking, completion flows
- **Task creation**: how tasks are created and assigned during onboarding
- **Acknowledge**: the confirm/accept action on a task
- **E-Sign**: digital signature flow layered on top of acknowledgement
- **Employee onboarding**: the end-to-end flow that generates and manages all of the above

---

## Notes / Things Claude Should Always Remember

- Spec Driven Development: always write a spec before building any feature
- AI SDLC context: Claude is part of the development lifecycle, not just a helper
- Stack is TypeScript-first across all layers (front, back, infra)
- GraphQL is the API layer — do not default to REST without explicit instruction
- Lambda functions are the serverless execution context — be aware of cold start, timeout, and package size constraints
