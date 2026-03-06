---
title: "INTEGRATION MAP"
---

# User Preferences Integration Map

This document shows how user preferences integrate with different parts of the SJRS LMS application.

## Integration Overview

```
┌─────────────────────────────────────────────────────────────┐
│                    USER PREFERENCES SYSTEM                   │
│                                                               │
│  ┌─────────────────────────────────────────────────────┐   │
│  │         Database: user_preferences table            │   │
│  │  - Theme, Display, Accessibility, Locale, etc.     │   │
│  └─────────────────────────────────────────────────────┘   │
│                           ↕                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │         API: /api/user/preferences                   │   │
│  │  - GET, PUT endpoints                                │   │
│  └─────────────────────────────────────────────────────┘   │
│                           ↕                                  │
│  ┌─────────────────────────────────────────────────────┐   │
│  │    Frontend: UserPreferencesContext                 │   │
│  │  - Centralized state management                     │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                            ↕
        ┌───────────────────┼───────────────────┐
        │                   │                     │
        ▼                   ▼                     ▼
```

## Integration Points

### 1. Theme/Color Mode Integration

```
┌─────────────────────────────────────────────────────────────┐
│ Current Implementation                                      │
│                                                             │
│  src/contexts/color-mode.tsx                               │
│  ├─ Uses localStorage only                                 │
│  ├─ Not synced across devices                              │
│  └─ Lost on browser clear                                  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ Updated Implementation                                      │
│                                                             │
│  src/contexts/color-mode.tsx                                │
│  ├─ Loads from user_preferences on mount                   │
│  ├─ Saves to database on change                            │
│  ├─ Falls back to localStorage if DB unavailable          │
│  └─ Syncs across tabs via storage events                   │
│                                                             │
│  Integration Points:                                        │
│  ├─ App initialization (load preferences)                  │
│  ├─ Theme selector in header (save on change)              │
│  ├─ Settings page (theme section)                         │
│  └─ All layout components (apply theme)                   │
└─────────────────────────────────────────────────────────────┘
```

**Components to Update:**
- `src/contexts/color-mode.tsx` - Load/save from database
- `src/components/layout/templates/PublicLayout.tsx` - Theme menu
- `src/components/layout/templates/hooks/useThemeMenu.tsx` - Save on change
- `src/pages/settings/components/ThemeSettings.tsx` - New settings UI

---

### 2. Pagination Integration

```
┌─────────────────────────────────────────────────────────────┐
│ Current Implementation                                      │
│                                                             │
│  src/constants/config.ts                                   │
│  ├─ DEFAULT_PAGE_SIZE: 20 (hardcoded)                      │
│  └─ Used across all tables                                 │
│                                                             │
│  src/hooks/usePagination.ts                                │
│  ├─ initialPageSize: 20 (hardcoded)                        │
│  └─ Used by all table components                           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ Updated Implementation                                      │
│                                                             │
│  src/hooks/usePagination.ts                                │
│  ├─ Reads default_page_size from preferences                │
│  ├─ Falls back to 20 if not set                           │
│  └─ Updates preference when user changes page size         │
│                                                             │
│  Integration Points:                                        │
│  ├─ All table components (books, loans, orders, etc.)     │
│  ├─ Pagination components (BookCatalogPagination, etc.)    │
│  └─ Settings page (default page size selector)            │
└─────────────────────────────────────────────────────────────┘
```

**Components to Update:**
- `src/hooks/usePagination.ts` - Read from preferences
- `src/pages/book-catalog/components/BookCatalogPagination.tsx`
- `src/components/features/loans/components/*` - All loan table components
- `src/pages/orders/OrderList.tsx` - Order list/table component
- `src/pages/books/BookListPage.tsx`
- `src/pages/students/components/StudentTable.tsx`
- `src/components/features/members/components/MemberTable/*`
- All other table/list components

---

### 3. Table Column Visibility Integration

```
┌─────────────────────────────────────────────────────────────┐
│ New Feature                                                  │
│                                                             │
│  User can show/hide table columns                           │
│  Preferences stored as JSON:                                │
│  {                                                          │
│    "books": { "isbn": true, "genre": false },              │
│    "loans": { "due_date": true, "fine": false }            │
│  }                                                          │
│                                                             │
│  Integration Points:                                        │
│  ├─ UnifiedTable component (respect column visibility)     │
│  ├─ Individual table components (apply visibility)         │
│  ├─ Table column selector UI (new component)              │
│  └─ Settings page (column visibility manager)              │
└─────────────────────────────────────────────────────────────┘
```

**Components to Create/Update:**
- `src/components/ui/organisms/tables/UnifiedTable.tsx` - Apply visibility
- `src/components/features/tables/ColumnSelector.tsx` - New component
- `src/pages/settings/components/DataTableSettings.tsx` - Settings UI
- All table components to respect preferences

---

### 4. Dashboard Layout Integration

```
┌─────────────────────────────────────────────────────────────┐
│ Current Implementation                                      │
│                                                             │
│  src/components/features/dashboard/DashboardContainer.tsx  │
│  ├─ Static widget layout                                   │
│  └─ No customization                                       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ Updated Implementation                                      │
│                                                             │
│  Dashboard preferences stored as JSON:                     │
│  {                                                          │
│    "widgets": [                                            │
│      { "id": "stats", "position": {...}, "visible": true }│
│    ]                                                        │
│  }                                                          │
│                                                             │
│  Integration Points:                                        │
│  ├─ DashboardContainer (load layout from preferences)      │
│  ├─ Dashboard widgets (respect visibility)                │
│  ├─ Drag-and-drop layout editor (new component)            │
│  └─ Settings page (dashboard layout editor)               │
└─────────────────────────────────────────────────────────────┘
```

**Components to Create/Update:**
- `src/components/features/dashboard/DashboardContainer.tsx` - Load layout
- `src/components/features/dashboard/DashboardLayoutEditor.tsx` - New component
- `src/pages/settings/components/DashboardSettings.tsx` - Settings UI
- All dashboard widgets to respect preferences

---

### 5. Language/Locale Integration

```
┌─────────────────────────────────────────────────────────────┐
│ New Feature                                                  │
│                                                             │
│  User can select language and date/time formats            │
│                                                             │
│  Integration Points:                                        │
│  ├─ Date formatting utilities (use user format)           │
│  ├─ Time formatting utilities (use user format)            │
│  ├─ Number formatting utilities (use user locale)         │
│  ├─ Language selector in settings                         │
│  └─ All date/time displays (apply format)                  │
└─────────────────────────────────────────────────────────────┘
```

**Components to Create/Update:**
- `src/utilities/formatting/date-formatter.ts` - Use user format
- `src/utilities/formatting/time-formatter.ts` - Use user format
- `src/utilities/formatting/number-formatter.ts` - Use user locale
- `src/pages/settings/components/LocaleSettings.tsx` - Settings UI
- All date/time displays throughout the app

---

### 6. Accessibility Integration

```
┌─────────────────────────────────────────────────────────────┐
│ New Feature                                                  │
│                                                             │
│  Accessibility preferences:                                │
│  - High contrast mode                                       │
│  - Reduced motion                                           │
│  - Screen reader optimizations                              │
│                                                             │
│  Integration Points:                                        │
│  ├─ Theme context (apply high contrast)                    │
│  ├─ CSS animations (respect reduced motion)                │
│  ├─ ARIA attributes (screen reader optimizations)         │
│  └─ Settings page (accessibility section)                 │
└─────────────────────────────────────────────────────────────┘
```

**Components to Create/Update:**
- `src/contexts/color-mode.tsx` - High contrast mode
- `src/index.css` - Reduced motion CSS
- `src/components/**/*.tsx` - ARIA attributes
- `src/pages/settings/components/AccessibilitySettings.tsx` - Settings UI

---

### 7. Settings Page Integration

```
┌─────────────────────────────────────────────────────────────┐
│ New Main Settings Page                                      │
│                                                             │
│  src/pages/settings/index.tsx                              │
│  ├─ Tab 1: General (Theme, Language)                      │
│  ├─ Tab 2: Display (Font, Density, Sidebar)              │
│  ├─ Tab 3: Data Tables (Page size, Columns)               │
│  ├─ Tab 4: Accessibility                                   │
│  ├─ Tab 5: Notifications (link to existing page)           │
│  └─ Tab 6: Security (link to MFA settings)                │
│                                                             │
│  Navigation Integration:                                    │
│  ├─ Profile page → Settings link                           │
│  ├─ User menu → Settings option                            │
│  └─ Route: /settings (or /dashboard-*/settings)           │
└─────────────────────────────────────────────────────────────┘
```

**Components to Create:**
- `src/pages/settings/index.tsx` - Main settings page
- `src/pages/settings/components/ThemeSettings.tsx`
- `src/pages/settings/components/DisplaySettings.tsx`
- `src/pages/settings/components/DataTableSettings.tsx`
- `src/pages/settings/components/AccessibilitySettings.tsx`
- `src/pages/settings/components/LocaleSettings.tsx`

**Components to Update:**
- `src/pages/profile.tsx` - Add Settings link
- `src/components/layout/templates/hooks/useUserMenu.tsx` - Add Settings option
- `src/router/route-definitions.ts` - Add settings route

---

### 8. Notification Preferences (Existing - Keep Separate)

```
┌─────────────────────────────────────────────────────────────┐
│ Existing Implementation (Keep Separate)                     │
│                                                             │
│  Database: user_notification_preferences                    │
│  API: /api/notifications/preferences                        │
│  Component: src/components/features/notifications/         │
│             notification-preferences.tsx                    │
│  Route: /notification-preferences                           │
│                                                             │
│  Integration:                                               │
│  ├─ Link from main settings page                           │
│  └─ Keep separate (different update frequency)             │
└─────────────────────────────────────────────────────────────┘
```

**No changes needed** - Just add navigation link from main settings page.

---

### 9. MFA Settings (Existing - Keep Separate)

```
┌─────────────────────────────────────────────────────────────┐
│ Existing Implementation (Keep Separate)                     │
│                                                             │
│  Database: user_mfa_settings                                │
│  Component: src/pages/mfa-settings.tsx                    │
│  Route: /mfa-settings                                       │
│                                                             │
│  Integration:                                               │
│  ├─ Link from main settings page                           │
│  └─ Keep separate (security-sensitive)                      │
└─────────────────────────────────────────────────────────────┘
```

**No changes needed** - Just add navigation link from main settings page.

---

## Component Dependency Graph

```
UserPreferencesContext
    │
    ├─→ ColorModeContext (theme preferences)
    ├─→ usePagination hook (page size preferences)
    ├─→ Table components (column visibility)
    ├─→ Dashboard components (layout preferences)
    ├─→ Date/Time formatters (locale preferences)
    ├─→ Settings page (all preference UIs)
    └─→ All layout components (apply preferences)
```

---

## Data Flow

```
1. User logs in
   ↓
2. UserPreferencesContext loads preferences from API
   ↓
3. Preferences applied to:
   - Theme (ColorModeContext)
   - Pagination defaults
   - Table column visibility
   - Dashboard layout
   - Date/time formats
   ↓
4. User changes preference in Settings page
   ↓
5. Preference updated via API
   ↓
6. Context updated
   ↓
7. All dependent components re-render with new preferences
   ↓
8. Preference saved to database
   ↓
9. Synced across devices on next login
```

---

## Migration Path

### Phase 1: Theme Migration
1. Create `user_preferences` table
2. Migrate theme from localStorage to database
3. Update `ColorModeContext` to use database
4. Test cross-device sync

### Phase 2: Display Preferences
1. Add display preference fields
2. Create display settings UI
3. Update components to respect preferences
4. Test persistence

### Phase 3: Data Display Preferences
1. Add data display preference fields
2. Update pagination hook
3. Create table column visibility feature
4. Test across all tables

### Phase 4: Advanced Features
1. Add accessibility preferences
2. Add locale preferences
3. Add dashboard layout preferences
4. Comprehensive testing

---

## Testing Checklist

- [ ] Preferences load on login
- [ ] Preferences persist across sessions
- [ ] Preferences sync across devices
- [ ] Theme changes apply immediately
- [ ] Page size changes apply to all tables
- [ ] Column visibility persists
- [ ] Dashboard layout persists
- [ ] Date/time formats apply correctly
- [ ] Accessibility preferences work
- [ ] Settings page navigation works
- [ ] Fallback to defaults if preferences missing
- [ ] Offline support (localStorage fallback)

