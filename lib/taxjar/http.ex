defmodule Taxjar.HTTP do
  def request(method, url, data, headers) do
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
