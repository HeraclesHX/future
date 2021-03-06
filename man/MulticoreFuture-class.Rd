% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MulticoreFuture-class.R
\name{MulticoreFuture-class}
\alias{MulticoreFuture}
\alias{MulticoreFuture-class}
\title{An multicore future is a future whose value will be resolved asynchroneously in a parallel process}
\usage{
MulticoreFuture(expr = NULL, envir = parent.frame(), substitute = FALSE,
  ...)
}
\arguments{
\item{expr}{An R \link[base]{expression}.}

\item{envir}{The \link{environment} in which the evaluation
is done (or inherits from if \code{local} is TRUE).}

\item{substitute}{If TRUE, argument \code{expr} is
\code{\link[base]{substitute}()}:ed, otherwise not.}

\item{\dots}{Additional named elements of the future.}
}
\value{
An object of class \code{MulticoreFuture}.
}
\description{
An multicore future is a future whose value will be resolved asynchroneously in a parallel process
}
\seealso{
To evaluate an expression using "multicore future", see function
\code{\link{multicore}()}.
}
\keyword{internal}

