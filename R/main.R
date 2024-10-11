
#'
#' Restore environment.
#'
#' @param dir temporary directory
#' @param version campsisverse version
#' @importFrom renv restore
#' @export
#'
installEnv <- function(dir=getEnvDefaultDir(), version=getPackageVersion()) {
  
  project <- file.path(dir, paste0("campsisverse_", version))
  
  # make dir
  dir.create(project, showWarnings=FALSE)
  
  # Create a temporary file with the renv.lock data
  filePath <- file.path(project, "renv.lock")
  fileConn <- file(filePath)
  data <- eval(parse(text=sprintf("campsisverse::%s", paste0("renv_lock_", version))))
  writeLines(gsub(pattern="\r", replacement="", x=data), sep="", fileConn)
  close(fileConn)
  
  renv::restore(lockfile=filePath, project=project, exclude="campsisnca")
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
