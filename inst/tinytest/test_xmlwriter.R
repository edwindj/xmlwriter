library(xmlwriter)
library(tinytest)

x <- xmlbuilder()
x$start("person", id = "1")
  x$element("name", "John Doe")
x$end("person")

s <- x$to_xml_string()

expect_equal(s, "<person id=\"1\"><name>John Doe</name></person>")
expect_equal(as.character(x), "<person id=\"1\"><name>John Doe</name></person>")


