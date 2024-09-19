#include <Rcpp.h>
#include <string>
using namespace Rcpp;

// [[Rcpp::export]]
List rcpp_frag(List elements, List attr){
  List out = List::create();

  if (elements.size() > 0){
    if (!elements.hasAttribute("names")){
      for (int i = 0; i < elements.size(); i++){
        if (elements[i] != R_NilValue){
          out.push_back(as<CharacterVector>(elements[i]));
        }
      }
    } else {
      auto nms = as<std::vector<std::string>>(elements.names());
      for (int i = 0; i < elements.size(); i++){
        if (is<List>(elements[i])){
          List l = elements[i];
          // remove class attribute (since it is not necessary for xml_fragment)
          l.attr("class") = R_NilValue;
          out.push_back(l, nms[i]);
        } else if (elements[i] == R_NilValue){
          out.push_back(R_NilValue, nms[i]);
        } else {
          CharacterVector v = elements[i];
          if (nms[i] == ""){
            out.push_back(v);
          } else {
            out.push_back(List::create(v), nms[i]);
          }
        }
      }
    }
  }



  // assume all attr have names
  if (attr.size() > 0){

    if (!attr.hasAttribute("names")){
      stop("All attributes must have names");
    }

    std::vector<std::string> nms = attr.names();

    if (nms.size() == 0){
      stop("All attributes must have names");
    }

    for(auto n: nms){
      if (n == ""){
        stop("All attributes must have names");
      }

      auto n2 = n;
      if (n2 == "names"){
        n2 = ".names";
      } else if (n2 == "class"){
        n2 = ".class";
      }
      out.attr(n2) = as<CharacterVector>(attr[n]);
    }
  }
  out.attr("class") = "xml_fragment";
  return out;
}


/*** R
.frag <- function(..., .attr = NULL){
  rcpp_frag(list(...), as.list(.attr))
}

.frag(a =1, b = .frag("test", .attr=list(id=2), b = "3", c = 4))

library(microbenchmark)
microbenchmark(
  rcpp = .frag(a =1, b = .frag("test", .attr=list(id=2), b = "3", c = 4)),
  R    = frag(a =1, b = frag("test", .attr=list(id=2), b = "3", c = 4))
)

*/

