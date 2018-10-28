defmodule Olagarro.PDF.Header.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Header.Factory.
  """

  use ExMachina

  import FactoryHelpers

  def header_factory(options \\ []) do
    version = Keyword.get(options, :version, "1.7")
    binary_hint = Keyword.get(options, :binary_hint, true)
    as_binary = Keyword.get(options, :as_binary, false)

    ["%PDF-#{version}"]
    |> add_binary_hint(binary_hint)
    |> to_binary(as_binary)
  end

  # "olagarro" with the high bit set on every byte
  defp add_binary_hint(list, true), do: list ++ [<<0xEF, 0xEC, 0xE1, 0xE7, 0xE1, 0xF2, 0xF2, 0xEF>>]
  defp add_binary_hint(list, false), do: list
  defp add_binary_hint(list, nil), do: list
  defp add_binary_hint(list, hint), do: list ++ [hint]
end
