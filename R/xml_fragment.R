#' Create an element with attributes
#' @rdname xml_fragment
#' @export
.elem <- function(..., .attr = character()){
  n <- list(...)
  is_list <- sapply(n, is.list)
  n[!is_list] <- lapply(n[!is_list], .text)

  .attr <- lapply(.attr, as.character)
  # TODO improve on the attributes, replace names with ".names" etc.
  attributes(n) <- c(attributes(n), .attr)
  n
}

#' Create an XML fragment
#'
#' Create an xml fragment that can be converted fast into to an `xml2::xml_document`
#' or `character` string
#' @export
#' @param ... nest named elements and characters to include in the fragment (see example)
#' @param .attr attributes to be set on the root element
#' @rdname xml_fragment
#' @return an `xml_fragment`, list object that can be converted to an `xml2::xml_document`
#' or `character` string
#' @example example/xml_fragment.R
xml_fragment <- function(..., .attr = character()){
  elems <- .elem(..., .attr = as.list(.attr))

  class(elems) <- "xml_fragment"
  elems
}

#' Create an xml_fragment that contains exactly one element
#' @export
#' @rdname xml_fragment
xml_doc <- function(..., .attr = character()){
  root <- xml_fragment(..., .attr = .attr)
  if (length(root) != 1) {
    stop("xml_doc must contain exactly one root element")
  }
  class(root) <- c("xml_doc", class(root))
  root
}

#' @exportS3Method xml2::as_xml_document
as_xml_document.xml_fragment <- function(x, ...){

  if (length(x) != 1) {
    stop("an xml_document must contain exactly one root element.", call. = FALSE)
  }

  x |>
    list_as_xml_document()
}

#' Transforms an xml_fragment into an xml_nodeset
#'
#' Using the `xml2` package, this function transforms an `xml_fragment` into an `xml_nodeset`
#' @param x an object created with [xml_fragment()]
#' @param ... reserved for future use
#' @export
as_xml_nodeset <- function(x, ...){
  if (!requireNamespace("xml2", quietly = TRUE)) {
    stop("xml2 is required to convert an xml_fragment to xml_nodeset")
  }

  root <-
    list(root = x) |>
    list_as_xml_document()

  xml2::xml_children(root)
}

#' Turn an xml_fragment into a character
#'
#' This function turns an `xml_fragment` into a character string, using
#' a performant c++ implementation.
#' @inheritParams base::as.character.default
#' @rdname as.character.xml_fragment
#' @export
as.character.xml_fragment <- function(x, ...){
  x |>
    list_as_xml_string()
}

#' @export
#' @rdname as.character.xml_fragment
#' @param use_prolog if `TRUE` the xml prolog with be included.
#' To suppress the prolog string either remove it manually or set `use_prolog = FALSE`.
as.character.xml_doc <- function(x, use_prolog=TRUE,...){
  if (use_prolog) {
    paste(
      "<?xml version='1.0' encoding='UTF-8'?>",
      list_as_xml_string(x)
    )
  } else {
    list_as_xml_string(x)
  }
}


#' @export
print.xml_fragment <- function(x, ...){
  cat(x |>
    list_as_xml_string(), ...)
}

.text <- function(text){
  list(as.character(text))
}

#
# doc_list <- root("study", .attr = c(id="1"),
#   person = elem(name = "John Doe", age = "30", .attr = c(id = "p1")),
#   person = elem(name = "Jane Doe", age = "25")
# )
#
# doc_list  |> as_xml_document()
# doc_list
