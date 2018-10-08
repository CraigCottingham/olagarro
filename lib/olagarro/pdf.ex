defmodule Olagarro.PDF do
  @moduledoc """
  Top-level functions for PDF handling, including file I/O.
  """

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
      []

  """
  def decode(_stream, _options \\ []) do
    []
  end

  @doc """
  Write a PDF document to an I/O stream.

  ## Options

  These are the options:
    * `:eol_marker` - The character or character sequence used in the file
      as an end-of-line marker. Can be `:lf`, `:cr`, or `:crlf`; defaults
      to `:lf`.

  ## Examples

      iex> nil |> Olagarro.PDF.encode
      []

  """
  def encode(_stream, _options \\ []) do
    []
  end

end
