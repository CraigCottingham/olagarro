defmodule Olagarro.PDF.Document.Spec do
  @moduledoc """
  Documentation for Olagarro.PDF.Document.Spec.
  """

  use ESpec
  import Olagarro.PDF.Document.Factory

  # doctest Olagarro.PDF.Document

  it do: expect (document_factory()) |> to(start_with("%PDF-1.7" <> <<10>> <> "%" <> <<239, 236, 225, 231, 225, 242, 242, 239>> <> <<10>>))
  it do: expect (document_factory(version: "1.3")) |> to(start_with("%PDF-1.3" <> <<10>> <> "%" <> <<239, 236, 225, 231, 225, 242, 242, 239>> <> <<10>>))
  it do: expect (document_factory(binary_hint: <<0xF3, 0xF0, 0xE5, 0xE3>>)) |> to(start_with("%PDF-1.7" <> <<10>> <> "%" <> <<243, 240, 229, 227>> <> <<10>>))
  it do: expect (document_factory(binary_hint: false)) |> to(start_with("%PDF-1.7" <> <<10>>))
  it do: expect (document_factory(binary_hint: nil)) |> to(start_with("%PDF-1.7" <> <<10>>))
end
