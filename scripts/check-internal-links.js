
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DOCS_ROOT = path.join(__dirname, '../src/content/docs');

function getAllFiles(dirPath, arrayOfFiles = []) {
  const files = fs.readdirSync(dirPath);

  files.forEach(function(file) {
    const fullPath = path.join(dirPath, file);
    if (fs.statSync(fullPath).isDirectory()) {
      getAllFiles(fullPath, arrayOfFiles);
    } else {
      if (file.endsWith('.md') || file.endsWith('.mdx')) {
        arrayOfFiles.push(fullPath);
      }
    }
  });

  return arrayOfFiles;
}

function resolveLink(sourceFile, link) {
  // Ignore external links, anchors, and mailto
  if (link.startsWith('http') || link.startsWith('mailto:') || link.startsWith('#')) {
    return null;
  }

  // Handle absolute paths starting with /
  let targetPath;
  const linkWithoutAnchor = link.split('#')[0];

  if (!linkWithoutAnchor) {
    // Just an anchor link within the same page
    return { exists: true, path: sourceFile };
  }

  if (linkWithoutAnchor.startsWith('/')) {
    // Absolute path relative to docs root
    // For Starlight/Astro, / usually maps to the root of the site (src/content/docs)
    targetPath = path.join(DOCS_ROOT, linkWithoutAnchor);
  } else {
    // Relative path
    targetPath = path.resolve(path.dirname(sourceFile), linkWithoutAnchor);
  }

  // Check possible file extensions and index files
  const possibilities = [
    targetPath,
    targetPath + '.md',
    targetPath + '.mdx',
    path.join(targetPath, 'index.md'),
    path.join(targetPath, 'index.mdx')
  ];

  for (const p of possibilities) {
    if (fs.existsSync(p) && fs.statSync(p).isFile()) {
      return { exists: true, path: p };
    }
  }

  return { exists: false, path: targetPath, possibilities };
}

function checkLinks() {
  console.log(`Checking links in ${DOCS_ROOT}...`);
  const files = getAllFiles(DOCS_ROOT);
  let brokenLinks = [];

  files.forEach(file => {
    const content = fs.readFileSync(file, 'utf8');
    // Regex to capture [text](url)
    // Be careful with nested brackets or parentheses, but basic md links are [text](url)
    const regex = /\[([^\]]+)\]\(([^)]+)\)/g;
    let match;

    while ((match = regex.exec(content)) !== null) {
      const text = match[1];
      const link = match[2];
      
      const result = resolveLink(file, link);
      
      if (result && !result.exists) {
        brokenLinks.push({
          file: path.relative(DOCS_ROOT, file),
          text,
          link,
          resolvedPath: result.path
        });
      }
    }
  });

  if (brokenLinks.length > 0) {
    const reportPath = path.join(__dirname, 'broken-links.txt');
    let report = `Found ${brokenLinks.length} broken links:\n\n`;
    brokenLinks.forEach(item => {
      report += `File: ${item.file}\n`;
      report += `  Link Text: [${item.text}]\n`;
      report += `  Target: (${item.link})\n`;
      report += `  Resolved to: ${item.resolvedPath}\n`;
      report += '---\n';
    });
    fs.writeFileSync(reportPath, report);
    console.log(`Report written to ${reportPath}`);
  } else {
    console.log('No broken links found.');
  }
}

checkLinks();
