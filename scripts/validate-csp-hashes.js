import { createHash } from 'node:crypto';
import { readFileSync, readdirSync, statSync } from 'node:fs';
import { join } from 'node:path';

const distDir = join(process.cwd(), 'dist');
const headersFile = join(distDir, '_headers');
const hashes = new Set();
let scriptCount = 0;

function walkDir(dir) {
  for (const entry of readdirSync(dir)) {
    const fullPath = join(dir, entry);
    const stat = statSync(fullPath);
    if (stat.isDirectory()) {
      walkDir(fullPath);
    } else if (entry.endsWith('.html')) {
      extractInlineScripts(fullPath);
    }
  }
}

function extractInlineScripts(htmlFile) {
  const html = readFileSync(htmlFile, 'utf-8');
  const scriptRegex = /<script(?:\s[^>]*)?>([\s\S]*?)<\/script(?:\s[^>]*)?>/gi;
  let match;
  while ((match = scriptRegex.exec(html)) !== null) {
    const attrs = match[0].slice(0, match[0].indexOf('>') + 1);
    const content = match[1];
    if (/\ssrc\s*=/i.test(attrs)) continue;
    if (!content.trim()) continue;
    const hash = createHash('sha256').update(content).digest('base64');
    hashes.add(`sha256-${hash}`);
    scriptCount++;
  }
}

walkDir(distDir);

if (hashes.size === 0) {
  console.error('FAIL: No inline scripts found in built HTML');
  process.exit(1);
}

const headers = readFileSync(headersFile, 'utf-8');
const cspMatch = headers.match(/script-src\s+([^;]+);/);
if (!cspMatch) {
  console.error('FAIL: No script-src directive found in _headers');
  process.exit(1);
}

const cspHashes = new Set(
  cspMatch[1]
    .trim()
    .split(/\s+/)
    .filter((h) => h.startsWith("'sha256-"))
    .map((h) => h.slice(1, -1)),
);

const missing = [...hashes].filter((h) => !cspHashes.has(h));
const extra = [...cspHashes].filter((h) => !hashes.has(h));

console.log(`Inline scripts: ${scriptCount} (${hashes.size} unique hashes)`);
console.log(`CSP script-src: ${cspHashes.size} hashes`);

if (missing.length > 0) {
  console.error(`\nFAIL: ${missing.length} inline script hash(es) missing from CSP:`);
  for (const h of missing) console.error(`  ${h}`);
}

if (extra.length > 0) {
  console.warn(`\nWARN: ${extra.length} CSP hash(es) not found in built HTML (likely externally injected, e.g. Cloudflare):`);
  for (const h of extra) console.warn(`  ${h}`);
}

if (missing.length > 0) {
  console.error('\nCSP hashes are out of sync with inline scripts.');
  console.error('Run `npm run build` to regenerate, then redeploy.');
  process.exit(1);
}

console.log('\nPASS: CSP hashes match inline scripts.');
