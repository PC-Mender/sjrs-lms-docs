/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />
/// <reference path="../node_modules/@astrojs/starlight/virtual.d.ts" />

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
