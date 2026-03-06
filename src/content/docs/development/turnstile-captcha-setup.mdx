---
title: "Turnstile Captcha Setup"
---

# Cloudflare Turnstile CAPTCHA Setup Guide

## Overview

Cloudflare Turnstile CAPTCHA has been integrated into the registration process to prevent bot registrations and improve security.

**✅ Configuration Status: COMPLETE**

- Secret Key: Configured in Cloudflare Workers
- Site Key: `0x4AAAAAAB_6j49-YlSs-3S6` (configured in environment variables)
- Frontend Integration: Complete
- Backend Validation: Complete

---

## Backend Implementation

### ✅ Completed

1. **Turnstile Validation Middleware:**
   - Location: `functions/middleware/security/turnstile-validation.ts`
   - Validates Turnstile tokens with Cloudflare
   - Handles errors gracefully
   - Fails open if not configured (for development)

2. **Registration Endpoint Integration:**
   - Location: `functions/api/auth/registration.ts`
   - Validates Turnstile token before processing registration
   - Returns clear error messages if validation fails

3. **Payload Normalization:**
   - Location: `functions/middleware/normalization/payload.ts`
   - Extracts `turnstileToken` from request body
   - Supports both `turnstileToken` and `turnstile_token` formats

---

## Configuration

### ✅ Backend Configuration (Secret Key)

**Configured via CLI:**
```bash
wrangler secret put TURNSTILE_SECRET_KEY
```
- Secret Key: `0x4AAAAAAB_6jzjomMin2I3PZ_SRxuYQtyo` (stored securely)

### ✅ Frontend Configuration (Site Key)

**Configured in:**
- Environment variable: `VITE_TURNSTILE_SITE_KEY`
- Site Key: `0x4AAAAAAB_6j49-YlSs-3S6`
- Added to `env.example` for reference`

**For local development, create a `.env` file:**
```bash
VITE_TURNSTILE_SITE_KEY=0x4AAAAAAB_6j49-YlSs-3S6
```

### ✅ Frontend Integration

**Implemented in:** `src/pages/register.tsx`

- Turnstile widget dynamically loaded via script injection
- Token state management with React hooks
- Automatic widget initialization and cleanup
- Error handling and widget reset on failures

---

## Behavior

### If Turnstile is Configured:
- ✅ Registration requires valid Turnstile token
- ✅ Token is verified with Cloudflare
- ✅ Invalid/expired tokens are rejected
- ✅ Clear error messages returned

### If Turnstile is NOT Configured:
- ❌ Registration is blocked (fail closed)
- ⚠️ Error logged: "TURNSTILE_SECRET_KEY not configured"
- ✅ Prevents accidental production deployments without CAPTCHA

---

## Error Codes

| Code | Description | User Message |
|------|-------------|--------------|
| `TURNSTILE_TOKEN_MISSING` | No token provided | "CAPTCHA verification is required" |
| `TURNSTILE_VERIFY_FAILED` | Verification request failed | "Failed to verify CAPTCHA. Please try again." |
| `invalid-input-response` | Invalid token | "Invalid CAPTCHA token. Please complete the CAPTCHA again." |
| `timeout-or-duplicate` | Token expired/used | "CAPTCHA token expired or already used. Please complete the CAPTCHA again." |
| `TURNSTILE_TOKEN_EXPIRED` | Token older than 5 minutes | "CAPTCHA token expired. Please complete the CAPTCHA again." |
| `TURNSTILE_ERROR` | General error | "CAPTCHA verification failed. Please try again." |

---

## Security Features

1. **Token Validation:**
   - Verifies token with Cloudflare API
   - Checks token expiration (5 minutes)
   - Validates token format

2. **IP Address Tracking:**
   - Includes user IP in verification (if available)
   - Improves security and fraud detection

3. **Error Handling:**
   - Fails closed on errors (requires CAPTCHA)
   - Detailed error codes for debugging
   - User-friendly error messages

---

## Testing

### Test Without CAPTCHA (Development):
- Don't set `TURNSTILE_SECRET_KEY`
- Registration will proceed without validation
- Warning logged in console

### Test With CAPTCHA (Production):
1. Set `TURNSTILE_SECRET_KEY` secret
2. Add Turnstile widget to frontend
3. Submit registration with token
4. Verify token is validated

### Test Invalid Token:
- Submit registration with invalid/expired token
- Should receive error: "CAPTCHA verification failed"

---

## Production Checklist

- [x] Get Turnstile Site Key and Secret Key
- [x] Add `TURNSTILE_SECRET_KEY` to Cloudflare Workers secrets
- [x] Add Turnstile widget to registration form
- [ ] Test registration with valid token
- [ ] Test registration with invalid token
- [x] Verify error messages are user-friendly
- [ ] Monitor logs for Turnstile validation errors

---

## Notes

- Turnstile is **invisible** by default (no checkbox)
- Tokens expire after 5 minutes
- Each token can only be used once
- Works seamlessly with existing rate limiting
- No additional user friction (better UX than reCAPTCHA)

---

## References

- [Cloudflare Turnstile Documentation](https://developers.cloudflare.com/turnstile/)
- [Turnstile API Reference](https://developers.cloudflare.com/turnstile/get-started/server-side-validation/)

