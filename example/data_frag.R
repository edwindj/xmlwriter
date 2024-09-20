persons <- data.frame(
  name = c("John Doe", "Jane Doe"),
  age = c(30, 25),
  stringsAsFactors = FALSE
)

df <- data_frag(persons, row_tag = "person")
print(df)

# setting ids on rows
persons <- data.frame(
  name = c("John Doe", "Jane Doe"),
  age = c(30, 25),
  id = c("p1", "p2"),
  stringsAsFactors = FALSE
)

df <- data_frag(
  persons[1:2],
  row_tag = "person",
  .attr = persons[3]
)

print(df)

# turning it into a document
doc <- xml_doc("study", id = "1") / frag(
  source = "homeless db",
  data = df
)

cat(as.character(doc))
