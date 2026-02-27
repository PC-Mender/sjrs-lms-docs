---
title: "Api Patterns"
---

# API Patterns & Architecture

## Overview

This document outlines the API patterns and architecture used in the SJRS LMS, including the migration from Hono-based APIs to direct function APIs for better performance and consistency.

## 🏗️ API Architecture

### **Direct Function API Pattern**

The SJRS LMS uses a **direct function API pattern** optimized for Cloudflare Workers, providing:

- **Better Performance** - Native Cloudflare Workers functions without framework overhead
- **Simpler Debugging** - Direct function calls with clear stack traces
- **Consistent Patterns** - Standardized routing and error handling across all endpoints
- **Type Safety** - Full TypeScript support throughout the API layer

### **Migration from Hono Framework**

The project was migrated from Hono-based APIs to direct function APIs for the following reasons:

1. **Performance** - Direct function calls are faster than framework routing
2. **Simplicity** - Easier to debug and understand without framework abstraction
3. **Consistency** - All APIs now follow the same pattern
4. **Cloudflare Native** - Better alignment with Cloudflare Workers architecture

## 📋 API Structure

### **Standard API Function Pattern**

All API endpoints follow this consistent pattern:

```typescript
// functions/api/resource-name.ts
import { getAuthenticatedUser } from '../../middleware/auth';
import { addCORSHeaders } from '../../middleware/cors';
import { handleError } from '../../utilities/error/unified-error-handler';

export async function resourceName(request: Request, env: any) {
  const url = new URL(request.url);
  const path = url.pathname.replace('/api/resource-name', '');
  
  try {
    // Authentication middleware
    const user = await getAuthenticatedUser(request, env);
    if (!user) {
      const response = new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { 'Content-Type': 'application/json' }
      });
      return addCORSHeaders(response, request.headers.get('Origin'));
    }
    
    // Route handling with consistent patterns
    if (request.method === 'GET' && (path === '' || path === '/')) {
      // Handle GET /api/resource-name
      const result = await env.DB.prepare('SELECT * FROM resource_name').all();
      const response = new Response(JSON.stringify({ success: true, data: result.results }), {
        headers: { 'Content-Type': 'application/json' }
      });
      return addCORSHeaders(response, request.headers.get('Origin'));
    } else if (request.method === 'POST' && (path === '' || path === '/')) {
      // Handle POST /api/resource-name
      const body = await request.json();
      const result = await env.DB.prepare('INSERT INTO resource_name (name) VALUES (?)').bind(body.name).run();
      const response = new Response(JSON.stringify({ success: true, data: result }), {
        headers: { 'Content-Type': 'application/json' }
      });
      return addCORSHeaders(response, request.headers.get('Origin'));
    } else if (path.startsWith('/')) {
      const id = path.substring(1);
      // Handle /api/resource-name/:id
      if (request.method === 'GET') {
        const result = await env.DB.prepare('SELECT * FROM resource_name WHERE id = ?').bind(id).first();
        const response = new Response(JSON.stringify({ success: true, data: result }), {
          headers: { 'Content-Type': 'application/json' }
        });
        return addCORSHeaders(response, request.headers.get('Origin'));
      }
    }
    
    // Handle unsupported methods
    const response = new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: { 'Content-Type': 'application/json' }
    });
    return addCORSHeaders(response, request.headers.get('Origin'));
    
  } catch (error) {
    return await handleError(error, {
      operation: 'resource_name_api',
      component: 'ResourceNameAPI',
      context: { endpoint: '/api/resource-name' }
    });
  }
}
```

### **Standardized Routing Pattern**

All APIs follow a consistent routing pattern:

```typescript
const path = url.pathname.replace('/api/resource-name', '');

// Root endpoint: /api/resource-name
if (path === '' || path === '/') {
  // Handle collection operations (GET, POST)
}

// Specific resource: /api/resource-name/:id
if (path.startsWith('/')) {
  const id = path.substring(1);
  // Handle individual resource operations (GET, PUT, DELETE)
}
```

### **Main Router Pattern**

The main router (`functions/index.ts`) directs requests to appropriate API functions:

```typescript
// functions/index.ts
import { books } from './api/books/index';
import { users } from './api/users/index';
import { loans } from './api/loans/index';
import { handlePaymentsRequest } from './api/payments/index';
import { handleReceiptsRequest } from './api/receipts/index';
// ... other imports

export default {
  async fetch(request: Request, env: any): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;
    
    try {
      // Route to appropriate API function
      if (path.startsWith('/api/books')) {
        return await books(request, env);
      } else if (path.startsWith('/api/users')) {
        return await users(request, env);
      } else if (path.startsWith('/api/loans')) {
        return await loans(request, env);
      } else if (path.startsWith('/api/payments')) {
        return await handlePaymentsRequest(request, env);
      } else if (path.startsWith('/api/receipts')) {
        return await handleReceiptsRequest(request, env);
      }
      // ... other routes
      
    } catch (error) {
      return await handleError(error, {
        operation: 'main_router',
        component: 'MainRouter',
        context: { path }
      });
    }
  }
};
```

## 🔧 Error Handling

### **Unified Error Handling**

All APIs use the unified error handling system:

```typescript
import { handleError } from '../../utilities/error/unified-error-handler';

try {
  // API logic
} catch (error) {
  return await handleError(error, {
    operation: 'api_operation',
    component: 'APIComponent',
    context: { endpoint: '/api/resource-name' }
  });
}
```

### **CORS Headers**

All responses include CORS headers:

```typescript
import { addCORSHeaders } from '../middleware/cors';

const response = new Response(JSON.stringify(data), {
  headers: { 'Content-Type': 'application/json' }
});
return addCORSHeaders(response, request.headers.get('Origin'));
```

## 📊 Migration Summary

### **Before Migration (Hono-based)**
```typescript
// functions/api/resource.ts
import { Hono } from 'hono';

const app = new Hono();

app.get('/', async (c) => {
  const result = await c.env.DB.prepare('SELECT * FROM resource').all();
  return c.json({ success: true, data: result.results });
});

export default app;
```

### **After Migration (Direct Function)**
```typescript
// functions/api/resource.ts
export async function resource(request: Request, env: any) {
  const url = new URL(request.url);
  const path = url.pathname.replace('/api/resource', '');
  
  if (request.method === 'GET' && (path === '' || path === '/')) {
    const result = await env.DB.prepare('SELECT * FROM resource').all();
    const response = new Response(JSON.stringify({ success: true, data: result.results }), {
      headers: { 'Content-Type': 'application/json' }
    });
    return addCORSHeaders(response, request.headers.get('Origin'));
  }
}
```

### **Router Changes**
```typescript
// Before
if (path.startsWith('/api/books')) {
  return await books.fetch(request, env);
}

// After
if (path.startsWith('/api/books')) {
  return await books(request, env);
}
```

## 🎯 Best Practices

### **1. Consistent Patterns**
- Use the same routing pattern across all APIs
- Apply CORS headers to all responses
- Use unified error handling for all errors

### **2. Authentication**
- Always check authentication at the start of each API function
- Return consistent unauthorized responses
- Include user context in error handling

### **3. Database Operations**
- Use parameterized queries to prevent SQL injection
- Handle database errors gracefully
- Use appropriate database methods (`.all()`, `.first()`, `.run()`)

### **4. Response Format**
- Use consistent response structure
- Include appropriate HTTP status codes
- Provide meaningful error messages

### **5. Performance**
- Minimize database queries
- Use appropriate indexes
- Consider caching for frequently accessed data

## 📋 API Endpoints

### **Core APIs**
- **Authentication**: `/api/auth` - Login, registration, session management
- **Users**: `/api/users` - User management and profiles
- **Books**: `/api/books` - Book catalog and management
- **Loans**: `/api/loans` - Borrowing and return operations
- **Permissions**: `/api/permissions` - Role-based access control (legacy endpoints supported)
- **Payments**: `/api/payments` - Create, list, verify, user payments
- **Receipts**: `/api/receipts` - Create, get, download receipts

### **Supporting APIs**
- **Authors**: `/api/authors` - Author management
- **Book Copies**: `/api/book-copies` - Physical copy tracking
- **Reviews**: `/api/book-reviews` - Book review system
- **Borrow Limits**: `/api/borrow-limits` - Borrowing restrictions
- **Notifications**: `/api/notifications` - User notifications
- **Orders**: `/api/orders` - Order management
- **Penalties**: `/api/penalties` - Overdue and violation tracking
- **Publications**: `/api/publications` - Publication management
- **Roles**: `/api/roles` - Role management
- **Students**: `/api/students` - Student-specific operations
- **Upload**: `/api/upload` - File upload handling
- **Wishlist**: `/api/wishlist` - Wishlist management

### Orders API: Borrow Request Rules

- Purpose: Users create borrow requests (orders) for books that are fully Available.
- Create request (POST /api/orders):
  - Request body: `{ book_id: number, order_type?: 'request' }` (order_type defaults to 'request').
  - Server validations:
    - Book exists.
    - Availability strict: the book has copies and all copies have `status='available'`.
    - Duplicate prevention: no existing pending order by the same user for the same `book_id`.
    - Borrow limit enforcement: `active loans + pending orders + 1 <= borrow_limits.max_books` for the user’s `user_type`.
  - On success: creates an order with `status='pending'` and derived `title/author/isbn`.

- Approve request (PUT /api/orders/:id with `{ status: 'approved' }`):
  - Atomically claims one available copy for the book.
  - Creates a loan for the user and claimed copy; due date uses `borrow_limits.max_days` (fallback 14).
  - Updates order to `completed` and sets `approved_by/approved_at`.
  - If no copy available at approval time, approval fails with 409.

- Permissions:
  - POST allowed for students, professors, guests, and librarians.
  - PUT/DELETE restricted to librarians.

## 🔄 Migration Status

### **Completed Migrations**
- ✅ **Authors API** - Migrated from Hono to direct function
- ✅ **Book Copies API** - Migrated from Hono to direct function
- ✅ **Book Reviews API** - Migrated from Hono to direct function
- ✅ **Borrow Limits API** - Migrated from Hono to direct function
- ✅ **Notifications API** - Migrated from Hono to direct function
- ✅ **Orders API** - Migrated from Hono to direct function
- ✅ **Penalties API** - Migrated from Hono to direct function
- ✅ **Publications API** - Migrated from Hono to direct function
- ✅ **Upload API** - Migrated from Hono to direct function
- ✅ **Wishlist API** - Migrated from Hono to direct function

### **Already Direct Function APIs**
- ✅ **Auth API** - Already using direct function pattern
- ✅ **Books API** - Already using direct function pattern
- ✅ **Loans API** - Already using direct function pattern
- ✅ **Users API** - Already using direct function pattern
- ✅ **Roles API** - Already using direct function pattern
- ✅ **Students API** - Already using direct function pattern
- ✅ **Permissions API** - Already using direct function pattern

### **Special Purpose APIs**
- ✅ **Migrations API** - Uses direct function pattern for database migrations
- ✅ **Action Logs API** - Uses direct function pattern for audit logging
- ✅ **System Logs API** - Structured logs for system events
- ✅ **Email API** - Trigger email workflows

## 📝 Dependencies

### **Removed Dependencies**
- ❌ **Hono** - Removed from `package.json` after migration

### **Required Dependencies**
- ✅ **Cloudflare Workers** - Native runtime environment
- ✅ **TypeScript** - Type safety throughout
- ✅ **D1 Database** - SQLite-based database

---

**Last Updated:** November 2025  
**Version:** 2.3.0  
**Status:** Complete Migration
