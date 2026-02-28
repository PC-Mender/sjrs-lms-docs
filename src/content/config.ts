import { defineCollection, z } from 'astro:content';
import { docsSchema } from '@astrojs/starlight/schema';

export const collections = {
	docs: defineCollection({
		schema: docsSchema({
			extend: z.object({
				lifecycle: z
					.enum(['Active', 'Needs Review', 'Deprecated', 'Archived'])
					.optional()
					.default('Active'),
			}),
		}),
	}),
};
