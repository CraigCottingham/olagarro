defmodule Olagarro.PDF.Document do
  @moduledoc """
  Defines a structure representing a PDF document.
  """

  defstruct [:version]

  @doc """
  Read a PDF document from an I/O stream.

  ## Options

  These are the options:
    * `:eol_marker` - The character or character sequence used in the file
      as an end-of-line marker. Can be `:lf`, `:cr`, or `:crlf`. The code
      can usually figure out for itself what the separator is, but if it
      gets it wrong you can set it explicitly here.

  ## Examples

      iex> File.stream!(\"../spec/data/document.pdf\") |> Olagarro.PDF.Document.decode
      %Olagarro.PDF.Document{}

  """
  def decode(_stream, _options \\ []) do
    %Olagarro.PDF.Document{}
  end
end
