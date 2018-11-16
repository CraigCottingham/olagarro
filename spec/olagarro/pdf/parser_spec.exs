defmodule Olagarro.PDF.Parser.Spec do
  @moduledoc """
  Documentation for Olagarro.PDF.Parser.Spec.
  """

  use ESpec

  # doctest Olagarro.PDF.Parser

  example_group "direct object" do
    let :output, do: input() |> Olagarro.PDF.Parser.object
    let :status, do: elem(output(), 0)
    let :acc, do: elem(output(), 1)
    let :rest, do: elem(output(), 2)
    let :context, do: elem(output(), 3)
    let :line, do: elem(output(), 4)
    let :column, do: elem(output(), 5)

    describe "boolean objects" do
      context "true" do
        let :input, do: "true"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([boolean: true]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "false" do
        let :input, do: "false"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([boolean: false]))
          expect(rest()) |> to(eq(""))
        end
      end
    end

    describe "integer objects" do
      context "no leading sign" do
        let :input, do: "123"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([integer: 123]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "leading +" do
        let :input, do: "+456"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([integer: 456]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "leading -" do
        let :input, do: "-789"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([integer: -789]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "trailing whitespace" do
        let :input, do: "123   "
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([integer: 123]))
          expect(rest()) |> to(eq(""))
        end
      end
    end

    describe "real objects" do
      context "no leading sign" do
        let :input, do: "123.4"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([real: 123.4]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "leading +" do
        let :input, do: "+456.7"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([real: 456.7]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "leading -" do
        let :input, do: "-789.0"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([real: -789.0]))
          expect(rest()) |> to(eq(""))
        end
      end
    end

    describe "string literal objects" do
      context "a simple string" do
        let :input, do: "(a simple string)"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([string: "a simple string"]))
          expect(rest()) |> to(eq(""))
        end
      end

      # TODO: empty string
      # TODO: enclosed parentheses
      # TODO: escape sequences
      # TODO: octal character codes
    end

    describe "string hexdata objects" do
      context "with an even number of nibbles" do
        let :input, do: "<48454C4C4F>"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([string: "HELLO"]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "with mixed case" do
        let :input, do: "<48454C4C4f>"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([string: "HELLO"]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "with an odd number of nibbles" do
        let :input, do: "<48454C4C3>"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([string: "HELL0"]))
          expect(rest()) |> to(eq(""))
        end
      end
    end

    describe "name objects" do
      context "a simple name" do
        let :input, do: "/Name"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([name: "Name"]))
          expect(rest()) |> to(eq(""))
        end
      end

      # TODO: embedded hex codes
      # TODO: embedded "#"
    end

    describe "array objects" do
      context "empty array" do
        let :input, do: "[]"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([array: []]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "single element" do
        let :input, do: "[123]"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([array: [integer: 123]]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "multiple elements" do
        let :input, do: "[123 456 789]"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([array: [integer: 123, integer: 456, integer: 789]]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "different object types" do
        let :input, do: "[123.4 true /SomeName]"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([array: [real: 123.4, boolean: true, name: "SomeName"]]))
          expect(rest()) |> to(eq(""))
        end
      end

      # TODO: included dictionary
      # TODO: nested arrays
    end

    describe "dictionary objects" do
      context "empty dictionary" do
        let :input, do: "<<>>"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([dictionary: []]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "single pair" do
        let :input, do: "<</Key (value)>>"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([dictionary: [[name: "Key", string: "value"]]]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "multiple pairs" do
        let :input, do: "<</X 123.4 /Y 567.8>>"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([dictionary: [[name: "X", real: 123.4], [name: "Y", real: 567.8]]]))
          expect(rest()) |> to(eq(""))
        end
      end

      context "different object types" do
        let :input, do: "<</Name (foo bar) /Age 90 /Baz true>>"
        example do
          expect(status()) |> to(eq(:ok))
          expect(acc()) |> to(eq([dictionary: [[name: "Name", string: "foo bar"], [name: "Age", integer: 90], [name: "Baz", boolean: true]]]))
          expect(rest()) |> to(eq(""))
        end
      end

      # TODO: included array
      # TODO: nested dictionaries
    end

    describe "stream objects" do

    end

    describe "null object" do
      let :input, do: "null"
      example do
        expect(status()) |> to(eq(:ok))
        expect(acc()) |> to(eq([null: nil]))
        expect(rest()) |> to(eq(""))
      end
    end

    describe "indirect objects" do

    end

  end

end
