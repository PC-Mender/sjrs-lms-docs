---
title: "Implementation Proposal"
---

# Library Rules Quiz & Reminder System - Implementation Proposal

## Overview

Implement a comprehensive library rules reminder system that presents users with quiz questions about library rules to ensure they understand and remember important policies.

---

## Problem Statement

Library users often forget library rules, leading to:
- Policy violations
- Overdue books
- Fines and penalties
- Confusion about borrowing limits
- Misunderstanding of renewal policies

---

## Proposed Solution

### 1. **Library Rules Quiz System**
- Interactive quiz with multiple-choice questions
- Questions based on actual library rules (borrow limits, loan periods, fines, etc.)
- Score tracking and completion status
- Required passing score (e.g., 80%)

### 2. **Reminder Triggers**
- **First-time users**: After account approval, before first book borrow
- **Periodic reminders**: Every 30/60/90 days (configurable)
- **Before critical actions**: Before borrowing books (if quiz expired)
- **Notification-based**: Push notifications for overdue quiz completion

### 3. **User Experience**
- Non-intrusive modal/popup
- Can be dismissed temporarily (with reminder)
- Accessible from dashboard and help section
- Progress tracking and completion certificates

---

## Implementation Approach

### Option A: **Modal-Based Quiz (Recommended)**
**Location**: Dashboard overlay modal
**Trigger**: 
- First login after approval
- Periodic reminders (every 30 days)
- Before book borrowing (if quiz expired)

**Pros**:
- Non-intrusive but visible
- Can be dismissed with "Remind me later"
- Doesn't block entire app

**Cons**:
- Users might dismiss without completing

### Option B: **Dedicated Quiz Page**
**Location**: `/library-rules-quiz` route
**Trigger**: 
- Redirect from dashboard if quiz required
- Link in navigation menu
- Notification link

**Pros**:
- Full attention on quiz
- Can't be easily dismissed
- Better for comprehensive quizzes

**Cons**:
- More intrusive
- Requires navigation

### Option C: **Hybrid Approach (Best)**
**Location**: 
- Modal for quick reminders
- Dedicated page for full quiz
- Dashboard widget showing quiz status

**Pros**:
- Flexible user experience
- Multiple entry points
- Best of both worlds

**Cons**:
- More complex implementation

---

## Recommended Implementation: Hybrid Approach

### 1. **Database Schema**

```sql
-- Library rules quiz questions
CREATE TABLE library_rules_questions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  question TEXT NOT NULL,
  options TEXT NOT NULL, -- JSON array of options
  correct_answer INTEGER NOT NULL, -- Index of correct option
  explanation TEXT, -- Explanation shown after answering
  category TEXT, -- 'borrowing', 'renewal', 'fines', 'general'
  difficulty TEXT DEFAULT 'medium', -- 'easy', 'medium', 'hard'
  is_active BOOLEAN DEFAULT TRUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- User quiz attempts and completion
CREATE TABLE library_rules_quiz_attempts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  score INTEGER NOT NULL, -- Percentage score
  total_questions INTEGER NOT NULL,
  correct_answers INTEGER NOT NULL,
  completed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  passed BOOLEAN DEFAULT FALSE, -- TRUE if score >= passing_threshold
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);

-- User quiz preferences and reminders
CREATE TABLE library_rules_quiz_preferences (
  user_id INTEGER PRIMARY KEY,
  last_completed_at DATETIME, -- Last successful quiz completion
  next_reminder_at DATETIME, -- When to show next reminder
  reminder_frequency_days INTEGER DEFAULT 30, -- Days between reminders
  is_required BOOLEAN DEFAULT TRUE, -- Whether quiz is required before borrowing
  dismissed_until DATETIME, -- If user dismissed, when to show again
  FOREIGN KEY (user_id) REFERENCES library_users(id) ON DELETE CASCADE
);
```

### 2. **Backend API Endpoints**

```
GET  /api/library-rules-quiz/questions     - Get quiz questions
POST /api/library-rules-quiz/submit        - Submit quiz answers
GET  /api/library-rules-quiz/status        - Get user quiz status
POST /api/library-rules-quiz/dismiss       - Dismiss reminder
GET  /api/library-rules-quiz/history        - Get quiz attempt history
```

### 3. **Frontend Components**

**Components to Create:**
1. `LibraryRulesQuizModal.tsx` - Modal for quick quiz
2. `LibraryRulesQuizPage.tsx` - Full quiz page
3. `LibraryRulesQuizWidget.tsx` - Dashboard widget showing status
4. `LibraryRulesQuizQuestions.tsx` - Question display component
5. `LibraryRulesQuizResults.tsx` - Results display component

**Integration Points:**
1. Dashboard - Show widget and modal trigger
2. Book borrowing flow - Check quiz status before allowing borrow
3. Help/Support page - Link to quiz
4. Navigation menu - "Library Rules Quiz" link
5. Notifications - Reminder notifications

### 4. **Quiz Questions (Sample)**

Based on `LIBRARY_RULES` from `src/constants/config.ts`:

1. **Borrowing Limits:**
   - "How many books can a 1st year student borrow at once?"
   - "What is the maximum loan period for students?"

2. **Renewals:**
   - "How many times can a student renew a book?"
   - "What happens if you renew a book after the due date?"

3. **Fines:**
   - "What is the fine per day for overdue books for students?"
   - "Is there a grace period for overdue books?"

4. **General Rules:**
   - "Can you borrow books if you have outstanding fines?"
   - "What should you do if you lose a borrowed book?"

---

## Implementation Plan

### Phase 1: Database & Backend (Foundation)
1. Create database migrations for quiz tables
2. Create backend API endpoints
3. Seed initial quiz questions
4. Implement quiz scoring logic

### Phase 2: Frontend Components (UI)
1. Create quiz modal component
2. Create quiz page component
3. Create dashboard widget
4. Integrate with dashboard

### Phase 3: Integration (Workflow)
1. Add quiz check to book borrowing flow
2. Add notification reminders
3. Add help page integration
4. Add navigation menu link

### Phase 4: Admin Features (Management)
1. Admin interface to manage questions
2. View quiz statistics
3. Configure reminder frequency
4. View user completion rates

---

## User Flow Examples

### Flow 1: First-Time User
```
1. User account approved → Status: 'active'
2. User logs in → Dashboard shows
3. Modal appears: "Welcome! Please complete Library Rules Quiz"
4. User completes quiz → Score saved, completion recorded
5. User can now borrow books
```

### Flow 2: Periodic Reminder
```
1. User last completed quiz 35 days ago
2. User logs in → Dashboard shows
3. Widget shows: "Quiz due for renewal"
4. Notification: "Time to refresh your knowledge!"
5. User clicks → Quiz modal/page opens
6. User completes → Next reminder scheduled
```

### Flow 3: Before Borrowing
```
1. User tries to borrow a book
2. System checks: Quiz completed in last 30 days?
3. If NO → Modal: "Please complete Library Rules Quiz first"
4. User completes quiz → Borrowing proceeds
5. If YES → Borrowing proceeds normally
```

---

## Configuration Options

### Admin-Configurable Settings:
- **Reminder Frequency**: 30/60/90 days (default: 30)
- **Passing Score**: 70-100% (default: 80%)
- **Required Before Borrowing**: Yes/No (default: Yes)
- **Questions Per Quiz**: 5-20 (default: 10)
- **Quiz Timeout**: Optional time limit

### User Preferences:
- **Reminder Frequency**: User can set preference
- **Dismiss Duration**: How long to dismiss (1 day, 1 week, etc.)

---

## Benefits

1. **User Education**: Users learn and remember rules
2. **Reduced Violations**: Fewer policy violations
3. **Better Compliance**: Users understand consequences
4. **Reduced Support**: Fewer questions about rules
5. **Data Insights**: Track which rules users struggle with

---

## Next Steps

1. **Confirm Approach**: Choose implementation approach (Hybrid recommended)
2. **Define Questions**: Create initial set of quiz questions
3. **Database Migration**: Create migration for quiz tables
4. **Backend Implementation**: Create API endpoints
5. **Frontend Implementation**: Create UI components
6. **Integration**: Integrate with existing flows
7. **Testing**: Test all user flows
8. **Deployment**: Deploy and monitor

---

## Questions for Discussion

1. **Quiz Frequency**: How often should users retake the quiz? (30/60/90 days?)
2. **Required vs Optional**: Should quiz be required before borrowing?
3. **Question Count**: How many questions per quiz? (5-10 recommended)
4. **Passing Score**: What percentage is required to pass? (80% recommended)
5. **Enforcement**: Should users be blocked from borrowing if quiz not completed?

---

**Status**: Proposal - Awaiting Approval  
**Priority**: Medium  
**Estimated Effort**: 2-3 days development

