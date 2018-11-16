defmodule Olagarro.PDF.Parser.Helpers do
  import NimbleParsec

  def fractional_part(combinator \\ empty()), do: combinator |> integer(min: 1) # |> tag(:fractional_part)
  def integer_part(combinator \\ empty()), do: combinator |> integer(min: 1)
  def sign(combinator \\ empty()), do: combinator |> optional(utf8_char([?+, ?-])) |> tag(:sign)

  def resolve_boolean(["true"]), do: true
  def resolve_boolean(["false"]), do: false

  # [52, 56, 52, 53, 52, 67, 52, 67, 52, 70]
  def resolve_hexdata(tokens) when rem(length(tokens), 2) == 0, do: tokens |> List.to_string |> Base.decode16!(case: :mixed)
  # [52, 56, 52, 53, 52, 67, 52, 67, 51]
  def resolve_hexdata(tokens), do: (tokens ++ "0") |> List.to_string |> Base.decode16!(case: :mixed)

  # [{:sign, '+'}, 456]
  def resolve_integer_sign([{:sign, '+'}, value]), do: value
  # [{:sign, '-'}, 789]
  def resolve_integer_sign([{:sign, '-'}, value]), do: -value
  # [{:sign, []}, 123]
  def resolve_integer_sign([{:sign, []}, value]), do: value

  # [name: "Name", string: "value"]
  def resolve_pair([{:name, name}, {tag, value}]), do: [{:name, name}, {tag, value}]

  # [-789, 0]
  def resolve_real([integer_part, fractional_part]), do: String.to_float("#{integer_part}.#{fractional_part}")
end
