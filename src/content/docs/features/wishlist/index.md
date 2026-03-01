---
title: "Overview"
---

# Wishlist System

## Overview

The wishlist system has been refactored into a modular, well-structured architecture that aligns with the backend API and follows modern React patterns.

## Architecture

### Components

- **`WishlistList.tsx`** - Main wishlist management interface with table, search, and actions
- **`WishlistCreate.tsx`** - Form for adding new wishlist items
- **`WishlistEdit.tsx`** - Form for editing existing wishlist items
- **`WishlistShow.tsx`** - Detailed view of a wishlist item

### Services

- **`WishlistService`** - Business logic and API communication layer
- **`useWishlist`** - Custom hooks for data fetching and mutations

### Types

- **`WishlistItem`** - Core wishlist item interface
- **`WishlistItemWithDetails`** - Extended interface with user and book relations
- **`WishlistFormData`** - Form data for creating wishlist items
- **`WishlistUpdateData`** - Form data for updating wishlist items

## Features

### Core Functionality
- ✅ Create, read, update, delete wishlist items
- ✅ Search and filter wishlist items
- ✅ Pagination support
- ✅ Priority management (low, normal, high)
- ✅ Status tracking (active, acquired, removed)
- ✅ User and book relationship management

### Enhanced Features
- ✅ Statistics dashboard
- ✅ Availability checking
- ✅ Order placement from wishlist
- ✅ Custom title, author, and ISBN support
- ✅ Notes and priority management

## API Endpoints

### GET `/api/wishlist`
- **Query Parameters:**
  - `page` - Page number (default: 1)
  - `limit` - Items per page (default: 20)
  - `search` - Search term for title, author, or user
  - `priority` - Filter by priority (low, normal, high)
  - `status` - Filter by status (active, acquired, removed)
  - `user_id` - Filter by specific user

### POST `/api/wishlist`
- **Body:**
  ```json
  {
    "book_id": 123,
    "title": "Custom Title (optional)",
    "author": "Custom Author (optional)",
    "isbn": "1234567890 (optional)",
    "notes": "Additional notes (optional)",
    "priority": "normal"
  }
  ```

### PUT `/api/wishlist/:id`
- **Body:** Same as POST, but all fields are optional

### DELETE `/api/wishlist/:id`
- Deletes the specified wishlist item

## Database Schema

The wishlist table includes:
- `id` - Primary key
- `user_id` - Foreign key to library_users
- `book_id` - Foreign key to books (nullable)
- `title` - Custom title (nullable)
- `author` - Custom author (nullable)
- `isbn` - ISBN (nullable)
- `notes` - Additional notes (nullable)
- `priority` - Priority level (low, normal, high)
- `status` - Item status (active, acquired, removed)
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

## Usage Examples

### Basic List Component
```tsx
import { WishlistList } from './pages/wishlist';

function App() {
  return <WishlistList />;
}
```

### Custom Hook Usage
```tsx
import { useWishlistItems, useCreateWishlistItem } from './hooks/useWishlist';

function MyComponent() {
  const { data, isLoading } = useWishlistItems();
  const createMutation = useCreateWishlistItem();
  
  // Use the data and mutations
}
```

## Benefits of Refactoring

1. **Modularity** - Each component has a single responsibility
2. **Type Safety** - Comprehensive TypeScript interfaces
3. **Performance** - React Query for efficient data fetching and caching
4. **Maintainability** - Clean separation of concerns
5. **Reusability** - Custom hooks can be used across components
6. **Backend Alignment** - API structure matches frontend expectations
7. **Error Handling** - Consistent error handling throughout
8. **User Experience** - Better loading states and feedback

## Future Enhancements

- [ ] Bulk operations (delete multiple items)
- [ ] Export functionality (CSV, PDF)
- [ ] Advanced filtering and sorting
- [ ] Wishlist analytics and reporting
- [ ] Integration with notification system
- [ ] Wishlist sharing between users

---

**Source**: Moved from `src/pages/wishlist/index.md` during documentation consolidation

