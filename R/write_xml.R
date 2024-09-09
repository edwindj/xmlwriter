#' @exportS3Method xml2::write_xml
write_xml.xml_fragment <- function(x, file, ...){
  if (!requireNamespace("xml2", quietly = TRUE)) {
    stop("xml2 is required to use this function")
  }

  if (length(x) != 1) {
    stop("an xml_document must contain exactly one root element.", call. = FALSE)
  }

  x |>
    list_as_xml_string() |>
    cat(file = file)
}

#' @exportS3Method xml2::write_xml
write_xml.xmlbuilder <- function(x, file, ...){
  if (!requireNamespace("xml2", quietly = TRUE)) {
    stop("xml2 is required to use this function")
  }

  s <- x$to_xml_string()

  if (length(s) != 1) {
    stop("an xml_document must contain exactly one root element.", call. = FALSE)
  }

  cat(file = file)
}
