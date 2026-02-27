---
title: "D1 Batch Operations Guide"
---

# Cloudflare D1 Batch Operations Guide

## Overview

Cloudflare D1 supports **batch operations** which allow you to execute multiple SQL statements in a single request. This is useful for:
- **Atomic transactions**: All operations succeed or all fail
- **Performance**: Fewer round trips to the database
- **Data consistency**: Ensures related updates happen together

---

## How D1 Batch Operations Work

### Basic Syntax

```typescript
// D1 batch operations use the .batch() method
const results = await env.DB.batch([
  env.DB.prepare('UPDATE library_users SET phone = ? WHERE id = ?').bind(phone, userId),
  env.DB.prepare('INSERT INTO students (user_id, registration_number) VALUES (?, ?)').bind(userId, regNum)
]);
```

### Key Features

1. **Atomic Execution**: All statements in the batch execute together
2. **Sequential Processing**: Statements execute in order
3. **Error Handling**: If any statement fails, the entire batch fails
4. **Return Values**: Returns an array of results, one per statement

---

## Example: Profile Update with Batch Operations

### Current Implementation (Sequential)

```typescript
// functions/middleware/auth/users/profile-update.ts
export async function updateUserProfileWithTypeData(
  data: ProfileUpdateData,
  env: Environment
): Promise<void> {
  // Update main user profile
  await updateUserProfile(user_id, user_type, phone || null, env);

  // Update type-specific information (separate queries)
  if (user_type === 'Student' && registration_number && year_of_study) {
    await updateStudentProfile(user_id, registration_number, year_of_study, env);
  } else if (user_type === 'Professor' && stream) {
    await updateProfessorProfile(user_id, stream, env);
  } else if (user_type === 'Guest' && about && city && state && country) {
    await updateGuestProfile(user_id, about, city, state, country, env);
  }
}
```

**Issues:**
- Multiple database round trips
- Not atomic (if second query fails, first one already succeeded)
- Potential data inconsistency

### Improved Implementation (Batch)

```typescript
export async function updateUserProfileWithTypeData(
  data: ProfileUpdateData,
  env: Environment
): Promise<void> {
  const { user_id, user_type, phone, stream, registration_number, year_of_study, about, city, state, country } = data;

  // Format phone number if provided
  let formattedPhone = phone;
  if (phone) {
    const phoneValidation = validatePhoneNumber(phone, 'IN');
    if (phoneValidation.valid && phoneValidation.formatted) {
      formattedPhone = phoneValidation.formatted;
    }
  }

  // Prepare batch statements
  const statements: D1PreparedStatement[] = [];

  // Always update main user profile
  statements.push(
    env.DB.prepare(`
      UPDATE library_users 
      SET phone = ?, user_type = ?, 
          status = 'pending', updated_at = datetime('now')
      WHERE id = ?
    `).bind(formattedPhone, user_type, user_id)
  );

  // Add type-specific update based on user type
  if (user_type === 'Student' && registration_number && year_of_study) {
    // Check for existing student record
    const existingStudent = await env.DB.prepare(`
      SELECT id FROM students WHERE user_id = ?
    `).bind(user_id).first();

    if (existingStudent) {
      statements.push(
        env.DB.prepare(`
          UPDATE students 
          SET registration_number = ?, year_of_study = ?, updated_at = datetime('now')
          WHERE user_id = ?
        `).bind(registration_number, year_of_study, user_id)
      );
    } else {
      statements.push(
        env.DB.prepare(`
          INSERT INTO students (user_id, registration_number, year_of_study, created_at, updated_at)
          VALUES (?, ?, ?, datetime('now'), datetime('now'))
        `).bind(user_id, registration_number, year_of_study)
      );
    }
  } else if (user_type === 'Professor' && stream) {
    statements.push(
      env.DB.prepare(`
        INSERT INTO professors (user_id, stream, created_at, updated_at)
        VALUES (?, ?, datetime('now'), datetime('now'))
        ON CONFLICT(user_id) DO UPDATE SET
          stream = excluded.stream,
          updated_at = datetime('now')
      `).bind(user_id, stream)
    );
  } else if (user_type === 'Guest' && about && city && state && country) {
    statements.push(
      env.DB.prepare(`
        INSERT INTO guests (user_id, about, city, state, country, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, datetime('now'), datetime('now'))
        ON CONFLICT(user_id) DO UPDATE SET
          about = excluded.about,
          city = excluded.city,
          state = excluded.state,
          country = excluded.country,
          updated_at = datetime('now')
      `).bind(user_id, about, city, state, country)
    );
  }

  // Execute all statements atomically
  await env.DB.batch(statements);
}
```

**Benefits:**
- ✅ **Atomic**: All updates succeed or all fail
- ✅ **Performance**: Single round trip to database
- ✅ **Consistency**: No partial updates

---

## When to Use Batch Operations

### ✅ Use Batch Operations For:

1. **Related Updates**: When updating multiple related tables
   ```typescript
   // Update user and their profile together
   await env.DB.batch([
     env.DB.prepare('UPDATE users SET name = ? WHERE id = ?').bind(name, id),
     env.DB.prepare('UPDATE profiles SET bio = ? WHERE user_id = ?').bind(bio, id)
   ]);
   ```

2. **Transaction-like Behavior**: When you need all-or-nothing updates
   ```typescript
   // Transfer credits between accounts
   await env.DB.batch([
     env.DB.prepare('UPDATE accounts SET balance = balance - ? WHERE id = ?').bind(amount, fromId),
     env.DB.prepare('UPDATE accounts SET balance = balance + ? WHERE id = ?').bind(amount, toId)
   ]);
   ```

3. **Performance Optimization**: When you have multiple sequential queries
   ```typescript
   // Instead of 3 separate queries, use 1 batch
   await env.DB.batch([
     query1,
     query2,
     query3
   ]);
   ```

### ❌ Don't Use Batch Operations For:

1. **Independent Operations**: When operations don't need to be atomic
   ```typescript
   // These are independent - no need for batch
   await updateUser(userId);
   await logActivity(activityId);
   ```

2. **Conditional Logic**: When you need results from one query to decide the next
   ```typescript
   // Need result from first query
   const user = await env.DB.prepare('SELECT * FROM users WHERE id = ?').bind(id).first();
   if (user.status === 'active') {
     await env.DB.prepare('UPDATE ...').bind(...).run();
   }
   ```

---

## Error Handling

```typescript
try {
  const results = await env.DB.batch([
    env.DB.prepare('UPDATE ...').bind(...),
    env.DB.prepare('INSERT ...').bind(...)
  ]);
  
  // All statements succeeded
  console.log('Batch executed successfully');
} catch (error) {
  // If any statement fails, entire batch fails
  // All changes are rolled back
  console.error('Batch operation failed:', error);
  throw error;
}
```

---

## Limitations

1. **No True Transactions**: D1 doesn't support full ACID transactions like PostgreSQL
2. **Read Operations**: Batch is mainly for write operations (INSERT, UPDATE, DELETE)
3. **Size Limits**: Very large batches may have performance implications

---

## Best Practices

1. **Keep Batches Small**: Don't batch hundreds of statements
2. **Use for Related Operations**: Only batch operations that need to be atomic
3. **Handle Errors Properly**: Always wrap batch operations in try-catch
4. **Test Thoroughly**: Ensure batch operations work correctly in all scenarios

---

## Migration Example for Profile Updates

### Current Code (Sequential)
```typescript
await updateUserProfile(user_id, user_type, phone, env);
await updateStudentProfile(user_id, registration_number, year_of_study, env);
```

### Migrated Code (Batch)
```typescript
await env.DB.batch([
  env.DB.prepare('UPDATE library_users ...').bind(...),
  env.DB.prepare('INSERT INTO students ...').bind(...)
]);
```

---

## References

- [Cloudflare D1 Documentation](https://developers.cloudflare.com/d1/)
- [D1 Batch API](https://developers.cloudflare.com/d1/platform/client-api/#batch)

