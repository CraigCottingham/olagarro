defmodule Olagarro.PDF.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Factory.
  """

  use ExMachina

  def document_factory do
    Enum.join([
      "PDF-1.3",
    ], "\n") <> <<10>>
  end
end
