# Assets

Static files referenced by the rendered docs. Contents are copied verbatim
into `dist/assets/` by `yarn build`, so they end up alongside `index.html`
and ship to `developers.withlocals.com` on deploy.

## Required files

- `logo.svg` — Withlocals logo, displayed top-left in the Redoc sidebar via
  the `x-logo` extension in `openapi.yaml`. **Drop the canonical logo file
  here.** SVG is preferred (scales cleanly); PNG also works — if you change
  the format, update the `x-logo.url` path in `openapi.yaml` accordingly.

If `logo.svg` is missing at build time, Redoc renders a broken image
placeholder where the logo should be. The docs still work; it just looks
unfinished. CI will not fail.
