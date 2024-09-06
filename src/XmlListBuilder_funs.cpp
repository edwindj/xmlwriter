#include "XmlListBuilder.h"
#include <Rcpp.h>

using namespace Rcpp;

//[[Rcpp::export]]
List xmllistbuilder_create(){
  auto ptr = XPtr<XmlListBuilder>(new XmlListBuilder());
  auto x = List::create(_["ptr"] = ptr);
  return x;
}

//[[Rcpp::export]]
List xmllistbuilder_to_list(List& xb){
  auto ptr = as<XPtr<XmlListBuilder>>(xb["ptr"]);
  return ptr->get_list();
}

//[[Rcpp::export]]
void xmllistbuilder_start_element(List& xb, std::string tag, List att){
  auto ptr = as<XPtr<XmlListBuilder>>(xb["ptr"]);
  ptr->start_element(tag, att);
}

//[[Rcpp::export]]
void xmllistbuilder_write_element(List& xb, std::string tag, std::string text, List att){
  auto ptr = as<XPtr<XmlListBuilder>>(xb["ptr"]);
  // note that att and text have different order, that is to facilitate
  // the use of the function in R
  ptr->write_element(tag, att, text);
}

//[[Rcpp::export]]
void xmllistbuilder_end_element(List& xb){
  auto ptr = as<XPtr<XmlListBuilder>>(xb["ptr"]);
  ptr->end_element();
}

//[[Rcpp::export]]
void xmllistbuilder_text_node(List& xb, std::string text){
  auto ptr = as<XPtr<XmlListBuilder>>(xb["ptr"]);
  ptr->text_node(text);
}


//[[Rcpp::export]]
void xmllistbuilder_write_dataframe( List& xb, DataFrame df
                               , std::string row_tag = "row"
                               , Nullable<CharacterVector> dataframe_tag = R_NilValue
                               ){
  auto ptr = as<XPtr<XmlListBuilder>>(xb["ptr"]);

  if (dataframe_tag.isNotNull()){
    ptr->start_element(as<std::string>(dataframe_tag), List::create());
  }

  // assume they are valid tagnames...
  auto ncol = df.cols();
  auto tags = as<std::vector<std::string>>(df.names());
  for (int i = 0; i < df.nrow(); i++){
    ptr->start_element(row_tag, List::create());
    for (int j = 0; j < ncol; j++){
      // this is inefficient, but it is a proof of concept
      CharacterVector clmn = df[j];
      List att = List::create();
      std::string text = as<std::string>(clmn[i]);
      ptr->write_element(tags[j], att, text);
    }
    ptr->end_element();
  }

  if (dataframe_tag.isNotNull()){
    ptr->end_element();
  }
}

