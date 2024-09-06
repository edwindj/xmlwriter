#' Create an fast feed-forward XML builder
#'
#' This function creates an XML builder that allows you to create XML documents in a feed-forward manner.
#' `xmlbuilder` returns an object that has methods to create XML elements, text nodes, comments, and more.
#'
#' - `$start(tag, ...)` (or `$start_element`) starts an element with a given tag and attributes.
#' - `$end()` (or `$end_element`) ends the current element.
#' - `$element(tag, text, ...)` creates an element with a given tag, text, and attributes.
#' - `$text(text)` creates a text node.
#' - `$comment(comment)` creates a comment node.
#' - `$to_xml_string()` returns the XML document or fragments(s) as a character vector.
#'
#' @param use_prolog logical. Should the XML prolog be included in the output?
#' Default is `TRUE`, which generate an UTF-8 xml prolog.
#' Set to `FALSE` if you want to generate an xml fragment or manually prepend the prolog.
#' @param single_root_warn logical. Should a warning be issued if the XML document has multiple root elements?
#' Set to `FALSE` to suppress when creating multiple xml fragments.
#' @return An object of class `xmlbuilder
#' @example example/xmlbuilder.R
#' @export
xmlbuilder <- function(use_prolog = TRUE, single_root_warn = TRUE){
  xb <- new.env()

  xb$x <- xmlbuilder_create(use_prolog)

  xb$start <- function(tag, ...){
    attr <- list(...)
    xmlbuilder_start_element(xb$x, tag, attr)
    # invisible(xb)
  }

  # aliases
  xb$start_element <- xb$start

  xb$end <- function(){
    xmlbuilder_end_element(xb$x)
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
    if (single_root_warn && length(s) > 1){
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

  xb$to_xml_node

  structure(xb, class="xmlbuilder")
}

#' @export
print.xmlbuilder <- function(x, ...){
  cat(x$to_xml_string(), ...)
}

#' @exportS3Method xml2::as_xml_document
as_xml_document.xmlbuilder <- function(x, ...){
  if (requireNamespace("xml2", quietly = TRUE) == FALSE){
    stop("xml2 package is required to convert xmlbuilder object to xml_document")
  }
  xml2::read_xml(x$to_xml_string(), ...)
}
