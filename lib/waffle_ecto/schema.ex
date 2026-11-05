defmodule Waffle.Ecto.Schema do
  @moduledoc """
  Provides helpers for casting attachments in Ecto changesets.
  """

  @type changeset_params :: map() | nil | :invalid
  @type permitted_fields :: [atom()]

  @type attachment_option ::
          {:allow_urls, boolean()}
          | {:allow_paths, boolean()}

  defmacro __using__(_) do
    quote do
      import Waffle.Ecto.Schema
    end
  end

  @doc ~S"""
  Converts a payload into a schema change.

  This function triggers Waffle's file processing and storage pipeline
  during type casting.

  ## Type casting

  When processing the payload, the function expects the payload to be an attachment.

  An attachment can be represented in the following forms:

    * `%Plug.Upload{}`
    * `%Waffle.File{}`
    * `%{filename: "name.jpg", binary: <<42>>}`
    * `%{filename: "name.jpg", path: "/path/to/file.jpg"}` - requires
      `allow_paths: true`
    * `%{filename: "name.jpg", path: "https://example.com/file.jpg"}` -
      requires `allow_paths: true` or `allow_urls: true`
    * `"/path/to/file.jpg"` - requires `allow_paths: true`
    * `"https://example.com/file.jpg"` - requires `allow_paths: true` or
      `allow_urls: true`

  ## Options

    * `:allow_urls` - defaults to `false`, fetches a remote file if the
      string matches `~r/^https?:\/\//`
    * `:allow_paths` - defaults to `false`, accepts a local path as a source
      file, **should never be used with untrusted input**

  ## Examples

      cast_attachments(
        changeset,
        params,
        [:attachment],
        allow_urls: true,
        allow_paths: true
      )

  ## Cleaning up files after schema changes

  When removing or updating files, you need to handle the cleanup
  after the schema update. In general, it's recommended to put file
  handling into a dedicated changeset function, as file handling
  happens during type casting.

      old_avatar = user.avatar
      old_scope = user

      changeset =
        user
        |> Ecto.Changeset.change()
        |> cast_attachments(%{"avatar" => nil}, [:avatar])

      case Repo.update(changeset) do
        {:ok, updated_user} ->
          if updated_user.avatar == nil && old_avatar do
            AvatarUploader.delete({old_avatar, old_scope})
          end

          {:ok, updated_user}

        {:error, changeset} ->
          {:error, changeset}
      end
  """
  @spec cast_attachments(
          Ecto.Changeset.t() | struct(),
          changeset_params(),
          permitted_fields(),
          [attachment_option()]
        ) :: Ecto.Changeset.t() | struct()
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

      case params do
        params when is_map(params) and map_size(params) > 0 ->
          waffle_params =
            params
            |> convert_params_to_binary()
            |> Map.take(allowed_param_keys)
            |> check_and_apply_scope(scope, options)
            |> Enum.into(%{})

          Ecto.Changeset.cast(changeset_or_data, waffle_params, allowed)

        _ ->
          changeset_or_data
      end
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

      # Allow casting Waffle's File structs
      {field, upload = %Waffle.File{}}, fields ->
        [{field, {upload, scope}} | fields]

      # Allow casting binary data structs
      {field, upload = %{filename: filename, binary: binary}}, fields
      when is_binary(filename) and is_binary(binary) ->
        [{field, {upload, scope}} | fields]

      {field, upload = %{filename: filename, path: path}}, fields
      when is_binary(filename) and is_binary(path) ->
        path = String.trim(path)
        upload = %{upload | path: path}
        if path_allowed?(path, options), do: [{field, {upload, scope}} | fields], else: fields

      # If casting a binary (path), ensure we've explicitly allowed paths
      {field, path}, fields when is_binary(path) ->
        path = String.trim(path)
        if path_allowed?(path, options), do: [{field, {path, scope}} | fields], else: fields
    end)
  end

  defp path_allowed?(path, options) do
    cond do
      path == "" ->
        false

      Keyword.get(options, :allow_urls, false) and Regex.match?(~r/^https?:\/\//, path) ->
        true

      Keyword.get(options, :allow_paths, false) ->
        true

      true ->
        false
    end
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
