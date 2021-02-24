FROM elixir:1.9.1-alpine

RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /srv/app

COPY . .

ENV MIX_ENV=test

RUN mix deps.get && mix deps.compile

CMD mix test
