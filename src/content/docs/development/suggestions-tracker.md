---
title: "Suggestions Tracker"
---

# Suggestions Tracker

A living record of improvements discussed, what’s implemented, and what’s next. Use this to prioritize and keep a clear history.

## Implemented
- Login UX fixes: clear field errors on input; success state on valid entries
- AuthGuard: superusers bypass account-status gating to avoid flicker/redirects
- CSP updates: allow `blob:` scripts; add GA domain to `connect-src`; add specific inline hash
- Vendor chunking: conservative split for React/AntD to avoid load-order runtime errors
- Roles query gating: `useRoles` waits for `isAuthenticated && token` to prevent 401 flicker
- Standardized API responses: auth profile uses `createSuccessResponse`/`createErrorResponse` with codes and fields
- Payload normalization: registration accepts camelCase and snake_case
- Password reset (admin + token): implemented hashing and DB update

## In Progress / Planned
- Superuser Tools drawer: permission cache clear, session termination, resend confirmation, health checks
- Logging hardening: avoid circular references; sanitize large objects in logs
- Sentry CSP: add ingestion domain if DSN is enabled; consider env‑gated enabling
- Admin feature lazy‑loading: defer heavy routes; add skeletons for data‑heavy tables
- Permission matrix UI: show effective permissions; inline audit trail (action logs)

## Notes
- CSP: if inline scripts change, update their hash or move to external files
- Sessions: backend enforces single active session; force‑logout flow resolves 409 conflicts
- Performance: review chunk warnings for dynamic+static imports; maintain conservative split to preserve stability