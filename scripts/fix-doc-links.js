
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const DOCS_ROOT = path.join(__dirname, '../src/content/docs');

const fixes = {
  'api/api-response-standardization.mdx': [
    { from: '../development/error-handling.mdx', to: '../development/error-mapping.mdx' },
    { from: '../development/testing.mdx', to: '../development/testing-guide.mdx' }
  ],
  'api/functions-folder-architecture.mdx': [
    { from: '../../sql/index.mdx', to: '../database/index.mdx' }
  ],
  'api/quick-start-guide.mdx': [
    { from: '../index.mdx#session-management-api', to: '../development/session-management.mdx' }
  ],
  'api/superuser-endpoints.mdx': [
    { from: '../features/superuser-features-implementation.mdx', to: '../features/superuser/superuser-features-implementation.mdx' }
  ],
  'api/token-requirements.mdx': [
    { from: './development/ENHANCED_PERMISSION_SYSTEM.mdx', to: '../development/enhanced-permissions.mdx' },
    { from: './security/index.mdx', to: '../security/index.mdx' },
    { from: './deployment/D1_SETUP_GUIDE.mdx', to: '../deployment/d1-setup.mdx' },
    { from: './PERMISSION_SYSTEM_GUIDE.mdx', to: '../architecture/permission-system.mdx' }
  ],
  'architecture/index.mdx': [
    { from: '../features/permission-system.mdx', to: '../features/permissions/index.mdx' }
  ],
  'archive/deployment-workflow-organization.mdx': [
    { from: './unified-workers-deployment.mdx', to: '../deployment/unified-workers-deployment.mdx' },
    { from: './ci-cd-pipeline.mdx', to: '../deployment/version-and-release-management.mdx' },
    { from: './local-development.mdx', to: '../getting-started/setup.mdx' }
  ],
  'archive/index.mdx': [
    { from: '../architecture/refactoring-summary.mdx', to: '../development/refactoring-summary.mdx' }
  ],
  'changelog.mdx': [
    { from: '/architecture/routing-system/', to: '/architecture/routing-system' },
    { from: '/api/api-response-standardization/', to: '/api/api-response-standardization' },
    { from: '/api/functions-folder-architecture/', to: '/api/functions-folder-architecture' },
    { from: '/development/session-management/', to: '/development/session-management' },
    { from: '/features/multiple-device-login-detection/', to: '/features/multiple-device-login-detection' }
  ],
  'development/refactoring-summaries/guests-refactoring.mdx': [
    { from: '../../../sql/d1-schema.sql', to: '../../database/d1-schema.sql' }
  ],
  'development/reference-books-refactoring-summary.mdx': [
    { from: '../api/reference-books.mdx', to: '../features/reference-books/index.mdx' },
    { from: '../sql/d1-schema.sql', to: '../database/d1-schema.sql' }
  ],
  'features/badges/index.mdx': [
    { from: './action-logging.mdx', to: '../action-logging.mdx' },
    { from: './permissions/', to: '../permissions/' },
    { from: '../api/', to: '../../api/' }
  ],
  'features/email-service/enhanced-three-stage-process.mdx': [
    { from: '../user-management/index.mdx', to: '../../features/users/index.mdx' },
    { from: '../admin-dashboard/index.mdx', to: '../../features/superuser/index.mdx' },
    { from: '../security/index.mdx', to: '../../security/index.mdx' }
  ],
  'features/email-service/index.mdx': [
    { from: './direct-mailjet.mdx', to: '#-account-email-direct-mailjet' },
    { from: './queue-mailjet.mdx', to: '#-transactional-email-queue--mailjet' }
  ],
  'features/guests/index.mdx': [
    { from: '../../../sql/d1-schema.sql', to: '../../database/d1-schema.sql' }
  ],
  'features/notifications/EXTERNAL-SOURCES-CONFIGURATION.mdx': [
    { from: '../scripts/auto-version.js', to: '../../scripts/auto-version.js' },
    { from: '../../env.example', to: '../../env.example' } 
  ],
  'features/penalties/AUTOMATIC_PENALTY_CALCULATION.mdx': [
    { from: '../../development/scheduled-tasks.mdx', to: '../../deployment/index.mdx' }
  ],
  'features/superuser/index.mdx': [
    { from: '../development/roles-and-permissions.mdx', to: '../../development/roles-and-permissions.mdx' },
    { from: '../features/permissions/', to: '../permissions/' },
    { from: '../development/session-management.mdx', to: '../../development/session-management.mdx' }
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
  'performance/cloudflare-web-analytics-setup.mdx': [
    { from: '../../index.html', to: '`index.html`' }
  ],
  'performance/implementation-2026-01-25.mdx': [
    { from: '../project-rules.mdx', to: '../project-rules-app.mdx' },
    { from: '../../index.html', to: '`index.html`' }
  ],
  'performance/system-logs-architecture-improvements.mdx': [
    { from: './security/system-logs-defense-in-depth.mdx', to: '../security/system-logs-defense-in-depth.mdx' }
  ],
  'performance/system-logs-performance-optimizations.mdx': [
    { from: './security/system-logs-defense-in-depth.mdx', to: '../security/system-logs-defense-in-depth.mdx' }
  ],
  'security/system-logs-retention-policy.mdx': [
    { from: './security/logging-standards.mdx', to: '../development/logging-system.mdx' },
    { from: './security/audit-log-policy.mdx', to: '../features/action-logging.mdx' },
    { from: './data-privacy-policy.mdx', to: '../security/index.mdx' },
    { from: './deployment/scheduled-tasks.mdx', to: '../deployment/index.mdx' }
  ],
  'user-guides/superuser-features-guide.mdx': [
    { from: '../features/superuser-features-implementation.mdx', to: '../features/superuser/superuser-features-implementation.mdx' }
  ],
  'development/validation-system.mdx': [
    { from: '../hooks/useInputValidation.mdx', to: '#react-hook-integration' },
    { from: '../api/validation.mdx', to: '../api/api-response-standardization.mdx' }
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
