#' Fast and elegant XML generation
#'
#' `xmlwriter` is an R package that provides a fast and simple interface for
#' creating XML documents and fragments from R. It has a simple elegant
#' syntax for creating `xml_fragment`s.
#' `xmlwriter`'s XML generation from R lists is fast, implemented in C++
#' using [`Rcpp`](https://cran.r-project.org/package=Rcpp).
#'
#' `xmlwriter` can be used as a companion to R packages
#' [`XML`](https://cran.r-project.org/package=XML) or
#' [`xml2`](https://cran.r-project.org/package=xml2) which are both
#' wonderful packages optimized for parsing, querying and manipulating XML
#' documents. Both `XML` and `xml2` provide several ways for creating XML
#' documents, but they are not optimized for generating and writing XML.
#'
#' Creating XML documents with `XML` and `xml2` can be a bit cumbersome,
#' mostly because it
#' forces the author to manipulate the XML document tree, obscuring the XML
#' structure of the document, and making it hard to read the XML that is
#' being generated. `xml2` does provide a way to create XML documents from
#' R data structures using nested lists which is a powerful feature, but it
#' is not optimized for speed or readability.
#'
#'
#' `xmlwriter` provides an intuitive interface for creating XML documents,
#' that mimics how XML is written in a text editor.
#' It has two different ways to create XML documents:
#'
#' -   a light weight R syntax using [tag()], [frag()], `+`, `/` and
#'     [data_frag()], creating an [xml_fragment()], that can be easily
#'    translated into a `character` or `xml2::xml_document` object, or be
#'    used as a flexible building block for generating a larger XML
#'    document.
#' -   an [xmlbuilder()] object that allows you to create XML documents in a
#'     feed-forward manner, with `start` and `end` methods, giving you more
#'     control on the XML document structure, including XML comment, prolog  etc.
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
