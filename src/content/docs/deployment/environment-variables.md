---
title: "Environment Variables"
---

# Environment Variables Configuration

## Overview

This project uses Cloudflare Workers for deployment, and environment variables are managed through Cloudflare's Workers settings rather than local `.env` files.

## 🔧 Configuration Locations

### Cloudflare Workers Dashboard
- **Secrets**: Sensitive data like API keys, database credentials
- **Environment Variables**: Non-sensitive configuration values
- **KV Bindings**: Key-value storage bindings
- **D1 Bindings**: Database bindings

### Local Development
- **Not Required**: Environment variables are not needed locally for development
- **wrangler.toml**: Contains some public configuration (non-sensitive)
- **Local Testing**: Use `wrangler dev` to simulate the Workers environment

## 📋 Required Environment Variables

### Database Configuration
```
D1_DATABASE_ID=your-d1-database-id
D1_DATABASE_NAME=your-database-name
```

### Authentication & Security
```
JWT_SECRET=your-jwt-secret-key
ENCRYPTION_KEY=your-encryption-key
SESSION_SECRET=your-session-secret
```

### Email Service (Optional)
```
EMAIL_SERVICE_API_KEY=your-email-api-key
EMAIL_FROM_ADDRESS=noreply@yourdomain.com
```

### SMS Service (Optional)
```
SMS_API_KEY=your-sms-api-key
SMS_SENDER_ID=your-sender-id
```

## 🚀 Setup Instructions

### 1. Cloudflare Workers Dashboard
1. Navigate to your Workers & Pages dashboard
2. Select your worker
3. Go to **Settings** → **Variables**
4. Add environment variables and secrets as needed

### 2. Using Wrangler CLI
```bash
# Set secrets (sensitive data)
wrangler secret put JWT_SECRET
wrangler secret put ENCRYPTION_KEY

# Set environment variables (non-sensitive)
wrangler env put ENVIRONMENT production
```

### 3. Local Development
```bash
# Start local development server
wrangler dev

# The local server will automatically use your configured variables
```

## 🔍 Verification

### Check Current Variables
```bash
# List all secrets
wrangler secret list

# List environment variables
wrangler env list
```

### Quality Gates Integration
The quality gates system (`scripts/enhanced-quality-gates.js`) validates environment variables by:
- Checking `wrangler secret list` for required secrets
- Validating D1 database connectivity
- Ensuring all required bindings are configured

## ⚠️ Important Notes

1. **No Local .env Required**: Unlike traditional Node.js applications, this project doesn't require local environment files
2. **Secrets vs Variables**: Use secrets for sensitive data, environment variables for public configuration
3. **Development vs Production**: Use different Workers for different environments
4. **Quality Gates**: Environment validation is part of the automated quality gates process

## 🔗 Related Documentation

- [Cloudflare Workers Environment Variables](https://developers.cloudflare.com/workers/configuration/environment-variables/)
- [Wrangler CLI Documentation](https://developers.cloudflare.com/workers/wrangler/)
- [Quality Gates Guide](../quality-gates-guide.md)