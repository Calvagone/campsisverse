#'
#' Install the Campsis suite into your R distribution.
#' Please note the installation will occur in 2 steps:
#' 1. Campsis packages will be installed with their tests
#' 2. Extra packages (mrgsolve, rxode2, etc.) will be downloaded in their binary form and installed
#'
#' @param ... extra arguments passed to renv::install
#' @param cran install Campsis packages from CRAN when possible, default is TRUE
#' @importFrom renv install
#' @export
#'
install <- function(..., cran=TRUE) {
  options(INSTALL_opts="--install-tests")
  packages <- c(
    sprintf("%scampsismod", ifelse(cran, "", "Calvagone/")),
    sprintf("%scampsis", ifelse(cran, "", "Calvagone/")),
    "Calvagone/campsisnca",
    "Calvagone/campsismisc",
    "Calvagone/campsisqual"
  )
  # Set type to 'source', otherwise tests are not installed when packages come from CRAN
  renv::install(packages=packages, type="source", ...)
  extras <- c(
    "mrgsolve",
    "rxode2",
    "ncappc", # Campsisnca testing only
    "xgxr",
    "cowplot",
    "ragg"
  )
  renv::install(packages=extras, ...)
}

#'
#' Restore environment.
#'
#' @param version campsisverse version
#' @param all all packages, included private ones, default is FALSE. Reserved for Calvagone members only.
#' @param no_deps do not restore Campsis suite dependencies as specified in the lock file, default is FALSE.
#' @param ... extra arguments
#' @importFrom renv restore
#' @export
#'
restore <- function(version=getPackageVersion(), all=FALSE, no_deps=FALSE, ...) {
  options(INSTALL_opts="--install-tests")
  # Warning is suppressed because of the following issue: #1
  suppressWarnings(renv::restore(lockfile=getLockFile(version=version, all=all, no_deps=no_deps), ...))
}

#'
#' Use environment.
#'
#' @param version campsisverse version
#' @param all all packages, included private ones, default is FALSE. Reserved for Calvagone members only.
#' @param no_deps do not use Campsis suite dependencies as specified in the lock file, default is FALSE.
#' @param ... extra arguments
#' @importFrom renv use
#' @export
#'
use <- function(version=getPackageVersion(), all=FALSE, no_deps=FALSE, ...) {
  options(INSTALL_opts="--install-tests")
  # Warning is suppressed because of the following issue: #1
  suppressWarnings(renv::use(lockfile=getLockFile(version=version, all=all, no_deps=no_deps), ...))
}

#'
#' Uninstall the Campsis suite.
#'
#' @param all all packages included private ones, default is FALSE
#' @export
#'
uninstall <- function(all=FALSE) {
  packages <- getPublicPackages()
  if (all) {
    packages <- c(packages, getPrivatePackages())
  }
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
#' @param no_deps discard Campsis suite dependencies specified in the lock file, default is FALSE.
#' @param prompt prompt the user for input, default is TRUE (e.g. if campsisverse must be updated)
#' @importFrom renv load
#' @importFrom jsonlite fromJSON toJSON
#' @importFrom remotes install_github
#' @importFrom utils askYesNo
#' @export
#'
getLockFile <- function(version=getPackageVersion(), all=FALSE, no_deps=FALSE, prompt=TRUE) {
  version_ <- tryCatch(
    processVersion(version),
    error = function(cond) {
      cat(cond$message)
      yes <- utils::askYesNo("Do you want to update campsisverse?", default=TRUE)
      if (isTRUE(yes)) {
        remotes::install_github("Calvagone/campsisverse")
        return(processVersion(version))
      } else {
        stop("Operation cancelled.")
      }
    })
  
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
  
  # Discard Campsis suite dependencies if argument no_deps is TRUE
  # Note: mrgsolve and rxode2 are always included
  if (no_deps) {
    packageNames <- names(data$Packages)
    packageNames <- packageNames[packageNames %in% getCampsisSuitePackages(include_engines=TRUE)]
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

#'
#' Get the private packages from the Campsis suite.
#'
#' @return a character vector of the private packages
#'
getPrivatePackages <- function() {
  return(c("campsistrans"))
}

#'
#' Get the public packages from the Campsis suite.
#'
#' @return a character vector of the public packages
#'
getPublicPackages <- function() {
  return(c("campsismod", "campsis", "campsisnca", "campsismisc", "campsisqual"))
}

#'
#' Get all packages from the Campsis suite.
#'
#' @param include_engines include simulation engines (mrgsolve and rxode2), default is TRUE
#' @return a character vector with the packages
#' @export
#'
getCampsisSuitePackages <- function(include_engines=TRUE) {
  retValue <- c(getPublicPackages(), getPrivatePackages())
  if (include_engines) {
    retValue <- retValue |>
      append(c("mrgsolve", "rxode2"))
  }
  
  return(retValue)
}

getPackageVersion <- function() {
  return(getNamespaceVersion("campsisverse") |>
           as.character())
}
