import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import rehypeExternalLinks from 'rehype-external-links';

// https://astro.build/config
export default defineConfig({
  site: 'https://docs.sjrslms.in',
  output: 'static',
  markdown: {
    rehypePlugins: [
      [
        rehypeExternalLinks,
        {
          target: '_blank',
          rel: ['noopener', 'noreferrer'],
        },
      ],
    ],
  },
  mdx: {
    rehypePlugins: [
      [
        rehypeExternalLinks,
        {
          target: '_blank',
          rel: ['noopener', 'noreferrer'],
        },
      ],
    ],
  },
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
          label: 'Glossary',
          slug: 'glossary',
        },
        {
          label: 'For Users',
          collapsed: true,
          items: [
            { autogenerate: { directory: 'user-guides' } },
            {
              label: 'Library Policies',
              collapsed: true,
              items: [{ autogenerate: { directory: 'policies' } }],
            },
          ],
        },
        {
          label: 'For Admins',
          collapsed: true,
          items: [{ autogenerate: { directory: 'admin-guides' } }],
        },
        {
          label: 'For Developers',
          collapsed: true,
          items: [
            {
              label: 'Project Rules',
              collapsed: true,
              items: [
                { label: 'Application Rules', slug: 'project-rules-app' },
                { label: 'Docs Site Rules', slug: 'project-rules-docs' },
                { label: 'Documentation Standards', slug: 'documentation-standards' },
              ],
            },
            {
              label: 'Architecture',
              collapsed: true,
              items: [{ autogenerate: { directory: 'architecture' } }],
            },
            {
              label: 'Development Guides',
              collapsed: true,
              items: [{ autogenerate: { directory: 'development' } }],
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
              label: 'Deployment',
              collapsed: true,
              items: [{ autogenerate: { directory: 'deployment' } }],
            },
            {
              label: 'Security',
              collapsed: true,
              items: [
                { label: 'Permission-Based Security', slug: 'permission-based-security' },
                { autogenerate: { directory: 'security' } },
              ],
            },
            {
              label: 'Testing',
              collapsed: true,
              items: [
                { label: 'Quality Gates Guide', slug: 'quality-gates-guide' },
                { autogenerate: { directory: 'testing' } },
              ],
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
          ],
        },
        {
          label: 'Changelog',
          slug: 'changelog',
        },
      ],
      head: [
        { tag: 'link', attrs: { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' } },
        { tag: 'link', attrs: { rel: 'icon', type: 'image/png', sizes: '32x32', href: '/favicon-32x32.png' } },
        { tag: 'link', attrs: { rel: 'icon', type: 'image/png', sizes: '16x16', href: '/favicon-16x16.png' } },
        { tag: 'link', attrs: { rel: 'apple-touch-icon', sizes: '180x180', href: '/apple-touch-icon.png' } },
        { tag: 'link', attrs: { rel: 'manifest', href: '/site.webmanifest' } },
        { tag: 'meta', attrs: { name: 'theme-color', content: '#0056d2' } },
      ],
    }),
  ],
});
