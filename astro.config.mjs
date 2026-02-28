import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import react from '@astrojs/react';

// https://astro.build/config
export default defineConfig({
  site: 'https://docs.sjrslms.in',
  output: 'static',
  integrations: [
    starlight({
      title: 'SJRS LMS Docs',
      customCss: ['./src/styles/custom.css'],
      editLink: {
        baseUrl: 'https://github.com/PC-Mender/sjrs-lms-docs/edit/main/',
      },
      tableOfContents: {
        minHeadingLevel: 2,
        maxHeadingLevel: 4,
      },
      components: {
        Banner: './src/components/LifecycleBanner.astro',
        Footer: './src/components/CustomFooter.astro',
      },
      social: [
        { label: 'Open App', href: 'https://sjrslms.in', icon: 'external' },
        { label: 'GitHub', href: 'https://github.com/PC-Mender/sjrs-lms-docs', icon: 'github' },
      ],
      sidebar: [
        {
          label: 'Getting Started',
          collapsed: true,
          autogenerate: { directory: 'getting-started' },
        },
        {
          label: 'User Guides',
          collapsed: true,
          autogenerate: { directory: 'user-guides' },
        },
        {
          label: 'Features',
          collapsed: true,
          autogenerate: { directory: 'features' },
        },
        {
          label: 'Architecture',
          collapsed: true,
          autogenerate: { directory: 'architecture' },
        },
        {
          label: 'Development',
          collapsed: true,
          autogenerate: { directory: 'development' },
        },
        {
          label: 'Deployment',
          collapsed: true,
          autogenerate: { directory: 'deployment' },
        },
        {
          label: 'Security',
          collapsed: true,
          autogenerate: { directory: 'security' },
        },
        {
          label: 'API',
          collapsed: true,
          autogenerate: { directory: 'api' },
        },
        {
          label: 'Database',
          collapsed: true,
          autogenerate: { directory: 'database' },
        },
        {
          label: 'Testing',
          collapsed: true,
          autogenerate: { directory: 'testing' },
        },
        {
          label: 'Policies',
          collapsed: true,
          autogenerate: { directory: 'policies' },
        },
        {
          label: 'Integrations',
          collapsed: true,
          autogenerate: { directory: 'integrations' },
        },
        {
          label: 'Performance',
          collapsed: true,
          autogenerate: { directory: 'performance' },
        },
        {
          label: 'System Status',
          slug: 'status',
        },
        {
          label: 'Changelog',
          slug: 'changelog',
        },
        {
          label: 'Project Rules',
          slug: 'project-rules',
        },
        {
          label: 'Archive',
          collapsed: true,
          autogenerate: { directory: 'archive' },
        },
      ],
      head: [
        // NO SEO: Noindex, Nofollow
        { tag: 'meta', attrs: { name: 'robots', content: 'noindex, nofollow' } }
      ],
    }),
    react(),
  ],
});
