#' Create an xml_fragment from a data.frame
#'
#' Create a [xml_fragment()] from a data.frame, in which each row is a set of xml elements (columns).
#' @export
#' @param row_tags `character` the tag name that is used for each row. Note that
#' this can be a single value or a vector of length equal to the number of rows in the data.frame.
#' @param df data frame that will be stored as set of xml elements
#' @return [xml_fragment()] object
#' @example example/data_frag.R
#' @family xml_fragment
data_frag <- function(df, row_tags = "row"){
  m <- as.matrix(df)
  storage.mode(m) <- "character"

  if (length(row_tags) == 1){
    row_tags <- rep(row_tags, nrow(df))
  }

  if (length(row_tags) != nrow(df)){
    stop("row_tags must be a single value or a vector of length equal to the number of rows in the data.frame")
  }

  l <- m |>
    apply(1, lapply, as.list) |>
    stats::setNames(row_tags)

  class(l) <- "xml_fragment"
  l
}
