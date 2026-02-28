import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const docsDir = path.resolve(__dirname, '../src/content/docs');

const allowed = new Set(['Active', 'Needs Review', 'Deprecated', 'Archived']);

function isArchivePath(filePath) {
  return filePath.split(path.sep).includes('archive');
}

function walk(dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const files = [];
  for (const entry of entries) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...walk(full));
      continue;
    }
    if (entry.isFile() && (entry.name.endsWith('.md') || entry.name.endsWith('.mdx'))) {
      files.push(full);
    }
  }
  return files;
}

function parseFrontmatter(source) {
  const trimmed = source.trimStart();
  if (!trimmed.startsWith('---')) return null;
  const start = trimmed.indexOf('---');
  const rest = trimmed.slice(start + 3);
  const end = rest.indexOf('\n---');
  if (end === -1) return null;
  const fmRaw = rest.slice(0, end).trim();

  // Minimal YAML parser for simple "key: value" lines.
  const obj = {};
  for (const line of fmRaw.split(/\r?\n/)) {
    const match = line.match(/^([A-Za-z0-9_-]+)\s*:\s*(.*)$/);
    if (!match) continue;
    const key = match[1];
    let value = match[2].trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    obj[key] = value;
  }

  return obj;
}

function toRepoRelative(filePath) {
  const rel = path.relative(path.resolve(__dirname, '..'), filePath);
  return rel.split(path.sep).join('/');
}

function main() {
  if (!fs.existsSync(docsDir)) {
    console.error(`Docs directory not found: ${docsDir}`);
    process.exit(2);
  }

  const files = walk(docsDir);
  const errors = [];

  for (const file of files) {
    const content = fs.readFileSync(file, 'utf8');
    const fm = parseFrontmatter(content);

    if (!fm) {
      errors.push(`${toRepoRelative(file)}: missing frontmatter`);
      continue;
    }

    const lifecycle = fm.lifecycle;

    if (!lifecycle) {
      continue;
    }

    if (!allowed.has(lifecycle)) {
      errors.push(`${toRepoRelative(file)}: invalid lifecycle '${lifecycle}' (allowed: ${Array.from(allowed).join(', ')})`);
      continue;
    }

    if (isArchivePath(file) && lifecycle !== 'Archived') {
      errors.push(`${toRepoRelative(file)}: archive pages must be lifecycle: Archived (found '${lifecycle}')`);
    }
  }

  if (errors.length > 0) {
    console.error('Lifecycle validation failed:');
    for (const err of errors) console.error(`- ${err}`);
    process.exit(1);
  }

  console.log(`Lifecycle validation passed for ${files.length} docs pages.`);
}

main();
