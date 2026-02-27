---
title: "POSTMAN GUIDE"
---

# 🧪 Testing with Postman

Complete guide for testing SJRS LMS APIs using Postman.

---

## 📬 Postman Setup

### Step 1: Import Collection and Environment

1. **Download the files**:
   - `docs/api/sjrs-lms-api.postman_collection.json` (Collection)
   - `docs/api/sjrs-lms-staging.postman_environment.json` (Environment)

2. **Import into Postman**:
   - Open Postman → Click **Import** (top left)
   - Select both files (collection + environment)
   - Click **Import**

3. **Select Environment**:
   - In the top-right corner, click the environment dropdown
   - Select: **SJRS LMS - Production**

**Note**: The collection is configured to use `https://your-worker.your-subdomain.workers.dev` (production Workers dev) instead of staging to avoid 403 permission errors. This is the recommended environment for testing.

### Step 2: Configure Credentials

1. **Click the eye icon** (👁️) in the top-right to view environment variables
2. **Update credentials** if needed:
   - `email`: Your registered email (or test user email)
   - `password`: Your actual password (or test user password)

**⚠️ Important**: The email and password must be **real credentials** that exist in your database!

**Test Users** (if database was seeded):
- `admin@yourdomain.com` / `password123` (Admin)
- `librarian@yourdomain.com` / `password123` (Librarian)
- `professor@yourdomain.com` / `password123` (Professor)
- `student@yourdomain.com` / `password123` (Student)

**Or use your own credentials** that you've registered in the system.

---

## 🔐 Authentication Flow

### Step 1: Login to Get Token

1. **Open Postman Console** (View → Show Postman Console) - This helps debug issues
2. Open the collection: **SJRS LMS API** → **Authentication** → **Login**
3. Check the request:
   - **Method**: `POST`
   - **URL**: `{{base_url}}/api/auth/login`
   - **Body** (raw JSON):
   ```json
   {
     "email": "{{email}}",
     "password": "{{password}}"
   }
   ```
4. **Verify environment variables**:
   - Click the **eye icon** (👁️) in the top-right
   - Check that `email` and `password` are set
   - Check that `base_url` is `https://your-worker.your-subdomain.workers.dev`
5. Click **Send**
6. **Check the response**:
   - Status should be **200 OK** for success
   - Response body should have `"success": true` and a `"token"` field
   - Check the Console tab for any error messages
7. The token will be **automatically saved** to your environment!

### Step 2: Verify Token is Saved

1. Click the **eye icon** (👁️) in the top-right
2. Check that `auth_token` shows a value (not empty)
3. If empty:
   - Check the **Console** tab for error messages
   - Check the **Tests** tab in the Login request - it should have auto-save script
   - Look at the response body - the token should be in the `token` field (not nested under `data`)
   - Manually copy the token from the response and paste it into the environment variable

---

## 🧪 Testing Fixed Endpoints

### Test 1: Notifications Bell Context

1. Open: **Notifications** → **Get Bell Context**
2. Check the request:
   - **Method**: `GET`
   - **URL**: `{{base_url}}/api/notifications/bell-context`
   - **Headers**:
     ```
     Authorization: Bearer {{auth_token}}
     Content-Type: application/json
     ```
3. Click **Send**
4. **Expected Response** (200 OK):
   ```json
   {
     "success": true,
     "data": {
       "type": "announcements",
       "label": "Announcements",
       "tooltip": "View announcements",
       "destination": "/dashboard/notifications",
       "unreadCount": 0,
       "totalUnread": 0,
       "breakdown": {
         "announcements": 0,
         "system": 0,
         "app": 0
       }
     }
   }
   ```

### Test 2: Notifications Unread Count

1. Open: **Notifications** → **Get Unread Count**
2. Check the request:
   - **Method**: `GET`
   - **URL**: `{{base_url}}/api/notifications/unread-count?user_id={{user_id}}`
   - **Headers**:
     ```
     Authorization: Bearer {{auth_token}}
     Content-Type: application/json
     ```
3. Click **Send**
4. **Expected Response** (200 OK):
   ```json
   {
     "success": true,
     "data": {
       "count": 0
     }
   }
   ```

### Test 3: Get Users

1. Open: **Users** → **Get All Users**
2. Check the request:
   - **Method**: `GET`
   - **URL**: `{{base_url}}/api/users`
   - **Headers**:
     ```
     Authorization: Bearer {{auth_token}}
     Content-Type: application/json
     ```
3. Click **Send**
4. **Expected Response** (200 OK):
   ```json
   {
     "data": [
       {
         "id": 1,
         "email": "admin@yourdomain.com",
         "first_name": "Admin",
         "last_name": "User",
         ...
       }
     ],
     "total": 10,
     "page": 1,
     "limit": 20,
     "totalPages": 1
   }
   ```

---

## 🔑 Using Your Own Credentials

### Option 1: Use Test Users (If Database Was Seeded)

If your database was set up with seed data, these test users should exist:

| Email | Password | Role |
|-------|----------|------|
| `admin@yourdomain.com` | `password123` | Admin |
| `librarian@yourdomain.com` | `password123` | Librarian |
| `professor@yourdomain.com` | `password123` | Professor |
| `student@yourdomain.com` | `password123` | Student |

### Option 2: Use Your Own Account

1. **Register a new account** (if you don't have one):
   - Use the **Register** endpoint in the Authentication folder
   - Or register through the web interface

2. **Update environment variables**:
   - Click the **eye icon** (👁️) in top-right
   - Change `email` to your registered email
   - Change `password` to your actual password
   - Click **Save**

3. **Test login** to verify credentials work

### Option 3: Check What Users Exist

If you have database access, you can check existing users:

```sql
-- Check existing users
SELECT id, email, first_name, last_name, role_id 
FROM library_users 
ORDER BY id;
```

Then use one of those emails and its corresponding password.

---

## 🚨 Troubleshooting

### Issue: "Unauthorized" (401) Errors - Login Failed

**Possible Causes**:
1. **Wrong email/password** - The credentials don't exist or are incorrect
2. **User doesn't exist** - The email isn't registered in the database
3. **Password mismatch** - The password is incorrect
4. **Account suspended** - User account is suspended
5. **Account locked** - Too many failed login attempts (423 status)

**Solutions**:
1. **Check the response details**:
   - Open Postman Console (View → Show Postman Console)
   - Look at the response body for specific error messages
   - Check the status code (401, 409, 423, 429)

2. **Verify credentials exist**:
   - Try logging in through the web interface: https://your-worker.your-subdomain.workers.dev
   - Or check the database for the user
   
3. **Use correct credentials**:
   - Make sure you're using the exact email (will be converted to lowercase automatically)
   - Make sure password matches exactly
   - Check for typos or extra spaces
   
4. **Check for account issues**:
   - If you get 409: Another session is active - you may need to force logout
   - If you get 423: Account is locked - wait for the lockout period
   - If you get 429: Rate limit exceeded - wait before trying again
   
5. **Register a new user** if needed:
   - Use the Register endpoint in the collection
   - Or register through the web interface
   
6. **Check environment variables**:
   - Click the eye icon (👁️) to view variables
   - Make sure `email` and `password` are set correctly
   - Make sure `base_url` is `https://your-worker.your-subdomain.workers.dev`

### Issue: "Unauthorized" (401) Errors - Token Issues

**Solution**:
1. Make sure you've run the Login request first
2. Check that `auth_token` is set in your environment (eye icon)
3. Verify the token format: `Bearer {{auth_token}}`
4. Token might have expired - login again

### Issue: "Forbidden" (403) Errors

**Possible Causes**:
1. **Wrong environment URL** - Staging might have different permission settings
2. **User lacks permissions** - Your user doesn't have the required permissions
3. **CORS issues** - Origin not allowed

**Solutions**:
1. **Use production URL**: Make sure you're using `https://your-worker.your-subdomain.workers.dev` (not staging)
   - Check the `base_url` variable in your environment
   - Should be: `https://your-worker.your-subdomain.workers.dev`
   
2. **Check user permissions**:
   - Try logging in as an admin user
   - Verify the user has `notifications:read` permission
   - Check that your user account exists and is active
   
3. **Verify environment is selected**: Make sure "SJRS LMS - Production" is selected in the top-right dropdown

### Issue: "Internal Server Error" (500)

**Solution**:
1. Check the response body for error details
2. Verify the endpoint URL is correct
3. Check that all required parameters are provided
4. Try the endpoint with a different user

### Issue: Variables Not Working

**Solution**:
- Use `{{variable_name}}` syntax (double curly braces)
- Make sure environment is selected in top-right dropdown
- Check variable name spelling (case-sensitive)
- Click the eye icon to verify variable values

### Issue: Token Not Auto-Saving

**Solution**:
- Make sure the Test script is in the Login request
- Check the response structure matches the script
- Look at the Console (View → Show Postman Console) for errors
- Manually copy token from response and update environment variable

---

## 📊 Testing Checklist

### Pre-Testing Setup
- [ ] Collection imported
- [ ] Environment imported and selected
- [ ] Credentials configured (email/password)
- [ ] Login request working
- [ ] Token saved in environment
- [ ] Base URL is correct

### Notifications Endpoints
- [ ] Bell Context returns 200 OK
- [ ] Bell Context returns valid JSON structure
- [ ] Unread Count returns 200 OK
- [ ] Unread Count returns valid count
- [ ] No 500 errors

### Users Endpoint
- [ ] Get Users returns 200 OK
- [ ] Get Users returns valid user list
- [ ] Pagination works correctly
- [ ] No 500 errors

### Error Handling
- [ ] Invalid token returns 401
- [ ] Missing auth returns 401
- [ ] Invalid user_id returns appropriate error
- [ ] Missing permissions returns 403

---

## 🎯 Quick Test Workflow

1. **Select environment**: `SJRS LMS - Production` (top-right)
2. **Run Login**: **Authentication** → **Login** → **Send**
3. **Verify token saved**: Click eye icon, check `auth_token` has value
4. **Test Notifications**: **Notifications** → **Get Bell Context** → **Send** ✅
5. **Test Unread Count**: **Notifications** → **Get Unread Count** → **Send** ✅
6. **Test Users**: **Users** → **Get All Users** → **Send** ✅

---

## 📚 Additional Resources

- [API Documentation](../api/)
- [API Quick Start Guide](../api/quick-start-guide.md)

---

**Last Updated**: November 2025  
**Maintained By**: Development Team

