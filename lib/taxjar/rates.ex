defmodule Taxjar.Rates do
  alias Taxjar.Query

  def for_location(zip, opts \\ []) do
    conditional_and_optional_params =
      opts
      |> Keyword.take([:country, :state, :city, :street])
      |> Enum.into(%{})

    path = "/rates/#{zip}"

    path
    |> Query.new(:get, :rates_for_location)
    |> Query.merge_params(conditional_and_optional_params)
  end
end
