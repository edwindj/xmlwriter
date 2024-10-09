
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xmlwriter

> Fast and elegant XML generation for R

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/xmlwriter)](https://CRAN.R-project.org/package=xmlwriter)
[![R-CMD-check](https://github.com/edwindj/xmlwriter/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edwindj/xmlwriter/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

`xmlwriter` is an R package that provides a fast and simple interface
for creating XML documents and fragments from R. It has a simple elegant
syntax for creating `xml_fragment`s.

`xmlwriter`’s XML generation from R lists is fast, implemented in C++
using [`Rcpp`](https://cran.r-project.org/package=Rcpp). Curious for the
benchmarks? Check the [performance section](#performance).

`xmlwriter` can be used as a companion to R packages
[`XML`](https://cran.r-project.org/package=XML) or
[`xml2`](https://cran.r-project.org/package=xml2) which are both
wonderful packages optimized for parsing, querying and manipulating XML
documents. Both `XML` and `xml2` provide several ways for creating XML
documents, but they are not optimized for generating and writing XML.

Creating XML documents with `XML` and `xml2` can be a bit cumbersome,
mostly because it  
forces the author to manipulate the XML document tree, obscuring the XML
structure of the document, and making it hard to read the XML that is
being generated. `xml2` does provide a way to create XML documents from
R data structures using nested lists which is a powerful feature, but it
is not optimized for speed or readability.

`xmlwriter` provides an intuitive interface for creating XML documents,
that mimics how XML is written in a text editor.

It has two different ways to create XML documents:

- a light weight R syntax using `tag`, `frag`, `+`, `/` and `data_frag`,
  creating an `xml_fragment`, that can be easily translated into a
  `character` or `xml2::xml_document` object, or be used as a flexible
  building block for generating a larger XML document.
- an `xmlbuilder` object that allows you to create XML documents in a
  feed-forward manner, with `start` and `end` methods, giving you more
  control on the XML document structure, including XML comment, prolog
  etc.

## Installation

You can install the development version of `xmlwriter` from:w

[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("edwindj/xmlwriter")
```

## Example

### Using `tag`, `frag`, `+`, `/` and `data_frag`:

`xml_fragment`s allow to write XML using readable R syntax. `tag` and
`frag` are function that create XML elements that can be combined using
`+` and `/` operators resulting in an `xml_fragment`.

`xml_fragment`s can be used to create an `character` with valid XML, a
`xml2::xml_document` or as a building block for more complex XML
documents. An `xml_fragment` is a list object that is identical to the
output of `xml2::as_list`, and can be converted to a `character` or an
`xml2::xml_document` object but `xmlwriter` provides a much faster
implementation (see performance).

`tag` is a function that creates a simple `xml_fragment` element with a
given tag name, text, and attributes. It allows for creating elements
with a tag name using a character, which gives flexibility.

``` r
library(xmlwriter)

# tag creates a simple xml_fragment, with text and named attributes
tag("person", "John Doe", id = 1, state="CA")
#> {xml_fragment}
#> <person id="1" state="CA">John Doe</person>
```

`frag` is a function that allows for specifying nested elements and
attributes, thus creating a more complex `xml_fragment`.

An argument to `frag` is either:

- a named element in which case the name is used as the tag name for
  that element. The element can be a value or a nested `frag`.
- an unnamed element in which case the element is added as a text node.
- a `.attr` argument that is used to add attributes to the parent
  element.

``` r
# a frag can contain multiple elements
frag(
  name = "John Doe",
  age = 30
)
#> {xml_fragment (2)}
#> [1]<name>John Doe</name>
#> [2]<age>30</age>
#> ...

# and can nest frags
frag(
  person = frag(
    # attributes on person are specified using .attr
    .attr = c(id = 1, state = "CA"),
    name = "John Doe",
    age = 30
  )
)
#> {xml_fragment}
#> <person id="1" state="CA">
#>   <name>John Doe</name>
#>   <age>30</age>
#> </person>
```

The `xml_fragment` function is a restricted version of `frag` that does
not allow `.attr` on its top level.

``` r
# xml_fragment is more strict version of a frag
fragment <- xml_fragment(
  person = frag(
    .attr = c(id = 1, state="CA"),
    name = "John Doe",
    age = 30,
    address = frag(
      street = "123 Main St",
      city = "Anytown",
      state = "CA",
      zip = 12345
    )
  )
)
```

``` r
cat(as.character(fragment))
```

``` xml
<person id="1" state="CA">
  <name>John Doe</name>
  <age>30</age>
  <address>
    <street>123 Main St</street>
    <city>Anytown</city>
    <state>CA</state>
    <zip>12345</zip>
  </address>
</person>
```

`data_frag` is function that converts a data.frame to an `xml_fragment`:

``` r
data <- data.frame(
  name = c("John Doe", "Jane Doe"),
  age = c(30, 25),
  stringsAsFactors = FALSE
)

# create an xml_fragment from a data.frame
data_frag(data, row_tag = "person")
#> {xml_fragment (2)}
#> [1]<person>
#>   <name>John Doe</name>
#>   <age>30</age>
#> </person>
#> [2]<person>
#>   <name>Jane Doe</name>
#>   <age>25</age>
#> </person>
#> ...
```

Or you can use it within an `xml_fragment`:

``` r
# but you can also use it within an xml_fragment
doc <- xml_fragment(
  homeless = data_frag(data, row_tags = "person")
)

doc
```

``` xml
<homeless>
  <person>
    <name>John Doe</name>
    <age>30</age>
  </person>
  <person>
    <name>Jane Doe</name>
    <age>25</age>
  </person>
</homeless>
```

#### Combine fragments with `+`, `append` or `c()`)

`xml_fragment`s such as `tag`, `frag` and `data_frag` can be combined
with the `+` operator, which is equivalent to the `append()` and `c()`
function: it creates sibling XML nodes.

``` r
library(xmlwriter)
john <- tag("person", "John", id = 1)
jane <- tag("person", "Jane", id = 2)

john + jane
#> {xml_fragment (2)}
#> [1]<person id="1">John</person>
#> [2]<person id="2">Jane</person>
#> ...

john + tag("person", "Jane", id = 2)
#> {xml_fragment (2)}
#> [1]<person id="1">John</person>
#> [2]<person id="2">Jane</person>
#> ...

john + xml_fragment(
  person = frag(
    .attr = c(id = 2),
    "Jane"
  )
)
#> {xml_fragment (2)}
#> [1]<person id="1">John</person>
#> [2]<person id="2">Jane</person>
#> ...
```

#### Add child fragments with ‘/’ or `add_child_fragment()`

- the `/` operator, which is equivalent to the `add_child_fragment`
  function which creates a child XML node of the last XML node in an
  `xml_fragment`.

``` r
tag("person", id = 1) / (
  tag("name", "John Doe") 
)
#> {xml_fragment}
#> <person id="1">
#>   <name>John Doe</name>
#> </person>

tag("person", id = 1) / frag(
  name = "John Doe",
  age = 30
)
#> {xml_fragment}
#> <person id="1">
#>   <name>John Doe</name>
#>   <age>30</age>
#> </person>

tag("person", id = 1) |> 
  add_child_fragment(
    name = "John Doe",
    age = 30
  )
#> {xml_fragment}
#> <person id="1">
#>   <name>John Doe</name>
#>   <age>30</age>
#> </person>
```

#### Flexible XML creation…

Using the `tag`, `frag`, `+` and `/` functions, one can create complex
XML documents in a very flexible manner.

``` r
# overly complex, but shows flexible construction of XML
fragment <- 
  tag("person", id = "1") / # adds child nodes to person
    ( frag(
        name = "John Doe",
        age = 30
      ) +  # add an extra child node to person, with subnodes
      tag("address") |> add_child_fragment(
          street = "123 Main St",
          city = "Anytown",
          state = "CA",
          zip = 12345
      ) 
    )

fragment
#> {xml_fragment}
#> <person id="1">
#>   <name>John Doe</name>
#>   <age>30</age>
#>   <address>
#>     <street>...
```

A cleaner version of the above:

``` r
tag("person", id = 1) / frag(
    name = "John Doe",
    age = 30,
    address = frag(
      street = "123 Main St",
      city = "Anytown",
      state = "CA",
      zip = 12345
    )
)
#> {xml_fragment}
#> <person id="1">
#>   <name>John Doe</name>
#>   <age>30</age>
#>   <address>
#>     <street>...
```

#### `xml2` compatibility

`xml_writer` does not have a hard dependency on `xml2`, but the output
of xml_writer can be converted to a `xml2::xml_document` object. An
`xml_fragment` is identical to the output of `xml2::as_list`, so it can
be converted to a `xml2::xml_document` object.

`xml_fragment` supports the following `xml2` methods:

- `xml2::as_xml_document`, calls the `xml2::read_xml` method
- `xml2::as_list`, removes the `xml_fragment` class
- `xml2::write_xml`, writes the xml to a file or console

One can also use the `as_xml_nodeset` function to convert the
`xml_fragment` to a `xml2::xml_nodeset` object.

``` r
fragment |> xml2::as_xml_document()
#> {xml_document}
#> <person id="1">
#> [1] <name>John Doe</name>
#> [2] <age>30</age>
#> [3] <address>\n  <street>123 Main St</street>\n  <city>Anytown</city>\n  <sta ...
fragment |> as_xml_nodeset()
#> {xml_nodeset (1)}
#> [1] <person id="1">\n  <name>John Doe</name>\n  <age>30</age>\n  <address>\n  ...
```

`xml_fragment` implements the `xml2::write_xml` method

``` r
xml2::write_xml(fragment, file="") # print to the console
```

results in:

``` xml
<person id="1">
  <name>John Doe</name>
  <age>30</age>
  <address>
    <street>123 Main St</street>
    <city>Anytown</city>
    <state>CA</state>
    <zip>12345</zip>
  </address>
</person>
```

# Performance of xml generation:

`xmlwriter` is optimized for generating xml documents and fragments from
a R `list` structure that is identical to the `xml2::as_list` output.

``` r
library(microbenchmark)

library(xml2)
library(xmlwriter)

# read in a sample 600k xml file as a R list str
doc <- xml2::read_xml("./example/DataGeneric.xml")
doc_list <- xml2::as_list(doc)

# just copy the list and set an extra attribute class="xml_fragment"
# making it a xml_fragment object
doc_fragment <- structure(doc_list, class = "xml_fragment")

# see how long it takes to create an xml document with xml2 and xmlwriter

(m <- microbenchmark(
  xml2      = xml2::as_xml_document(doc_list),
  xmlwriter = xml2::as_xml_document(doc_fragment),
  times     = 10
))
#> Warning in microbenchmark(xml2 = xml2::as_xml_document(doc_list), xmlwriter =
#> xml2::as_xml_document(doc_fragment), : less accurate nanosecond times to avoid
#> potential integer overflows
#> Unit: milliseconds
#>       expr        min        lq       mean     median         uq        max
#>       xml2 2399.64796 2447.8843 2473.02250 2459.12949 2519.27686 2559.83217
#>  xmlwriter   39.46873   40.6877   42.48128   41.46744   44.61841   46.35956
#>  neval
#>     10
#>     10
```

`xmlwriter` is about 58.2 times faster than `xml2` for creating an xml
document from an R list. Note that `xmlwriter` includes a round trip,
since `xmlwriter` first generates a `character` vector which is then
read using `xml2::read_xml()`.

### Using an `xmlbuilder` object

`xmlbuilder` is an object that allows you to create xml documents in a
feed-forward manner.

With `xml_fragment` one creates the xml document structure as one
(large) R list and then converts it to a xml string or
`xml2::xml_document`, with `xmlbuilder` one incremently builds the xml
document, without having the whole list structure in memory. It also
provides more functions for the output xml document, like adding a
prolog or comment.

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
    person = frag(
      .attr = c(id = "3"),
      name = "Jim Doe",
      age = 35
    )
  )
b$end("homeless")

# includes a xml prolog and comment
b
#> {xmlbuilder}

as.character(b)
#> [1] "<?xml version='1.0' encoding='UTF-8'?><!--This is an xml comment--><homeless><person id=\"1\"><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address></person><person id=\"2\"><name>Jane Doe</name><age>25</age><address><street>321 Main St</street><city>Anytown</city><state>CA</state><zip>54321</zip></address></person><person id=\"3\">\n  <name>Jim Doe</name>\n  <age>35</age>\n</person></homeless>"

# only contains the actual nodes
xml2::as_xml_document(b)
#> {xml_document}
#> <homeless>
#> [1] <person id="1">\n  <name>John Doe</name>\n  <age>30</age>\n  <address>\n  ...
#> [2] <person id="2">\n  <name>Jane Doe</name>\n  <age>25</age>\n  <address>\n  ...
#> [3] <person id="3">\n  <name>Jim Doe</name>\n  <age>35</age>\n</person>
```
