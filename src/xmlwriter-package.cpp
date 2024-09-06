#include <Rcpp.h>
using namespace std;
using namespace Rcpp;

inline void write_encode(stringstream& ss, std::string text){
  std::string out;
  for (int i = 0; i < text.size(); i++){
    char c = text[i];
    if (c == '<'){
      ss << "&lt;";
    } else if (c == '>'){
      ss << "&gt;";
    } else if (c == '&'){
      ss << "&amp;";
    } else if (c == '"'){
      ss << "&quot;";
    } else if (c == '\''){
      ss << "&apos;";
    } else {
      ss << c;
    }
  }
}


// returns true if the attributes contain names (means xml_childs...)
bool write_attributes(std::stringstream& ss, List xml){
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
    ss << " " << name << "=\"" << attr << "\"";
  }
  return has_names;
}

// assumes that the node contains a character vector...
void write_text_node(std::stringstream& ss, List node){
  write_encode(ss, as<std::string>(node(0)));
}

void write_childnode(std::stringstream& ss, std::string tag, List xml){
  //Rcout << "tag: <" << tag << ">" << endl;

  //opening tag
  ss << "<" << tag;

  bool has_names = write_attributes(ss, xml);

  if (xml.size() == 0){
    ss << "/>";
    return;
  }
  ss << ">";
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
      write_childnode(ss, as<std::string>(tags(i)), child);
    } else {
      write_text_node(ss, child);
    }
  }
  ss << "</" << tag << ">";
}



// [[Rcpp::export("rcpp_list_to_xml_string")]]
std::string list_to_xml_string(List xml){
  std::stringstream ss;

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
      write_encode(ss, text);
      continue;
    }
    write_childnode(ss, as<std::string>(tags(i)), node);
  }
  return std::string(ss.str());
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
l <- read_xml("<root names='test'><child dim='2'></child>content</root>") |> as_list()
rcpp_list_to_xml_string(l)
*/
