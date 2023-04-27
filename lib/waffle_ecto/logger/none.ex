defmodule WaffleEcto.Logger.None do
  @behaviour WaffleEcto.Logger

  def log(_, _) do
    :ok
  end
end
