---
title: "Auth Flow"
---

# Authentication & Routing Stability

This document captures the finalized login flow, route-guard behavior, and supporting infrastructure. It serves as the reference for future changes and must remain consistent unless a defect is found.

## Overview
- Token is stored using secure storage via `tokenManager` (from `src/utilities/auth/token-manager.ts`).
- ⚠️ **Never use `localStorage` directly** - always use `tokenManager.getToken()`, `tokenManager.setToken()`, or `tokenManager.clearAuth()`.
- Auth state hydrates on navigation. If a token exists but `isAuthenticated` is false, the guard triggers `refreshToken()` to hydrate the user.
- Public routes auto-redirect authenticated users to their role dashboard.
- Protected routes delegate access decisions to `AuthGuard` only (no duplicate checks in the protected route wrapper).

## Token & Cookie Policy
- Cookie attributes:
  - `Path=/`
  - `SameSite=Strict`
  - `Secure` only on HTTPS; omitted on `http://localhost` to allow dev.
- Cookies are prefixed with `secure_` and stored/read consistently.

## Hydration & Guard Logic
- On every protected navigation:
  1. If no token, redirect to `/login` with loop protection.
  2. If a token exists but `isAuthenticated` is false, call `refreshToken()` to hydrate.
  3. When `userDataLoaded` is true and `user` is present, evaluate role/status gates.
- Status gates:
  - Non‑superusers: `inactive` → `/inactive`.
  - Non‑superusers: `mfa_enabled && !mfa_setup` → `/mfa-setup`.
  - Superusers: bypass `inactive` gating.

## Role-Based Routing
- Public routes (`/`, `/home`, `/login`, `/register`, `/forgot-password`, `/reset-password`, `/email-confirmation`, `/resend-confirmation`) redirect authenticated users to role dashboards:
  - `superuser` → `/dashboard-superuser`
  - `admin` → `/dashboard-admin`
  - `librarian` → `/dashboard-librarian`
  - `dean` → `/dashboard-dean`
  - others → `/dashboard-user`
- Protected routes: handled exclusively by `AuthGuard` after hydration.

## Sentry (Dev & Prod)
- Dev: event sending gated unless `VITE_SENTRY_DEBUG=true`.
- Sanitization: event `extra` and breadcrumb `data` are sanitized via `safeStringify` to avoid circular references.
- Release set from `VITE_APP_VERSION` to prevent session discard warnings.

## Testing & Verification
- With a valid token in cookies, navigating directly to `/dashboard` should load and route to the correct dashboard without manual refresh.
- Visiting public routes while authenticated should immediately redirect to the role dashboard.
- Superusers should not be routed to `/inactive`.

## Change Control
- Do not alter this flow unless a defect is confirmed.
- Any proposed changes must:
  - Preserve hydration-first logic.
  - Keep status/MFA gates and superuser bypass intact.
  - Maintain public-route authenticated redirects.
  - Keep Sentry dev gating and sanitization in place.