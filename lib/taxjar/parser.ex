defmodule Taxjar.Parser do
  @moduledoc """
  This module is responsible for parsing responses from the Taxjar API and coercing them into their
  respsective structs. If you would like to define custom parser logic see Taxjar.Query.t
  """

  alias Taxjar.Models.Rates

  @type result :: {:ok, any} | {:error, Taxjar.Error.t()}

  def parse({:ok, response}, action) do
    response.body
    |> Poison.decode!()
    |> parse(action)
  end

  def parse({:error, error_response}, _action), do: build_client_error(error_response)

  def parse(response, :rates_for_location) do
    {:ok, Rates.new(response)}
  end

  defp build_client_error(error) do
    error_messages =
      error.body
      |> Poison.decode!()
      |> Map.take(["error", "detail"])

    message = "#{error_messages["error"]}. #{error_messages["detail"]}"

    {:error, %Taxjar.Error{code: error.status_code, message: message}}
  end
end
