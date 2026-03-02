---
title: "Account Status & Onboarding Management"
description: Comprehensive guide to account lifecycle, status tracking, and onboarding workflows
---

# Account Status & Onboarding Management

## Overview

The SJRS LMS now features comprehensive account status and onboarding tracking that provides administrators with clear visibility into each user's lifecycle state. This system tracks both **account status** (account state) and **onboarding status** (user setup progress) separately for better visibility and control.

**Version**: Introduced in v3.49.0 (March 2, 2026)

---

## Account Status vs. Onboarding Status

### Account Status
Represents the **account state** within the system:
- **Active**: User account is fully functional and active
- **Pending Verification**: Email verification pending
- **Pending Approval**: Awaiting administrative approval
- **Rejected**: Account application was rejected
- **Suspended**: Account has been suspended
- **Deactivated**: User account has been closed/deactivated

### Onboarding Status
Represents the **user setup progress** through the onboarding workflow:
- **Not Started**: User hasn't begun the onboarding process
- **In Progress**: User has started but not completed onboarding
- **Completed**: User has finished all onboarding steps
- **Skipped**: User skipped the onboarding process

---

## Database Schema

### New Migration (v3.49.0)
```sql
-- Migration: 2026-03-01_add-onboarding-status-to-library-users.sql
ALTER TABLE library_users ADD COLUMN onboarding_status TEXT;
-- Backfilled with 'completed' for existing users
-- New users default to 'not-started'
```

### Fields
- **Field**: `library_users.onboarding_status`
- **Type**: TEXT
- **Values**: `'not-started' | 'in-progress' | 'completed' | 'skipped'`
- **Default**: `'not-started'` for new users
- **Backfill**: Existing users set to `'completed'` for backward compatibility

---

## Status Lifecycle

### Typical User Lifecycle

```
Registration
    ↓
Email Confirmation (Account Status: Pending Verification)
    ↓
Profile Completion + Onboarding (Onboarding Status: In Progress)
    ↓
Approval (if required) (Account Status: Pending Approval → Active)
    ↓
Onboarding Complete (Onboarding Status: Completed)
    ↓
Active User (Account Status: Active, Onboarding Status: Completed)
```

### Status Transitions

#### Email Confirmation
- **Triggered**: User clicks email confirmation link
- **Updates**: Account Status → `pending-approval` (if approval required) or `active`
- **Onboarding Status**: Advances if user completes profile

#### Profile Completion
- **Triggered**: User completes profile/onboarding form
- **Updates**: Onboarding Status → `in-progress` or `completed`
- **Prerequisite**: Account Status must be `active`

#### Administrative Approval
- **Triggered**: Admin approves/rejects pending user
- **Approval**: Account Status → `active` + triggers onboarding start
- **Rejection**: Account Status → `rejected`
- **Audit Logged**: All approval/rejection actions

#### Onboarding Completion
- **Triggered**: User completes all onboarding steps
- **Updates**: Onboarding Status → `completed`
- **Verification**: Backend validates completion before marking as done

---

## Administration Features

### Viewing Status Information

#### Admin Lists (Professors, Students, Guests, Members)
Each admin list displays both status types in a structured format:

```
Name            | Account Status    | Onboarding Status | Role
─────────────────────────────────────────────────────────────────
John Smith      | Active           | Completed         | Student
Jane Doe        | Pending Approval | In Progress       | Professor
Bob Johnson     | Active           | Not Started       | Guest
```

#### Members Directory (v3.49.0 Enhanced)
- **Layout**: Improved 3-up grid with clearer information grouping
- **Row Grouping**: 
  - Row 1: User type, Account status
  - Row 2: Onboarding status, Role
  - Row 3: Phone, Registration year
- **Status Badges**: Color-coded status indicators for quick identification
- **Filter Options**: Filter by account status and onboarding status

### Modifying Onboarding Status

#### Guest Edit Modal (Onboarding-Specific)
- **Constraint**: Guest edit modal restricts onboarding selector to onboarding-only values
- **Allowed Values**: 
  - `in-progress`
  - `completed`
  - `skipped`
- **Use Case**: Allows admins to manually adjust guest onboarding progress

#### Edit Student/Professor
- **Full Status Access**: Can update any status field (account + onboarding)
- **Workflow Options**: Can reset or advance onboarding status as needed
- **Audit Trail**: All changes are audit logged

### Bulk Operations
- **Approve Users**: Update multiple pending users to active
- **Skip Onboarding**: Bulk-skip onboarding for groups of users
- **Reset Status**: Admin can reset onboarding for problematic users

---

## Backend API Changes

### New Endpoints (v3.49.0)

#### Get Professor Metadata
```
GET /api/v1/professors/:id/meta

Response:
{
  success: true,
  data: {
    id: number,
    account_status: string,
    onboarding_status: string,
    // ... other metadata
  }
}
```

#### Get Student Metadata
```
GET /api/v1/students/:id/meta

Response:
{
  success: true,
  data: {
    id: number,
    account_status: string,
    onboarding_status: string,
    // ... other metadata
  }
}
```

### Updated Endpoints

#### Check Status
- **Endpoint**: `POST /api/auth/check-status`
- **Enhanced**: Refactored status helpers and next-steps logic
- **Returns**: 
  - Current account status
  - Current onboarding status
  - Recommended next action

#### Update User
- **Endpoint**: `PUT /api/users/:id`
- **Enhanced**: Can now update `onboarding_status` field
- **Validation**: Enforces valid status transitions

### Service Layer Updates

#### Status Check Services
- **File**: `functions/api/auth/services/status-check-helpers.ts`
- **Functions**: 
  - `checkAccountStatus()` - Validates account access
  - `checkOnboardingStatus()` - Validates onboarding progress
  - `getStatusCheckNext()` - Determines next action

#### Status Check Next Steps
- **File**: `functions/api/auth/services/status-check-next-steps.ts`
- **Logic**: Determines what action user should take next based on both statuses

---

## Frontend Integration

### Component Updates

#### Student Table Columns
- Added: `Account Status` column
- Added: `Onboarding Status` column
- Sorting: Both columns sortable
- Filtering: Filter by status values

#### Guest Edit Modal
- Status Selector: Restricted to onboarding values only
- Validation: Prevents invalid status combinations

#### Members Directory Cards
- Layout: Reorganized to show both statuses clearly
- Grouping: Information grouped by relevance
- Badges: Color-coded status indicators

### Hooks & Utilities

#### Status Constants Refactoring
The monolithic `status.ts` has been split into specialized modules:
- `user-status.ts` - User/account status constants
- `book-status.ts` - Book and media status constants
- `misc-status.ts` - Miscellaneous status constants
- `status-helpers.ts` - Common helper functions

---

## Best Practices

### For Administrators

1. **Account vs. Onboarding**: Remember these represent different aspects
   - Account Status = Can they access the system?
   - Onboarding Status = Have they completed setup?

2. **User Creation Workflow**:
   - Invite user → Account Status: Pending Verification
   - User confirms email → Account Status: Active
   - User completes profile → Onboarding Status: In Progress
   - Admin approves → Account Status: Active, Onboarding Status: Completed

3. **Troubleshooting**:
   - User can't login? Check Account Status
   - User hasn't set profile? Check Onboarding Status
   - Need more info? Use filter to find similar users

### For Developers

1. **Always Persist Onboarding State**: Use database field, not session
2. **Update on Key Events**: Trigger updates on profile completion, approval, etc.
3. **Idempotent Updates**: Status updates should be idempotent
4. **Audit Trail**: Log all status changes for compliance
5. **Type Safety**: Use status constants, never magic strings

---

## Migration Guide

### For Existing Installations (v3.48.x → v3.49.0)

1. **Database Migration**: 
   ```bash
   # Automatic via D1 migrations
   # lib table: onboarding_status field added
   # Backfilled with 'completed' for all existing users
   ```

2. **No Code Changes Required**: 
   - New field is optional
   - Existing code continues to work
   - Defaults handle old data gracefully

3. **Admin UI Update**: 
   - Admin lists automatically show new status columns
   - No configuration needed
   - Filter options auto-enable

---

## Examples

### Check User Status (API)
```typescript
// Frontend
const response = await fetch('/api/auth/check-status', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ user_id: 123 })
});

const { data } = await response.json();
console.log(data.account_status);      // 'active' | 'pending-verification' | etc.
console.log(data.onboarding_status);   // 'completed' | 'in-progress' | etc.
```

### Display Status (React)
```tsx
import { getStatusColor, getStatusLabel } from '@/utilities/status-helpers';

function UserStatusBadge({ accountStatus, onboardingStatus }) {
  return (
    <div>
      <span className={`badge ${getStatusColor(accountStatus)}`}>
        {getStatusLabel(accountStatus)}
      </span>
      <span className={`badge ${getStatusColor(onboardingStatus)}`}>
        {getStatusLabel(onboardingStatus)}
      </span>
    </div>
  );
}
```

### Update Onboarding Status (Backend)
```typescript
// functions/api/users/handlers/update-user.ts
export async function handleUpdateUser(req) {
  const { onboarding_status, ...otherFields } = req.body;

  // Validate onboarding status
  const validStatuses = ['not-started', 'in-progress', 'completed', 'skipped'];
  if (!validStatuses.includes(onboarding_status)) {
    return createErrorResponse('Invalid onboarding status', 400);
  }

  // Update in database
  const result = await db.execute(
    `UPDATE library_users 
     SET onboarding_status = ? 
     WHERE id = ?`,
    [onboarding_status, req.params.id]
  );

  // Audit log
  await ActionLogger.log({
    action: 'UPDATE_ONBOARDING_STATUS',
    target: req.params.id,
    value: onboarding_status
  });

  return createUpdatedResponse(result);
}
```

---

## Troubleshooting

### Common Issues

#### User Shows "Pending Verification" After Email Confirmed
- **Cause**: Email confirmation status not updated in database
- **Fix**: Run email confirmation handler again or manually update account status

#### Onboarding Status Shows "Not Started" for Active Users
- **Cause**: Old user data not backfilled (if migrating from older version)
- **Fix**: Run backfill script to set existing users to 'completed'
- **Prevention**: Migration handles this automatically in v3.49.0+

#### Can't Update Guest Onboarding Status
- **Cause**: Guest edit modal has validation restrictions
- **Fix**: Use appropriate onboarding values or edit via admin API endpoint

---

## Related Documentation

- [Users Module](/features/users/) - General user management
- [Students Module](/features/students/) - Student-specific features
- [Members Directory](/features/members/) - Member administration
- [Authentication Flow](/development/auth-flow) - Login and registration flow
- [Audit Logging](/features/action-logging) - Audit trail and compliance

