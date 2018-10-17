defmodule Olagarro.PDF.Comment.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Comment.Factory.
  """

  use ExMachina

  def comment_factory do
    [
      "% #{Faker.Lorem.sentence}",
    ] |> Enum.map(fn item -> item <> <<10>> end)
      |> Enum.join
  end
end
