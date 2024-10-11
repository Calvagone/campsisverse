
#'
#' Restore environment.
#'
#' @param version campsisverse version
#' @param ... extra arguments
#' @importFrom renv restore
#' @export
#'
restore <- function(version=getPackageVersion(), ...) {
  configureOptions()
  renv::restore(lockfile=getLockFile(version=version), ...)
}

#'
#' Use environment.
#'
#' @param version campsisverse version
#' @param ... extra arguments
#' @importFrom renv restore
#' @export
#'
use <- function(version=getPackageVersion(), ...) {
  configureOptions()
  renv::use(lockfile=getLockFile(version=version), ...)
}

#'
#' Qualify the Campsis environment.
#'
#' @param packages campsisverse version
#' @param fullname full user name (firstname lastname)
#' @param output_dir output directory of the qualification report
#' @param ... extra arguments
#' @importFrom renv restore
#' @export
#'
qualify <- function(packages, fullname, output_dir=getwd()) {
  require("campsisqual")
  campsisqual::runQualification(packages=packages, fullname=fullname, output_dir=output_dir)
}

#'
#' Get lock file.
#'
#' @param dir temporary directory
#' @param version campsisverse version
#' @importFrom renv load
#' @export
#'
getLockFile <- function(version=getPackageVersion()) {
  filePath <- tempfile(fileext=".lock")
  fileConn <- file(filePath)
  data <- eval(parse(text=sprintf("campsisverse::%s", paste0("renv_lock_", version))))
  writeLines(gsub(pattern="\r", replacement="", x=data), sep="", fileConn)
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
