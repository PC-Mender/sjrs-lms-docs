---
title: "Plagiarism Checker"
---

# Plagiarism Checker

## Overview
- Performs plagiarism checks using n-gram analysis with configurable sensitivity
- Calculates similarity percentage and risk level; returns matched snippets and sources
- Saves results to database for user history and later review

## Endpoints
- POST `/api/plagiarism` — Run a plagiarism check
  - Implementation: `functions/api/plagiarism/handlers/check-plagiarism.ts:7`
- GET `/api/plagiarism/history` — List user plagiarism checks
  - Implementation: `functions/api/plagiarism/handlers/get-plagiarism-history.ts:7`
- GET `/api/plagiarism/:id` — Get a specific check result
  - Implementation: `functions/api/plagiarism/handlers/get-plagiarism-results.ts:7`
- DELETE `/api/plagiarism/:id` — Delete a check result
  - Implementation: `functions/api/plagiarism/handlers/delete-plagiarism-result.ts:7`

## Permissions
- `plagiarism:create` — Run checks
- `plagiarism:read` — View history and individual results
- `plagiarism:delete` — Delete results

## Validation
- Schema: `functions/middleware/validation/schemas/plagiarism-schemas.ts:3`
- Fields:
  - `text` (string, 50–50,000 chars)
  - `title` (string, optional, defaults to "Untitled Document")
  - `sensitivity` (`low | standard | high | strict`, default `standard`)

## Request Example
```json
{
  "text": "This is an example text used to demonstrate plagiarism detection ...",
  "title": "My Essay",
  "sensitivity": "high"
}
```

## Response Example
- Handler returns canonical shape at `functions/api/plagiarism/handlers/check-plagiarism.ts:54`
```json
{
  "success": true,
  "data": {
    "plagiarism_check": {
      "id": "c2a0b8f2-...",
      "similarity_percentage": 23.5,
      "risk_level": "medium",
      "matches": [
        { "text": "example text used", "similarity": 0.84, "source": "Internet Source" }
      ],
      "checked_at": "2025-11-15T12:00:00.000Z"
    }
  }
}
```

## Service & Storage
- Service: `functions/plagiarism-service.ts:42` — `PlagiarismCheckerService`
  - Performs analysis and persists results
- Tables: `plagiarism_checks` — created via migrations; used by service
  - Reads: `getPlagiarismHistory()` at `functions/plagiarism-service.ts:199`
  - Reads single: `getPlagiarismCheck()` at `functions/plagiarism-service.ts:214`
  - Delete: `deletePlagiarismCheck()` at `functions/plagiarism-service.ts:229`

## Frontend Integration
- Route definitions: `src/router/route-definitions.ts:446–448`
- Menu items: `src/components/layout/templates/hooks/useMenuItems.tsx:345–349`
- Component: `src/components/features/plagiarism/PlagiarismChecker.tsx`

## Sensitivity and Risk
- Sensitivity thresholds implemented in `functions/plagiarism-service.ts:159`
  - `low`: medium 15, high 25, critical 40
  - `standard`: medium 10, high 20, critical 35
  - `high`: medium 5, high 15, critical 30
  - `strict`: medium 3, high 10, critical 25