#' @rdname xml_fragment
#' @export
.tags <- function(..., .attr = NULL){
  n <- list(...)
  is_list <- sapply(n, is.list)
  n[!is_list] <- lapply(n[!is_list], .text)
  no_name <- which(names(n) == "" & is_list)
  if (length(no_name)) {
    stop("unnamed elements are not allowed in xml fragments")
  }

  .attr <- lapply(.attr, as.character)
  # TODO improve on the attributes, replace names with ".names" etc.
  attributes(n) <- c(attributes(n), .attr)
  n
}

.elem <- .tags


#' @rdname xml_fragment
#' @export
#' @param row_tag the name of the row tag
#' @param df data frame that will be stored as set of xml elements
.data <- function(df, row_tag = "obs"){
    m <- as.matrix(df)
    storage.mode(m) <- "character"

    l <- m |>
      apply(1, lapply, as.list) |>
      stats::setNames(rep(row_tag, nrow(df)))

    l
}

#' Create elegantly an XML fragment
#'
#' Create an xml fragment using readable R syntax, that can be used to create
#' a string, an `xml2::xml_document` or as a building block for more complex XML documents.
#'
#' An `xml_fragment` is built using
#' - named `.tags` elements, each name is a tag name, and the value is the contents
#' of the tag. The contents can be a nested `.tags` object, a character string or a numeric value.
#' - `.attr` attributes, which is set on current element, or on the `.tags` where
#' it is specified
#' - unnamed elements, which are added as text nodes.
#' - `.data` function that can be used to convert a data.frame to an xml fragment
#'
#' An `xml_doc` is a special case of an `xml_fragment` that contains exactly one
#' root element, and errors when this is not the case.
#'
#' A resulting `xml_fragment` object can be converted to an `xml2::xml_document` with
#' [xml2::as_xml_document()] or to a character string with [as.character()]. Both
#' methods are fast using a performant c++ implementation.
#' @export
#' @param ... nest named elements and characters to include in the fragment (see example)
#' @param .attr attributes to be set on the root element
#' @rdname xml_fragment
#' @return an `xml_fragment`, list object that can be converted to an `xml2::xml_document`
#' or `character` string
#' @example example/xml_fragment.R
xml_fragment <- function(..., .attr = character()){
  elems <- .tags(..., .attr = as.list(.attr))

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

#' @exportS3Method xml2::as_list
as_list.xml_fragment <- function(x, ...){

  if (length(x) != 1) {
    stop("an xml_document must contain exactly one root element.", call. = FALSE)
  }

  unclass(x)
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

shorten_character <- function(x, max_characters = 120){
  if (nchar(x) <= max_characters) {
    x
  } else {
    paste0(substr(x, 1, max_characters), "...")
  }
}

#' @export
print.xml_fragment <- function(x, ..., max_characters = 80){
  s <- list_as_xml_string(x)

  if (length(s) > 1){
    l <- length(s)
    cat("{",paste(class(x), collapse=","), " (" ,length(s),")}\n", sep="")
    s <- utils::head(s, 3)

  } else {
    cat("{",paste(class(x), collapse = ","),"}\n", sep = "")
  }
  s <- sapply(s, shorten_character, max_characters = max_characters, USE.NAMES = FALSE)
  if (length(s) <= 1){
    cat(s, "\n")
  } else {
    for (i in seq_along(s)){
      cat("[",i,"]", s[i], "\n", sep="")
    }
    cat("...\n")
  }
}

.text <- function(text){
  list(as.character(text))
}

#' @export
c.xml_fragment <- function(...){
  l <- list(...)
  # keep the class
  cls <- sapply(l, class)
  l <- lapply(l, unclass)
  l <- do.call("c", l)
  class(l) <- cls[1]
  l
}

#
# doc_list <- root("study", .attr = c(id="1"),
#   person = elem(name = "John Doe", age = "30", .attr = c(id = "p1")),
#   person = elem(name = "Jane Doe", age = "25")
# )
#
# doc_list  |> as_xml_document()
# doc_list
