#' Read an XML fragment from a string
#'
#' Reads a xml fragment from a string, a connection or a raw vector using
#' [xml2::read_xml()], and turns it into a [xml_fragment()].
#' @export
#' @param x A string, a connection or a raw vector
#' @param ... passed to [xml2::read_xml()]
read_fragment <- function(x, ...){
  if (!requireNamespace("xml2", quietly = TRUE)) {
    stop("xml2 is required to use this function")
  }

  fragment <-
    xml2::read_xml(x, ...) |>
    xml2::as_list()

  class(fragment) <- "xml_fragment"

  fragment
}
