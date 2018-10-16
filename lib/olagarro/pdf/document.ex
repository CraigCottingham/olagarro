defmodule Olagarro.PDF.Document do
  @moduledoc """
  Defines a structure representing a PDF document.
  """

  defstruct [
    :version,
    :eol_marker
  ]

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
      %Olagarro.PDF.Document{eol_marker: :lf}

  """
  def decode(_stream, options \\ []) do
    options = options |> with_defaults

    %Olagarro.PDF.Document{eol_marker: (options |> Keyword.get(:eol_marker, :lf))}
  end

  defp with_defaults(options) do
    options
    |> Keyword.merge(
      eol_marker: options |> Keyword.get(:eol_marker, :lf)
    )
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
  def encode(%Olagarro.PDF.Document{} = _document, _options \\ []) do
    []
  end
end
