import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
// Adjust path to point to src/content/docs from scripts/ directory
const docsDir = path.resolve(__dirname, '../src/content/docs');

function toTitleCase(str) {
  // Remove extension
  const name = str.replace(/\.mdx?$/, '');
  
  // Handle special filenames
  if (name.toLowerCase() === 'readme' || name.toLowerCase() === 'index') {
    return 'Overview';
  }
  
  return name
    .split(/[-_]/)
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ');
}

function processDirectory(dir) {
  if (!fs.existsSync(dir)) {
    console.error(`Directory not found: ${dir}`);
    return;
  }

  const files = fs.readdirSync(dir);

  files.forEach(file => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);

    if (stat.isDirectory()) {
      processDirectory(filePath);
    } else if (file.endsWith('.md') || file.endsWith('.mdx')) {
      let content = fs.readFileSync(filePath, 'utf8');
      
      // Check if file already has frontmatter
      if (!content.trim().startsWith('---')) {
        const title = toTitleCase(file);
        const frontmatter = `---
title: "${title}"
---

`;
        fs.writeFileSync(filePath, frontmatter + content);
        console.log(`Added frontmatter to ${filePath}`);
      }
    }
  });
}

console.log(`Scanning docs directory: ${docsDir}`);
processDirectory(docsDir);
console.log('Finished processing documentation files.');
