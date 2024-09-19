#include <Rcpp.h>
#ifndef XMLBUILDER_H
#define XMLBUILDER_H

using namespace Rcpp;

class Xmlbuilder {
  std::vector<std::string> out;

  std::stringstream _ss;
  std::vector<std::string> stack;
  bool tag_open = false;

  bool strict = true;

public:

  std::string prolog = "<?xml version='1.0' encoding='UTF-8'?>";
  bool use_prolog = true;

  Xmlbuilder(bool use_prolog = true, bool strict = true){
    this->use_prolog = use_prolog;
    this->strict = strict;
    if (use_prolog){
      _ss << prolog;
    }
  }

  inline void write_indent(){
    return;
    if (stack.size() == 0 && _ss.str().length() == 0){
      return;
    }

    _ss << "\n";

    for (int i = 0; i < stack.size(); i++){
      _ss << "  ";
    }
  }

  Xmlbuilder(std::string prolog){
    this->prolog = prolog;
    _ss << prolog;
  }

  void write_comment(std::string comment){
    check_finished();
    write_indent();
    _ss << "<!--" << comment << "-->";
  }

  void write_cdata(std::string cdata){
    check_finished();
    _ss << "<![CDATA[" << cdata << "]]>";
  }

  void write_doctype(std::string doctype){
    check_finished();
    _ss << "<!DOCTYPE " << doctype << ">";
  }

  void write_processing_instruction(std::string target, std::string data){
    check_finished();
    _ss << "<?" << target << " " << data << "?>";
  }

  void write_raw_xml(std::string xml){
    check_finished();
    // Rcout << "writing raw xml: '" << xml << "'\n";
    _ss << xml;
    // Rcout << "stream is '" << _ss.str() << "'\n";
  }

  void write_entity(std::string entity, std::string value){
    check_finished();
    _ss << "<!ENTITY " << entity << " '" << value << "'>";
  }

  void write_element(std::string tag, List att, std::string text = ""){
    start_element(tag);
    write_attributes(att);
    if (text.length() > 0){text_node(text);};
    end_element(tag);
  }

  void append_xmlbuilder(Xmlbuilder& other){
    check_finished();
    // Rcout << "stack 1 size: " << stack.size() << "\n";
    // Rcout << "stack 2 size: " << other.stack.size() << "\n";

    stack.insert(stack.end(), other.stack.begin(), other.stack.end());
    for (auto s : other.out){
      write_indent();
      _ss << s;
    }
    write_indent();
    _ss << other._ss.str();
    tag_open = other.tag_open;
  }

  inline void write_encoded(std::string text){
    std::string out;
    for (int i = 0; i < text.size(); i++){
      char c = text[i];
      if (c == '<'){
        _ss << "&lt;";
      } else if (c == '>'){
        _ss << "&gt;";
      } else if (c == '&'){
        _ss << "&amp;";
      } else if (c == '"'){
        _ss << "&quot;";
      } else if (c == '\''){
        _ss << "&apos;";
      } else {
        _ss << c;
      }
    }
  }


  void write_attributes(List att){
    if (!tag_open){
      Rcpp::stop("write_attributes can only be called directly after start_tag.");
    }

    if (R_NilValue == att.attr("names")){
      return;
    }

    CharacterVector nms = att.names();
    if (nms.length() == 0){
      return;
    }

    for (int i = 0; i < att.length(); i++){
      auto name = as<std::string>(nms[i]);
      if (name == "names"){
        continue;
      }

      auto attr = as<std::string>(att[i]);
      //std::string attr = "1";
      if (name.at(0) == '.'){
        name = name.substr(1);
      }
      _ss << " " << name << "=\"";
      write_encoded(attr);
      _ss << "\"";
    }
  }

  inline void check_finished(){
    if (tag_open){
      _ss << ">";
      tag_open = false;
    }
  }

  void start_element(std::string tag){
    check_finished();

    write_indent();

    _ss << "<" << tag;
    tag_open = true;
    stack.push_back(tag);
  }

  void end_element(std::string tag = ""){
    if (stack.size() == 0){
      Rcpp::stop("There are no open tags to close.");
    }

    auto stag = stack.back();

    if (strict && tag.compare(stag) != 0){
      Rcpp::stop("Trying to close tag %s, but last opened tag was %s", tag, stag);
    }

    stack.pop_back();

    if (tag_open){
      _ss << "/>";
      tag_open = false;
    } else{
      write_indent();
      _ss << "</" << stag << ">";
    }


    if (stack.size() == 0){
      out.push_back(_ss.str());
      _ss.str("");
      _ss.clear();
    }
  }

  void text_node(std::string text){
    check_finished();
    write_indent();
    write_encoded(text);
  }

  std::string get_partial_xml(){
    auto s = _ss.str();
    if (tag_open){
      s += "/>";
    }
    return s;
  }

  std::vector<std::string> get_xml_string(){
    if (stack.size() > 0){
      if (strict){
        std::string missing_tags;
        int i = 0;
        for (auto tag : stack){
          missing_tags += "\n";
          for (int j = 0; j < i; j++){
            missing_tags += " ";
          }
          missing_tags += "<" + tag + ">...";
          i++;
        }
        Rcpp::warning("There are still tags to be closed: %s", missing_tags);
      } else {
        // dirty should improve...
          while (stack.size() > 0){
            end_element();
          }
        }
    }
    return out;
  }

  void reset(){
    _ss.str("");
    _ss.clear();
    stack.clear();
  }
};


#endif
