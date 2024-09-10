#' Fast and elegant XML generation
#'
#' `xmlwriter` is an R package that provides a simple interface for creating XML documents
#' and fragments from R. It provides a simple elegant syntax for creating `xml_fragment`s and furthermore
#' contains a feed-forward API that allows you to write xml.
#'
#' `xmlwriter`'s xml generation from R lists is fast, implemented in C++ using [`Rcpp`](https://cran.r-project.org/package=Rcpp).
#'
#' `xmlwriter` provides two different ways to create xml documents:
#'
#' - a light weight R syntax using [xml_doc()], [xml_fragment()] and [.tags()], creating an xml fragment
#' that can be easily translated into a xml string or `xml2::xml_document` object
#' - a feed-forward API using [xmlbuilder()] that allows you to create xml documents in a feed-forward manner.
#'
#' It implements several `xml2` methods:
#'
#' - `as_xml_document.xml_fragment()`
#' - `as_list.xml_fragment()`
#' - `write_xml.xml_fragment()`
#'
#' @example example/xml_fragment.R
"_PACKAGE"


## usethis namespace: start
#' @importFrom Rcpp sourceCpp
#' @useDynLib xmlwriter, .registration = TRUE
## usethis namespace: end
NULL
