library(xmlwriter)
library(tinytest)

l <- list(a = 1, b = 2)
expect_equal(as_frag(l), xml_fragment(a = 1, b = 2))

l <- list(a = 1, b = "2", c = list(a =1))
expect_equal(
  as_frag(l),
  xml_fragment(a = 1, b = "2", c = frag(a = 1)))

