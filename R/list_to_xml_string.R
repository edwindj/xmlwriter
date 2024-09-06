#' Convert a list to an xml string
#'
#' `list_to_xml_string` is fast and efficient way to convert a list to an xml string.
#'
#' The list format is identical to the format returned by [xml2::as_list()] function,
#' but much, much faster. This function allows for easy conversion of R data structures
#' into xml format by creating the list structures in R and then converting them to xml.
#'
#' The function can be used in tandem with [xml2::as_list()] to convert R data structures
#' @family xml2
#' @param x a list as returned by [xml2::as_list()]
#' @param ... reserved for future use
#' @export
list_to_xml_string <- function(x, ...){
  rcpp_list_to_xml_string(x)
}
