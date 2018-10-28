defmodule Olagarro.PDF.Comment.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Comment.Factory.
  """

  use ExMachina

  import FactoryHelpers

  def comment_factory(options \\ []) do
    as_binary = Keyword.get(options, :as_binary, false)

    ["% #{Faker.Lorem.sentence}"]
    |> to_binary(as_binary)
  end
end
