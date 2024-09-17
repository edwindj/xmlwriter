#' Create a fast feed-forward XML builder
#'
#' This function creates an XML builder that allows you to create XML documents in a feed-forward manner.
#' `xmlbuilder` returns an object that has methods to create XML elements, text nodes, comments, and more.
#'
#' - `$start(tag, ...)` (or `$start_element`) starts an element with a given tag and attributes.
#' - `$end()` (or `$end_element`) ends the current element.
#' - `$element(tag, text, ...)` creates an element with a given tag, text, and attributes.
#' - `$text(text)` creates a text node.
#' - `$fragment(..., .attr)` writes an xml fragment to the.
#' - `$comment(comment)` creates a comment node.
#' - `$to_xml_string()` returns the XML document or fragments(s) as a character vector.
#'
#' @param allow_fragments logical. Should a warning be issued if the XML document has multiple root elements?
#' Set to `FALSE` to suppress when creating multiple xml fragments.
#' @param use_prolog logical. Should the XML prolog be included in the output?
#' Default is `TRUE`, which generate an UTF-8 xml prolog.
#' Set to `FALSE` if you want to generate an xml fragment or manually prepend the prolog.
#' @param strict logical. Should the builder check for dangling nodes, default is `FALSE`.
#' @return An object of class `xmlbuilder
#' @example example/xmlbuilder.R
#' @export
xmlbuilder <- function(allow_fragments = TRUE, use_prolog = !allow_fragments, strict = FALSE){
  xb <- new.env()

  xb$x <- xmlbuilder_create(use_prolog, strict = strict)

  xb$start <- function(tag, ...){
    attr <- list(...) |> lapply(as.character)
    xmlbuilder_start_element(xb$x, tag, attr)
    # invisible(xb)
  }

  # aliases
  xb$start_element <- xb$start

  xb$end <- function(tag = ""){
    xmlbuilder_end_element(xb$x, tag)
    # invisible(xb)
  }

  #alias
  xb$end_element <- xb$end

  xb$element <- function(tag, text = NULL, ...){
    attr <- list(...)
    text <- if(is.null(text)) "" else as.character(text[1])
    xmlbuilder_write_element(xb$x, tag, text, attr)
    # invisible(xb)
  }

  xb$comment <- function(comment){
    xmlbuilder_write_comment(xb$x, comment)
    # invisible(xb)
  }

  xb$text <- function(text){
    xmlbuilder_text_node(xb$x, paste(text, collapse = "\n"))
    # invisible(xb)
  }

  xb$to_xml_string <- function(){
    s <- xmlbuilder_to_string(xb$x)
    if (length(s) > 1 && !allow_fragments){
      warning("Multiple root elements detected. XML requires a single root element. \nReturning character vector with multiple roots.", call. = FALSE)
    }
    s
  }

  xb$to_xml_node_list <- function(){
    if (!requireNamespace("xml2", quietly = TRUE)) {
      stop("xml2 is required to use this function")
    }
    s <- xb$to_xml_string()
    lapply(s, xml2::read_xml)
  }

  xb$get_partial_xml <- function(){
    xmlbuilder_get_partial_xml(xb$x)
  }

  xb$append_xmlbuilder <- function(xb2){
    xmlbuilder_append_xmlbuilder(xb$x, xb2$x)
  }

  xb$raw_xml <- function(s){
    for (xml in as.character(s)){
      xmlbuilder_write_raw_xml(xb$x, xml)
    }
  }

  xb$fragment <- function(..., .attr = NULL, .fragment = xml_fragment(..., .attr=.attr)){
    stopifnot(inherits(.fragment, "xml_fragment"))
    for (xml in as.character(.fragment)){
      xmlbuilder_write_raw_xml(xb$x, xml)
    }
  }

  structure(xb, class="xmlbuilder")
}

#' @export
print.xmlbuilder <- function(x, ..., max_characters = 120){
  cat("{xmlbuilder}\n")
  s <- x$get_partial_xml()
  if (length(s) <= max_characters) {
    cat(s)
  } else {
    s <- substr(s, 1, max_characters)
    cat(s, "...", sep="")
  }
}

#' @export
as.character.xmlbuilder <- function(x, ...){
  x$to_xml_string()
}

#' @exportS3Method xml2::as_xml_document
as_xml_document.xmlbuilder <- function(x, ...){
  if (requireNamespace("xml2", quietly = TRUE) == FALSE){
    stop("xml2 package is required to convert xmlbuilder object to xml_document")
  }
  s <- x$to_xml_string()
  if (length(s) > 1){
    warning("The xml fragment has multiple roots and cannot be converted into an xml_document.\n
Converted the first element...", call. = FALSE)
  }
  xml2::read_xml(s[1])
}
