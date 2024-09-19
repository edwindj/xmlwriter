#include "Xmlbuilder.h"
#include <Rcpp.h>

using namespace Rcpp;

//[[Rcpp::export]]
List xmlbuilder_create(bool use_prolog = true, bool strict = true){
  auto ptr = XPtr<Xmlbuilder>(new Xmlbuilder(use_prolog, strict), true);
  auto x = List::create(_["ptr"] = ptr);
  return x;
}

//[[Rcpp::export]]
std::string xmlbuilder_get_partial_xml(List& xb){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);

  // Rcout << "get_partial_xml: '";
  auto s = ptr->get_partial_xml();
  // Rcout << s << "'\n";
  return s;
}

//[[Rcpp::export]]
void xmlbuilder_append_xmlbuilder(List& xb, List& xb2){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  auto ptr2 = as<XPtr<Xmlbuilder>>(xb2["ptr"]);
  ptr->append_xmlbuilder(*ptr2);
}

//[[Rcpp::export]]
std::vector<std::string> xmlbuilder_to_string(List& xb){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  return ptr->get_xml_string();
}

//[[Rcpp::export]]
void xmlbuilder_start_element(List& xb, std::string tag, List att){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  ptr->start_element(tag);
  if (att.size() > 0){
    ptr->write_attributes(att);
  }
}

//[[Rcpp::export]]
void xmlbuilder_write_raw_xml(List& xb, std::string raw_xml){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  ptr->write_raw_xml(raw_xml);
}

//[[Rcpp::export]]
void xmlbuilder_write_element(List& xb, std::string tag, std::string text, List att){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  // note that att and text have different order, that is to facilitate
  // the use of the function in R
  ptr->write_element(tag, att, text);
}

//[[Rcpp::export]]
void xmlbuilder_end_element(List& xb, std::string tag = ""){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  ptr->end_element(tag);
}

//[[Rcpp::export]]
void xmlbuilder_text_node(List& xb, std::string text){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  ptr->text_node(text);
}

//[[Rcpp::export]]
void xmlbuilder_write_comment(List& xb, std::string comment){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  ptr->write_comment(comment);
}

//[[Rcpp::export]]
void xmlbuilder_write_cdata(List& xb, std::string cdata){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  ptr->write_cdata(cdata);
}

//[[Rcpp::export]]
void xmlbuilder_write_doctype(List& xb, std::string doctype){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  ptr->write_doctype(doctype);
}

//[[Rcpp::export]]
void xmlbuilder_write_processing_instruction(List& xb, std::string target, std::string pi){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);
  ptr->write_processing_instruction(target, pi);
}

//[[Rcpp::export]]
void xmlbuilder_write_dataframe( List& xb, DataFrame df
                               , std::string row_tag = "row"
                               , Nullable<CharacterVector> dataframe_tag = R_NilValue
                               ){
  auto ptr = as<XPtr<Xmlbuilder>>(xb["ptr"]);

  if (dataframe_tag.isNotNull()){
    ptr->start_element(as<std::string>(dataframe_tag));
  }

  // assume they are valid tagnames...
  auto ncol = df.cols();
  auto tags = as<std::vector<std::string>>(df.names());
  for (int i = 0; i < df.nrow(); i++){
    ptr->start_element(row_tag);
    for (int j = 0; j < ncol; j++){
      // this is inefficient, but it is a proof of concept
      CharacterVector clmn = df[j];
      List att = List::create();
      std::string text = as<std::string>(clmn[i]);
      ptr->write_element(tags[j], att, text);
    }
    ptr->end_element(row_tag);
  }

  if (dataframe_tag.isNotNull()){
    ptr->end_element(as<std::string>(dataframe_tag));
  }
}

