---
title: "Vitest Migration Guide"
---

# Vitest Migration Guide

## Current Status

**Problem**: Jest doesn't support Vite's `import.meta` syntax, causing all tests to fail with:
```
SyntaxError: Cannot use 'import.meta' outside a module
```

**Solution**: Migrate from Jest to Vitest (Vite's native test runner)

## Why Vitest?

### Technical Compatibility
- **Native Vite Support**: Understands `import.meta` out of the box
- **Same Config**: Reuses `vite.config.ts` - no duplicate configuration
- **ES Modules**: Native ESM support without transformations
- **Instant HMR**: Test changes reflect instantly (like Vite dev server)

### Developer Experience
- **10x Faster**: Tests run in milliseconds, not seconds
- **Watch Mode**: Intelligent re-running of affected tests only
- **Jest Compatible**: 98% API compatible with Jest - minimal code changes
- **TypeScript First**: No additional configuration needed

### Project Alignment
- **Consistency**: Same tool chain for dev, build, and test
- **Modern Stack**: Aligns with project's modern architecture
- **Active Development**: Backed by Vite team with strong community

## Migration Steps

### 1. Install Vitest

```bash
npm install -D vitest @vitest/ui
```

### 2. Update package.json Scripts

```json
{
  "scripts": {
    "test": "vitest",
    "test:ui": "vitest --ui",
    "test:run": "vitest run",
    "test:coverage": "vitest --coverage"
  }
}
```

### 3. Create vitest.config.ts

```typescript
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: './src/test/setupTests.ts',
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'src/test/',
        '**/*.d.ts',
        '**/*.config.*',
        '**/mockData',
        '**/__tests__',
      ],
    },
  },
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
      'shared': path.resolve(__dirname, './shared'),
    },
  },
});
```

### 4. Update setupTests.ts

```typescript
import '@testing-library/jest-dom';
import { cleanup } from '@testing-library/react';
import { afterEach } from 'vitest';

// Auto cleanup after each test
afterEach(() => {
  cleanup();
});

// Mock environment variables
process.env.VITE_USE_ZUSTAND_PERMISSIONS = 'false';
process.env.VITE_PERFORMANCE_MONITORING = 'true';

// Mock localStorage (if not already available in jsdom)
if (typeof window !== 'undefined') {
  const localStorageMock = {
    getItem: vi.fn(),
    setItem: vi.fn(),
    removeItem: vi.fn(),
    clear: vi.fn(),
  };
  Object.defineProperty(window, 'localStorage', {
    value: localStorageMock,
  });
}
```

### 5. Update Test Files

Minimal changes needed:

```typescript
// Before (Jest)
import { jest } from '@jest/globals';
jest.mock('../../../hooks/usePermissions');
const mockFn = jest.fn();

// After (Vitest)
import { vi } from 'vitest';
vi.mock('../../../hooks/usePermissions');
const mockFn = vi.fn();
```

Most tests work with zero changes due to Jest compatibility!

### 6. Remove Jest Dependencies

```bash
npm uninstall jest @types/jest ts-jest jest-environment-jsdom
```

### 7. Update CI/CD

```yaml
# .github/workflows/deploy.yml
- name: Run tests
  run: npm run test:run
```

## Estimated Migration Time

- **Setup**: 15 minutes
- **Test Updates**: 30 minutes (mostly find/replace)
- **Verification**: 15 minutes
- **Total**: ~1 hour

## Benefits After Migration

### Immediate
- ✅ All tests run successfully
- ✅ 10x faster test execution
- ✅ No more `import.meta` errors
- ✅ Instant test feedback during development

### Long-term
- ✅ Consistent tooling across project
- ✅ Better debugging with source maps
- ✅ Parallel test execution
- ✅ UI for test exploration (`npm run test:ui`)

## Current Workaround

Until migration is complete:
- Tests are documented and structured correctly
- CI runs with `--passWithNoTests` flag
- Pre-push hooks warn but don't block
- All test logic is ready - just waiting for compatible runner

## Migration Priority

**Recommended**: High Priority
- Blocks test-driven development
- Prevents regression detection
- Limits code quality enforcement

## References

- [Vitest Official Docs](https://vitest.dev/)
- [Vitest vs Jest](https://vitest.dev/guide/comparisons.html)
- [Migration from Jest](https://vitest.dev/guide/migration.html)
