defmodule Taxjar.RatesTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open()
    request_options = [scheme: "http", host: "localhost", port: bypass.port]

    [bypass: bypass, request_options: request_options]
  end

  describe "fetches the rates for a location" do
    test "successfully fetching rates for a location", %{
      bypass: bypass,
      request_options: request_options
    } do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, ~s<{
          "rate": {
            "zip": "90404",
            "state": "CA",
            "state_rate": "0.0625",
            "county": "LOS ANGELES",
            "county_rate": "0.01",
            "city": "SANTA MONICA",
            "city_rate": "0.0",
            "combined_district_rate": "0.025",
            "combined_rate": "0.0975",
            "freight_taxable": false
          }
        }>)
      end)

      {:ok, rates} =
        "90404"
        |> Taxjar.Rates.for_location()
        |> Taxjar.request(request_options)

      assert match?(%Taxjar.Models.Rates{}, rates)
      assert rates.zip == "90404"
      assert rates.state == "CA"
      assert rates.state_rate == "0.0625"
      assert rates.county == "LOS ANGELES"
      assert rates.county_rate == "0.01"
      assert rates.city == "SANTA MONICA"
      assert rates.city_rate == "0.0"
      assert rates.combined_district_rate == "0.025"
      assert rates.combined_rate == "0.0975"
      assert rates.freight_taxable == false
    end
  end
end
