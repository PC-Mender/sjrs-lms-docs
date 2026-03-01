
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DOCS_ROOT = path.join(__dirname, '../src/content/docs');

const fixes = {
  'api/api-response-standardization.md': [
    { from: '../development/error-handling.md', to: '../development/error-mapping.md' },
    { from: '../development/testing.md', to: '../development/testing-guide.md' }
  ],
  'api/functions-folder-architecture.md': [
    { from: '../../sql/index.md', to: '../database/index.md' }
  ],
  'api/quick-start-guide.md': [
    { from: '../index.md#session-management-api', to: '../development/session-management.md' }
  ],
  'api/superuser-endpoints.md': [
    { from: '../features/superuser-features-implementation.md', to: '../features/superuser/superuser-features-implementation.md' }
  ],
  'api/token-requirements.md': [
    { from: './development/ENHANCED_PERMISSION_SYSTEM.md', to: '../development/enhanced-permissions.md' },
    { from: './security/index.md', to: '../security/index.md' },
    { from: './deployment/D1_SETUP_GUIDE.md', to: '../deployment/d1-setup.md' },
    { from: './PERMISSION_SYSTEM_GUIDE.md', to: '../architecture/permission-system.md' }
  ],
  'architecture/index.md': [
    { from: '../features/permission-system.md', to: '../features/permissions/index.md' }
  ],
  'archive/deployment-workflow-organization.md': [
    { from: './unified-workers-deployment.md', to: '../deployment/unified-workers-deployment.md' },
    { from: './ci-cd-pipeline.md', to: '../deployment/version-and-release-management.md' },
    { from: './local-development.md', to: '../getting-started/setup.md' }
  ],
  'archive/index.md': [
    { from: '../architecture/refactoring-summary.md', to: '../development/refactoring-summary.md' }
  ],
  'changelog.md': [
    { from: '/architecture/routing-system/', to: '/architecture/routing-system' },
    { from: '/api/api-response-standardization/', to: '/api/api-response-standardization' },
    { from: '/api/functions-folder-architecture/', to: '/api/functions-folder-architecture' },
    { from: '/development/session-management/', to: '/development/session-management' },
    { from: '/features/multiple-device-login-detection/', to: '/features/multiple-device-login-detection' }
  ],
  'development/refactoring-summaries/guests-refactoring.md': [
    { from: '../../../sql/d1-schema.sql', to: '../../database/d1-schema.sql' }
  ],
  'development/reference-books-refactoring-summary.md': [
    { from: '../api/reference-books.md', to: '../features/reference-books/index.md' },
    { from: '../sql/d1-schema.sql', to: '../database/d1-schema.sql' }
  ],
  'features/badges/index.md': [
    { from: './action-logging.md', to: '../action-logging.md' },
    { from: './permissions/', to: '../permissions/' },
    { from: '../api/', to: '../../api/' }
  ],
  'features/email-service/enhanced-three-stage-process.md': [
    { from: '../user-management/index.md', to: '../../features/users/index.md' },
    { from: '../admin-dashboard/index.md', to: '../../features/superuser/index.md' },
    { from: '../security/index.md', to: '../../security/index.md' }
  ],
  'features/email-service/index.md': [
    { from: './direct-mailjet.md', to: '#-account-email-direct-mailjet' },
    { from: './queue-mailjet.md', to: '#-transactional-email-queue--mailjet' }
  ],
  'features/guests/index.md': [
    { from: '../../../sql/d1-schema.sql', to: '../../database/d1-schema.sql' }
  ],
  'features/notifications/EXTERNAL-SOURCES-CONFIGURATION.md': [
    { from: '../scripts/auto-version.js', to: '../../scripts/auto-version.js' },
    { from: '../../env.example', to: '../../env.example' } 
  ],
  'features/penalties/AUTOMATIC_PENALTY_CALCULATION.md': [
    { from: '../../development/scheduled-tasks.md', to: '../../deployment/index.md' }
  ],
  'features/superuser/index.md': [
    { from: '../development/roles-and-permissions.md', to: '../../development/roles-and-permissions.md' },
    { from: '../features/permissions/', to: '../permissions/' },
    { from: '../development/session-management.md', to: '../../development/session-management.md' }
  ],
  'index.mdx': [
    { from: '/getting-started/setup/', to: '/getting-started/setup' },
    { from: '/project-rules/', to: '/project-rules-docs' },
    { from: '/project-rules-app/', to: '/project-rules-app' },
    { from: '/documentation-standards/', to: '/documentation-standards' },
    { from: '/user-guides/help-system-guide/', to: '/user-guides/help-system-guide' },
    { from: '/features/mfa-system/', to: '/features/mfa-system' },
    { from: '/development/session-management/', to: '/development/session-management' },
    { from: '/api/token-requirements/', to: '/api/token-requirements' },
    { from: '/api/api-response-standardization/', to: '/api/api-response-standardization' },
    { from: '/status/', to: '/status' },
    { from: '/deployment/registration-troubleshooting/', to: '/deployment/registration-troubleshooting' },
    { from: '/changelog/', to: '/changelog' },
    { from: '/deployment/version-and-release-management/', to: '/deployment/version-and-release-management' },
    { from: '/documentation-review/', to: '/documentation-review' }
  ],
  'performance/cloudflare-web-analytics-setup.md': [
    { from: '../../index.html', to: '`index.html`' }
  ],
  'performance/implementation-2026-01-25.md': [
    { from: '../project-rules.md', to: '../project-rules-app.md' },
    { from: '../../index.html', to: '`index.html`' }
  ],
  'performance/system-logs-architecture-improvements.md': [
    { from: './security/system-logs-defense-in-depth.md', to: '../security/system-logs-defense-in-depth.md' }
  ],
  'performance/system-logs-performance-optimizations.md': [
    { from: './security/system-logs-defense-in-depth.md', to: '../security/system-logs-defense-in-depth.md' }
  ],
  'security/system-logs-retention-policy.md': [
    { from: './security/logging-standards.md', to: '../development/logging-system.md' },
    { from: './security/audit-log-policy.md', to: '../features/action-logging.md' },
    { from: './data-privacy-policy.md', to: '../security/index.md' },
    { from: './deployment/scheduled-tasks.md', to: '../deployment/index.md' }
  ],
  'user-guides/superuser-features-guide.md': [
    { from: '../features/superuser-features-implementation.md', to: '../features/superuser/superuser-features-implementation.md' }
  ],
  'development/validation-system.md': [
    { from: '../hooks/useInputValidation.md', to: '#react-hook-integration' },
    { from: '../api/validation.md', to: '../api/api-response-standardization.md' }
  ]
};

function fixDocLinks() {
  for (const [relativePath, replacements] of Object.entries(fixes)) {
    const filePath = path.join(DOCS_ROOT, relativePath);
    if (fs.existsSync(filePath)) {
      let content = fs.readFileSync(filePath, 'utf8');
      let originalContent = content;

      replacements.forEach(({ from, to }) => {
        // Escape special regex characters in 'from'
        const escapedFrom = from.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
        const regex = new RegExp(`\\[([^\\]]+)\\]\\(${escapedFrom}\\)`, 'g');
        content = content.replace(regex, `[$1](${to})`);
      });

      if (content !== originalContent) {
        fs.writeFileSync(filePath, content);
        console.log(`Fixed links in ${relativePath}`);
      }
    } else {
      console.log(`File not found: ${relativePath}`);
    }
  }
}

fixDocLinks();
