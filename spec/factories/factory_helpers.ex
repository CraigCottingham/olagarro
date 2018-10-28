defmodule FactoryHelpers do
  @moduledoc """
  Documentation for FactoryHelpers.
  """

  # require IEx

  def cons(left, right) do
    [left, right]
  end

  def to_binary(list, true) do
    list
    |> List.flatten
    |> Enum.map(fn item -> item <> <<10>> end)
    # |> (fn list -> IEx.pry; list end).()
    |> Enum.join
  end
  def to_binary(list, _), do: list
end
