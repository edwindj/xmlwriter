doc <- xml_fragment(
  study = frag(
    .attr = c(id="1"),
    person = frag(
      .attr = c(id = "p1"),
      name = "John Doe",
      age = 30
    ),
    person = frag(
      name = "Jane Doe",
      age = 25,
      address = frag(street = "123 Main St", city = "Springfield"),
      "This is a text node"
    )
  )
)

print(doc)
if (require("xml2")){
  as_xml_document(doc)
}

# you can create a function to generate an xml fragment:
person_frag <- function(name, age, id){
  tag("person", id = id) / frag(
    name = name,
    age  = age,
    address = frag(
      street = "123 Main St",
      city = "Springfield"
    )
  )
}

# xml_doc is a xml_fragment with the restriction of having one root element
doc2 <- xml_doc("study") / (
  person_frag("John Doe", 30, "p1") +
  person_frag("Jane Doe", 25, "p2")
)

print(doc2)

if (require("xml2")){
  as_xml_document(doc2)
}

# a fragment can have multiple root elements
fgmt <- person_frag("John Doe", 30, id = "p1") +
  person_frag("Jane Doe", 25, id = "p2")


print(fgmt)

if (require("xml2")){
  # as_xml_document won't work because it expects a single root element,
  # so we retrieve a nodeset instead
  as_xml_nodeset(fgmt)
}

iris_xml <- xml_doc("fieldstudy", id = "iris", doi ="10.1111/j.1469-1809.1936.tb02137.x") /
  frag(
    source = "Fisher, R. A. (1936) The use of multiple measurements in
taxonomic problems. Annals of Eugenics, 7, Part II, 179–188.",
    data = data_frag(iris, row_tag = "obs")
  )

print(iris_xml, max_characters = 300)

if (require("xml2")){
  as_xml_document(iris_xml)
}
