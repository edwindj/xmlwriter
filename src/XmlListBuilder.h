#include <Rcpp.h>
#ifndef XMLLISTBUILDER_H
#define XMLLISTBUILDER_H

using namespace Rcpp;

class XmlListBuilder {
  List out;
  List parent;
  std::vector<List> node_stack;
  std::vector<std::string> tag_stack;

public:

  XmlListBuilder(){
    out = List::create();
    parent = out;
  }

  void write_element(std::string tag, List att, std::string text = ""){
    start_element(tag, att);
    if (text.length() > 0) {text_node(text);};
    end_element();
  }

  void start_element(std::string tag, List att){
    List node = List::create();

    CharacterVector nms = att.names();
    for (int i = 0; i < att.size(); i++){
      std::string name = as<std::string>(nms(i));

      if (name == ""){
        Rcpp::stop("Attribute names must be non-empty strings.");
      }

      //TODO expand special attributes
      if (name.compare("names") || name.compare("dim") || name.compare("class") ){
        //prefix
        name = "." + name;
      }

      // implicit conversion to string
      CharacterVector value = att[i];
      node.attr(name) = value;
    }

    if (R_NilValue == parent.attr("names")){
      parent.attr("names") = CharacterVector::create(tag);
    } else {
      CharacterVector tags = parent.names();
      tags[tags.size() - 1] = tag;
    }

    parent.push_back(node);
    node_stack.push_back(parent);

    parent = node;
  }

  void end_element(){
    if (node_stack.size() == 0){
      Rcpp::stop("There are no open tags to close.");
    }
    List parent = node_stack.back();
    node_stack.pop_back();
  }

  void text_node(std::string text){
    List node = List::create(text);
    parent.push_back(node);
  }

  List get_list(){
    if (node_stack.size() > 0){
      Rcpp::warning("There are still open tags. Closing them now.");
    }
    while(node_stack.size() > 0){
      end_element();
    }
    return out;
  }

  void reset(){
    out = List::create();
    node_stack.clear();
  }
};


#endif
