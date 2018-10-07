defmodule FooSpec do
  use ESpec
  import TestFactory

  it do: expect true |> to(be_true())
  it do: (1..3) |> should(have 2)
  it do: expect (foo_factory()) |> to(eq("bar"))
end
