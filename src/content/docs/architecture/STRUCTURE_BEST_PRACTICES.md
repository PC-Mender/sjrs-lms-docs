---
title: "STRUCTURE BEST PRACTICES"
---

# Structure Best Practices & Guidelines

**Important considerations for maintaining and evolving the feature-based modular structure.**

---

## 🎯 Core Principles to Remember

### 1. **Keep Features Self-Contained**

✅ **DO:**
- Put all feature-specific code in the feature directory
- Keep feature boundaries clear
- Make features independent where possible

❌ **DON'T:**
- Mix feature code with shared code
- Create circular dependencies between features
- Put feature-specific code in shared directories

---

### 2. **Maintain Consistent Patterns**

✅ **DO:**
- Follow the established module pattern (`base/`, `handlers/`, `index.ts`)
- Use consistent naming conventions
- Keep file sizes manageable (~100-200 lines)

❌ **DON'T:**
- Create new patterns for each feature
- Mix different organizational styles
- Let files grow beyond 300 lines without splitting

---

### 3. **Separate Shared vs. Feature-Specific Code**

✅ **DO:**
- Put reusable components in `src/components/ui/`
- Put feature-specific components in `src/components/features/[feature]/`
- Use shared utilities from `src/utilities/`
- Create feature-specific utilities in feature directories

❌ **DON'T:**
- Put reusable code in feature directories
- Put feature-specific code in shared directories
- Duplicate shared utilities in features

---

## 📋 When Adding New Features

### Step-by-Step Guide

#### 1. **Create Feature Structure**

```
src/components/features/[feature-name]/
├── components/
│   ├── [Feature]List.tsx
│   ├── [Feature]Form.tsx
│   ├── [Feature]Show.tsx
│   └── index.ts
└── index.ts

# Complex pages (recommended):
src/pages/[feature-name]/
├── components/          # Page-specific components (if needed)
├── hooks/              # Page-specific hooks (if needed)
├── types.ts            # Or types/ directory (if needed)
├── utils.ts            # Or utils/ directory (if needed)
└── index.tsx           # Main page component

# Simple pages (<100 lines) can be flat:
src/pages/[feature-name].tsx

functions/api/[feature-name]/
├── base/
│   └── [feature]-utils.ts
├── handlers/
│   ├── get-[feature]s.ts
│   ├── create-[feature].ts
│   ├── update-[feature].ts
│   └── delete-[feature].ts
└── index.ts
```

#### 2. **Follow Naming Conventions**

- **Components:** PascalCase (`BookList.tsx`)
- **Handlers:** kebab-case (`get-books.ts`)
- **Utilities:** kebab-case (`book-utils.ts`)
- **Types:** kebab-case (`book.types.ts`)

#### 3. **Export Through Index Files**

Always export through `index.ts` files:

```typescript
// src/components/features/books/index.ts
export * from './components';
```

#### 4. **Document the Feature**

Add a `README.md` for complex features:

```markdown
# [Feature Name]

## Overview
Brief description of the feature.

## Structure
Directory structure explanation.

## Usage
How to use the feature components.
```

---

## ⚠️ Common Pitfalls to Avoid

### 1. **Feature Creep**

❌ **Problem:** Adding unrelated functionality to existing features

**Example:**
```
books/
├── BookList.tsx
├── BookForm.tsx
└── UserProfile.tsx  # ❌ Wrong! This belongs in users/
```

✅ **Solution:** Create a new feature or use shared components

---

### 2. **Circular Dependencies**

❌ **Problem:** Features depending on each other

**Example:**
```
books/ → imports from loans/
loans/ → imports from books/
```

✅ **Solution:** 
- Extract shared code to `src/components/ui/` (for reusable components) or `src/utilities/` (for utilities)
- Use dependency injection
- Create shared types in `src/types/`

---

### 3. **Over-Sharing**

❌ **Problem:** Putting everything in shared directories

**Example:**
```
src/components/ui/
├── BookList.tsx      # ❌ Should be in features/books/
├── AuthorList.tsx    # ❌ Should be in features/authors/
└── LoanList.tsx      # ❌ Should be in features/loans/
```

✅ **Solution:** Only put truly reusable components in `ui/`

**Rule of Thumb:** If a component is used by 3+ features, it can be shared.

---

### 4. **Under-Sharing**

❌ **Problem:** Duplicating code across features

**Example:**
```
books/utils/validation.ts
authors/utils/validation.ts  # ❌ Duplicate code
loans/utils/validation.ts     # ❌ Duplicate code
```

✅ **Solution:** Extract to `src/utilities/validation/`

**Rule of Thumb:** If code is identical across features, it should be shared.

---

### 5. **Inconsistent Structure**

❌ **Problem:** Different features using different patterns

**Example:**
```
books/
├── BookList.tsx      # Flat structure
└── BookForm.tsx

authors/
├── components/       # Nested structure
│   └── AuthorList.tsx
```

✅ **Solution:** Follow the established pattern consistently

---

## 🔍 When to Refactor

### Signs You Need to Refactor

1. **File Too Large** (>300 lines)
   - Split into smaller components
   - Extract utilities
   - Break into sub-features

2. **Feature Too Complex**
   - Split into sub-features
   - Extract shared logic
   - Create feature modules

3. **Circular Dependencies**
   - Extract shared code
   - Restructure dependencies
   - Use dependency injection

4. **Code Duplication**
   - Extract to shared utilities
   - Create shared components
   - Use composition

5. **Unclear Boundaries**
   - Clarify feature responsibilities
   - Move code to correct feature
   - Split overlapping features

---

## 📊 Maintaining File Sizes

### Guidelines

| File Type | Target Size | Max Size | Action if Exceeded |
|-----------|------------|----------|-------------------|
| Component | 50-200 lines | 300 lines | Split into smaller components |
| Handler | 50-150 lines | 250 lines | Extract utilities, split logic |
| Router | 50-150 lines | 250 lines | Delegate to handlers |
| Page | 100-300 lines | 500 lines | Extract components |
| Utility | 50-200 lines | 300 lines | Split into focused utilities |

### How to Split Large Files

**Before:**
```typescript
// BookList.tsx (400 lines)
export function BookList() {
  // 200 lines of table logic
  // 100 lines of filter logic
  // 100 lines of pagination logic
}
```

**After:**
```typescript
// BookList.tsx (50 lines)
import { BookTable } from './BookTable';
import { BookFilters } from './BookFilters';
import { BookPagination } from './BookPagination';

export function BookList() {
  // Composition of smaller components
}
```

---

## 🧪 Testing Considerations

### Feature Testing Structure

```
src/pages/books/
├── components/
├── hooks/
├── types.ts
├── index.tsx
└── __tests__/          # Feature-specific tests
    ├── BookList.test.tsx
    ├── BookForm.test.tsx
    └── book-utils.test.ts
```

### Testing Best Practices

1. **Test Features Independently**
   - Mock dependencies on other features
   - Test feature boundaries
   - Verify feature isolation

2. **Test Shared Code Separately**
   - Test utilities in `src/utilities/__tests__/`
   - Test UI components in `src/components/ui/__tests__/`
   - Avoid testing shared code through features

3. **Integration Tests**
   - Test feature interactions
   - Test API integration
   - Test end-to-end flows

---

## 🚀 Performance Considerations

### Code Splitting

✅ **DO:**
- Use lazy loading for features
- Split large features into chunks
- Load features on demand

```typescript
// Route definitions
const BooksPage = lazy(() => import('../pages/books'));
```

### Bundle Size

✅ **DO:**
- Keep feature bundles small
- Avoid importing entire feature libraries
- Use tree-shaking friendly imports

❌ **DON'T:**
- Import entire feature when you only need one component
- Create circular dependencies
- Duplicate large dependencies

---

## 📝 Documentation Standards

### Feature Documentation

Each feature should have:

1. **README.md** (for complex features)
   - Overview
   - Structure
   - Usage examples
   - API documentation

2. **Type Definitions**
   - Clear interfaces
   - JSDoc comments
   - Export through index

3. **Component Documentation**
   - Props interfaces
   - Usage examples
   - Behavior notes

### Example README Structure

```markdown
# [Feature Name]

## Overview
Brief description of what this feature does.

## Structure
```
[feature]/
├── components/
├── hooks/
├── types.ts
└── index.tsx
```

## Usage
```typescript
import { FeatureComponent } from '@/components/features/[feature]';
```

## API
Document API endpoints and data structures.
```

---

## 🔄 Migration Guidelines

### When Migrating Code

1. **Identify Feature Boundaries**
   - Determine which feature the code belongs to
   - Check for dependencies
   - Plan migration path

2. **Move Code Gradually**
   - Move one file at a time
   - Update imports
   - Test after each move

3. **Update Dependencies**
   - Update import paths
   - Fix circular dependencies
   - Update tests

4. **Verify**
   - Run tests
   - Check for broken imports
   - Verify feature isolation

---

## 🎨 Code Organization Checklist

When adding new code, ask:

- [ ] Does this belong to an existing feature?
- [ ] Should this be shared across features?
- [ ] Is the file size manageable (<300 lines)?
- [ ] Are naming conventions consistent?
- [ ] Is the code exported through index files?
- [ ] Are dependencies clear and minimal?
- [ ] Is the feature self-contained?
- [ ] Is documentation up to date?

---

## 🔗 Dependency Management

### Feature Dependencies

✅ **Allowed:**
- Features → Shared code (`src/utilities/`, `src/components/ui/`)
- Features → Types (`src/types/`)
- Features → Hooks (`src/hooks/`)

❌ **Avoid:**
- Feature → Feature (creates coupling)
- Circular dependencies
- Deep dependency chains

### Dependency Injection

If features need to interact:

```typescript
// ❌ BAD: Direct import
import { BookService } from '@/features/books';

// ✅ GOOD: Dependency injection
function LoanComponent({ bookService }: { bookService: BookService }) {
  // Use injected service
}
```

---

## 📈 Growth Management

### As Codebase Grows

1. **Monitor Feature Size**
   - Split large features (>10 files)
   - Extract sub-features
   - Create feature modules

2. **Review Shared Code**
   - Identify new shared patterns
   - Extract common utilities
   - Create shared components

3. **Maintain Consistency**
   - Regular code reviews
   - Structure audits
   - Refactoring sessions

---

## 🛠️ Tooling Recommendations

### Useful Tools

1. **ESLint Rules** (Recommendations - not currently implemented)
   ```json
   {
     "rules": {
       "max-lines": ["warn", 300],
       "no-restricted-imports": ["error", {
         "paths": ["@/components/features/*/features/*"]  // SUGGESTION: Prevent feature → feature
       }]
     }
   }
   ```

2. **File Size Monitoring**
   - Set up file size warnings
   - Monitor bundle sizes
   - Track feature growth

3. **Dependency Analysis**
   - Use tools to detect circular dependencies
   - Analyze import graphs
   - Identify coupling issues

---

## 🎓 Learning Resources

### Key Concepts

1. **Feature-Based Architecture**
   - Organize by business domain
   - Keep features independent
   - Clear boundaries

2. **Modular Design**
   - Single responsibility
   - Loose coupling
   - High cohesion

3. **Separation of Concerns**
   - Feature-specific vs. shared
   - Clear boundaries
   - Minimal dependencies

---

## ✅ Quick Reference

### File Organization

```
Feature Code:
├── src/components/features/[feature]/
├── src/pages/[feature]/
└── functions/api/[feature]/

Shared Code:
├── src/components/ui/
├── src/components/layout/
├── src/utilities/
├── src/hooks/
└── src/types/
```

### File Size Limits

- Components: 300 lines max
- Handlers: 250 lines max
- Pages: 500 lines max
- Utilities: 300 lines max

### Naming Conventions

- Components: PascalCase (`BookList.tsx`)
- Handlers: kebab-case (`get-books.ts`)
- Utilities: kebab-case (`book-utils.ts`)
- Types: kebab-case (`book.types.ts`)

---

## 🎯 Final Checklist

Before committing code:

- [ ] Code is in the correct feature directory
- [ ] File sizes are within limits
- [ ] Naming conventions are followed
- [ ] Exports are through index files
- [ ] No circular dependencies
- [ ] Shared code is truly shared
- [ ] Feature code is feature-specific
- [ ] Documentation is updated
- [ ] Tests are updated
- [ ] Imports are correct

---

*Following these guidelines will help maintain the excellent structure you've built!*

