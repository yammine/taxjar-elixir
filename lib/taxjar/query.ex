defmodule Taxjar.Query do
  @moduledoc """
  All requests to Taxjar will be composed via a Taxjar.Query struct.
  """
  alias Taxjar.Parser

  defstruct action: nil,
            http_method: :get,
            path: "/",
            params: %{},
            additional_headers: %{},
            parser: &Parser.parse/2

  @type t :: %__MODULE__{
          action: nil | Atom.t(),
          http_method: :get | :post | :put | :patch | :delete,
          path: String.t(),
          params: map,
          additional_headers: map,
          parser: (String.t() -> Parser.result())
        }

  @spec perform(t, Keyword.t()) :: {:ok, any} | {:error, Taxjar.Error.t()}
  def perform(query, config) do
    url = build_url(query, config)
    data = URI.encode_query(query.params)

    api_token =
      Keyword.get_lazy(Taxjar.Config.get(), :api_token, fn ->
        raise "Taxjar api_token not set."
      end)

    headers = [{"Authorization", "Bearer #{api_token}"}]

    result = Taxjar.HTTP.request(query.http_method, url, data, headers)

    query.parser.(result, query.action)
  end

  defp build_url(query, config) do
    config
    |> Keyword.take([:scheme, :host, :port])
    |> do_build_url(query.path)
  end

  defp do_build_url(config, path) do
    case config[:port] do
      nil -> "#{config[:scheme]}://#{config[:host]}#{path}"
      port -> "#{config[:scheme]}://#{config[:host]}:#{port}#{path}"
    end
  end

  @doc """
  Merges a map of params into the provided Taxjar.Query
  """
  @spec merge_params(t, map) :: t
  def merge_params(query, params) do
    new_params = Map.merge(query.params, params)
    %{query | params: new_params}
  end

  @doc """
  Merges a map of headers into the provided Taxjar.Query
  """
  @spec merge_headers(t, map) :: t
  def merge_headers(query, headers) do
    new_headers = Map.merge(query.additional_headers, headers)
    %{query | additional_headers: new_headers}
  end
end
