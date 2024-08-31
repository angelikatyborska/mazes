# How to release?

- `cd assets && npm install`
- `npm run deploy`
- `cd ..`
- `mix phx.digest`
- `mix sentry.package_source_code`
- `MIX_ENV=prod mix release`
