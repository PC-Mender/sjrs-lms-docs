---
title: "Overview"
---

# Subcategories Module

## 📁 Structure

```
src/pages/subcategories/
├── components/
│   ├── SubcategoryList.tsx      # Main list component with CRUD operations
│   ├── SubcategoryForm.tsx      # Reusable form component for create/edit
│   └── SubcategoryShow.tsx      # Detail view component
├── index.tsx                    # Module exports
├── SubcategoryListPage.tsx      # Page wrapper for list view
├── SubcategoryShowPage.tsx      # Page wrapper for detail view
└── README.md                    # This documentation
```

## 🏗️ Architecture

### Backend Alignment
- **API Endpoint**: `/api/subcategories`
- **Database Table**: `subcategories`
- **Schema Fields**:
  - `id` (INTEGER PRIMARY KEY)
  - `name` (TEXT NOT NULL)
  - `section_id` (INTEGER, nullable)
  - `created_at` (DATETIME)
  - `updated_at` (DATETIME)

### Frontend Components
- **SubcategoryList**: Main component handling all CRUD operations
- **SubcategoryForm**: Reusable form component for create/edit operations
- **SubcategoryShow**: Detail view component showing subcategory information and related books
- **Types**: Proper TypeScript interfaces in `src/types/d1/subcategories.ts`

## 🔧 Features

### CRUD Operations
- ✅ **Create**: Modal form for new subcategories
- ✅ **Read**: Paginated table with search functionality
- ✅ **Update**: Inline edit modal
- ✅ **Delete**: Confirmation modal with validation

### Search & Filtering
- Real-time search across name and section
- Pagination support
- Sortable columns

### Validation
- Required field validation
- Name length constraints (2-100 characters)
- Section selection validation

## 🚀 Usage

### Basic List View
```tsx
import { SubcategoryList } from './components/SubcategoryList';

// Use in any page
<SubcategoryList />
```

### Form Component
```tsx
import { SubcategoryForm } from './components/SubcategoryForm';

<SubcategoryForm
  onSubmit={handleSubmit}
  onCancel={handleCancel}
  loading={isLoading}
  isEdit={false}
/>
```

### Detail View
```tsx
import { SubcategoryShow } from './components/SubcategoryShow';

// Use in route with ID parameter
<SubcategoryShow />
```

## 🔒 Security

- Admin/Superuser/Librarian access required for mutations
- Proper permission checks on backend
- Input validation and sanitization
- SQL injection protection

## 📊 Data Flow

1. **List**: `GET /api/subcategories` → Display in table
2. **Create**: Form submission → `POST /api/subcategories` → Refresh list
3. **Update**: Form submission → `PUT /api/subcategories/:id` → Refresh list
4. **Delete**: Confirmation → `DELETE /api/subcategories/:id` → Refresh list

## 🔄 State Management

- Uses React Query for server state management
- Local state for UI interactions (modals, forms)
- Optimistic updates for better UX
- Proper error handling and loading states

## 🎨 UI Components

- **Ant Design**: Consistent UI components
- **Responsive Design**: Works on all screen sizes
- **Accessibility**: Proper ARIA labels and keyboard navigation
- **Loading States**: Skeleton loaders and spinners

## 📝 Form Handling

- **Validation**: Client-side validation with Ant Design Form
- **Error Handling**: User-friendly error messages
- **Loading States**: Disabled buttons during submission
- **Reset**: Form resets after successful submission

## 🗑️ Removed Redundancy

- Eliminated duplicate page files
- Consolidated all CRUD operations in one list component
- Reusable form component for create/edit
- Clean separation of concerns

## 🔧 Future Enhancements

- Bulk operations (delete multiple, bulk edit)
- Advanced filtering (by section, date range)
- Export functionality (CSV, PDF)
- Audit logging for changes
- Soft delete with restore functionality

---

**Source**: Moved from `src/pages/subcategories/README.md` during documentation consolidation
