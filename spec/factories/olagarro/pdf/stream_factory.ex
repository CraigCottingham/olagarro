defmodule Olagarro.PDF.Stream.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Stream.Factory.
  """

  use ExMachina

  def stream_factory(_options \\ []) do
    [
      "<< /Length 55 >>",
      "stream",
      "  BT",
      "    /F1 18 Tf",
      "    0 0 Td",
      "    (Hello World) Tj",
      "  ET",
      "endstream"
    ]
  end
end


# A stream, 55 bytes in length
# Begin stream
# Begin Text object
#   Use F1 font at 18 point size
#   Position the text at 0,0
#   Show text Hello World
# End Text
# End stream
#
# << /Length 55 >>
# stream
# BT
#   /F1 18 Tf
#   0 0 Td
#   (Hello World) Tj
# ET
# endstream
