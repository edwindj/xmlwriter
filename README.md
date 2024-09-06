
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xmlwriter

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/xmlwriter)](https://CRAN.R-project.org/package=xmlwriter)
[![R-CMD-check](https://github.com/edwindj/xmlwriter/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edwindj/xmlwriter/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`xmlwriter` is an R package that provides a simple interface for
creating XML documents and fragments from R. It has a feed-forward API
that allows you to write xml in the same order as it appears in an xml
document or fragment. Its main goal is to provide a simple and fast way
to create xml documents and fragments.

`xmlwriter` can be used as a companion to R package
[`xml2`](https://cran.r-project.org/package=xml2), which is a wonderful
package optimized for parsing, querying and manipulating XML documents.
`xml2` provides several ways for creating xml documents, but it is not
optimized for generating and writing xml.

Creating xml documents with `xml2` can be a bit cumbersome, because it
mostly forces the author to manipulate the xml document tree adding
nodes and attributes. It *does* provide a way to create xml documents
from R data structures using nested lists. This is a very powerful
feature, but not optimized for speed and readability.

`xmlwriter` provides a more natural interface for creating xml
documents, that mimicks the way xml is written in a text editor. It has
two different ways to create xml documents:

- a light weight R syntax using `xml_fragment` and `.elem` functions,
  creating an `xml_fragment`, that can be easily translated into a xml
  string or `xml2::xml_document` object, or be used as a flexible
  building block for generating a larger xml document.
- an `xmlbuilder` object that allows you to create xml documents in a
  feed-forward manner, with `start` and `end` methods, giving you more
  control on the xml document structure, including xml comment, prolog
  etc.

## Installation

You can install the development version of xmlwriter from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edwindj/xmlwriter")
```

## Example

### Using `xml_fragment`, `.elem` functions:

``` r
library(xmlwriter)

fragment <- xml_fragment(
  persoon = .elem(
    .attr = c(id = "1"),
    name = "John Doe",
    age = 30,
    address = .elem(
       street = "123 Main St",
       city = "Anytown",
       state = "CA",
       zip = 12345
    )
  )
)

print(fragment)
#> <persoon id='1'><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address></persoon>
```

``` r
fragment |> xml2::as_xml_document()
#> {xml_document}
#> <persoon id="1">
#> [1] <name>John Doe</name>
#> [2] <age>30</age>
#> [3] <address>\n  <street>123 Main St</street>\n  <city>Anytown</city>\n  <sta ...
```

``` r
fragment |> as_xml_nodeset()
#> {xml_nodeset (1)}
#> [1] <persoon id="1">\n  <name>John Doe</name>\n  <age>30</age>\n  <address>\n ...
```

### Using `xmlbuilder` object

``` r
library(xmlwriter)

b <- xmlbuilder(allow_fragments = FALSE)
b$comment("This is an xml comment")
b$start("person", id = "1")
  b$element("name", "John Doe")
  b$element("age", 30)
  b$start("address")
    b$element("street", "123 Main St")
    b$element("city", "Anytown")
    b$element("state", "CA")
    b$element("zip", 12345)
  b$end()
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

# includes a xml prolog and comment
b$to_xml_string()
#> Warning in xmlbuilder_to_string(xb$x): There are still open tags. Closing them
#> now.
#> [1] "<?xml version='1.0' encoding='UTF-8'?><!--This is an xml comment--><person id='1'><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address><person id='1'><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address></person></person>"
```

``` r

# only contains the actual nodes
xml2::as_xml_document(b)
#> {xml_document}
#> <person id="1">
#> [1] <name>John Doe</name>
#> [2] <age>30</age>
#> [3] <address>\n  <street>123 Main St</street>\n  <city>Anytown</city>\n  <sta ...
#> [4] <person id="1">\n  <name>John Doe</name>\n  <age>30</age>\n  <address>\n  ...
```

# Performance

`xmlwriter` is optimized for generating xml documents and fragments from
R data structures.

``` r
library(microbenchmark)

library(xml2)
library(xmlwriter)

# read in a sample 600k xml file as a R list str
doc <- xml2::read_xml("./example/DataGeneric.xml")
doc_list <- xml2::as_list(doc)

# copy of the list with an extra attribute class="xml_fragment" (xmlwriter specific)
doc_list2 <- structure(doc_list, class = "xml_fragment")

# see how long it takes to create an xml document with xml2 and xmlwriter

microbenchmark(
  xml2 = xml2::as_xml_document(doc_list),
  xmlwriter = xml2::as_xml_document(doc_list2),
  times = 10
)
#> Warning in microbenchmark(xml2 = xml2::as_xml_document(doc_list), xmlwriter =
#> xml2::as_xml_document(doc_list2), : less accurate nanosecond times to avoid
#> potential integer overflows
#> Unit: milliseconds
#>       expr        min         lq      mean     median         uq        max
#>       xml2 2417.94798 2440.25551 2456.7871 2453.37936 2469.68826 2515.33959
#>  xmlwriter   35.26927   37.12788   38.6148   37.64495   40.21095   42.90047
#>  neval
#>     10
#>     10
```
