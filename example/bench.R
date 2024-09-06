library(microbenchmark)

#doc <- xml2::read_xml("./example/estat_nama_10_gdp_filtered.xml")
doc <- xml2::read_xml("./example/DataGeneric.xml")
doc_list <- as_list(doc)

create_xml_doc1 <-function(x){
  xml2::as_xml_document(x)
}

create_xml_doc2 <- function(x){
  x |>
    rcpp_list_to_xml_string() |>
    xml2::read_xml()
}

create_xml_doc3 <- function(x){
  x |>
    list_to_xmlwriter() |>
    as.character() |>
    xml2::read_xml()
}

create_xml_doc1(doc_list)
create_xml_doc2(doc_list)
create_xml_doc3(doc_list)

microbenchmark(
  create_xml_doc1(doc_list),
  create_xml_doc2(doc_list),
  create_xml_doc3(doc_list),
  times = 1
)
