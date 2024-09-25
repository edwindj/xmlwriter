#' Convert a list to an xml string
#'
#' `list_to_xml_string` is fast and efficient way to convert a specific list to an xml string.
#' The preferred interface is to use [xml_fragment()] and [xml_doc()] to create xml fragments.
#'
#' This function is the working horse for turning [xml_fragment()], [xml_doc()] and list
#' object into `character` xml strings and `xml2::xml_document` objects.
#'
#' The input list format is identical to the format returned by [xml2::as_list()] function,
#' but much faster in generating an xml string from it. It writes the xml directly to a string buffer.
#'
#' This function allows for easy conversion of R data structures
#' into xml format by creating the list structures in R and then converting them to xml.
#' The function can be used in tandem with [xml2::as_list()] to convert R data structures.
#'
#' @family xml2
#' @param x a list as returned by [xml2::as_list()]
#' @param ... reserved for future use
#' @return a character string with the xml representation of the list
#' @example example/list_to_xml_string.R
#' @export
list_as_xml_string <- function(x, ...){
  rcpp_list_to_xml_string(x)
}
