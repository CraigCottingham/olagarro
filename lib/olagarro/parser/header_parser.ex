defmodule Olagarro.Parser.HeaderParser do
  @moduledoc """
  Defines a parser for a PDF file header.
  """

  import NimbleParsec

  @doc """
  Parse a PDF file header from a binary.

  ## Examples

      iex> ("%PDF-1.7" <> <<10>>) |> Olagarro.Parser.HeaderParser.parse
      {}

  """
  header =
    string("%PDF-")
    |> integer(1)
    |> string(".")
    |> integer(1)
    |> choice([ascii_char([10]), concat(ascii_char([13]), ascii_char([10])), ascii_char([13])])

  defparsec :parse, header
end
