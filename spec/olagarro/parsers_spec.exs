defmodule Olagarro.Parsers.Spec do
  @moduledoc """
  Documentation for Olagarro.Parsers.Spec.
  """

  use ESpec
  import Olagarro.PDF.Comment.Factory
  import Olagarro.PDF.Header.Factory

  doctest Olagarro.Parsers

  context "header parser" do
    it do: expect (Olagarro.Parsers.header(header_factory(as_binary: true)))
           |> to(eq({:ok, ["%PDF-", 1, ".", 7, 10], <<239, 236, 225, 231, 225, 242, 242, 239, 10>>, %{}, {2, 9}, 9}))

    it do: expect (Olagarro.Parsers.header(header_factory(version: "1.3", as_binary: true)))
           |> to(eq({:ok, ["%PDF-", 1, ".", 3, 10], <<239, 236, 225, 231, 225, 242, 242, 239, 10>>, %{}, {2, 9}, 9}))

    it do: expect (Olagarro.Parsers.header(header_factory(binary_hint: <<0xF3, 0xF0, 0xE5, 0xE3>>, as_binary: true)))
           |> to(eq({:ok, ["%PDF-", 1, ".", 7, 10], <<243, 240, 229, 227, 10>>, %{}, {2, 9}, 9}))

    it do: expect (Olagarro.Parsers.header(header_factory(binary_hint: false, as_binary: true)))
           |> to(eq({:ok, ["%PDF-", 1, ".", 7, 10], "", %{}, {2, 9}, 9}))
  end

  context "comment parser" do
    let :raw_comment, do: comment_factory(as_binary: true)
    let :parsed_comment, do: Olagarro.Parsers.comment(raw_comment())
    # {:ok, ["%", " Sit inventore dolorem enim quos laboriosam recusandae?", 10], "", %{}, {2, 57}, 57}

    it do: expect (elem(parsed_comment(), 0)) |> to(eq(:ok))
    it do: expect (:erlang.list_to_binary(elem(parsed_comment(), 1))) |> to(eq(raw_comment()))
    it do: expect (elem(parsed_comment(), 2)) |> to(eq(""))
  end
end
