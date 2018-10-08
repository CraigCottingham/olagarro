defmodule Olagarro.PDF do
  @moduledoc """
  Top-level functions for PDF handling, including file I/O.
  """

  alias Olagarro.PDF.Document

  @doc """
  Read a PDF document from an I/O stream.

  ## Options

  These are the options:
    * `:eol_marker` - The character or character sequence used in the file
      as an end-of-line marker. Can be `:lf`, `:cr`, or `:crlf`. The code
      can usually figure out for itself what the separator is, but if it
      gets it wrong you can set it explicitly here.

  ## Examples

      iex> File.stream!(\"../spec/data/document.pdf\") |> Olagarro.PDF.decode
      %Olagarro.PDF.Document{}

  """
  def decode(stream, options \\ []) do
    Document.decode(stream, options)
  end

  @doc """
  Write a PDF document to an I/O stream.

  ## Options

  These are the options:
    * `:eol_marker` - The character or character sequence used in the file
      as an end-of-line marker. Can be `:lf`, `:cr`, or `:crlf`; defaults
      to `:lf`.

  ## Examples

      iex> %Olagarro.PDF.Document{} |> Olagarro.PDF.encode
      []

  """
  def encode(%Document{} = document, options \\ []) do
    Document.encode(document, options)
  end
end
