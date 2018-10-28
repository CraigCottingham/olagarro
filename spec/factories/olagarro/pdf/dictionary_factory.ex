defmodule Olagarro.PDF.Dictionary.Factory do
  @moduledoc """
  Documentation for Olagarro.PDF.Dictionary.Factory.
  """

  use ExMachina

  # def dictionary_factory(options \\ []), do: dictionary_data(Keyword.get(options, :type), options)

  def dictionary_factory(type, options \\ [])

  # Begin a Catalog dictionary
  #   The root Pages object: Object 2, Generation 0
  # End dictionary
  #
  # << /Type /Catalog
  #    /Pages 2 0 R
  # >>
  def dictionary_factory(:catalog, _options) do
    [
      "<< /Type /Catalog",
         "/Pages 2 0 R",
      ">>"
    ]
  end

  # Begin a Pages dictionary
  #   An array of the individual pages in the document
  #   The array contains only one page
  #   Global page size, lower-left to upper-right, measured in points
  # End dictionary
  #
  # << /Type /Pages
  #    /Kids [3 0 R]
  #    /Count 1
  #    /MediaBox [0 0 300 144]
  # >>
  def dictionary_factory(:pages, _options) do
    [
      "<< /Type /Pages",
         "/Kids [3 0 R]",
         "/Count 1",
         "/MediaBox [0 0 300 144]",
      ">>"
    ]
  end

  # Begin a Page dictionary
  #
  #   The resources for this page…
  #     Begin a Font resource dictionary
  #       Bind the name "F1" to
  #         a Font dictionary
  #           It's a Type 1 font
  #           and the font face is Times-Roman
  #
  #
  #
  #   The contents of the page: Object 4, Generation 0
  #
  # <<  /Type /Page
  #     /Parent 2 0 R
  #     /Resources
  #      << /Font
  #          << /F1
  #              << /Type /Font
  #                 /Subtype /Type1
  #                 /BaseFont /Times-Roman
  #              >>
  #          >>
  #      >>
  #     /Contents 4 0 R
  # >>
  def dictionary_factory(:page, _options) do
    [
      "<< /Type /Page",
         "/Parent 2 0 R",
         "/Resources",
           "<< /Font",
                "<< /F1",
                     "<< /Type /Font",
                        "/Subtype /Type1",
                        "/BaseFont /Times-Roman",
                     ">>",
                ">>",
           ">>",
         "/Contents 4 0 R",
      ">>"
    ]
  end

  ## all other dictionary types
  def dictionary_factory(type, _options) do
    [
      "<< /Type #{type}",
         "/Pages 2 0 R",
      ">>"
    ]
  end
end
