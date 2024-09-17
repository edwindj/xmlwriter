library(xmlwriter)
library(tinytest)

x <- xml_fragment(a = 1)

s <- x |> append_frag("a", 2)
expect_equal(as.character(s), c("<a>1</a>","<a>2</a>"))

s <- x |> add_child("c", 2)
expect_equal(as.character(s),
"<a>1
  <c>2</c>
</a>"
)

s <- x + x
s
expect_equal(as.character(s), c("<a>1</a>","<a>1</a>"))

s<- (x + x) |> add_child("c", "child")
s
expect_equal(as.character(s),c(
"<a>1</a>",
"<a>1
  <c>child</c>
</a>"
))
