#' Convert a list to an xml node
#'
#' `list_to_xml_node` is fast and efficient way to convert a list to an `xml2::xml_node`.
#'
#' `list_to_xml_node` is a much faster implementation of `xml2::as_xml_document.list()` method.
#' It writes the xml directly to a string and then reads it back into an `xml2::xml_node`.
#' Note that it returns the root node of the document, not the document itself.
#' It therefore can be used to create fragments or single nodes.
#'
#' The function can be used in tandem with [xml2::as_list()] to convert R data structures.
#' @family xml2
#' @param x a list as returned by [xml2::as_list()]
#' @param ... reserved for future use
#' @return an `xml2::xml_document`
#' @export
list_to_xml_node <- function(x, ...){
  if (!requireNamespace("xml2", quietly = TRUE)) {
    stop("xml2 is required to use this function")
  }
  s <- rcpp_list_to_xml_string(x)

  s |>
    xml2::read_xml() |>
    xml2::xml_root()
}
