defmodule Taxjar.Config do
  @moduledoc """
  Interfacing with the Taxjar config should be done via this module.

  Taxjar can be configured in your `config.exs` like so:

    config :taxjar, Taxjar.Config,
      api_token: System.get_env("TAXJAR_API_TOKEN")
  """
  @type scope :: :global | :process

  def current_scope do
    if Process.get(:_taxjar_config, nil), do: :process, else: :global
  end

  @doc """
  Get Taxjar configuration values.
  """
  @spec get() :: Keyword.t | nil
  @spec get(scope) :: Keyword.t | nil
  def get, do: get(current_scope())
  def get(:global) do
    Application.get_env(:taxjar, Taxjar.Config, nil)
  end
  def get(:process), do: Process.get(:_taxjar_config, nil)

  @doc """
  Set Taxjar configuration values.
  """
  @spec set(Keyword.t) :: :ok
  @spec set(scope, Keyword.t) :: :ok
  def set(config), do: set(current_scope(), config)
  def set(:global, config), do: Application.put_env(:taxjar, Taxjar.Config, config)
  def set(:process, config) do
    Process.put(:_taxjar_config, config)
    :ok
  end
end
