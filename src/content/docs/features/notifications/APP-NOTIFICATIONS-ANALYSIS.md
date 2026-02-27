---
title: "APP NOTIFICATIONS ANALYSIS"
---

# App Notifications - Comprehensive Analysis

## Overview

This document analyzes the **App Notifications** feature - user-specific in-app notifications stored in the `notifications` table. These are different from System Notifications (which are platform-wide events).

---

## ✅ Current Implementation Status

### What Exists

#### 1. **UI Components** ✅
- **List Page**: `/dashboard/notifications` - Shows user's notifications in a table
- **Create Page**: `/dashboard/notifications/create` - Form to create new notifications
- **Edit Page**: `/dashboard/notifications/edit/:id` - Form to edit existing notifications
- **View Page**: `/dashboard/notifications/show/:id` - Detailed view of notification

**Features**:
- ✅ Search functionality
- ✅ Filter by type, priority, read status
- ✅ Mark as read/unread
- ✅ Delete notifications
- ✅ Create/Edit/View notifications
- ✅ Pagination

#### 2. **API Endpoints** ✅
- `GET /api/notifications` - List user's notifications
- `GET /api/notifications/:id` - Get single notification
- `POST /api/notifications` - Create notification
- `PUT /api/notifications/:id` - Update notification
- `DELETE /api/notifications/:id` - Delete notification
- `PUT /api/notifications/mark-all-read` - Mark all as read

#### 3. **Automatic Generation** ✅

**Currently Auto-Generated:**

1. **Loan Notifications** (`functions/lib/notifications/transaction-notifications.ts`)
   - ✅ **Loan Created** - When loan is created
     - Type: `success`
     - Priority: `normal`
     - Recipient: Loan owner
   
   - ✅ **Loan Status Changed** - When loan status changes
     - `returned` → Type: `success`, Priority: `normal`
     - `overdue` (<14 days) → Type: `warning`, Priority: `high`
     - `overdue` (≥14 days) → Type: `error`, Priority: `urgent`
     - `approved` → Type: `success`, Priority: `normal`
     - `rejected` → Type: `warning`, Priority: `normal`
     - Recipient: Loan owner

2. **Payment Notifications** (`functions/lib/notifications/transaction-notifications.ts`)
   - ✅ **Payment Received** - When payment is processed
     - Type: `success`
     - Priority: `normal`
     - Recipient: Payment owner
     - Includes: amount, receipt number, transaction ID, penalty info

3. **Order Notifications** (`functions/api/orders/handlers/create-order.ts`)
   - ✅ **New Borrow Request** - When order is created
     - Type: `info`
     - Priority: `high`
     - Recipient: **Admins/Librarians** (not the requester)
     - Checks: `order_notifications` and `in_app_notifications` preferences
     - Only sends to users with roles: `superuser`, `admin`, `librarian`, `dean`

---

## ❌ Missing Functionality

### 1. **Penalty Notifications** ❌
**Issue**: No App Notifications created when penalties are assigned
- **When**: Penalty is created for a user
- **Who should receive**: The user who got the penalty
- **Current**: No notification sent
- **Expected**: Notification with penalty details, amount, reason, due date

**Location**: `functions/api/penalties/handlers/create-penalty.ts`

**Recommendation**: Add notification creation after penalty is created:
```typescript
await createAppNotification(env, {
  userId: penalty.user_id,
  title: `Penalty Assigned • ${formatCurrency(penalty.amount)}`,
  message: `A penalty has been assigned to your account.\n• Amount: ${formatCurrency(penalty.amount)}\n• Reason: ${penalty.reason}\n• Due Date: ${formatDate(penalty.due_date)}`,
  type: 'warning',
  priority: 'high',
  actionUrl: `${frontendUrl}/dashboard/penalties`,
  metadata: {
    transactionType: 'penalty-assigned',
    penaltyId: penalty.id,
    amount: penalty.amount,
    reason: penalty.reason,
  },
});
```

### 2. **Borrow Limit Notifications** ❌
**Issue**: No App Notifications when user reaches/exceeds borrow limit
- **When**: User tries to borrow but has reached max books limit
- **Who should receive**: The user who tried to borrow
- **Current**: Error message shown, but no persistent notification
- **Expected**: Notification warning about borrow limit

**Location**: `functions/api/orders/handlers/create-order.ts` (line 87)

**Recommendation**: Add notification when borrow limit is exceeded:
```typescript
await createAppNotification(env, {
  userId: user.id,
  title: 'Borrow Limit Reached',
  message: `You have reached your maximum borrow limit of ${maxBooks} books. Please return some books before borrowing more.`,
  type: 'warning',
  priority: 'normal',
  actionUrl: `${frontendUrl}/dashboard/loans`,
  metadata: {
    transactionType: 'borrow-limit-reached',
    maxBooks,
    currentLoans: activeLoansCount,
  },
});
```

### 3. **Wishlist Notifications** ❌
**Issue**: No App Notifications when wishlist item becomes available
- **When**: Book in user's wishlist becomes available (status changes to 'available')
- **Who should receive**: Users who have the book in their wishlist
- **Current**: No notification sent
- **Expected**: Notification that book is now available

**Location**: Need to add trigger when book copy status changes

**Recommendation**: Add notification when book becomes available:
```typescript
// When book copy status changes to 'available'
const wishlistUsers = await env.DB.prepare(`
  SELECT DISTINCT user_id FROM wishlist WHERE book_id = ?
`).bind(bookId).all();

for (const user of wishlistUsers.results) {
  await createAppNotification(env, {
    userId: user.user_id,
    title: `Book Available • ${bookTitle}`,
    message: `A book from your wishlist is now available for borrowing.`,
    type: 'info',
    priority: 'normal',
    actionUrl: `${frontendUrl}/dashboard/wishlist`,
    metadata: {
      transactionType: 'wishlist-available',
      bookId,
      bookTitle,
    },
  });
}
```

### 4. **Loan Due Date Reminders** ⚠️
**Issue**: No automatic reminders before due date
- **When**: X days before loan due date (e.g., 3 days, 1 day)
- **Who should receive**: Users with loans approaching due date
- **Current**: No reminder notifications
- **Expected**: Scheduled reminders before due date

**Recommendation**: Add scheduled task (cron job) to check loans approaching due date:
```typescript
// Scheduled task (daily)
const loansDueSoon = await env.DB.prepare(`
  SELECT l.*, u.id as user_id
  FROM loans l
  JOIN library_users u ON l.user_id = u.id
  WHERE l.status = 'active'
    AND l.due_date BETWEEN date('now') AND date('now', '+3 days')
    AND l.due_date NOT IN (
      SELECT DISTINCT json_extract(metadata, '$.dueDate')
      FROM notifications
      WHERE user_id = l.user_id
        AND json_extract(metadata, '$.transactionType') = 'loan-due-reminder'
        AND created_at > date('now', '-1 day')
    )
`).all();

for (const loan of loansDueSoon.results) {
  const daysUntilDue = Math.ceil((new Date(loan.due_date) - new Date()) / (1000 * 60 * 60 * 24));
  await createAppNotification(env, {
    userId: loan.user_id,
    title: `Loan Due Soon • ${loan.book_title}`,
    message: `Your loan is due in ${daysUntilDue} day${daysUntilDue === 1 ? '' : 's'}. Please return the book by ${formatDate(loan.due_date)}.`,
    type: daysUntilDue === 1 ? 'warning' : 'reminder',
    priority: daysUntilDue === 1 ? 'high' : 'normal',
    actionUrl: `${frontendUrl}/dashboard/loans`,
    metadata: {
      transactionType: 'loan-due-reminder',
      loanId: loan.id,
      dueDate: loan.due_date,
      daysUntilDue,
    },
  });
}
```

### 5. **Order Status Notifications** ⚠️
**Issue**: No notifications when order status changes
- **When**: Order is approved, rejected, or cancelled
- **Who should receive**: The user who created the order
- **Current**: Only admins get notified when order is created
- **Expected**: User should get notified when order status changes

**Location**: `functions/api/orders/handlers/update-order.ts`

**Recommendation**: Add notification when order status changes:
```typescript
if (orderStatusChanged) {
  await createAppNotification(env, {
    userId: order.user_id,
    title: `Order ${newStatus} • ${order.title}`,
    message: `Your borrow request has been ${newStatus}.`,
    type: newStatus === 'approved' ? 'success' : newStatus === 'rejected' ? 'warning' : 'info',
    priority: newStatus === 'approved' ? 'high' : 'normal',
    actionUrl: `${frontendUrl}/dashboard/orders/${order.id}`,
    metadata: {
      transactionType: 'order-status',
      orderId: order.id,
      status: newStatus,
    },
  });
}
```

### 6. **Reservation Notifications** ❌
**Issue**: No notifications for reservations (if reservations exist)
- **When**: Reservation is created, confirmed, or cancelled
- **Who should receive**: User who made the reservation
- **Current**: Unknown if reservations exist
- **Expected**: Notifications for reservation lifecycle

---

## 🔐 Permission & Preference Issues

### 1. **User Preferences Not Fully Respected** ⚠️
**Issue**: Some notifications may not check `in_app_notifications` preference
- **Current**: Orders check `in_app_notifications` ✅
- **Missing**: Loans and payments don't check preferences
- **Fix**: Add preference check before creating notifications

**Location**: `functions/lib/notifications/transaction-notifications.ts`

**Recommendation**: Check preferences before creating:
```typescript
// Before creating notification
const preferences = await env.DB.prepare(`
  SELECT in_app_notifications, loan_notifications
  FROM user_notification_preferences
  WHERE user_id = ?
`).bind(userId).first();

if (!preferences?.in_app_notifications || !preferences?.loan_notifications) {
  return; // Skip notification creation
}
```

### 2. **Permission-Based Order Notifications** ⚠️
**Issue**: Order notifications use role names instead of permissions
- **Current**: Checks roles: `superuser`, `admin`, `librarian`, `dean`
- **Better**: Check permissions: `orders:read` or `orders:update`
- **Fix**: Use permission system instead of hardcoded roles

**Location**: `functions/api/orders/handlers/create-order.ts` (line 134)

**Recommendation**: Use permission-based check:
```typescript
// Instead of role names, check permissions
const adminUsers = await env.DB.prepare(`
  SELECT u.id, u.first_name, u.last_name, u.email,
         COALESCE(unp.order_notifications, TRUE) as order_notifications_enabled,
         COALESCE(unp.in_app_notifications, TRUE) as in_app_notifications_enabled
  FROM library_users u
  LEFT JOIN user_notification_preferences unp ON u.id = unp.user_id
  WHERE u.status = 'active'
    AND EXISTS (
      SELECT 1 FROM role_permissions rp
      JOIN permission_resources pr ON rp.resource_id = pr.id
      JOIN permission_actions pa ON rp.action_id = pa.id
      WHERE rp.role_id = u.role_id
        AND pr.resource_name = 'orders'
        AND pa.action_name IN ('read', 'update')
        AND rp.is_granted = 1
    )
`).all();
```

### 3. **No Role-Based Notification Type Filtering** ❌
**Issue**: Cannot disable specific notification types for specific roles
- **Current**: All notification types sent to all users (if preferences allow)
- **Expected**: Superuser can configure which notification types each role receives
- **Example**: Disable `loan-due-reminder` for professors, disable `order-status` for students

**Recommendation**: Add `role_notification_type_preferences` table:
```sql
CREATE TABLE role_notification_type_preferences (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  role_id INTEGER NOT NULL,
  notification_type TEXT NOT NULL CHECK (notification_type IN (
    'loan-created', 'loan-status', 'loan-due-reminder',
    'payment-receipt', 'penalty-assigned',
    'order-created', 'order-status',
    'wishlist-available', 'borrow-limit-reached'
  )),
  enabled BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(role_id, notification_type),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);
```

---

## 📊 Notification Types Summary

### Currently Auto-Generated ✅

| Type | Trigger | Recipient | Type | Priority | Status |
|------|---------|-----------|------|----------|--------|
| **Loan Created** | Loan created | Loan owner | `success` | `normal` | ✅ Working |
| **Loan Status** | Status changed | Loan owner | `success`/`warning`/`error` | `normal`/`high`/`urgent` | ✅ Working |
| **Payment Received** | Payment processed | Payment owner | `success` | `normal` | ✅ Working |
| **New Borrow Request** | Order created | Admins/Librarians | `info` | `high` | ✅ Working |

### Missing ❌

| Type | Trigger | Recipient | Type | Priority | Status |
|------|---------|-----------|------|----------|--------|
| **Penalty Assigned** | Penalty created | Penalty owner | `warning` | `high` | ❌ Missing |
| **Borrow Limit Reached** | Limit exceeded | User | `warning` | `normal` | ❌ Missing |
| **Wishlist Available** | Book available | Wishlist users | `info` | `normal` | ❌ Missing |
| **Loan Due Reminder** | X days before due | Loan owner | `reminder`/`warning` | `normal`/`high` | ❌ Missing |
| **Order Status** | Order approved/rejected | Order creator | `success`/`warning` | `normal`/`high` | ❌ Missing |

---

## 🎯 Recommendations

### Priority 1: Critical Missing Features

1. **Add Penalty Notifications**
   - Create notification when penalty is assigned
   - Include amount, reason, due date
   - Link to penalties page

2. **Add Order Status Notifications**
   - Notify user when order is approved/rejected
   - Include order details and next steps

3. **Respect User Preferences**
   - Check `in_app_notifications` before creating all notifications
   - Check `loan_notifications` for loan-related notifications
   - Check `order_notifications` for order-related notifications

### Priority 2: Important Features

4. **Add Loan Due Date Reminders**
   - Scheduled task to check loans approaching due date
   - Send reminders 3 days, 1 day before due date
   - Use `reminder` type for early reminders, `warning` for urgent

5. **Add Borrow Limit Notifications**
   - Notify when user reaches/exceeds borrow limit
   - Include current loans count and max allowed

6. **Use Permission-Based Order Notifications**
   - Replace role-based check with permission-based check
   - Use `orders:read` or `orders:update` permissions

### Priority 3: Nice to Have

7. **Add Wishlist Notifications**
   - Notify when book in wishlist becomes available
   - Include book details and link to wishlist

8. **Add Role-Based Notification Type Preferences**
   - Allow superusers to configure which notification types each role receives
   - Create UI for managing these preferences

9. **Add Notification Categories/Grouping**
   - Group notifications by type (loans, payments, orders, etc.)
   - Add filter by category in UI

10. **Add Notification Statistics**
    - Show unread count by type
    - Show notification trends
    - Add summary dashboard

---

## 🔧 Implementation Checklist

### Immediate Fixes
- [ ] Add penalty notification creation
- [ ] Add order status change notifications
- [ ] Add user preference checks for all notifications
- [ ] Replace role-based order notifications with permission-based

### Short-term Features
- [ ] Add loan due date reminder scheduled task
- [ ] Add borrow limit notification
- [ ] Add wishlist availability notification

### Long-term Enhancements
- [ ] Add role-based notification type preferences
- [ ] Add notification categories/grouping
- [ ] Add notification statistics dashboard
- [ ] Add notification templates for consistency

---

## 📝 Summary

**Current State**: App Notifications are **partially implemented** with basic CRUD functionality and some automatic generation.

**What Works**:
- ✅ UI for viewing, creating, editing, deleting notifications
- ✅ Automatic notifications for loans, payments, orders (to admins)

**What's Missing**:
- ❌ Penalty notifications
- ❌ Order status change notifications (to users)
- ❌ Loan due date reminders
- ❌ Borrow limit notifications
- ❌ Wishlist availability notifications
- ❌ User preference checks for all notifications
- ❌ Permission-based order notifications
- ❌ Role-based notification type filtering

**Priority Actions**:
1. Add missing notification types (penalties, order status, reminders)
2. Fix user preference checking
3. Implement permission-based notifications
4. Add scheduled tasks for reminders

