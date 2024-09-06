
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xmlwriter

<!-- badges: start -->

<!-- badges: end -->

xmlwriter is a package that provides a simple interface for creating XML
documents and fragments from R. It has a feed-forward API that allows
you to write xml in the same order as it appears in the document or
fragment.

It can be used as a companion to `xml2`, which is a wonderful package
optimized for parsing, querying and manipulating XML documents.

Creating xml documents with `xml2` can be a bit cumbersome, because it
forces the author to manipulate the xml document tree. `xmlwriter`
provides a more natural interface for creating xml documents.

`xmlwriter` is built on top of `Rcpp` and is fast.

## Installation

You can install the development version of xmlwriter from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edwindj/xmlwriter")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(xmlwriter)

b <- xmlbuilder()

b$start("person", id = "1")
  b$element("name", "John Doe")
  b$element("age", 30)
  b$start("address")
    b$element("street", "123 Main St")
    b$element("city", "Anytown")
    b$element("state", "CA")
    b$element("zip", 12345)
  b$end()
b$end()

b$to_xml_string()
#> [1] "<?xml version='1.0' encoding='UTF-8'?><person id='1'><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address></person>"
```

``` r
xml2::as_xml_document(b)
#> {xml_document}
#> <person id="1">
#> [1] <name>John Doe</name>
#> [2] <age>30</age>
#> [3] <address>\n  <street>123 Main St</street>\n  <city>Anytown</city>\n  <sta ...
```

# Performance

The package is optimized for generating xml.

``` r
library(microbenchmark)
library(xml2)
library(xmlwriter)

# read in a sample 600k xml file as a R list str
doc <- xml2::read_xml("./example/DataGeneric.xml")
doc_list <- xml2::as_list(doc)

# see how long it takes to create an xml document with xml2 and xmlwriter

microbenchmark(
  xml2 = xml2::as_xml_document(doc_list),
  xmlwriter = xmlwriter::list_to_xml_node(doc_list),
  times = 10
)
#> Warning in microbenchmark(xml2 = xml2::as_xml_document(doc_list), xmlwriter =
#> xmlwriter::list_to_xml_node(doc_list), : less accurate nanosecond times to
#> avoid potential integer overflows
#> Unit: milliseconds
#>       expr       min         lq      mean     median         uq        max
#>       xml2 2398.2886 2431.66125 2450.1169 2455.84160 2471.88426 2482.95073
#>  xmlwriter   35.4142   36.93747   42.5319   40.18203   41.01558   75.67243
#>  neval
#>     10
#>     10
```
