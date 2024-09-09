#' Convert a list to an xml_document
#'
#' `list_as_xml_document` is fast and efficient way to convert a list to an `xml2::xml_document`.
#' The preferred interface is to use [xml_fragment()] and [xml_doc()] to create xml fragments.
#'
#' `list_to_xml_document` is a much faster implementation of `xml2::as_xml_document.list()` method.
#' It writes the xml directly to a string buffer and then reads it back into an `xml2::xml_document`.
#'
#' The function can be used in tandem with [xml2::as_list()] to convert R data structures.
#' @family xml2
#' @param x a list as returned by [xml2::as_list()]
#' @param ... reserved for future use
#' @return an `xml2::xml_document`
#' @example example/list_to_xml_string.R
#' @export
list_as_xml_document <- function(x, ...){
  if (!requireNamespace("xml2", quietly = TRUE)) {
    stop("xml2 is required to use this function")
  }
  s <- rcpp_list_to_xml_string(x)

  s |>
    xml2::read_xml()
}
