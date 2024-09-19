#' Add a child fragment to an existing xml_fragment
#'
#' Add a child fragment to an existing xml_fragment.
#' The child fragment can be a named `frag` element in which case the name
#' is used as the tag name, an unnamed element in which case the element
#' is added as a text node. This functionality is equivalent with the `/` operator.
#' @export
#' @param x an [xml_fragment()] object
#' @inheritParams xml_fragment
#' @param .frag an xml_fragment to add as a child, overrides the ... argument
#' @family xml_fragment
add_child_fragment <- function(x, ..., .frag = frag(...)){
  stopifnot(inherits(x, "xml_fragment"))

  if (length(x) == 0){
    stop("add_child_fragment requires an existing xml_fragment")
  }

  last_node <- x[[length(x)]]
  a <- attributes(last_node)
  # this adds a child to the last node
  last_node <-
    last_node |>
    append(.frag) |>
    unclass()
  attributes(last_node) <- c(a, attributes(last_node))

  x[[length(x)]] <- last_node
  x
}

#' @export
`>.xml_fragment` <- function(e1, e2){
  add_child_fragment(e1, .frag = e2)
}

#' @export
`/.xml_fragment` <- function(e1, e2){
  add_child_fragment(e1, .frag = e2)
}

#'@export
`+.xml_fragment` <- function(e1,e2){
  c(e1,e2)
}


# x <- xml_fragment(a = 1)
# .add_tag(x, "test", 2, id = "2")
