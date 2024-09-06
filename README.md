
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xmlwriter

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/xmlwriter)](https://CRAN.R-project.org/package=xmlwriter)
[![R-CMD-check](https://github.com/edwindj/xmlwriter/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edwindj/xmlwriter/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`xmlwriter` is an R package that provides a simple interface for
creating XML documents and fragments from R. It provides a simple
elegant syntax for creating `xml_fragment`s and contains a feed-forward
API that allows you to write xml in the same order as the xml elements
appear in an xml document or fragment. The main goal of `xmlwriter` is
to provide a simple and fast way to create xml documents and fragments.

`xmlwriter` can be used as a companion to R packages
[`XML`](https://cran.r-project.org/package=XML) or
[`xml2`](https://cran.r-project.org/package=xml2) which are both
wonderful packages optimized for parsing, querying and manipulating XML
documents. Both `XML` and `xml2` provide several ways for creating xml
documents, but they are not optimized for generating and writing xml.

Creating xml documents with `XML` and `xml2` can be a bit cumbersome,
because it mostly forces the author to manipulate the xml document tree
by adding nodes and attributes. `xml2` *does* provide a way to create
xml documents from R data structures using nested lists which is a
powerful feature, but currently not optimized for speed or readability.

`xmlwriter` provides an intuitive interface for creating xml documents,
that mimicks the way xml is written in a text editor. It has two
different ways to create xml documents:

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
#> {xml_fragment}
#> <persoon id="1"><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</st...
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

`xml_fragment` also provides a `.data` function that can be used to
convert a data.frame to xml:

``` r
data <- data.frame(
  name = c("John Doe", "Jane Doe"),
  age = c(30, 25),
  stringsAsFactors = FALSE
)

doc <- xml_fragment(
  homeless = .elem(
    .attr = c(year = "1900"),
    data = .data(data, row_tag = "person")
  )
)

doc
#> {xml_fragment}
#> <homeless year="1900"><data><person><name>John Doe</name><age>30</age></person><person><name>Jane Doe</name><age>25</age...
```

### Using `xmlbuilder` object

``` r
library(xmlwriter)

b <- xmlbuilder(allow_fragments = FALSE)
b$comment("This is an xml comment")
b$start("homeless")
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
b$end()

# includes a xml prolog and comment
b
#> {xmlbuilder}
#> Warning in xmlbuilder_to_string(xb$x): There are still open tags. Closing them
#> now.
#> <?xml version='1.0' encoding='UTF-8'?><!--This is an xml comment--><homeless><person id="1"><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address><person id="1"><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address></person></person></homeless>
```

``` r

as.character(b)
#> [1] "<?xml version='1.0' encoding='UTF-8'?><!--This is an xml comment--><homeless><person id=\"1\"><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address><person id=\"1\"><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address></person></person></homeless>"
```

``` r

# only contains the actual nodes
xml2::as_xml_document(b)
#> {xml_document}
#> <homeless>
#> [1] <person id="1">\n  <name>John Doe</name>\n  <age>30</age>\n  <address>\n  ...
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
#>       expr       min         lq       mean     median         uq       max
#>       xml2 2403.9226 2438.80058 2461.07102 2450.85067 2500.64465 2525.6305
#>  xmlwriter   35.4807   37.08573   38.62547   37.34393   41.08995   44.7497
#>  neval
#>     10
#>     10
```
