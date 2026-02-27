---
title: "Overview"
---

# Resources System - Modular Architecture

## Overview

The Resources system has been completely refactored to follow a modular, maintainable architecture that aligns with the backend API structure. This system provides comprehensive resource management capabilities with clean separation of concerns.

## Architecture

### Backend API
- **Endpoint**: `/api/resources`
- **Database Table**: `resources`
- **Features**: Full CRUD operations with proper validation, security, and error handling

### Frontend Structure
```
src/
├── components/features/resources/
│   ├── ResourceList.tsx          # Main list component with table
│   ├── ResourceDetails.tsx       # Detailed view component
│   ├── ResourceFormModal.tsx     # Create/Edit form modal
│   ├── ResourceFiltersPanel.tsx  # Advanced filtering and sorting
│   └── index.ts                  # Component exports
├── hooks/
│   └── useResources.ts           # Custom hooks for resource operations
├── services/
│   └── resource.service.ts       # API service layer
├── types/
│   └── resources.ts              # TypeScript type definitions
└── pages/resources/
    ├── ResourcesPage.tsx         # Main resources listing page
    ├── ResourceShowPage.tsx      # Individual resource view page
    └── index.tsx                 # Legacy exports for compatibility
```

## Components

### ResourceList
The main component for displaying and managing resources.

**Features:**
- Data table with pagination
- Search functionality
- Advanced filtering and sorting
- Create, edit, and delete operations
- Responsive design

**Props:**
```typescript
interface ResourceListProps {
  onEdit?: (resource: ResourceWithDetails) => void;
  onView?: (resource: ResourceWithDetails) => void;
  showActions?: boolean;
  showFilters?: boolean;
  showSearch?: boolean;
  showCreateButton?: boolean;
}
```

### ResourceDetails
Displays comprehensive information about a single resource.

**Features:**
- Detailed resource information
- Status indicators with color coding
- Edit and refresh actions
- Responsive layout

**Props:**
```typescript
interface ResourceDetailsProps {
  resourceId: number;
  onEdit?: (resource: ResourceWithDetails) => void;
  onBack?: () => void;
  showActions?: boolean;
}
```

### ResourceFormModal
Handles creation and editing of resources.

**Features:**
- Form validation
- Dynamic field population for editing
- Error handling
- Success callbacks

**Props:**
```typescript
interface ResourceFormModalProps {
  open: boolean;
  resource?: ResourceWithDetails | null;
  resourceTypes: any[];
  sections: any[];
  onSuccess: () => void;
  onCancel: () => void;
}
```

### ResourceFiltersPanel
Provides advanced filtering and sorting capabilities.

**Features:**
- Resource type filtering
- Section filtering
- Status filtering
- Sort field and order selection
- Active filter display

## Hooks

### useResourcesList
Manages the list of resources with pagination and filtering.

```typescript
const {
  resources,
  loading,
  error,
  pagination,
  fetchResources,
  refreshResources,
  setPagination
} = useResourcesList();
```

### useResourceCreate
Handles resource creation operations.

```typescript
const { createResource, loading, error } = useResourceCreate();
```

### useResourceUpdate
Handles resource update operations.

```typescript
const { updateResource, loading, error } = useResourceUpdate();
```

### useResourceDelete
Handles resource deletion operations.

```typescript
const { deleteResource, loading, error } = useResourceDelete();
```

### useResourceDetails
Manages individual resource data.

```typescript
const { resource, loading, error, fetchResource } = useResourceDetails(resourceId);
```

## Service Layer

The `ResourceService` class provides a clean API for all resource operations:

```typescript
// Get resources with filters and pagination
ResourceService.getResources(filters, sort, pagination)

// Get single resource
ResourceService.getResource(id)

// Create resource
ResourceService.createResource(data)

// Update resource
ResourceService.updateResource(id, data)

// Delete resource
ResourceService.deleteResource(id)
```

## Types

### Core Types
```typescript
interface Resource extends BaseEntity {
  name: string;
  description?: string;
  resource_type_id: number;
  section_id: number;
  status: ResourceStatus;
}

type ResourceStatus = 'available' | 'in_use' | 'under_maintenance' | 'lost' | 'deprecated';
```

### Form Types
```typescript
interface ResourceFormData {
  name: string;
  description?: string;
  resource_type_id: number;
  section_id: number;
  status: ResourceStatus;
}
```

## Usage Examples

### Basic Resource List
```typescript
import { ResourceList } from '../../components/features/resources';

<ResourceList
  onView={(resource) => navigate(`/resources/${resource.id}`)}
  showActions={true}
  showFilters={true}
/>
```

### Resource Details Page
```typescript
import { ResourceDetails } from '../../components/features/resources';

<ResourceDetails
  resourceId={resourceId}
  onEdit={handleEdit}
  onBack={() => navigate('/resources')}
/>
```

### Custom Resource Management
```typescript
import { useResourcesList, useResourceCreate } from '../../hooks/useResources';

const { resources, loading, fetchResources } = useResourcesList();
const { createResource } = useResourceCreate();

// Create a new resource
const handleCreate = async (data) => {
  const result = await createResource(data);
  if (result) {
    fetchResources(); // Refresh the list
  }
};
```

## Migration from Legacy System

The old monolithic `ResourceShowPage.tsx` has been replaced with:

1. **ResourcesPage.tsx** - Main listing page
2. **ResourceShowPage.tsx** - Individual resource view
3. **Modular components** - Reusable, focused components
4. **Custom hooks** - Clean state management
5. **Service layer** - API abstraction

## Benefits of New Architecture

1. **Modularity** - Components can be used independently
2. **Reusability** - Components work in different contexts
3. **Maintainability** - Clear separation of concerns
4. **Type Safety** - Comprehensive TypeScript support
5. **Performance** - Optimized rendering and data fetching
6. **Testing** - Easier to test individual components
7. **Extensibility** - Easy to add new features

## Database Schema

The system uses a proper `resources` table with:

- `id` - Primary key
- `name` - Resource name
- `description` - Optional description
- `resource_type_id` - Foreign key to resource_types
- `section_id` - Foreign key to sections
- `status` - Resource status
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

## Security

- Proper authentication and authorization
- Input validation and sanitization
- SQL injection prevention
- Rate limiting
- CORS support

## Error Handling

- Comprehensive error handling at all levels
- User-friendly error messages
- Retry mechanisms
- Fallback states

---

**Source**: Moved from `src/pages/resources/README.md` during documentation consolidation
