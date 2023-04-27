defmodule WaffleEcto.Logger.Default do
  @behaviour WaffleEcto.Logger

  require Logger

  def log(:info, message), do: Logger.info(message)
  def log(:warning, message), do: Logger.warning(message)
  def log(:error, message), do: Logger.error(message)
end
