Waffle.Ecto
========

[![Codeship Status for elixir-waffle/waffle_ecto](https://app.codeship.com/projects/60167fe0-aa59-0137-be69-2259d5318dee/status?branch=master)](https://app.codeship.com/projects/361675)

Waffle.Ecto provides an integration with [Waffle](https://github.com/elixir-waffle/waffle) and Ecto.

Installation
============

Add the latest stable release to your `mix.exs` file:

```elixir
defp deps do
  [
    {:waffle_ecto, "~> 0.0.2"}
  ]
end
```

Then run `mix deps.get` in your shell to fetch the dependencies.

Usage
=====

### Add Waffle.Ecto.Definition

Add a second using macro `use Waffle.Ecto.Definition` to the top of your Waffle definitions.

```elixir
defmodule MyApp.Avatar do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  # ...
end
```

This provides a set of functions to ease integration with Waffle and Ecto.  In particular:

  * Definition of a custom Ecto Type responsible for storing the images.
  * Url generation with a cache-busting timestamp query parameter

### Add a string column to your schema

Waffle attachments should be stored in a string column, with a name indicative of the attachment.

```elixir
create table :users do
  add :avatar, :string
end
```

### Add your attachment to your Ecto Schema

Add a using statement `use Waffle.Ecto.Schema` to the top of your ecto schema, and specify the type of the column in your schema as `MyApp.Avatar.Type`.

Attachments can subsequently be passed to Waffle's storage though a Changeset `cast_attachments/3` function, following the syntax of `cast/3`

```elixir
defmodule MyApp.User do
  use MyApp.Web, :model
  use Waffle.Ecto.Schema

  schema "users" do
    field :name,   :string
    field :avatar, MyApp.Avatar.Type
  end

  @doc """
  Creates a changeset based on the `data` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(user, params \\ :invalid) do
    user
    |> cast(params, [:name])
    |> cast_attachments(params, [:avatar])
    |> validate_required([:name, :avatar])
  end
end
```

### Save your attachments as normal through your controller

```elixir
  @doc """
  Given params of:

  %{
    "id" => 1,
    "user" => %{
      "avatar" => %Plug.Upload{
                    content_type: "image/png",
                    filename: "selfie.png",
                    path: "/var/folders/q0/dg42x390000gp/T//plug-1434/multipart-765369-5"}
    }
  }

  """
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "User updated successfully.")
      |> redirect(to: user_path(conn, :index))
    else
      render conn, "edit.html", user: user, changeset: changeset
    end
  end
```

### Retrieve the serialized url

Both public and signed urls will include the timestamp for cache busting, and are retrieved the exact same way as using Waffle directly.

```elixir
  user = Repo.get(User, 1)

  # To receive a single rendition:
  MyApp.Avatar.url({user.avatar, user}, :thumb)
    #=> "https://bucket.s3.amazonaws.com/uploads/avatars/1/thumb.png?v=63601457477"

  # To receive all renditions:
  MyApp.Avatar.urls({user.avatar, user})
    #=> %{original: "https://.../original.png?v=1234", thumb: "https://.../thumb.png?v=1234"}

  # To receive a signed url:
  MyApp.Avatar.url({user.avatar, user}, signed: true)
  MyApp.Avatar.url({user.avatar, user}, :thumb, signed: true)
```

## Development

[Development documentation](/documentation/development.md)

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
