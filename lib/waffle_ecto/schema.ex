defmodule Waffle.Ecto.Schema do
  @moduledoc ~S"""
  Defines helpers to work with changeset.

  Add a using statement `use Waffle.Ecto.Schema` to the top of your
  ecto schema, and specify the type of the column in your schema as
  `MyApp.Avatar.Type`.

  Attachments can subsequently be passed to Waffle's storage though a
  Changeset `cast_attachments/3` function, following the syntax of
  `cast/3`.

  ## Example

      defmodule MyApp.User do
        use MyApp.Web, :model
        use Waffle.Ecto.Schema

        schema "users" do
          field :name,   :string
          field :avatar, MyApp.Uploaders.AvatarUploader.Type
        end

        def changeset(user, params \\ :invalid) do
          user
          |> cast(params, [:name])
          |> cast_attachments(params, [:avatar])
          |> validate_required([:name, :avatar])
        end
      end

  """

  defmacro __using__(_) do
    quote do
      import Waffle.Ecto.Schema
    end
  end

  @doc ~S"""
  Extracts attachments from params and converts it to the accepted format.

  ## Options

    * `:allow_urls` — fetches remote file if the string matches `~r/^https?:\/\//`
    * `:allow_paths` — accepts any local path as file destination

  ## Examples

      cast_attachments(changeset, params, [:fetched_remote_file], allow_urls: true)

  """
  defmacro cast_attachments(changeset_or_data, params, allowed, options \\ []) do
    quote bind_quoted: [
            changeset_or_data: changeset_or_data,
            params: params,
            allowed: allowed,
            options: options
          ] do
      # If given a changeset, apply the changes to obtain the underlying data
      scope = do_apply_changes(changeset_or_data)

      # Cast supports both atom and string keys, ensure we're matching on both.
      allowed_param_keys =
        Enum.map(allowed, fn key ->
          case key do
            key when is_binary(key) -> key
            key when is_atom(key) -> Atom.to_string(key)
          end
        end)

      waffle_params =
        case params do
          :invalid ->
            :invalid

          %{} ->
            params
            |> convert_params_to_binary()
            |> Map.take(allowed_param_keys)
            |> check_and_apply_scope(scope, options)
            |> Enum.into(%{})
        end

      Ecto.Changeset.cast(changeset_or_data, waffle_params, allowed)
    end
  end

  def do_apply_changes(%Ecto.Changeset{} = changeset), do: Ecto.Changeset.apply_changes(changeset)
  def do_apply_changes(%{__meta__: _} = data), do: data

  def check_and_apply_scope(params, scope, options) do
    Enum.reduce(params, [], fn
      # Don't wrap nil casts in the scope object
      {field, nil}, fields ->
        [{field, nil} | fields]

      # Allow casting Plug.Uploads
      {field, upload = %{__struct__: Plug.Upload}}, fields ->
        [{field, {upload, scope}} | fields]

      # Allow casting binary data structs
      {field, upload = %{filename: filename, binary: binary}}, fields
      when is_binary(filename) and is_binary(binary) ->
        [{field, {upload, scope}} | fields]

      # If casting a binary (path), ensure we've explicitly allowed paths
      {field, path}, fields when is_binary(path) ->
        path = String.trim(path)

        cond do
          path == "" ->
            fields

          Keyword.get(options, :allow_urls, false) and Regex.match?(~r/^https?:\/\//, path) ->
            [{field, {path, scope}} | fields]

          Keyword.get(options, :allow_paths, false) ->
            [{field, {path, scope}} | fields]

          true ->
            fields
        end
    end)
  end

  def convert_params_to_binary(params) do
    Enum.reduce(params, nil, fn
      {key, _value}, nil when is_binary(key) ->
        nil

      {key, _value}, _ when is_binary(key) ->
        raise ArgumentError,
              "expected params to be a map with atoms or string keys, " <>
                "got a map with mixed keys: #{inspect(params)}"

      {key, value}, acc when is_atom(key) ->
        Map.put(acc || %{}, Atom.to_string(key), value)
    end) || params
  end
end
