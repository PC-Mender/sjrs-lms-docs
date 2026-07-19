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
  // e.g. src/content/docs/getting-started/end-users.mdx -> /getting-started/end-users/
  const rel = path.relative(DOCS_ROOT, file).replace(/\\/g, '/');
  const withoutExt = rel.replace(/\.mdx?$/, '');
  if (withoutExt.endsWith('/index')) {
    return '/' + withoutExt.replace(/\/index$/, '/') ;
  }
  return '/' + withoutExt + '/';
}

function resolveUrl(baseUrl, link) {
  if (link.startsWith('http') || link.startsWith('mailto:') || link.startsWith('#')) return null;
  if (link.startsWith('/')) return link.split('#')[0];
  const [pathPart] = link.split('#');
  if (!pathPart) return baseUrl;
  return new URL(pathPart, 'https://example.com' + baseUrl).pathname;
}

function isPublicAsset(urlPath) {
  return urlPath.startsWith('/images/') || urlPath.startsWith('/assets/');
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
  return candidates.some(p => fs.existsSync(p) && fs.statSync(p).isFile());
}

function checkRelativeLinks() {
  const files = getAllFiles(DOCS_ROOT);
  const broken = [];

  files.forEach(file => {
    const content = fs.readFileSync(file, 'utf8');
    const regex = /\[([^\]]+)\]\(([^)]+)\)/g;
    const baseUrl = pageUrlFromFile(file);
    let match;

    while ((match = regex.exec(content)) !== null) {
      const text = match[1];
      const link = match[2];
      const resolved = resolveUrl(baseUrl, link);
      if (resolved === null) continue;
      if (isPublicAsset(resolved)) continue;
      if (!fileExistsForUrl(resolved)) {
        broken.push({
          file: path.relative(DOCS_ROOT, file).replace(/\\/g, '/'),
          text,
          link,
          resolvedUrl: resolved
        });
      }
    }
  });

  if (broken.length > 0) {
    console.log(`Found ${broken.length} broken relative links (with trailing-slash URL resolution):\n`);
    broken.forEach(item => {
      console.log(`File: ${item.file}`);
      console.log(`  Link Text: [${item.text}]`);
      console.log(`  Target: (${item.link})`);
      console.log(`  Resolves to: ${item.resolvedUrl}`);
      console.log('---');
    });
    process.exitCode = 1;
  } else {
    console.log('No broken relative links found.');
  }
}

checkRelativeLinks();
