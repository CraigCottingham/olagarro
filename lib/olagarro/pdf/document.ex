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
    # IO.puts "in decode/2"
    options = options |> with_defaults
    document = %Olagarro.PDF.Document{eol_marker: (options |> Keyword.get(:eol_marker, nil))}

    # A PDF consists of four parts:
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
  defp decode_header({:ok, document, buffer, stream}) do
    # IO.puts "in decode_header/1; loading buffer from stream"
    if byte_size(buffer) < 8 do # "%PDF-1.x"
      case IO.binread(stream, 1024) do
        :eof ->
          {:ok, document, buffer, stream}
        {:error, _} = error_reason ->
          error_reason
        data ->
          decode_header({:ok, document, buffer <> data, stream})
      end
    else
      {:error, :header_not_found}
    end
  end

  defp decode_eol_marker({:ok, document, stream}), do: decode_eol_marker({:ok, document, "", stream})
  defp decode_eol_marker({:ok, document, <<10, remaining::binary>>, stream}), do: {:ok, %{document | eol_marker: :lf}, remaining, stream}
  defp decode_eol_marker({:ok, document, <<13, 10, remaining::binary>>, stream}), do: {:ok, %{document | eol_marker: :crlf}, remaining, stream}
  defp decode_eol_marker({:ok, document, <<13, remaining::binary>>, stream}), do: {:ok, %{document | eol_marker: :cr}, remaining, stream}
  defp decode_eol_marker({:ok, document, buffer, stream}) do
    # IO.puts "in decode_eol_marker/1; loading buffer from stream"
    if byte_size(buffer) < 2 do # <CR><LF>, in the worst case
      case IO.binread(stream, 1024) do
        :eof ->
          {:ok, document, buffer, stream}
        {:error, _} = error_reason ->
          error_reason
        data ->
          decode_eol_marker({:ok, document, buffer <> data, stream})
      end
    else
      {:error, :eol_marker_not_found}
    end
  end

  defp decode_body({:ok, document, stream}), do: decode_body({:ok, document, "", stream})
  defp decode_body({:ok, document, "", stream}) do
    # IO.puts "in decode_body/1; loading buffer from stream"
    case IO.binread(stream, 1024) do
      :eof ->
        {:ok, document, "", stream}
      {:error, _} = error_reason ->
        error_reason
      data ->
        decode_body({:ok, document, data, stream})
    end
  end
  defp decode_body({:ok, document, buffer, stream}) do
    # IO.puts "in decode_header/1; switching on comment/xref/other"
    case buffer do
      "%" <> remaining ->
        {:ok, document, remaining, stream}
        |> strip_comment
        |> decode_body
      "xref" <> _ ->
        {:ok, document, buffer, stream}
      _ ->
        {:ok, document, buffer, stream}
        |> decode_object
        |> decode_body
    end
  end

  defp decode_xref({:ok, document, stream}), do: decode_xref({:ok, document, "", stream})
  defp decode_xref({:ok, document, "", stream}) do
    # IO.puts "in decode_xref/1; loading buffer from stream"
    case IO.binread(stream, 1024) do
      :eof ->
        {:ok, document, "", stream}
      {:error, _} = error_reason ->
        error_reason
      data ->
        decode_xref({:ok, document, data, stream})
    end
  end
  defp decode_xref({:ok, _document, _buffer, _stream} = state), do: state

  defp decode_trailer({:ok, _document, _remaining, _stream} = state), do: state

  defp strip_comment({:ok, document, <<10, remaining::binary>>, stream}) do
    if document.eol_marker == :lf do
      {:ok, document, remaining, stream}
    else
      strip_comment({:ok, document, remaining, stream})
    end
  end
  defp strip_comment({:ok, document, <<13, 10, remaining::binary>>, stream}) do
    if document.eol_marker == :crlf do
      {:ok, document, remaining, stream}
    else
      strip_comment({:ok, document, <<10>> <> remaining, stream})
    end
  end
  defp strip_comment({:ok, document, <<13, remaining::binary>>, stream}) do
    if document.eol_marker == :cr do
      {:ok, document, remaining, stream}
    else
      strip_comment({:ok, document, remaining, stream})
    end
  end
  defp strip_comment({:ok, document, "", stream}) do
    case IO.binread(stream, 1024) do
      :eof ->
        {:ok, document, "", stream}
      {:error, _} = error_reason ->
        error_reason
      data ->
        strip_comment({:ok, document, data, stream})
    end
  end
  defp strip_comment({:ok, document, <<_::bytes-size(1), remaining::binary>>, stream}), do: strip_comment({:ok, document, remaining, stream})

  defp decode_object({:ok, _document, _buffer, _stream}) do

    # 1 0 obj
    #   << /Type /Catalog
    #      /Pages 2 0 R
    #   >>
    # endobj

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
