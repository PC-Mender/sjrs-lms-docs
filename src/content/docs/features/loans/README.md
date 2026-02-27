---
title: "Overview"
---

# Loans Module

This module provides a complete loan management system for the SJRS LMS, following a modular architecture pattern.

## 🏗️ Architecture

### Directory Structure
```
src/components/features/loans/
├── components/           # Loan feature UI components
│   ├── LoanList.tsx     # Main loan listing component
│   ├── LoanCreate.tsx   # Loan creation form
│   ├── LoanEdit.tsx     # Loan editing form
│   ├── LoanShow.tsx     # Loan details display
│   ├── LoanForm.tsx     # Reusable form component
│   └── LoanTable.tsx    # Reusable table component
├── hooks/               # Feature hooks for business logic
│   ├── useLoanActions.ts # Loan action handlers (approve, reject, etc.)
│   └── useLoanTable.tsx # Table logic and data management
├── constants.ts         # Feature constants
├── types.ts             # TypeScript interfaces and types
└── index.ts             # Feature exports

src/pages/loans/
├── index.tsx            # Thin re-export shim for backward compatibility
├── constants.ts         # Thin re-export shim
├── types.ts             # Thin re-export shim
└── hooks/               # Thin re-export shims
```

## 🎯 Components

### Core Components
- **LoanList**: Main listing page with search, filtering, and pagination
- **LoanCreate**: Form for creating new loans
- **LoanEdit**: Form for editing existing loans
- **LoanShow**: Detailed view of a single loan
- **LoanForm**: Reusable form component for create/edit operations
- **LoanTable**: Reusable table component with actions

### Custom Hooks
- **useLoanActions**: Handles all loan operations (approve, reject, return, cancel, delete)
- **useLoanTable**: Manages table state, filtering, pagination, and permissions

## 🔧 Features

### Loan Management
- ✅ Create new loans
- ✅ Edit existing loans
- ✅ View loan details
- ✅ Search and filter loans
- ✅ Pagination support

### Loan Actions
- ✅ Approve pending loans (Librarian/Admin/Superuser)
- ✅ Reject pending loans (Librarian/Admin/Superuser)
- ✅ Return approved loans (Librarian/Admin/Superuser)
- ✅ Cancel pending loans (Students/Professors)
- ✅ Delete loans (Librarian/Admin/Superuser)

### Permission System
- **Librarian/Admin/Superuser**: Full access to all loan operations
- **Students/Professors**: Can create loans and cancel their own pending loans
- **Guests**: Read-only access to loan information

## 🚀 Usage

### Basic Import
```tsx
import { LoanList, LoanCreate, LoanEdit, LoanShow } from './components/features/loans';
```

### Using Custom Hooks
```tsx
import { useLoanActions, useLoanTable } from './components/features/loans/hooks';

const MyComponent = () => {
  const { handleApprove, handleReject } = useLoanActions();
  const { loans, loading, pagination } = useLoanTable();
  
  // Use the hooks...
};
```

### Using Types
```tsx
import type { LoanFormData, LoanStatus } from './components/features/loans/types';

const loanData: LoanFormData = {
  user_id: 1,
  copy_id: 1,
  status: 'pending',
  due_date: '2024-12-31'
};
```

## 🔄 Data Flow

1. **Data Fetching**: Uses `useD1LoansQuery` and related hooks for API calls
2. **State Management**: Local state managed through custom hooks
3. **User Actions**: Handled through `useLoanActions` hook
4. **UI Updates**: Components re-render based on state changes
5. **Error Handling**: Centralized error handling through `handleError` utility

## 🎨 UI Components

### Ant Design Integration
- Uses Ant Design components for consistent UI
- Responsive design with proper mobile support
- Accessible form controls and table interactions

### Styling
- Consistent with the overall application design
- Proper spacing and typography
- Status-based color coding for loan states

## 🔒 Security

### Permission Checks
- Role-based access control through `useRoles` hook
- Resource-level permissions for loan operations
- Client-side validation with server-side enforcement

### Data Validation
- Form validation using Ant Design's built-in validation
- Type safety through TypeScript interfaces
- API-level validation through backend schemas

## 🧪 Testing Considerations

### Component Testing
- Each component can be tested in isolation
- Custom hooks can be tested independently
- Mock data can be easily injected for testing

### Integration Testing
- Full loan workflow testing (create → approve → return)
- Permission-based access testing
- Error handling and edge case testing

## 📝 Future Enhancements

### Planned Features
- [ ] Bulk loan operations
- [ ] Advanced filtering and sorting
- [ ] Loan history tracking
- [ ] Overdue loan notifications
- [ ] Loan statistics and reporting

### Technical Improvements
- [ ] Virtual scrolling for large loan lists
- [ ] Real-time updates through WebSockets
- [ ] Offline support with service workers
- [ ] Advanced caching strategies

## 🤝 Contributing

When adding new features to the loans module:

1. **Follow the modular pattern** - Keep components focused and reusable
2. **Use custom hooks** - Extract business logic into hooks
3. **Maintain type safety** - Add proper TypeScript interfaces
4. **Update this README** - Document new features and changes
5. **Follow existing patterns** - Maintain consistency with the codebase

---

**Source**: Moved from `src/pages/loans/README.md` during documentation consolidation
