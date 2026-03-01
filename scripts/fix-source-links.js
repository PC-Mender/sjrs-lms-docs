
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

function fixSourceLinks() {
  const files = getAllFiles(DOCS_ROOT);
  let count = 0;

  files.forEach(file => {
    let content = fs.readFileSync(file, 'utf8');
    let originalContent = content;

    // Fix x:\GitHub\sjrslms links
    // Pattern: [text](x:\GitHub\sjrslms\path\to\file)
    // We want to change it to `path/to/file`
    content = content.replace(/\[([^\]]+)\]\(x:\\GitHub\\sjrslms\\([^\)]+)\)/g, (match, text, url) => {
      const normalizedUrl = url.replace(/\\/g, '/');
      return `\`${normalizedUrl}\``;
    });

    // Fix src/ links (relative or absolute)
    // Pattern: [text](../src/path/to/file) or [text](src/path/to/file)
    // We want to change it to `src/path/to/file`
    // Match anything ending in .ts, .tsx, .js, .json inside the parentheses if it looks like a source file
    // Also allow optional anchor like #L123 at the end
    content = content.replace(/\[([^\]]+)\]\((?:(?:\.\.\/)+)?src\/([^\)]+)\)/g, (match, text, url) => {
        // Remove anchor for extension check
        const urlNoAnchor = url.split('#')[0];
        // Only if it looks like a code file
        if (urlNoAnchor.match(/\.(ts|tsx|js|json|css|scss)$/)) {
            return `\`src/${url}\``;
        }
        return match;
    });

    // Also fix functions/ links
    content = content.replace(/\[([^\]]+)\]\((?:(?:\.\.\/)+)?functions\/([^\)]+)\)/g, (match, text, url) => {
         const urlNoAnchor = url.split('#')[0];
         if (urlNoAnchor.match(/\.(ts|tsx|js|json)$/)) {
            return `\`functions/${url}\``;
        }
        return match;
    });
    
    // Fix .github links
    content = content.replace(/\[([^\]]+)\]\((?:(?:\.\.\/)+)?\.github\/([^\)]+)\)/g, (match, text, url) => {
        return `\`${text}\` (.github/${url})`;
    });

    if (content !== originalContent) {
      fs.writeFileSync(file, content);
      console.log(`Fixed links in ${path.relative(DOCS_ROOT, file)}`);
      count++;
    }
  });

  console.log(`Fixed source links in ${count} files.`);
}

fixSourceLinks();
