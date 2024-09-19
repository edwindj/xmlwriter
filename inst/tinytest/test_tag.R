library(xmlwriter)
library(tinytest)

tg <- tag("a")
expect_equal(as.character(tg), "<a/>")

tg <- tag("a", "text")
expect_equal(as.character(tg), "<a>text</a>")

tg <- tag("a", id = "a1")
expect_equal(as.character(tg), "<a id=\"a1\"/>")

tg <- tag("a", "text", id = "a1")
expect_equal(as.character(tg), "<a id=\"a1\">text</a>")

# tg <- tag("a", "text", id = "a1", class = "class1")
# expect_equal(as.character(tg), "<a id=\"a1\" class=\"class1\">text</a>")

frgmt <- tag("a") + tag("b")
expect_equal(as.character(frgmt), c("<a/>", "<b/>"))

frgmt <- tag("a") + tag("b", "text")
expect_equal(as.character(frgmt), c("<a/>", "<b>text</b>"))

frgmt <- tag("a","texta") + tag("b", "textb") + tag("c", "textc")
expect_equal(as.character(frgmt), c("<a>texta</a>", "<b>textb</b>", "<c>textc</c>"))

frgmt <- tag("a","texta", id = "a1") + tag("b", "textb", id = "b1")
expect_equal(as.character(frgmt), c("<a id=\"a1\">texta</a>", "<b id=\"b1\">textb</b>"))

frgmt <- tag("a", id = "a1") + tag("b", id = "b1")
expect_equal(as.character(frgmt), c("<a id=\"a1\"/>", "<b id=\"b1\"/>"))


tg <- tag("a") > tag("b")
expect_equal(as.character(tg), "<a>\n  <b/>\n</a>")

tg <- tag("a", id = "a1") > tag("b", id = "b1")
expect_equal(as.character(tg), "<a id=\"a1\">\n  <b id=\"b1\"/>\n</a>")

tg <- tag("a", "texta", id = "a1") > tag("b", "textb", id = "b1")
expect_equal(as.character(tg), "<a id=\"a1\">texta\n  <b id=\"b1\">textb</b>\n</a>")

tg <- tag("a") / (tag("b") + tag("c"))
expect_equal(as.character(tg), "<a>\n  <b/>\n  <c/>\n</a>")

