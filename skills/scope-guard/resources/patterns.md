# Scope Guard - Common Patterns

Catalog of common scope creep patterns and how to detect/handle them.

---

## 1. Drive-By Refactoring

### Pattern
While editing file A for Task X, you notice unrelated code in file A that "could be better"

### Example
```typescript
// Task: Add error logging to saveUser()
// File: src/ UserService.ts

export class UserService {
  // ❌ TEMPTATION: Rename this while we're here
  async getUserById(id) {  // Should be fetchUserById
    // ...
  }

  // ✅ IN SCOPE: Only this function
  async saveUser(user) {
    try {
      await db.save(user);
    } catch (err) {
      logger.error(err);  // ✅ Added logging (in scope)
    }
  }
}
```

### Detection
**Ask:** Is this change mentioned in the task description?
- If NO → Out of scope

### Response
```text
📝 REFACTOR OPPORTUNITY NOTED

Location: src/UserService.ts:5
Issue: getUserById should be fetchUserById for consistency
Severity: Low (naming convention)

ACTION: Documented, not changed
FOLLOW-UP: refactor/user-service-naming
```

---

## 2. Dependency Cascade

### Pattern
Need feature X → requires library Y → library Y has peer dependency Z → Z requires configuration...

### Example
```bash
# Task: Add date formatting
# Scope: src/utils/formatDate.js

# ❌ DEPENDENCY CASCADE:
npm install date-fns           # Reasonable
npm install date-fns-tz        # Still ok...
npm install @types/date-fns    # Ok for TypeScript...
npm install @babel/preset-env  # Wait, why?
# Reconfigure Babel, update tsconfig, add polyfills...
```

### Detection
**Ask:** Is each dependency explicitly approved or absolutely required?

### Response
```text
⚠️ DEPENDENCY BLOCKER

Initial request: date-fns (for date formatting)

Discovered cascade:
1. date-fns (required) ✅
2. date-fns-tz (required for timezone support) ✅
3. @types/date-fns (TypeScript definitions) ✅
4. Babel reconfiguration (NOT required) ❌

ACTION: Stopped at step 3
REASON: Babel changes out of scope
WORKAROUND: Use existing Babel config (works for 95% of cases)
```

---

## 3. Improver Syndrome

### Pattern
"While I'm fixing X, I should also improve Y and Z because they're related"

### Example
```jsx
// Task: Fix button styling on mobile
// File: src/components/Button.jsx

// ❌ IMPROVER SYNDROME:
export function Button({ text, onClick }) {
  return (
    <button
      className="btn"  // ✅ In scope: Fix mobile styles
      onClick={onClick}
      aria-label={text}  // ❌ Out of scope: Accessibility improvement
      role="button"      // ❌ Out of scope: ARIA roles
    >
      {text}
    </button>
  );
}

// ❌ Also added:
// - Dark mode support (not in task)
// - Loading state (not in task)
// - Icon support (not in task)
```

### Detection
**Ask:** Is this improvement required for the stated task?
- If NO → Scope creep

### Response
```text
📝 IMPROVEMENT OPPORTUNITIES

While fixing mobile button styles, noticed:
1. Missing aria-label (accessibility)
2. No dark mode support
3. No loading state
4. No icon support

CHANGES MADE: Mobile styles only (in scope)
FOLLOW-UP TASKS:
- [ ] accessibility/button-aria
- [ ] feature/button-darkmode
- [ ] feature/button-loading
- [ ] feature/button-icons
```

---

## 4. Testing Scope Creep

### Pattern
"While adding tests for X, noticed Y and Z aren't tested either..."

### Example
```javascript
// Task: Add tests for login function
// File: tests/auth.test.js

// ✅ IN SCOPE:
describe('login', () => {
  it('should authenticate valid credentials', () => {
    // ...
  });
});

// ❌ OUT OF SCOPE:
describe('logout', () => {  // Not mentioned in task
  it('should clear session', () => {
    // ...
  });
});

describe('register', () => {  // Not mentioned in task
  it('should create new user', () => {
    // ...
  });
});
```

### Detection
**Ask:** Is this test for the explicitly mentioned feature?
- If NO → Document, don't write

### Response
```text
📝 TEST COVERAGE GAPS

While writing login tests, noticed missing tests:
- logout() - 0% coverage
- register() - 0% coverage
- resetPassword() - 0% coverage

CHANGES MADE: login tests only (in scope)
FOLLOW-UP: test/auth-coverage (separate ticket)
```

---

## 5. The "Just One More Thing" Pattern

### Pattern
Task is 95% done, then "just add this small thing while we're here"

### Example
```text
Task: Implement user search

COMPLETED (in scope):
✅ Search input component
✅ API endpoint for search
✅ Display search results
✅ Loading state
✅ Error handling

ADDED (scope creep):
❌ "Just add" pagination
❌ "Just add" sorting
❌ "Just add" filters
❌ "Just add" export to CSV
❌ "Just add" search history
```

### Detection
**Ask:** Was this in the original scope definition?
- If NO → Resist the urge

### Response
```text
✅ CORE TASK COMPLETE

Original scope: User search (basic)
Status: COMPLETE

Requested additions:
- Pagination (good idea, but out of scope)
- Sorting (good idea, but out of scope)
- Filters (good idea, but out of scope)
- Export (good idea, but out of scope)
- History (good idea, but out of scope)

ACTION: Ship core feature
FOLLOW-UP: enhancement/search-advanced (includes all additions)
```

---

## 6. The Cleanup Pattern

### Pattern
"This file is messy, let me clean it up while I'm editing it"

### Example
```typescript
// Task: Add userId validation
// File: src/validators/user.js (legacy code, messy)

// ❌ CLEANUP SCOPE CREEP:
- Converted var → const/let (not in scope)
- Renamed functions to camelCase (not in scope)
- Added JSDoc comments (not in scope)
- Fixed indentation (not in scope)
- Removed console.logs (not in scope)
- Split into multiple files (DEFINITELY not in scope)

// ✅ ACTUAL SCOPE:
export function validateUserId(id) {
  if (!id || typeof id !== 'string') {
    throw new Error('Invalid user ID');
  }
  return true;
}
```

### Detection
**Ask:** Is this cleanup required for my specific change to work?
- If NO → Don't clean

### Response
```text
📝 CODE QUALITY ISSUES NOTED

While adding userId validation, noticed:
- var instead of const/let (28 instances)
- Inconsistent camelCase (15 functions)
- No JSDoc comments (entire file)
- Console.logs in production code (4 locations)
- File is 800 lines (should be split)

CHANGES MADE: Added validateUserId only
REASON: Cleanup is separate from validation task

FOLLOW-UP: refactor/user-validators (low priority)
```

---

## 7. The Configuration Drift

### Pattern
Modify one config setting → cascade of related config changes

### Example
```json
// Task: Increase API timeout from 5s to 10s
// File: config/api.json

{
  "timeout": 10000,  // ✅ In scope

  // ❌ OUT OF SCOPE - Configuration drift:
  "retries": 3,       // "While we're here, add retries"
  "baseURL": "...",   // "Update the base URL too"
  "headers": {...},   // "Fix the headers"
  "interceptors": [...] // "Add auth interceptor"
}
```

### Detection
**Ask:** Is each config change explicitly mentioned or required by the primary change?

### Response
```text
⚠️ CONFIGURATION BLOCKER

Target change: Increase timeout 5s → 10s

Suggested additional changes:
1. Add retry logic (out of scope)
2. Update base URL (out of scope)
3. Fix headers (out of scope)
4. Add auth interceptor (out of scope)

CHANGES MADE: Timeout only
REASON: Other changes are enhancements, not requirements

FOLLOW-UP: config/api-improvements
```

---

## 8. The Type Definition Cascade

### Pattern
Add one type → requires updating 10 related types

### Example
```typescript
// Task: Add 'role' field to User type
// File: src/types/user.ts

// ✅ IN SCOPE:
export interface User {
  id: string;
  name: string;
  email: string;
  role: 'admin' | 'user';  // ✅ Added
}

// ❌ TEMPTATION (cascade):
export interface UserDto { ... }  // Update DTO
export interface UserEntity { ... }  // Update entity
export interface UserResponse { ... }  // Update response
export interface CreateUserInput { ... }  // Update input
// + Update 15 more related types
```

### Detection
**Ask:** Is each type update absolutely required for the primary change to work?

### Response
```text
⚠️ TYPE CASCADE DETECTED

Primary change: Add 'role' to User type

Required updates (blocking):
- User interface ✅ (primary change)
- UserEntity ✅ (database model)
- CreateUserInput ✅ (API input)

Optional updates (non-blocking):
- UserDto (API can omit role for now)
- UserResponse (can be added later)
- 15 other types (can be updated incrementally)

ACTION: Updated only required types
FOLLOW-UP: types/user-role-complete (full cascade)
```

---

## Detection Quick Reference

| Pattern | Key Question | Red Flag |
|---------|--------------|----------|
| Drive-By Refactoring | Is this mentioned in task? | "While I'm here..." |
| Dependency Cascade | Is each dependency approved? | "Need to install one more thing..." |
| Improver Syndrome | Is this improvement required? | "I should also..." |
| Testing Scope Creep | Is this test for the feature? | "Let me test this too..." |
| Just One More Thing | Was this in original scope? | "Just add..." |
| Cleanup Pattern | Is cleanup required? | "Let me clean this up..." |
| Configuration Drift | Is each config change needed? | "Update this setting too..." |
| Type Definition Cascade | Is each type update blocking? | "Need to update all related types..." |

---

## Response Templates

### For Documentation
```text
📝 [ISSUE TYPE] NOTED

Location: [file:line]
Issue: [description]
Severity: [Low/Medium/High]

ACTION: Documented, not changed
FOLLOW-UP: [task-id/description]
```

### For Blockers
```text
⚠️ SCOPE BLOCKER

Required change: [file:line]
Reason: [why it's needed]
Impact: [Low/Medium/High]

OPTIONS:
1. [option 1]
2. [option 2]
3. [option 3]

User approval required.
```

### For Rejected Scope
```text
📝 OUT-OF-SCOPE OBSERVATIONS

The following were noticed but NOT changed:
1. [observation 1]
2. [observation 2]
3. [observation 3]

REASON: [why out of scope]

FOLLOW-UP TASKS CREATED:
- [ ] [task 1]
- [ ] [task 2]
```

---

## Recovery Strategies

### When You Catch Yourself Mid-Creep

**Step 1:** STOP immediately

**Step 2:** Review what you've changed:
```bash
git diff --stat  # See all changed files
```

**Step 3:** Categorize changes:
- In-scope: Keep
- Out-of-scope but useful: Stash for separate PR
- Out-of-scope cleanup: Discard

**Step 4:** Reset out-of-scope changes:
```bash
git checkout path/to/out-of-scope-file.js
```

**Step 5:** Document what you removed and why

---

**Remember:** Scope creep isn't evil — it's enthusiasm! The goal is to **channel that enthusiasm into organized follow-up tasks** instead of uncontrolled expansion.
