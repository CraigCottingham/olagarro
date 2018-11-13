defmodule Olagarro.PDF.Document.Spec do
  @moduledoc """
  Documentation for Olagarro.PDF.Document.Spec.
  """

  use ESpec
  import Olagarro.PDF.Document.Factory

  # doctest Olagarro.PDF.Document

  describe "factory specs" do
    # yes, I'm writing specs for factories
    # I suspect I'll pull these once I'm comfortable that the factories are working correctly
    it do: expect (document_factory()) |> to(start_with("%PDF-1.7" <> <<10>> <> "%" <> <<239, 236, 225, 231, 225, 242, 242, 239>> <> <<10>>))
    it do: expect (document_factory(version: "1.3")) |> to(start_with("%PDF-1.3" <> <<10>> <> "%" <> <<239, 236, 225, 231, 225, 242, 242, 239>> <> <<10>>))
    it do: expect (document_factory(binary_hint: <<0xF3, 0xF0, 0xE5, 0xE3>>)) |> to(start_with("%PDF-1.7" <> <<10>> <> "%" <> <<243, 240, 229, 227>> <> <<10>>))
    it do: expect (document_factory(binary_hint: false)) |> to(start_with("%PDF-1.7" <> <<10>>))
    it do: expect (document_factory(binary_hint: nil)) |> to(start_with("%PDF-1.7" <> <<10>>))
  end

  describe "parsing header" do
    before do
      {:ok, stream_pid} = StringIO.open(data())
      {:shared, stream: stream_pid}
    end

    let :data, do: "%PDF-1.7" <> <<10>>
    let :decoded, do: Olagarro.PDF.decode(shared.stream)

    it do: expect (elem(decoded(), 0)) |> to(eq(:ok))
  end

  describe "detecting end-of-line marker" do
    before do
      {:ok, stream_pid} = StringIO.open(data())
      {:shared, stream: stream_pid}
    end

    let :decoded, do: Olagarro.PDF.decode(shared.stream)
    let :status, do: decoded() |> elem(0)
    let :document, do: decoded() |> elem(1)

    context "when it is LF" do
      let :data, do: "%PDF-1.7" <> <<10>>
      it do: expect (status()) |> to(eq(:ok))
      it do: expect (document().eol_marker) |> to(eq(:lf))
    end

    context "when it is CRLF" do
      let :data, do: "%PDF-1.7" <> <<13, 10>>
      it do: expect (status()) |> to(eq(:ok))
      it do: expect (document().eol_marker) |> to(eq(:crlf))
    end

    context "when it is CR" do
      let :data, do: "%PDF-1.7" <> <<13>>
      it do: expect (status()) |> to(eq(:ok))
      it do: expect (document().eol_marker) |> to(eq(:cr))
    end
  end

  describe "parsing comments" do
    before do
      {:ok, stream_pid} = StringIO.open(data())
      {:shared, stream: stream_pid}
    end

    let :decoded, do: Olagarro.PDF.decode(shared.stream)
    let :status, do: decoded() |> elem(0)
    let :document, do: decoded() |> elem(1)

    context "when eol-marker is :lf" do
      let :data, do: "%PDF-1.7" <> <<10>> <> "% this is a comment" <> <<10>>
      it do: expect (status()) |> to(eq(:ok))
    end

    context "when eol-marker is :lf and the comment contains a different EOL marker" do
      let :data, do: "%PDF-1.7" <> <<10>> <> "% this is a comment containing " <> <<13, 10>>
      it do: expect (status()) |> to(eq(:ok))
      it do: expect (document().eol_marker) |> to(eq(:lf))
    end

    context "when eol-marker is :crlf" do
      let :data, do: "%PDF-1.7" <> <<13, 10>> <> "% this is a comment" <> <<13, 10>>
      it do: expect (status()) |> to(eq(:ok))
    end

    context "when eol-marker is :cr" do
      let :data, do: "%PDF-1.7" <> <<13>> <> "% this is a comment" <> <<13>>
      it do: expect (status()) |> to(eq(:ok))
    end
  end
end
