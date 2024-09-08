
if ( requireNamespace("tinytest", quietly=TRUE) ){
  tinytest::test_package("xmlwriter")
}

a <- list(a=5)
b <- c(a, list(w = 1))

study_xml <- xml_fragment(
  study = ""
)

print(study)
