b <-xmlbuilder()

b$start("root")
  b$element("child1", "text1", attr1 = "value1")
  b$element("child2", "text2", attr2 = "value2")
  b$start("child3", attr3 = "value3")
    b$text("text3")
    b$element("child4", "text3", attr4 = "value4")
  b$end()
b$end()

s <- b$xml_string()
print(s)

if (requireNamespace("xml2", quietly = TRUE)) {
  xml2::read_xml(s)
}
