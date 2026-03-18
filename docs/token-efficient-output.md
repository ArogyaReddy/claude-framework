# Token-Efficient Output Guidelines
## Quick Reference for Minimal Token Usage

**Last Updated:** 2025-03-17

---

## Core Principle

**Every word costs tokens. Every token costs money.**

Default to the **shortest correct answer** that provides all necessary information.

---

## Output Templates

### 1. Code Changes

**❌ Wordy (High Token Cost):**
```
I've successfully reviewed your authentication system and made several improvements.
First, I read through the login.js file to understand the current implementation.
Then I identified that we needed better error handling, so I've added try-catch
blocks around the JWT validation. I also noticed the token expiry wasn't being
checked properly, so I've updated the middleware to handle that. Let me show you
what I changed...
```
**Tokens:** ~80

**✅ Token-Efficient (Low Cost):**
```
Changed:
- auth/login.js:23 - Added JWT validation error handling
- middleware/auth.js:67 - Added token expiry check
- config/jwt.js - Created (JWT config constants)

Impact: Auth now handles expired tokens gracefully
```
**Tokens:** ~25
**Savings:** 69% reduction

---

### 2. File Analysis

**❌ Wordy:**
```
After thoroughly analyzing your codebase, I've discovered several interesting
patterns. The authentication module is well-structured, but there are a few
areas that could benefit from improvement. I noticed that the login function
in auth/login.js handles the main authentication logic, and it's using JWT
tokens which is great. However, the error handling could be more robust...
```
**Tokens:** ~65

**✅ Token-Efficient:**
```
Analysis:
- auth/login.js:15-45 - Main auth logic (JWT-based)
- Issues found:
  • Line 23: No error handling for invalid tokens
  • Line 34: Token expiry not validated
  • Line 41: Missing input sanitization

Recommendation: Add error handling + input validation
```
**Tokens:** ~30
**Savings:** 54% reduction

---

### 3. Bug Reports

**❌ Wordy:**
```
I've identified a bug in your application. The issue is occurring in the login
function where the authentication token is being processed. It appears that when
a user tries to log in with expired credentials, the system doesn't handle this
gracefully and instead crashes. This is happening because there's no check for
token expiration before attempting to validate the token...
```
**Tokens:** ~70

**✅ Token-Efficient:**
```
Bug: Login crashes on expired token

Location: auth/login.js:23
Cause: Missing token expiry check before validation
Impact: App crashes (500 error)
Fix: Add expiry validation at line 22
```
**Tokens:** ~25
**Savings:** 64% reduction

---

### 4. Implementation Summaries

**❌ Wordy:**
```
I've completed the implementation of the new feature you requested. The work
involved creating several new files and modifying some existing ones. I started
by creating the new component in the components directory, then I added the
necessary state management logic, and finally I wired everything up to work
with the existing routing system. Here's what was changed...
```
**Tokens:** ~60

**✅ Token-Efficient:**
```
Implemented: User notifications feature

Created:
- components/NotificationBell.jsx (UI component)
- hooks/useNotifications.js (state management)
- api/notifications.js (API calls)

Modified:
- App.jsx:12 - Added NotificationBell import
- routes.jsx:45 - Added /notifications route

Status: ✅ Working, tested locally
```
**Tokens:** ~30
**Savings:** 50% reduction

---

### 5. Error Explanations

**❌ Wordy:**
```
The error you're encountering is related to a problem with the way your
application is handling the authentication token. When the token expires,
the current code doesn't check for this condition before trying to use it,
which causes an error to be thrown. To fix this, we need to add a check...
```
**Tokens:** ~55

**✅ Token-Efficient:**
```
Error: Token validation failure

Cause: auth/login.js:23 - No expiry check
Solution: Add `if (token.exp < Date.now())` at line 22
```
**Tokens:** ~15
**Savings:** 73% reduction

---

## Format Rules

### Always Use

1. **File:line references**
   - ✅ `auth.js:45`
   - ❌ "in the auth file around line 45"

2. **Bullet points**
   - ✅ List format for everything
   - ❌ Paragraphs (except when prose is clearly better)

3. **Action language**
   - ✅ "Added error handling"
   - ❌ "I have added error handling to improve..."

4. **Status indicators**
   - ✅ `✅ Complete`, `⚠️ Warning`, `❌ Error`
   - ❌ "This has been completed successfully"

### Never Use

1. **Process narration**
   - ❌ "Let me read the file..."
   - ❌ "I will now..."
   - ❌ "First, I'll..."

2. **Celebratory language**
   - ❌ "Great question!"
   - ❌ "Excellent work!"
   - ❌ "Successfully completed!"

3. **Filler phrases**
   - ❌ "As you can see..."
   - ❌ "It's important to note that..."
   - ❌ "In order to..."

4. **Emojis** (unless user explicitly wants them)
   - ❌ 🎉 🚀 ✨ (in normal responses)
   - ✅ Use only when celebrating major milestones with permission

---

## Response Structure Templates

### Code Review Response
```
Issues:
- [file:line] - [issue] ([severity])
- [file:line] - [issue] ([severity])

Recommended fixes:
- [file:line] - [action needed]
```

### Multi-File Implementation
```
Changed:
- [file:line] - [what changed]
- [file:line] - [what changed]

Created:
- [file] - [purpose]

Deleted:
- [file] - [reason]

Impact: [one-line summary]
Test: [quick test command]
```

### Planning Response
```
Plan: [feature name]

Phases:
1. [Phase name] - [brief description]
   - [task 1]
   - [task 2]

2. [Phase name] - [brief description]
   - [task 1]
   - [task 2]

Estimated: [time/complexity]
Dependencies: [list]
```

### Status Update
```
Progress: [X/Y tasks complete]

Completed:
- [task] - [file:line]

In Progress:
- [task] - [current state]

Blocked:
- [task] - [blocker]

Next: [immediate next action]
```

---

## Token Savings Calculator

| Response Type | Wordy Tokens | Efficient Tokens | Savings |
|---------------|--------------|------------------|---------|
| Code changes | 80 | 25 | 69% |
| File analysis | 65 | 30 | 54% |
| Bug report | 70 | 25 | 64% |
| Implementation | 60 | 30 | 50% |
| Error explanation | 55 | 15 | 73% |
| **Average** | **66** | **25** | **62%** |

**Average session (10 responses):**
- Wordy: 660 tokens
- Efficient: 250 tokens
- **Savings: 410 tokens per session**

**Cost impact** (at $15/$60 per million tokens):
- 100 sessions wordy: 66,000 tokens = $3.96
- 100 sessions efficient: 25,000 tokens = $1.50
- **Savings: $2.46 per 100 sessions** ≈ 62% cost reduction

---

## When to Break These Rules

**Use longer format when:**
1. User explicitly asks for detailed explanation
2. Teaching/explaining complex concepts
3. Documentation (where clarity > brevity)
4. User provides `<format>detailed</format>` or similar tag
5. Error is complex and requires step-by-step explanation

**Golden rule:** If in doubt, go short. User can always ask for more detail.

---

## Examples in Practice

### Session Exchange (Wordy)
```
User: "Fix the login bug"

Claude: "I'd be happy to help you fix the login bug! Let me start by examining
the authentication code to understand what's happening. I'll read through the
login.js file first to see the current implementation... [reads file] ...
Okay, I can see the issue now. The problem is in the token validation section
where we're not checking if the token has expired before trying to validate it.
This causes the application to crash when users with expired tokens try to log
in. To fix this, I'm going to add a check at line 22 that validates the token
expiry before proceeding with the validation. Let me make that change now...
[makes change] ... Great! I've successfully fixed the bug by adding the expiry
check. The login function will now handle expired tokens gracefully."

Tokens: ~180
```

### Session Exchange (Token-Efficient)
```
User: "Fix the login bug"

Claude:
Bug found: auth/login.js:23 - Missing token expiry check

Fixed:
- Added expiry validation at line 22
- Now returns clear error for expired tokens

Test: `npm run dev` → try login with old session
```
**Tokens: ~35**
**Savings: 81% reduction**

---

## Auto-Activation Integration

These output rules are now **enforced by default** in:
- ✅ Global CLAUDE.md (all projects)
- ✅ Project CLAUDE.md (framework repo)
- ✅ Auto-suggested via `output-control` skill when detected

**Trigger words that activate output-control:**
- "save tokens"
- "reduce cost"
- "minimal output"
- "summary format"
- "brief response"

---

## Enforcement

**These rules are:**
- ✅ Active in global CLAUDE.md
- ✅ Active in project CLAUDE.md
- ✅ Monitored by auto-activation system
- ✅ Applied to all responses by default

**User can override with:**
- `<format>detailed</format>` tag
- "Explain in detail..."
- "Give me a comprehensive..."
- Any explicit request for longer format

---

**Remember:** Tokens = Cost. Every unnecessary word is wasted money.
**Target:** <300 words, <25 tokens overhead per response
