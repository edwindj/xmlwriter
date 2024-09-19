
tag("greeting", "hi", id = "hi")

tag("person", id = "1") / (tag("name", "John Doe") + tag("age", 35))

xml_fragment(person = frag(
  .attr = c(id = 1),
  name = "John Doe",
  age = 30
))   / tag("address", "Unknown")


a <- tag("person", id = 1) /
  xml_fragment(
    name ="John Doe",
    age = 30,
    address = frag(
      street = "123 Main St",
      city = "Springfield"
    )
  )

cat(as.character(a))
