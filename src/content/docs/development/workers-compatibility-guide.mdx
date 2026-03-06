---
title: "Workers Compatibility Guide"
---

# Cloudflare Workers Compatibility Guide

## Overview

This guide outlines best practices for maintaining Cloudflare Workers compatibility in the SJRSLMS application, particularly for code in the `functions/` directory.

## Recent Changes

### Process Environment Variables

**Problem**: Direct usage of `process.env` in email templates and API handlers caused Workers compatibility warnings.

**Solution**: Replace `process.env` with the Cloudflare Workers `env` parameter.

#### Before:
```typescript
// ❌ Not compatible with Cloudflare Workers
const url = `${process.env.FRONTEND_URL}/dashboard`;
```

#### After:
```typescript
// ✅ Compatible with Cloudflare Workers
const frontendUrl = env.FRONTEND_URL || 'https://default-url.com';
const url = `${frontendUrl}/dashboard`;
```

### Email Template Updates

All email templates now accept a `frontendUrl` parameter instead of directly accessing `process.env.FRONTEND_URL`:

```typescript
interface TemplateData {
  frontendUrl?: string;
  // ... other properties
}

function generateTemplate(data: TemplateData) {
  const frontendUrl = data.frontendUrl || 'https://default-url.com';
  // Use frontendUrl in template
}
```

## Best Practices

### 1. Environment Variables
- **Use**: `env.VARIABLE_NAME` in API handlers
- **Avoid**: `process.env.VARIABLE_NAME`
- **Pass**: Environment variables as parameters to utility functions

### 2. File System Operations
- **Use**: Web APIs like `fetch()` for HTTP requests
- **Avoid**: Node.js `fs` module
- **Alternative**: Use Cloudflare's APIs for file operations

### 3. Path Operations
- **Use**: Standard JavaScript string methods (`startsWith()`, `includes()`, etc.)
- **Avoid**: Node.js `path` module methods (`path.join()`, `path.resolve()`)
- **Note**: Simple string operations are fine and Workers-compatible

### 4. Module System
- **Use**: ES6 imports/exports (`import`/`export`)
- **Avoid**: CommonJS (`require()`, `module.exports`)

### 5. Global Variables
- **Avoid**: Node.js globals like `__dirname`, `__filename`, `Buffer`
- **Use**: Web standard APIs when available

## Quality Gates Integration

The enhanced quality gates now perform more specific validation:

- ✅ Detects actual Node.js API usage with regex patterns
- ✅ Provides line numbers for easier debugging
- ✅ Avoids false positives for standard JavaScript methods
- ✅ Includes helpful tips for remediation

## Testing Workers Compatibility

Run the quality gates to check for compatibility issues:

```bash
npm run quality-gates
```

Phase 5 (Infrastructure Validation) will report any Workers compatibility warnings.

## Common Patterns

### API Handler Pattern
```typescript
export async function handleRequest(request: Request, env: Environment): Promise<Response> {
  // Access environment variables through env parameter
  const frontendUrl = env.FRONTEND_URL || 'https://default.com';
  
  // Pass environment data to utilities
  const result = await someUtility({ frontendUrl, ...otherData });
  
  return new Response(JSON.stringify(result));
}
```

### Email Template Pattern
```typescript
interface EmailData {
  frontendUrl?: string;
  // ... other properties
}

export function generateEmailTemplate(data: EmailData): string {
  const frontendUrl = data.frontendUrl || 'https://default.com';
  
  return `
    <a href="${frontendUrl}/dashboard">Dashboard</a>
  `;
}
```

## Migration Checklist

When adding new code to the `functions/` directory:

- [ ] Use `env` parameter instead of `process.env`
- [ ] Use ES6 modules instead of CommonJS
- [ ] Avoid Node.js-specific APIs
- [ ] Test with quality gates
- [ ] Pass environment variables as parameters to utilities

## Troubleshooting

If you encounter Workers compatibility warnings:

1. Check the specific file and line number in the quality gates output
2. Replace Node.js APIs with Web standard alternatives
3. Pass environment variables through function parameters
4. Re-run quality gates to verify fixes

For questions or issues, refer to the [Cloudflare Workers documentation](https://developers.cloudflare.com/workers/).