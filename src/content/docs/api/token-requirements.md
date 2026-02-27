---
title: "Token Requirements"
---

# API Token Requirements Documentation

## Overview

The SJRS Library Management System requires several types of API tokens and authentication mechanisms to function properly. This document outlines all token requirements and their usage throughout the application.

## 1. JWT Authentication Tokens

### Purpose
JWT (JSON Web Tokens) are used for user authentication and session management across the application.

### Implementation
- **Location**: `functions/middleware/auth/tokens/jwt.ts`
- **Algorithm**: HMAC-SHA256 using WebCrypto
- **Encoding**: base64url for header, payload, and signature
- **Claims enforced**: `iss`, `aud`, `iat`, `nbf` (optional), `exp`, `jti`
- **Key rotation**: Supported via `JWT_KEYS_JSON` and `JWT_DEFAULT_KID`
- **Storage**: Use `tokenManager` from `src/utilities/auth/token-manager.ts` (secure storage)
- **⚠️ Important**: Do NOT use `localStorage` directly. Always use `tokenManager` methods.
- **Header Format**: `Authorization: Bearer <token>` (automatically handled by `unifiedAPIClient`)

### Usage Examples
```typescript
// ⚠️ IMPORTANT: Always use tokenManager, never localStorage directly
import { tokenManager } from '@/utilities/auth/token-manager';

// Client-side token storage (uses secure storage)
await tokenManager.setToken(token, 'cookie');

// Get token (from secure storage)
const token = await tokenManager.getToken('cookie');

// API requests with token (automatically handled by unifiedAPIClient)
// No manual header needed - unifiedAPIClient adds Authorization header automatically
import { unifiedAPIClient } from '@/utilities/api/unified-api-client';
const response = await unifiedAPIClient.get('/api/users');

// Server-side verification
const user = await validateUserToken(token, env); // returns user or null
```

### Environment Variables
You can use a single secret or a rotation map.

Single-secret (legacy, still supported):
```bash
JWT_SECRET=your-secure-jwt-secret-key
```

Rotation-ready (recommended):
```bash
# JSON map of kid -> secret
JWT_KEYS_JSON={"key-2025-01":"super-secret-1","key-2025-07":"super-secret-2"}
# Which kid to use when signing new tokens
JWT_DEFAULT_KID=key-2025-01
# Optional issuer and audience checks
JWT_ISS=your-jwt-issuer
JWT_AUD=https://your-worker.your-subdomain.workers.dev
```

## 2. CSRF Protection Tokens

### Purpose
Cross-Site Request Forgery (CSRF) tokens protect against unauthorized form submissions and API calls.

### Implementation
- **Location**: `src/utilities/security/csrf-protection.ts`
- **Token Generation**: Cryptographically secure random tokens
- **Expiration**: 30 minutes
- **Storage**: Secure memory storage with cookie backup
- **Automatic Header Injection**: CSRF token is automatically added to all requests via request interceptor in `src/utilities/api/unified-api-client.ts` (lines 735-743)

### Configuration
```typescript
const CSRF_CONFIG = {
  TOKEN: {
    length: 32,
    alphabet: 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
    expiryMinutes: 30,
  },
  COOKIE: {
    name: 'XSRF-TOKEN',
    path: '/',
    secure: true,
    sameSite: 'strict'
  }
};
```

### Usage Examples
```typescript
// Import CSRF protection utilities
import { csrfProtection, addCSRFToHeaders, getCSRFToken } from '@/utilities/security/csrf-protection';

// Generate CSRF token (usually done automatically on app initialization)
const csrfToken = await csrfProtection.createToken();

// Get current token (creates if doesn't exist)
const token = await getCSRFToken();

// Validate token in requests (client-side validation)
const validation = await csrfProtection.validateToken(headerToken);

// Manually add to headers (usually not needed - handled automatically by unifiedAPIClient)
const headers = await addCSRFToHeaders({ 'Content-Type': 'application/json' });
// Result: { 'Content-Type': 'application/json', 'X-XSRF-TOKEN': '<token>' }

// Note: CSRF token is automatically added to all API requests via
// request interceptor in src/utilities/api/unified-api-client.ts
```

## 3. Email Service API Keys

### Purpose
API keys for Mailjet email service to send account-related and transactional emails.

### Architecture
Our email system uses a **hybrid approach**:
- **Account emails** (registration, password reset): Direct Mailjet API calls
- **Transactional emails** (loans, notifications): Cloudflare Queues with Mailjet backend

### Implementation
- **Direct Mailjet**: `functions/middleware/auth/index.ts` (account emails)
- **Queue + Mailjet**: `functions/email-templates/index.ts` (transactional emails)

### Configuration

#### **Direct Mailjet (Account Emails)**
```typescript
// Registration confirmation email
const emailData = {
  Messages: [{
    From: {
      Email: env.MAILJET_FROM_EMAIL || "noreply@yourdomain.com",
      Name: "SJRS Library Management System"
    },
    To: [{ Email: email, Name: firstName }],
    Subject: "Confirm Your Email Address - SJRS LMS",
    TextPart: `Hello ${firstName},\n\nPlease confirm your email...`,
    HTMLPart: `<div><h2>Welcome to SJRS LMS!</h2>...</div>`
  }]
};

const response = await fetch('https://api.mailjet.com/v3.1/send', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Basic ${btoa(`${env.MAILJET_API_KEY}:${env.MAILJET_API_SECRET}`)}`
  },
  body: JSON.stringify(emailData)
});
```

#### **Queue + Mailjet (Transactional Emails)**
```typescript
// Send to queue
await env.EMAIL_QUEUE.send({
  type: 'borrow_notification',
  data: {
    userId: user.id,
    email: user.email,
    name: user.first_name,
    bookTitle: book.title,
    dueDate: dueDate
  }
});

// Queue processor sends via Mailjet
async sendEmailViaMailjet(to: string, content: { subject: string; body: string; html?: string }, env: any) {
  const emailData = {
    Messages: [{
      From: { Email: env.MAILJET_FROM_EMAIL, Name: "SJRS Library Management System" },
      To: [{ Email: to, Name: to.split('@')[0] }],
      Subject: content.subject,
      TextPart: content.body,
      HTMLPart: content.html
    }]
  };

  const response = await fetch('https://api.mailjet.com/v3.1/send', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Basic ${btoa(`${env.MAILJET_API_KEY}:${env.MAILJET_API_SECRET}`)}`
    },
    body: JSON.stringify(emailData)
  });
}
```

### Environment Variables Required
```bash
# Mailjet Configuration (for both direct and queue)
MAILJET_API_KEY=your_mailjet_api_key
MAILJET_API_SECRET=your_mailjet_api_secret
MAILJET_FROM_EMAIL=noreply@yourdomain.com

# Frontend URL
FRONTEND_URL=https://your-worker.your-subdomain.workers.dev
```

### Email Service Strategy

#### **📧 Account-Related Emails (Direct Mailjet)**
- **Registration confirmation**
- **Password reset**
- **Email verification**
- **Account status changes**

#### **📧 Transactional Emails (Queue + Mailjet)**
- **Loan notifications** (`borrow_notification`)
- **Return reminders** (`return_reminder`)
- **Overdue notices** (`overdue_notification`)
- **System notifications** (`system_notification`)
- **Order status updates** (`order_notification`)

### Benefits of This Approach

#### **✅ Direct Mailjet Benefits**
- **Immediate feedback** for critical account emails
- **Simple implementation** for low-volume emails
- **No queue complexity** for account flows

#### **✅ Queue + Mailjet Benefits**
- **Reliability** with automatic retries
- **Scalability** for high-volume transactional emails
- **Non-blocking** user experience
- **Background processing** for notifications

### Usage Examples

#### **Account Email (Direct)**
```typescript
// Registration confirmation
if (env.MAILJET_API_KEY && env.MAILJET_API_SECRET) {
  await sendConfirmationEmail(user.email, user.first_name, confirmationToken, env);
}
```

#### **Transactional Email (Queue)**
```typescript
// Loan notification
await sendLoanNotification('borrow_notification', {
  userId: user.id,
  userEmail: user.email,
  userName: user.first_name,
  bookTitle: book.title,
  dueDate: dueDate
});
```

### Error Handling

#### **Direct Mailjet Error Handling**
```typescript
try {
  await sendConfirmationEmail(email, name, token, env);
} catch (error) {
  console.error('Failed to send confirmation email:', error);
  // Don't break registration flow
}
```

#### **Queue Error Handling (Automatic)**
```typescript
async queue(batch: MessageBatch<EmailQueueMessage>, env: any) {
  for (const message of batch.messages) {
    try {
      await this.processEmailMessage(message.body, env);
      message.ack();
    } catch (error) {
      if (message.body.retries < 3) {
        message.retry(); // Automatic retry
      } else {
        message.ack(); // Move to dead letter queue
      }
    }
  }
}
```

## 4. Cloudflare API Tokens

### Purpose
Used for deployment automation and Cloudflare Workers management.

### Implementation
- **Location**: `.github/workflows/release.yml`
- **Usage**: GitHub Actions deployment pipeline
- **Scope**: Cloudflare Workers and D1 database management

### Configuration
```yaml
# GitHub Actions workflow
- name: Deploy to Cloudflare Workers
  uses: cloudflare/wrangler-action@v3
  with:
    apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
    accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
    command: deploy
```

### Environment Variables Required
```bash
CLOUDFLARE_API_TOKEN=your-cloudflare-api-token
CLOUDFLARE_ACCOUNT_ID=your-cloudflare-account-id
```

## 5. API Client Authentication

### Purpose
Secure API client for making authenticated requests to the backend.

### Implementation
- **Location**: `src/utilities/client/d1-api.ts`
- **Base URL**: Remote API endpoint (even in development)
- **Token Management**: Automatic token inclusion in requests

### Configuration
```typescript
// API base URL configuration
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 
  'https://your-worker.your-subdomain.workers.dev';

// Token management (use tokenManager instead)
import { tokenManager } from '@/utilities/auth/token-manager';

// Set token (uses secure storage)
await tokenManager.setToken(token, 'cookie');

// Clear token
await tokenManager.clearAuth();

// Automatic token inclusion (handled by unifiedAPIClient)
// No manual header needed - unifiedAPIClient automatically adds Authorization header
import { unifiedAPIClient } from '@/utilities/api/unified-api-client';
const response = await unifiedAPIClient.get('/api/users');
```

### Environment Variables Required
```bash
VITE_API_BASE_URL=https://your-worker.your-subdomain.workers.dev
```

## 6. Secure API Client

### Purpose
Enhanced API client with CSRF protection and security headers.

### Implementation
- **Location**: `src/utilities/api-client.ts`
- **Features**: CSRF protection, retry logic, error handling
- **Security**: Automatic security header inclusion

### Usage Examples
```typescript
// Secure API client instance
const apiClient = SecureAPIClient.getInstance();

// Making authenticated requests
const response = await apiClient.request({
  method: 'POST',
  url: '/api/books',
  data: bookData,
  headers: customHeaders
});

// Helper functions
const result = await securePost('/api/books', bookData);
```

## 7. Session Management

### Purpose
Manage user sessions and token lifecycle.

### Implementation
- **Location**: `src/utilities/session-manager.ts`
- **Features**: Token validation, session persistence, automatic logout

### Token Validation Process
```typescript
// ⚠️ IMPORTANT: Always use tokenManager, never localStorage directly
import { tokenManager } from '@/utilities/auth/token-manager';

// Check token validity
const token = await tokenManager.getToken('cookie');
if (token) {
  // D1 uses JWT tokens that are stateless
  // We just need to ensure the token is still valid
  const isValid = await validateToken(token);
  if (!isValid) {
    await tokenManager.clearAuth();
    // Redirect to login
  }
}
```

## Security Best Practices

### 1. Token Storage
- **⚠️ Always use `tokenManager`** from `src/utilities/auth/token-manager.ts` for token storage
- Never use `localStorage` directly - it's deprecated and less secure
- `tokenManager` uses secure storage (cookies with HttpOnly when possible)
- Implement token rotation for long-lived sessions

### 2. Token Validation
- Always validate tokens on the server side
- Check token expiration before processing requests
- Implement proper error handling for invalid tokens

### 3. Environment Variables
- Never commit API keys to version control
- Use environment variables for all sensitive configuration
- Implement proper secret management in production

### 4. CSRF Protection
- Include CSRF tokens in all state-changing requests
- Validate tokens on the server side
- Use secure token generation methods

## Required Environment Variables Summary

```bash
# JWT Authentication
JWT_SECRET=your-secure-jwt-secret-key

# Email Service
EMAIL_API_KEY=your-email-service-api-key
FROM_EMAIL=noreply@yourdomain.com

# Cloudflare Deployment
CLOUDFLARE_API_TOKEN=your-cloudflare-api-token
CLOUDFLARE_ACCOUNT_ID=your-cloudflare-account-id

# API Configuration
VITE_API_BASE_URL=https://your-worker.your-subdomain.workers.dev
```

## Development Setup

1. **Set up environment variables** in your development environment
2. **Configure email service** with appropriate API keys
3. **Set up Cloudflare tokens** for deployment
4. **Test token functionality** in development environment

## Production Deployment

1. **Configure all environment variables** in Cloudflare Workers
2. **Set up proper secret management** for production
3. **Enable CSRF protection** for all forms and API endpoints
4. **Monitor token usage** and implement proper logging

## Troubleshooting

### Common Issues
1. **401 Unauthorized**: Check JWT token validity and expiration
2. **CSRF Token Mismatch**: Ensure tokens are properly generated and validated
3. **Email Delivery Failures**: Verify email service API key and configuration
4. **Deployment Failures**: Check Cloudflare API token permissions

### Debug Steps
1. Check browser console for token-related errors
2. Verify environment variables are properly set
3. Test API endpoints with proper authentication headers
4. Monitor server logs for authentication failures

## Related Documentation

- [Authentication System Guide](./development/ENHANCED_PERMISSION_SYSTEM.md)
- [Security Documentation](./security/README.md)
- [Deployment Guide](./deployment/D1_SETUP_GUIDE.md)
- [Permission System Guide](./PERMISSION_SYSTEM_GUIDE.md) 