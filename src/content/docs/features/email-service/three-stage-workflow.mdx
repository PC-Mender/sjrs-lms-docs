---
title: "Three Stage Workflow"
---

# Three-Stage User Registration Workflow

## Overview

The SJRS LMS implements a comprehensive three-stage user registration process designed for three user types: **Student**, **Professor**, and **Guest**. This workflow ensures proper verification, profile completion, and administrative oversight while providing a smooth user experience.

## User Types and Requirements

### 1. Student
**Required Profile Fields:**
- Phone number
- Registration number
- Year of study

### 2. Professor
**Required Profile Fields:**
- Phone number
- Stream/Department

### 3. Guest
**Required Profile Fields:**
- Phone number
- Institution/Organization

## Three-Stage Process Flow

### Stage 1: Email Confirmation
**Account Status (DB):** `pending` (email_verified: false)
**Onboarding Status (DB):** `pending_email_confirmation`
**Duration:** 24 hours (confirmation link expires)

**Process:**
1. User registers with email and password
2. System generates confirmation token
3. Email confirmation template sent with:
   - Welcome message
   - Three-stage process explanation
   - Visual timeline showing current stage
   - Security notices
4. User clicks confirmation link
5. Status remains `pending` but email_verified becomes `true`

**Email Template:** `generateEmailConfirmationTemplate()`

### Stage 2: Profile Completion
**Account Status (DB):** `pending` (email_verified: true)
**Onboarding Status (DB):** `profile_incomplete`
**Duration:** User-dependent (immediate upon completion)

**Process:**
1. User logs in and accesses profile completion page
2. System presents required fields based on user type
3. User fills in all required information
4. System validates and saves profile data
5. Profile completion notification email sent with:
   - Success confirmation
   - Submitted profile details summary
   - Updated progress timeline
   - Next steps information
6. Onboarding status changes to `pending_approval`

**Email Template:** `generateProfileCompletionNotificationTemplate()`

### Stage 3: Admin Approval
**Account Status (DB):** `pending` → `active` or `inactive`
**Onboarding Status (DB):** `pending_approval` → `complete`
**Duration:** 24-48 hours (admin review time)

**Process:**
1. Admin reviews user profile in admin panel
2. Admin can approve or reject the account
3. If approved: status changes to `active`
4. If rejected: status changes to `inactive`
5. User receives notification email about approval/rejection
6. Approved users can access the system
7. Rejected users must contact admin for clarification

**Email Templates:** 
- `generateAccountApprovedTemplate()`
- `generateAccountRejectedTemplate()`

## Status Mapping System

The system uses **two persisted fields** to avoid conflating onboarding state with account state:

- `status` (account status): `pending | active | inactive | suspended`
- `onboarding_status` (onboarding stage): `pending_email_confirmation | profile_incomplete | pending_approval | complete`

### Account Status + Flags → Onboarding Status
- `status: 'pending'` + `email_verified: false` → `onboarding_status: 'pending_email_confirmation'`
- `status: 'pending'` + `email_verified: true` + `profile_completed: false` → `onboarding_status: 'profile_incomplete'`
- `status: 'pending'` + `email_verified: true` + `profile_completed: true` → `onboarding_status: 'pending_approval'`
- `status: 'active' | 'inactive' | 'suspended'` → `onboarding_status: 'complete'`

### Implementation Details

**Backend (functions/api/auth/index.ts):**
```typescript
// Helper functions for status mapping
function mapStatusToWorkflow(status: string, email_verified: boolean, profile_completed?: boolean): string
function mapWorkflowToDatabase(workflowStatus: string): string
```

**Frontend (src/constants/status.ts):**
```typescript
// Helper functions for UI display
export const mapStatusToWorkflow = (status: string, email_verified: boolean, profile_completed?: boolean): string
export const getWorkflowStatusColor = (status: string, email_verified: boolean, profile_completed?: boolean): string
export const getWorkflowStatusLabel = (status: string, email_verified: boolean, profile_completed?: boolean): string
```

## API Responses

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
  "onboarding_status": "profile_incomplete"
}
```

## Benefits of This Approach

1. **Clear separation of concerns** - Account state vs onboarding stage
2. **DB-authoritative onboarding** - Onboarding stage is persisted as a first-class field
3. **Consistent across backend + frontend** - UI can prefer `onboarding_status` and fall back when needed
4. **Backward compatible** - Existing clients can still use `workflowStatus` / `workflow_status` where present

## User Experience

- Users see clear workflow status labels throughout the application
- Admin panel shows proper workflow status for user management
- Email notifications use workflow terminology
- System maintains data integrity with existing database schema