library(xmlwriter)

fragment <- xml_fragment(
  person = frag(
    name = "John Doe",
    age = 30
  )
)

expect_equal(
  as.character(fragment),
  "<person>\n  <name>John Doe</name>\n  <age>30</age>\n</person>"
)

fragment <- xml_fragment(
  person = frag(
    .attr = c(id = "id", test = "test"),
    name = "John Doe",
    age = 30
  )
)

expect_equal(
  as.character(fragment),
  "<person id=\"id\" test=\"test\">\n  <name>John Doe</name>\n  <age>30</age>\n</person>"
)

fragment <- xml_fragment(
  person = frag(
    name = "John Doe",
    age = 30,
    address = frag(street = "123 Main St", city = "Springfield"),
    "This is a text node"
  )
)

expect_equal(
  as.character(fragment),
  "<person>\n  <name>John Doe</name>\n  <age>30</age>\n  <address>\n    <street>123 Main St</street>\n    <city>Springfield</city>\n  </address>This is a text node\n</person>"
)

fragment <- xml_fragment(
  person = frag(
    name = "John Doe",
    age = 30,
    address = frag(street = "123 Main St", city = "Springfield"),
    "This is a text node"
  ),
  person = frag(
    name = "Jane Doe",
    age = 25,
    address = frag(street = "123 Main St", city = "Springfield"),
    "This is a text node"
  )
)

expect_equal(
  as.character(fragment),
  c("<person>\n  <name>John Doe</name>\n  <age>30</age>\n  <address>\n    <street>123 Main St</street>\n    <city>Springfield</city>\n  </address>This is a text node\n</person>","<person>\n  <name>Jane Doe</name>\n  <age>25</age>\n  <address>\n    <street>123 Main St</street>\n    <city>Springfield</city>\n  </address>This is a text node\n</person>")
)

expect_error(
  doc <- xml_doc(
    person = frag(
      name = "John Doe",
      age = 30,
      address = frag(street = "123 Main St", city = "Springfield"),
      "This is a text node"
    ),
    person = frag(
      name = "Jane Doe",
      age = 25,
      address = frag(street = "123 Main St", city = "Springfield"),
      "This is a text node"
    )
  ),

)
