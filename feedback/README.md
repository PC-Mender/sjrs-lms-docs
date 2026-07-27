# Docs Feedback Worker

This Worker handles anonymous page feedback for `sjrs-lms-docs`.

## Endpoints

- `GET /health`
- `GET /api/v1/feedback/summary?page=/some/page`
- `POST /api/v1/feedback/vote`

## Security Model

- Exact-origin CORS allowlist via `ALLOWED_ORIGIN`
- HttpOnly visitor cookie for per-browser deduplication
- Server-side hashing of visitor, IP, and user-agent values
- D1-backed rate limiting for summary and vote requests
- Length-limited, validated payloads

## Setup

1. Create the D1 database:

```bash
npx wrangler d1 create sjrs-docs-feedback --config feedback/wrangler.toml
```

2. Copy the returned `database_id` values into [`feedback/wrangler.toml`](./wrangler.toml).

3. Apply the migration:

```bash
npx wrangler d1 migrations apply FEEDBACK_DB --config feedback/wrangler.toml
```

4. Add the required secret:

```bash
npx wrangler secret put HASH_SECRET --config feedback/wrangler.toml
```

5. Deploy the Worker:

```bash
npx wrangler deploy --config feedback/wrangler.toml
```

6. Set the docs-site build variable:

```bash
PUBLIC_DOCS_FEEDBACK_API_BASE_URL=https://your-feedback-endpoint.example
```
