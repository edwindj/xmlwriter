#include <Rcpp.h>
using namespace std;
using namespace Rcpp;

// returns true if the attributes contain names (means xml_childs...)
bool write_attributes(std::stringstream& xml_builder, List xml){
  //Rcout << "attributes: " << endl;
  bool has_names = false;
  for(auto& name : xml.attributeNames()){
    if (name == "names"){
      has_names = true;
      continue;
    }
    // this might give a problem with attributes of length > 1
    auto attr = as<std::string>(xml.attr(name));

    // special names in R are escaped with a dot
    if (name.at(0) == '.'){
      name = name.substr(1);
    }
    // filter out names that are not attributes
    xml_builder << " " << name << "='" << attr << "'";
  }
  return has_names;
}

void write_text_node(std::stringstream& xml_builder, List node){
  xml_builder << as<std::string>(node(0));
}

void write_childnode(std::stringstream& xml_builder, std::string tag, List xml){
  //Rcout << "tag: <" << tag << ">" << endl;

  //opening tag
  xml_builder << "<" << tag;

  bool has_names = write_attributes(xml_builder, xml);

  if (xml.size() == 0){
    xml_builder << "/>";
    return;
  }
  xml_builder << ">";
  //opening tag

  // we proceed with the childnodes

  CharacterVector tags;
  if (has_names) {
    tags = xml.attr("names");
  }

  for(int i = 0; i < xml.size(); i++){
    //Rcout << "node: " << i << endl;
    List child = xml[i];
    if (has_names && tags(i) != ""){
      write_childnode(xml_builder, as<std::string>(tags(i)), child);
    } else {
      write_text_node(xml_builder, child);
    }
  }
  xml_builder << "</" << tag << ">";
}

// [[Rcpp::export("rcpp_list_to_xml_string")]]
std::string list_to_xml_string(List xml){
  std::stringstream xml_builder;

  // expect root elements, no attributes
  CharacterVector tags;
  if (xml.attr("names") != R_NilValue){
    tags = xml.attr("names");
  }

  //iterate through the children (probably only 1 child)
  for(int i = 0; i < xml.size(); i++){
    List node = xml[i];
    if (tags.length() == 0 || tags(i) == ""){
      //text node
      auto text = as<std::string>(node(i));
      xml_builder << text;
      continue;
    }
    write_childnode(xml_builder, as<std::string>(tags(i)), node);
  }
  return std::string(xml_builder.str());
}



/*** R
library(xml2)

n <- read_xml("<root  id='root'><child>1a<sub2 id='sub2'></sub2>1b</child><child id='2'>2</child></root>")
l <- n |> as_list()
str(l)

s <- rcpp_list_to_xml_string(l)
s
read_xml(s)  |> as_list() |> str()

# more difficult
l <- read_xml("<root names='test'><child dim='2'></child></root>") |> as_list()
rcpp_list_to_xml_string(l)
*/
