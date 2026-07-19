# Contributing to SJRS LMS Documentation

Thank you for your interest in improving the SJRS LMS documentation. This repository documents the SJRS Library Management System application and is published to [docs.sjrslms.in](https://docs.sjrslms.in).

## How to Contribute

### Reporting Issues

If you find an error, outdated content, broken link, or have a suggestion, please open an issue:

- **Docs repository issues**: [https://github.com/PC-Mender/sjrs-lms-docs/issues](https://github.com/PC-Mender/sjrs-lms-docs/issues)
- **Application issues**: [https://github.com/PC-Mender/sjrslms/issues](https://github.com/PC-Mender/sjrslms/issues) (for bugs in the app itself)

When reporting, please include:

- The page URL or file path
- A clear description of the problem
- Suggested correction or improvement, if any

### Submitting Changes

1. **Fork the repository** and create a feature branch from `main`.
2. **Make your changes** following the standards below.
3. **Run quality checks** locally (see [Local Checks](#local-checks)).
4. **Commit** using [Conventional Commits](https://www.conventionalcommits.org/) format, for example:
   - `docs(user-guides): clarify renewal steps`
   - `fix(links): correct broken api reference`
   - `chore(security): update supported releases`
5. **Open a pull request** with a clear description of what changed and why.

## Documentation Standards

All contributions should follow the [Documentation Standards](./src/content/docs/documentation-standards.mdx) and the [Docs Project Rules](./src/content/docs/project-rules-docs.mdx).

### Writing Guidelines

- Write for the reader’s task: what to do, why, prerequisites, and expected result.
- Use plain, direct language. Define jargon or link to the [Glossary](./src/content/docs/getting-started/glossary.mdx).
- Prefer stepwise procedures for operational tasks.
- Keep examples realistic, minimal, and free of secrets or sensitive data.

### File and Naming Conventions

- Use **kebab-case** for new file names, e.g., `api-quick-start.mdx`.
- Use `.md` for standard content and `.mdx` only when interactive JSX is required.
- Place new pages in the appropriate section directory under `src/content/docs/`.

### Frontmatter

Every docs page must include valid frontmatter with at least a `title`:

```yaml
---
title: Page Title
description: Short description for SEO and previews.
---
```

For pages that are no longer current, set a lifecycle value:

```yaml
---
title: Old Feature Guide
lifecycle: Archived
---
```

Allowed lifecycle values: `Active`, `Needs Review`, `Deprecated`, `Archived`.

### Links

- Use relative links for internal references.
- Validate links after moving or renaming files.
- Mark external source-code paths as external to this repository.

## Local Checks

Before opening a pull request, run:

```bash
npm install
npm run build
npm run lint
npm run check:lifecycle
```

Ensure there are no build errors, type errors, or broken internal links.

## Review Process

Pull requests are reviewed for:

- Technical accuracy
- Clarity and completeness
- Link integrity
- Consistency with adjacent documentation
- Build and schema health

All automated checks defined in [`.github/workflows/docs-quality-gates.yml`](./.github/workflows/docs-quality-gates.yml) must pass.

## Code of Conduct

This project follows the [Code of Conduct](./CODE_OF_CONDUCT.md). By participating, you agree to uphold this standard.

## Questions?

For questions about the application or its documentation, open a [GitHub Discussion](https://github.com/PC-Mender/sjrs-lms-docs/discussions) if enabled, or an issue in the appropriate repository.
