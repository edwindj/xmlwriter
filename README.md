
<!-- README.md is generated from README.Rmd. Please edit that file -->

# xmlwriter

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/xmlwriter)](https://CRAN.R-project.org/package=xmlwriter)
[![R-CMD-check](https://github.com/edwindj/xmlwriter/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edwindj/xmlwriter/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

`xmlwriter` is an R package that provides a simple interface for
creating XML documents and fragments from R. It provides a simple
elegant syntax for creating `xml_fragment`s. Furthermore it contains a
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
mostly because it  
forces the author to manipulate the xml document tree, obscuring the xml
structure of the document, and making it hard to read the code. `xml2`
*does* provide a way to create xml documents from R data structures
using nested lists which is a powerful feature, but it is not optimized
for speed or readability.

`xmlwriter` provides an intuitive interface for creating xml documents,
that mimicks how xml is written in a text editor.

It has two different ways to create xml documents:

**NOTE the api is still in flux, and might change before `xmlwriter` is
put on CRAN**

- a light weight R syntax using `xml_fragment`, `tag`, `frag` and
  `data_frag`, creating an `xml_fragment`, that can be easily translated
  into a `character` or `xml2::xml_document` object, or be used as a
  flexible building block for generating a larger xml document.
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

### Using `xml_fragment`, `tag`, `frag` and `.attr`:

`xml_fragment`s allow to write XML using readable R syntax.

They can be used to create an `character` with valid xml, a
`xml2::xml_document` or as a building block for more complex XML
documents. An `xml_fragment` is a list object that is identical to the
output of `xml2::as_list`, and can be converted to a `character` or an
`xml2::xml_document` object but is much faster (see performance).

`tag` is a function that creates a simple `xml_fragment` element with a
given tag name, text, and attributes.

``` r
library(xmlwriter)

# a tag is a simple xml_fragment
tag("person", "John Doe", id = 1)
#> {xml_fragment}
#> <person id="1">John Doe</person>
```

`frag` allows for specifying nested tags, and attributes, creating more
complex xml fragments.

Each argument to `frag` is either:

- a named `frag` element in which case the name is used as the tag name.
- an unnamed element in which case the element is added as a text node.
- a `.attr` argument that is used to add attributes to the parent
  element.

``` r
# a frag can contain multiple tags
frag(
  name = "John Doe",
  age = 30
)
#> {xml_fragment (2)}
#> [1]<name>John Doe</name>
#> [2]<age>30</age>
#> ...

# or can nest tags
frag(
  person = frag(
    # attributes are specified using .attr
    .attr = c(id = 1),
    name = "John Doe",
    age = 30
  )
)
#> {xml_fragment}
#> <person id="1">
#>   <name>John Doe</name>
#>   <age>30</age>
#> </person>
```

The `xml_fragment` function is a restricted version of `frag` that only
allows named elements.

The output of `xml_fragment` is a

``` r
# xml_fragment is more strict version of a frag
fragment <- xml_fragment(
  person = frag(
    .attr = c(id = 1),
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

`data_frag` is function that can be used to convert a data.frame to an
`xml_fragment`:

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

# but you can also use it within an xml_fragment

# xml_doc is a xml_fragment that contains a single root element
doc <- xml_doc(
  homeless = frag(
    .attr = c(year = "1900"),
    data = data_frag(data, row_tag = "person")
  )
)

doc
#> {xml_doc,xml_fragment}
#> <?xml version='1.0' encoding='UTF-8'?>
#>  <homeless year="1900">
#>   <data>
#>     <per...
```

#### Combine fragments with `+`, `append` or `c()`)

`xml_fragment`s such as `tag`, `frag` and `data_frag` can be combined
with the `+` operator, which is equivalent to the `append()` and `c()`
function: it creates sibling xmlnodes.

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
  function which creates a child xmlnodes of the last xmlnode in an
  `xml_fragment`.

``` r
tag("person", id = 1) / (
  tag("name", "John Doe") +
  tag("age", 30)
)
#> {xml_fragment}
#> <person id="1">
#>   <name>John Doe</name>
#>   <age>30</age>
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

#### flexible xml creation…

Using the `+` and `/` operators, one can create complex xml documents in
a very flexible manner.

``` r
fragment <- 
  tag("person", id = "1") /
    ( tag("name", "John Doe") +
      tag("age", 30) +
      tag("address") /
        frag(
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
#> writing raw xml: '<person id="3">
#>   <name>Jim Doe</name>
#>   <age>35</age>
#> </person>'
#> stream is '<?xml version='1.0' encoding='UTF-8'?><!--This is an xml comment--><homeless><person id="1"><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Anytown</city><state>CA</state><zip>12345</zip></address></person><person id="2"><name>Jane Doe</name><age>25</age><address><street>321 Main St</street><city>Anytown</city><state>CA</state><zip>54321</zip></address></person><person id="3">
#>   <name>Jim Doe</name>
#>   <age>35</age>
#> </person>'
b$end("homeless")

# includes a xml prolog and comment
b
#> {xmlbuilder}
#> get_partial_xml: ''

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

# just copy the list and set an extra attribute class="xml_fragment"
# making it a xml_fragment object
doc_fragment <- structure(doc_list, class = "xml_fragment")

# see how long it takes to create an xml document with xml2 and xmlwriter

microbenchmark(
  xml2      = xml2::as_xml_document(doc_list),
  xmlwriter = xml2::as_xml_document(doc_fragment),
  times     = 10
)
#> Warning in microbenchmark(xml2 = xml2::as_xml_document(doc_list), xmlwriter =
#> xml2::as_xml_document(doc_fragment), : less accurate nanosecond times to avoid
#> potential integer overflows
#> Unit: milliseconds
#>       expr        min         lq       mean     median         uq        max
#>       xml2 2437.38452 2469.03365 2485.57684 2489.30971 2499.51900 2531.43045
#>  xmlwriter   42.12377   42.19265   44.21955   42.92977   45.80282   50.22676
#>  neval
#>     10
#>     10
```
