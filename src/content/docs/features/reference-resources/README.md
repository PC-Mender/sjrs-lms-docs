---
title: "Overview"
---

# Reference Resources Module

This module provides a complete CRUD interface for managing reference resources in the SJRS LMS system.

## Structure

```
src/pages/reference-resources/
├── components/
│   ├── ReferenceResourceList.tsx    # Main list view with table and search
│   ├── ReferenceResourceForm.tsx    # Reusable form for create/edit
│   └── index.ts                     # Component exports
├── index.tsx                        # Main module with all components
└── README.md                        # This file
```

## Components

### ReferenceResourceList
- Displays resources in a table format
- Includes search functionality
- Handles delete operations
- Emits events for edit and create actions

### ReferenceResourceForm
- Reusable form component for creating and editing resources
- Dynamically loads resource types and sections from the backend
- Includes validation rules
- Supports both create and edit modes

### Main Components
- **ReferenceResourcesManagement**: Main list view with inline create/edit modals
- **ReferenceResourceCreate**: Standalone create page
- **ReferenceResourceEdit**: Standalone edit page
- **ReferenceResourceShow**: Standalone show/details page

## Backend Integration

The module is fully integrated with the backend API at `/api/reference-resources`:

- **GET** `/api/reference-resources` - List all resources with filtering and pagination
- **GET** `/api/reference-resources/:id` - Get specific resource details
- **POST** `/api/reference-resources` - Create new resource
- **PUT** `/api/reference-resources/:id` - Update existing resource
- **DELETE** `/api/reference-resources/:id` - Delete resource

## Data Flow

1. **List View**: Loads resources using `useReferenceResources` hook
2. **Create/Edit**: Uses `useCreateReferenceResource` and `useUpdateReferenceResource` hooks
3. **Delete**: Uses `useDeleteReferenceResource` hook
4. **Form Data**: Dynamically loads resource types and sections using respective hooks

## Features

- ✅ Full CRUD operations
- ✅ Search and filtering
- ✅ Pagination
- ✅ Form validation
- ✅ Error handling
- ✅ Loading states
- ✅ Responsive design
- ✅ Type safety with TypeScript
- ✅ Modular component architecture
- ✅ Backend API integration
- ✅ Permission-based access control

## Usage

```tsx
// In a route definition
import { ReferenceResourcesManagement } from '../pages/reference-resources';

// For standalone pages
import { ReferenceResourceCreate } from '../pages/reference-resources';
import { ReferenceResourceEdit } from '../pages/reference-resources';
import { ReferenceResourceShow } from '../pages/reference-resources';
```

## Dependencies

- React Query for data fetching and caching
- Ant Design for UI components
- React Router for navigation
- Custom hooks for business logic
- TypeScript for type safety

---

**Source**: Moved from `src/pages/reference-resources/README.md` during documentation consolidation
