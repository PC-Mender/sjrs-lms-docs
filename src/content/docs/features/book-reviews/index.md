---
title: "Overview"
---

# Book Reviews Module

This directory contains the refactored book reviews module with a clean, modular structure.

## Structure

```
src/pages/book-reviews/
├── BookReviewList.tsx          # Main list component with table and actions
├── BookReviewCreate.tsx        # Create form component
├── BookReviewEdit.tsx          # Edit form component
├── BookReviewShow.tsx          # Detail view component
├── BookReviewListPage.tsx      # Page wrapper for list
├── BookReviewCreatePage.tsx    # Page wrapper for create
├── BookReviewEditPage.tsx      # Page wrapper for edit
├── BookReviewShowPage.tsx      # Page wrapper for show
├── types.ts                    # Shared type definitions
├── utils.ts                    # Shared utility functions
├── index.ts                    # Component exports
└── index.md                   # This file
```

## Components

### BookReviewList
- Displays all book reviews in a table format
- Supports search, pagination, and filtering
- Handles approve/reject actions for moderators
- Includes edit and delete actions

### BookReviewCreate
- Form for creating new book reviews
- Validates required fields (book, user, rating)
- Integrates with D1 API for data submission

### BookReviewEdit
- Form for editing existing book reviews
- Pre-populates with current review data
- Validates edit permissions and limits

### BookReviewShow
- Detailed view of a single book review
- Shows approval/rejection information
- Displays edit count and moderation details

## Shared Resources

### Types (`types.ts`)
- `BookReviewWithStatus`: Extended interface with approval workflow
- `BookReviewFormValues`: Form data interface for create/edit operations

### Utilities (`utils.ts`)
- `getStatusColor()`: Consistent status color mapping
- `formatStatus()`: Status text formatting
- `canEditReview()`: Permission checking for edits
- `canModerateReview()`: Permission checking for moderation
- `formatDate()` / `formatDateTime()`: Date formatting helpers

## Usage

### Importing Components
```tsx
import { BookReviewList, BookReviewCreate } from './pages/book-reviews';
```

### Using Shared Types
```tsx
import { BookReviewWithStatus, BookReviewFormValues } from './pages/book-reviews/types';
```

### Using Shared Utilities
```tsx
import { getStatusColor, formatStatus } from './pages/book-reviews/utils';
```

## Backend Integration

The components use the unified D1 hooks:
- `useD1BookReviewsQuery()` - Fetch all reviews
- `useD1BookReviewQuery(id)` - Fetch single review
- `useD1CreateBookReview()` - Create new review
- `useD1UpdateBookReview()` - Update existing review
- `useD1DeleteBookReview()` - Delete review

## Features

- **Modular Design**: Each component is self-contained and focused
- **Type Safety**: Shared interfaces ensure consistency
- **Reusable Utilities**: Common functions centralized for maintenance
- **Backend Alignment**: Proper integration with D1 API endpoints
- **Permission Handling**: Built-in checks for edit/moderation actions
- **Error Handling**: Unified error handling across components
- **Responsive UI**: Ant Design components for consistent styling

## Benefits of Refactoring

1. **Maintainability**: Smaller, focused files are easier to understand and modify
2. **Reusability**: Shared types and utilities reduce duplication
3. **Consistency**: Unified patterns across all components
4. **Testing**: Individual components can be tested in isolation
5. **Performance**: Better tree-shaking and code splitting
6. **Developer Experience**: Clear structure and imports

---

**Source**: Moved from `src/pages/book-reviews/index.md` during documentation consolidation

