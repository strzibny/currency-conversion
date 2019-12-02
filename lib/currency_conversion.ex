defmodule CurrencyConversion do
  @moduledoc """
  Module to Convert Currencies.
  """

  alias CurrencyConversion.Rates
  alias CurrencyConversion.UpdateWorker

  @doc """
  Convert from currency A to B.

  ### Example

      iex> CurrencyConversion.convert(Money.new(7_00, :CHF), :USD, %CurrencyConversion.Rates{base: :EUR,
      ...>  rates: %{CHF: 0.5, USD: 0.75}})
      %Money{amount: 10_50, currency: :USD}

      iex> CurrencyConversion.convert(Money.new(7_00, :EUR), :USD, %CurrencyConversion.Rates{base: :EUR,
      ...>  rates: %{CHF: 0.5, USD: 0.75}})
      %Money{amount: 5_25, currency: :USD}

      iex> CurrencyConversion.convert(Money.new(7_00, :CHF), :EUR, %CurrencyConversion.Rates{base: :EUR,
      ...>  rates: %{CHF: 0.5, USD: 0.75}})
      %Money{amount: 14_00, currency: :EUR}

      iex> CurrencyConversion.convert(Money.new(0, :CHF), :EUR, %CurrencyConversion.Rates{base: :EUR,
      ...>  rates: %{CHF: 0.5, USD: 0.75}})
      %Money{amount: 0, currency: :EUR}

      iex> CurrencyConversion.convert(Money.new(7_20, :CHF), :CHF, %CurrencyConversion.Rates{base: :EUR,
      ...>  rates: %{CHF: 0.5, USD: 0.75}})
      %Money{amount: 7_20, currency: :CHF}

  """
  @spec convert(Money.t(), atom, Rates.t()) :: Money.t()
  def convert(amount, to_currency, rates \\ UpdateWorker.get_rates())
  def convert(%Money{amount: 0}, to_currency, _), do: Money.new(0, to_currency)
  def convert(amount = %Money{currency: currency}, currency, _), do: amount

  def convert(%Money{amount: amount, currency: currency}, to_currency, %Rates{
        base: currency,
        rates: rates
      }) do
    Money.new(round(amount * Map.fetch!(rates, to_currency)), to_currency)
  end

  def convert(%Money{amount: amount, currency: currency}, to_currency, %Rates{
        base: to_currency,
        rates: rates
      }) do
    Money.new(round(amount / Map.fetch!(rates, currency)), to_currency)
  end

  def convert(amount, to_currency, rates) do
    convert(convert(amount, rates.base, rates), to_currency, rates)
  end

  @doc """
  Get all currencies

  ### Examples

      iex> CurrencyConversion.get_currencies(%CurrencyConversion.Rates{base: :EUR,
      ...>  rates: %{CHF: 0.5, USD: 0.75}})
      [:EUR, :CHF, :USD]

  """
  @spec get_currencies(Rates.t()) :: [atom]
  def get_currencies(rates \\ UpdateWorker.get_rates())
  def get_currencies(%Rates{base: base, rates: rates}), do: [base | Map.keys(rates)]

  @doc """
  Refresh exchange rates

  ### Examples

      iex> CurrencyConversion.refresh_rates()
      {:ok, %CurrencyConversion.Rates{base: :EUR, rates: %{CHF: 1.0693, AUD: 1.4205, BGN: 1.9558, BRL: 3.4093, CAD: 1.4048, CNY: 7.3634, CZK: 27.021, DKK: 7.4367, GBP: 0.85143, HKD: 8.3006, HRK: 7.48, HUF: 310.98, IDR: 14316.0, ILS: 4.0527, INR: 72.957, JPY: 122.4, KRW: 1248.1, MXN: 22.476, MYR: 4.739, NOK: 8.9215, NZD: 1.4793, PHP: 53.373, PLN: 4.3435, RON: 4.4943, RUB: 64.727, SEK: 9.466, SGD: 1.5228, THB: 37.776, TRY: 4.1361, USD: 1.07, ZAR: 14.31}}}

  """
  @spec refresh_rates() :: tuple
  def refresh_rates do
    UpdateWorker.refresh_rates()
  end
end
