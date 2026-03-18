# Scope Guard - Real-World Examples

Detailed examples of scope-guard in action across different scenarios.

---

## Example 1: Feature Addition (React Component)

### Task Given
"Add a loading spinner to the Login button"

### Scope Definition
```text
SCOPE:
- Goal: Show spinner during login API call
- Files: src/components/LoginButton.jsx
- Symbols: LoginButton component, handleLogin function
- Dependencies: None (use existing Spinner component)
```

### Work Process

**✅ In-Scope Change:**
```jsx
// src/components/LoginButton.jsx
import { Spinner } from './Spinner';  // ✅ Existing component

export function LoginButton() {
  const [loading, setLoading] = useState(false);  // ✅ In scope

  const handleLogin = async () => {
    setLoading(true);  // ✅ In scope
    try {
      await api.login();
    } finally {
      setLoading(false);  // ✅ In scope
    }
  };

  return (
    <button onClick={handleLogin}>
      {loading ? <Spinner /> : 'Login'}  {/* ✅ In scope */}
    </button>
  );
}
```

**❌ Scope Violation (Caught and Prevented):**
```jsx
// Would be WRONG to also change:
// src/components/Spinner.jsx - Adding new props
// src/api/auth.js - Refactoring login function
// package.json - Installing new spinner library
```

**Outcome:** Task completed within scope, no scope creep.

---

## Example 2: Bug Fix with Blocker

### Task Given
"Fix TypeError in user dashboard when profile is null"

### Scope Definition
```text
SCOPE:
- Goal: Handle null profile gracefully
- Files: src/pages/Dashboard.jsx
- Symbols: Dashboard component, useProfile hook
- Dependencies: None
```

### Work Process

**Step 1:** Started editing Dashboard.jsx

**Step 2:** Discovered useProfile hook returns inconsistent data shape

**Step 3:** ⚠️ BLOCKER ENCOUNTERED

```text
⚠️ SCOPE BLOCKER

Required change: src/hooks/useProfile.js:15
Reason: Hook returns different data shape than Dashboard expects
  Current: { data: null } when loading
  Expected: { data: null, loading: boolean }

Impact: HIGH - Without this fix, the dashboard fix is incomplete

OPTIONS:
1. Expand scope to include src/hooks/useProfile.js
2. Add defensive checks in Dashboard only (partial fix)
3. Stop and create separate task for hook refactor

User approval required.
```

**User Decision:** Expand scope to include useProfile.js

**Updated Scope:**
```text
SCOPE (REVISED):
- Goal: Handle null profile gracefully + fix hook data shape
- Files:
  - src/pages/Dashboard.jsx ✅ Original
  - src/hooks/useProfile.js ✅ Added
- Symbols: Dashboard component, useProfile hook, ProfileProvider
- Dependencies: None
```

**Outcome:** Task completed with documented scope expansion.

---

## Example 3: Refactoring with Discipline

### Task Given
"Extract repeated validation logic into a utility function"

### Scope Definition
```text
SCOPE:
- Goal: DRY up validation code in UserForm and ProfileForm
- Files:
  - src/components/UserForm.jsx (extract from here)
  - src/components/ProfileForm.jsx (extract from here)
  - src/utils/validation.js (create new utility)
- Symbols: validateEmail, validatePhone (to be extracted)
- Dependencies: None
```

### Temptation vs Discipline

**❌ TEMPTATION (Scope Creep):**
While editing validation.js, noticed:
- validateEmail doesn't handle plus-addressing (user+tag@domain.com)
- validatePhone doesn't support international formats
- Should add validateZipCode while we're at it...

**✅ DISCIPLINE (Scope Guard Applied):**
```text
📝 OUT-OF-SCOPE OBSERVATIONS

The following improvements were noticed but NOT implemented:
1. validateEmail: Add plus-addressing support (RFC 5233)
2. validatePhone: Add international format support
3. New validator: validateZipCode for future forms

REASON: Current task is EXTRACT existing logic, not ENHANCE it

FOLLOW-UP TASKS CREATED:
- [ ] enhancement/validation-plus-addressing
- [ ] enhancement/validation-international-phone
- [ ] feature/zipcode-validator
```

**Changes Made (In-Scope Only):**
1. Extracted existing validateEmail exactly as-is
2. Extracted existing validatePhone exactly as-is
3. Updated UserForm to import from utils/validation
4. Updated ProfileForm to import from utils/validation
5. Verified tests still pass

**Outcome:** Clean refactor, no scope creep, improvements documented for later.

---

## Example 4: Multi-File Feature (API Integration)

### Task Given
"Add user avatar upload feature"

### Scope Definition
```text
SCOPE:
- Goal: Users can upload and display custom avatars
- Files:
  - src/components/AvatarUpload.jsx (create new)
  - src/components/UserProfile.jsx (add AvatarUpload component)
  - src/api/users.js (add uploadAvatar endpoint)
  - src/hooks/useAvatarUpload.js (create new hook)
- Symbols:
  - AvatarUpload component
  - UserProfile component (modify)
  - uploadAvatar function
  - useAvatarUpload hook
- Dependencies:
  - multer (backend - already exists)
  - No new frontend dependencies
```

### Work Process with Blockers

**Blocker 1:** CDN URL construction
```text
⚠️ SCOPE BLOCKER #1

Required change: src/config/cdn.js
Reason: Need BASE_CDN_URL constant for avatar URLs
Impact: MEDIUM

DECISION: Added cdn.js to scope (utility, not feature creep)
```

**Blocker 2:** Image compression
```text
⚠️ SCOPE BLOCKER #2

Required change: Add 'sharp' package for server-side image compression
Reason: Uploaded avatars are too large (10MB+), need compression
Impact: HIGH - Affects performance and storage costs

DECISION: Out of scope for this task
WORKAROUND: Added client-side file size validation (max 2MB)
FOLLOW-UP TASK: Server-side image compression (separate sprint)
```

**Blocker 3:** Cache invalidation
```text
⚠️ SCOPE BLOCKER #3

Required change: src/hooks/useProfile.js - invalidate cache after upload
Reason: Profile still shows old avatar after upload
Impact: HIGH - Feature appears broken without this

DECISION: Added useProfile.js to scope (critical for feature)
```

**Final Scope:**
```text
SCOPE (FINAL):
Original files: 4
Added to scope: 2 (cdn.js, useProfile.js)
Explicitly rejected: 1 (sharp package)

Total files: 6
Follow-up tasks created: 1 (image compression)
```

**Outcome:** Feature delivered within reasonable scope, performance optimization deferred.

---

## Example 5: Emergency Bug Fix

### Task Given
"URGENT: Users can't checkout, payment button disabled"

### Initial Scope (Too Broad)
```text
❌ WRONG SCOPE:
- Goal: Fix checkout
- Files: All checkout-related files
- Symbols: Any checkout code
```

### Correct Scope (Focused)
```text
✅ CORRECT SCOPE:
- Goal: Identify why payment button is disabled
- Files: INVESTIGATION ONLY - no edits until root cause found
- Approach: Use debug-first skill
```

### Investigation → Scope Definition
```text
ROOT CAUSE: src/components/CheckoutButton.jsx:23
Condition: disabled={!cart.items.length || !shippingValid || !billingValid}

Bug: billingValid is undefined (should be true for saved payment methods)

ACTUAL SCOPE:
- Goal: Fix billingValid undefined issue
- Files: src/hooks/useBillingValidation.js
- Symbols: useBillingValidation hook, validateBilling function
- Dependencies: None
```

### Discipline During Emergency
Even under pressure, avoided:
- ❌ "Fixing" other checkout issues noticed during investigation
- ❌ Refactoring CheckoutButton while we're in there
- ❌ Adding new validation features

**Outcome:** Bug fixed in 10 minutes, no new bugs introduced.

---

## Example 6: Documentation Task

### Task Given
"Document the authentication flow"

### Scope Definition
```text
SCOPE:
- Goal: Create authentication flow documentation
- Files:
  - docs/authentication.md (create new)
- Symbols: N/A (documentation only)
- Dependencies: None
- Code changes: NONE (read-only task)
```

### Temptation Encountered
While reading auth code for documentation:
- Noticed missing error handling in login endpoint
- Token refresh logic could be improved
- Password reset doesn't rate-limit

**✅ Discipline Applied:**
```text
📝 DOCUMENTATION-ONLY MODE

Code issues noticed but NOT fixed:
1. src/api/auth.js:45 - Missing try/catch in login
2. src/api/auth.js:78 - Token refresh race condition
3. src/api/auth.js:102 - No rate limiting on password reset

REASON: This is a documentation task, not a code task

OUTCOME:
- Issues documented in docs/authentication.md "Known Issues" section
- Follow-up tasks created for each issue
- NO code changes made
```

**Outcome:** Documentation complete, code issues tracked separately.

---

## Key Patterns from Examples

### Pattern: Blocker Documentation
Every blocker should include:
1. Exact file and line number
2. Reason why change is needed
3. Impact assessment
4. Options for user decision

### Pattern: Scope Expansion
When expanding scope:
1. Document WHY expansion is necessary
2. Get explicit approval
3. Update scope definition
4. Report expanded scope in summary

### Pattern: Deferred Work
When rejecting scope expansion:
1. Document what was noticed
2. Explain why it's out of scope
3. Create follow-up task
4. Verify workaround is acceptable

---

## Quick Decision Tree

```
Need to edit a file?
│
├─ Is it in stated scope?
│  ├─ YES → Proceed
│  └─ NO → STOP
│         │
│         ├─ Critical to task?
│         │  ├─ YES → Report blocker, request scope expansion
│         │  └─ NO → Document for follow-up, skip change
│         │
│         └─ Follow-up created?
│            ├─ YES → Continue with current scope
│            └─ NO → Create follow-up task, then continue
```

---

**Remember:** Every example shows the same principle — **TOUCH ONLY WHAT'S NAMED**. Report everything else.
