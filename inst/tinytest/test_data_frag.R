library(xmlwriter)
library(tinytest)

person <- data.frame(
  name = c("John Doe", "Jane Doe"),
  age = c(30, 25)
)

person_frag <- data_frag(person, row_tags = "person")
expect_equal( as.character(person_frag),
              c("<person>\n  <name>John Doe</name>\n  <age>30</age>\n</person>","<person>\n  <name>Jane Doe</name>\n  <age>25</age>\n</person>")
)

person <- data.frame(
  name = c("John Doe", "Jane Doe"),
  age = c(30, 25),
  id = c("p1", "p2")
)


person_frag <- data_frag(person[1:2], row_tags = "person", .attr = person[3])
person_frag
