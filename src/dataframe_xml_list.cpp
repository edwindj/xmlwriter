#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
List dataframe_xml_list(DataFrame df, std::string row_tag) {
  List out = List::create();
  // // first convert the data.frame to a character matrix
  //DataFrame cdf = DataFrame::create();

  auto names = as<std::vector<std::string>>(df.names());
  // for (auto& name: names){
  //   cdf[name] = wrap<CharacterVector>(df[name]);
  // }

  for (int i = 0; i < df.nrow(); i++) {
    List row = List::create();
    for (int j = 0; j < df.ncol(); j++) {
      CharacterVector v = df[j];
      List value = List::create(CharacterVector::create(v[i]));
      row.push_back(value, names[j]);
    }
    out.push_back(row, row_tag);
  }
  // auto cdf = as<CharacterMatrix>(df);
  // CharacterVector names = df.names();
  //
  // // then iterate over the rows
  // for (int i = 0; i < cdf.nrow(); i++) {
  //   List row = List::create();
  //
  //   for (int j = 0; j < cdf.ncol(); j++) {
  //     List value = List::create(cdf(i,j));
  //     row.push_back(value);
  //   }
  //   row.attr("names") = names;
  //   out.push_back(row);
  // }
  // out.attr("names")  = CharacterVector::create(row_tag, df.nrow());
  return out;
}


/*** R
df <- data.frame(a = LETTERS[1:3], b = letters[1:3])

xdf <- dataframe_xml_list(df, "row2")
class(xdf) <- "xml_fragment"
xdf

*/
