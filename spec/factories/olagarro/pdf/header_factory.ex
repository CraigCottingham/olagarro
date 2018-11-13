defmodule Olagarro.PDF.Header.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Header.Factory.
  """

  use ExMachina

  import FactoryHelpers

  def header_factory(options \\ []) do
    version = Keyword.get(options, :version, "1.7")
    as_binary = Keyword.get(options, :as_binary, false)

    ["%PDF-#{version}"]
    |> to_binary(as_binary)
  end
end
