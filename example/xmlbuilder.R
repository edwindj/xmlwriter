b <-xmlbuilder()

b$start("root")
  b$element("child1", "text1", attr1 = "value1")
  b$element("child2", "text2", attr2 = "value2")
  b$start("child3", attr3 = "value3")
    b$text("text3")
    b$element("child4", "text3", attr4 = "value4")
  b$end()
b$end()

print(b)

if (require("xml2")) {
  # a builder can be converted to an xml_document using
  doc <- as_xml_document(b)

  # or equivalentlty
  doc <-
    b$to_xml_string() |>
    read_xml()
}

# build some xml fragments
fms <- xmlbuilder(allow_fragments = TRUE)

fms$start("person", id = "1")
  fms$element("name", "John Doe")
  fms$element("age", 30)
fms$end()

fms$start("person", id = "2")
  fms$element("name", "Jane Doe")
  fms$element("age", 25)
fms$end()

fms$start("person", id = "3")
  fms$element("name", "Jim Doe")
  fms$element("age", 35)
fms$end()

s <- fms$to_xml_string()
as.character(fms)
length(s) # three fragments

# print xml string of the second fragment
print(s[2])

if (require("xml2")){
  # convert to xml_nodes
  nodes <- fms$to_xml_node_list()
  length(nodes) # three nodes
  # show the second xml_node
  print(nodes[[2]])
}
