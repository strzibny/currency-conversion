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
               {:ok,
                %CurrencyConversion.Rates{
                  base: :EUR,
                  rates: %{
                    CHF: 1.0693,
                    AUD: 1.4205,
                    BGN: 1.9558,
                    BRL: 3.4093,
                    CAD: 1.4048,
                    CNY: 7.3634,
                    CZK: 27.021,
                    DKK: 7.4367,
                    GBP: 0.85143,
                    HKD: 8.3006,
                    HRK: 7.48,
                    HUF: 310.98,
                    IDR: 14316.0,
                    ILS: 4.0527,
                    INR: 72.957,
                    JPY: 122.4,
                    KRW: 1248.1,
                    MXN: 22.476,
                    MYR: 4.739,
                    NOK: 8.9215,
                    NZD: 1.4793,
                    PHP: 53.373,
                    PLN: 4.3435,
                    RON: 4.4943,
                    RUB: 64.727,
                    SEK: 9.466,
                    SGD: 1.5228,
                    THB: 37.776,
                    TRY: 4.1361,
                    USD: 1.07,
                    ZAR: 14.31
                  }
                }}
    end
  end
end
