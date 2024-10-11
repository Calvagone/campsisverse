
#'
#' Restore environment.
#'
#' @param version campsisverse version
#' @param ... extra arguments
#' @importFrom renv restore
#' @export
#'
restore <- function(version=getPackageVersion(), ...) {
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
  renv::use(lockfile=getLockFile(version=version), ...)
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
