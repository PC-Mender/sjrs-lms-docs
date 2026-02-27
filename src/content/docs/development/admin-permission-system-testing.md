---
title: "Admin Permission System Testing"
---

# Admin Permission System Testing

## Overview
This document outlines how to test the admin permission system to ensure it properly respects superuser permission grants and doesn't automatically bypass permission checks.

## Key Changes Made

### 1. **Backend Permission Middleware**
- **File**: `functions/middleware/permissions/has-permission.ts`
- **Change**: Removed automatic admin bypass
- **Before**: Admin and Superuser automatically got access to everything
- **After**: Only Superuser gets automatic access, Admin must have explicit permissions

### 2. **Frontend Permission Hook**
- **File**: `src/hooks/usePermissions.ts`
- **Change**: Replaced hardcoded permissions with database API calls
- **Before**: Used static `ROLE_PERMISSIONS` object
- **After**: Calls `/api/permissions/check` endpoint to get real permissions

### 3. **New Permission Check API**
- **File**: `functions/api/permissions/handlers/check-permissions.ts`
- **Endpoint**: `GET /api/permissions/check`
- **Purpose**: Check user permissions against database

### 4. **Admin Dashboard Warning**
- **File**: `src/pages/dashboard-admin.tsx`
- **Feature**: Shows warning when admin lacks permissions
- **Action**: Links to superuser permission management

## Testing Scenarios

### Scenario 1: Fresh Admin Account (No Permissions)
1. **Setup**: Create admin user with no database permissions
2. **Expected Behavior**: 
   - Dashboard shows permission warning
   - Quick actions are filtered out
   - Navigation buttons respect permissions
3. **Test Steps**:
   ```sql
   -- Ensure admin role exists but has no permissions
   INSERT INTO roles (name, description, hierarchy_level) 
   VALUES ('Admin', 'Administrator role', 5);
   
   -- Don't insert any role_permissions records
   ```

### Scenario 2: Admin with Limited Permissions
1. **Setup**: Grant admin only 'read' access to 'users' resource
2. **Expected Behavior**:
   - Can view user management
   - Cannot create/update/delete users
   - Other features are hidden
3. **Test Steps**:
   ```sql
   -- Grant limited permissions
   INSERT INTO role_permissions (role_id, resource_id, action_id, is_granted)
   SELECT r.id, pr.id, pa.id, 1
   FROM roles r, permission_resources pr, permission_actions pa
   WHERE r.name = 'Admin' 
     AND pr.resource_name = 'users' 
     AND pa.action_name = 'read';
   ```

### Scenario 3: Admin with Full User Management
1. **Setup**: Grant admin full CRUD access to users
2. **Expected Behavior**:
   - Full user management access
   - Can create, read, update, delete users
   - Other system features still restricted
3. **Test Steps**:
   ```sql
   -- Grant full user permissions
   INSERT INTO role_permissions (role_id, resource_id, action_id, is_granted)
   SELECT r.id, pr.id, pa.id, 1
   FROM roles r, permission_resources pr, permission_actions pa
   WHERE r.name = 'Admin' 
     AND pr.resource_name = 'users' 
     AND pa.action_name IN ('read', 'create', 'update', 'delete');
   ```

### Scenario 4: Superuser Permission Management
1. **Setup**: Superuser manages admin permissions
2. **Expected Behavior**:
   - Superuser can grant/revoke admin permissions
   - Changes take effect immediately
   - Admin dashboard updates accordingly
3. **Test Steps**:
   - Login as superuser
   - Navigate to `/dashboard-superuser/permissions`
   - Modify admin role permissions
   - Verify changes in admin dashboard

## API Testing

### Test Permission Check Endpoint
```bash
# Check specific permission
curl "https://your-domain.com/api/permissions/check?role=Admin&resource=users&action=read"

# Get all permissions for role
curl "https://your-domain.com/api/permissions/check?role=Admin&resources=all"
```

### Expected Responses
```json
// Specific permission check
{
  "success": true,
  "data": {
    "hasPermission": true
  }
}

// All permissions for role
{
  "success": true,
  "data": {
    "permissions": {
      "users": ["read", "create", "update"],
      "books": ["read"]
    }
  }
}
```

## Frontend Testing

### Test Permission Filtering
1. **Login as admin with no permissions**
2. **Verify**:
   - Permission warning appears
   - Quick actions are empty
   - Navigation is restricted

### Test Permission Granting
1. **Login as superuser**
2. **Grant admin permissions**:
   - Navigate to permission management
   - Grant admin access to users resource
3. **Login as admin**
4. **Verify**:
   - Warning disappears
   - User management actions appear
   - Navigation works for granted resources

## Security Verification

### 1. **No Automatic Admin Bypass**
- Admin users must have explicit permissions
- Backend middleware checks database permissions
- No hardcoded permission grants

### 2. **Superuser Control**
- Only superusers can modify permissions
- Permission changes are audited
- Changes take effect immediately

### 3. **Frontend Validation**
- UI respects backend permissions
- No client-side permission bypass
- Graceful degradation when permissions denied

## Troubleshooting

### Common Issues

#### 1. **Admin Dashboard Shows No Actions**
- **Cause**: Admin has no permissions granted
- **Solution**: Superuser must grant permissions via permission management

#### 2. **Permission Changes Not Reflecting**
- **Cause**: Frontend cache or backend cache
- **Solution**: 
  - Clear browser cache
  - Check backend permission cache
  - Use `/api/permission_cache_clear` endpoint

#### 3. **API Permission Check Fails**
- **Cause**: Database permission tables not set up
- **Solution**: Ensure permission_resources and permission_actions tables exist

### Debug Commands
```sql
-- Check admin role permissions
SELECT r.name as role, pr.resource_name, pa.action_name, rp.is_granted
FROM roles r
JOIN role_permissions rp ON r.id = rp.role_id
JOIN permission_resources pr ON pr.id = rp.resource_id
JOIN permission_actions pa ON pa.id = rp.action_id
WHERE r.name = 'Admin';

-- Check if permission tables exist
SELECT name FROM sqlite_master WHERE type='table' AND name LIKE '%permission%';
```

## Conclusion

The admin permission system now properly respects superuser permission grants:
- ✅ **No automatic admin bypass**
- ✅ **Database-driven permissions**
- ✅ **Real-time permission checking**
- ✅ **Superuser control over admin access**
- ✅ **Frontend permission validation**
- ✅ **Graceful permission degradation**

This ensures that admin users can only access features that superusers have explicitly granted them permission to use.
