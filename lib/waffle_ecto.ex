defmodule Waffle.Ecto do
  @moduledoc """
  Waffle.Ecto provides an integration with `Waffle` and `Ecto`.

  Waffle attachments should be stored in a string column, with a name indicative of the attachment.

      create table :users do
        add :avatar, :string
      end

  ## How to add `waffle_ecto` to your project

    * add [Schema](Waffle.Ecto.Schema.html) to the model
    * configure [Definition](Waffle.Ecto.Definition.html) for uploader

  ## Pages

    * [How to use `:id` in filepath](filepath-with-id.html)

  """

  @type t :: %{file_name: String.t, updated_at: DateTime.t}
end
