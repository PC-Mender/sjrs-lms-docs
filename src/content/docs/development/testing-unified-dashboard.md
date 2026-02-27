---
title: "Testing Unified Dashboard"
---

# Testing the Unified Dashboard Pilot

## Quick Start

To test the new unified dashboard system for Admin:

### 1. Enable the Feature Flag

Create or edit `.env.local` in the project root:

```bash
# .env.local
VITE_USE_UNIFIED_DASHBOARD=true
```

### 2. Restart Dev Server

```bash
npm run dev
```

### 3. Navigate to Admin Dashboard

```
http://localhost:5173/dashboard-admin
```

You should now see the unified dashboard implementation.

## What to Test

### ✅ Visual Appearance
- [ ] Dashboard header displays correctly
- [ ] Stats grid (4 cards) layout matches original
- [ ] Quick actions section displays and is clickable
- [ ] Analytics widgets render correctly
- [ ] Activity feed shows recent activities

### ✅ Functionality
- [ ] Clicking stats navigates to correct pages
- [ ] Quick action buttons navigate correctly
- [ ] Refresh functionality works
- [ ] Loading states display properly
- [ ] Error states display properly (if any errors occur)

### ✅ Permissions
- [ ] Widgets without permission are hidden
- [ ] Quick actions without permission are hidden
- [ ] Navigation works correctly based on permissions

### ✅ Performance
- [ ] Initial page load time (compare with legacy)
- [ ] Widget lazy loading works
- [ ] No console errors
- [ ] Smooth interactions

### ✅ Responsive Design
- [ ] Mobile view (xs: <576px)
- [ ] Tablet view (sm: 576px, md: 768px)
- [ ] Desktop view (lg: 992px, xl: 1200px, xxl: 1600px)

## Comparing Implementations

### View Legacy Implementation

Set feature flag to false or comment it out:

```bash
# .env.local
VITE_USE_UNIFIED_DASHBOARD=false
# or remove the variable entirely
```

### Side-by-Side Comparison

Open two browser windows:
1. Legacy: `VITE_USE_UNIFIED_DASHBOARD=false`
2. Unified: `VITE_USE_UNIFIED_DASHBOARD=true`

Compare:
- Visual differences (should be minimal)
- Functionality (should be identical)
- Performance (check network tab, React DevTools Profiler)
- Bundle size (check browser DevTools, Network tab)

## Metrics to Measure

### Code Metrics
```bash
# Count lines in legacy implementation
# dashboard-admin.tsx: ~202 lines total
# With unified: ~40 lines (LegacyAdminDashboard) + 15 lines (wrapper) = ~55 lines

# Reduction: ~147 lines eliminated (~73% reduction)
```

### Bundle Size
Check in browser DevTools Network tab:
- Legacy: Look for chunk size containing AdminDashboard
- Unified: Check if chunks are smaller due to better code splitting

### Performance
Use React DevTools Profiler:
- Measure render time for legacy vs. unified
- Check for unnecessary re-renders
- Verify lazy loading of widgets

## Known Differences

### Expected Differences
- **None** - The unified implementation should be visually and functionally identical

### If You Notice Differences
1. Take screenshots of both implementations
2. Note the specific difference
3. Check browser console for errors
4. File issue with details

## Rollback Plan

If issues are found:

### Immediate Rollback
```bash
# .env.local
VITE_USE_UNIFIED_DASHBOARD=false
```

Restart dev server. System reverts to legacy implementation.

### Report Issues
Create issue with:
- What you were testing
- Expected behavior
- Actual behavior
- Screenshots (if visual issue)
- Browser console errors (if applicable)
- Steps to reproduce

## Success Criteria

Pilot is successful if:
- ✅ Visual appearance matches legacy (or is improved)
- ✅ All functionality works identically
- ✅ No new console errors
- ✅ Performance is equal or better
- ✅ Code is significantly reduced
- ✅ Configuration is easier to understand than JSX

## Next Steps After Pilot

If pilot succeeds:
1. Keep feature flag for 1-2 weeks of testing
2. Gather feedback from team
3. Roll out to staging environment
4. A/B test with real users (optional)
5. Enable by default for Admin
6. Migrate other dashboards (Librarian, Dean, Superuser, User)
7. Remove legacy code once all dashboards migrated

## Questions?

See: `src/components/features/dashboard/unified/README.md`

---

**Current Status:** Pilot implementation ready for testing  
**Affected Dashboard:** Admin only  
**Risk Level:** Low (feature flag allows instant rollback)
