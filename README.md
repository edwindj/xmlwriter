
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xmlwriter

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/xmlwriter)](https://CRAN.R-project.org/package=xmlwriter)
[![R-CMD-check](https://github.com/edwindj/xmlwriter/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edwindj/xmlwriter/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`xmlwriter` is an R package that provides a simple interface for
creating XML documents and fragments from R. It provides a simple
elegant syntax for creating `xml_fragment`s and furthermore contains a
feed-forward API that allows you to write xml in the same order as the
xml elements appear in an xml document or fragment.

`xmlwriter`’s xml generation from R lists is fast, implemented in C++
using [`Rcpp`](https://cran.r-project.org/package=Rcpp). Curious for the
benchmarks? Check the [performance section](#performance).

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
powerful feature, but it is not optimized for speed or readability.

`xmlwriter` provides an intuitive interface for creating xml documents,
that mimicks how xml is written in a text editor.

It has two different ways to create xml documents:

- a light weight R syntax using `xml_fragment` and `.tags`, creating an
  `xml_fragment`, that can be easily translated into a xml string or
  `xml2::xml_document` object, or be used as a flexible building block
  for generating a larger xml document.
- an `xmlbuilder` object that allows you to create xml documents in a
  feed-forward manner, with `start` and `end` methods, giving you more
  control on the xml document structure, including xml comment, prolog
  etc.

## Installation

`xmlwriter` is not yet available on CRAN, feedback is welcome before
submitting to CRAN.

You can install the development version of `xmlwriter` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edwindj/xmlwriter")
```

## Example

### Using `xml_fragment`, `.tags` and `.attr`:

`xml_fragment` is a function that creates an xml fragment using readable
R syntax. It can be used to create an `character` with valid xml, a
`xml2::xml_document` or as a building block for more complex XML
documents. Each argument to `xml_fragment` is either:

- a named `.tags` element in which case the name is used as the tag
  name.
- an unnamed element in which case the element is added as a text node.
- a `.attr` argument that is used to add attributes to the root element.

`.tags` have the same structure as `xml_fragment`, so you can nest them
to create a complex xml document. The output of `xml_fragment` is a list
object that is identical to the output of `xml2::as_list`, and can be
converted to an `xml2::xml_document` or `character` string, but is much
faster.

``` r
library(xmlwriter)

fragment <- xml_fragment(
  persoon = .tags(
    .attr = c(id = "1"),
    name = "John Doe",
    age = 30,
    address = .tags(
       street = "123 Main St",
       city = "Anytown",
       state = "CA",
       zip = 12345
    )
  )
)

print(fragment)
#> {xml_fragment}
#> <persoon id="1"><name>John Doe</name><age>30</age><address><street>123 Main St</...
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

# xml_doc is a xml_fragment that contains a single root element
doc <- xml_doc(
  homeless = .tags(
    .attr = c(year = "1900"),
    data = .data(data, row_tag = "person")
  )
)

doc
#> {xml_doc,xml_fragment}
#> <homeless year="1900"><data><person><name>John Doe</name><age>30</age></person><...
```

Both `xml_doc` as well as `xml_fragment` can be used to create a single
root element xml document. `xml_doc` is a `xml_fragment` that errors
when there is more than one root element.

### Using an `xmlbuilder` object

`xmlbuilder` is an object that allows you to create xml documents in a
feed-forward manner.

With `xml_fragment` one creates the xml document structure as one R list
and then converts it to a xml string or `xml2::xml_document`, with
`xmlbuilder` one incremently builds the xml document, without having the
whole list structure in memory. It also provides more functions for the
output xml document, like adding a prolog or comment.

It provides the following methods:

- `start` to start a new element
- `end` to end the current element
- `element` to add an element with a value
- `comment` to add a comment
- `prolog` to add a prolog
- `fragment` to add a fragment

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
    b$end("address")
  b$end("person")
  b$start("person", id = "2")
    b$element("name", "Jane Doe")
    b$element("age", 25)
    b$start("address")
      b$element("street", "321 Main St")
      b$element("city", "Anytown")
      b$element("state", "CA")
      b$element("zip", 54321)
    b$end("address")
  b$end("person")
  b$fragment(
    person = .tags(
      .attr = c(id = "3"),
      name = "Jim Doe",
      age = 35
    )
  )
b$end("homeless")

# includes a xml prolog and comment
b
#> {xmlbuilder}
#> <?xml version='1.0' encoding='UTF-8'?><!--This is an xml comment--><homeless><person id="1"><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address></person><person id="2"><name>Jane Doe</name><age>25</age><address><street>321 Main St</street><city>Anytown</city><state>CA</state><zip>54321</zip></address></person><person id="3"><name>Jim Doe</name><age>35</age></person></homeless>
```

``` r

as.character(b)
#> [1] "<?xml version='1.0' encoding='UTF-8'?><!--This is an xml comment--><homeless><person id=\"1\"><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address></person><person id=\"2\"><name>Jane Doe</name><age>25</age><address><street>321 Main St</street><city>Anytown</city><state>CA</state><zip>54321</zip></address></person><person id=\"3\"><name>Jim Doe</name><age>35</age></person></homeless>"
```

``` r

# only contains the actual nodes
xml2::as_xml_document(b)
#> {xml_document}
#> <homeless>
#> [1] <person id="1">\n  <name>John Doe</name>\n  <age>30</age>\n  <address>\n  ...
#> [2] <person id="2">\n  <name>Jane Doe</name>\n  <age>25</age>\n  <address>\n  ...
#> [3] <person id="3">\n  <name>Jim Doe</name>\n  <age>35</age>\n</person>
```

# Performance

`xmlwriter` is optimized for generating xml documents and fragments from
a R `list` structure that is identical to the `xml2::as_list` output.

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
#>       expr        min         lq       mean     median         uq        max
#>       xml2 2405.03089 2454.09940 2464.97629 2460.49669 2483.65971 2529.20788
#>  xmlwriter   35.60879   35.74036   38.18791   37.24766   37.67248   47.16652
#>  neval
#>     10
#>     10
```
