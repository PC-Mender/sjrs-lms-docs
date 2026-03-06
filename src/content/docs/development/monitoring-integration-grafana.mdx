---
title: "Monitoring Integration Grafana"
---

# Monitoring Integration (Grafana Cloud / Faro)

This document describes the current frontend monitoring setup using
**Grafana Cloud Frontend Observability (Faro)** and how it fits into the
existing error-handling and logging architecture.

---

## ✅ What Is Implemented

- **Frontend telemetry** via Grafana Faro Web SDK
- **Tracing support** via `@grafana/faro-web-tracing`
- **Environment-aware initialization** in `src/index.tsx`
- **Unified error handling** via `src/utilities/error/unified-error-handler.ts`
- **Production-safe logging** via `src/utilities/logging/logger.ts`

The backend (Cloudflare Workers) uses structured logging and error
handling (`functions/utilities/error/unified-error-handler.ts`) and can
be wired to Grafana Loki / Prometheus independently.

---

## Frontend Integration

### Packages

Installed in `package.json`:

- `@grafana/faro-web-sdk`
- `@grafana/faro-web-tracing`

### Initialization (`src/index.tsx`)

Faro is initialized once at app startup, before React renders, so it
covers the entire SPA:

```ts
import { initializeFaro, getWebInstrumentations } from '@grafana/faro-web-sdk';
import { TracingInstrumentation } from '@grafana/faro-web-tracing';

initializeFaro({
  url: '<your Grafana Faro collector URL>',
  app: {
    name: 'SJRS LMS Frontend',
    version: '<app version>',
    environment: import.meta.env.MODE ?? 'development',
  },
  instrumentations: [
    ...getWebInstrumentations(),
    new TracingInstrumentation(),
  ],
});
```

Replace `<your Grafana Faro collector URL>` with the value from the
Grafana Cloud **Frontend Observability** UI.

### What Faro Captures

- Uncaught JavaScript errors
- Unhandled promise rejections
- Basic performance metrics (page load, resources, etc.)
- Sessions and some navigation information

You do **not** need to add Faro calls on every page; the global init is
enough for baseline coverage.

---

## Error Handling & Logging

### Unified Error Handler

- **Frontend**: `src/utilities/error/unified-error-handler.ts`
- **Backend**: `functions/utilities/error/unified-error-handler.ts`

Responsibilities:

- Normalize any thrown value to an `Error`
- Classify errors into categories/severity
- Produce user-friendly messages
- Maintain an in-memory error log (for diagnostics)
- Optionally show user notifications based on severity

Faro runs alongside this; the unified handler itself does **not** depend
on Faro or any specific external provider.

### Logger

- `src/utilities/logging/logger.ts`

Responsibilities:

- Provide `logDebug`, `logInfo`, `logWarn`, `logError` helpers
- Delegate error logging to the unified error handler
- Avoid ad-hoc `console.log` in production

In development, console calls are commented out by default; production
builds rely on the structured error handling path.

---

## CSP Configuration for Faro

To allow the browser to send events to Grafana, the Content Security
Policy must permit connections to the Faro collector.

In `functions/middleware/cors/headers/security-headers.ts`:

```ts
"connect-src 'self' http://localhost:* https://localhost:* ws://localhost:* wss://localhost:* https://www.google-analytics.com https://challenges.cloudflare.com https://*.sjrslms.in https://your-grafana-collector-endpoint.grafana.net",
```

Ensure the correct collector origin from your Grafana Cloud stack is
included in `connect-src`.

---

## How to Verify the Integration

1. **Run the app locally**

   ```bash
   npm run dev
   ```

2. **Open the app in a browser** and navigate across several routes.

3. **Trigger a test error** in any component (temporarily), e.g.:

   ```ts
   throw new Error('Faro test error');
   ```

4. **Check Grafana Cloud → Frontend Observability → your app**:

   - Confirm sessions and page views are visible.
   - Confirm the test error appears with stack trace.

---

## Recommended Next Steps

### 1. Add User Context

Expose a small helper that, after login, sets user-identifying data in
Faro (e.g. user id, role, institution). This allows filtering and
grouping errors by user or tenant.

### 2. Backend Observability

Independently of Faro, consider wiring Workers logs/metrics to Grafana:

- **Logs** → Loki
- **Metrics** → Prometheus

### 3. Dashboards & Alerts

Create Grafana dashboards and alerts for:

- **Frontend error rate** and top error types
- **API error rate / latency** (once backend metrics/logs are wired in)
- **Key business metrics** (e.g. logins, loans, reservations) as needed
