use Mix.Config

config :currency_conversion,
  source: CurrencyConversion.Source.Test,
  seed: {CurrencyConversion, :rates, []}
