# Changelog

All notable changes to this project will be documented in this file. See [commit-and-tag-version](https://github.com/absolute-version/commit-and-tag-version) for commit guidelines.

## 1.8.0 (2026-07-29)

### Features

* **assets:** add favicon and web app manifest ([d55f211](https://github.com/PC-Mender/sjrs-lms-docs/commit/d55f211303d1a05ac1eb19d6b6dff29340c5f889))
* Begin with standard versioning ([fe66eab](https://github.com/PC-Mender/sjrs-lms-docs/commit/fe66eab88681312daeb486a6c49a4af222df509e))
* **docs:** add comprehensive user registration documentation ([587cb08](https://github.com/PC-Mender/sjrs-lms-docs/commit/587cb083c0e4466ff456aedbe83d47f88c5c7d95))
* **docs:** add comprehensive v6.x documentation for enhanced user dashboard and system notifications ([7449265](https://github.com/PC-Mender/sjrs-lms-docs/commit/744926515d8448544f911b5bbb0f84f0d2052914))
* **feedback:** add page feedback widget and Cloudflare Worker backend ([a65420d](https://github.com/PC-Mender/sjrs-lms-docs/commit/a65420df689d4bbcc67178ee49ba99e96f62655a))
* **security:** add security headers for static docs site and feedback worker ([f2ee6d1](https://github.com/PC-Mender/sjrs-lms-docs/commit/f2ee6d1f9812a81811cb377a14522e450e19259e))

### Bug Fixes

* add wasm-unsafe-eval to CSP script-src for Pagefind WASM ([ff6a878](https://github.com/PC-Mender/sjrs-lms-docs/commit/ff6a878024b334b83cc6bdf501cdce2c5eb6cd68))
* Broken links fixed ([4d90d1c](https://github.com/PC-Mender/sjrs-lms-docs/commit/4d90d1cf18c7f1eea32e37caad95df07000b288e))
* **deploy:** add root wrangler.toml for static assets deployment ([6e2f4c5](https://github.com/PC-Mender/sjrs-lms-docs/commit/6e2f4c5caa045effb53aa03fdc13001073286ae5))
* **deployment:** configure custom domain, 404 handling, and SEO for docs site ([f359615](https://github.com/PC-Mender/sjrs-lms-docs/commit/f359615c14df3d833d5d64476fd6cd0ed6826bde))
* **deps:** resolve remaining npm audit alerts ([001871e](https://github.com/PC-Mender/sjrs-lms-docs/commit/001871ee8e9c0549e5f22209d741090cb1265952))
* **deps:** resolve Vite security vulnerabilities (CVE-2025-XXXX) ([1cbb6d1](https://github.com/PC-Mender/sjrs-lms-docs/commit/1cbb6d16390603bf2b0b1cdc8a8b1381600a4e30))
* **deps:** upgrade vulnerable packages to secure versions ([c648271](https://github.com/PC-Mender/sjrs-lms-docs/commit/c648271a21d07521117f26c8a5f0f1524d80f7d4)), references [#46](https://github.com/PC-Mender/sjrs-lms-docs/issues/46) [#43](https://github.com/PC-Mender/sjrs-lms-docs/issues/43) [#48](https://github.com/PC-Mender/sjrs-lms-docs/issues/48) [#42](https://github.com/PC-Mender/sjrs-lms-docs/issues/42) [#49](https://github.com/PC-Mender/sjrs-lms-docs/issues/49) [#44](https://github.com/PC-Mender/sjrs-lms-docs/issues/44) [#50](https://github.com/PC-Mender/sjrs-lms-docs/issues/50) [#45](https://github.com/PC-Mender/sjrs-lms-docs/issues/45)
* **deps:** upgrade vulnerable transitive deps ([1947a3b](https://github.com/PC-Mender/sjrs-lms-docs/commit/1947a3ba8ddc528554d1b07b71ff543e9601eade))
* **docs:** add getting-started glossary and repair links ([020b107](https://github.com/PC-Mender/sjrs-lms-docs/commit/020b107ce71549cd7fc9886976a84a40cdffa79c))
* **docs:** correct 404 page to document docs site instead of React app ([158cfb8](https://github.com/PC-Mender/sjrs-lms-docs/commit/158cfb825c1998f4d3db31b5ee2d25fa1f5b1dc4))
* **docs:** move setup guide to developers section ([e90c2df](https://github.com/PC-Mender/sjrs-lms-docs/commit/e90c2df2e4ea45a77e34fabec9010896a37a4214))
* **docs:** normalize internal links and add glossary redirects ([71f5db6](https://github.com/PC-Mender/sjrs-lms-docs/commit/71f5db6118a79392cfdf79a308e724f985a9dd84))
* **docs:** remove duplicate account types section in registration guide ([3e65d3f](https://github.com/PC-Mender/sjrs-lms-docs/commit/3e65d3f0c38af3d83c5b6e7c0274d73f684ffbfc))
* **docs:** remove duplicate email confirmation section in registration guide ([675bc7a](https://github.com/PC-Mender/sjrs-lms-docs/commit/675bc7a0965d84f7cbffdbee22e57e6bd5945890))
* **docs:** remove duplicate H1 heading in registration guide ([be850a7](https://github.com/PC-Mender/sjrs-lms-docs/commit/be850a748a9adfa87f7ea141b3529ba1355a8e31))
* **docs:** remove setup guide from getting started quick resources ([740e91e](https://github.com/PC-Mender/sjrs-lms-docs/commit/740e91e73c84477153b891f08f42c5f19bf55776))
* **docs:** resolve broken internal links across docs site ([9e4d470](https://github.com/PC-Mender/sjrs-lms-docs/commit/9e4d4708b69687579025758782ad0a0fc4d3aba0))
* expose version_changed output for release job ([0970f56](https://github.com/PC-Mender/sjrs-lms-docs/commit/0970f5654983f8cc73e4cbc9a61df64832ee7a43))
* **feedback:** remove card styling on vote buttons and add optimistic UI ([2a76ec0](https://github.com/PC-Mender/sjrs-lms-docs/commit/2a76ec00f7cee1b65207f576cd46f3904fe6521d))
* handle Cloudflare-injected script hash and prevent stale CSP cache ([0300005](https://github.com/PC-Mender/sjrs-lms-docs/commit/030000531373ba4dc1bb74aec1c9884e1f8c8249))
* lychee link check on built HTML and feedback widget UI ([70a6c2e](https://github.com/PC-Mender/sjrs-lms-docs/commit/70a6c2e4ff6a5e09a68fc0407c7e5226e695ddfe))
* remove broken link to non-existent professors module ([10631e4](https://github.com/PC-Mender/sjrs-lms-docs/commit/10631e4763b997a61e762083906c1569c37e3a60))
* remove duplicate social links and as-any cast in SocialIcons ([4cd57f6](https://github.com/PC-Mender/sjrs-lms-docs/commit/4cd57f6ddc297e5840cadd67cde0da7f52844ca7))
* replace node:fs with Vite JSON import in CustomFooter for Cloudflare Workers compatibility ([b7afd97](https://github.com/PC-Mender/sjrs-lms-docs/commit/b7afd97595784f4ea7ce90b0bc10dcf397836c35))
* resolve CodeQL bad-tag-filter alert in inline script hash extractor ([1870d88](https://github.com/PC-Mender/sjrs-lms-docs/commit/1870d8806244f1f6e1a6a50008f4c03382b2ec03))
* **security:** eliminate TOCTOU race condition in feedback rate limiter ([7bd9221](https://github.com/PC-Mender/sjrs-lms-docs/commit/7bd92219357979fde5dae51f8ad984e5a115b5e7))
* **security:** replace unsafe-inline in script-src with SHA256 hashes ([76876ee](https://github.com/PC-Mender/sjrs-lms-docs/commit/76876ee5f00ce48a8986417d20365c147a52a66f))
* switch script-src to unsafe-inline to handle Cloudflare dynamic injection ([bba9258](https://github.com/PC-Mender/sjrs-lms-docs/commit/bba9258ebad8a15122ca5623c333b2726f6be1ae))

### Documentation

* add 17 comprehensive user guides for all app features ([f85010d](https://github.com/PC-Mender/sjrs-lms-docs/commit/f85010d7cf317f75e3ab3eb9de69a7847c742fba))
* add complete historical changelog from v1.0.0 ([a5c3f3e](https://github.com/PC-Mender/sjrs-lms-docs/commit/a5c3f3e626ac5ceb464d1035b8459cb7a40a67a2))
* add comprehensive fixes applied summary ([e50cf1f](https://github.com/PC-Mender/sjrs-lms-docs/commit/e50cf1f57760960b35975d2af03719a20ab7e30d))
* add comprehensive instant-close modal migration guide for developers ([2ba89b2](https://github.com/PC-Mender/sjrs-lms-docs/commit/2ba89b20b709405415f943218d5abb14cfe1bf65))
* add data fetching guide, loans refactoring summary, and update query migration details ([0e7c9be](https://github.com/PC-Mender/sjrs-lms-docs/commit/0e7c9be5fbc18ff7ee4cb16248091411a12c1d1f))
* add dependency update summary ([a2738c5](https://github.com/PC-Mender/sjrs-lms-docs/commit/a2738c5319122bf11b106dcedbb3c795c355dc31))
* add faqs content ([5b0c604](https://github.com/PC-Mender/sjrs-lms-docs/commit/5b0c604bf7c7aae28c2867e4ea4890f67578f961))
* add missing index pages for documentation sections ([8179cc9](https://github.com/PC-Mender/sjrs-lms-docs/commit/8179cc90140809fc768ae6422b4ca42372acea10))
* add missing v5.0.0 and v5.0.1 release information to changelog ([67f9f0c](https://github.com/PC-Mender/sjrs-lms-docs/commit/67f9f0c7b38ebc26330dde7c3e3983822b1ff65f))
* Add security policy for vulnerability reporting ([ea5cea9](https://github.com/PC-Mender/sjrs-lms-docs/commit/ea5cea93f1fd38be6581c140e12b82023d6c6e35))
* add v6.0.0 release documentation and instant-close modal pattern guide ([f692094](https://github.com/PC-Mender/sjrs-lms-docs/commit/f69209433e38d871f2c5734d9b495840edbc04d5))
* align auth, CSRF, and superuser testing ([83617ea](https://github.com/PC-Mender/sjrs-lms-docs/commit/83617ea34b04488ce3d38785fa59e691d07a6c34))
* align onboarding workflow and help system\n\n- Update Account Management to new onboarding statuses\n- Simplify Help System Guide with keyboard shortcut and external links\n- Update changelog for 3.52.0, 3.51.x\n- Add onboarding-status reference and status data dictionary\n- Minor doc index adjustments ([1d2b04c](https://github.com/PC-Mender/sjrs-lms-docs/commit/1d2b04ca291cb5c767acda9ce878f94b3f3ad9ec))
* **api:** update API docs with v1 prefix and Zod validation patterns ([7fde674](https://github.com/PC-Mender/sjrs-lms-docs/commit/7fde674cfc29710105e3848a0be77f7f372c7844))
* **architecture:** sync architecture docs with current app state ([b29f105](https://github.com/PC-Mender/sjrs-lms-docs/commit/b29f105f3690fd38d46cfb78b1dea2faf6edcb40))
* **development:** update development docs with API v1 prefix ([100b1e0](https://github.com/PC-Mender/sjrs-lms-docs/commit/100b1e0b816b31dcc573daaa6a692c4d1f31ef9b))
* document feedback worker setup and npm scripts ([af2ba38](https://github.com/PC-Mender/sjrs-lms-docs/commit/af2ba38d10ed262092b8449f7b86f60a80e06ec2))
* **features:** update feature docs with API v1 prefix ([3e8d6b3](https://github.com/PC-Mender/sjrs-lms-docs/commit/3e8d6b34fa8d7ffacbae1abeb1af55497e569b85))
* fix capitalized titles and redundant h1 headings ([38f3b2f](https://github.com/PC-Mender/sjrs-lms-docs/commit/38f3b2ff1bdb9d6c727f17ac38bebc33da8a33ca))
* fix duplicate content on badges page, add reservations overview, update homepage and footer text ([89484ad](https://github.com/PC-Mender/sjrs-lms-docs/commit/89484ad73c3a59efdb50ef7bafed80d533e807c3))
* **homepage:** refine card headings and links for clarity ([47da032](https://github.com/PC-Mender/sjrs-lms-docs/commit/47da0325ee0694d2700a27349ec501a7d5d492e6))
* include guest end-user guidance ([6127eab](https://github.com/PC-Mender/sjrs-lms-docs/commit/6127eab5f2e346c3d89a8058f0734cd699667ffb))
* migrate content to mdx ([4c752e5](https://github.com/PC-Mender/sjrs-lms-docs/commit/4c752e544c7e460ae9b369cf637700817b4e0f52))
* **project-rules:** sync project-rules-app with latest project-rules.md ([2fc3ac7](https://github.com/PC-Mender/sjrs-lms-docs/commit/2fc3ac7696598b7278de25bf25971c1478814ad8))
* reduce emoji usage ([d717304](https://github.com/PC-Mender/sjrs-lms-docs/commit/d717304f2ca706aa10c8074e25b67dceb573b3d3))
* **release:** document 6.3.x rollout and bump CI node ([2e27f77](https://github.com/PC-Mender/sjrs-lms-docs/commit/2e27f77bb26c6a5045c17d7de8ebf967c2ea1264))
* remove hyphens from sidebar headings ([caf16de](https://github.com/PC-Mender/sjrs-lms-docs/commit/caf16de1714af292346fa15bb1778bd4a6c715f0))
* remove internal architectural info and replace sensitive values with placeholders ([cd97f8e](https://github.com/PC-Mender/sjrs-lms-docs/commit/cd97f8e3743aee45ac4e11aa5e715dca4e540229))
* remove temporary audit and documentation files ([28229b4](https://github.com/PC-Mender/sjrs-lms-docs/commit/28229b499adf81ad78e5f920cca44c0924bebff9))
* remove unnecessary bold markers from headings ([88c12e6](https://github.com/PC-Mender/sjrs-lms-docs/commit/88c12e6ac6fdd2b3c0c3efc1eb63b4a6c480adf1))
* sanitize base URLs and secrets ([22be046](https://github.com/PC-Mender/sjrs-lms-docs/commit/22be046b03c0676f3d520f72cc09a2b1b84507c7))
* **security:** update security and deployment docs with API v1 prefix ([85fd40a](https://github.com/PC-Mender/sjrs-lms-docs/commit/85fd40ad4a02ae79cdb5c05eb1182d9b4f47b8df))
* sync docs site with app v6.19.1 ([df9808c](https://github.com/PC-Mender/sjrs-lms-docs/commit/df9808c9732ef0677ee36e9c7de77e52b33c9d1d))
* sync v7.27.0 feature docs and fix internal links ([5d3d6b4](https://github.com/PC-Mender/sjrs-lms-docs/commit/5d3d6b4ce64b197b52c0ff168258768830ba7750))
* update API docs for v4.0.0 and clarify wishlist priority ([0c22198](https://github.com/PC-Mender/sjrs-lms-docs/commit/0c221981c2854ecb8151ca26c2b2a90a09f21eb2))
* update changelog and full-changelog to v8.2.2 ([503fb27](https://github.com/PC-Mender/sjrs-lms-docs/commit/503fb27b83c1f2a99359115e2a7507f10922744b))
* update changelog for v3.50.3, add full changelog, and fix internal links ([a94a011](https://github.com/PC-Mender/sjrs-lms-docs/commit/a94a011b8a4004d4ab32423efcdc60ab29fdda25))
* update content ([0c3b36a](https://github.com/PC-Mender/sjrs-lms-docs/commit/0c3b36a3b68a8b4d020d546785db9238929827f1))
* update documentation for v3.49.0 release ([c0040e5](https://github.com/PC-Mender/sjrs-lms-docs/commit/c0040e56a5d418b63cbce65b086223b2b580b1ef))
* update email trigger matrix and related docs ([bf8c881](https://github.com/PC-Mender/sjrs-lms-docs/commit/bf8c881ace001064df0889aa6ce07524c2dd9e43))
* update feature documentation for v4.0.1/v4.0.2 changes ([c4df031](https://github.com/PC-Mender/sjrs-lms-docs/commit/c4df0316ad3f6fba172acfd71712b1c295dbf738))
* update GitHub repository references from PC-Mender to PC-Mender ([5173c9a](https://github.com/PC-Mender/sjrs-lms-docs/commit/5173c9a55e24e3b78bd839b4ffe765f9e7a4f77c))
* update project rules documentation formatting ([9354e73](https://github.com/PC-Mender/sjrs-lms-docs/commit/9354e7383a48c38a6a106e6db8914813457a8382))
* update routing, changelog, auth flow, and project rules for June 2026 ([56f5ee4](https://github.com/PC-Mender/sjrs-lms-docs/commit/56f5ee4bfc860f0ec07065407e108451f8405499))
* update to auth workflow ([ea97b5d](https://github.com/PC-Mender/sjrs-lms-docs/commit/ea97b5d57d1919165675f085bb4855e249861325))
* **user-guides:** add registration and first-login flow illustrations ([1b65158](https://github.com/PC-Mender/sjrs-lms-docs/commit/1b65158517d42803cbcfb5949c5f6a5040f44a32))
* **user-guides:** update documentation for request cart workflow and borrow request tracking ([993fd64](https://github.com/PC-Mender/sjrs-lms-docs/commit/993fd64a4eefcb8a171cb6aa30e55541a759b119))

### Styling

* remove unnecessary !important declarations and empty media query blocks ([f3707a4](https://github.com/PC-Mender/sjrs-lms-docs/commit/f3707a49bacc8fd4b1492e0d93f99e4e9dcf5484))
* update version label format in footer ([91451be](https://github.com/PC-Mender/sjrs-lms-docs/commit/91451be3b2da4cc7f052639a4065198fbc571383))

### Performance Improvements

* add version visibility in footer ([6ef1674](https://github.com/PC-Mender/sjrs-lms-docs/commit/6ef1674cea68eb21a207881803b22f7bd568d230))
* improvements to doc functionality & updated docs ([a99cef3](https://github.com/PC-Mender/sjrs-lms-docs/commit/a99cef3fd70cbde8b9dc7b6f50fc82ecd97c52c6))

### Build System

* remove unused packages, update starlight, replace deprecated standard-version ([4df61bf](https://github.com/PC-Mender/sjrs-lms-docs/commit/4df61bf35b680ff74aa15b3384723844d0a924a8))

### CI

* add CSP hash validation to quality gates ([53b5f6c](https://github.com/PC-Mender/sjrs-lms-docs/commit/53b5f6c6eafe876dd0ec4b331bd0e12b6b8224bc))
* type-check feedback worker in CI and IDE ([9ab90ad](https://github.com/PC-Mender/sjrs-lms-docs/commit/9ab90adc52c7b3f134c1858775304360e67dd91e))
## [1.7.1](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.7.0...v1.7.1) (2026-07-29)
## 1.7.0 (2026-07-29)

### Features

* **assets:** add favicon and web app manifest ([5cec191](https://github.com/PC-Mender/sjrs-lms-docs/commit/5cec191c88140ac0fdf6fe6a8a43fd4a2ef6da64))
* Begin with standard versioning ([f2ec426](https://github.com/PC-Mender/sjrs-lms-docs/commit/f2ec426576b246639b7d1268f059fdf3b72ec11c))
* **docs:** add comprehensive user registration documentation ([3e2e536](https://github.com/PC-Mender/sjrs-lms-docs/commit/3e2e536d7e2f68f92f88f5d0e474bcb318174f9a))
* **docs:** add comprehensive v6.x documentation for enhanced user dashboard and system notifications ([5be2b1b](https://github.com/PC-Mender/sjrs-lms-docs/commit/5be2b1bcf5829abcda31877750abbce3176f4aab))
* **feedback:** add page feedback widget and Cloudflare Worker backend ([58c874a](https://github.com/PC-Mender/sjrs-lms-docs/commit/58c874a25d0db97beebecd6e17ac013c21b9a45a))
* **security:** add security headers for static docs site and feedback worker ([63d533d](https://github.com/PC-Mender/sjrs-lms-docs/commit/63d533d88143d1c3f679545ee8b591ba78d1491f))

### Bug Fixes

* add wasm-unsafe-eval to CSP script-src for Pagefind WASM ([f5fe428](https://github.com/PC-Mender/sjrs-lms-docs/commit/f5fe428395d98d137096218c9f8974eee92a40ee))
* Broken links fixed ([dfdb18a](https://github.com/PC-Mender/sjrs-lms-docs/commit/dfdb18aceb846b4cf434d41638e6fd3e46c33a3e))
* correct GitHub org from PC-Mender to PC-Mender in all URL references ([c367b38](https://github.com/PC-Mender/sjrs-lms-docs/commit/c367b38a1264cfc4110d379a3e6bbc59c3170564))
* **deploy:** add root wrangler.toml for static assets deployment ([685bfb5](https://github.com/PC-Mender/sjrs-lms-docs/commit/685bfb536398baf589be0bc5beb3ecfba383d64f))
* **deployment:** configure custom domain, 404 handling, and SEO for docs site ([cc24e25](https://github.com/PC-Mender/sjrs-lms-docs/commit/cc24e25ec92e3cd69740cc3b0f09ea7ae78c0b67))
* **deps:** resolve remaining npm audit alerts ([9b78c2f](https://github.com/PC-Mender/sjrs-lms-docs/commit/9b78c2faa9739ec4d01ef235c1b0b6c5daa9cf66))
* **deps:** resolve Vite security vulnerabilities (CVE-2025-XXXX) ([ae44b9a](https://github.com/PC-Mender/sjrs-lms-docs/commit/ae44b9a76fadc3be87f6fcceb12d28375fefb41e))
* **deps:** upgrade vulnerable packages to secure versions ([3280c1d](https://github.com/PC-Mender/sjrs-lms-docs/commit/3280c1d2be7ee3222042005c91cd1ea4ea03fdd4)), references [#46](https://github.com/PC-Mender/sjrs-lms-docs/issues/46) [#43](https://github.com/PC-Mender/sjrs-lms-docs/issues/43) [#48](https://github.com/PC-Mender/sjrs-lms-docs/issues/48) [#42](https://github.com/PC-Mender/sjrs-lms-docs/issues/42) [#49](https://github.com/PC-Mender/sjrs-lms-docs/issues/49) [#44](https://github.com/PC-Mender/sjrs-lms-docs/issues/44) [#50](https://github.com/PC-Mender/sjrs-lms-docs/issues/50) [#45](https://github.com/PC-Mender/sjrs-lms-docs/issues/45)
* **deps:** upgrade vulnerable transitive deps ([50b9ead](https://github.com/PC-Mender/sjrs-lms-docs/commit/50b9ead8b9b3ed1953c71c15e618928f0e462a05))
* **docs:** add getting-started glossary and repair links ([bc02b40](https://github.com/PC-Mender/sjrs-lms-docs/commit/bc02b40e6ae3e3d83b67d6372801de1b9a379b9c))
* **docs:** correct 404 page to document docs site instead of React app ([9eb2800](https://github.com/PC-Mender/sjrs-lms-docs/commit/9eb2800ddd81baf4fc1726a96835dc4c7a2f45fa))
* **docs:** move setup guide to developers section ([4299cf4](https://github.com/PC-Mender/sjrs-lms-docs/commit/4299cf4b4830832a3a9404adf71d532876105691))
* **docs:** normalize internal links and add glossary redirects ([ca2d0d1](https://github.com/PC-Mender/sjrs-lms-docs/commit/ca2d0d18c947fcee01001dce9b42ca9a60af1eb1))
* **docs:** remove duplicate account types section in registration guide ([0615fea](https://github.com/PC-Mender/sjrs-lms-docs/commit/0615fea47473f314f257412ba295803e8318ca0d))
* **docs:** remove duplicate email confirmation section in registration guide ([368e411](https://github.com/PC-Mender/sjrs-lms-docs/commit/368e411fd5619c768fa56ea6249e4178acccb211))
* **docs:** remove duplicate H1 heading in registration guide ([f2f4941](https://github.com/PC-Mender/sjrs-lms-docs/commit/f2f4941f7ac4eb6678c16cd876bf13dd04297f37))
* **docs:** remove setup guide from getting started quick resources ([bdf1fec](https://github.com/PC-Mender/sjrs-lms-docs/commit/bdf1fecdacec6e5398505dc287ab2ec53c8656bd))
* **docs:** resolve broken internal links across docs site ([8f006bb](https://github.com/PC-Mender/sjrs-lms-docs/commit/8f006bb57f57c15c4aafefb938f4098e75127042))
* expose version_changed output for release job ([0d12161](https://github.com/PC-Mender/sjrs-lms-docs/commit/0d121610ee6e07f45029f067b50ea043ff439ffc))
* **feedback:** remove card styling on vote buttons and add optimistic UI ([059a5b3](https://github.com/PC-Mender/sjrs-lms-docs/commit/059a5b3d35660b29861c5cda97b4a9bbf2c6b936))
* handle Cloudflare-injected script hash and prevent stale CSP cache ([7c1ab09](https://github.com/PC-Mender/sjrs-lms-docs/commit/7c1ab09c31eb5acf80be0cbe08705096c579d19a))
* lychee link check on built HTML and feedback widget UI ([9f45def](https://github.com/PC-Mender/sjrs-lms-docs/commit/9f45def3e05b1bd8c40557c68b5d3ffb7069a5f6))
* remove broken link to non-existent professors module ([7f6b1de](https://github.com/PC-Mender/sjrs-lms-docs/commit/7f6b1de1b712a7f08ae9cc76d068255e37a1f099))
* remove duplicate social links and as-any cast in SocialIcons ([78ce8a8](https://github.com/PC-Mender/sjrs-lms-docs/commit/78ce8a8e9951e2937c4d5a4d817fef435d3f0fc0))
* replace node:fs with Vite JSON import in CustomFooter for Cloudflare Workers compatibility ([80dd84d](https://github.com/PC-Mender/sjrs-lms-docs/commit/80dd84dc83667707b15c62e6ee7ce022106b0323))
* resolve CodeQL bad-tag-filter alert in inline script hash extractor ([2747620](https://github.com/PC-Mender/sjrs-lms-docs/commit/2747620842ed4494db467b3dc2e56e4010692fef))
* **security:** eliminate TOCTOU race condition in feedback rate limiter ([69a4539](https://github.com/PC-Mender/sjrs-lms-docs/commit/69a453942fa3bcb8e91a1788f5fc8ce3c170f53d))
* **security:** replace unsafe-inline in script-src with SHA256 hashes ([6f70f0d](https://github.com/PC-Mender/sjrs-lms-docs/commit/6f70f0da8e56f8b999bcbc4972a244057da9a681))
* switch script-src to unsafe-inline to handle Cloudflare dynamic injection ([dd19d0e](https://github.com/PC-Mender/sjrs-lms-docs/commit/dd19d0edb547c1f2d1784d10bdcb4a14d3f85cf4))

### Documentation

* add 17 comprehensive user guides for all app features ([e332107](https://github.com/PC-Mender/sjrs-lms-docs/commit/e3321072cb28f012c26d7ba95b2955d9a5b577a8))
* add complete historical changelog from v1.0.0 ([05295f8](https://github.com/PC-Mender/sjrs-lms-docs/commit/05295f85f087571cbc1eba4406c07cd8e0b38e06))
* add comprehensive fixes applied summary ([46a2bdb](https://github.com/PC-Mender/sjrs-lms-docs/commit/46a2bdbe15c91033fb1d306286aba37600e0aff2))
* add comprehensive instant-close modal migration guide for developers ([4d0d5b4](https://github.com/PC-Mender/sjrs-lms-docs/commit/4d0d5b48a8ac0e3fb69c693ada04b88366aec6ca))
* add data fetching guide, loans refactoring summary, and update query migration details ([5aa978b](https://github.com/PC-Mender/sjrs-lms-docs/commit/5aa978bf556442597a6428888d6988f8be38176f))
* add dependency update summary ([f7d3ada](https://github.com/PC-Mender/sjrs-lms-docs/commit/f7d3adae3a4aefec35e496866a09f3b972accbb2))
* add faqs content ([c101172](https://github.com/PC-Mender/sjrs-lms-docs/commit/c1011725eebf4db52e5f7c02c6352eae1cd3cdde))
* add missing index pages for documentation sections ([9941f63](https://github.com/PC-Mender/sjrs-lms-docs/commit/9941f639af97c3751cfccb90a8d299e612801aff))
* add missing v5.0.0 and v5.0.1 release information to changelog ([008f6b1](https://github.com/PC-Mender/sjrs-lms-docs/commit/008f6b155c4ae01663c74087102fb2d6a6c2077f))
* Add security policy for vulnerability reporting ([eef3ad6](https://github.com/PC-Mender/sjrs-lms-docs/commit/eef3ad61246a38f5b499dd19556c6bb84388c28c))
* add v6.0.0 release documentation and instant-close modal pattern guide ([c2e73ab](https://github.com/PC-Mender/sjrs-lms-docs/commit/c2e73ab6fc005f15ddda97bbe5277bc141df6e46))
* align auth, CSRF, and superuser testing ([75edc64](https://github.com/PC-Mender/sjrs-lms-docs/commit/75edc64ef96cb49c68e3ed9ce5f2f5432c95b7de))
* align onboarding workflow and help system\n\n- Update Account Management to new onboarding statuses\n- Simplify Help System Guide with keyboard shortcut and external links\n- Update changelog for 3.52.0, 3.51.x\n- Add onboarding-status reference and status data dictionary\n- Minor doc index adjustments ([f1c24ec](https://github.com/PC-Mender/sjrs-lms-docs/commit/f1c24ec3137b5495c9e4568229ca28c8baa9603e))
* **api:** update API docs with v1 prefix and Zod validation patterns ([cf3ab3e](https://github.com/PC-Mender/sjrs-lms-docs/commit/cf3ab3e42afe37089832665487ceb5cbcf5fe5ef))
* **architecture:** sync architecture docs with current app state ([6091f07](https://github.com/PC-Mender/sjrs-lms-docs/commit/6091f079f074acd8294b0126909376abcda853a9))
* **development:** update development docs with API v1 prefix ([a3dde5b](https://github.com/PC-Mender/sjrs-lms-docs/commit/a3dde5bf20f42ec4c5169f402f593bdd217d37c3))
* document feedback worker setup and npm scripts ([04c7bf0](https://github.com/PC-Mender/sjrs-lms-docs/commit/04c7bf0a11bf7e206e6135c0159007339e0f671b))
* **features:** update feature docs with API v1 prefix ([0dac0b5](https://github.com/PC-Mender/sjrs-lms-docs/commit/0dac0b54937f00b64e4628ba01342b3386ce3df0))
* fix capitalized titles and redundant h1 headings ([7e719f1](https://github.com/PC-Mender/sjrs-lms-docs/commit/7e719f11e7a5a7e965ed12cd5f1e88be9294aefc))
* fix duplicate content on badges page, add reservations overview, update homepage and footer text ([0231293](https://github.com/PC-Mender/sjrs-lms-docs/commit/023129353c7aa7a8161ca758bec8bc90fa2fdf80))
* **homepage:** refine card headings and links for clarity ([ac95d4f](https://github.com/PC-Mender/sjrs-lms-docs/commit/ac95d4fb17fc9e50c7a2c5558850732e80c12059))
* include guest end-user guidance ([2597f15](https://github.com/PC-Mender/sjrs-lms-docs/commit/2597f1558c003d9b344be264384cd33988515f33))
* migrate content to mdx ([02d0685](https://github.com/PC-Mender/sjrs-lms-docs/commit/02d06853da5a7e44995b71e1a1bd86fb17672346))
* **project-rules:** sync project-rules-app with latest project-rules.md ([201acb7](https://github.com/PC-Mender/sjrs-lms-docs/commit/201acb7afaf7e72328fdb3cdac6fbb13868d3c91))
* reduce emoji usage ([63d4b00](https://github.com/PC-Mender/sjrs-lms-docs/commit/63d4b003db44b48c8c52df2f92b8b7e587a7496d))
* **release:** document 6.3.x rollout and bump CI node ([70cd45b](https://github.com/PC-Mender/sjrs-lms-docs/commit/70cd45bb626ccce98ae47abbde9d309e165e5446))
* remove hyphens from sidebar headings ([8a438be](https://github.com/PC-Mender/sjrs-lms-docs/commit/8a438be5c01868ba8a794825b2e8ccd7af6af544))
* remove internal architectural info and replace sensitive values with placeholders ([72eb8fa](https://github.com/PC-Mender/sjrs-lms-docs/commit/72eb8faea543192faa216a74c884bbfe09fec166))
* remove temporary audit and documentation files ([da4bc69](https://github.com/PC-Mender/sjrs-lms-docs/commit/da4bc6912204387ff2fea2d94c2b57171f56540c))
* remove unnecessary bold markers from headings ([049acc2](https://github.com/PC-Mender/sjrs-lms-docs/commit/049acc245f0fc2a829f429bbf06eb8658910ac92))
* sanitize base URLs and secrets ([98248f1](https://github.com/PC-Mender/sjrs-lms-docs/commit/98248f123e7bf8865f741a4c2f3e08ca60f0d9cb))
* **security:** update security and deployment docs with API v1 prefix ([ceafeaf](https://github.com/PC-Mender/sjrs-lms-docs/commit/ceafeaf83b108cb717c1a1e1f1c31a80bd086453))
* sync docs site with app v6.19.1 ([dc74a69](https://github.com/PC-Mender/sjrs-lms-docs/commit/dc74a69a63a285826d8646a6f7f5cd59751990bf))
* sync v7.27.0 feature docs and fix internal links ([bbbe072](https://github.com/PC-Mender/sjrs-lms-docs/commit/bbbe072d913f67360f37fdbdd88b8b83b30aa449))
* update API docs for v4.0.0 and clarify wishlist priority ([4c4ec14](https://github.com/PC-Mender/sjrs-lms-docs/commit/4c4ec1438af15a84864ba7a2a18982262a145a39))
* update changelog and full-changelog to v8.2.2 ([6b362cc](https://github.com/PC-Mender/sjrs-lms-docs/commit/6b362cc2c3f32773c2510aa1e84590bffb01e545))
* update changelog for v3.50.3, add full changelog, and fix internal links ([ca878ed](https://github.com/PC-Mender/sjrs-lms-docs/commit/ca878ed9bf82e2bac14a5a70e31da86358f6cd69))
* update content ([790a722](https://github.com/PC-Mender/sjrs-lms-docs/commit/790a722f796602b5103aa8c53c297b2cf26cab39))
* update documentation for v3.49.0 release ([1392771](https://github.com/PC-Mender/sjrs-lms-docs/commit/13927710ffa551750fc6d9d5549c59627a1a9cb1))
* update email trigger matrix and related docs ([e15ce30](https://github.com/PC-Mender/sjrs-lms-docs/commit/e15ce3015be0fa389b2ab8b6a713da074fbfcbb6))
* update feature documentation for v4.0.1/v4.0.2 changes ([fa5a982](https://github.com/PC-Mender/sjrs-lms-docs/commit/fa5a98235ca8e4193f444db99c815c4bd7e617e3))
* update GitHub repository references from PC-Mender to PC-Mender ([8a5dae7](https://github.com/PC-Mender/sjrs-lms-docs/commit/8a5dae72f005a13b5678631d65108a2a7e4209da))
* update project rules documentation formatting ([c756e29](https://github.com/PC-Mender/sjrs-lms-docs/commit/c756e298ff78e5e9f0e64f747617f98fba4bcfcc))
* update routing, changelog, auth flow, and project rules for June 2026 ([8a83fcf](https://github.com/PC-Mender/sjrs-lms-docs/commit/8a83fcf4cb7106bc099fff08af685e239293a23c))
* update to auth workflow ([1d46303](https://github.com/PC-Mender/sjrs-lms-docs/commit/1d4630389e5eac166185a709b40e05bd45c6f8b8))
* **user-guides:** add registration and first-login flow illustrations ([7495cd7](https://github.com/PC-Mender/sjrs-lms-docs/commit/7495cd7a1fde352c6cbaf1302720ec4ce768547f))
* **user-guides:** update documentation for request cart workflow and borrow request tracking ([a0f96d6](https://github.com/PC-Mender/sjrs-lms-docs/commit/a0f96d6744ccf4dafb4f96edbfb9505453895c8c))

### Styling

* remove unnecessary !important declarations and empty media query blocks ([13faf1b](https://github.com/PC-Mender/sjrs-lms-docs/commit/13faf1bad07edef6a5cf31391178a5ac8dd3f33b))
* update version label format in footer ([0a5dfa0](https://github.com/PC-Mender/sjrs-lms-docs/commit/0a5dfa0524d06ad38d9cf2054ad023743df63e19))

### Performance Improvements

* add version visibility in footer ([b28e1ee](https://github.com/PC-Mender/sjrs-lms-docs/commit/b28e1ee1bea1146f3295ea93bc29dbd903a24476))
* improvements to doc functionality & updated docs ([4a589c0](https://github.com/PC-Mender/sjrs-lms-docs/commit/4a589c0c82f2681955cbb1bd96297315e43a1da5))

### Build System

* remove unused packages, update starlight, replace deprecated standard-version ([211f7af](https://github.com/PC-Mender/sjrs-lms-docs/commit/211f7afd644c90a7ed21087bfee07832be0d358b))

### CI

* add CSP hash validation to quality gates ([13555e8](https://github.com/PC-Mender/sjrs-lms-docs/commit/13555e8fb18f0a55a2ea87f77ccc16e66b9e6290))
* type-check feedback worker in CI and IDE ([f975b65](https://github.com/PC-Mender/sjrs-lms-docs/commit/f975b65543009e74d62f9fc8c2e3168b5dd1d0f7))
## [1.6.7](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.6.6...v1.6.7) (2026-07-28)

### Bug Fixes

* switch script-src to unsafe-inline to handle Cloudflare dynamic injection ([795fb73](https://github.com/PC-Mender/sjrs-lms-docs/commit/795fb73384664877f057ede1d7832ea262ff1916))
## [1.6.6](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.6.5...v1.6.6) (2026-07-28)

### Bug Fixes

* handle Cloudflare-injected script hash and prevent stale CSP cache ([e15dfc7](https://github.com/PC-Mender/sjrs-lms-docs/commit/e15dfc7d2e8179ac401196c9bff12b45e600ef25))
## [1.6.5](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.6.4...v1.6.5) (2026-07-28)

### Bug Fixes

* add wasm-unsafe-eval to CSP script-src for Pagefind WASM ([b424d94](https://github.com/PC-Mender/sjrs-lms-docs/commit/b424d94539290c81ad0616f06010b6a02b12540f))
## [1.6.4](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.6.3...v1.6.4) (2026-07-28)

### CI

* add CSP hash validation to quality gates ([5f10bf0](https://github.com/PC-Mender/sjrs-lms-docs/commit/5f10bf0324972eb7fcd4af8df2cdc625c3b95dfa))
## [1.6.3](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.6.2...v1.6.3) (2026-07-28)

### Documentation

* **api:** update API docs with v1 prefix and Zod validation patterns ([5e1c59f](https://github.com/PC-Mender/sjrs-lms-docs/commit/5e1c59fcfa8e4ae62410d2b82c4aea1da25aa350))
* **architecture:** sync architecture docs with current app state ([84b6267](https://github.com/PC-Mender/sjrs-lms-docs/commit/84b6267b4503f562c03f2f474cb3f581a0efc642))
* **development:** update development docs with API v1 prefix ([6e570b6](https://github.com/PC-Mender/sjrs-lms-docs/commit/6e570b60849778313da1c99b635678b72a39bdf2))
* **features:** update feature docs with API v1 prefix ([e649fde](https://github.com/PC-Mender/sjrs-lms-docs/commit/e649fdecf281ebff668170e9e24267ac27104f06))
* **project-rules:** sync project-rules-app with latest project-rules.md ([23a999a](https://github.com/PC-Mender/sjrs-lms-docs/commit/23a999a77b7744ccd82fa99a8c20df3e3d272dd3))
* **security:** update security and deployment docs with API v1 prefix ([ee91157](https://github.com/PC-Mender/sjrs-lms-docs/commit/ee91157b037c5d0e733c0d8b582238672c92a888))
## [1.6.2](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.6.1...v1.6.2) (2026-07-28)

### Bug Fixes

* remove duplicate social links and as-any cast in SocialIcons ([409e1e4](https://github.com/PC-Mender/sjrs-lms-docs/commit/409e1e4aeaed7999c099f01b833ef560ec4e2e05))
* resolve CodeQL bad-tag-filter alert in inline script hash extractor ([ace0b53](https://github.com/PC-Mender/sjrs-lms-docs/commit/ace0b53d4928574cb5d42d2a5d73ac052c096ef2))
* **security:** eliminate TOCTOU race condition in feedback rate limiter ([f46a682](https://github.com/PC-Mender/sjrs-lms-docs/commit/f46a682a03f7efa9d01361388be2e3b2a58e9bf3))

### Styling

* remove unnecessary !important declarations and empty media query blocks ([f15ca6b](https://github.com/PC-Mender/sjrs-lms-docs/commit/f15ca6bf67bc5ec28deeb249954727b490cd4c21))

### CI

* type-check feedback worker in CI and IDE ([f43803e](https://github.com/PC-Mender/sjrs-lms-docs/commit/f43803ec25d3795e94d1d35d2b94f11204585d59))
## [1.6.1](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.6.0...v1.6.1) (2026-07-27)

### Bug Fixes

* **docs:** correct 404 page to document docs site instead of React app ([d46e3eb](https://github.com/PC-Mender/sjrs-lms-docs/commit/d46e3eb93c919b39c25b9ac14cffaab3b4f3d1e0))
* **security:** replace unsafe-inline in script-src with SHA256 hashes ([aeb1e54](https://github.com/PC-Mender/sjrs-lms-docs/commit/aeb1e5466c4b2c6ec12e6f1daba0abba54dc74e8))
## [1.6.0](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.5.5...v1.6.0) (2026-07-27)

### Features

* **security:** add security headers for static docs site and feedback worker ([35a5bd9](https://github.com/PC-Mender/sjrs-lms-docs/commit/35a5bd9bc815e6758fe0404d85700fd9718812e5))

### Bug Fixes

* correct GitHub org from PC-Mender to PC-Mender in all URL references ([1e24767](https://github.com/PC-Mender/sjrs-lms-docs/commit/1e24767048eb1657440ac0cb39604c9ac8ae5d1f))
* **deployment:** configure custom domain, 404 handling, and SEO for docs site ([18816bc](https://github.com/PC-Mender/sjrs-lms-docs/commit/18816bc210044e58cd7c73bfc18f74ad6ec0b6d8))
## [1.5.5](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.5.4...v1.5.5) (2026-07-27)

### Bug Fixes

* **deps:** upgrade vulnerable packages to secure versions ([5a0ed0f](https://github.com/PC-Mender/sjrs-lms-docs/commit/5a0ed0f273d8cdc7166c39a5317fac3491e98262)), references [#46](https://github.com/PC-Mender/sjrs-lms-docs/issues/46) [#43](https://github.com/PC-Mender/sjrs-lms-docs/issues/43) [#48](https://github.com/PC-Mender/sjrs-lms-docs/issues/48) [#42](https://github.com/PC-Mender/sjrs-lms-docs/issues/42) [#49](https://github.com/PC-Mender/sjrs-lms-docs/issues/49) [#44](https://github.com/PC-Mender/sjrs-lms-docs/issues/44) [#50](https://github.com/PC-Mender/sjrs-lms-docs/issues/50) [#45](https://github.com/PC-Mender/sjrs-lms-docs/issues/45)
## [1.5.4](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.5.3...v1.5.4) (2026-07-27)

### Bug Fixes

* **feedback:** remove card styling on vote buttons and add optimistic UI ([9cca8b3](https://github.com/PC-Mender/sjrs-lms-docs/commit/9cca8b361950227d25590a3ec8845a6d82992b2d))
## [1.5.3](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.5.2...v1.5.3) (2026-07-27)
## [1.5.2](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.5.1...v1.5.2) (2026-07-27)

### Bug Fixes

* lychee link check on built HTML and feedback widget UI ([8da509a](https://github.com/PC-Mender/sjrs-lms-docs/commit/8da509a40270d977629ca8bfa99f6e47e7d0e609))
## [1.5.1](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.5.0...v1.5.1) (2026-07-27)

### Bug Fixes

* **deploy:** add root wrangler.toml for static assets deployment ([c9d6bc1](https://github.com/PC-Mender/sjrs-lms-docs/commit/c9d6bc193b6e0177b53bef1c4b79633d80be85bc))
## [1.5.0](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.4.3...v1.5.0) (2026-07-27)

### Features

* **feedback:** add page feedback widget and Cloudflare Worker backend ([b374587](https://github.com/PC-Mender/sjrs-lms-docs/commit/b374587c74f16e5965576225aa67394be9876710))

### Documentation

* document feedback worker setup and npm scripts ([346915c](https://github.com/PC-Mender/sjrs-lms-docs/commit/346915ce724ed04e795eee2e56bb7c51cc33d374))
## [1.4.3](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.4.2...v1.4.3) (2026-07-21)

### Documentation

* **user-guides:** update documentation for request cart workflow and borrow request tracking ([e5a9432](https://github.com/PC-Mender/sjrs-lms-docs/commit/e5a9432b3e8f1883b4bc1624785902bd1b943731))
## [1.4.2](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.4.1...v1.4.2) (2026-07-20)

### Documentation

* **homepage:** refine card headings and links for clarity ([0752771](https://github.com/PC-Mender/sjrs-lms-docs/commit/07527718e2865330af466b6d4e07f4c5ff7640a0))
* remove unnecessary bold markers from headings ([5c4026e](https://github.com/PC-Mender/sjrs-lms-docs/commit/5c4026eb55e70aa36376fe05cdd650b377b0cfed))
## [1.4.1](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.4.0...v1.4.1) (2026-07-19)

### Bug Fixes

* **docs:** resolve broken internal links across docs site ([7637f65](https://github.com/PC-Mender/sjrs-lms-docs/commit/7637f65190476744a00b6074fe8ced60826b52d7))
## [1.4.0](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.23...v1.4.0) (2026-07-19)

### Features

* **assets:** add favicon and web app manifest ([399be59](https://github.com/PC-Mender/sjrs-lms-docs/commit/399be5949f7bdc397446cadf59499d32db723db4))
## [1.3.23](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.22...v1.3.23) (2026-07-19)
## [1.3.22](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.21...v1.3.22) (2026-07-19)

### Documentation

* **user-guides:** add registration and first-login flow illustrations ([103d3eb](https://github.com/PC-Mender/sjrs-lms-docs/commit/103d3ebc8079e5cecd2d986a5bbdcfc499166873))
## [1.3.21](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.20...v1.3.21) (2026-07-19)

### Documentation

* sync v7.27.0 feature docs and fix internal links ([03498b3](https://github.com/PC-Mender/sjrs-lms-docs/commit/03498b3c03cb08a834688500fedca307cebc56d0))
## [1.3.20](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.19...v1.3.20) (2026-07-05)


### Documentation

* fix duplicate content on badges page, add reservations overview, update homepage and footer text ([8307185](https://github.com/PC-Mender/sjrs-lms-docs/commit/830718506420ba7a68b1e31aa49e046bd10895f0))


### Build System

* remove unused packages, update starlight, replace deprecated standard-version ([f41e3fc](https://github.com/PC-Mender/sjrs-lms-docs/commit/f41e3fcf147222f2030d6cc12a280c0ff17bb759))

### [1.3.19](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.18...v1.3.19) (2026-07-03)


### Bug Fixes

* replace node:fs with Vite JSON import in CustomFooter for Cloudflare Workers compatibility ([aaf3c48](https://github.com/PC-Mender/sjrs-lms-docs/commit/aaf3c48d8e576a550a63841a2c7bd9b0f91e3fb0))

### [1.3.18](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.17...v1.3.18) (2026-07-03)


### Documentation

* add 17 comprehensive user guides for all app features ([58258ff](https://github.com/PC-Mender/sjrs-lms-docs/commit/58258ff91f8d26bd4c67098756b18af47e6e4a45))
* update GitHub repository references from PC-Mender to PC-Mender ([c3585c0](https://github.com/PC-Mender/sjrs-lms-docs/commit/c3585c052986b0e414ea5fe64a351bb334fd6b92))

### [1.3.17](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.16...v1.3.17) (2026-06-30)


### Documentation

* update routing, changelog, auth flow, and project rules for June 2026 ([8bc3198](https://github.com/PC-Mender/sjrs-lms-docs/commit/8bc31986db030ef97e78be19a5f35a9201771a9d))

### [1.3.16](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.15...v1.3.16) (2026-05-26)

### [1.3.15](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.14...v1.3.15) (2026-04-14)


### Bug Fixes

* **deps:** resolve Vite security vulnerabilities (CVE-2025-XXXX) ([f713d4a](https://github.com/PC-Mender/sjrs-lms-docs/commit/f713d4ad6af36006860b6f9cf1231e49ac25fe52))

### [1.3.14](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.13...v1.3.14) (2026-04-14)

### [1.3.13](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.12...v1.3.13) (2026-04-14)


### Documentation

* Add security policy for vulnerability reporting ([baf1cde](https://github.com/PC-Mender/sjrs-lms-docs/commit/baf1cde688a9740b61cb5a3cefb3bec69e1ecc05))

### [1.3.12](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.11...v1.3.12) (2026-04-04)


### Documentation

* sync docs site with app v6.19.1 ([f9a3af0](https://github.com/PC-Mender/sjrs-lms-docs/commit/f9a3af06fd7aff88160a868f25f799ab3dcdd95f))

### [1.3.11](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.10...v1.3.11) (2026-04-04)


### Bug Fixes

* **deps:** resolve remaining npm audit alerts ([7261d69](https://github.com/PC-Mender/sjrs-lms-docs/commit/7261d69cc89110266948f8bdd9beea9e338c204d))

### [1.3.10](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.9...v1.3.10) (2026-04-04)


### Bug Fixes

* **deps:** upgrade vulnerable transitive deps ([1de772a](https://github.com/PC-Mender/sjrs-lms-docs/commit/1de772addcba3384bdbccfd3d4f67675826508db))

### [1.3.9](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.8...v1.3.9) (2026-04-04)

### [1.3.8](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.7...v1.3.8) (2026-04-04)


### Documentation

* update email trigger matrix and related docs ([ecf620c](https://github.com/PC-Mender/sjrs-lms-docs/commit/ecf620c52a1e693d446431ff13386eba76d6f472))

### [1.3.7](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.6...v1.3.7) (2026-03-23)

### [1.3.6](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.5...v1.3.6) (2026-03-23)

### [1.3.5](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.4...v1.3.5) (2026-03-16)


### Documentation

* update project rules documentation formatting ([8a867c6](https://github.com/PC-Mender/sjrs-lms-docs/commit/8a867c61a14427f3b97e29db2e88dbaa3c077dc2))

### [1.3.4](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.3...v1.3.4) (2026-03-15)


### Bug Fixes

* **docs:** move setup guide to developers section ([5156df4](https://github.com/PC-Mender/sjrs-lms-docs/commit/5156df4ed34ed9cf6037bb002b7e4e6d61e7d691))

### [1.3.3](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.2...v1.3.3) (2026-03-15)


### Bug Fixes

* **docs:** remove setup guide from getting started quick resources ([c1c8a1f](https://github.com/PC-Mender/sjrs-lms-docs/commit/c1c8a1fd2cc6901d134e314b67b4b550786d3af7))

### [1.3.2](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.1...v1.3.2) (2026-03-15)


### Bug Fixes

* **docs:** remove duplicate email confirmation section in registration guide ([ba1b1be](https://github.com/PC-Mender/sjrs-lms-docs/commit/ba1b1be9383034afdc5fc5f008ad6022e92fed7b))
* **docs:** remove duplicate H1 heading in registration guide ([69a968a](https://github.com/PC-Mender/sjrs-lms-docs/commit/69a968af9898cf494e3c893a8d071f5a261682b0))

### [1.3.1](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.3.0...v1.3.1) (2026-03-15)


### Bug Fixes

* **docs:** remove duplicate account types section in registration guide ([752a0e9](https://github.com/PC-Mender/sjrs-lms-docs/commit/752a0e980a4508b776712427b1d3a921d1a0d7c2))

## [1.3.0](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.2.0...v1.3.0) (2026-03-15)


### Features

* **docs:** add comprehensive user registration documentation ([068d523](https://github.com/PC-Mender/sjrs-lms-docs/commit/068d523f3fbfe9679c13949601d444a9e39bd17c))

## [1.2.0](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.34...v1.2.0) (2026-03-15)


### Features

* **docs:** add comprehensive v6.x documentation for enhanced user dashboard and system notifications ([a100840](https://github.com/PC-Mender/sjrs-lms-docs/commit/a100840957fca251cc24b45795af86ea60fca0eb))

### [1.1.34](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.33...v1.1.34) (2026-03-12)


### Bug Fixes

* **docs:** normalize internal links and add glossary redirects ([066ca4a](https://github.com/PC-Mender/sjrs-lms-docs/commit/066ca4a0c17cde9e8b4de8ba1ee5aa75c5fd78df))

### [1.1.33](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.32...v1.1.33) (2026-03-12)


### Bug Fixes

* **docs:** add getting-started glossary and repair links ([c5b0fb5](https://github.com/PC-Mender/sjrs-lms-docs/commit/c5b0fb56f1584c6363787822799562f06d36dad8))

### [1.1.32](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.31...v1.1.32) (2026-03-12)


### Documentation

* include guest end-user guidance ([db85b02](https://github.com/PC-Mender/sjrs-lms-docs/commit/db85b0298e0c883609d69e583ce3f425c9698afa))

### [1.1.31](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.30...v1.1.31) (2026-03-12)


### Documentation

* reduce emoji usage ([7f094d5](https://github.com/PC-Mender/sjrs-lms-docs/commit/7f094d5d0f64728b268d8d9344f4a846a34da773))

### [1.1.30](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.29...v1.1.30) (2026-03-12)


### Documentation

* sanitize base URLs and secrets ([17b900b](https://github.com/PC-Mender/sjrs-lms-docs/commit/17b900bb8cb417c108c4c92bab41cccc164d543e))

### [1.1.29](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.28...v1.1.29) (2026-03-12)


### Documentation

* align auth, CSRF, and superuser testing ([7463105](https://github.com/PC-Mender/sjrs-lms-docs/commit/7463105e28cc2f6ca24858aa436874da00e8712c))

### [1.1.28](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.27...v1.1.28) (2026-03-11)


### Documentation

* **release:** document 6.3.x rollout and bump CI node ([05d72df](https://github.com/PC-Mender/sjrs-lms-docs/commit/05d72dff113cb0528e61c4c3d95c59f703a61925))

### [1.1.27](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.26...v1.1.27) (2026-03-10)


### Documentation

* add comprehensive instant-close modal migration guide for developers ([b3da1f2](https://github.com/PC-Mender/sjrs-lms-docs/commit/b3da1f20cd191dc1bedffb43faa0f633667afb94))

### [1.1.26](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.25...v1.1.26) (2026-03-10)


### Documentation

* add missing v5.0.0 and v5.0.1 release information to changelog ([8d7542b](https://github.com/PC-Mender/sjrs-lms-docs/commit/8d7542baa2438b5224b95a0803c74942caec4b64))

### [1.1.25](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.23...v1.1.25) (2026-03-10)


### Documentation

* add v6.0.0 release documentation and instant-close modal pattern guide ([38b201c](https://github.com/PC-Mender/sjrs-lms-docs/commit/38b201c6564e2f638a35bb22f2af73599ccea23e))

### [1.1.23](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.22...v1.1.23) (2026-03-09)


### Documentation

* add data fetching guide, loans refactoring summary, and update query migration details ([7229dfe](https://github.com/PC-Mender/sjrs-lms-docs/commit/7229dfedefc10cfe03778310fa1fccd0c69ca453))
* add missing index pages for documentation sections ([f40de67](https://github.com/PC-Mender/sjrs-lms-docs/commit/f40de6737d71701e30390ca948daa4f369fa3e40))

### [1.1.22](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.21...v1.1.22) (2026-03-07)


### Documentation

* remove hyphens from sidebar headings ([f0bbdbe](https://github.com/PC-Mender/sjrs-lms-docs/commit/f0bbdbe6024f42b2e4602dccdcf759df3ee671c8))

### [1.1.21](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.20...v1.1.21) (2026-03-07)


### Documentation

* fix capitalized titles and redundant h1 headings ([96fa315](https://github.com/PC-Mender/sjrs-lms-docs/commit/96fa3156ebb5346b4b0c7671be327d31d07a2cf3))

### [1.1.20](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.19...v1.1.20) (2026-03-06)


### Documentation

* migrate content to mdx ([d2aadc6](https://github.com/PC-Mender/sjrs-lms-docs/commit/d2aadc66b4bc6d968d55efa6a4a33d74162668bd))

### [1.1.19](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.18...v1.1.19) (2026-03-05)


### Bug Fixes

* remove broken link to non-existent professors module ([00e8f4e](https://github.com/PC-Mender/sjrs-lms-docs/commit/00e8f4e34f08973c8908657d8eb2a178661c482d))

### [1.1.18](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.16...v1.1.18) (2026-03-05)


### Documentation

* update feature documentation for v4.0.1/v4.0.2 changes ([500fdae](https://github.com/PC-Mender/sjrs-lms-docs/commit/500fdaeccc9710960e96fbf9bce7b73b290d5667))

### [1.1.17](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.16...v1.1.17) (2026-03-05)


### Documentation

* update feature documentation for v4.0.1/v4.0.2 changes ([500fdae](https://github.com/PC-Mender/sjrs-lms-docs/commit/500fdaeccc9710960e96fbf9bce7b73b290d5667))

### [1.1.16](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.15...v1.1.16) (2026-03-04)


### Styling

* update version label format in footer ([4bacd7e](https://github.com/PC-Mender/sjrs-lms-docs/commit/4bacd7e7d1f051ea6a8411b1f56b63c7629d74b8))

### [1.1.15](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.14...v1.1.15) (2026-03-04)


### Documentation

* update API docs for v4.0.0 and clarify wishlist priority ([8b4a7bd](https://github.com/PC-Mender/sjrs-lms-docs/commit/8b4a7bd9f33f34cfed241bf6c3efcc540af23240))

### [1.1.14](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.13...v1.1.14) (2026-03-03)


### Documentation

* align onboarding workflow and help system\n\n- Update Account Management to new onboarding statuses\n- Simplify Help System Guide with keyboard shortcut and external links\n- Update changelog for 3.52.0, 3.51.x\n- Add onboarding-status reference and status data dictionary\n- Minor doc index adjustments ([eac78fb](https://github.com/PC-Mender/sjrs-lms-docs/commit/eac78fb041a7f110175474931cbfff25098a4ba4))

### [1.1.13](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.12...v1.1.13) (2026-03-03)


### Documentation

* add complete historical changelog from v1.0.0 ([a615897](https://github.com/PC-Mender/sjrs-lms-docs/commit/a615897e7c1aa0461ca5621c12f8ed269a7c753a))

### [1.1.12](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.11...v1.1.12) (2026-03-02)


### Documentation

* update changelog for v3.50.3, add full changelog, and fix internal links ([2ff2469](https://github.com/PC-Mender/sjrs-lms-docs/commit/2ff24699633cb08c8159f2b92a99e00e8682b837))

### [1.1.11](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.10...v1.1.11) (2026-03-02)


### Documentation

* update content ([86edf09](https://github.com/PC-Mender/sjrs-lms-docs/commit/86edf094c5f410c007fb21508a0a833a9b7d6288))

### [1.1.10](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.9...v1.1.10) (2026-03-02)


### Documentation

* add faqs content ([2c36801](https://github.com/PC-Mender/sjrs-lms-docs/commit/2c3680183011e5a171c55180b2d6f1b238571bd0))

### [1.1.9](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.8...v1.1.9) (2026-03-02)


### Documentation

* update to auth workflow ([785cb89](https://github.com/PC-Mender/sjrs-lms-docs/commit/785cb894d915b70538e9f32649becc9e1567a77c))

### [1.1.8](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.7...v1.1.8) (2026-03-02)


### Documentation

* update documentation for v3.49.0 release ([470e6bb](https://github.com/PC-Mender/sjrs-lms-docs/commit/470e6bb811aa9462291ba2ebb58da602a95217aa))

### [1.1.7](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.6...v1.1.7) (2026-03-01)

### [1.1.6](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.5...v1.1.6) (2026-03-01)


### Bug Fixes

* Broken links fixed ([8956077](https://github.com/PC-Mender/sjrs-lms-docs/commit/8956077b869701c6557eb48b230250478384099c))

### [1.1.5](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.4...v1.1.5) (2026-02-28)


### Performance Improvements

* improvements to doc functionality & updated docs ([f506db7](https://github.com/PC-Mender/sjrs-lms-docs/commit/f506db7fab34b5de69a55407a04e4c0d18037cf6))

### [1.1.4](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.3...v1.1.4) (2026-02-28)


### Performance Improvements

* add version visibility in footer ([4d51a5f](https://github.com/PC-Mender/sjrs-lms-docs/commit/4d51a5fca668436010ea1a8e6e26c63817b4eb2f))

### [1.1.3](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.2...v1.1.3) (2026-02-28)

### [1.1.2](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.1...v1.1.2) (2026-02-28)


### Documentation

* add dependency update summary ([d3d99a6](https://github.com/PC-Mender/sjrs-lms-docs/commit/d3d99a629dd48e6980daed3a8dcf4756b1b96489))
* remove temporary audit and documentation files ([0645471](https://github.com/PC-Mender/sjrs-lms-docs/commit/06454714b309245b067d2880c49ca624da7b3837))

### [1.1.1](https://github.com/PC-Mender/sjrs-lms-docs/compare/v1.1.0...v1.1.1) (2026-02-28)


### Documentation

* add comprehensive fixes applied summary ([eba4b12](https://github.com/PC-Mender/sjrs-lms-docs/commit/eba4b1200dbe91c0104bf2f301bd0313ff2e0ab2))

## 1.1.0 (2026-02-27)


### Features

* Begin with standard versioning ([2a96b65](https://github.com/PC-Mender/sjrs-lms-docs/commit/2a96b6516be99d43cba5382f08f16af49e6a3279))


### Bug Fixes

* expose version_changed output for release job ([54e42cf](https://github.com/PC-Mender/sjrs-lms-docs/commit/54e42cfe99e467491a9817a228ec6f5a038d8778))
