defmodule Olagarro.PDF.Document.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Document.Factory.
  """

  use ExMachina

  import FactoryHelpers
  # import Olagarro.PDF.Comment.Factory
  # import Olagarro.PDF.Dictionary.Factory
  import Olagarro.PDF.Header.Factory
  # import Olagarro.PDF.IndirectObject.Factory
  # import Olagarro.PDF.Stream.Factory
  # import Olagarro.PDF.Xref.Factory

  def document_factory(options \\ []) do
    binary_hint = Keyword.get(options, :binary_hint, true)

    header_factory(options)
    |> cons(add_binary_hint(binary_hint))

    # # catalog object
    # |> cons(dictionary_factory(:catalog) |> indirect_object_factory(object_number: 1))
    # # pages object
    # |> cons(dictionary_factory(:pages) |> indirect_object_factory(object_number: 2))
    # # page object
    # |> cons(dictionary_factory(:page) |> indirect_object_factory(object_number: 3))
    # # stream object
    # |> cons(stream_factory() |> indirect_object_factory(object_number: 4))
    # # xref object
    # |> cons(xref_factory())
    # |> cons("%%EOF") # end of file marker

    |> to_binary(true)
  end

  # "olagarro" with the high bit set on every byte
  defp add_binary_hint(true), do: ["%" <> <<0xEF, 0xEC, 0xE1, 0xE7, 0xE1, 0xF2, 0xF2, 0xEF>>]
  defp add_binary_hint(false), do: nil
  defp add_binary_hint(nil), do: nil
  defp add_binary_hint(hint), do: ["%" <> hint]
end
