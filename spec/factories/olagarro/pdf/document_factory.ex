defmodule Olagarro.PDF.Document.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Document.Factory.
  """

  use ExMachina

  def document_factory(version \\ "1.7") do
    Enum.join([
      "PDF-#{version}",
    ], "\n") <> <<10>>
  end
end
