library(xmlwriter)

fragment <- xml_fragment(
  person = .tags(
    name = "John Doe",
    age = 30
  )
)

expect_equal(
  as.character(fragment),
  "<person><name>John Doe</name><age>30</age></person>"
)

fragment <- xml_fragment(
  person = .tags(
    .attr = c(id = "id", test = "test"),
    name = "John Doe",
    age = 30
  )
)

expect_equal(
  as.character(fragment),
  "<person id=\"id\" test=\"test\"><name>John Doe</name><age>30</age></person>"
)

fragment <- xml_fragment(
  person = .tags(
    name = "John Doe",
    age = 30,
    address = .tags(street = "123 Main St", city = "Springfield"),
    "This is a text node"
  )
)

expect_equal(
  as.character(fragment),
  "<person><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Springfield</city></address>This is a text node</person>"
)

fragment <- xml_fragment(
  person = .tags(
    name = "John Doe",
    age = 30,
    address = .tags(street = "123 Main St", city = "Springfield"),
    "This is a text node"
  ),
  person = .tags(
    name = "Jane Doe",
    age = 25,
    address = .tags(street = "123 Main St", city = "Springfield"),
    "This is a text node"
  )
)

expect_equal(
  as.character(fragment),
  c("<person><name>John Doe</name><age>30</age><address><street>123 Main St</street><city>Springfield</city></address>This is a text node</person>","<person><name>Jane Doe</name><age>25</age><address><street>123 Main St</street><city>Springfield</city></address>This is a text node</person>")
)

expect_error(
  doc <- xml_doc(
    person = .tags(
      name = "John Doe",
      age = 30,
      address = .tags(street = "123 Main St", city = "Springfield"),
      "This is a text node"
    ),
    person = .tags(
      name = "Jane Doe",
      age = 25,
      address = .tags(street = "123 Main St", city = "Springfield"),
      "This is a text node"
    )
  ),

)
