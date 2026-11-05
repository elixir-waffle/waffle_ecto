defmodule Waffle.Ecto do
  @moduledoc ~S"""
  Waffle.Ecto connects your Waffle definition with Ecto via custom Ecto types.

  First, connect Waffle.Ecto to your uploader definition

      defmodule MyApp.AvatarUploader do
        use Waffle.Ecto.Definition

        def storage_dir(_, {_, scope}), do: "uploads/avatar/#{scope.id}"
      end

  Second, use the definition's Ecto-compatible type in your schema

      defmodule MyApp.User do
        schema "users" do
          field :avatar, MyApp.AvatarUploader.Type
        end

        def changeset(user, attrs) do
          user
          |> cast_attachments(attrs, [:avatar])
        end
      end

  Please read `Waffle.Ecto.Schema.cast_attachments/4` for details on how attachment casting works.

  Also, Waffle.Ecto stores the `updated_at` timestamp in the file schema and automatically adds it to the URL for cache busting.

  ## How to use schema `id` in storage directory

  If you have auto-generated record IDs, you need to insert a record before processing the file upload.

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:user, User.changeset(user, attrs))
      |> Ecto.Multi.update(:user_with_avatar, &User.avatar_changeset(&1.user, attrs))
      |> Repo.transaction()

  """

  @type t :: %{file_name: String.t(), updated_at: DateTime.t()}
end
