# Withlocals Partner API — OpenAPI spec

OpenAPI 3.1 spec for the Withlocals partner API (products, availability,
bookings, and the booking-cancelled webhook). **Single source of truth** for
the partner contract.

## Layout

```
.
├── openapi.yaml         # root: info, servers, security, refs into paths/ and webhooks/
├── paths/               # one file per URL path
├── webhooks/            # one file per outbound webhook event
├── components/          # schemas, responses, parameters
├── examples/            # reusable request/response examples
├── assets/              # logo
├── index.html           # Scalar shell — renders the bundled spec
├── .spectral.yaml       # lint ruleset
└── package.json         # tooling
```

## Local commands

```bash
yarn install
yarn lint        # bundle + spectral
yarn build       # bundle to dist/api-reference/ + copy index.html + assets
yarn preview     # build + serve at http://localhost:3001/api-reference/
```

## Deploys

| Artifact | URL |
|---|---|
| Docs | <https://developers.withlocals.com/api-reference/> |
| Bundled spec | <https://developers.withlocals.com/api-reference/openapi.yaml> |

Published by [`.github/workflows/build.yml`](./.github/workflows/build.yml) —
lint on PR, build + deploy to GitHub Pages on merge to `main`.

## Docs theme

Rendered by [Scalar](https://github.com/scalar/scalar).