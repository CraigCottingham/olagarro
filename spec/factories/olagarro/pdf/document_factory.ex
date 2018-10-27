defmodule Olagarro.PDF.Document.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Document.Factory.
  """

  use ExMachina

  def document_factory(options \\ []) do
    Olagarro.PDF.Header.Factory.header_factory(options)
    |> Enum.join
  end
end
