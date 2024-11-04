
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
  # Warning is suppressed because of the following issue: #1
  suppressWarnings(renv::restore(lockfile=getLockFile(version=version, all=all), ...))
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
  # Warning is suppressed because of the following issue: #1
  suppressWarnings(renv::use(lockfile=getLockFile(version=version, all=all), ...))
}

#'
#' Qualify the Campsis environment. Note that this is just a call to the campsisqual::runQualification function.
#'
#' @param packages campsisverse version
#' @param fullname full user name (firstname lastname)
#' @param output_dir output directory of the qualification report
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
  version_ <- processVersion(version)
  filePath <- tempfile(fileext=".lock")
  fileConn <- file(filePath)
  dataRaw <- eval(parse(text=sprintf("campsisverse::%s", paste0("renv_lock_", version_))))
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

processVersion <- function(version) {
  version_ <- gsub(pattern="[\\.-]", replacement="", x=version)
  if (!version_ %in% getAvailableVersions()) {
    stop(sprintf("Version %s is not available. Available versions are: %s", version, paste(getAvailableVersions(as_date=TRUE), collapse=", ")))
  }
  return(version_)
}

getAvailableVersions <- function(as_date=FALSE) {
  dataItems <- as.character(data(package="campsisverse")[["results"]][,"Item"])
  retValue <- gsub("renv_lock_", "", dataItems)
  if (as_date) {
    retValue <- gsub(pattern="(\\d)(\\d)(\\d)(\\d)(\\d)(\\d)", replacement="\\1\\2-\\3\\4-\\5\\6", x=retValue)
  }
  return(retValue)
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
  return(c("campsistrans", "calvamod", "campsisqual"))
}

#'
#' Get the public packages from the Campsis suite.
#'
#' @return a character vector of the public packages
#'
getPublicPackages <- function() {
  return(c("campsismod", "campsis", "campsisnca", "campsismisc"))
}

getPackageVersion <- function() {
  return(getNamespaceVersion("campsisverse") |>
           as.character())
}
