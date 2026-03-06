---
title: "Error Mapping"
---

# Frontend Error Mapping Guide

This guide standardizes how frontend components interpret backend errors and map them to inline form validation. It ensures consistent UX across registration, login, profile, and future forms, and helps prevent regressions.

## Goals

- Provide a single source of truth for error mapping patterns
- Keep payload and casing conventions consistent with the remote D1 backend
- Encourage field-level validation messages instead of generic alerts
- Define testing and rollout checklists for changes to error codes

## Backend Error Contract

Where possible, backend endpoints should return structured error details:

```json
{
  "success": false,
  "message": "Human-friendly message",
  "error": {
    "code": "MACHINE_READABLE_CODE",
    "codeNo": 1000,
    "details": "Detailed message",
    "fields": { "email": ["Email is required"] }
  },
  "status": 400,
  "timestamp": "2025-01-01T00:00:00Z",
  "requestId": "req_..."
}
```

- `code`: The canonical identifier for the error (stable across releases)
- `codeNo`: Numeric code aligned to `ERROR_CODE_NO` (analytics/dashboards/logs)
- `field`: The camelCase name of the invalid field (if applicable)

## Frontend Contract

Frontend auth context and helpers should surface backend `code` and `field` so UI can map them:

- `register(userData)` returns `{ success, error?, field?, code? }`
- `login(email, password)` returns `{ success, error?, requiresForceLogout?, field?, code? }`
- Profile update handlers read `field` and `code` from response body

UI components should use Ant Design `Form.setFields([{ name, errors }])` to render inline messages when `field` is provided; otherwise show a friendly global message via `Alert` or `message.error`.

### Display Behavior
- Field-specific errors: inline below inputs via `Form.setFields`; persist until resolved.
- Global transient errors: toasts via `antd` `message.error(text, duration)` (default ~3s; components may override).
- Global persistent errors: banners via `Alert` or dedicated pages (e.g., account suspended); persist until navigated away or state changes.

## Casing & Payload Conventions

- Request payload keys to backend: camelCase
  - Registration: `email`, `password`, `firstName`, `lastName`, `userType`
  - Login: `email`, `password`
  - Profile update: snake_case accepted in existing endpoint; keep consistent with surrounding usage; future endpoints should prefer camelCase and normalize server-side
- Enum-like fields (e.g., `userType`) should be lowercase on submit: `student`, `professor`, `guest`

## Common Error Codes and Mappings

Use these codes in backend responses and map them in the UI:

- Registration
  - `EMAIL_ALREADY_EXISTS` → field: `email` → "Email address is already registered"
  - `INVALID_EMAIL_FORMAT` → field: `email` → "Please enter a valid email address"
  - `PASSWORD_TOO_SHORT` → field: `password` → "Password must be at least 8 characters long"

- Login
  - `INVALID_CREDENTIALS` → field: `password` → "Invalid email or password."
  - `EMAIL_NOT_CONFIRMED` → global message → "Please verify your email before logging in."
  - `ACCOUNT_LOCKED` → global message → "Account temporarily locked due to failed attempts."
  - `RATE_LIMIT_EXCEEDED` → global message → "Too many attempts. Try again later."
  - `SESSION_CONFLICT` (optional) → global message → "Session conflict. Try force logout of other sessions."

- Profile Update
  - `INVALID_PHONE` → field: `phone` → "Please enter a valid phone number"
  - `INVALID_STREAM` → field: `stream` → "Please enter a valid stream"
  - `NAME_TOO_SHORT` → field: `firstName`/`lastName` → "Name must be at least 2 characters"
  - `NAME_INVALID` → field: `firstName`/`lastName` → "Only letters, spaces, apostrophes, and hyphens allowed"

When adding a new code:
- Use uppercase `SNAKE_CASE`
- Keep message short and precise
- Include `field` when the error is field-specific

## Component Patterns

### Registration (`src/pages/register.tsx`)

- Convert form values to camelCase when calling `register()`
- Normalize `userType` to lowercase
- Map `{ field, code }` to `Form.setFields`
- Fall back to a global `Alert` if no `field` is provided

### Login (`src/pages/login.tsx`)

- Use `code` and `field` to set inline errors
- Treat `requiresForceLogout` as a special flow with a prompt
- Keep global messages for email confirmation and rate limit

### Profile Update (`src/pages/profile.tsx`)

- Map `{ field, code }` to inline errors for `first_name`, `last_name`, `phone`, `stream`, `status`
- Keep friendly global messages for non-field errors

### Profile Completion (`src/pages/profile-completion.tsx`)

- Normalize `user_type` to lowercase before submit
- Use lowercase comparisons (`student`, `professor`) for conditional fields

## Testing & Regression Prevention

Before merging changes to error handling:

- Unit tests
  - Verify mapping of codes to messages per component
  - Test `Form.setFields` invocation when `field` present
- Integration/E2E tests (recommended)
  - Registration with existing email → inline email error
  - Login with wrong password → inline password error
  - Login with unconfirmed email → global message
  - Profile with invalid phone → inline error
- Manual checklist
  - Confirm payload casing is correct (camelCase)
  - Confirm enum casing is lowercase on submit
  - Validate global vs inline error behavior

## Change Management

- When adding/modifying error codes:
  - Update backend handlers to include `code`/`field`
  - Update frontend mapping tables (registration, login, profile)
  - Add/update tests for new codes
- Document changes here. Run `npm run docs:generate:error-codes` to regenerate `docs/api/error-codes-reference.md` from the shared map.

## References

- Auth context: `src/contexts/auth-context-d1.tsx`
- Registration page: `src/pages/register.tsx`
- Login page: `src/pages/login.tsx`
- Profile page: `src/pages/profile.tsx`
- Profile completion: `src/pages/profile-completion.tsx`
