defmodule WaffleEcto.Logger do
  @type level :: :info | :warning | :error

  @callback log(level :: level(), message :: binary) :: :ok

  @adapter Application.compile_env(:waffle_ecto, :log_adapter, WaffleEcto.Logger.Default)

  @doc ~S"""
  Log a message using the log adapter.
  This function expect an atom representing the level (`:info`, `:warning`, `:error`) and a message.

  The logger will be fetch from the application configuration.

  ```elixir
  config :waffle_ecto, :log_adapter, WaffleEcto.Logger.Default
  ```

  By default it will use the Default logger which use the Elixir Logger module.

  You can define you own adapter by adding `@behaviour WaffleEcto.Logger` to your adapter module
  and defining the callback `log/2`.

  ```elixir
  defmodule MyAdapter do
    @behaviour Waffle.Ecto

    def log(level, message) do
      #do something
    end
  end
  ```

  You can avoid logging messages by using adding this to your config file:

  ```elixir
  config :waffle_ecto, :log_adapter, WaffleEcto.Logger.None
  ```

  ## Examples

      log(:warning, "Large file size")
      log(:error, "Invalid file extensions")

  """
  @spec log(level :: level, message :: binary()) :: :ok
  def log(level, message) do
    @adapter.log(level, message)
  end
end
