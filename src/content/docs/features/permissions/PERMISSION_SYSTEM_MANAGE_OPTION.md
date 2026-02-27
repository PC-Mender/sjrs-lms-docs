---
title: "PERMISSION SYSTEM MANAGE OPTION"
---

# Retired `manage` Permission

## Summary

The legacy `manage` action has been removed from the unified permission system. All CRUD capabilities must now be granted explicitly (`create`, `read`, `update`, `delete`). This change eliminates hidden escalation paths, keeps backend middleware simpler, and makes the permission matrix reflect exactly what is granted in the database.

## Why It Was Removed

- **Redundant with bulk updates** – the bulk permission tools already allow superusers to assign all four CRUD permissions in a single operation.
- **Hard to audit** – downstream code needed special-case logic (extra cache lookups, branching in middleware, custom validation) to translate `manage` into four distinct actions.
- **Inconsistent documentation** – keeping `manage` meant explaining two overlapping models (granular vs. shortcut). Removing it aligns the UI, API, and docs.

## Migration Impact

1. **Database**  
   - Existing grants of `manage` are converted to the four CRUD actions.  
   - Audit log entries referencing `manage` are remapped to `update` for historical continuity.  
   - The `permission_actions` entry for `manage` is deleted.

2. **Backend**  
   - Middleware and API handlers now rely solely on the explicit actions.  
   - Permission checks no longer attempt a fallback to `manage`.  
   - Bulk update and role-permission handlers no longer special-case the action.

3. **Frontend**  
   - UI components and hooks reference the explicit CRUD actions only.  
   - Superusers continue to grant full access by toggling or staging the four actions together.

## Granting Full CRUD Access Now

Use the bulk permission workflow (or staged changes in the permission matrix) to toggle:

- `resource:create`
- `resource:read`
- `resource:update`
- `resource:delete`

This approach keeps the permission set explicit and audit-friendly while still offering a one-pass granting experience.

## Action Items

- Ensure any saved role templates or documentation remove references to `manage`.  
- When reviewing permissions, confirm that roles needing full CRUD access have all four explicit actions granted.  
- Update runbooks or training materials to describe the bulk grant workflow instead of the retired shortcut.

