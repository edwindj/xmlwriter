#' add an element to an xmlbuilder object
#'
#' add an element to an xmlbuilder object
#' @param tag name of element
#' @param text text contents of element
#' @param ... additional xml. attributes to be set
#' @export
#' @example example/elem.R
#' @return an xmlbuilder object
elem <- function(tag, text = NULL, ...){
  xb <- xmlbuilder(strict = FALSE)
  xb$start(tag, ...)
  if (!is.null(text)){
    xb$text(text)
  }
  xb
}

add_ <- function(e1, e2){
  switch(class(e2),
         list = {
           for (i in seq_along(e2)){
             e1  <- e1 + e2[[i]]
           }
         },
         xmlbuilder = {
           e1$append_xmlbuilder(e2)
         },
         e1$text(as.character(e2))
  )
  e1
}

#' @export
`/.xmlbuilder` <- function(e1, e2){
  add_(e1, e2)
}

#' @export
`^.xmlbuilder` <- function(e1, e2){
  # close current tag
  e1$end()
  # move up in the xml tree
  e1$end()
  add_(e1, e2)
}


#' @export
`+.xmlbuilder` <- function(e1, e2){
  e1$end()
  add_(e1, e2)
}


