---
title: "Project Rules"
slug: project-rules
---

# Documentation Repository Project Rules

These rules apply to this **docs repository** (`sjrs-lms-docs`) and are intentionally separate from application runtime rules.

## Scope & Applicability

- **Primary scope**: Documentation content, docs information architecture, docs publishing pipeline, and docs quality controls.
- **Out of scope**: Runtime application implementation rules (frontend state rules, backend/API implementation enforcement, database query SLAs, React Query cache mechanics).
- **Source system relationship**: This repository documents the app; it does not enforce app runtime behavior directly.

## Core Principles

- **Accuracy First**: Published docs must match actual behavior of the source application.
- **Clarity Over Volume**: Prefer concise, task-oriented docs over large narrative blocks.
- **Single Source of Truth**: Avoid duplicated policy content across pages; link to canonical pages.
- **Traceability**: Significant behavioral claims should be traceable to code, configuration, release notes, or approved decisions.
- **Docs-as-Code**: Documentation changes follow PR review, quality checks, and release discipline.

## Information Architecture Standards

- Organize docs by user intent and system domain (Getting Started, API, Security, Deployment, etc.).
- Keep sidebar categories stable; avoid frequent structural churn that breaks user navigation memory.
- Use one canonical page per major topic; other pages should reference it instead of restating it.
- Archive stale or historical content under `archive/` rather than deleting immediately when historical context is valuable.
- New top-level categories require a documented reason and maintainer approval.

## File & Naming Standards

- Preferred naming is **kebab-case** for new markdown/mdx pages.
- Existing legacy uppercase/underscore files are allowed temporarily; do not mass-rename unless there is a planned migration to avoid link churn.
- New file names must be descriptive and stable (avoid date-only or temporary names unless explicitly archival).
- Use `.md` for standard content and `.mdx` only when interactive JSX content is required.

## Frontmatter & Metadata Standards

- Every doc page must include valid frontmatter with at least:
  - `title`
- Add `description` for user-facing pages whenever possible.
- Keep titles human-readable and unique within a section.
- Do not include stale or speculative “Last Updated” values without a maintenance process.
- Validate frontmatter and content collections with Astro’s schema checks before merge (`npx astro check`).
- For bulk imports or legacy files missing frontmatter, run `node scripts/fix-docs-frontmatter.js` to auto-insert a title based on filename, then review titles for clarity.

## Writing Standards

- Write for the reader’s task: what to do, why, prerequisites, and expected result.
- Use plain, direct language; avoid ambiguous internal jargon unless defined.
- Prefer stepwise procedures for operational tasks.
- Keep examples realistic and minimal.
- Explicitly label assumptions, environment scope (dev/staging/prod), and prerequisites.

## Link & Reference Standards

- Use relative links for internal docs references.
- Validate links after renames/moves; do not merge known broken links.
- Prefer linking to canonical pages rather than copying large repeated content.
- If referencing source code paths from the application repo, clearly mark them as **external to this repo**.
- Automate broken-link detection where feasible. Recommended approaches:
  - Baseline: manual validation for changed pages.
  - Optional: add a link-checking integration to fail builds on broken internal links; enable external link checks on a scheduled basis to avoid slow CI.

## Code Snippet & Command Standards

- Snippets must be executable or clearly marked as pseudo-code.
- Commands must be copy/paste-safe and specify required shell/runtime when relevant.
- Redact secrets and sensitive identifiers in all examples.
- Avoid stale snippets: if a snippet no longer matches actual behavior, update or remove it.

## API & Behavior Documentation Standards

- API docs should reflect released or actively supported behavior only.
- Mark experimental, deprecated, or internal endpoints explicitly.
- Breaking API changes require corresponding docs updates in the same release cycle.
- When behavior differs by environment/version, document the difference explicitly.

## Security & Privacy Standards (Docs Context)

- Never commit secrets, tokens, credentials, private keys, or internal-only URLs.
- Never publish sensitive PII, customer data, or raw production payloads.
- Sanitize logs, screenshots, and examples before publishing.
- Security guidance pages must align with current approved security posture; outdated advice must be archived or removed.

## Accessibility & UX Standards for Docs

- Use semantic markdown structure (`#`, `##`, `###`) with logical heading hierarchy.
- Use descriptive link text (avoid repeated “click here”).
- Provide alt text intent for meaningful images/diagrams.
- Keep tables readable and avoid overly wide, hard-to-scan layouts where possible.

## Quality Gates for This Repository

Required before merge:

- `npm run build` passes.
- Added/updated pages render correctly in Starlight (frontmatter/schema compatible).
- New/changed links are validated manually or through available automated checks.
- No exposed secrets or sensitive data in changed files.
- `npx astro check` passes with no errors for changed content (frontmatter/types/link targets validated by Starlight’s schema).

Recommended before merge:

- `npm run dev` spot-check for changed pages and navigation.
- Cross-check high-impact claims (security/API/deployment) against source-of-truth references.
- Consider a CI job to run `astro build` (and link checks if enabled) on pull requests to prevent regressions.

## PR & Review Standards

- Keep pull requests focused and reviewable.
- Every docs change should answer at least one of:
  - New capability documented
  - Existing behavior corrected
  - Structure/findability improved
  - Outdated guidance removed/archived
- Reviews must check:
  - Technical correctness
  - Clarity and task completion
  - Link integrity
  - Consistency with adjacent docs
  - Build and schema health for changed pages (`astro build` and `astro check` produce no errors; warnings triaged)

## Versioning, Changelog & Release Discipline

- Docs version references must not drift from actual published context.
- Avoid hardcoding application version numbers broadly unless there is a reliable update process.
- Keep changelog entries concise, user-relevant, and traceable to merged PRs.
- Prefer date + release-note references over speculative future-version statements.

## Content Lifecycle Management

Each page should be treated as one of:

- **Active**: Current and maintained
- **Needs Review**: Potentially stale, pending verification
- **Deprecated**: Still published for transition guidance
- **Archived**: Historical reference, not current guidance

Lifecycle transitions should be explicit in PR descriptions when content status changes.

## Non-Applicable App Rules (Explicit)

The following categories from the original app rules are **not directly enforceable in this docs repo** and should remain in the application governance docs instead:

- Runtime frontend state-management mandates (for example React Query mutation/cache policies)
- Backend implementation constraints (response builder internals, DB query execution SLAs)
- Runtime API enforcement details that require app-code CI in another repository
- Application-only lint/test gates that are not configured in this docs repository

## Definition of Done (Docs Repo)

A documentation change is done when:

- Content is accurate, understandable, and scoped correctly.
- Navigation and links work.
- `npm run build` succeeds.
- Security/privacy checks pass for published content.
- Reviewer approval is obtained per branch protections.

## Exceptions Process

- Exceptions are allowed only with explicit rationale in the PR.
- Temporary exceptions must include a follow-up issue and target resolution date.
- Repeated exceptions indicate a rule gap and should trigger rule refinement.

---

These rules are intentionally docs-first. Application runtime rules should live in the application repository and be referenced here when needed, not duplicated as enforcement policy for this site.
