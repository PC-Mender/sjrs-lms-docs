---
title: "TABLE MIGRATION STATUS"
---

# Table Migration Status - Server-Side Pagination

## Current Status: Opt-In (Not Automatic)

**Important**: Server-side pagination is **opt-in** - tables need to explicitly enable it. This ensures backward compatibility.

## Tables That Should Use Server-Side Pagination

### ✅ High Priority (Large Datasets)

| Table | Estimated Rows | Status | Priority |
|-------|---------------|--------|----------|
| **Journals** | 47,000+ | ⚠️ Needs Migration | **CRITICAL** |
| **Books** | 1,000+ | ⚠️ Needs Migration | **HIGH** |
| **Book Copies** | 5,000+ | ⚠️ Needs Migration | **HIGH** |
| **Students** | 1,000+ | ⚠️ Needs Migration | **HIGH** |
| **Professors** | 500+ | ⚠️ Needs Migration | **MEDIUM** |
| **Users** | 1,000+ | ⚠️ Needs Migration | **HIGH** |
| **Borrow Records** | 10,000+ | ⚠️ Needs Migration | **HIGH** |
| **Resources** | 1,000+ | ⚠️ Needs Migration | **MEDIUM** |

### ✅ Medium Priority (Medium Datasets)

| Table | Estimated Rows | Status | Priority |
|-------|---------------|--------|----------|
| **Publications** | 100-500 | ⚠️ Consider Migration | **LOW** |
| **Authors** | 100-500 | ⚠️ Consider Migration | **LOW** |
| **Sections** | 50-200 | ✅ Can stay client-side | **NONE** |
| **Reference Books** | 500-1,000 | ⚠️ Consider Migration | **MEDIUM** |

### ✅ Low Priority (Small Datasets)

| Table | Estimated Rows | Status | Priority |
|-------|---------------|--------|----------|
| **Settings** | <50 | ✅ Client-side OK | **NONE** |
| **Categories** | <100 | ✅ Client-side OK | **NONE** |
| **Resource Types** | <50 | ✅ Client-side OK | **NONE** |

## Migration Checklist

For each table, check:

- [ ] **Dataset size**: >100 rows? → Use server-side pagination
- [ ] **Backend support**: Does API support pagination? → Check endpoint
- [ ] **Performance**: Is initial load slow? → Migrate to server-side
- [ ] **Memory**: High memory usage? → Migrate to server-side

## How to Enable Server-Side Pagination

### Option 1: Use `useServerSideTable` Hook (Recommended)

```tsx
import { useServerSideTable } from '@/hooks/useServerSideTable';
import { OptimizedTable } from '@/components/ui/organisms/tables/OptimizedTable';

const MyTable = () => {
  const { tableProps, onSearch, onPaginationChange } = useServerSideTable({
    queryKey: ['my-resource'],
    queryFn: async (page, pageSize, search) => {
      const result = await myService.findAll({
        pagination: { current: page, pageSize },
        search: search || undefined,
      });
      return { data: result.data, total: result.total };
    },
  });

  return (
    <OptimizedTable
      data={tableProps.data}
      columns={columns}
      config={{
        serverSidePagination: true, // ✅ Enable server-side
        pagination: tableProps.pagination,
        loading: tableProps.loading,
      }}
      onPaginationChange={onPaginationChange}
      onSearch={onSearch}
    />
  );
};
```

### Option 2: Use Enhanced `DataTable` Component

```tsx
import { DataTable } from '@/components/ui/organisms/tables/OptimizedTable';

<DataTable
  queryKey={['my-resource']}
  queryFn={() => myService.findAll()}
  paginationQueryFn={async (page, pageSize, search) => {
    const result = await myService.findAll({
      pagination: { current: page, pageSize },
      search: search || undefined,
    });
    return { data: result.data, total: result.total };
  }}
  columns={columns}
  config={{
    serverSidePagination: true, // ✅ Enable server-side
    pagination: { current: 1, pageSize: 20 },
  }}
/>
```

## Current Table Implementations

### Using OptimizedTable
- ✅ `src/pages/book-copies/index.tsx` - **Needs Migration**
- ✅ `src/components/auth/session/session-management.tsx` - Check size
- ✅ `src/pages/borrow-limits/BorrowLimitList.tsx` - Check size

### Using UnifiedTable
- ✅ `src/components/ui/organisms/tables/UnifiedTable.tsx` - **Needs Enhancement**
- ⚠️ Currently does client-side pagination only

### Using Ant Design Table Directly
- ✅ `src/pages/journals/index.tsx` - **Needs Migration** (47k rows!)
- ✅ `src/pages/students/index.tsx` - **Needs Migration**
- ✅ `src/pages/guests/GuestListPage.tsx` - Check size
- ✅ `src/pages/book-views/index.tsx` - Check size

## Migration Priority Order

1. **Journals** (47k rows) - CRITICAL
2. **Books** (1k+ rows) - HIGH
3. **Book Copies** (5k+ rows) - HIGH
4. **Borrow Records** (10k+ rows) - HIGH
5. **Students** (1k+ rows) - HIGH
6. **Users** (1k+ rows) - HIGH
7. **Professors** (500+ rows) - MEDIUM
8. **Resources** (1k+ rows) - MEDIUM
9. **Reference Books** (500-1k rows) - MEDIUM

## Backend Support Status

All major endpoints support pagination:
- ✅ `/api/journals` - Supports pagination
- ✅ `/api/books` - Supports pagination
- ✅ `/api/book-copies` - Supports pagination
- ✅ `/api/students` - Supports pagination
- ✅ `/api/professors` - Supports pagination
- ✅ `/api/users` - Supports pagination
- ✅ `/api/resources` - Supports pagination
- ✅ `/api/borrow-records` - Supports pagination

## Future Enhancement: Auto-Detect

We could enhance `OptimizedTable` to automatically enable server-side pagination when:
- Dataset size >100 rows AND
- `total` prop is provided AND
- `onPaginationChange` callback is provided

This would make it more automatic while maintaining backward compatibility.

## Summary

**Current State**: Opt-in (explicitly enable `serverSidePagination: true`)

**Recommendation**: 
- ✅ Migrate all tables with >100 rows
- ✅ Use `useServerSideTable` hook for new tables
- ✅ Keep client-side for small datasets (<100 rows)

**Migration Effort**: Low (thanks to centralized hook)

