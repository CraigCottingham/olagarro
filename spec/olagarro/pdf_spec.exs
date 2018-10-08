defmodule Olagarro.PDF.Spec do
  @moduledoc """
  Documentation for Olagarro.PDF.Spec.
  """

  use ESpec
  import Olagarro.PDF.Factory

  doctest Olagarro.PDF

  it do: expect (document_factory()) |> to(eq("PDF-1.3" <> <<10>>))
end
