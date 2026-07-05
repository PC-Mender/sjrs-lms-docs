import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

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
        SocialIcons: './src/components/SocialIcons.astro',
      },
      social: [
        { label: 'Open App', href: 'https://sjrslms.in', icon: 'external' },
        { label: 'GitHub', href: 'https://github.com/PC-Mender/sjrs-lms-docs', icon: 'github' },
      ],
      sidebar: [
        {
          label: 'Getting Started',
          collapsed: true,
          items: [{ autogenerate: { directory: 'getting-started' } }],
        },
        {
          label: 'User Guides',
          collapsed: true,
          items: [{ autogenerate: { directory: 'user-guides' } }],
        },
        {
          label: 'Features',
          collapsed: true,
          items: [{ autogenerate: { directory: 'features' } }],
        },
        {
          label: 'Architecture',
          collapsed: true,
          items: [{ autogenerate: { directory: 'architecture' } }],
        },
        {
          label: 'Development',
          collapsed: true,
          items: [{ autogenerate: { directory: 'development' } }],
        },
        {
          label: 'Deployment',
          collapsed: true,
          items: [{ autogenerate: { directory: 'deployment' } }],
        },
        {
          label: 'Security',
          collapsed: true,
          items: [{ autogenerate: { directory: 'security' } }],
        },
        {
          label: 'API',
          collapsed: true,
          items: [{ autogenerate: { directory: 'api' } }],
        },
        {
          label: 'Database',
          collapsed: true,
          items: [{ autogenerate: { directory: 'database' } }],
        },
        {
          label: 'Testing',
          collapsed: true,
          items: [{ autogenerate: { directory: 'testing' } }],
        },
        {
          label: 'Policies',
          collapsed: true,
          items: [{ autogenerate: { directory: 'policies' } }],
        },
        {
          label: 'Integrations',
          collapsed: true,
          items: [{ autogenerate: { directory: 'integrations' } }],
        },
        {
          label: 'Performance',
          collapsed: true,
          items: [{ autogenerate: { directory: 'performance' } }],
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
          items: [{ autogenerate: { directory: 'archive' } }],
        },
      ],
      head: [
        // NO SEO: Noindex, Nofollow
        { tag: 'meta', attrs: { name: 'robots', content: 'noindex, nofollow' } }
      ],
    }),
  ],
});
