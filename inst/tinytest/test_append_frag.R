library(xmlwriter)
library(tinytest)

x <- xml_fragment(a = 1)
s <- x |> append(tag("a", 2))
expect_equal(as.character(s), c("<a>1</a>","<a>2</a>"))

s <- x |> add_child_fragment(.frag=tag("c", 2))
expect_equal(as.character(s),
"<a>1
  <c>2</c>
</a>"
)

s <- x |> add_child_fragment(c = 2)
expect_equal(as.character(s),
"<a>1
  <c>2</c>
</a>"
)


s <- x + x
expect_equal(as.character(s), c("<a>1</a>","<a>1</a>"))

s <- (x + x) |> add_child_fragment(c = "child")

expect_equal(as.character(s),c(
"<a>1</a>",
"<a>1
  <c>child</c>
</a>"
))

s <- (x + x) |>  add_child_fragment( c=  "child")
s

expect_equal(as.character(s),c(
  "<a>1</a>",
  "<a>1
  <c>child</c>
</a>"
))

child <- xml_fragment(c = "child")
s <- (x + x) /  child

expect_equal(as.character(s),c(
  "<a>1</a>",
  "<a>1
  <c>child</c>
</a>"
))


x <- xml_fragment(a = 1)
x |> add_child_fragment(b = 2, c=3)
x |> add_child_fragment(" test")
