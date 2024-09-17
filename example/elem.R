xb <- elem("homeless") /
  elem("person") / (
     elem("name","John Doe") +
     elem("age",35)
  ) +
  elem("person") /(
    elem("name","Jane Doe") +
    elem("age", 30)
  ) +
  elem("person") / (
    elem("name","Jim Doe") +
    elem("age", 25) +
    elem("address") / (
      elem("street", "123 Main St") +
      elem("city", "Anytown") +
      elem("state", "CA") +
      elem("zip", 12345)
    )
  )

print(xb)
xb$end()
xb$end()


doc <- xb |> xml2::as_xml_document()
doc |> as.character() |> cat()
