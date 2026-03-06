---
title: "Three Stage Workflow Implementation"
---

# Three-Stage Workflow Implementation Summary

## Overview

This document summarizes the implementation of the three-stage user registration workflow in the SJRS LMS system. The implementation uses a persisted onboarding_status approach to bridge the gap between database constraints and workflow terminology.

## Problem Statement

The original issue was that a single `status` field was being used to represent both:

- **Account status** (active/inactive/suspended)
- **Onboarding stage** (email confirmation, profile completion, pending approval)

This caused confusion and required brittle code-level mapping.

## Solution: Persist onboarding_status separately

We added a new persisted column on `library_users`:

- `status` (account status): `pending | active | inactive | suspended`
- `onboarding_status` (onboarding stage): `pending_email_confirmation | profile_incomplete | pending_approval | complete`

The frontend prefers `onboarding_status` when present and falls back to derived mapping for backward compatibility.

### Mapping Logic

```typescript
// Account Status + Flags → Onboarding Status
status: 'pending' + email_verified: false → onboarding_status: 'pending_email_confirmation'
status: 'pending' + email_verified: true  + profile_completed: false → onboarding_status: 'profile_incomplete'
status: 'pending' + email_verified: true  + profile_completed: true  → onboarding_status: 'pending_approval'
status: 'active' | 'inactive' | 'suspended' → onboarding_status: 'complete'
```

## Files Modified

### 1. Backend Changes (functions/api/auth/index.ts)

**Added Helper Functions:**
```typescript
function mapStatusToWorkflow(status: string, email_verified: boolean, profile_completed?: boolean): string
function mapWorkflowToDatabase(workflowStatus: string): string
```

**Updated API Responses:**
- Registration now returns both `status` and `workflow_status`
- Email confirmation returns `workflow_status` and `database_status`
- All responses include proper workflow terminology

### 2. Frontend Changes

#### Status Constants (src/constants/status.ts)
- ✅ Fixed incorrect status mappings
- ✅ Added helper functions for UI display
- ✅ Proper TypeScript types for all statuses

**Added Functions:**
```typescript
export const mapStatusToWorkflow = (status: string, email_verified: boolean, profile_completed?: boolean): string
export const getWorkflowStatusColor = (status: string, email_verified: boolean, profile_completed?: boolean): string
export const getWorkflowStatusLabel = (status: string, email_verified: boolean, profile_completed?: boolean): string
```

#### User Service (src/services/user.service.ts)
- ✅ Updated statistics to use workflow mapping
- ✅ Proper status counting with email_verified field
- ✅ Fixed import issues and D1 client method calls

#### Auth Context (src/contexts/auth-context-d1.tsx)
- ✅ Updated login redirect logic to use workflow status
- ✅ Proper status checking for pending_approval

#### Type Definitions (src/types/users.ts)
- ✅ Updated UserStatus type to include workflow statuses
- ✅ Added `pending_email_confirmation` to type definition

#### Member List Component (src/pages/members/MemberList.tsx)
- ✅ Updated status column to show workflow status
- ✅ Proper status mapping with email_verified field

## API Response Examples

### Registration Response
```json
{
  "success": true,
  "user": {
    "status": "pending",
    "onboarding_status": "pending_email_confirmation",
    "workflow_status": "pending_email_confirmation"
  }
}
```

### Email Confirmation Response
```json
{
  "success": true,
  "message": "Email verified successfully! Your account is now pending admin approval.",
  "status": "pending",
  "onboarding_status": "profile_incomplete",
  "workflow_status": "profile_incomplete"
}
```

## Three-Stage Workflow Flow

### Stage 1: Email Confirmation
- **Database**: `status: 'pending'`, `email_verified: false`
- **Workflow**: `pending_email_confirmation`
- **Action**: User clicks email confirmation link
- **Result**: `email_verified: true`, status remains `pending`

### Stage 2: Profile Completion
- **Database**: `status: 'pending'`, `email_verified: true`
- **Workflow**: `profile_incomplete`
- **Action**: User completes profile information
- **Result**: `profile_completed: true`, status remains `pending`, ready for admin review

### Stage 3: Admin Approval
- **Database**: `status: 'pending'` → `'active'` or `'inactive'`
- **Workflow**: `pending_approval` → `'active'` or `'inactive'`
- **Action**: Admin approves or rejects account
- **Result**: Final status set by admin

## Benefits Achieved

1. **✅ Clear separation** - Account status vs onboarding stage
2. **✅ DB-authoritative onboarding** - Onboarding stage is stored as a persisted field
3. **✅ Backward compatible** - Clients can still rely on `workflowStatus` / `workflow_status` when present
4. **✅ Type safety** - Optional `onboarding_status` added to relevant TS types

## Testing Results

### Build Status
- ✅ TypeScript compilation: **SUCCESS**
- ✅ Vite build: **SUCCESS**
- ✅ No linter errors: **SUCCESS**

### Deployment Status
- ✅ Cloudflare Workers deployment: **SUCCESS**
- ✅ API endpoints working: **SUCCESS**
- ✅ Email confirmation flow: **WORKING**

## User Experience

- Users see clear workflow status labels throughout the application
- Admin panel shows proper workflow status for user management
- Email notifications use workflow terminology
- System maintains data integrity with existing database schema
- All status displays use the mapping system for consistency

## Future Considerations

1. **Database Schema Update**: If needed in the future, the mapping system can be easily removed once the database constraint is updated
2. **Additional Statuses**: New workflow statuses can be added to the mapping system without database changes
3. **Internationalization**: Status labels can be easily localized using the mapping system
4. **Analytics**: The mapping system provides clear data for workflow analytics

## Maintenance Notes

- Prefer `onboarding_status` (persisted) as the canonical onboarding stage and fall back when needed
- New components should import helper functions from `src/constants/status.ts`
- Database operations should use the actual database status values
- UI displays should use the workflow status values
- API responses should include both status types for clarity

## Conclusion

The three-stage workflow implementation is now complete and fully functional. The status mapping system provides a robust solution that maintains data integrity while delivering the desired user experience. The implementation is production-ready and has been successfully deployed. 
