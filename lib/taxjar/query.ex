defmodule Taxjar.Query do
  @moduledoc """
  All requests to Taxjar will be composed via a Taxjar.Query struct.
  """
  defstruct [
    http_method: :get,
    path: "/",
    params: %{},
    additional_headers: %{}
  ]

  @type t :: %__MODULE__{
    http_method: :get | :post | :put | :patch | :delete,
    path: String.t,
    params: map,
    additional_headers: map
  }

  @spec perform(t, Keyword.t) :: {:ok, any} | {:error, Taxjar.Error.t}
  def perform(query, config) do
    url = build_url(query, config)
    data = URI.encode_query(query.params)
    api_token = Keyword.get_lazy(
      Taxjar.Config.get,
      :api_token,
      fn -> raise "Taxjar api_token not set." end
    )

    headers = [{"Authorization", "Bearer #{api_token}"}]

    Taxjar.HTTP.request(query.http_method, url, data, headers)
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
end
