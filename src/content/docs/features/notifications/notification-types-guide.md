---
title: "Notification Types Guide"
---

# Notification Types Guide

This document provides comprehensive documentation for all three notification systems in the SJRS LMS platform.

## Overview

The platform uses three distinct notification systems, each serving different purposes:

1. **Announcements** - Bulk notifications sent to multiple users
2. **System Notifications** - Platform-wide event notifications with lifecycle management
3. **App Notifications** - User-specific in-app notifications

---

## UI Navigation (Header Menu)

The app exposes these notification areas under the header **Notifications** menu. The exact dashboard prefix varies by role (e.g. `/dashboard-superuser`, `/dashboard-admin`, `/dashboard`).

### Common
- **My Notifications**: `/<dashboard-prefix>/notifications`
  - Shows only the signed-in user's in-app notifications (App Notifications).

### Superuser / Permission-Based
- **System Notifications**: `/<dashboard-prefix>/system-notifications`
  - Requires `notification_events` permissions.
- **App Notifications Log**: `/<dashboard-prefix>/app-notifications-log`
  - Superuser/audit view across users.
- **Announcements**: `/<dashboard-prefix>/announcements`
  - Requires `announcements` permissions.

---

## 1. Announcements

### Purpose
Announcements are bulk notifications sent to multiple users simultaneously. They are designed for one-time communications to groups of users (e.g., all students, all professors, specific user types, or custom user lists).

### Key Characteristics
- **Delivery**: Bulk sending to multiple users at once
- **Storage**: Creates individual entries in the `notifications` table for each recipient
- **Targeting**: Supports targeting by:
  - All users (`'all'`)
  - User types (`'students'`, `'professors'`, `'guests'`)
  - Specific user IDs (array)
  - Students by year of study (`'students-year'` with `studentYears` parameter)
- **Channels**: Both in-app notifications and optional email delivery
- **User Preferences**: Respects user notification preferences (system_notifications, in_app_notifications, email_notifications)

### Database Storage
- **Primary Table**: `announcements` - Tracks each bulk announcement sent
  - Stores: title, message, type, priority, targeting info, delivery statistics, sender, timestamps
  - Tracks: total recipients, notifications created, emails sent, errors
- **Related Table**: `notifications` - Individual notification records created for each recipient
  - Each announcement creates one notification record per recipient user
  - Fields: `user_id`, `title`, `message`, `type`, `priority`, `is_read`, `action_url`, `metadata`

### API Endpoints
- **Send Announcement**: `POST /api/notifications/send-bulk`
  - **Handler**: `functions/api/notifications/handlers/send-bulk-notifications.ts`
  - Creates announcement record in `announcements` table
  - Creates individual notifications in `notifications` table for each recipient
- **List Announcements**: `GET /api/notifications/announcements`
  - **Handler**: `functions/api/notifications/handlers/get-announcements.ts`
  - Supports pagination and filtering (sentBy, type, priority, search)
  - Enriches results with sender information
- **Get Single Announcement**: `GET /api/notifications/announcements/:id` or `GET /api/notifications/announcements?id=:id`
  - Returns full announcement details with sender information
- **Delete Announcement**: `DELETE /api/notifications/announcements/:id`
  - **Handler**: `functions/api/notifications/handlers/delete-announcement.ts`
  - Deletes the announcement record (individual notifications remain in `notifications` table)

### Request Format
```typescript
{
  title: string;
  message: string;
  type?: 'info' | 'success' | 'warning' | 'error' | 'reminder'; // default: 'info'
  priority?: 'low' | 'normal' | 'high' | 'urgent'; // default: 'normal'
  targetUsers: 'all' | 'students' | 'professors' | 'guests' | 'students-year' | number[];
  sendEmail?: boolean; // default: false
  actionUrl?: string;
  metadata?: object;
  studentYears?: number[]; // Required when targetUsers is 'students-year'
}
```

### Response Format
```typescript
{
  message: string;
  summary: {
    totalTargetUsers: number;
    notificationsCreated: number;
    emailsSent: number;
    errors: number;
  };
  details: {
    notificationsCreated: number[];
    emailsSent: number[];
    errors: string[];
  };
}
```

### Frontend Components
- **Location**: `src/components/features/announcements/`
- **Main Components**:
  - `AnnouncementForm` - Form for composing announcements
  - `AnnouncementResults` - Displays sending results
  - `AnnouncementSidebar` - Shows user statistics
  - `AnnouncementsList` - Paginated list of sent announcements with filtering
  - `AnnouncementDetail` - Detailed view of a single announcement
- **Page**: `/announcements` (requires `announcements` resource permissions)
  - **Tabs**: 
    - "Compose" - Send new announcements
    - "Manage" - View and manage sent announcements (list, view details, delete)
- **Documentation**: `src/components/features/announcements/README.md`

### Use Cases
- Sending important updates to all users
- Notifying specific user groups about policy changes
- Announcing library events or new features
- Sending reminders to students in specific years

### Example
```typescript
// Send announcement to all students
await fetch('/api/notifications/send-bulk', {
  method: 'POST',
  body: JSON.stringify({
    title: 'Library Hours Update',
    message: 'The library will have extended hours during finals week.',
    type: 'info',
    priority: 'normal',
    targetUsers: 'students',
    sendEmail: true
  })
});
```

---

## 2. System Notifications

### Purpose
System Notifications are **platform-wide event notifications automatically pulled from external sources**. They are designed for system health, deployment status, and platform updates - NOT user-specific transactions. They support full lifecycle management, scheduling, expiration, status tracking, and permission-based visibility.

**Key Sources:**
- **Deployment Events** - When new deployments are done (from release pipeline)
- **Platform Updates** - Version updates, feature releases
- **Cloudflare Analytics** - Performance metrics, threshold breaches
- **Sentry** - Error tracking, system issues, exceptions
- **System-Side Issues** - Infrastructure problems, maintenance windows

### Key Characteristics
- **Lifecycle Management**: Supports draft, scheduled, active, resolved, and archived states
- **Scheduling**: Can be scheduled for future publication (`publish_at`) and expiration (`expires_at`)
- **Categories**: Supports multiple categories:
  - `deployment` - System deployments
  - `platform-update` - Platform updates
  - `incident` - System incidents
  - `maintenance` - Scheduled maintenance
  - `announcement` - General announcements
  - `policy` - Policy changes
  - `event` - Library events
- **Severity Levels**: `info`, `notice`, `warning`, `critical`
- **Targeting**: Supports global, user-specific, role-based, or permission-based targeting
- **User Interaction**: Users can acknowledge, dismiss, or pin notifications
- **Sticky Notifications**: Can be marked as sticky to remain visible
- **Version Tracking**: Can include version information for platform updates

### Database Storage
- **Primary Table**: `notification_events`
- **Related Tables**:
  - `notification_event_targets` - Specifies target audience
  - `notification_event_acknowledgements` - Tracks user interactions (acknowledge, dismiss, pin)
- **Structure**: One event record that can be displayed to multiple users based on targeting

### API Endpoints
- **List Events (Admin)**: `GET /api/notifications/events`
- **List Events (User Feed)**: `GET /api/notifications/feed`
- **Ingest Event (External Sources Only)**: `POST /api/notifications/events/ingest`
  - **Authentication**: Token-based via `x-notification-ingest-token` header
  - **Supported Sources**: `release:pipeline`, `monitoring:sentry`, `analytics:cloudflare`
  - **Purpose**: Automatically create System Notifications from external systems
  - **Note**: System Notifications are **auto-generated only**. For emergency cases, use **Announcements** instead.
- **Update Event**: `PUT /api/notifications/events/:id`
- **Delete Event**: `DELETE /api/notifications/events/:id`

### Frontend Components
- **Admin Page**: `/dashboard-superuser/system-notifications` (requires `notification_events` resource permissions)
- **Component**: `src/pages/dashboard-superuser/notification-center.tsx`
- **User Feed**: Integrated into user notification feed
- **Note**: View-only interface - System Notifications are **auto-generated only**

### Use Cases
- **Auto-Generated Only**:
  - Deployment notifications (from release pipeline)
  - Platform update notifications (from version system)
  - Incident reporting (from Sentry)
  - Performance alerts (from Cloudflare Analytics)
  - System health notifications

### Emergency Cases
- **For manual/emergency notifications**, use **Announcements** instead
- Announcements support full CRUD and can be sent immediately to all users or specific groups
- See [Announcements section](#1-announcements) above for details

### Example (Ingest Endpoint - External Sources Only)
```typescript
// External system (e.g., deployment pipeline) creates System Notification
await fetch('/api/notifications/events/ingest', {
  method: 'POST',
  headers: {
    'x-notification-ingest-token': 'your-token-here',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    source: 'release:pipeline',
    release: {
      version: '1.2.3',
      environment: 'production',
      status: 'success'
    },
    title: 'Deployment 1.2.3 (production)',
    message: 'Deployment to production completed successfully.',
    category: 'deployment',
    severity: 'notice'
  })
});
```

---

## 3. App Notifications (User-Specific In-App Notifications)

### Purpose
App Notifications are **automatic user-specific in-app notifications** stored individually for each user. They are the most granular notification type and are used for personal notifications, loan reminders, order updates, and other user-specific communications. These notifications are **automatically generated** by the system based on user actions and system events.

### Key Characteristics
- **User-Specific**: Each notification is tied to a specific user (`user_id`)
- **Automatic Generation**: Created automatically by the system based on events (loans, payments, orders, etc.)
- **Read Status**: Tracks whether the user has read the notification (`is_read`)
- **Types**: `info`, `success`, `warning`, `error`, `reminder`
- **Priority**: `low`, `normal`, `high`, `urgent`
- **Action URLs**: Can include action URLs for navigation
- **Metadata**: Supports JSON metadata for additional context
- **Lifecycle**: Simple create, read, delete lifecycle

### Database Storage
- **Table**: `notifications`
- **Structure**: One record per notification per user
- **Fields**: `id`, `user_id`, `title`, `message`, `type`, `priority`, `is_read`, `action_url`, `metadata`, `created_at`, `updated_at`

### API Endpoints

#### User Endpoints (Regular Users)
- **List App Notifications**: `GET /api/notifications/app` (returns only current user's notifications)
- **Get App Notification**: `GET /api/notifications/app/:id` (only own notifications)
- **Update App Notification**: `PUT /api/notifications/app/:id` (only own notifications)
- **Delete App Notification**: `DELETE /api/notifications/app/:id` (only own notifications)
- **Mark All as Read**: `PUT /api/notifications/app/mark-all-read` (only own notifications)

#### Admin/Superuser Endpoints
- **List All App Notifications**: `GET /api/notifications/all` (superuser only - view all users' notifications)
- **Get Notification Statistics**: `GET /api/notifications/stats` (superuser only - delivery statistics)

#### Administrative Create (Restricted)
- **Create App Notification**: `POST /api/notifications/app`
  - Intended for privileged/administrative flows only.
  - Regular users should not manually create notifications.

### Automatic Generation - What's Implemented ✅

App Notifications are **automatically created** by the system in the following scenarios:

#### 1. **Loan Notifications** ✅
- **Loan Created** - When a loan is created
  - Type: `success`, Priority: `normal`
  - Recipient: Loan owner
  - Includes: book title, copy number, due date, loan type
  - Location: `functions/lib/notifications/transaction-notifications.ts`

- **Loan Status Changed** - When loan status changes
  - `returned` → Type: `success`, Priority: `normal`
  - `overdue` (<14 days) → Type: `warning`, Priority: `high`
  - `overdue` (≥14 days) → Type: `error`, Priority: `urgent`
  - `approved` → Type: `success`, Priority: `normal`
  - `rejected` → Type: `warning`, Priority: `normal`
  - Recipient: Loan owner
  - Location: `functions/lib/notifications/transaction-notifications.ts`

#### 2. **Payment Notifications** ✅
- **Payment Received** - When payment is processed
  - Type: `success`, Priority: `normal`
  - Recipient: Payment owner
  - Includes: amount, receipt number, transaction ID, penalty info, payment method
  - Location: `functions/lib/notifications/transaction-notifications.ts`

#### 3. **Order Notifications** ✅
- **New Borrow Request** - When an order is created
  - Type: `info`, Priority: `high`
  - Recipient: **Admins/Librarians** (not the requester)
  - Checks: `order_notifications` and `in_app_notifications` user preferences
  - Only sends to users with roles: `superuser`, `admin`, `librarian`, `dean`
  - Location: `functions/api/orders/handlers/create-order.ts`

### Automatic Generation - What's Missing ❌

The following automatic notifications are **not yet implemented**:

#### 1. **Penalty Notifications** ❌
- **When**: Penalty is created for a user
- **Who should receive**: The user who got the penalty
- **Expected**: Notification with penalty details, amount, reason, due date
- **Location**: `functions/api/penalties/handlers/create-penalty.ts`

#### 2. **Order Status Notifications** ❌
- **When**: Order is approved, rejected, or cancelled
- **Who should receive**: The user who created the order
- **Expected**: Notification when order status changes
- **Location**: `functions/api/orders/handlers/update-order.ts`

#### 3. **Borrow Limit Notifications** ❌
- **When**: User tries to borrow but has reached max books limit
- **Who should receive**: The user who tried to borrow
- **Expected**: Notification warning about borrow limit
- **Location**: `functions/api/orders/handlers/create-order.ts`

#### 4. **Loan Due Date Reminders** ❌
- **When**: X days before loan due date (e.g., 3 days, 1 day)
- **Who should receive**: Users with loans approaching due date
- **Expected**: Scheduled reminders before due date
- **Note**: Requires scheduled task (cron job) implementation

#### 5. **Wishlist Notifications** ❌
- **When**: Book in user's wishlist becomes available (status changes to 'available')
- **Who should receive**: Users who have the book in their wishlist
- **Expected**: Notification that book is now available
- **Note**: Requires trigger when book copy status changes

### User Preferences & Permissions

#### Current Status ⚠️
- **Order Notifications**: ✅ Checks `order_notifications` and `in_app_notifications` preferences
- **Loan/Payment Notifications**: ❌ Do not check user preferences yet
- **Permission-Based Order Notifications**: ⚠️ Uses role names instead of permissions

#### Recommended Improvements
- Add preference checks for all notification types (`in_app_notifications`, `loan_notifications`, `order_notifications`)
- Replace role-based order notifications with permission-based checks (`orders:read`, `orders:update`)

### Frontend Components

#### User View (Regular Users)
- **Location**: `src/pages/notifications/`
- **User Page**: `/dashboard/notifications` (users can view their own notifications only)
- **Components**:
  - `NotificationList` - List view with search and actions (view-only, no create/edit)
  - `NotificationShow` - Detailed view of a single notification
- **Features**:
  - ✅ View own notifications
  - ✅ Mark as read/unread
  - ✅ Delete own notifications
  - ✅ Search and filter
  - ❌ **No create/edit access** (notifications are automatic)

#### Superuser View (Delivery Log)
- **Page**: `/dashboard-superuser/app-notifications-log`
- **Purpose**:
  - View all app notifications across all users
  - Filter by user, notification type, date range
  - See delivery statistics
  - Track notification delivery status
- **Component**: `src/pages/dashboard-superuser/app-notifications-log.tsx`

#### Legacy Create/Edit Pages (Should Be Removed)
- **Note**: The following pages exist but **should not be accessible** for regular users:
  - `NotificationCreate` - `/dashboard/notifications/create` (should be removed or superuser-only)
  - `NotificationEdit` - `/dashboard/notifications/edit/:id` (should be removed or superuser-only)
- **Reason**: App Notifications are **automatic only** - users cannot manually create/edit them

### Use Cases
- ✅ Loan created confirmations
- ✅ Loan status updates (returned, overdue, approved, rejected)
- ✅ Payment receipts
- ✅ New borrow request notifications (to admins)
- ❌ Loan due date reminders (not yet implemented)
- ❌ Order status updates (not yet implemented)
- ❌ Penalty assignments (not yet implemented)
- ❌ Borrow limit warnings (not yet implemented)
- ❌ Wishlist availability (not yet implemented)

### Example (Automatic Generation)
```typescript
// App Notifications are automatically created by the system
// Example: When a loan is created, the system automatically calls:
await createAppNotification(env, {
  userId: loan.user_id,
  title: `Loan Created • ${loan.book_title}`,
  message: `Your loan has been created successfully.\n• Book: ${loan.book_title}\n• Due Date: ${dueDateFormatted}`,
  type: 'success',
  priority: 'normal',
  actionUrl: `${frontendUrl}/dashboard/loans`,
  metadata: {
    transactionType: 'loan-created',
    loanId: loan.id,
    dueDate: loan.due_date,
  },
});
```

### Implementation Details
- **Helper Function**: `functions/lib/notifications/app-notifications.ts`
  - `createAppNotification()` - Creates a single App Notification
  - `createBulkAppNotifications()` - Creates multiple App Notifications in bulk
- **Transaction Notifications**: `functions/lib/notifications/transaction-notifications.ts`
  - `publishLoanCreatedNotification()` - Creates notification when loan is created
  - `publishLoanStatusNotification()` - Creates notification when loan status changes
  - `publishPaymentReceiptNotification()` - Creates notification when payment is received

### Related Documentation
- **Comprehensive Analysis**: `docs/features/notifications/APP-NOTIFICATIONS-ANALYSIS.md`
- **Implementation Status**: See analysis document for detailed breakdown of what's done vs what's missing

---

## Comparison Table

| Feature | Announcements | System Notifications | App Notifications |
|---------|--------------|---------------------|------------------|
| **Purpose** | Bulk messaging | Platform-wide events | User-specific messages |
| **Storage** | `notifications` table (one per user) | `notification_events` table | `notifications` table |
| **Targeting** | User types, roles, custom lists | Global, role, permission, user | Single user |
| **Lifecycle** | Simple (create → send) | Full (draft → scheduled → active → resolved → archived) | Simple (create → read → delete) |
| **Scheduling** | No | Yes (publish_at, expires_at) | No |
| **User Interaction** | Read/delete | Acknowledge/dismiss/pin | Read/delete |
| **Categories** | No | Yes (7 categories) | No (types only) |
| **Severity** | No | Yes (4 levels) | No (priority only) |
| **Sticky** | No | Yes | No |
| **Version Tracking** | No | Yes | No |
| **Email Support** | Optional | No (via announcements) | No |
| **Use Case** | One-time bulk messages | System events, maintenance | Personal notifications |

---

## When to Use Each Type

### Use Announcements When:
- You need to send a message to multiple users at once
- You want to target specific user groups (students, professors, etc.)
- You need optional email delivery
- The message is a one-time communication
- You want to respect user notification preferences

### Use System Notifications When:
- You need to announce platform-wide events
- You need scheduling (future publication or expiration)
- You need lifecycle management (draft, active, resolved)
- You want users to acknowledge or dismiss notifications
- You need to track incidents, maintenance, or deployments
- You want sticky notifications that remain visible
- You need version tracking for platform updates

### Use App Notifications When:
- You need to notify a single specific user
- The notification is personal (loans, orders, account)
- You need simple read/unread tracking
- The notification doesn't need scheduling or lifecycle management
- You want the simplest notification type

---

## Integration Points

### User Notification Preferences
All three notification types respect user notification preferences stored in `user_notification_preferences`:
- `system_notifications` - Controls system-wide notifications
- `in_app_notifications` - Controls in-app notification delivery
- `email_notifications` - Controls email delivery

### Notification Feed
The user notification feed (`/api/notifications/feed`) combines:
- System Notifications that match the user's targeting
- User-specific App Notifications from the `notifications` table

### Permissions
- **Announcements**: Requires `announcements` resource permissions
- **System Notifications**: Requires `notification_events` resource permissions
- **App Notifications**: User-specific, no special permissions needed (users can only see their own)

---

## Best Practices

### Announcements
- Use clear, concise titles
- Target appropriately (don't spam all users for student-specific messages)
- Respect user preferences
- Use appropriate priority levels
- Include action URLs when relevant

### System Notifications
- Use appropriate categories for better organization
- Set expiration dates for time-sensitive notifications
- Use severity levels appropriately (don't mark everything as critical)
- Schedule maintenance notifications in advance
- Mark incidents as resolved when fixed
- Use sticky notifications sparingly

### App Notifications
- Keep messages concise and actionable
- Use appropriate types (reminder for due dates, success for confirmations)
- Include action URLs for easy navigation
- Don't create duplicate notifications
- Clean up old notifications periodically

---

## Related Documentation

- **Announcements**: `src/components/features/announcements/README.md`
- **App Notifications Module**: `docs/features/notifications/README.md`
- **Email Service**: `docs/features/email-service/README.md`
- **Database Schema**: `sql/d1-schema.sql`

---

**Last Updated**: December 2025  
**Version**: 1.1

