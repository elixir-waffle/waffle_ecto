# How to use `:id` in filepath

In order to use `:id` attribute within file's path, we should separate
creation stage on two steps:
- persist the resource
- upload the file

It needs to be done because `:id` not yet exist on creation stage.

## Example

To implement this we should define `storage_dir/2` inside uploader

```elixir
def storage_dir(_version, {_file, scope}) do
  "uploads/avatar/#{scope.id}"
end
```

Then define two separate `changeset`s inside our resource

```elixir
def changeset(user, attrs) do
  user
  |> cast(attrs, [:name])
  |> validate_required([:name])
end

def avatar_changeset(user, attrs) do
  user
  |> cast_attachments(attrs, [:avatar])
  |> validate_required([:avatar])
end
```

Finally, we can combine two stages into one action

```elixir
Ecto.Multi.new()
|> Ecto.Multi.insert(:user, User.changeset(user, attrs))
|> Ecto.Multi.update(:user_with_avatar, &User.avatar_changeset(&1.user, attrs))
|> Repo.transaction()
```

This can be used in a Phoenix app context like

```elixir
defmodule Accounts do
  # ...
  
  def create_user(attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user, User.changeset(%User{}, attrs))
    |> Ecto.Multi.update(:user_with_avatar, &User.avatar_changeset(&1.user, attrs))
    |> Repo.transaction()
    |> case do
      {:ok, %{user_with_avatar: user}} -> {:ok, user}
      {:error, _, changeset, _} -> {:error, changeset}
  end
  
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> User.avatar_changeset(attrs)
    |> Repo.update()
  end
  
  def change_user(%User{} = user, attrs \\ %{}) do
    user
    |> User.changeset(attrs)
    |> User.avatar_changeset(attrs)
  end
  
  # ...
end
```
