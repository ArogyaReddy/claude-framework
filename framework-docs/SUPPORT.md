# SUPPORT.md — Getting Help

## Self-Service (Try First)

Before opening an issue, check these in order:

1. **[QUESTIONS-BANK.md](QUESTIONS-BANK.md)** — 25 answered questions covering installation, configuration, usage, and troubleshooting. Most problems are covered here.

2. **[WORKING-MODEL.md](WORKING-MODEL.md)** — Full day-to-day usage guide. If Claude isn't behaving as expected, this document explains what should be happening and why.

3. **[DEVELOPMENT.md](DEVELOPMENT.md)** — Setup and hook debugging. If hooks aren't firing or healthcheck is failing, the troubleshooting table in this document covers the most common causes.

4. **[FRAMEWORK-MECHANICS.md](FRAMEWORK-MECHANICS.md)** — The honest technical answer to "does Claude really follow this?" Includes verification tests you can run in 30 seconds each to confirm individual components are active.

5. **Run the healthcheck:** Open Claude Code and type `Use healthcheck skill.` It runs 12 verification points and tells you exactly which component is failing.

---

## Reporting Bugs

If self-service didn't resolve the issue, open a GitHub issue at:
**https://github.com/ArogyaReddy/claude-framework/issues**

Include all of the following — issues without this information will be closed:

- **OS and shell:** Windows 11 / PowerShell 5.1, macOS 14 / Bash 5.2, etc.
- **Claude Code version:** Run `claude --version`
- **Framework component failing:** Which file / skill / hook is not working
- **Steps to reproduce:** Exact sequence of commands
- **Expected behavior:** What should have happened
- **Actual behavior:** What happened instead
- **Healthcheck output:** Paste the full result of `Use healthcheck skill.`
- **Hook log output (if relevant):** Paste from `.claude/logs/tool-use.log`

---

## Requesting Features

Feature requests are welcome. Open a GitHub issue with the label `enhancement`. Include:

- The problem you're trying to solve (not the solution)
- The workflow impact — how often you hit this, how much time it costs
- Any workaround you're currently using

Feature requests framed as problems are far more likely to result in implementation than requests framed as specific solutions.

---

## Security Issues

If you discover a security vulnerability — particularly around hook scripts, settings.json paths, or anything that could affect the execution of arbitrary commands on the developer's machine — **do not open a public GitHub issue**.

Contact the maintainer directly via GitHub private message or email as listed on the GitHub profile. Include:
- Nature of the vulnerability
- Reproduction steps
- Potential impact
- Any suggested fix

Security issues will be acknowledged within 48 hours and resolved before any public disclosure.

---

## Community

This is a personal framework made public. There is no official community forum. However:

- GitHub Discussions is enabled for the repo — use it for questions that don't fit the bug/feature template
- If you've built something on top of this framework (a new skill, an enhanced hook, a team setup guide), pull requests are welcome

---

## What This Framework Is Not

This is not a commercial product with SLAs. It is a practitioner-built tool shared publicly because other engineers asked for it. Response times are best-effort. Contributions that improve the framework for others are the most effective way to improve it.
