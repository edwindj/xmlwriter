library(xmlwriter)
library(tinytest)

if (!require(xml2)){
  exit_file("xml2 is not installed")
}

a <- read_fragment("<a/>")
expect_equal(a, tag("a"))

a <- read_fragment("<a id='3'/>")
expect_equal(a, tag("a", id = 3))

# read multiple fragments
a <- read_fragment(c("<a id='3'/>", "<b/>"))
expect_equal(a, tag("a", id = 3) + tag("b"))

a <- read_fragment("<a>hi</a>")
expect_equal(a, tag("a", "hi"))

a <- read_fragment("<a b='2'>hi</a>")
expect_equal(a, tag("a", "hi", b = 2))

a <- read_fragment("<person id='1'><name>John Doe</name><age>30</age></person>")
expect_equal(
  a,
  tag("person", id = 1) / frag(
    name = "John Doe",
    age = 30
  )
)
