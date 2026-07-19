import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DOCS_ROOT = path.join(__dirname, '../src/content/docs');
const GITHUB_BASE = 'https://github.com/PC-Mender/sjrslms/blob/main';

const replacements = [
  {
    file: 'api/api-testing-collection.mdx',
    from: './sjrs-lms-api.postman_collection.json',
    to: `${GITHUB_BASE}/sjrs-lms-api.postman_collection.json`
  },
  {
    file: 'database/index.mdx',
    from: './d1-schema.sql',
    to: `${GITHUB_BASE}/sql/d1-schema.sql`
  },
  {
    file: 'development/refactoring-summaries/guests-refactoring.mdx',
    from: '../../database/d1-schema.sql',
    to: `${GITHUB_BASE}/sql/d1-schema.sql`
  },
  {
    file: 'development/reference-books-refactoring-summary.mdx',
    from: '../database/d1-schema.sql',
    to: `${GITHUB_BASE}/sql/d1-schema.sql`
  },
  {
    file: 'features/guests/index.mdx',
    from: '../../database/d1-schema.sql',
    to: `${GITHUB_BASE}/sql/d1-schema.sql`
  },
  {
    file: 'features/onboarding-status.mdx',
    from: 'e:\\GitHub\\sjrslms\\src\\constants\\user-status.ts',
    to: `${GITHUB_BASE}/src/constants/user-status.ts`
  },
  {
    file: 'features/onboarding-status.mdx',
    from: 'e:\\GitHub\\sjrslms\\functions\\api\\auth\\email-confirmation.ts',
    to: `${GITHUB_BASE}/functions/api/auth/email-confirmation.ts`
  },
  {
    file: 'features/onboarding-status.mdx',
    from: 'e:\\GitHub\\sjrslms\\src\\pages\\profile-completion\\hooks\\useProfileSubmission.ts',
    to: `${GITHUB_BASE}/src/pages/profile-completion/hooks/useProfileSubmission.ts`
  },
  {
    file: 'features/onboarding-status.mdx',
    from: 'e:\\GitHub\\sjrslms\\functions\\api\\users\\handlers\\update-user.ts',
    to: `${GITHUB_BASE}/functions/api/users/handlers/update-user.ts`
  },
  {
    file: 'features/users/status-data-dictionary.mdx',
    from: 'e:\\GitHub\\sjrslms\\src\\constants\\user-status.ts',
    to: `${GITHUB_BASE}/src/constants/user-status.ts`
  },
  {
    file: 'features/users/status-data-dictionary.mdx',
    from: 'e:\\GitHub\\sjrslms\\src\\utilities\\status\\status-utils.tsx',
    to: `${GITHUB_BASE}/src/utilities/status/status-utils.tsx`
  },
  {
    file: 'features/users/status-data-dictionary.mdx',
    from: 'e:\\GitHub\\sjrslms\\functions\\middleware\\validation\\schemas\\common-schemas.ts',
    to: `${GITHUB_BASE}/functions/middleware/validation/schemas/common-schemas.ts`
  }
];

let total = 0;
replacements.forEach(({ file, from, to }) => {
  const filePath = path.join(DOCS_ROOT, file);
  if (!fs.existsSync(filePath)) {
    console.log(`File not found: ${file}`);
    return;
  }
  const content = fs.readFileSync(filePath, 'utf8');
  const escapedFrom = from.replace(/[-/\\^$*+?.()|[\]{}]/g, '\\$&');
  const regex = new RegExp(`\\[([^\\]]+)\\]\\(${escapedFrom}\\)`, 'g');
  const updated = content.replace(regex, (match, text) => {
    total++;
    return `[${text}](${to})`;
  });
  if (updated !== content) {
    fs.writeFileSync(filePath, updated);
    console.log(`Fixed links in ${file}`);
  }
});

console.log(`\nTotal links fixed: ${total}`);
