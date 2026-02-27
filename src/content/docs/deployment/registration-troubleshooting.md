---
title: "Registration Troubleshooting"
---

## Registration Troubleshooting Playbook

**Last updated:** November 2025  
**Audience:** On-call engineers & support staff  
**Related components:** `functions/api/auth/registration.ts`, `functions/middleware/security/turnstile-validation.ts`, `src/pages/register.tsx`

---

### 1. Summary
- Registration now **fails closed** whenever Cloudflare Turnstile is not configured or the user fails CAPTCHA verification.
- Three independent **rate-limit guards** protect abuse scenarios: per email, per IP, and a composite email+IP key. Each returns explicit error codes surfaced in the UI.
- This document provides the checks, remediation steps, and user messaging guidance when the registration flow is blocked.

---

### 2. CAPTCHA Configuration Requirement

| Condition | System Behaviour | API Error Code | Frontend Behaviour | Recovery Steps |
|-----------|------------------|----------------|--------------------|----------------|
| `TURNSTILE_SECRET_KEY` missing in Workers environment | Registration is rejected before reaching database | `TURNSTILE_NOT_CONFIGURED` | Registration form is disabled with “CAPTCHA verification is required…” messaging | 1. Set the secret via `wrangler secret put TURNSTILE_SECRET_KEY` (value from Cloudflare Turnstile dashboard).<br>2. Redeploy with `npm run release`.<br>3. Confirm the CAPTCHA widget renders on `/register`. |
| Invalid/expired CAPTCHA token | Verification fails against Cloudflare API | `TURNSTILE_VERIFICATION_FAILED`, `TURNSTILE_TOKEN_EXPIRED`, or underlying Turnstile codes | User asked to complete CAPTCHA again; widget auto-resets | Advise user to refresh and complete CAPTCHA, ensuring third-party scripts are allowed. |

**Operational checklist:**
1. Confirm `TURNSTILE_SECRET_KEY` is present in production namespace (`wrangler secret list`).  
2. Verify the Turnstile site key (`VITE_TURNSTILE_SITE_KEY`) is available to the frontend build.  
3. If end users report constant failures, validate the domain configuration inside the Turnstile dashboard (hostname must match the deployed site).  
4. Review Worker logs for `[Turnstile]` warnings or errors to differentiate configuration vs end-user issues.

---

### 3. Registration Rate Limits

| Guard | Config Key | Limit | API Error Code | UI Messaging | Typical Root Cause | Recommended Action |
|-------|------------|-------|----------------|--------------|--------------------|--------------------|
| Per email address | `RATE_LIMIT_CONFIGS.REGISTRATION_EMAIL` | 5 attempts / hour | `REGISTRATION_EMAIL_RATE_LIMIT` | “Too many registration attempts with this email…” including human-readable retry duration | User repeatedly submitting same email (typos, impatience) | Encourage user to wait for the provided time window, then retry. Verify email confirmation not already pending. |
| Per IP address | `RATE_LIMIT_CONFIGS.REGISTRATION_IP` | 10 attempts / 15 minutes | `REGISTRATION_IP_RATE_LIMIT` | “Too many registration attempts from this network…” | Shared networks (labs, cafes) or scripted attacks | If legitimate, manually clear the rate limit via KV (`rate_limit_registration_ip:<ip>`). Otherwise monitor for abuse. |
| Composite email+IP | `RATE_LIMIT_CONFIGS.REGISTRATION` | 3 attempts / 15 minutes | `REGISTRATION_RATE_LIMIT` | Generic attempt limit messaging with retry countdown | Combination of rapid submissions and field validation errors | Ensure user fixes validation errors before retrying; advise waiting the indicated time. |

**KV management tips:**
- Keys live in the Workers KV namespace defined in `KV_CONFIG`. Use the Cloudflare dashboard or Wrangler KV commands to inspect/delete (`wrangler kv:key get ...`, `wrangler kv:key delete ...`).  
- Always document manual overrides in the on-call log (include key deleted, reason, and requester).  
- Repeated IP/email hits should be considered for additional security measures (e.g., temporary firewall rule or support escalation).

---

### 4. User Communication Templates

- **CAPTCHA missing:**  
  “Our security verification service is temporarily unavailable. We’re working on a fix—please try again later or contact support.”

- **CAPTCHA failure (single user):**  
  “Please refresh the page, allow the CAPTCHA widget to load, and complete the verification before submitting the form.”

- **Rate limit hit (email/IP):**  
  Use the UI-provided duration: “You’ve reached the maximum number of sign-up attempts. Please wait _X minutes and Y seconds_ before trying again.”

- **Profile completion reminder:**  
  Direct users to `/resend-confirmation` for the guided experience (includes steps and support links).

---

### 5. Escalation Path
1. Confirm environment variables and KV entries via Wrangler or dashboard.  
2. Capture relevant logs (`wrangler tail` or Workers dashboard) showing Turnstile or rate-limit errors.  
3. If the issue persists after secret refresh or KV reset, escalate to the platform engineering contact (Neil Jay – Cloudflare Community MVP ID 034f8d9858b6355750fb13d6dcaa8796).  
4. Update this document with any new remediation steps discovered during incidents.

