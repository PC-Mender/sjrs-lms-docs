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
**Database Status:** `pending` (email_verified: false)
**Workflow Status:** `pending_email_confirmation`
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
**Database Status:** `pending` (email_verified: true)
**Workflow Status:** `profile_incomplete`
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
6. Status changes to `pending_approval`

**Email Template:** `generateProfileCompletionNotificationTemplate()`

### Stage 3: Admin Approval
**Database Status:** `pending` → `active` or `inactive`
**Workflow Status:** `pending_approval` → `active` or `inactive`
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

The system uses a mapping layer to translate between database constraints and workflow terminology:

### Database Status → Workflow Status
- `'pending'` + `email_verified: false` → `'pending_email_confirmation'`
- `'pending'` + `email_verified: true` + `profile_completed: false` → `'profile_incomplete'`
- `'pending'` + `email_verified: true` + `profile_completed: true` → `'pending_approval'`
- `'active'` → `'active'`
- `'inactive'` → `'inactive'`
- `'suspended'` → `'suspended'`

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
    "workflow_status": "pending_email_confirmation"
  }
}
```

### Email Confirmation Response
```json
{
  "success": true,
  "message": "Email verified successfully! Your account is now pending admin approval.",
  "workflow_status": "pending_approval",
  "database_status": "pending"
}
```

## Benefits of This Approach

1. **No Database Migration Required** - Works with existing constraint
2. **Proper Workflow Terminology** - Matches documentation
3. **Clear Status Mapping** - Both database and workflow status provided
4. **Consistent Across Codebase** - All components use mapping system
5. **Backward Compatible** - Existing code continues to work
6. **Type Safety** - Proper TypeScript types for all statuses

## User Experience

- Users see clear workflow status labels throughout the application
- Admin panel shows proper workflow status for user management
- Email notifications use workflow terminology
- System maintains data integrity with existing database schema 