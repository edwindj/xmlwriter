#' Create a tag fragment
#'
#' Create a tag fragment with optional text and attributes
#' @param tag character, the name of the tag
#' @param text character, the text to include in the tag
#' @param ... additional attributes to add to the tag
#' @param .attr a list of additional attributes to add to the tag, overrides the `...` argument
#' @return an xml_fragment with the new tag added
#' @export
#' @example example/tag.R
tag <- function(tag, text = NULL, ..., .attr = list(...)){
  tg <- if (is.null(text)){
    list(frag(.attr = .attr) |> unclass())
  } else {
    list(frag(text, .attr = .attr) |> unclass())
  }

  names(tg) <- tag
  class(tg) <- "xml_fragment"

  tg
}
