import { defineCollection, z } from 'astro:content';
import { docsSchema } from '@astrojs/starlight/schema';
import { glob } from 'astro/loaders';

const docs = defineCollection({
	loader: glob({ pattern: '**/[^_]*.{md,mdx}', base: './src/content/docs' }),
	schema: docsSchema({
		extend: z.object({
			lifecycle: z
				.enum(['Active', 'Needs Review', 'Deprecated', 'Archived'])
				.optional()
				.default('Active'),
		}),
	}),
});

export const collections = {
	docs,
};
