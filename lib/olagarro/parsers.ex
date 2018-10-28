defmodule Olagarro.Parsers do
  @moduledoc """
  Defines parsers for PDF data.
  """

  import NimbleParsec

  cr = ascii_char([13])
  crlf = concat(ascii_char([13]), ascii_char([10]))
  lf = ascii_char([10])

  end_of_line = choice([lf, crlf, cr])

  defparsec :header,
    string("%PDF-")
    |> integer(1)
    |> string(".")
    |> integer(1)
    |> concat(end_of_line)

  defparsec :comment,
    string("%")
    |> optional(ascii_string([not: 10, not: 13], min: 1))
    |> concat(end_of_line)
end
