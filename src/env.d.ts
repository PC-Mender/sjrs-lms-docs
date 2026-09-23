/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />

declare module 'virtual:starlight/user-config' {
	const config: import('@astrojs/starlight/types').StarlightConfig;
	export default config;
}

interface ImportMetaEnv {
  readonly PUBLIC_DOCS_FEEDBACK_API_BASE_URL?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}

declare namespace App {
  interface Locals {
    starlightRoute: {
      entry: {
        data: {
          title: string;
        };
      };
      editUrl: URL;
    };
  }
}
