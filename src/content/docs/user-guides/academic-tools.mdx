---
title: "Academic Tools"
---

# Academic Tools User Guide

## Overview
This guide explains how to use the Citation Generator and Plagiarism Checker available under the "Academic Tools" menu. Access is permission-gated.

## Accessing the Tools
- Menu items appear when you have permissions:
  - Citation Generator: `citations:*`
  - Plagiarism Checker: `plagiarism:*`
- Menu configuration: `src/components/layout/templates/hooks/useMenuItems.tsx:335–351`
- Routes are available across all dashboards: `src/router/route-definitions.ts:446–448`

## Citation Generator
### Features
- **Multiple Styles**: APA, MLA, Chicago, Harvard, IEEE.
- **Various Sources**: Book, Journal, Website, Newspaper, Film.
- **History**: View and manage previously generated citations.
- **Export**: Copy to clipboard or save to your account.

### Steps
- Open `Citation Generator` from the Academic Tools menu
- Select `Format` (APA, MLA, Chicago, Harvard)
- Select `Source Type` (Book, Journal, Website, etc.)
- Fill in the fields shown; required fields depend on source type
- Click `Generate Citation`
- Optionally, click `Save Citation` to store it

### Tips
- Source-type validation rules are enforced by the backend: `functions/middleware/validation/schemas/citation-schemas.ts:8`
- The generated response includes both full citation and in-text citation: `functions/api/citations/handlers/generate-citation.ts:30`

### Troubleshooting
- If required fields are missing, the backend returns a validation error
- Ensure your account has `citations:create` to generate and `citations:read` to view history

## Plagiarism Checker
### Features
- **Experimental Tool**: Heuristic-based checking (not a replacement for professional tools).
- **Sensitivity Levels**: Low, Medium, High, Strict.
- **Detailed Report**: Similarity percentage, matched snippets, and potential sources.

### Steps
- Open `Plagiarism Checker` from the Academic Tools menu
- Paste your text (minimum 50 characters; max 50,000)
- Provide a title (optional)
- Choose a sensitivity (Low, Standard, High, Strict)
- Click `Check for Plagiarism`

### Understanding Results
- The result shows:
  - Similarity percentage
  - Risk level (low/medium/high/critical)
  - Matched snippets and potential sources
- Risk thresholds: `functions/plagiarism-service.ts:159`

### Tips
- Sensitivity controls how strict detection is
- Use results to rephrase content, add citations, and improve originality

### Troubleshooting
- Ensure your account has `plagiarism:create` permission
- For history, you need `plagiarism:read`
- Use reasonable input sizes; very long texts can be slow

## Bookmarks
### Features
- **Organize**: Group links into folders and tag them.
- **Favorites & Pinned**: Mark important links for quick access.
- **Import/Export**: Bulk import from CSV or export your data.
- **Advanced Search**: Filter by folder, tags, or status.

### Steps
1. Navigate to **"Academic Tools"** > **"Bookmarks"**.
2. Click **"Add Bookmark"**.
3. Enter the **Title** and **URL**.
4. (Optional) Add a **Folder**, **Tags**, and **Notes**.
5. Check **Favorite** or **Pinned** if desired.
6. Click **"Save"**.

### Managing Bookmarks
- **Edit**: Click the edit icon to change details.
- **Delete**: Remove obsolete links.
- **Bulk Actions**: Select multiple bookmarks to delete them at once.

## Security & Permissions
- All operations are validated by backend security middleware: `functions/api/citations/index.ts:20`, `functions/api/plagiarism/index.ts:20`
- Permissions checked via `hasPermission`: `functions/api/citations/index.ts:38`, `functions/api/plagiarism/index.ts:37`

## API References
- Full endpoint list: `docs/api/endpoints.md` (Academic Tools section)

## Known Limitations
- Plagiarism detection uses simulated matching; future integrations can provide real-time database comparisons
- Citation history depends on database migrations for `saved_citations` and `citation_history`