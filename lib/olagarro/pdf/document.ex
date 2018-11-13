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
  def decode(stream, options \\ []) do
    options = options |> with_defaults
    document = %Olagarro.PDF.Document{eol_marker: (options |> Keyword.get(:eol_marker, nil))}

    # a PDF consists of four parts:
    #   1. header
    #   2. body (a sequence of objects, containing at least 3 indirect objects)
    #   3. xref
    #   4. trailer (startxref and %%EOF)

    {:ok, document, stream}
    |> decode_header()
    |> decode_body()
    |> decode_xref()
    |> decode_trailer()
  end

  defp with_defaults(options) do
    options
    |> Keyword.merge(
      eol_marker: options |> Keyword.get(:eol_marker, nil)
    )
  end

  defp decode_header({:ok, document, stream}), do: decode_header({:ok, document, "", stream})
  defp decode_header({:ok, document, "%PDF-" <> <<major::size(8)>> <> "." <> <<minor::size(8), remaining::binary>>, stream}) do
    decode_eol_marker({:ok, %{document | version: "#{<<major::utf8>>}.#{<<minor::utf8>>}"}, remaining, stream})
  end
  defp decode_header({:ok, document, remaining, stream}) do
    if byte_size(remaining) < 8 do # "%PDF-1.x"
      decode_header({:ok, document, remaining <> IO.binread(stream, 1024), stream})
    else
      # didn't match header, so error
      {:error, :header_not_found}
    end
  end

  defp decode_eol_marker({:ok, document, stream}), do: decode_eol_marker({:ok, document, "", stream})
  defp decode_eol_marker({:ok, document, <<10, remaining::binary>>, stream}), do: {:ok, %{document | eol_marker: :lf}, remaining, stream}
  defp decode_eol_marker({:ok, document, <<13, 10, remaining::binary>>, stream}), do: {:ok, %{document | eol_marker: :crlf}, remaining, stream}
  defp decode_eol_marker({:ok, document, <<13, remaining::binary>>, stream}), do: {:ok, %{document | eol_marker: :cr}, remaining, stream}
  defp decode_eol_marker({:ok, document, remaining, stream}) do
    if byte_size(remaining) < 2 do # <CR><LF>
      decode_eol_marker({:ok, document, remaining <> IO.binread(stream, 1024), stream})
    else
      {:error, :eol_marker_not_found}
    end
  end

  defp decode_body({:ok, _document, _remaining, _stream} = state), do: state
  defp decode_xref({:ok, _document, _remaining, _stream} = state), do: state
  defp decode_trailer({:ok, _document, _remaining, _stream} = state), do: state

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
