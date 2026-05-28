# Withlocals Partner API — OpenAPI spec

The OpenAPI 3.1 spec for the Withlocals partner API (products, availability,
and the create → amend → cancel booking lifecycle — v1 commits bookings
immediately, with no reserve / confirm step). **Single source of truth** for
the partner contract.

Design rationale and decision history live in the main `withlocals/withlocals`
monorepo at `docs/plans/partner-api-adapter-review.md`.

## Layout

```
.
├── openapi.yaml              # root: info, servers, security, paths-as-refs
├── paths/                    # one file per URL path
├── components/
│   ├── schemas/              # one file per data type
│   ├── responses/            # one file per shared response
│   └── parameters/           # one file per shared parameter
├── examples/                 # reusable request/response examples
├── assets/                   # logo and other static files (drop logo.svg here)
├── index.html                # Scalar shell — loads Scalar from CDN, renders openapi.yaml
├── .spectral.yaml            # house style ruleset
├── Dockerfile                # mock server image (Prism) — local-dev only
└── package.json              # tooling
```

## Branding & docs theme

Docs are rendered by [**Scalar**](https://github.com/scalar/scalar), loaded
from the jsDelivr CDN. The renderer shell lives at [`index.html`](./index.html)
and styling is done through Scalar's CSS variables:

- `--scalar-color-accent: #e71575` — Withlocals pink, applied in both light
  and dark modes (Scalar's default dark mode is preserved).
- `--scalar-font: "Inter", …` — Inter loaded from Google Fonts with system
  fallbacks.

The favicon and any inline logo come from [`assets/logo.svg`](./assets/);
`yarn build` copies the whole `assets/` directory into `dist/assets/` so the
logo travels with the deploy.

Scalar is **pinned to major version 1** via the CDN URL
(`@scalar/api-reference@1`) — bug fixes still flow in, but a future Scalar 2.0
won't silently break the docs.

## Local commands

```bash
yarn install

yarn lint               # bundle + spectral
yarn build              # bundle to dist/api-reference/ + copy index.html + assets
yarn preview            # build + serve at http://localhost:3001 (docs at /api-reference/)
yarn mock               # boot Prism mock at http://127.0.0.1:4010
```

> **Yarn version:** the CI workflow uses `yarn install --immutable` (Yarn
> Berry, 2+). On Yarn Classic (1.x) the equivalent is `--frozen-lockfile`.
> The package scripts are identical either way.

### Hitting the mock

The spec declares `bearerAuth` globally, so the mock returns
`{"error":"UNAUTHORIZED",...}` on requests without an `Authorization: Bearer ...`
header. **Prism does not validate the token** — any non-empty token string
is accepted. This mirrors production's auth flow so partners hit the same
shape of error in the sandbox as they will in prod.

```bash
# curl — list products
curl -s -H 'Authorization: Bearer demo-token' \
  http://127.0.0.1:4010/products | jq .

# curl — create a CONFIRMED booking (guest details required upfront)
curl -s -H 'Authorization: Bearer demo-token' \
  -X POST http://127.0.0.1:4010/bookings \
  -H 'Content-Type: application/json' \
  -d '{
    "productId": "1b9d6bcd-bbfd-4b2d-9b5d-ab8dfbbd4bed",
    "localDate": "2026-07-15",
    "localTime": "10:00",
    "numberOfAdults": 2,
    "mainGuest": {
      "firstName": "Anna",
      "lastName": "Kowalska",
      "email": "anna@example.com"
    }
  }' | jq .

# curl — cancel a booking
curl -s -H 'Authorization: Bearer demo-token' \
  -X DELETE 'http://127.0.0.1:4010/bookings/7c9e6679-7425-40de-944b-e07fc1f90ae7?reason=changed-plans' | jq .

# HTTPie
http localhost:4010/products 'Authorization:Bearer demo-token'
```

In **Postman / Insomnia**, set Authorization → Bearer Token with any value.

> **Browser note:** browsers do not send `Authorization: Bearer` headers on
> plain navigation (unlike Basic auth, there's no built-in prompt). To poke
> at the mock from a browser, use a REST client extension (Thunder Client,
> RestMan) or hit it from the JS console with `fetch()`.

## Deploys

| Artifact | URL | How |
|---|---|---|
| Docs | `https://developers.withlocals.com/api-reference/` | GitHub Pages, published from `dist/` by CI on every push to `main`. |
| Bundled spec | `https://developers.withlocals.com/api-reference/openapi.yaml` | Same artifact; partners point codegen here. |

CI workflow: [`.github/workflows/build.yml`](./.github/workflows/build.yml) —
lint on PR, build + deploy to Pages on merge to `main`.

**One-time repo setup** (do once, in repo Settings):

1. Settings → Pages → **Source: GitHub Actions**.
2. Settings → Pages → **Custom domain: `developers.withlocals.com`**, then
   add a `CNAME` record at the DNS provider pointing to
   `<org>.github.io`. GitHub provisions HTTPS via Let's Encrypt
   automatically.

No Prism mock is deployed; `yarn mock` is for local development only.

## Authoring conventions

- Every operation has an `operationId`, a `summary`, a `description`, and at
  least one example per request body / 2xx response.
- Every 4xx response references the shared `Error` envelope under
  `components/responses/`.
- Field semantics that differ from a partner's likely default expectation are
  documented inline on the field itself (see `AvailabilitySlot.capacity`,
  `Money`, `BookingStatus`).

## Status

Phase 0 deliverable (spec + docs + mock). Backend implementation (Phase 1+)
is tracked in the main `withlocals/withlocals` monorepo. The contract here is
the source of truth — Phase 1 controllers must conform to it (contract test
in CI).
