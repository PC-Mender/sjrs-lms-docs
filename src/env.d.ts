/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />

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
