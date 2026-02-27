---
title: "Overview"
---

# Members Module - Refactored Architecture

## Overview

The Members module has been refactored to follow a modular, maintainable architecture that aligns with the backend API structure and eliminates code duplication.

## Architecture

```
src/components/features/members/
├── index.ts                     # Feature exports
├── types.ts                     # Centralized member types
├── utils/
│   └── member.utils.ts          # Member utility functions
└── components/                  # Reusable UI components
    ├── index.ts                 # Component exports
    ├── MemberFilters/
    ├── MemberTable/
    ├── MemberModals/
    └── MemberActionsDrawer/

src/pages/members/
├── index.tsx                    # Main page exports
├── MemberList.tsx               # Main container component
├── hooks/                       # Page hooks (data fetching/orchestration)
├── types/                       # Thin re-export shims for backward compatibility
└── utils/                       # Thin re-export shims for backward compatibility
```

## Key Improvements

### 1. **Centralized Types**
- Single source of truth for `MemberData` interface
- Eliminates duplicate interface definitions
- Consistent type usage across all components

### 2. **Modular Components**
- **MemberFilters**: Handles search, status, role, and user type filtering
- **MemberActions**: Manages bulk actions, export, and superuser features
- **MemberTable**: Displays member data with consistent styling
- **MemberModals**: Handles bulk operations and confirmations

### 3. **Custom Hook (`useMembers`)**
- Centralizes all member-related state and operations
- Provides consistent API for member management
- Handles data fetching, filtering, sorting, and mutations
- Manages modal states and user interactions

### 4. **Utility Functions**
- Common formatting and validation functions
- Status and role color mapping
- Filtering and sorting logic
- Reusable across components

### 5. **Backend Alignment**
- Uses unified API hooks (`useD1UsersQuery`, `useD1RolesQuery`)
- Consistent error handling with `handleError`
- Proper action logging with `ActionLogger`
- Follows backend API patterns

## Usage

### Basic Implementation

```tsx
import { MemberList } from './pages/members';

function App() {
  return <MemberList />;
}
```

### Using the Custom Hook

```tsx
import { useMembers } from './pages/members';

function CustomComponent() {
  const {
    members,
    loading,
    handleSearch,
    handleFilterChange,
    isSuperuser
  } = useMembers();

  // Use the hook's functionality
}
```

### Using Individual Components

```tsx
import { 
  MemberFiltersComponent, 
  MemberTableComponent 
} from './components/features/members';

function CustomMemberView() {
  return (
    <>
      <MemberFiltersComponent {...filterProps} />
      <MemberTableComponent {...tableProps} />
    </>
  );
}
```

## Migration Guide

### From Old Structure

1. **Replace direct API calls** with `useMembers` hook
2. **Use centralized types** from `./types/member.types`
3. **Import components** from `./components` instead of individual files
4. **Remove duplicate interfaces** and utility functions

### Before (Old Structure)
```tsx
// ❌ Old way - duplicate interfaces
interface MemberData { /* ... */ }

// ❌ Old way - direct API calls
const { data: members } = useD1UsersQuery();

// ❌ Old way - inline utility functions
const getStatusColor = (status: string) => { /* ... */ };
```

### After (New Structure)
```tsx
// ✅ New way - centralized types
import { MemberData } from './components/features/members/types';

// ✅ New way - centralized hook
const { members, handleSearch } = useMembers();

// ✅ New way - utility functions
import { getStatusColor } from './components/features/members/utils/member.utils';
```

## Benefits

1. **Maintainability**: Single source of truth for types and logic
2. **Reusability**: Components can be used independently
3. **Testability**: Smaller, focused components are easier to test
4. **Performance**: Optimized re-renders and state management
5. **Consistency**: Uniform patterns across the module
6. **Scalability**: Easy to add new features and components

## Future Enhancements

1. **Component Library**: Extract common components to a shared library
2. **State Management**: Consider using Zustand or Redux for complex state
3. **Testing**: Add comprehensive unit and integration tests
4. **Documentation**: Generate API documentation from TypeScript types
5. **Performance**: Implement virtual scrolling for large datasets

## Contributing

When adding new features to the Members module:

1. **Follow the modular structure**
2. **Use the centralized types**
3. **Extend the `useMembers` hook** for new functionality
4. **Create reusable components** in the appropriate directory
5. **Update this README** with new features
6. **Maintain consistency** with existing patterns

---

**Source**: Moved from `src/pages/members/README.md` during documentation consolidation
