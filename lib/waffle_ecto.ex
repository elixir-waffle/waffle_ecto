defmodule Waffle.Ecto do
  @moduledoc """
  Waffle.Ecto provides an integration with Waffle and Ecto.

  Waffle attachments should be stored in a string column, with a name indicative of the attachment.

    create table :users do
      add :avatar, :string
    end
  """

  @type t :: %{file_name: String.t, updated_at: DateTime.t}
end
