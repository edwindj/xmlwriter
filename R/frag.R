#' Create a frag xml_fragment
#'
#' Create a `frag` xml_fragment, that allows for multiple elements and nested
#' `frag`s.
#' @inheritParams xml_fragment
#' @export
#' @param .attr a list of attributes to add to the parent of the fragment
#' @example example/xml_fragment.R
#' @family xml_fragment
frag <- function(..., .attr = NULL){
  n <- list(...)
  is_list <- sapply(n, is.list)

  # turn all none-lists into text nodes
  if (length(n) > 0){
    no_name <- if (is.null(names(n))) {TRUE} else {names(n) == ""}

    n[is_list] <- lapply(n[is_list], unclass)
    n[!is_list] <- lapply(n[!is_list], .text)
    n[(!is_list) & no_name] <- lapply(n[(!is_list) & no_name], as.character)

    # check for unnamed elements
    if (any(no_name & is_list)) {
      stop("unnamed elements are not allowed in xml fragments")
    }
  }

  .attr <- lapply(.attr, as.character)
  # TODO improve on the attributes, replace names with ".names" etc.
  attributes(n) <- c(attributes(n), .attr)
  class(n) <- "xml_fragment"
  n
}
