# Mock server for the Withlocals Partner API.
# Bakes the bundled spec into the image so partners hitting
# sandbox.withlocals.com always get example responses consistent
# with the published docs.
#
# Build prerequisite: run `yarn build` first so dist/openapi.yaml exists.

FROM node:20-alpine

WORKDIR /app

# node:20-alpine ships with Yarn Classic (1.x), so `yarn global add` works here.
RUN yarn global add @stoplight/prism-cli@5

COPY dist/openapi.yaml /app/openapi.yaml

EXPOSE 4010

CMD ["prism", "mock", "-h", "0.0.0.0", "-p", "4010", "/app/openapi.yaml"]
