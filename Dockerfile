FROM elixir:1.10.2-alpine as build

# install build dependencies
RUN apk add --no-cache build-base npm git python

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod
ENV CYPRESS_INSTALL_BINARY=0

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

# Build dice-roller
COPY dice-roller/package.json dice-roller/package-lock.json ./dice-roller/
RUN npm --prefix ./dice-roller ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
COPY dice-roller dice-roller

RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs nodejs

WORKDIR /app

# RUN chown nobody:nobody /app

# USER nobody:nobody

# COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/dnd_chat ./
# COPY --from=build --chown=nobody:nobody /app/dice-roller /app/dice-roller

COPY --from=build /app/_build/prod/rel/dnd_chat ./
COPY --from=build /app/dice-roller /app/dice-roller

ENV HOME=/app

CMD ["bin/dnd_chat", "start"]
