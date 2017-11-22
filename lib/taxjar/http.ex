defmodule Taxjar.HTTP do
  @moduledoc """
  TODO: Add some docs
  """

  def request(method, url, data, headers) do
    if Application.get_env(:taxjar, Taxjar.Config, [])[:debug_requests] do
      require Logger
      Logger.debug("REQUEST_URL: #{url}")
      Logger.debug("REQUEST_METHOD: #{method}")
      Logger.debug("REQUEST_HEADERS: #{inspect(headers)}")
      Logger.debug("REQUEST_BODY: #{inspect(data)}")
    end

    case HTTPoison.request(method, url, data, headers) do
      {:ok, %{status_code: code}} = response when code in 200..299 or code == 304 ->
        response
      {:ok, %{status_code: code} = error_response} when code in 400..499 ->
        {:error, error_response}
      {:ok, %{status_code: code}} when code >= 500 ->
        raise "TODO handle this"
    end
  end
end
