data <-
  list(
    study = list(
      person = list(
        name = "John Doe",
        age = "30"
      ),
      person = list(
        name = "Jane Doe",
        age = "25"
      )
    )
  )

list_as_xml_string(data)
if (require("xml2")){
  list_as_xml_document(data)
}

#note the xml_fragment function is more powerful to create lists

data <- xml_doc(
  study = frag(
    .attr = c(id = "1"),
    person = frag(
      name = "John Doe",
      age = "30"
    ),
    person = frag(
      name = "Jane Doe",
      age = "25"
    ),
    "This is a text node"
  )
) |> unclass()

list_as_xml_string(data)
