
#'
#' Restore environment.
#'
#' @param dir temporary directory
#' @param version campsisverse version
#' @importFrom renv restore
#' @export
#'
restoreEnv <- function(dir=getEnvDefaultDir(), version=getPackageVersion()) {
  # Create a temporary file with the renv.lock data
  tmpRenvFile <- tempfile()
  fileConn <- file(tmpRenvFile)
  data <- eval(parse(text=sprintf("campsisverse::%s", paste0("renv_lock_", version))))
  writeLines(data, fileConn)
  close(fileConn)

  # Restore the environment
  renv::restore(lockfile=tmpRenvFile, project=file.path(dir, paste0("campsisverse_", version)))
  
  # https://stackoverflow.com/questions/68890715/install-r-package-with-specific-version-and-tests
}

#'
#' Load environment.
#'
#' @param dir temporary directory
#' @param version campsisverse version
#' @importFrom renv load
#' @export
#'
loadEnv <- function(dir=getEnvDefaultDir(), version=getPackageVersion()) {
  renv::load(project=file.path(dir, paste0("campsisverse_", version)))
}

getEnvDefaultDir <- function() {
  return(dirname(tempdir()))
}

getPackageVersion <- function() {
  return(getNamespaceVersion("campsisverse") |>
           as.character())
}
