# SJRS LMS Documentation

[![Release](https://github.com/PC-Mender/sjrs-lms-docs/actions/workflows/release.yml/badge.svg)](https://github.com/PC-Mender/sjrs-lms-docs/actions/workflows/release.yml)
[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](https://opensource.org/licenses/ISC)

> Official documentation site for the **SJRS Library Management System** — built with [Astro Starlight](https://starlight.astro.build/) and published to [docs.sjrslms.in](https://docs.sjrslms.in).

## About This Repository

This repository contains the source for the public documentation site of SJRS LMS. It is maintained alongside the main application repository:

- **App repository**: [PC-Mender/sjrslms](https://github.com/PC-Mender/sjrslms)
- **Live docs site**: [https://docs.sjrslms.in](https://docs.sjrslms.in)
- **Live app**: [https://sjrslms.in](https://sjrslms.in)

## Documentation Structure

| Section | Audience | Description |
|---|---|---|
| [Getting Started](https://docs.sjrslms.in/getting-started/) | Everyone | End-user, administrator, and developer onboarding |
| [User Guides](https://docs.sjrslms.in/user-guides/) | End users | Step-by-step guides for students, professors, and guests |
| [Features](https://docs.sjrslms.in/features/) | End users / admins | Feature overviews and reference material |
| [Architecture](https://docs.sjrslms.in/architecture/) | Developers | System design, patterns, and decisions |
| [Development](https://docs.sjrslms.in/development/) | Developers | Technical guides, refactoring notes, and standards |
| [API](https://docs.sjrslms.in/api/) | Integrators / developers | Endpoint reference and Postman collections |
| [Security](https://docs.sjrslms.in/security/) | Everyone | Security policies and implementation details |
| [Deployment](https://docs.sjrslms.in/deployment/) | DevOps / maintainers | Cloudflare Workers deployment guides |

## Local Development

### Prerequisites

- **Node.js** ≥ 22 (matches CI — see `.github/workflows/docs-quality-gates.yml`)
- **npm**

### Quick Start

```bash
git clone https://github.com/PC-Mender/sjrs-lms-docs.git
cd sjrs-lms-docs
npm install
npm run dev
```

The development server starts at `http://localhost:4321` by default.

### Common Commands

| Command | Description |
|---|---|
| `npm run dev` | Start local development server |
| `npm run build` | Build the static documentation site |
| `npm run preview` | Preview the production build locally |
| `npm run lint` | Run Astro type/content checks (`astro check`) |
| `npm run check:lifecycle` | Validate documentation lifecycle metadata |
| `npm run release` | Generate changelog and version bump |

## Contributing

We welcome documentation improvements. Please see [`CONTRIBUTING.md`](./CONTRIBUTING.md) for guidelines on:

- Reporting issues and suggesting changes
- Submitting pull requests
- Following our documentation standards
- Running quality checks locally

## Documentation Standards

This repository follows the standards defined in [`src/content/docs/documentation-standards.mdx`](./src/content/docs/documentation-standards.mdx) and the project rules in [`src/content/docs/project-rules-docs.mdx`](./src/content/docs/project-rules-docs.mdx).

Key principles:

- **Accuracy first** — docs must reflect released application behavior.
- **Single source of truth** — link to canonical pages instead of duplicating content.
- **Docs-as-code** — changes follow PR review, quality gates, and release discipline.

## Security

For vulnerability reporting guidelines, see [`SECURITY.md`](./SECURITY.md) or the [full security policy](https://docs.sjrslms.in/policies/security-policy).

## License

This project is licensed under the [ISC License](./LICENSE).
