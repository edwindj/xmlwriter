% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_fragment.R
\name{read_fragment}
\alias{read_fragment}
\title{Read an XML fragment from a string}
\usage{
read_fragment(x, ...)
}
\arguments{
\item{x}{A string, a connection or a raw vector}

\item{...}{passed to \code{\link[xml2:read_xml]{xml2::read_xml()}}}
}
\value{
an object of class \code{xml_fragment}
}
\description{
Reads a xml fragment from a string, a connection or a raw vector using
\code{\link[xml2:read_xml]{xml2::read_xml()}}, and turns it into a \code{\link[=xml_fragment]{xml_fragment()}}.
}
\concept{fragments}
