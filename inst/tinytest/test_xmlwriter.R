library(xmlwriter)

x <- xmlbuilder()
x$start("person", id = "1")
  x$element("name", "John Doe")
x$end()

s <- x$to_xml_string()

expect_equal(s, "<person id='1'><name>John Doe</name></person>", info = "single node")

x <- xmlbuilder()
