defmodule Olagarro.PDF.Document.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Document.Factory.
  """

  use ExMachina

  import FactoryHelpers
  import Olagarro.PDF.Dictionary.Factory
  import Olagarro.PDF.Header.Factory
  import Olagarro.PDF.IndirectObject.Factory
  import Olagarro.PDF.Stream.Factory
  import Olagarro.PDF.Xref.Factory

  def document_factory(options \\ []) do
    header_factory(options)
    # catalog object
    |> cons(dictionary_factory(:catalog) |> indirect_object_factory(object_number: 1))
    # pages object
    |> cons(dictionary_factory(:pages) |> indirect_object_factory(object_number: 2))
    # page object
    |> cons(dictionary_factory(:page) |> indirect_object_factory(object_number: 3))
    # stream object
    |> cons(stream_factory() |> indirect_object_factory(object_number: 4))
    # xref object
    |> cons(xref_factory())
    |> cons("%%EOF") # end of file marker
    |> to_binary
  end

end
