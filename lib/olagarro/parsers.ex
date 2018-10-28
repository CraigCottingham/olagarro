defmodule Olagarro.Parsers do
  @moduledoc """
  Defines parsers for PDF data.
  """

  import NimbleParsec

  defparsec :header,
    string("%PDF-")
    |> integer(1)
    |> string(".")
    |> integer(1)
    |> choice([ascii_char([10]), concat(ascii_char([13]), ascii_char([10])), ascii_char([13])])
end
