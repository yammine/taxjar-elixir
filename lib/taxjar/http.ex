defmodule Taxjar.HTTP do
  def request(method, url, data, headers) do
    HTTPoison.request(method, url, data, headers)
  end
end
