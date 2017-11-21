defmodule Taxjar do
  @moduledoc false

  def configure(config)
  def configure(config), do: configure(:global, config)

  @doc """
  Configures the Taxjar application at runtime.

  ## Example
      # Set the api_token to be used globally
      Taxjar.configure(api_token: "asdf1234hjkl7890")

      # Set the api_token to be used for requests from this process only
      Taxjar.configure(:process, api_token: "asdf1234hjkl7890")
  """
  @spec configure(:global | :process, Keyword.t) :: :ok
  def configure(scope, config)
  def configure(:global, config), do: Taxjar.Config.set(:global, config)
  def configure(:process, config), do: Taxjar.Config.set(:process, config)
end
