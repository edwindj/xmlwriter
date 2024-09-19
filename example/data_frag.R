persons <- data.frame(
  name = c("John Doe", "Jane Doe"),
  age = c(30, 25),
  stringsAsFactors = FALSE
)

df <- data_frag(persons, row_tag = "person")
print(df)

tag("study", date = "today") / df
