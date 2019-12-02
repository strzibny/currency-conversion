defmodule CurrencyConversion.UpdateWorker do
  @moduledoc false

  use GenServer
  alias CurrencyConversion.Rates

  require Logger

  @update_worker CurrencyConversion.UpdateWorker

  @doc """
  Starts the update worker.
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @update_worker)
  end

  @spec init(:ok) :: {:ok, Rates.t()} | {:stop, any}
  def init(:ok) do
    schedule_refresh()

    # jobs = {Fun, :myfunction, [1, 3]}
    case {module, function, args} = get_seed() do
      nil ->
        case refresh() do
          {:ok, rates} -> {:ok, rates}
          {:error, binary} -> {:stop, {:error, binary}}
        end

      _ ->
        # jobs = {Fun, :myfunction, [1, 3]}
        jobs = {module, function, args}
        {m, f, a} = jobs
        result = apply(m, f, a)

        # put data with handle_call :put

        {:ok, result}
    end
  end

  @spec handle_call(:get, any, Rates.t()) :: {:reply, Rates.t(), Rates.t()}
  def handle_call(:get, _options, state) do
    {:reply, state, state}
  end

  @spec handle_call(:refresh, any, Rates.t()) ::
          {:reply, Rates.t(), Rates.t()} | {:reply, {:error, string}, Rates.t()}
  def handle_call(:refresh, _options, state) do
    schedule_refresh()

    case refresh() do
      {:ok, rates} -> {:reply, rates, rates}
      {:error, error} -> {:reply, {:error, error}, state}
    end
  end

  @spec schedule_refresh() :: :ok
  defp schedule_refresh do
    case get_refresh_interval() do
      :manual ->
        Logger.debug("Scheduling refresh was skipped due to manual mode.")

      interval ->
        Process.send_after(self(), :refresh, interval)
    end

    :ok
  end

  @spec refresh() :: tuple
  def refresh do
    case get_source().load() do
      {:ok, rates} ->
        Logger.info("Refreshed currency rates.")
        Logger.debug(inspect(rates))
        {:ok, rates}

      {:error, error} ->
        Logger.error("An error occured while rereshing currency rates. " <> inspect(error))
        {:error, error}
    end
  end

  @spec refresh_rates() :: {:ok, Rates.t()} | {:error, string}
  def refresh_rates do
    case GenServer.call(@update_worker, :refresh) do
      :error -> {:error}
      rates -> {:ok, rates}
    end
  end

  @spec get_source() :: atom
  defp get_source,
    do: Application.get_env(:currency_conversion, :source, CurrencyConversion.Source.Fixer)

  # Default: One Day
  @spec get_refresh_interval() :: integer
  defp get_refresh_interval,
    do: Application.get_env(:currency_conversion, :refresh_interval, 1000 * 60 * 60 * 24)

  @spec get_rates() :: Rates.t()
  def get_rates, do: GenServer.call(@update_worker, :get)

  defp get_seed do
    Application.get_env(:currency_conversion, :seed)
  end
end
