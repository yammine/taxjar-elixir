defmodule Taxjar.Models.Rates do
  defstruct [
    :zip,
    :state,
    :state_rate,
    :county,
    :county_rate,
    :city,
    :city_rate,
    :combined_district_rate,
    :combined_rate,
    :freight_taxable,

    # International
    :country,
    :name,

    # Australia / SST states
    :country_rate,

    # European Union
    :standard_rate,
    :reduced_rate,
    :super_reduced_rate,
    :parking_rate,
    :distance_sale_threshold
  ]

  @type t :: %__MODULE__{}

  def new(map) do
    rates =
      map
      |> Map.get("rate")
      |> atomize_keys

    struct(__MODULE__, rates)
  end

  defp atomize_keys(map) do
    Enum.reduce(map, %{}, fn {k, v}, acc ->
      Map.put(acc, String.to_atom(k), v)
    end)
  end
end
