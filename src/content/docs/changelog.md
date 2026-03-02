---
title: Changelog
description: Detailed history of changes and improvements
slug: changelog
---

> **Note:** This page highlights major updates and recent patches. For a complete list of all technical changes since inception, see the **[Full Technical Changelog](/full-changelog)**.

## 🆕 **Latest Updates**

### **Version 3.50.3** ⭐ **CURRENT** (March 2, 2026)

#### **Code Refactoring**
- ✅ **Documentation**: Moved FAQ content to the documentation site and simplified the help system.

### **Version 3.50.2** (March 2, 2026)

#### **Security Hardening**
- ✅ **Auth Profile Loading**: Hardened `/api/auth/me` profile loading with schema-safe fallbacks.

### **Version 3.50.1** (March 2, 2026)

#### **Code Refactoring**
- ✅ **Guest Profile Steps**: Split `guest-profile-steps` into focused step components for better maintainability.

### **Version 3.50.0** ⭐ **MAJOR UPDATE** (March 2, 2026)

#### **Location Services Integration** ⭐ **NEW**
The SJRS LMS now features **comprehensive location services** with country-state-city integration for accurate user profile data.

**Key Features:**
- ✅ **Location API**: New endpoints for fetching countries, states, and cities.
- ✅ **Database Schema**: New location fields added to the database schema.
- ✅ **Profile Forms**: Cascading selectors for location fields in profile forms.
- ✅ **User Types**: Updated user type definitions and contexts to include location data.
- ✅ **Pending Approval**: Display of location and "about" fields on the pending approval page.

### **Version 3.49.1** (March 2, 2026)

#### **Bug Fixes & Improvements**
- ✅ **Email Verification**: Fixed email verification workflow and profile completion issues.
- ✅ **Login UX**: Improved modal dismissal behavior in login.
- ✅ **Pending Approval**: Simplified pending approval page UX.

### **Version 3.49.0** (March 2, 2026)

#### **Onboarding Status & Account Management** ⭐ **NEW**
The SJRS LMS now features **persistent onboarding status tracking** and improved account status visibility in Administration pages.

**Key Features:**
- ✅ **Onboarding Status Persistence**: New D1 migration to track `library_users.onboarding_status`
- ✅ **Account Status Tracking**: Separate display of Account Status and Onboarding Status in admin lists
- ✅ **Updated Admin Lists**: Professors, Students, Guests, and Members pages now show comprehensive status information
- ✅ **Improved Members Directory**: Enhanced 3-up grid layout with clearer row grouping for user type, account status, onboarding status, phone, registration year
- ✅ **Guest Edit Modal**: Tightened onboarding selector to onboarding-only values
- ✅ **Enhanced Handlers**: New `get-professor-meta` and `get-student-meta` endpoints for metadata enrichment

**Database Changes:**
- Migration: `2026-03-01_add-onboarding-status-to-library-users.sql`
- New field: `library_users.onboarding_status` with automatic backfill

**API Updates:**
- New handlers: `functions/api/professors/handlers/get-professor-meta.ts`
- New handlers: `functions/api/students/handlers/get-student-meta.ts`
- Enhanced status check services with helpers and next-steps logic

#### **Performance Improvements**
- ✅ **Professors Table**: Optimized table rendering and query performance
- ✅ **Toolbar Enhancement**: Added avatar support for improved table UI
- ✅ **Code Refactoring**: General refactoring for improved maintainability

#### **Recent Patches (v3.48.22 - v3.48.15)**
- ✅ Account Status Updates & Fixes
- ✅ Profile Completion Workflow Refinements
- ✅ Alignment of Students and Guests pages with Professor page patterns
- ✅ Professor Edit Modal Fixes
- ✅ TypeScript Error Resolutions

---

### **Unified Cloudflare Workers Deployment** ⭐ **NEW**
The SJRS LMS has been **migrated from Cloudflare Pages to a unified Cloudflare Workers deployment** with Static Assets, providing a simplified architecture and improved performance.

**Key Achievements:**
- ✅ **Unified Deployment**: Single Workers deployment for both frontend and backend
- ✅ **Simplified Architecture**: Eliminated separate Pages deployment
- ✅ **Automatic Versioning**: Commit-message-based version bumping with `npm run release`
- ✅ **Enhanced Performance**: Static assets served directly from Workers edge network
- ✅ **Cost Optimization**: Unified billing and resource usage
- ✅ **Easier Maintenance**: Single deployment to manage instead of two

### **Routing System Refactoring** ⭐ **COMPLETED**
The SJRS LMS routing system has been **completely refactored** with a revolutionary approach that eliminates 85% of code duplication while enhancing security and performance.

**Key Achievements:**
- ✅ **85% Code Reduction**: Eliminated 200+ duplicate route definitions
- ✅ **Dynamic Generation**: Single route definition creates all dashboard variants
- ✅ **Enhanced Security**: Multi-layer role-based access control
- ✅ **Performance Optimized**: Smart code splitting and lazy loading
- ✅ **Future Proof**: Easy to extend and maintain
- ✅ **Type Safe**: Full TypeScript support throughout

**Documentation:**
- **[Routing System](/architecture/routing-system)** - Complete routing architecture overview
- Archived routing refactor docs → [Archive](/archive/)

### **API Response Standardization** ⭐ **NEW**
The SJRS LMS now features a **standardized API response system** that ensures consistent response formats across all backend endpoints.

**Key Features:**
- ✅ **Standardized Format**: All API responses follow consistent structure
- ✅ **Type Safety**: Full TypeScript support with proper interfaces
- ✅ **Frontend Compatible**: Perfect integration with React hooks
- ✅ **Error Handling**: Structured error responses with codes
- ✅ **Request Tracking**: Unique request IDs for debugging
- ✅ **Performance Monitoring**: Built-in processing time measurement
- ✅ **Automatic CORS**: CORS headers added automatically

**Documentation:**
- **[API Response Standardization](/api/api-response-standardization)** - Complete implementation guide
- **[Functions Folder Architecture](/api/functions-folder-architecture)** - Backend architecture overview

### **Dynamic Role System** ⭐ **NEW**
The SJRS LMS now features a **hybrid role management system** that combines exact role matching for routing with dynamic role inheritance for permissions.

**Key Features:**
- ✅ **Database-Driven Roles**: All roles stored in D1 database
- ✅ **Runtime Configuration**: Role changes without code deployment
- ✅ **Zero Hardcoded Dependencies**: No static role constants
- ✅ **Full CRUD Interface**: Complete role management at `/dashboard-superuser/roles`
- ✅ **Exact Role Matching**: Precise routing to specific dashboards
- ✅ **Dynamic Permissions**: Role inheritance for feature access
- ✅ **No Routing Loops**: Eliminated role switching issues

### **Advanced Session Management** ⭐ **NEW**
The SJRS LMS features a **comprehensive session management system** with cross-tab synchronization and enhanced security features.

**Key Features:**
- ✅ **Cross-Tab Synchronization**: Automatic login/logout detection across browser tabs
- ✅ **Security Hash Validation**: Browser fingerprint-based security validation
- ✅ **Activity Pattern Detection**: Suspicious behavior monitoring and prevention
- ✅ **Session Duration Limits**: 24-hour maximum session duration enforcement
- ✅ **Real-time Security Alerts**: Immediate notification of security events
- ✅ **System Sleep Detection**: Enhanced security monitoring for system sleep/wake cycles
- ✅ **Debug Tools**: Session status monitor with keyboard shortcuts
- ✅ **Single Session Policy**: Only one active session per user with force logout option
- ✅ **Force Logout Mechanism**: User choice to deactivate existing sessions
- ✅ **Activity-Based Detection**: 15-minute activity threshold for session validity
- ✅ **Audit Logging**: Complete logging of force logout actions for security

**Documentation:**
- **[Session Management](/development/session-management)** - Comprehensive session management guide
- **[Single Session Policy](/features/multiple-device-login-detection)** - Force logout and session control

### **Recent Improvements**
- ✅ **Enhanced Session Management**: Industry-standard session handling with cross-tab sync
- ✅ **Advanced Security Features**: Security hash validation and activity pattern detection
- ✅ **Improved Error Handling**: Better error messages and user feedback
- ✅ **Performance Optimizations**: Faster role lookups and caching
- ✅ **Security Enhancements**: Role-based access control improvements
