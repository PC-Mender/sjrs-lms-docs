---
title: "OVERDUE STATUS ANALYSIS"
---

# Overdue Status - Current Implementation & Gaps Analysis

## Executive Summary

The system has automated overdue status updates via a scheduled task, but there are several gaps that need to be addressed for complete automation.

## Currently Implemented ✅

### 1. Scheduled Overdue Status Updates
- **Location**: `functions/scheduled/calculate-overdue-penalties.ts`
- **Schedule**: Daily at 2 AM UTC (configured in `wrangler.toml`)
- **Function**: `calculateOverduePenalties()` in `functions/lib/penalties/calculate-overdue-penalties.ts`

**What it does:**
- Queries loans with:
  - Status: `'active'` OR `'overdue'`
  - Due date: Past current date/time (`due_date < now`)
  - Returned date: NULL (not yet returned)
- For each overdue loan:
  - Calculates days overdue
  - Creates/updates penalty records
  - **Marks loan as overdue** (only if status is `'active'`)
  - Sends notifications for newly created penalties

**Key Function:**
```198:212:functions/lib/penalties/calculate-overdue-penalties.ts
async function markLoanAsOverdue(env: Environment, loanId: number): Promise<boolean> {
  try {
    const result = await env.DB.prepare(`
      UPDATE loans
      SET status = 'overdue',
          updated_at = datetime('now')
      WHERE id = ? AND status = 'active'
    `).bind(loanId).run();

    return result.meta.changes > 0;
  } catch (error) {
    await handleError(error, { operation: 'Mark Loan as Overdue', env });
    return false;
  }
}
```

### 2. Overdue Reminders
- **Location**: `functions/scheduled/send-overdue-reminders.ts`
- **Schedule**: Daily (same cron trigger)
- Sends email reminders at 7, 14, and 30 days overdue

## Identified Gaps ❌

### Gap 1: Renewal Doesn't Clear Overdue Status
**Issue**: When a loan is renewed, the system updates the `due_date` to a future date but **does not change the status from `'overdue'` back to `'active'`**.

**Location**: `functions/api/loans/handlers/renew-loan.ts`

**Current Code:**
```106:116:functions/api/loans/handlers/renew-loan.ts
    const updateResult = await env.DB.prepare(`
      UPDATE loans
      SET 
        renewed_count = COALESCE(renewed_count, 0) + 1,
        due_date = ?,
        updated_at = datetime('now')
      WHERE id = ?
    `).bind(
      newDueDate.toISOString().split('T')[0],
      loanId
    ).run();
```

**Problem**: A loan that was overdue and then renewed will remain marked as `'overdue'` even though it now has a future due date. This will cause:
- The loan to continue appearing in overdue queries
- Penalties to continue being calculated incorrectly
- Confusion in reports and dashboards

**Expected Behavior**: When a loan is renewed and gets a new future due date, its status should be changed from `'overdue'` back to `'active'`.

### Gap 2: No Real-Time Overdue Status Updates
**Issue**: Overdue status is only updated once per day at 2 AM UTC. If a loan becomes overdue during the day (e.g., due date was today), it won't be marked as overdue until the next scheduled run.

**Impact**:
- Loans that become overdue during business hours won't show as overdue until the next day
- Penalties won't be calculated immediately
- Users won't see accurate overdue status in real-time

**Potential Solutions**:
1. Add overdue status check when loans are queried/displayed (client-side or API-side)
2. Add overdue status check when loan is updated manually
3. Run scheduled task more frequently (e.g., every 6 hours)
4. Add a trigger/check when loan is created/approved

### Gap 3: Manual Updates Don't Validate Overdue Status
**Issue**: When a loan is manually updated via `handleUpdateLoan()`, the system doesn't check if the loan should be marked as overdue based on the new `due_date`.

**Location**: `functions/api/loans/handlers/update-loan.ts`

**Current Code**: Updates status, due_date, etc., but doesn't validate if the loan should be overdue based on the due_date.

**Expected Behavior**: After updating a loan's `due_date`, the system should:
- If `due_date < now` and status is `'active'`: Mark as `'overdue'`
- If `due_date >= now` and status is `'overdue'`: Mark as `'active'`

### Gap 4: No Automatic Status Correction for Active Loans Past Due Date
**Issue**: The scheduled task only marks loans as overdue if they have status `'active'`. However, if a loan somehow has status `'overdue'` but `due_date` is in the future, it won't be corrected.

**Current Logic**: Only updates `'active'` → `'overdue'`, but doesn't handle the reverse case (`'overdue'` → `'active'` when due_date is in the future).

## Recommendations

### Priority 1: Fix Renewal Status Update
**Action**: Update `renew-loan.ts` to change status from `'overdue'` to `'active'` when renewing.

**Implementation**:
```typescript
UPDATE loans
SET 
  renewed_count = COALESCE(renewed_count, 0) + 1,
  due_date = ?,
  status = CASE 
    WHEN ? > datetime('now') THEN 'active' 
    ELSE status 
  END,
  updated_at = datetime('now')
WHERE id = ?
```

### Priority 2: Add Overdue Status Validation to Update Handler
**Action**: Add a helper function to validate and update overdue status based on due_date, and call it:
- After loan renewal
- After manual loan updates
- In the scheduled task (to correct any inconsistencies)

**Implementation**: Create `functions/lib/loans/update-overdue-status.ts`:
```typescript
export async function updateLoanOverdueStatus(
  env: Environment, 
  loanId: number
): Promise<boolean> {
  // Get loan with due_date
  // If due_date < now AND status = 'active': set to 'overdue'
  // If due_date >= now AND status = 'overdue': set to 'active'
}
```

### Priority 3: Enhance Scheduled Task
**Action**: Update the scheduled task to also correct loans that are marked `'overdue'` but have future due dates.

**Implementation**: Add logic to `calculateOverduePenalties()` to:
- Find loans with status `'overdue'` but `due_date >= now`
- Change their status back to `'active'`

### Priority 4: Consider Real-Time Checks (Optional)
**Action**: Add overdue status checks when loans are queried or displayed, or run scheduled task more frequently.

## Current Query Logic

The scheduled task queries overdue loans using:
```217:244:functions/lib/penalties/calculate-overdue-penalties.ts
async function getOverdueLoans(env: Environment): Promise<OverdueLoan[]> {
  try {
    const loans = await env.DB.prepare(`
      SELECT 
        l.id,
        l.user_id,
        l.book_copy_id,
        l.due_date,
        l.borrowed_at,
        u.user_type,
        b.title as book_title
      FROM loans l
      INNER JOIN library_users u ON l.user_id = u.id
      LEFT JOIN book_copies bc ON l.book_copy_id = bc.id
      LEFT JOIN books b ON bc.book_id = b.id
      WHERE l.status IN ('active', 'overdue')
        AND l.due_date IS NOT NULL
        AND datetime(l.due_date) < datetime('now')
        AND l.returned_at IS NULL
      ORDER BY l.due_date ASC
    `).all();

    return (loans.results || []) as unknown as OverdueLoan[];
  } catch (error) {
    await handleError(error, { operation: 'Get Overdue Loans', env });
    return [];
  }
}
```

This query correctly identifies overdue loans, but the status update only happens for `'active'` loans.

## Summary

**What Works:**
- ✅ Daily scheduled task marks active loans as overdue
- ✅ Penalties are calculated automatically
- ✅ Notifications are sent

**What Needs Fixing:**
- ❌ Renewal doesn't clear overdue status
- ❌ No real-time overdue detection (only daily)
- ❌ Manual updates don't validate overdue status
- ❌ No correction for overdue loans with future due dates

**Recommended Next Steps:**
1. Fix renewal to clear overdue status (Priority 1)
2. Add overdue status validation helper function (Priority 2)
3. Enhance scheduled task to correct inconsistencies (Priority 3)
4. Consider real-time checks for better UX (Priority 4)

