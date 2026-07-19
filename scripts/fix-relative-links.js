import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DOCS_ROOT = path.join(__dirname, '../src/content/docs');

function getAllFiles(dirPath, arrayOfFiles = []) {
  const files = fs.readdirSync(dirPath);
  files.forEach(file => {
    const fullPath = path.join(dirPath, file);
    if (fs.statSync(fullPath).isDirectory()) {
      getAllFiles(fullPath, arrayOfFiles);
    } else if (file.endsWith('.md') || file.endsWith('.mdx')) {
      arrayOfFiles.push(fullPath);
    }
  });
  return arrayOfFiles;
}

function pageUrlFromFile(file) {
  const rel = path.relative(DOCS_ROOT, file).replace(/\\/g, '/');
  const withoutExt = rel.replace(/\.mdx?$/, '');
  if (withoutExt.endsWith('/index')) {
    return '/' + withoutExt.replace(/\/index$/, '/');
  }
  return '/' + withoutExt + '/';
}

function resolveUrl(baseUrl, link) {
  if (link.startsWith('http') || link.startsWith('mailto:') || link.startsWith('#') || link.startsWith('/')) {
    return null;
  }
  const [pathPart] = link.split('#');
  if (!pathPart) return null;
  return new URL(pathPart, 'https://example.com' + baseUrl).pathname;
}

function fileExistsForUrl(urlPath) {
  const rel = urlPath.replace(/^\//, '');
  const base = path.join(DOCS_ROOT, rel.replace(/\//g, path.sep));
  const candidates = [
    base + '.md',
    base + '.mdx',
    path.join(base, 'index.md'),
    path.join(base, 'index.mdx')
  ];
  return candidates.find(p => fs.existsSync(p) && fs.statSync(p).isFile());
}

function normalizeToAbsolute(link, resolvedUrl) {
  const [pathPart, anchor] = link.split('#');
  const target = resolvedUrl.replace(/\/$/, '');
  return anchor ? `${target}#${anchor}` : target;
}

function findIntendedTarget(baseUrl, resolvedUrl) {
  // If resolvedUrl exists, it's already correct.
  if (fileExistsForUrl(resolvedUrl)) return resolvedUrl;

  // For cross-directory links like ../other-dir/page from /dir/sub/page/
  // resolvedUrl becomes /dir/sub/other-dir/page; try stripping leading dirs.
  const parts = resolvedUrl.replace(/^\//, '').split('/');
  for (let i = 1; i < parts.length; i++) {
    const candidate = '/' + parts.slice(i).join('/');
    if (fileExistsForUrl(candidate)) return candidate;
  }

  // For same-directory links like ./other-page from /dir/page/
  // resolvedUrl becomes /dir/page/other-page; replace the last segment.
  const baseParts = baseUrl.replace(/^\//, '').split('/').filter(Boolean);
  const targetName = resolvedUrl.replace(/^\//, '').split('/').pop();
  if (baseParts.length > 0 && targetName) {
    const candidate = '/' + [...baseParts.slice(0, -1), targetName].join('/');
    if (fileExistsForUrl(candidate)) return candidate;
  }

  return null;
}

function fixRelativeLinks() {
  const files = getAllFiles(DOCS_ROOT);
  let totalFixed = 0;

  files.forEach(file => {
    const original = fs.readFileSync(file, 'utf8');
    const baseUrl = pageUrlFromFile(file);
    const regex = /\[([^\]]+)\]\(([^)]+)\)/g;
    let changed = false;

    const updated = original.replace(regex, (match, text, link) => {
      const resolved = resolveUrl(baseUrl, link);
      if (resolved === null) return match;

      if (fileExistsForUrl(resolved)) return match;

      const intended = findIntendedTarget(baseUrl, resolved);
      if (intended) {
        const fixedLink = normalizeToAbsolute(link, intended);
        changed = true;
        totalFixed++;
        return `[${text}](${fixedLink})`;
      }

      // Could not auto-fix; leave as-is for manual review.
      return match;
    });

    if (updated !== original) {
      fs.writeFileSync(file, updated);
      console.log(`Fixed links in ${path.relative(DOCS_ROOT, file).replace(/\\/g, '/')}`);
    }
  });

  console.log(`\nTotal links fixed: ${totalFixed}`);
}

fixRelativeLinks();
