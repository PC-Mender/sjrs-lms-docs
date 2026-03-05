---
title: "Overview"
slug: features/students
---

# Students Module

This module provides a comprehensive, modular system for managing students in the SJRS LMS application.

## Architecture

The module follows a clean, modular architecture with clear separation of concerns:

```
src/pages/students/
├── index.tsx                 # Main page component
├── components/               # Reusable UI components
│   ├── index.ts             # Component exports
│   ├── StudentTable.tsx     # Data table component
│   ├── StudentForm.tsx      # Form for create/edit
│   ├── StudentViewModal.tsx # Student details view
│   ├── StudentEditModal.tsx # Edit student modal
│   ├── StudentCreateModal.tsx # Create student modal
│   └── StudentDeleteModal.tsx # Delete confirmation modal
├── hooks/                    # Custom React hooks
│   └── useStudents.ts       # Main data management hook
├── services/                 # API service layer
│   └── studentService.ts    # Student API operations
├── types/                    # TypeScript type definitions
│   └── student.types.ts     # Student-related interfaces
└── index.md                # This documentation
```

## Key Features

### 1. **Modular Components**
- **StudentTable**: Displays student data with sorting, filtering, and pagination
- **StudentForm**: Reusable form for creating and editing students
- **StudentViewModal**: Comprehensive student details view
- **StudentEditModal**: Modal for editing existing students (enhanced in v3.49.0 with status management)
- **StudentCreateModal**: Modal for creating new students from existing users
- **StudentDeleteModal**: Confirmation modal for student deletion

### 2. **Status Tracking (v3.49.0+)**
- **Account Status Column**: Displays user account state (Active, Pending Approval, etc.)
- **Onboarding Status Column**: Shows user setup progress (In Progress, Completed, etc.)
- **Status Badges**: Color-coded visual indicators for quick identification
- **Status Filtering**: Filter students by account or onboarding status
- **Metadata Endpoints**: New endpoints for enriched metadata
  - `GET /api/v1/students/:id/meta` - Fetch student metadata with status info
  - Enhanced backend handlers for status enrichment

### 3. **Service Layer**
- **StudentService**: Handles all API communication with the backend
- **Data Transformation**: Converts between API and frontend data formats
- **Error Handling**: Consistent error handling across all operations
- **Metadata Fetching**: New methods to retrieve student metadata with status details

### 4. **Custom Hooks**
- **useStudents**: Manages all student-related state and operations
- **React Query Integration**: Efficient data fetching and caching
- **Modal State Management**: Centralized modal visibility control
- **Status Management**: Handles account and onboarding status updates

### 5. **Type Safety**
- **StudentWithDetails**: Extended user interface with student-specific fields plus status fields
- **StudentFormData**: Form data interface for validation
- **API Response Types**: Proper typing for backend communication
- **Status Constants**: Imported from centralized `status-helpers.ts`

## Version History

### v3.49.0 (March 2, 2026)
- ✅ Added Account Status and Onboarding Status columns
- ✅ Enhanced StudentEditModal with status management
- ✅ New metadata endpoints for status enrichment
- ✅ Improved table performance with optimized queries
- ✅ Status alignment with Professors page patterns

### v3.48.x (February 2026)
- ✅ Initial release with core functionality

## Backend Integration

The module is designed to work seamlessly with the existing backend API:

- **GET /api/v1/students**: Fetch students with pagination and search
- **GET /api/v1/students/:id**: Get individual student details
- **GET /api/v1/students/:id/meta**: Get student metadata with status enrichment (v3.49.0+)
- **POST /api/v1/students**: Create new student record
- **PUT /api/v1/students/:id**: Update existing student (including account/onboarding status)
- **DELETE /api/v1/students/:id**: Delete student record

### Status Management API

```typescript
// Fetch student with metadata
const response = await fetch('/api/v1/students/123/meta');
const { data } = await response.json();

// Response includes:
// {
//   id: number,
//   email: string,
//   account_status: 'active' | 'pending-approval' | 'pending-verification' | ...,
//   onboarding_status: 'not-started' | 'in-progress' | 'completed' | 'skipped',
//   name: string,
//   reg_number: string,
//   ...
// }
```

## Usage

### Basic Implementation

```tsx
import { useStudents } from './hooks/useStudents';
import { StudentTable } from './components';

const MyComponent = () => {
  const { students, loading, openViewModal } = useStudents();
  
  return (
    <StudentTable
      students={students}
      loading={loading}
      onView={openViewModal}
      // ... other props
    />
  );
};
```

### Creating a Student

```tsx
const { openCreateModal, handleCreateStudent } = useStudents();

const handleSubmit = (data: StudentFormData & { user_id: number }) => {
  handleCreateStudent(data);
};

// Open create modal
openCreateModal();
```

### Editing a Student

```tsx
const { openEditModal, handleUpdateStudent } = useStudents();

const handleEdit = (student: StudentWithDetails) => {
  openEditModal(student);
};

const handleSubmit = (data: StudentFormData) => {
  handleUpdateStudent(student.id, data);
};
```

## Data Flow

1. **Initial Load**: `useStudents` hook fetches data via `StudentService`
2. **User Interaction**: User clicks actions (view, edit, delete)
3. **Modal Display**: Appropriate modal opens with student data
4. **Data Submission**: Form data is processed and sent to backend
5. **State Update**: React Query invalidates cache and refetches data
6. **UI Update**: Components re-render with updated data

## Permissions

The module respects the permission system:
- **Read**: View student list and details
- **Create**: Add new students
- **Update**: Edit existing students
- **Delete**: Remove students

## Error Handling

- **API Errors**: Handled by `StudentService` with user-friendly messages
- **Validation Errors**: Form validation with clear error messages
- **Network Errors**: Graceful fallbacks and retry mechanisms

## Performance Features

- **React Query**: Efficient caching and background updates
- **Debounced Search**: Optimized search performance
- **Pagination**: Server-side pagination for large datasets
- **Lazy Loading**: Components load only when needed

## Future Enhancements

- **Bulk Operations**: Select multiple students for batch actions
- **Advanced Filters**: Department, year, status filtering
- **Export Functionality**: CSV/PDF export of student data
- **Audit Trail**: Track changes to student records
- **Import Functionality**: Bulk import from CSV files

## Import Examples

```typescript
import { User, UserType, Student } from 'src/types/users';
import { StudentWithDetails, StudentFormData } from 'src/types/students';
```

## Related Documentation

- **[Account Status & Onboarding Management](/features/account-management)** - Comprehensive guide to status tracking and onboarding workflows
- **[Members Directory](/features/members/)** - Member administration and directory features
<!-- Future links here -->

---

**Source**: Moved from `src/pages/students/index.md` during documentation consolidation

