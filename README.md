# Waffle.Ecto

<img align="right" width="176" alt="Waffle.Ecto logo" src="https://elixir-waffle.github.io/waffle/assets/waffle-ecto-logo.svg">

Waffle.Ecto provides an integration with [Waffle](https://github.com/elixir-waffle/waffle) and Ecto.

[Documentation](https://hexdocs.pm/waffle_ecto/readme.html)
 · [Hex](https://hex.pm/packages/waffle_ecto)

[Presentation at ElixirConf](https://www.youtube.com/watch?v=4iM-V9yELsE)
 · [Thinking Elixir Podcast 80](https://podcast.thinkingelixir.com/80)

---

Already using Waffle in your org? I'd love to learn more. Let's [have a chat](https://cal.com/achempion/meet) or just [send me an email](mailto:me@achempion.com?subject=Feedback%20on%20Waffle).

---

## Installation

Add the latest stable release to your `mix.exs` file:

```elixir
defp deps do
  [
    {:waffle_ecto, "~> 0.1"}
  ]
end
```

Then run `mix deps.get` in your shell to fetch the dependencies.

## Usage

See the [Waffle.Ecto guide](https://hexdocs.pm/waffle_ecto/Waffle.Ecto.html) for uploader and schema setup, and [`cast_attachments/4`](https://hexdocs.pm/waffle_ecto/Waffle.Ecto.Schema.html#cast_attachments/4) for attachment casting and cleanup.

## Sponsors

- [Oficinaria](https://oficinaria.com.br?utm_source=waffle), marketplace for in-person creative workshops in Brazil
- [Tecotype](https://tecotype.com?utm_source=waffle), keyboard-first mail app

## License

Copyright 2019 Boris Kuznetsov
Copyright 2015 Sean Stavropoulos

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
