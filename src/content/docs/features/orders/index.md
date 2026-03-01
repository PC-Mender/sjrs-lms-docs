---
title: "Overview"
---

# Orders Module

This module provides a complete, modular system for managing library orders and book requests.

## Structure

```
src/pages/orders/
├── components/           # React components
│   ├── OrderList.tsx    # Main orders listing with table
│   ├── OrderCreate.tsx  # Create new order form
│   ├── OrderShow.tsx    # Display order details
│   ├── OrderEdit.tsx    # Edit existing order form
│   └── index.ts         # Component exports
├── types.ts             # TypeScript interfaces and types
├── constants.ts         # Configuration constants
├── utils.ts             # Utility functions
├── index.tsx            # Main module exports
└── index.md            # This file
```

## Components

### OrderList
- Displays all orders in a searchable, paginated table
- Supports filtering by various criteria
- Includes actions for view, edit, approve, reject, and delete
- Role-based permission controls

### Request Cart (Frontend)
- Users do not fill a form; they add books to a Request Cart from the catalog.
- The "Add to Request Cart" button is shown only when the book's availability status is exactly `Available`.
- Submitting the cart creates one request per book via `POST /api/orders` with `{ book_id, order_type: 'request' }`.
- Client removes only successful items; failed items remain for retry.

### OrderShow
- Detailed view of a single order
- Displays all order information in organized sections
- Shows approval/rejection dates when applicable

### OrderEdit
- Form for editing existing orders
- Pre-fills with current order data
- Status-based editing restrictions
- Navigation back to order details

## Types

### OrderWithDetails
Extended interface that includes related user and book information.

### OrderFormValues
Form data structure for creating and editing orders.

### OrderStatusConfig, OrderTypeConfig, PriorityConfig
Configuration objects for statuses, types, and priorities.

## Constants

### ORDER_STATUSES
Defines all possible order statuses with colors and labels.

### ORDER_TYPES
Available order types with descriptions.

### PRIORITIES
Priority levels with color coding.

### TABLE_COLUMNS
Column configuration for the orders table.

### FORM_VALIDATION_RULES
Validation rules for form fields.

## Utilities

### Status and Priority Functions
- `getStatusColor(status)` - Get color for status display
- `getPriorityColor(priority)` - Get color for priority display
- `getStatusLabel(status)` - Get human-readable status label
- `getPriorityLabel(priority)` - Get human-readable priority label

### Date Formatting
- `formatDate(date)` - Format date for display
- `formatDateTime(date)` - Format date and time for display

### Display Helpers
- `getUserDisplayName(order)` - Get formatted user name
- `getBookDisplayInfo(order)` - Get book title and subtitle

### Permission Checks
- `canManageOrders(userRole)` - Check if user can manage orders
- `canApproveOrder(status)` - Check if order can be approved
- `canRejectOrder(status)` - Check if order can be rejected
- `canEditOrder(status)` - Check if order can be edited
- `canDeleteOrder(status)` - Check if order can be deleted

## Usage

### Basic Import
```typescript
import { OrderList, OrderCreate, OrderShow, OrderEdit } from './pages/orders';
```

### Using Utilities
```typescript
import { getStatusColor, formatDate } from './pages/orders';

const statusColor = getStatusColor('pending');
const formattedDate = formatDate(order.created_at);
```

### Using Types
```typescript
import type { OrderWithDetails, OrderFormValues } from './pages/orders';

const order: OrderWithDetails = { /* ... */ };
const formData: OrderFormValues = { /* ... */ };
```

## Backend Alignment

This module is designed to work with the Cloudflare D1 database and API structure:

- Uses `useD1OrdersQuery` for data fetching
- Uses `useD1CreateOrder`, `useD1UpdateOrder`, `useD1DeleteOrder` for mutations
- Aligns with the orders table schema in `sql/d1-schema.sql`
- Follows the API patterns in `functions/api/orders/`

### Borrow Request Rules (Backend)
- Create request requires: existing book, all copies `available`, no duplicate pending user+book, within borrow limits.
- Approval automatically allocates a copy atomically, creates a loan (due date from `borrow_limits.max_days`), and completes the order.
- POST allowed for students, professors, guests, librarians; updates restricted to librarians.

## Features

- **Role-based Access Control**: Different actions available based on user role
- **Status Management**: Complete order lifecycle from pending to completed
- **Search and Filtering**: Find orders by various criteria
- **Validation**: Form validation with clear error messages
- **Responsive Design**: Works on all device sizes
- **Error Handling**: Comprehensive error handling and user feedback
- **Type Safety**: Full TypeScript support with proper interfaces

## Future Enhancements

- Bulk operations (approve/reject multiple orders)
- Advanced filtering and sorting
- Order templates for common requests
- Integration with notification system
- Export functionality (CSV, PDF)
- Order history tracking

---

**Source**: Moved from `src/pages/orders/index.md` during documentation consolidation

