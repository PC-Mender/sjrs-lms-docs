---
title: "Registration Flow"
---

# 📝 Registration Flow Guide

This guide explains the complete registration workflow for SJRS LMS, including account creation, email confirmation, admin approval, and how roles are assigned.

## 🔄 Overview

- New accounts start with `status = "pending"`, `email_verified = false`, and `onboarding_status = "pending_email_confirmation"`.
- After email confirmation, accounts remain `pending` until a superuser/admin approves them.
- `role_id` is assigned using the `user_type_role_mapping` table; if no mapping exists, `role_id` stays `NULL` until admin assignment.
- Users can check their status via OTP-based public endpoints.

## ✅ Step 1: Register

**Endpoint:** `POST /api/auth/register` (public)

**Request Body:**
```json
{
  "email": "newuser@example.com",
  "password": "securepassword123",
  "firstName": "Jane",
  "lastName": "Smith",
  "userType": "Student",
  "phone": "+1234567890",
  "stream": "CSE",
  "turnstileToken": "<optional-captcha-token>"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Registration received. If this email is associated with an account, you will receive further instructions shortly.",
  "data": { "pending": true }
}
```

Notes:
- The response is enumeration-safe and does not reveal account existence.
- Accounts are created with `status = "pending"` and `email_verified = false`.
- `role_id` is determined by `user_type_role_mapping`; if no mapping, `role_id = NULL`.

## ✉️ Step 2: Confirm Email

**Endpoint:** `POST /api/auth/confirm-email` (public, from email link)

After confirmation, `email_verified = true`, but the account remains `pending` until admin approval.

## 👤 Step 3: Check Status (Optional)

Public OTP-based status check endpoints:
- `POST /api/auth/check-status/send-otp` – sends OTP to the registered email.
- `POST /api/auth/check-status/verify` – verifies OTP and returns workflow status.

Workflow statuses:
- `pending_email_confirmation` – email not yet verified.
- `profile_incomplete` – email verified, but profile details are not completed yet.
- `pending_approval` – email verified and profile completed, awaiting admin approval.
- `complete` – onboarding finished, account fully activated.
- `active` / `inactive` / `suspended` – terminal account states.

> 📘 **Detailed Reference**: See [Onboarding Status System](/features/onboarding-status) for complete workflow documentation, admin management, and troubleshooting.

Note:
- The canonical persisted onboarding field is `onboarding_status`.
- Some responses also include `workflowStatus` / `workflow_status` for compatibility.

## 🛡️ Step 4: Admin Approval

Admins approve and assign/override roles using the user management endpoint:
- `PUT /api/users/:id` – set `status = "active"` and optionally set/override `role_id`.

Recommended process:
- Approve after verifying profile completeness and institutional eligibility.
- Assign appropriate `role_id` based on `user_type` or override as needed.

## 👀 View Current Profile

**Endpoint:** `GET /api/auth/me` (authenticated)

Returns user details including `role`, `status`, `email_verified`, and `workflowStatus`.

Example response:
```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "user": {
    "id": 123,
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "role": "Student",
    "status": "pending",
    "user_type": "Student",
    "phone": "+1234567890",
    "stream": "CSE",
    "email_verified": false,
    "onboarding_status": "pending_email_confirmation",
    "workflowStatus": "pending_email_confirmation"
  }
}
```

## 🔐 Security & UX Considerations

- Registration is rate-limited and uses CAPTCHA when enabled.
- Responses are standardized and enumeration-safe.
- Pending users cannot access privileged features until admin approval.
- Superusers have full access to manage roles and approvals.

---

**Last Updated:** January 2025  
**Version:** 1.0.0