defmodule CurrencyConversionTest do
  use ExUnit.Case, async: true
  doctest CurrencyConversion

  describe "get_currencies/0" do
    test "fetches all currencies" do
      assert CurrencyConversion.get_currencies() == [
               :EUR,
               :AUD,
               :BGN,
               :BRL,
               :CAD,
               :CHF,
               :CNY,
               :CZK,
               :DKK,
               :GBP,
               :HKD,
               :HRK,
               :HUF,
               :IDR,
               :ILS,
               :INR,
               :JPY,
               :KRW,
               :MXN,
               :MYR,
               :NOK,
               :NZD,
               :PHP,
               :PLN,
               :RON,
               :RUB,
               :SEK,
               :SGD,
               :THB,
               :TRY,
               :USD,
               :ZAR
             ]
    end
  end

  describe "refresh_rates/0" do
    test "refreshes rates" do
      assert CurrencyConversion.refresh_rates() ==
               {:ok, %CurrencyConversion.Rates{base: :EUR, rates: %{CHF: 7}}}
    end
  end
end
