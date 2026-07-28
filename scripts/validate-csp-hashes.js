import { readFileSync } from 'node:fs';
import { join } from 'node:path';

const headersFile = join(process.cwd(), 'dist', '_headers');
const headers = readFileSync(headersFile, 'utf-8');

const cspMatch = headers.match(/Content-Security-Policy:\s*(.+)/i);
if (!cspMatch) {
  console.error('FAIL: No Content-Security-Policy header found in _headers');
  process.exit(1);
}

const csp = cspMatch[1].trim();
const scriptSrcMatch = csp.match(/script-src\s+([^;]+);/);
if (!scriptSrcMatch) {
  console.error('FAIL: No script-src directive found in CSP');
  process.exit(1);
}

const scriptSrc = scriptSrcMatch[1].trim();
const tokens = new Set(scriptSrc.split(/\s+/));

const checks = [
  { token: "'self'", label: 'self' },
  { token: "'wasm-unsafe-eval'", label: 'wasm-unsafe-eval (Pagefind WASM)' },
  { token: "'unsafe-inline'", label: 'unsafe-inline (Cloudflare injected scripts)' },
];

let failed = false;
for (const { token, label } of checks) {
  if (tokens.has(token)) {
    console.log(`  PASS: script-src contains ${label}`);
  } else {
    console.error(`  FAIL: script-src missing ${label}`);
    failed = true;
  }
}

const workerSrcMatch = csp.match(/worker-src\s+([^;]+);/);
if (workerSrcMatch) {
  const workerSrc = workerSrcMatch[1].trim();
  if (workerSrc.includes('blob:')) {
    console.log('  PASS: worker-src contains blob: (Pagefind web worker)');
  } else {
    console.error('  FAIL: worker-src missing blob: (required for Pagefind web worker)');
    failed = true;
  }
} else {
  console.error('  FAIL: No worker-src directive found in CSP');
  failed = true;
}

if (failed) {
  console.error('\nFAIL: CSP is missing required directives.');
  process.exit(1);
}

console.log('\nPASS: CSP contains all required directives for Pagefind and Cloudflare.');
