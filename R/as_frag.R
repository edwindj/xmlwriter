#' Convert a list to an xml fragment
#'
#' As frag is a helper function to convert a named list to an xml fragment, it
#' transforms all values to character, and recursively transforms nested lists.
#' `as_frag` can be used for flexible list created xml fragments, names of a
#' list turn into tags, and values into text nodes.
#' @param x named list that will be transformed into a fragment
#' @param ... optional attributes to be set on the parent of the fragment
#' @param .attr a list of attributes to add to the parent of the fragment, overrides the `...` argument
#' @return [xml_fragment()] object as if specified with [frag()].
#' @export
#' @family xml_fragment
as_frag <- function(x, ..., .attr = list(...)){
  # recursively transform the list to fragments, needed for conversion
  # of none-character values to character etc
  is_list <- sapply(x, is.list)
  if (any(is_list)){
    x[is_list] <- lapply(x[is_list], as_frag)
    x[is_list] <- lapply(x[is_list], unclass)
  }
  x$.attr <- .attr
  do.call(frag, x)
}
