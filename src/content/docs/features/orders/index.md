---
title: "Overview"
---

# Orders Module

This module provides a complete, modular system for managing library orders and book requests, utilizing a **Backend-First** architecture with **Cloudflare D1**.

## Structure

The module follows a feature-based architecture, separating UI components, business logic, and page wrappers.

```text
src/
├── components/
│   ├── features/
│   │   └── orders/             # Core order components and logic
│   │       ├── components/     # UI Components (OrderForm, OrderTableActions, etc.)
│   │       ├── hooks/          # Custom hooks (useOrderModeration, useOrderTableColumns)
│   │       ├── types/          # TypeScript interfaces (Order, OrderFormValues)
│   │       ├── utils/          # Utilities (status colors, formatting)
│   │       └── index.ts        # Public API
│   └── request-cart/           # Request Cart feature
│       ├── RequestCartDrawer.tsx
│       └── ...
└── pages/
    └── orders/                 # Page wrappers (Lazy loaded)
        ├── OrderList.tsx       # Main listing page
        ├── OrderCreate.tsx     # Create page
        ├── OrderShow.tsx       # Details page
        └── OrderEdit.tsx       # Edit page
```

### Backend Structure (`functions/api/orders/`)

The backend is organized into layers to ensure separation of concerns and testability:

```text
functions/api/orders/
├── handlers/           # HTTP Endpoint handlers (GET, POST, etc.)
├── policies/           # Business rules (canApproveOrder, canCreateOrder)
├── repositories/       # Data access layer (D1 queries & mutations)
│   └── orders-repository/
│       ├── loan-from-order.ts # Atomic loan creation logic
│       └── ...
├── validation/         # Zod schemas for input validation
└── services/           # External services (e.g., Notifications)
```

## Components

### OrderList
-   **Wrapper**: `src/pages/orders/OrderList.tsx`
-   **Implementation**: Uses `ManagementTable` and `useD1OrdersQuery`.
-   **Features**:
    -   Server-side pagination and sorting.
    -   Advanced filtering (Priority, Author, Date Range, User).
    -   Role-based columns (Admin sees User info, Regular users don't).
    -   Real-time feedback on actions (Approve, Reject).

### Request Cart
-   **Location**: `src/components/request-cart/`
-   **Functionality**:
    -   Allows users to collect multiple book requests.
    -   **Validation**: Checks for existing pending requests and availability.
    -   **Submission**: Bulk submission via `useRequestCart` context.
    -   **UI**: Drawer-based interface accessible via the global layout.

### OrderShow
-   Detailed view of a single order using `OrderDescriptions`.
-   Displays timeline of events (Created -> Approved/Rejected).
-   Shows book copy allocation details when approved.

## Backend Architecture

This module fully implements the **Backend-First** principle.

### 1. Policies (`policies/`)
Business logic is encapsulated in policy functions, not handlers.
-   `canApproveOrder`: Checks book availability, user borrow limits, and user status.
-   `canCreateOrder`: Checks for duplicates, overdue books, and cooldown periods.

### 2. Repositories (`repositories/`)
Handles all D1 database interactions.
-   **Atomic Operations**: Critical state changes happen in transactions.
    -   **Approval Flow** (`loan-from-order.ts`):
        1.  Updates `book_copies` status to 'borrowed'.
        2.  Creates a new `loans` record.
        3.  Updates `orders` status to 'completed'.
        4.  Updates `wishlist` status to 'acquired' (if applicable).
        5.  All execution within a single `db.batch()` call.

### 3. Validation (`validation/`)
Uses **Zod** for strict input validation.
-   `OrderCreateSchema`: Validates book ID and order type.
-   `OrderUpdateSchema`: Validates status transitions and admin notes.

## Integration

### With Wishlist
-   **Automatic Update**: When an order is approved, the system checks if the user has the book in their wishlist. If found, the wishlist item is marked as `acquired`.
-   **Status Check**: The backend prevents ordering books that are already "Available" (users should borrow directly) unless configured otherwise.

### With Loans
-   **Seamless Transition**: An approved order automatically becomes a loan.
-   **Due Date**: Calculated automatically based on the user's role and borrow limits.

## Types & Constants

Defined in `src/components/features/orders/types/` and `utils/`.

-   **`OrderWithDetails`**: Full order object with joined Book and User data.
-   **`ORDER_STATUSES`**: `pending`, `completed`, `cancelled`, `rejected`.
-   **`ORDER_TYPES`**: `request` (borrow), `purchase` (suggestion).

## Future Enhancements

-   **Email Notifications**: Send email on status change (Service stubbed in `services/`).
-   **Waitlist System**: Automatically create a reservation if order cannot be fulfilled immediately.
