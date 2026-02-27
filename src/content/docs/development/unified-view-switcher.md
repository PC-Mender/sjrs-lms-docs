---
title: "Unified View Switcher"
---

# Unified View Switcher (EnhancedListViewContainer)

## Overview

The **Unified View Switcher** (`EnhancedListViewContainer`) is a comprehensive, reusable React component for displaying and managing lists of data with CRUD operations, search, filtering, pagination, export, and multiple view modes.

## Features

| Feature | Description |
|---------|-------------|
| **View Modes** | Table, Cards, List - user preference stored |
| **Search** | Debounced search with configurable fields |
| **Advanced Filters** | Select, Date, DateRange, Number, Boolean |
| **Column Sorting** | Ascending/descending sort by any column |
| **Pagination** | Automatic pagination with page size options |
| **Row Selection** | Multi-select for batch operations |
| **Batch Operations** | Batch edit/delete selected items |
| **Export** | CSV, Excel (CSV format), JSON |
| **CRUD Modals** | Automatic modal management for View/Edit/Delete |
| **Actions Drawer** | Slide-out panel for detailed item actions |
| **Permissions** | RBAC-based action visibility |
| **Column Customization** | Users can show/hide columns |
| **Virtual Scrolling** | Performance optimization for large datasets |
| **Keyboard Shortcuts** | Ctrl+F (search), Esc (clear), Ctrl+R (refresh) |
| **Server-Side Operations** | Optional remote data fetching |
| **Empty States** | Context-aware empty state messages |
| **Error Handling** | Integrated error display and retry |

---

## Basic Usage

```tsx
import { EnhancedListViewContainer } from '../../../ui/organisms/list-view';

<EnhancedListViewContainer<AuthorListItem>
  resourceName="authors"
  data={authors}
  searchFields={['name', 'email', 'biography']}
  title="Authors Management"
  
  // CRUD Modal Configuration
  crudModals={{
    view: {
      component: GenericViewModal,
      getProps: (item) => ({
        title: 'Author Details',
        fields: [
          { key: 'id', label: 'ID' },
          { key: 'first_name', label: 'First Name' },
          { key: 'last_name', label: 'Last Name' },
        ],
      }),
    },
    edit: {
      component: GenericEditModal,
      getProps: (item) => ({
        title: 'Edit Author',
        renderForm: (props) => <AuthorForm {...props} />,
      }),
    },
    delete: {
      onDelete: async (item) => {
        await deleteAuthor(item.id);
      },
      confirmTitle: 'Delete Author',
      confirmContent: 'Are you sure?',
    },
  }}
  
  // Render functions
  renderTableView={({ data, pagination, actions }) => (
    <Table dataSource={data} pagination={pagination} />
  )}
  renderCardView={({ data, actions }) => (
    <AuthorCardGrid authors={data} onView={actions?.onView} />
  )}
/>
```

---

## Props Reference

### Required Props

| Prop | Type | Description |
|------|------|-------------|
| `resourceName` | `string` | Resource identifier (e.g., 'authors') |
| `data` | `T[]` | Array of data items |
| `renderTableView` | `(props) => ReactNode` | Table view renderer |

### Optional Props

#### Search & Filtering

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `searchFields` | `string[]` | `[]` | Fields to search |
| `searchDebounceMs` | `number` | `300` | Debounce delay |
| `showSearchStats` | `boolean` | `false` | Show "X of Y" stats |
| `advancedFilters` | `AdvancedFilterConfig[]` | `[]` | Filter configurations |

#### View Configuration

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `availableModes` | `TableViewMode[]` | `['table', 'cards']` | Enabled view modes |
| `renderCardView` | `(props) => ReactNode` | - | Card view renderer |
| `renderListView` | `(props) => ReactNode` | - | List view renderer |

#### Permissions

| Prop | Type | Description |
|------|------|-------------|
| `permissions` | `{ view?, edit?, delete?, create? }` | Permission strings (e.g., `'authors:read'`) |

#### CRUD Operations

| Prop | Type | Description |
|------|------|-------------|
| `crudModals` | `CRUDModalConfig<T>` | Modal configuration for CRUD |
| `batchActions` | `{ edit?, delete? }` | Batch operation handlers |

#### Export

| Prop | Type | Description |
|------|------|-------------|
| `exportConfig` | `{ enabled, formats, filename }` | Export configuration |

#### Performance

| Prop | Type | Description |
|------|------|-------------|
| `enableRowSelection` | `boolean` | Enable multi-select |
| `virtualScroll` | `{ enabled, height }` | Virtual scrolling |
| `columnCustomization` | `ColumnCustomizationConfig` | Column visibility |

---

## Advanced Filter Types

```tsx
advancedFilters={[
  // Select dropdown
  { 
    key: 'status', 
    label: 'Status', 
    type: 'select',
    options: [
      { label: 'Active', value: 'active' },
      { label: 'Inactive', value: 'inactive' },
    ]
  },
  // Date picker
  { key: 'created_at', label: 'Created At', type: 'date' },
  // Date range
  { key: 'date_range', label: 'Date Range', type: 'dateRange' },
  // Number
  { key: 'count', label: 'Count', type: 'number' },
  // Number range
  { key: 'price_range', label: 'Price Range', type: 'numberRange' },
  // Boolean toggle
  { key: 'is_active', label: 'Active', type: 'boolean' },
]}
```

---

## Batch Operations

```tsx
batchActions={{
  edit: {
    label: 'Edit Selected',
    onBatchEdit: async (items) => {
      // Handle batch edit
      await batchUpdateItems(items);
    },
  },
  delete: {
    label: 'Delete Selected',
    onBatchDelete: async (items) => {
      await Promise.all(items.map(item => deleteItem(item.id)));
    },
    confirmTitle: 'Delete Items',
    confirmContent: 'Are you sure you want to delete the selected items?',
  },
}}
```

---

## Export Configuration

```tsx
exportConfig={{
  enabled: true,
  formats: ['csv', 'excel', 'json'],
  filename: 'authors-export',
}}
```

---

## Permission-Based Action Visibility

Actions are automatically hidden based on permissions:

```tsx
permissions={{
  view: 'authors:read',     // View button
  edit: 'authors:update',   // Edit button
  delete: 'authors:delete', // Delete button
  create: 'authors:create', // Create button
}}
```

If user lacks `authors:update` permission, the Edit button won't appear.

---

## Server-Side Operations

For large datasets (>1000 items):

```tsx
serverSideOperations={{
  enabled: true,
  onFetch: async ({ page, pageSize, sort, filters, search }) => {
    const response = await api.get('/authors', {
      params: { page, pageSize, sort, filters, search }
    });
    return { data: response.data, total: response.total };
  },
}}
```

---

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl/Cmd + F` | Focus search input |
| `Esc` | Clear all filters |
| `Ctrl/Cmd + R` | Refresh data (if `onRefresh` provided) |

Disable with: `enableKeyboardShortcuts={false}`

---

## Column Customization

```tsx
columnCustomization={{
  enabled: true,
  storageKey: 'authors-columns',
  options: [
    { key: 'email', label: 'Email', defaultVisible: true },
    { key: 'website', label: 'Website', defaultVisible: false },
  ],
}}
```

Users can toggle column visibility via a popover in the header.

---

## Virtual Scrolling

For large tables:

```tsx
virtualScroll={{
  enabled: true,
  height: 600, // pixels
}}
```

---

## Related Hooks

| Hook | Purpose |
|------|---------|
| `useListView` | View mode management with user preferences |
| `usePagination` | Pagination state management |
| `useSearchAndFilter` | Search and client-side filtering |
| `useAdvancedFilters` | Advanced filter state |
| `useTableSorting` | Column sorting state |
| `useCRUDModals` | CRUD modal state management |

---

## Component Architecture

```
EnhancedListViewContainer
├── ListViewHeader (actions, view toggle, export)
├── ListViewFilters (search, advanced filters)
├── ListViewContent (table/cards/list rendering)
├── ListViewEmptyState (context-aware empty states)
└── CRUD Modals (GenericViewModal, GenericEditModal, etc.)
```

---

## Best Practices

1. **Start with client-side** - Use server-side only for >1000 items
2. **Configure permissions** - Always pass the permissions prop for RBAC
3. **Use generic modals** - Avoid custom modals when possible
4. **Memoize render functions** - Use `useCallback` for render props
5. **Provide `getItemKey`** - Essential for row selection to work correctly

---

## Example: Complete Authors Implementation

See `src/components/features/authors/components/AuthorList.tsx` for a complete implementation using all features.

