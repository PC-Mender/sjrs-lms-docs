# Security Audit Report - sjrs-lms-docs Repository

**Date**: February 28, 2026  
**Repository**: https://github.com/PC-Mender/sjrs-lms-docs  
**Visibility**: PUBLIC ⚠️

---

## Executive Summary

**CRITICAL SECURITY ISSUES FOUND**: 🔴

This documentation repository contains **hardcoded credentials in a public GitHub repository**, representing a **CRITICAL security vulnerability**. Additionally, there are moderate-severity package vulnerabilities that require attention.

---

## Critical Issues

### 1. **CRITICAL: Hardcoded Credentials in Public Repository** 🔴

**Location**: `src/content/docs/api/sjrs-lms-staging.postman_environment.json`

**Issue**: This file contains plaintext credentials that are committed to a public GitHub repository:

```json
{
  "key": "auth_token",
  "value": "",
  "type": "secret",
  "enabled": true
},
{
  "key": "password",
  "value": "password123",
  "type": "secret",
  "enabled": true
}
```

**Sensitive Data Exposed**:
- ✗ Email: `admin@yourdomain.com` (test/admin account identifier)
- ✗ Password: `password123` (plaintext test password)
- ✗ User ID: `5` (test user identifier)
- ✗ Production URL: `https://your-worker.your-subdomain.workers.dev`

**Risk Level**: **CRITICAL**

**Impact**:
- Anyone with access to this public repository can use these credentials to access the system
- Potential unauthorized access to the production/staging environment
- Account takeover risk
- Data breach potential

**Remediation**:
1. **IMMEDIATE**: 
   - Remove the file from the repository history using `git filter-branch` or similar tool
   - Invalidate the `admin@yourdomain.com` account or change its password immediately
   - Rotate any API keys or tokens that may have been exposed
   - Audit recent login activity for suspicious access

2. **Long-term**:
   - Store Postman environments in `.gitignore` or use Postman Workspaces for credential management
   - Use environment variables or Postman Vault for sensitive data
   - Add pre-commit hooks to prevent credential commits

**Recommended Action**: Contact GitHub to purge the file from all history, then reset any exposed credentials.

---

## High Priority Issues

### 2. **Leakage of Environment Variable Examples**

**Location**: `src/content/docs/api/token-quick-reference.md`

**Issue**: While the file contains placeholders and example documentation (which is acceptable), it documents the exact structure of environment variables that would be needed to compromise the system:

```bash
JWT_SECRET=your-secure-jwt-secret-key
JWT_KEYS_JSON={"key-2025-01":"super-secret-1","key-2025-07":"super-secret-2"}
MAILJET_API_KEY=your_mailjet_api_key
MAILJET_API_SECRET=your_mailjet_api_secret
CLOUDFLARE_API_TOKEN=your-cloudflare-api-token
CLOUDFLARE_ACCOUNT_ID=your-cloudflare-account-id
```

**Risk Level**: **MEDIUM**

**Impact**: While these are placeholders, they reveal the exact environment variable names and structure that an attacker would need to target

**Remediation**:
- Keep this as reference documentation (this is appropriate for documentation)
- Ensure no actual values are ever included
- Add warning headers to sensitive documentation sections

---

## Moderate Priority Issues

### 3. **npm Dependency Vulnerabilities**

**Issue**: Prototype Pollution vulnerability in `lodash` package

```
lodash  4.0.0 - 4.17.21
Severity: moderate
Lodash has Prototype Pollution Vulnerability in `_.unset` and `_.omit` functions
- https://github.com/advisories/GHSA-xxjr-mmjv-4gpg
Affected chain: @astrojs/check → @astrojs/language-server → volar-service-yaml → yaml-language-server → lodash
```

**Risk Level**: **MEDIUM**

**Impact**: Potential prototype pollution attacks through dependent packages

**Remediation**:
```bash
npm audit fix --force
```

**Note**: This requires updating `@astrojs/check` to v0.9.2, which is documented as a breaking change.

---

## Low Priority Issues

### 4. **Minor Configuration Observations**

#### 4a. No .env file in .gitignore

**Location**: `.gitignore`

**Current content**:
```
node_modules/
dist/
.astro/
.env
.DS_Store
```

**Status**: ✓ CORRECT - `.env` is properly ignored

---

## Configuration & Architecture Review

### ✓ Positive Findings

1. **robots.txt Configuration**: Correctly set to `Disallow: /` with `noindex, nofollow` meta tags
   - Prevents SEO indexing of documentation (appropriate for a docs site)

2. **GitHub Actions Security**:
   - Properly uses `secrets.GITHUB_TOKEN` instead of hardcoded credentials
   - Minimal permissions needed (only `contents: write`)
   - No exposed secrets in workflow definitions

3. **Astro Configuration**:
   - No hardcoded credentials in `astro.config.mjs`
   - Proper separation of concerns
   - React integration properly configured

4. **.gitignore Coverage**:
   - Correctly ignores sensitive directories
   - `.env` files properly excluded

5. **Version Control**:
   - Uses Conventional Commits with standard-version
   - Clean release automation

---

## Package Dependencies Analysis

### Included Packages

```json
{
  "@astrojs/check": "^0.9.3",
  "@astrojs/react": "^4.0.0",
  "@astrojs/starlight": "^0.30.0",
  "astro": "^5.0.0",
  "react": "^18.3.1",
  "react-dom": "^18.3.1",
  "typescript": "^5.5.3",
  "standard-version": "^9.5.0"
}
```

**Observation**: Uses `^` versioning (caret ranges), which allows major version updates. Per project policy, strict versioning is preferred.

**Risk Level**: **LOW** - This is a documentation repo, lower risk than production code

**Recommendation**: Consider using `~` or strict versioning for critical packages to match project policy

---

## Secrets Management Check

### Files Checked for Sensitive Data

- ✓ `astro.config.mjs` - No secrets
- ✓ `.versionrc` - No secrets  
- ✓ `package.json` - No secrets
- ✓ `.env.example` - Not found (none exists, which is fine)
- ✓ GitHub Workflows - Proper secret usage via `${{ secrets.GITHUB_TOKEN }}`
- ✗ `sjrs-lms-staging.postman_environment.json` - **CONTAINS CREDENTIALS** 🔴

---

## Recommendations Summary

### Immediate Actions Required

| Priority | Item | Status |
|----------|------|--------|
| CRITICAL | Remove/purge `sjrs-lms-staging.postman_environment.json` from git history | ⚠️ ACTION REQUIRED |
| CRITICAL | Invalidate exposed credentials (`admin@yourdomain.com`) | ⚠️ ACTION REQUIRED |
| CRITICAL | Rotate any related API keys/tokens | ⚠️ ACTION REQUIRED |
| HIGH | Run `npm audit fix --force` for lodash vulnerability | ⚠️ ACTION REQUIRED |

### Short-term Actions (Within 1 week)

1. Add Postman environment files to `.gitignore`
2. Document best practices for managing Postman collections in wiki/docs
3. Set up pre-commit hooks to prevent credential commits
4. Review git history for any other exposed secrets
5. Add security audit to CI/CD pipeline

### Long-term Actions (Within 1 month)

1. Implement GitHub Secret Scanning
2. Add SAST (Static Application Security Testing) to CI/CD
3. Implement pre-commit hooks for credential detection
4. Switch to strict versioning for all dependencies per project policy
5. Create `.env.example` file with template structure (no real values)

---

## Testing The Fixes

After remediation, verify:

```bash
# Check for remaining credentials
git log --all --source --remotes -S "password123" -S "admin@yourdomain.com"

# Check npm audit passes
npm audit

# Verify .gitignore is working
git check-ignore -v src/content/docs/api/sjrs-lms-staging.postman_environment.json
```

---

## Files That Should Be Excluded From Version Control

Add these patterns to `.gitignore`:

```
# Postman files with environment variables
*.postman_environment.json
!*.postman_collection.json    # Collections are OK to version

# Environment files
.env
.env.local
.env.*.local

# IDE files
.vscode/settings.json
.idea/
```

---

## Conclusion

The sjrs-lms-docs repository has **one critical security issue** that requires immediate attention: hardcoded credentials in a public repository. This must be remediated immediately by:

1. Purging the credentials from git history
2. Invalidating the exposed credentials
3. Implementing preventive measures

Additionally, npm dependency vulnerabilities should be resolved through `npm audit fix --force`.

All other aspects of the repository are well-configured from a security perspective.

---

**Report Generated**: February 28, 2026  
**Status**: ⚠️ REQUIRES IMMEDIATE ACTION
