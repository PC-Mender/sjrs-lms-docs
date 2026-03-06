---
title: "Enhanced Permissions"
---

# Enhanced Permission System

## Overview

The Enhanced Permission System provides real-time permission updates across the application. When permissions are changed in the Permission Management interface, all active components automatically refresh their permission states without requiring page refreshes or manual cache clearing.

## Key Features

### 1. Real-Time Permission Updates
- **Automatic Refresh**: Components automatically update when permissions change
- **Event-Driven**: Uses a global event system to notify components of changes
- **Cache Management**: Intelligent cache invalidation and refresh
- **User Context Integration**: User context automatically refreshes when permissions change

### 2. Enhanced Components
- **EnhancedPermissionButton**: Buttons that automatically refresh when permissions change
- **EnhancedPermissionGuard**: Guards that automatically refresh when permissions change
- **usePermissionMonitor**: Hook for monitoring permission changes
- **Permission Event System**: Global event management for permission updates

### 3. Notification System
- **Real-Time Notifications**: Users receive notifications when permissions change
- **Role Change Notifications**: Notifications when user roles are updated
- **Audit Trail**: Complete audit trail of permission changes

## Architecture

### Event System
```
Permission Management Page
         ↓ (emits events)
Permission Event Manager
         ↓ (notifies listeners)
User Context & Components
         ↓ (refresh automatically)
Updated UI State
```

### Components Hierarchy
```
App
├── UserContext (listens for permission events)
├── usePermissions (listens for permission events)
├── usePermissionMonitor (monitors specific events)
├── EnhancedPermissionButton (auto-refreshing buttons)
└── EnhancedPermissionGuard (auto-refreshing guards)
```

## Usage Examples

### 1. Enhanced Permission Buttons

```tsx
import { CreateButton, EditButton, DeleteButton } from '../components/permission-buttons';

// These buttons automatically refresh when permissions change
<CreateButton
  resource="books"
  onClick={handleCreate}
  type="primary"
>
  Add Book
</CreateButton>

<EditButton
  resource="books"
  onClick={() => handleEdit(record)}
  size="small"
/>

<DeleteButton
  resource="books"
  onDelete={() => handleDelete(record.id)}
  tooltip="Delete this book"
/>
```

### 2. Enhanced Permission Guards

```tsx
import { CreateGuard, ReadGuard, UpdateGuard, DeleteGuard } from '../components/permission-buttons';

// These guards automatically refresh when permissions change
<CreateGuard resource="books">
  <Button onClick={handleCreate}>Add Book</Button>
</CreateGuard>

<ReadGuard resource="books">
  <Table dataSource={books} />
</ReadGuard>

<UpdateGuard resource="books">
  <Button onClick={handleEdit}>Edit</Button>
</UpdateGuard>

<DeleteGuard resource="books">
  <Button onClick={handleDelete}>Delete</Button>
</DeleteGuard>
```

### 3. Permission Monitoring Hook

```tsx
import { usePermissionMonitor } from '../hooks/usePermissionMonitor';

function MyComponent() {
  const { isMonitoring } = usePermissionMonitor({
    onPermissionChange: (resource, action) => {
      console.log(`Permission changed: ${action} on ${resource}`);
    },
    onRoleChange: (roleName) => {
      console.log(`Role changed to: ${roleName}`);
    },
    onCacheClear: () => {
      console.log('Permission cache cleared');
    }
  });

  return (
    <div>
      {isMonitoring ? 'Monitoring permissions...' : 'Not monitoring'}
    </div>
  );
}
```

### 4. Enhanced usePermissions Hook

```tsx
import { usePermissions } from '../hooks/usePermissions';

function MyComponent() {
  const { 
    permissions, 
    isLoading, 
    checkPermission, 
    refreshPermissions,
    canCreateResource,
    canUpdateResource,
    canDeleteResource,
    canReadResource
  } = usePermissions(['books', 'users']);

  // This hook automatically refreshes when permissions change
  return (
    <div>
      {canCreateResource('books') && <Button>Add Book</Button>}
      {canUpdateResource('books') && <Button>Edit Book</Button>}
      {canDeleteResource('books') && <Button>Delete Book</Button>}
    </div>
  );
}
```

## Event System

### Permission Events

The system emits the following events:

1. **permission_updated**: When a permission is updated
2. **role_changed**: When a user's role is changed
3. **user_permissions_refreshed**: When user permissions are refreshed
4. **cache_cleared**: When permission cache is cleared

### Event Listeners

```tsx
import { 
  subscribeToPermissionUpdates,
  subscribeToRoleChanges,
  subscribeToCacheClears 
} from '../utilities/permission-events';

// Subscribe to events
const unsubscribe = subscribeToPermissionUpdates((event) => {
  console.log('Permission updated:', event);
});

// Clean up
unsubscribe();
```

## Migration Guide

### From Legacy Permission Components

**Before:**
```tsx
import { CreateButton, EditButton, DeleteButton } from '../utilities/permission-checks';

<CreateButton resourceName="books" onClick={handleCreate}>
  Add Book
</CreateButton>
```

**After:**
```tsx
import { CreateButton, EditButton, DeleteButton } from '../components/permission-buttons';

<CreateButton resource="books" onClick={handleCreate}>
  Add Book
</CreateButton>
```

### Key Changes

1. **Import Path**: Changed from `../utilities/permission-checks` to `../components/permission-buttons`
2. **Props**: `resourceName` → `resource`
3. **Auto-Refresh**: New components automatically refresh when permissions change
4. **Enhanced Features**: Better loading states, error handling, and user feedback

## Best Practices

### 1. Component Organization

```tsx
// Good: Use enhanced components for new features
import { CreateButton, EditButton, DeleteButton } from '../components/permission-buttons';

// Good: Use guards for conditional rendering
import { ReadGuard, UpdateGuard } from '../components/permission-buttons';

<ReadGuard resource="books">
  <Table dataSource={books} />
</ReadGuard>
```

### 2. Permission Monitoring

```tsx
// Good: Monitor specific permission changes
const { isMonitoring } = usePermissionMonitor({
  onPermissionChange: (resource, action) => {
    if (resource === 'books' && action === 'create') {
      // Refresh book list when create permission changes
      refreshBookList();
    }
  }
});
```

### 3. Error Handling

```tsx
// Good: Provide fallbacks for permission components
<CreateButton
  resource="books"
  onClick={handleCreate}
  fallback={<div>No permission to create books</div>}
  showFallbackWhenLoading={true}
>
  Add Book
</CreateButton>
```

### 4. Performance Optimization

```tsx
// Good: Use specific resources in usePermissions
const { permissions } = usePermissions(['books', 'users']);

// Avoid: Loading all permissions
const { permissions } = usePermissions(); // Don't do this
```

## Troubleshooting

### Common Issues

1. **Components Not Refreshing**
   - Check if the component is using enhanced permission components
   - Verify that the permission event system is working
   - Check browser console for errors

2. **Permission Cache Issues**
   - Use `clearPermissionCache()` to manually clear cache
   - Check if the user context is properly initialized
   - Verify that the user has a valid session

3. **Event System Not Working**
   - Check if the permission event manager is properly initialized
   - Verify that event listeners are properly subscribed
   - Check for memory leaks in event listeners

### Debug Tools

```tsx
// Enable debug logging
import { permissionEventManager } from '../utilities/permission-events';

// Monitor all events
permissionEventManager.subscribe('permission_updated', (event) => {
  console.log('Permission updated:', event);
});
```

## API Reference

### EnhancedPermissionButton Props

```tsx
interface EnhancedPermissionButtonProps {
  resource: string;                    // Resource name
  action: 'create' | 'read' | 'update' | 'delete';  // Action
  children: React.ReactNode;           // Button content
  type?: 'primary' | 'default' | 'dashed' | 'link' | 'text';
  size?: 'large' | 'middle' | 'small';
  disabled?: boolean;
  loading?: boolean;
  icon?: React.ReactNode;
  onClick?: () => void;
  tooltip?: string;
  className?: string;
  style?: React.CSSProperties;
  fallback?: React.ReactNode;         // Show when no permission
  showFallbackWhenLoading?: boolean;  // Show fallback during loading
}
```

### EnhancedPermissionGuard Props

```tsx
interface EnhancedPermissionGuardProps {
  resource: string;                    // Resource name
  action: 'create' | 'read' | 'update' | 'delete';  // Action
  children: React.ReactNode;           // Content to guard
  fallback?: React.ReactNode;         // Show when no permission
  loadingFallback?: React.ReactNode;  // Show during loading
  showLoadingFallback?: boolean;      // Whether to show loading fallback
}
```

### usePermissionMonitor Options

```tsx
interface UsePermissionMonitorOptions {
  onPermissionChange?: (resourceName?: string, actionName?: string) => void;
  onRoleChange?: (roleName?: string) => void;
  onCacheClear?: () => void;
  autoRefresh?: boolean;
}
```

## Future Enhancements

1. **WebSocket Integration**: Real-time updates via WebSocket
2. **Permission Analytics**: Track permission usage patterns
3. **Advanced Caching**: Redis-based permission caching
4. **Permission Templates**: Predefined permission sets
5. **Bulk Operations**: Update multiple permissions at once

## Conclusion

The Enhanced Permission System provides a robust, real-time permission management solution that automatically keeps the UI in sync with permission changes. By using the enhanced components and hooks, developers can create responsive applications that provide immediate feedback to permission changes without requiring manual refreshes or cache management. 