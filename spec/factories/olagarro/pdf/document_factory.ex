defmodule Olagarro.PDF.Document.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Document.Factory.
  """

  use ExMachina

  def document_factory(version \\ "1.7") do
    [
      "%PDF-#{version}",
      # Olagarro.PDF.Comment.Factory.comment_factory(),
    ] |> Enum.map(fn item -> item <> <<10>> end)
      |> Enum.join
  end
end
