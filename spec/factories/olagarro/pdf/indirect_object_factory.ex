defmodule Olagarro.PDF.IndirectObject.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.IndirectObject.Factory.
  """

  use ExMachina

  def indirect_object_factory(object_definition, options \\ []) do
    object_number = Keyword.get(options, :object_number, 1)
    generation_number = Keyword.get(options, :generation_number, 0)

    [
      "#{object_number} #{generation_number} obj",
      object_definition,
      "endobj"
    ]
  end
end
