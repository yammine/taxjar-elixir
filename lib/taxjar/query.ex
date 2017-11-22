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

  @typep action :: nil | Atom.t()
  @typep http_method :: :get | :post | :put | :patch | :delete
  @typep path :: String.t()
  @typep params :: Map.t()
  @typep headers :: Map.t()
  @typep parser :: (String.t(), action -> Parser.result())

  @type t :: %__MODULE__{
          action: action,
          http_method: http_method,
          path: path,
          params: params,
          additional_headers: headers,
          parser: parser
        }

  @doc """
  Creates a new Query struct with provided data
  """
  @spec new(path, http_method, action) :: t
  def new(path, method, action) do
    %__MODULE__{
      action: action,
      http_method: method,
      path: path
    }
  end

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
  @spec merge_params(t, params) :: t
  def merge_params(query, params) do
    new_params = Map.merge(query.params, params)
    %{query | params: new_params}
  end

  @doc """
  Merges a map of headers into the provided Taxjar.Query
  """
  @spec merge_headers(t, headers) :: t
  def merge_headers(query, headers) do
    new_headers = Map.merge(query.additional_headers, headers)
    %{query | additional_headers: new_headers}
  end

  @doc """
  Customize the parser to be used on the response body.
  """
  @spec customize_parser(t, parser) :: t
  def customize_parser(query, parser_fun) when is_function(parser_fun, 2) do
    %{query | parser: parser_fun}
  end
end
