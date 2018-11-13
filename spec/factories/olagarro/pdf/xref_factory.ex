defmodule Olagarro.PDF.Xref.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Xref.Factory.
  """

  use ExMachina

  def xref_factory(_options \\ []) do
    [
      "xref",
      "0 5",
      "0000000000 65535 f",
      "0000000018 00000 n",
      "0000000077 00000 n",
      "0000000178 00000 n",
      "0000000457 00000 n",
      "trailer",
      "  <<  /Root 1 0 R",
      "      /Size 5",
      "  >>",
      "startxref",
      "565",
    ] |> Enum.map(fn item -> item <> <<10>> end)
  end
end


# The xref section
# A contiguous group of 5 objects, starting with Object 0
# Object 0: is object number 0, generation 65535, free, space+linefeed
# Object 1: at byte offset 18, generation 0, in use, space+linefeed
#
#
#
# The trailer section
#   The document root is Object 1, Generation 0 (the Catalog dictionary)
#   The document contains 5 indirect objects
#
# Where is the newest xref?
# byte offset 565
#
# xref
# 0 5
# 0000000000 65535 f
# 0000000018 00000 n
# 0000000077 00000 n
# 0000000178 00000 n
# 0000000457 00000 n
# trailer
#   <<  /Root 1 0 R
#       /Size 5
#   >>
# startxref
# 565
