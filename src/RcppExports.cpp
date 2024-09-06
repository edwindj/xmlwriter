// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// xmllistbuilder_create
List xmllistbuilder_create();
RcppExport SEXP _xmlwriter_xmllistbuilder_create() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(xmllistbuilder_create());
    return rcpp_result_gen;
END_RCPP
}
// xmllistbuilder_to_list
List xmllistbuilder_to_list(List& xb);
RcppExport SEXP _xmlwriter_xmllistbuilder_to_list(SEXP xbSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    rcpp_result_gen = Rcpp::wrap(xmllistbuilder_to_list(xb));
    return rcpp_result_gen;
END_RCPP
}
// xmllistbuilder_start_element
void xmllistbuilder_start_element(List& xb, std::string tag, List att);
RcppExport SEXP _xmlwriter_xmllistbuilder_start_element(SEXP xbSEXP, SEXP tagSEXP, SEXP attSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< std::string >::type tag(tagSEXP);
    Rcpp::traits::input_parameter< List >::type att(attSEXP);
    xmllistbuilder_start_element(xb, tag, att);
    return R_NilValue;
END_RCPP
}
// xmllistbuilder_write_element
void xmllistbuilder_write_element(List& xb, std::string tag, std::string text, List att);
RcppExport SEXP _xmlwriter_xmllistbuilder_write_element(SEXP xbSEXP, SEXP tagSEXP, SEXP textSEXP, SEXP attSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< std::string >::type tag(tagSEXP);
    Rcpp::traits::input_parameter< std::string >::type text(textSEXP);
    Rcpp::traits::input_parameter< List >::type att(attSEXP);
    xmllistbuilder_write_element(xb, tag, text, att);
    return R_NilValue;
END_RCPP
}
// xmllistbuilder_end_element
void xmllistbuilder_end_element(List& xb);
RcppExport SEXP _xmlwriter_xmllistbuilder_end_element(SEXP xbSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    xmllistbuilder_end_element(xb);
    return R_NilValue;
END_RCPP
}
// xmllistbuilder_text_node
void xmllistbuilder_text_node(List& xb, std::string text);
RcppExport SEXP _xmlwriter_xmllistbuilder_text_node(SEXP xbSEXP, SEXP textSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< std::string >::type text(textSEXP);
    xmllistbuilder_text_node(xb, text);
    return R_NilValue;
END_RCPP
}
// xmllistbuilder_write_dataframe
void xmllistbuilder_write_dataframe(List& xb, DataFrame df, std::string row_tag, Nullable<CharacterVector> dataframe_tag);
RcppExport SEXP _xmlwriter_xmllistbuilder_write_dataframe(SEXP xbSEXP, SEXP dfSEXP, SEXP row_tagSEXP, SEXP dataframe_tagSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< DataFrame >::type df(dfSEXP);
    Rcpp::traits::input_parameter< std::string >::type row_tag(row_tagSEXP);
    Rcpp::traits::input_parameter< Nullable<CharacterVector> >::type dataframe_tag(dataframe_tagSEXP);
    xmllistbuilder_write_dataframe(xb, df, row_tag, dataframe_tag);
    return R_NilValue;
END_RCPP
}
// xmlbuilder_create
List xmlbuilder_create(bool use_prolog);
RcppExport SEXP _xmlwriter_xmlbuilder_create(SEXP use_prologSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< bool >::type use_prolog(use_prologSEXP);
    rcpp_result_gen = Rcpp::wrap(xmlbuilder_create(use_prolog));
    return rcpp_result_gen;
END_RCPP
}
// xmlbuilder_to_string
std::vector<std::string> xmlbuilder_to_string(List& xb);
RcppExport SEXP _xmlwriter_xmlbuilder_to_string(SEXP xbSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    rcpp_result_gen = Rcpp::wrap(xmlbuilder_to_string(xb));
    return rcpp_result_gen;
END_RCPP
}
// xmlbuilder_start_element
void xmlbuilder_start_element(List& xb, std::string tag, List att);
RcppExport SEXP _xmlwriter_xmlbuilder_start_element(SEXP xbSEXP, SEXP tagSEXP, SEXP attSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< std::string >::type tag(tagSEXP);
    Rcpp::traits::input_parameter< List >::type att(attSEXP);
    xmlbuilder_start_element(xb, tag, att);
    return R_NilValue;
END_RCPP
}
// xmlbuilder_write_element
void xmlbuilder_write_element(List& xb, std::string tag, std::string text, List att);
RcppExport SEXP _xmlwriter_xmlbuilder_write_element(SEXP xbSEXP, SEXP tagSEXP, SEXP textSEXP, SEXP attSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< std::string >::type tag(tagSEXP);
    Rcpp::traits::input_parameter< std::string >::type text(textSEXP);
    Rcpp::traits::input_parameter< List >::type att(attSEXP);
    xmlbuilder_write_element(xb, tag, text, att);
    return R_NilValue;
END_RCPP
}
// xmlbuilder_end_element
void xmlbuilder_end_element(List& xb);
RcppExport SEXP _xmlwriter_xmlbuilder_end_element(SEXP xbSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    xmlbuilder_end_element(xb);
    return R_NilValue;
END_RCPP
}
// xmlbuilder_text_node
void xmlbuilder_text_node(List& xb, std::string text);
RcppExport SEXP _xmlwriter_xmlbuilder_text_node(SEXP xbSEXP, SEXP textSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< std::string >::type text(textSEXP);
    xmlbuilder_text_node(xb, text);
    return R_NilValue;
END_RCPP
}
// xmlbuilder_write_comment
void xmlbuilder_write_comment(List& xb, std::string comment);
RcppExport SEXP _xmlwriter_xmlbuilder_write_comment(SEXP xbSEXP, SEXP commentSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< std::string >::type comment(commentSEXP);
    xmlbuilder_write_comment(xb, comment);
    return R_NilValue;
END_RCPP
}
// xmlbuilder_write_cdata
void xmlbuilder_write_cdata(List& xb, std::string cdata);
RcppExport SEXP _xmlwriter_xmlbuilder_write_cdata(SEXP xbSEXP, SEXP cdataSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< std::string >::type cdata(cdataSEXP);
    xmlbuilder_write_cdata(xb, cdata);
    return R_NilValue;
END_RCPP
}
// xmlbuilder_write_doctype
void xmlbuilder_write_doctype(List& xb, std::string doctype);
RcppExport SEXP _xmlwriter_xmlbuilder_write_doctype(SEXP xbSEXP, SEXP doctypeSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< std::string >::type doctype(doctypeSEXP);
    xmlbuilder_write_doctype(xb, doctype);
    return R_NilValue;
END_RCPP
}
// xmlbuilder_write_processing_instruction
void xmlbuilder_write_processing_instruction(List& xb, std::string target, std::string pi);
RcppExport SEXP _xmlwriter_xmlbuilder_write_processing_instruction(SEXP xbSEXP, SEXP targetSEXP, SEXP piSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< std::string >::type target(targetSEXP);
    Rcpp::traits::input_parameter< std::string >::type pi(piSEXP);
    xmlbuilder_write_processing_instruction(xb, target, pi);
    return R_NilValue;
END_RCPP
}
// xmlbuilder_write_dataframe
void xmlbuilder_write_dataframe(List& xb, DataFrame df, std::string row_tag, Nullable<CharacterVector> dataframe_tag);
RcppExport SEXP _xmlwriter_xmlbuilder_write_dataframe(SEXP xbSEXP, SEXP dfSEXP, SEXP row_tagSEXP, SEXP dataframe_tagSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List& >::type xb(xbSEXP);
    Rcpp::traits::input_parameter< DataFrame >::type df(dfSEXP);
    Rcpp::traits::input_parameter< std::string >::type row_tag(row_tagSEXP);
    Rcpp::traits::input_parameter< Nullable<CharacterVector> >::type dataframe_tag(dataframe_tagSEXP);
    xmlbuilder_write_dataframe(xb, df, row_tag, dataframe_tag);
    return R_NilValue;
END_RCPP
}
// list_to_xml_string
std::string list_to_xml_string(List xml);
RcppExport SEXP _xmlwriter_list_to_xml_string(SEXP xmlSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< List >::type xml(xmlSEXP);
    rcpp_result_gen = Rcpp::wrap(list_to_xml_string(xml));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_xmlwriter_xmllistbuilder_create", (DL_FUNC) &_xmlwriter_xmllistbuilder_create, 0},
    {"_xmlwriter_xmllistbuilder_to_list", (DL_FUNC) &_xmlwriter_xmllistbuilder_to_list, 1},
    {"_xmlwriter_xmllistbuilder_start_element", (DL_FUNC) &_xmlwriter_xmllistbuilder_start_element, 3},
    {"_xmlwriter_xmllistbuilder_write_element", (DL_FUNC) &_xmlwriter_xmllistbuilder_write_element, 4},
    {"_xmlwriter_xmllistbuilder_end_element", (DL_FUNC) &_xmlwriter_xmllistbuilder_end_element, 1},
    {"_xmlwriter_xmllistbuilder_text_node", (DL_FUNC) &_xmlwriter_xmllistbuilder_text_node, 2},
    {"_xmlwriter_xmllistbuilder_write_dataframe", (DL_FUNC) &_xmlwriter_xmllistbuilder_write_dataframe, 4},
    {"_xmlwriter_xmlbuilder_create", (DL_FUNC) &_xmlwriter_xmlbuilder_create, 1},
    {"_xmlwriter_xmlbuilder_to_string", (DL_FUNC) &_xmlwriter_xmlbuilder_to_string, 1},
    {"_xmlwriter_xmlbuilder_start_element", (DL_FUNC) &_xmlwriter_xmlbuilder_start_element, 3},
    {"_xmlwriter_xmlbuilder_write_element", (DL_FUNC) &_xmlwriter_xmlbuilder_write_element, 4},
    {"_xmlwriter_xmlbuilder_end_element", (DL_FUNC) &_xmlwriter_xmlbuilder_end_element, 1},
    {"_xmlwriter_xmlbuilder_text_node", (DL_FUNC) &_xmlwriter_xmlbuilder_text_node, 2},
    {"_xmlwriter_xmlbuilder_write_comment", (DL_FUNC) &_xmlwriter_xmlbuilder_write_comment, 2},
    {"_xmlwriter_xmlbuilder_write_cdata", (DL_FUNC) &_xmlwriter_xmlbuilder_write_cdata, 2},
    {"_xmlwriter_xmlbuilder_write_doctype", (DL_FUNC) &_xmlwriter_xmlbuilder_write_doctype, 2},
    {"_xmlwriter_xmlbuilder_write_processing_instruction", (DL_FUNC) &_xmlwriter_xmlbuilder_write_processing_instruction, 3},
    {"_xmlwriter_xmlbuilder_write_dataframe", (DL_FUNC) &_xmlwriter_xmlbuilder_write_dataframe, 4},
    {"_xmlwriter_list_to_xml_string", (DL_FUNC) &_xmlwriter_list_to_xml_string, 1},
    {NULL, NULL, 0}
};

RcppExport void R_init_xmlwriter(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
