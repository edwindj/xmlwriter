#' Create an xml_fragment from a data.frame
#'
#' Create a [xml_fragment()] from a data.frame, in which each row is a set of xml elements (columns).
#' @export
#' @param row_tags `character` the tag name that is used for each row. Note that
#' this can be a single value or a vector of length equal to the number of rows in the data.frame.
#' @param df data frame that will be stored as set of xml elements
#' @param .attr optional `data.frame` with xml row attributes
#' @return [xml_fragment()] object
#' @example example/data_frag.R
#' @family xml_fragment
data_frag <- function(df, row_tags = "row", .attr = NULL){
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

  if (!is.null(.attr)){
    .attr <- as.data.frame(.attr)

    stopifnot(nrow(.attr) == nrow(df))
    a <- as.matrix(.attr)
    storage.mode(a) <- "character"
    att <- a |>
      apply(1, lapply, as.character, simplify = FALSE)

    for (i in seq_along(l)){
      attributes(l[[i]]) <- c(attributes(l[[i]]),att[[i]])
    }
  }

  l
}
