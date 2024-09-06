doc <- xml_fragment(
  study = .elem(
    .attr = c(id="1"),
    person = .elem(
      .attr = c(id = "p1"),
      name = "John Doe",
      age = 30
    ),
    person = .elem(
      name = "Jane Doe",
      age = 25,
      address = .elem(street = "123 Main St", city = "Springfield"),
      "This is a text node"
    )
  )
)

print(doc)
if (require("xml2")){
  as_xml_document(doc)
}

# you can also create a function to generate xml elements,
# but remember that the enconsing element name must be used outside the
# function
person <- function(name, age, id){
  .elem(
    # xml attributes can be speficied with .attr
    .attr = c(id = id),
    name = name,
    age = age,
    address = .elem(street = "123 Main St", city = "Springfield")
  )
}

# xml_doc is a xml_fragment with the restriction of having one root element
doc2 <- xml_doc(
  study = .elem(
    # you need to specify "person" as the name for each element
    person = person("John Doe", 30, id = "p1"),
    person = person("Jane Doe", 25, id = "p2")
  )
)

print(doc2)
if (require("xml2")){
  as_xml_document(doc2)
}

# a fragment can have multiple root elements
fgmt <- xml_fragment(
  person = person("John Doe", 30, id = "p1"),
  person = person("Jane Doe", 25, id = "p2")
)

print(fgmt)

if (require("xml2")){
  # as_xml_document won't work because it expects a single root element,
  # so we retrieve a nodeset instead
  as_xml_nodeset(fgmt)
}

