
#'
#' Restore environment.
#'
#' @param dir temporary directory
#' @param version campsisverse version
#' @importFrom renv restore
#' @export
#'
restoreEnv <- function(dir=dirname(tempdir()), version="0.0.1") {
  # Create a temporary file with the renv.lock data
  tmpRenvFile <- tempfile()
  fileConn <- file(tmpRenvFile)
  data <- eval(parse(text=sprintf("campsisverse::%s", paste0("renv_lock_", version))))
  writeLines(data, fileConn)
  close(fileConn)

  # Restore the environment
  renv::restore(lockfile=tmpRenvFile, exclude=getPrivatePackages(),
                project=file.path(dir, paste0("campsisverse_", version)))
  
  # Snapshot
  renv::snapshot(project=file.path(dir, paste0("campsisverse_", version)))
}

#'
#' Load environment.
#'
#' @param dir temporary directory
#' @param version campsisverse version
#' @importFrom renv load
#' @export
#'
loadEnv <- function(dir=dirname(tempdir()), version="0.0.1") {
  renv::load(project=file.path(dir, paste0("campsisverse_", version)))
}

getPrivatePackages <- function() {
  retValue <- "campsistrans" |>
    append("campsisqual") |>
    append("calvamod") |>
    append("ecampsis")
  return(retValue)
}