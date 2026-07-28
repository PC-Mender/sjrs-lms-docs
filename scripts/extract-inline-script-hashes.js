import { createHash } from 'node:crypto';
import { readFileSync, readdirSync, statSync, writeFileSync } from 'node:fs';
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
    hashes.add(`'sha256-${hash}'`);
    scriptCount++;
  }
}

walkDir(distDir);

const sortedHtmlHashes = [...hashes].sort();
console.log(`Found ${scriptCount} inline scripts across ${sortedHtmlHashes.length} unique hashes`);

if (sortedHtmlHashes.length === 0) {
  console.error('No inline scripts found — refusing to write empty script-src');
  process.exit(1);
}

let headers = readFileSync(headersFile, 'utf-8');

// Preserve externally-injected script hashes (e.g. Cloudflare challenge platform)
// that are already in the CSP but not present in the built HTML.
const cspMatch = headers.match(/script-src\s+([^;]+);/);
const existingCspHashes = new Set();
if (cspMatch) {
  for (const token of cspMatch[1].trim().split(/\s+/)) {
    if (token.startsWith("'sha256-") && token.endsWith("'")) {
      existingCspHashes.add(token);
    }
  }
}

const allHashes = new Set([...hashes, ...existingCspHashes]);
const sortedHashes = [...allHashes].sort();
const externalCount = sortedHashes.length - sortedHtmlHashes.length;

if (externalCount > 0) {
  console.log(`Preserving ${externalCount} external hash(es) from existing CSP`);
}

const hashList = sortedHashes.join(' ');
headers = headers.replace(
  /script-src '[^']*'(\s*'[^']*')*\s*;/,
  `script-src 'self' 'wasm-unsafe-eval' ${hashList};`
);
writeFileSync(headersFile, headers, 'utf-8');
console.log(`Updated ${headersFile} with ${sortedHashes.length} script-src hashes`);
