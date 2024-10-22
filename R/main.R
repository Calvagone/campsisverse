
#'
#' Restore environment.
#'
#' @param version campsisverse version
#' @param all all packages, included private ones, default is FALSE. Reserved for Calvagone members only.
#' @param ... extra arguments
#' @importFrom renv restore
#' @export
#'
restore <- function(version=getPackageVersion(), all=FALSE, ...) {
  configureOptions()
  renv::restore(lockfile=getLockFile(version=version, all=all), ...)
}

#'
#' Use environment.
#'
#' @param version campsisverse version
#' @param all all packages, included private ones, default is FALSE. Reserved for Calvagone members only.
#' @param ... extra arguments
#' @importFrom renv use
#' @export
#'
use <- function(version=getPackageVersion(), all=FALSE, ...) {
  configureOptions()
  renv::use(lockfile=getLockFile(version=version, all=all), ...)
}

#'
#' Qualify the Campsis environment. Note that this is just a call to the campsisqual::runQualification function.
#'
#' @param packages campsisverse version
#' @param fullname full user name (firstname lastname)
#' @param output_dir output directory of the qualification report
#' @param ... extra arguments
#' @export
#'
runQualification <- function(packages, fullname, output_dir=getwd()) {
  require("campsisqual")
  campsisqual::runQualification(packages=packages, fullname=fullname, output_dir=output_dir)
}

#'
#' Uninstall the Campsis suite.
#'
#' @export
#'
uninstall <- function() {
  packages <- c(getPublicPackages(), getPrivatePackages())
  for (package in packages) {
    if (length(find.package(package, quiet=TRUE)) > 0) {
      remove.packages(package)
    }
  }
}

#'
#' Get lock file.
#'
#' @param version campsisverse version
#' @param all all packages, included private ones (authentication key needed), default is FALSE
#' @importFrom renv load
#' @importFrom jsonlite fromJSON toJSON
#' @export
#'
getLockFile <- function(version=getPackageVersion(), all=FALSE) {
  filePath <- tempfile(fileext=".lock")
  fileConn <- file(filePath)
  dataRaw <- eval(parse(text=sprintf("campsisverse::%s", paste0("renv_lock_", version))))
  data <- jsonlite::fromJSON(txt=dataRaw)
  
  # Discard private packages if argument all is FALSE
  if (!all) {
    packageNames <- names(data$Packages)
    packageNames <- packageNames[!packageNames %in% getPrivatePackages()]
    data$Packages <- data$Packages[packageNames]
  }
  
  json <- jsonlite::toJSON(data, auto_unbox=TRUE, pretty=TRUE)
  writeLines(gsub(pattern="\r", replacement="", x=json), sep="", fileConn)
  close(fileConn)
  
  return(filePath)
}

#' Configure options.
#' 
#' @return nothing
#' @export
configureOptions <- function() {
  installTests <- "--install-tests"
  options(INSTALL_opts.campsismod = installTests)
  options(INSTALL_opts.campsis = installTests)
  options(INSTALL_opts.campsisnca = installTests)
  options(INSTALL_opts.campsismisc = installTests)
  options(INSTALL_opts.campsistrans = installTests)
  options(INSTALL_opts.campsisqual = installTests)
}

#'
#' Get the private packages from the Campsis suite.
#'
#' @return a character vector of the private packages
#'
getPrivatePackages <- function() {
  return(c("campsistrans", "calvamod", "campsisqual", "campsisverse"))
}

#'
#' Get the public packages from the Campsis suite.
#'
#' @return a character vector of the public packages
#'
getPublicPackages <- function() {
  return(c("campsismod", "campsis", "campsisnca", "campsismisc"))
}

getEnvDefaultDir <- function() {
  return(dirname(tempdir()))
}

getPackageVersion <- function() {
  return(getNamespaceVersion("campsisverse") |>
           as.character())
}

#' With directory
#' 
#' @param dir directory
#' @param expr expression
#' @export
with_dir <- function(dir, expr) {
  old_wd <- getwd()
  on.exit(setwd(old_wd))
  setwd(dir)
  evalq(expr)
}
