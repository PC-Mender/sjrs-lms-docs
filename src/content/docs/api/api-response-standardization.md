---
title: "Api Response Standardization"
---

# 📦 API Response Standardization

**Status:** ✅ **Production Ready**  
**Version:** 1.0.0  
**Last Updated:** November 2025

## 📋 Overview

The SJRS LMS now features a **standardized API response system** that ensures consistent response formats across all backend endpoints. This system provides better frontend integration, improved error handling, and enhanced debugging capabilities.

## 🎯 **Key Features**

### ✅ **Standardized Response Formats**
- **Consistent Structure**: All API responses follow the same format
- **Type Safety**: Full TypeScript support with proper interfaces
- **Frontend Compatible**: Perfect integration with React hooks
- **Debugging Support**: Request IDs and timestamps in all responses

### ✅ **Response Builder System**
- **Centralized Logic**: Single source of truth for response creation
- **Automatic CORS**: CORS headers added automatically
- **Error Handling**: Structured error responses with codes
- **Performance Tracking**: Built-in processing time measurement

### ✅ **Backward Compatibility**
- **Re-exports**: All utility files maintain backward compatibility
- **No Breaking Changes**: Existing handlers continue to work
- **Gradual Migration**: Handlers can be updated incrementally

## 🏗️ **Architecture**

### **Response Builder Location**
```
functions/utilities/response-builder.ts
```

### **Response Format Structure**
```typescript
// Success Response
{
  "success": true,
  "data": T,                           // Actual response data
  "message": string,                   // Human-readable message
  "status": number,                    // HTTP status code
  "timestamp": "2024-01-15T10:30:00Z", // ISO timestamp
  "requestId": "req_1705312200_abc123", // Unique request ID
  "meta": {                            // Optional metadata
    "processingTime": 45,
    "version": "1.0.0"
  }
}

// Error Response
{
  "success": false,
  "message": string,                   // User-friendly error message
  "error": {
    "code": "VALIDATION_ERROR",        // Error code for programmatic handling
    "details": string,                 // Detailed error description
    "fields": {                        // Field-specific validation errors
      "email": ["Email is required"],
      "password": ["Password too short"]
    },
    "stack": string                    // Stack trace (development only)
  },
  "status": number,                    // HTTP status code
  "timestamp": "2024-01-15T10:30:00Z", // ISO timestamp
  "requestId": "req_1705312200_err456"  // Unique request ID
}

// Paginated Response
{
  "success": true,
  "data": T[],                         // Array of items
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5,
    "hasNext": true,
    "hasPrev": false
  },
  "message": "Resources listed successfully",
  "status": 200,
  "timestamp": "2024-01-15T10:30:00Z",
  "requestId": "req_1705312200_xyz789"
}
```

## 🔧 **Implementation**

### **Response Builder Functions**

#### **Success Responses**
```typescript
import { createSuccessResponse } from '../utilities/response-builder';

// Basic success response
const response = createSuccessResponse(
  { id: 1, title: "Book Title" },     // data
  "Book retrieved successfully",       // message
  200,                                // status (optional)
  { version: "1.0.0" },              // meta (optional)
  request.headers.get('Origin')       // origin for CORS
);

// Created response (specialized)
const createdResponse = createCreatedResponse(
  createdBook,                        // data (must have id field)
  'Book',                            // resource name
  request.headers.get('Origin')
);
```

#### **Error Responses**
```typescript
import { createErrorResponse } from '../utilities/response-builder';

// Basic error response
const errorResponse = createErrorResponse(
  "Book not found",                   // message
  404,                               // status
  "NOT_FOUND",                       // error code
  "The requested book could not be found", // details
  undefined,                         // validation fields
  request.headers.get('Origin')      // origin for CORS
);

// Validation error response
const validationResponse = createValidationErrorResponse(
  {                                  // validation fields
    "title": ["Title is required"],
    "author": ["Author must be selected"]
  },
  "Validation failed",              // message
  request.headers.get('Origin')
);
```

#### **Paginated Responses**
```typescript
import { createPaginatedResponse } from '../utilities/response-builder';

const paginatedResponse = createPaginatedResponse(
  books,                             // data array
  {                                  // pagination info
    page: 1,
    limit: 20,
    total: 100
  },
  "Books retrieved successfully",    // message
  { filters: appliedFilters },      // meta (optional)
  request.headers.get('Origin')
);
```

### **Utility File Integration**

All base utility files (`*-utils.ts`) now re-export the standardized functions:

```typescript
// functions/api/books/base/book-utils.ts
import { 
  createSuccessResponse as _createSuccessResponse, 
  createErrorResponse as _createErrorResponse 
} from '../../../utilities/response-builder';

// Re-export for backward compatibility
export const createSuccessResponse = _createSuccessResponse;
export const createErrorResponse = _createErrorResponse;
```

## 📊 **Error Codes**

### **Standard Error Codes**
```typescript
export const ERROR_CODES = {
  VALIDATION_ERROR: 'VALIDATION_ERROR',
  NOT_FOUND: 'NOT_FOUND',
  UNAUTHORIZED: 'UNAUTHORIZED',
  FORBIDDEN: 'FORBIDDEN',
  CONFLICT: 'CONFLICT',
  INTERNAL_ERROR: 'INTERNAL_ERROR',
  RATE_LIMITED: 'RATE_LIMITED',
  BAD_REQUEST: 'BAD_REQUEST',
  DATABASE_ERROR: 'DATABASE_ERROR',
  EXTERNAL_SERVICE_ERROR: 'EXTERNAL_SERVICE_ERROR'
} as const;
```

### **Error Code Usage**
- **VALIDATION_ERROR**: Field validation failures
- **NOT_FOUND**: Resource not found (404)
- **UNAUTHORIZED**: Authentication required (401)
- **FORBIDDEN**: Access denied (403)
- **CONFLICT**: Resource conflict (409)
- **INTERNAL_ERROR**: Server errors (500)
- **RATE_LIMITED**: Too many requests (429)
- **BAD_REQUEST**: Invalid request (400)
- **DATABASE_ERROR**: Database operation failures
- **EXTERNAL_SERVICE_ERROR**: Third-party service failures

## 🎯 **Frontend Integration**

### **React Hook Integration**
The standardized responses work perfectly with the existing React hooks:

```typescript
// useStandardQuery expects APIResponse<T>
const { data, isLoading, error } = useStandardQuery<Book>(
  '/api/books/1'
);

// usePaginatedQuery expects PaginatedResponse<T>
const { data, pagination, isLoading } = usePaginatedQuery<Book>(
  '/api/books',
  { page: 1, limit: 20 }
);
```

### **Response Validation**
The frontend automatically validates response formats:

```typescript
// Validation functions check for required fields
function isValidAPIResponse(response: any): response is APIResponse<any> {
  return (
    response &&
    typeof response === 'object' &&
    typeof response.success === 'boolean' &&
    'data' in response &&
    typeof response.message === 'string' &&
    typeof response.status === 'number' &&
    typeof response.timestamp === 'string'
  );
}
```

## 🛠️ **Development Guide**

## 🔢 **Numeric Error Codes (codeNo)**
- Backend includes a numeric `codeNo` in error responses aligned with `ERROR_CODE_NO` in `shared/types/error-codes.ts`.
- Use `error.code` for programmatic branching and `error.codeNo` for analytics, dashboards, and compact logs.
- Frontend types in `src/types/api-response.ts` include `error.codeNo?: number`.

## 🧩 **Auto-Generated Error Code Reference**
- Run `npm run docs:generate:error-codes` to generate `docs/api/error-codes-reference.md` directly from `shared/types/error-codes.ts`.
- This table is the single source of truth for codes, numeric IDs, and default messages.

### **Error Handling Standardization**

All API handlers follow a standardized error handling pattern:

```typescript
import { handleError } from '../../../utilities/logging';
import { createErrorResponse, ERROR_CODES } from '../../../utilities/response-builder';

export async function handleSomeOperation(request: Request, env: Environment): Promise<Response> {
  try {
    // ... operation logic ...
    return createSuccessResponse(data);
  } catch (error) {
    // Standardized error handling
    await handleError(error, { 
      operation: 'operation_name',
      component: 'component_name',  // Always include component name
      env 
    });
    
    // Extract error message consistently
    const errorMessage = error instanceof Error ? error.message : 'An error occurred';
    
    // Return standardized error response with ERROR_CODES
    return createErrorResponse(
      'User-friendly error message',
      500,
      ERROR_CODES.INTERNAL_ERROR,  // Use ERROR_CODES constant, never string literals
      errorMessage,
      undefined,
      request.headers.get('Origin'),
      { error, env }  // Options for automatic stack trace in development
    );
  }
}
```

**Key Points:**
- ✅ Always use `handleError` for logging (includes Sentry integration)
- ✅ Always use `ERROR_CODES` constants (never string literals)
- ✅ Always include `component` name in error context
- ✅ Stack traces automatically included in development mode
- ✅ Consistent error message extraction pattern

### **Creating New API Endpoints**

1. **Import the response builder and error handler**:
```typescript
import { handleError } from '../../../utilities/logging';
import { 
  createSuccessResponse, 
  createErrorResponse,
  createPaginatedResponse,
  ERROR_CODES
} from '../../../utilities/response-builder';
```

2. **Use standardized responses**:
```typescript
export async function handleGetBooks(request: Request, env: Environment): Promise<Response> {
  try {
    // ... authentication and validation ...
    
    const books = await getBooks(filters, pagination);
    
    return createPaginatedResponse(
      books.data,
      {
        page: pagination.page,
        limit: pagination.limit,
        total: books.total
      },
      'Books retrieved successfully',
      { filters: appliedFilters },
      request.headers.get('Origin')
    );
  } catch (error) {
    await handleError(error, { 
      operation: 'get_books',
      component: 'books',
      env 
    });
    
    const errorMessage = error instanceof Error ? error.message : 'An error occurred';
    
    return createErrorResponse(
      'Failed to retrieve books',
      500,
      ERROR_CODES.INTERNAL_ERROR,
      errorMessage,
      undefined,
      request.headers.get('Origin'),
      { error, env }
    );
  }
}
```

### **Best Practices**

1. **Always include origin for CORS**:
```typescript
request.headers.get('Origin')
```

2. **Use appropriate error codes**:
```typescript
// For validation errors
createErrorResponse(message, 422, 'VALIDATION_ERROR', details, fields, origin);

// For not found errors
createErrorResponse(message, 404, 'NOT_FOUND', details, undefined, origin);
```

3. **Include meaningful metadata**:
```typescript
createSuccessResponse(data, message, 200, {
  processingTime: Date.now() - startTime,
  version: '1.0.0',
  filters: appliedFilters
}, origin);
```

4. **Use specialized response functions**:
```typescript
// For creation operations
return createCreatedResponse(newResource, 'Resource', origin);

// For update operations  
return createUpdatedResponse(updatedResource, 'Resource', origin);

// For deletion operations
return createDeletedResponse(resourceId, 'Resource', origin);
```

## 🔍 **Debugging & Monitoring**

### **Request Tracking**
Every response includes a unique `requestId` for tracking:
```
req_1705312200000_abc123def
```

### **Performance Monitoring**
Processing time is automatically tracked:
```typescript
const tracker = createPerformanceTracker();
// ... perform operations ...
const metadata = tracker.getMetadata(); // includes processingTime
```

### **Error Analysis**
Structured error responses help with debugging:
```typescript
{
  "error": {
    "code": "VALIDATION_ERROR",
    "details": "Field validation failed",
    "fields": {
      "email": ["Email is required", "Invalid email format"]
    }
  }
}
```

## 📈 **Benefits**

### **For Developers**
- **Consistent APIs**: All endpoints follow the same pattern
- **Better Debugging**: Request IDs and timestamps
- **Type Safety**: Full TypeScript support
- **Easy Testing**: Predictable response formats

### **For Frontend**
- **Reliable Integration**: Responses always match expected format
- **Better UX**: Consistent error handling
- **Performance Insights**: Processing time visibility
- **Debugging Support**: Request tracking capabilities

### **For Operations**
- **Monitoring**: Request IDs for log correlation
- **Performance**: Built-in timing measurements
- **Error Tracking**: Structured error information
- **Audit Trail**: Complete request/response logging

## 🚀 **Migration Guide**

### **Existing Handlers**
No changes required! The response builder maintains backward compatibility through re-exports in utility files.

### **New Handlers**
Use the standardized response builder directly:
```typescript
import { createSuccessResponse, createErrorResponse } from '../../../utilities/response-builder';
```

### **Gradual Updates**
Update existing handlers incrementally to use more specific response functions:
- `createCreatedResponse()` for POST operations
- `createUpdatedResponse()` for PUT/PATCH operations
- `createDeletedResponse()` for DELETE operations
- `createPaginatedResponse()` for list operations

## 🔗 **Related Documentation**

- **[API Documentation](../api/README.md)** - API endpoints and usage
- **[Frontend Hooks](../../src/hooks/useStandardizedAPI.ts)** - React integration
- **[Error Handling](../development/error-handling.md)** - Error handling patterns
- **[Testing Guide](../development/testing.md)** - API testing strategies

---

**Last Updated:** November 2025  
**Status:** ✅ Production Ready  
**Next Review:** January 2026
