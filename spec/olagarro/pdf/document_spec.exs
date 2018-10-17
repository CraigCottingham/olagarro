defmodule Olagarro.PDF.Document.Spec do
  @moduledoc """
  Documentation for Olagarro.PDF.Document.Spec.
  """

  use ESpec
  import Olagarro.PDF.Document.Factory

  doctest Olagarro.PDF.Document

  it do: expect (document_factory()) |> to(eq("PDF-1.7" <> <<10>>))
  it do: expect (document_factory("1.3")) |> to(eq("PDF-1.3" <> <<10>>))
  it do: expect (document_factory("1.7")) |> to(eq("PDF-1.7" <> <<10>>))
end
