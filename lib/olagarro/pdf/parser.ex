defmodule Olagarro.PDF.Parser do
  @moduledoc """
  Defines a structure representing a PDF document.
  """

  import NimbleParsec
  import Olagarro.PDF.Parser.Helpers

  # nul, \t, \n, \f, \r, space respectively
  whitespace_values = [0, 9, 10, 12, 13, 32]
  whitespace_char = utf8_char(whitespace_values)
  whitespace_str = utf8_string(whitespace_values, min: 1)

  delimiter_values = [?(, ?), ?<, ?>, ?[, ?], ?{, ?}, ?/, ?%]

  terminator_values = whitespace_values ++ delimiter_values
  terminator_char = utf8_char(terminator_values)

  integer = sign()
            |> integer_part()
            |> reduce(:resolve_integer_sign)
            |> unwrap_and_tag(:integer)
            |> ignore(repeat(whitespace_char))
  real = sign()
         |> integer_part()
         |> reduce(:resolve_integer_sign)
         |> ignore(utf8_char([?.]))
         |> fractional_part()
         |> reduce(:resolve_real)
         |> unwrap_and_tag(:real)
         |> ignore(repeat(whitespace_char))
  string_hexdata = ignore(utf8_char([?<]))
                   |> repeat_until(utf8_char([?0..?9, ?A..?F, ?a..?f]), [utf8_char([?>])])
                   |> ignore(utf8_char([?>]))
                   |> reduce(:resolve_hexdata)
                   |> unwrap_and_tag(:string)
                   |> ignore(repeat(whitespace_char))
  # TODO: support enclosed parentheses, escape sequences, and octal character codes
  string_literal = ignore(utf8_char([?(]))
                   |> repeat_until(utf8_char([]), [utf8_char([?)])])
                   |> ignore(utf8_char([?)]))
                   |> reduce({List, :to_string, []})
                   |> unwrap_and_tag(:string)
                   |> ignore(repeat(whitespace_char))

  boolean = choice([string("true"), string("false")])
            |> reduce(:resolve_boolean)
            |> unwrap_and_tag(:boolean)
            |> ignore(repeat(whitespace_char))
  numeric = choice([real, integer])
  string = choice([string_literal, string_hexdata])
  name = ignore(utf8_char([?/]))
         |> repeat_until(utf8_char([]), [terminator_char])
         |> reduce({List, :to_string, []})
         |> unwrap_and_tag(:name)
         |> ignore(repeat(whitespace_char))
  array = ignore(utf8_char([?[]))
          |> repeat_until(parsec(:direct_object), [utf8_char([?]])])
          |> ignore(utf8_char([?]]))
          |> tag(:array)
          |> ignore(repeat(whitespace_char))
  dictionary = ignore(string("<<"))
               |> repeat_until(parsec(:pair), [string(">>")])
               |> ignore(string(">>"))
               |> tag(:dictionary)
               |> ignore(repeat(whitespace_char))
  stream = dictionary
           |> string("stream")
           |> repeat_until(ascii_char([]), [string("endstream")])
           |> string("endstream")
           |> unwrap_and_tag(:stream)
  null = string("null")
         |> replace(nil)
         |> unwrap_and_tag(:null)
         |> ignore(repeat(whitespace_char))

  defcombinatorp :pair, name
                        |> parsec(:direct_object)
                        |> reduce(:resolve_pair)

  defcombinatorp :direct_object, choice([
                                   boolean,
                                   numeric,
                                   string,
                                   name,
                                   array,
                                   dictionary,
                                   stream,
                                   null
                                 ])

  obj_number = integer(min: 1)
               |> unwrap_and_tag(:obj_number)

  # gen_number = integer(min: 1)
  #              |> unwrap_and_tag(:gen_number)

  indirect_object = obj_number
                    |> ignore(whitespace_str)
                    # |> gen_number
                    # |> ignore(whitespace_str)
                    |> string("obj")
                    |> parsec(:direct_object)
                    |> string("endobj")

  defparsec :object, choice([indirect_object, parsec(:direct_object)])
end
