---
title: "Server Side Pagination Guide"
---

# Server-Side Pagination Guide for OptimizedTable

## Overview

The `OptimizedTable` component now supports **server-side pagination** for handling large datasets efficiently. This is essential for tables with 1000+ rows, especially for book catalogs and other large data collections.

## When to Use Server-Side Pagination

- ✅ **Use server-side pagination** when:
  - Dataset has 1000+ rows
  - Data is fetched from backend API
  - Backend supports pagination (most endpoints do)
  - You want faster initial page load

- ❌ **Use client-side pagination** when:
  - Dataset has <100 rows
  - All data is already loaded in memory
  - No backend API calls needed

## Implementation

### Basic Example

```tsx
import { useState, useEffect } from 'react';
import { OptimizedTable } from '@/components/ui/organisms/tables/OptimizedTable';
import { bookService } from '@/services/book.service';

const BookListPage = () => {
  const [books, setBooks] = useState([]);
  const [loading, setLoading] = useState(false);
  const [pagination, setPagination] = useState({
    current: 1,
    pageSize: 20,
    total: 0,
  });
  const [searchTerm, setSearchTerm] = useState('');

  // Fetch books with pagination
  const fetchBooks = async (page: number, pageSize: number, search?: string) => {
    setLoading(true);
    try {
      const result = await bookService.findAll({
        pagination: { current: page, pageSize },
        search: search || undefined,
      });
      
      setBooks(result.data);
      setPagination(prev => ({
        ...prev,
        current: page,
        pageSize,
        total: result.total,
      }));
    } catch (error) {
      console.error('Failed to fetch books:', error);
    } finally {
      setLoading(false);
    }
  };

  // Initial load
  useEffect(() => {
    fetchBooks(pagination.current, pagination.pageSize, searchTerm);
  }, []);

  // Handle pagination change
  const handlePaginationChange = (page: number, pageSize: number) => {
    fetchBooks(page, pageSize, searchTerm);
  };

  // Handle search
  const handleSearch = (value: string) => {
    setSearchTerm(value);
    fetchBooks(1, pagination.pageSize, value); // Reset to page 1 on search
  };

  const columns = [
    { title: 'Title', dataIndex: 'title', key: 'title' },
    { title: 'Author', dataIndex: 'author_name', key: 'author_name' },
    { title: 'ISBN', dataIndex: 'isbn', key: 'isbn' },
    // ... more columns
  ];

  return (
    <OptimizedTable
      data={books}
      columns={columns}
      config={{
        title: 'Books Catalog',
        serverSidePagination: true, // Enable server-side pagination
        searchable: true,
        pagination: {
          current: pagination.current,
          pageSize: pagination.pageSize,
          total: pagination.total,
          showSizeChanger: true,
          showQuickJumper: true,
          showTotal: (total, range) => 
            `${range[0]}-${range[1]} of ${total} books`,
        },
        loading,
      }}
      onSearch={handleSearch}
      onPaginationChange={handlePaginationChange}
    />
  );
};
```

### Using React Query Hook

```tsx
import { useQuery } from '@tanstack/react-query';
import { OptimizedTable } from '@/components/ui/organisms/tables/OptimizedTable';
import { bookService } from '@/services/book.service';

const BookListPage = () => {
  const [pagination, setPagination] = useState({
    current: 1,
    pageSize: 20,
  });
  const [searchTerm, setSearchTerm] = useState('');

  const { data, isLoading, refetch } = useQuery({
    queryKey: ['books', pagination.current, pagination.pageSize, searchTerm],
    queryFn: async () => {
      const result = await bookService.findAll({
        pagination: {
          current: pagination.current,
          pageSize: pagination.pageSize,
        },
        search: searchTerm || undefined,
      });
      return result;
    },
  });

  const handlePaginationChange = (page: number, pageSize: number) => {
    setPagination({ current: page, pageSize });
  };

  const handleSearch = (value: string) => {
    setSearchTerm(value);
    setPagination(prev => ({ ...prev, current: 1 })); // Reset to page 1
  };

  return (
    <OptimizedTable
      data={data?.data || []}
      columns={columns}
      config={{
        serverSidePagination: true,
        pagination: {
          current: pagination.current,
          pageSize: pagination.pageSize,
          total: data?.total || 0,
        },
        loading: isLoading,
      }}
      onSearch={handleSearch}
      onPaginationChange={handlePaginationChange}
    />
  );
};
```

## Key Differences: Server-Side vs Client-Side

| Feature | Server-Side Pagination | Client-Side Pagination |
|---------|----------------------|----------------------|
| **Data Loading** | Only current page loaded | All data loaded upfront |
| **Performance** | Fast initial load | Slower initial load |
| **Memory Usage** | Low | High for large datasets |
| **Search** | Backend handles search | Client-side filtering |
| **Sorting** | Backend handles sorting | Client-side sorting |
| **Use Case** | Large datasets (1000+) | Small datasets (<100) |

## Configuration Options

### TableConfig.serverSidePagination

```tsx
config={{
  serverSidePagination: true, // Enable server-side mode
  pagination: {
    current: 1,        // Current page (required)
    pageSize: 20,      // Items per page (required)
    total: 1000,       // Total items (required for server-side)
    showSizeChanger: true,
    showQuickJumper: true,
  },
}}
```

### onPaginationChange Callback

```tsx
onPaginationChange={(page: number, pageSize: number) => {
  // Fetch new page from backend
  fetchData(page, pageSize);
}}
```

## Migration Guide

### Before (Client-Side)

```tsx
// ❌ Old way - loads all data
const { data: allBooks } = useD1BooksQuery();
const filteredBooks = allBooks.filter(/* ... */);

<OptimizedTable
  data={filteredBooks}
  config={{ pagination: { current: 1, pageSize: 20 } }}
/>
```

### After (Server-Side)

```tsx
// ✅ New way - loads only current page
const [page, setPage] = useState(1);
const { data } = useD1BooksQuery({ 
  pagination: { current: page, pageSize: 20 } 
});

<OptimizedTable
  data={data?.data || []}
  config={{
    serverSidePagination: true,
    pagination: { current: page, pageSize: 20, total: data?.total }
  }}
  onPaginationChange={(p, size) => setPage(p)}
/>
```

## Backend Requirements

Your backend API should support:

1. **Pagination Parameters**:
   - `page` or `current` - current page number
   - `limit` or `pageSize` - items per page

2. **Response Format**:
   ```json
   {
     "data": [...], // Array of items for current page
     "pagination": {
       "page": 1,
       "pageSize": 20,
       "total": 1000,
       "totalPages": 50
     }
   }
   ```

3. **Search Support**:
   - `search` query parameter for text search
   - Backend should filter results before pagination

## Performance Benefits

- **Initial Load**: Only loads 20-50 items instead of thousands
- **Memory**: Uses ~95% less memory for large datasets
- **Network**: Reduces data transfer significantly
- **User Experience**: Faster page loads, smoother interactions

## Best Practices

1. **Always set `total`** when using server-side pagination
2. **Reset to page 1** when search/filter changes
3. **Show loading state** during data fetching
4. **Handle errors** gracefully
5. **Cache results** using React Query or similar
6. **Debounce search** input for better performance

## Troubleshooting

### Pagination not working?
- Ensure `serverSidePagination: true` is set
- Check that `onPaginationChange` callback is provided
- Verify `total` is set correctly

### Search not working?
- Ensure `onSearch` callback fetches from backend
- Reset pagination to page 1 on search
- Check backend search implementation

### Performance still slow?
- Verify backend pagination is working
- Check network tab for large responses
- Consider increasing `pageSize` if appropriate
- Review backend query optimization

