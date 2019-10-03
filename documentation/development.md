# Development

Development documentation with instructions how to setup the project for local development.

## Preliminary

* Docker

```sh
# screen 1
$ docker-compose up

# screen 2
$ docker-compose exec waffle_ecto sh
$ > mix deps.get
```

## Run tests

### Tests without S3 integration
```sh
$ mix test
```

## Common tasks

```sh
# to run linter
$ mix credo --strict

# to generate documentation
$ MIX_ENV=dev mix docs
```
