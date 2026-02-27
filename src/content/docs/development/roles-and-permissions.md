---
title: "Roles And Permissions"
---

# Roles and Permissions

## Overview

This is the unified reference for roles and permissions, aligned with the latest backend `functions/` structure.

- Roles are dynamic (stored in D1) with hierarchy and display metadata
- Permissions are enforced via the permissions API and middleware
- Legacy permission endpoints are preserved and routed to the new API

## Backend APIs (functions/)

- Roles API: `functions/api/roles/index.ts`
  - GET `/api/roles` – list roles
  - PUT `/api/roles/:id` – update role
  - DELETE `/api/roles/:id` – delete role

- Permissions API: `functions/api/permissions/index.ts`
  - POST `/api/permissions/*` – unified permissions operations
  - Legacy routes mapped internally (see Legacy Compatibility)

## Legacy Compatibility

These legacy endpoints are supported and internally routed to `/api/permissions`:

- `POST /api/role_permissions`
- `POST /api/permission_resources`
- `POST /api/permission_actions`
- `POST /api/permission_audit_log`
- `POST /api/update_role_permission`

## Dynamic Role System (Database-Driven)

- Table fields: `id`, `name`, `description`, `display_name`, `hierarchy_level`, timestamps
- Hierarchical checks allow inheritance (e.g., superuser ≥ admin ≥ librarian)
- Updates are immediate without deployments

Example hierarchy:
```
Level 6: Superuser
Level 5: Admin
Level 4: Librarian
Level 3: Dean
Level 2: Professor
Level 1: Student
Level 0: Guest
```

## Frontend Usage (brief)

- Exact role matching for routing (dashboard redirects)
- Hierarchical checks for permissions (feature access)
- Typical hooks: `useRoles()`, `hasRoleAccess(userRole, requiredRole)`

## Security Notes

- Only Superusers can manage roles
- Changes are audited (action logs)
- Permission checks at API layer (middleware) and UI

## 🔐 RBAC Policy: Backend is Single Source of Truth

**The backend permissions endpoint (`/api/permissions/check`) is the single source of truth for all permission decisions.**

- **Backend Authority**: All permission checks must ultimately be validated by the backend `/api/permissions/check` endpoint
- **Client Fallbacks**: Client-side permission checks are for UI optimization only and **deny by default** when backend validation is unavailable
- **Security First**: Never trust client-side permission checks alone - always validate on the backend
- **Fail-Safe Design**: If the backend endpoint is unreachable or returns an error, the client should deny access

### Implementation Guidelines

```typescript
// ✅ Correct: Backend is authoritative
const hasPermission = await checkPermission(resource, action);
if (!hasPermission) {
  // Deny access - backend said no
  return;
}

// ❌ Incorrect: Client-only check
if (clientSidePermissionCheck(resource, action)) {
  // This is unsafe - backend must validate
  performAction();
}

// ✅ Correct: Client check with backend validation
const clientCheck = clientSidePermissionCheck(resource, action);
if (clientCheck) {
  // Optimistic UI update, but backend validates
  const backendCheck = await checkPermission(resource, action);
  if (!backendCheck) {
    // Backend denied - revert UI and show error
    return;
  }
  performAction();
}
```

## Related

- Permissions middleware: `functions/middleware/permissions/*`
- Auth middleware: `functions/middleware/auth/*`
- Action logs: `functions/api/action-logs/index.ts`
