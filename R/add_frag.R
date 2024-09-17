#' Add a fragment with a tag to an existing xml_fragment
#'
#' `append_frag` add a tag with supplied `contents` to an `xml_fragment`. The `tag` argument
#' is the name of the tag, and `contents` is the contents of the tag, which can be
#' an xml_fragment, a character string, or a list of xml_fragment or character strings.
#'
#' @param x an `xml_fragment`
#' @param tag character, the name of the tag (single value)
#' @param contents character, xml_fragment or list of xml_fragment or character strings
#' @param ... additional attributes to add to the tag
#' @param .attr a list of additional attributes to add to the tag, override the `...` argument
#' @return an `xml_fragment` with the new tag added
#' @family xml_fragment
#' @export
append_frag <- function(x, tag, contents, ..., .attr = list(...)){
  stopifnot(inherits(x, "xml_fragment"))
  contents <- unclass(contents)
  if (!is.list(contents)){
    contents <- contents |>
      as.character() |>
      as.list()
  }
  attributes(contents) <- c(attributes(contents), .attr)
  e <- list(contents)
  names(e) <- tag
  c(x, e)
}


#' Add a child fragment
#'
#' Adds a child fragment to an existing xml_fragment
#' @param x an xml_fragment
#' @param tag character, the name of the tag
#' @param contents character, xml_fragment or list of xml_fragment or character strings
#' @param ... additional attributes to add to the tag
#' @param .attr a list of additional attributes to add to the tag, overrides the `...` argument
#' @return an xml_fragment with the new child added
#' @family xml_fragment
#' @export
add_child <- function(x, tag, contents, ..., .attr = list(...)){
  last_node <- x[[length(x)]]
  class(last_node) <- "xml_fragment"
  x[[length(x)]] <-
    last_node |>
    append_frag(tag, contents, .attr = .attr) |>
    unclass()
  x
}

#'@export
`+.xml_fragment` <- function(e1,e2){
  c(e1,e2)
}


# x <- xml_fragment(a = 1)
# .add_tag(x, "test", 2, id = "2")
