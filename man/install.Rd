% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/main.R
\name{install}
\alias{install}
\title{Install the Campsis suite into your R distribution.}
\usage{
install(..., cran = TRUE)
}
\arguments{
\item{...}{extra arguments passed to renv::install}

\item{cran}{install Campsis packages from CRAN when possible, default is TRUE}
}
\description{
Please note the installation will occur in 2 steps:
1. Campsis packages will be installed with their tests
2. Extra packages (mrgsolve, rxode2, etc.) will be downloaded in their binary form and installed
}
