#'
#' Install the Campsis suite into your R distribution.
#'
#' @description
#' Please note the installation will occur in 2 steps:
#' 1. Campsis packages will be installed with their tests
#' 2. Extra packages (mrgsolve, rxode2, etc.) will be downloaded in their binary form and installed
#'
#' @param ... extra arguments passed to renv::install
#' @param cran install Campsis packages from CRAN when possible, default is TRUE
#' @importFrom renv install
#' @export
#'
install <- function(..., cran = TRUE) {
  options(INSTALL_opts = "--install-tests")
  packages <- c(
    sprintf("%scampsismod", ifelse(cran, "", "Calvagone/")),
    sprintf("%scampsis", ifelse(cran, "", "Calvagone/")),
    "Calvagone/campsisnca",
    "Calvagone/campsismisc",
    "Calvagone/campsisqual",
    "Calvagone/campsistrans"
  )
  # Set type to 'source', otherwise tests are not installed when packages come from CRAN
  renv::install(packages = packages, type = "source", ...)
  extras <- c(
    "mrgsolve",
    "rxode2",
    "ncappc", # Campsisnca testing
    "xgxr", # e-Campsis (R version)
    "cowplot", # e-Campsis (R version)
    "ragg", # High-quality 2D drawing library
    "plumber", # e-Campsis desktop
    "arrow", # e-Campsis desktop
    "base64enc", # e-Campsis desktop
    "webshot2" # e-Campsis desktop
  )
  renv::install(packages = extras, ...)
}

#'
#' Restore environment.
#'
#' @param version campsisverse version
#' @param all all packages, included private ones, default is FALSE. Reserved for Calvagone members only.
#' @param no_deps do not restore Campsis suite dependencies as specified in the lock file, default is FALSE.
#' @param library library paths to be used during restore, default is \code{.libPaths()}
#' @param ... extra arguments
#' @importFrom renv restore
#' @export
#'
restore <- function(version = get_package_version(), all = FALSE, no_deps = FALSE, library = .libPaths(), ...) {
  options(INSTALL_opts = "--install-tests")
  # Warning is suppressed because of the following issue: #1
  suppressWarnings(renv::restore(
    library = library,
    lockfile = get_lock_file(version = version, all = all, no_deps = no_deps),
    ...
  ))
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
use <- function(version = get_package_version(), all = FALSE, no_deps = FALSE, ...) {
  options(INSTALL_opts = "--install-tests")
  lockfile <- get_lock_file(version = version, all = all, no_deps = no_deps, discard_renv = TRUE)
  # Warning is suppressed because of the following issue: #1
  suppressWarnings(renv::use(lockfile = lockfile, ...))
}

#'
#' Uninstall the Campsis suite.
#'
#' @param all all packages included private ones, default is FALSE
#' @importFrom utils remove.packages
#' @export
#'
uninstall <- function(all = FALSE) {
  packages <- get_public_packages()
  if (all) {
    packages <- c(packages, get_private_packages())
  }
  for (package in packages) {
    if (length(find.package(package, quiet = TRUE)) > 0) {
      utils::remove.packages(package)
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
#' @param discard_renv discard renv package from the lock file, default is FALSE
#' @export
#'
get_lock_file <- function(
  version = get_package_version(),
  all = FALSE,
  no_deps = FALSE,
  prompt = TRUE,
  discard_renv = FALSE
) {
  version_ <- process_version(version)

  filePath <- tempfile(fileext = ".lock")
  fileConn <- file(filePath)
  dataRawTmp <- eval(parse(text = sprintf("campsisverse::%s", paste0("renv_lock_", version_))))

  # Large character vector
  dataRaw <- strsplit(dataRawTmp, split = "\r\n")[[1]]

  # Discard private packages if argument all is FALSE
  if (!all) {
    packages <- detect_packages(dataRaw)
    for (package in get_private_packages()) {
      dataRaw <- remove_package_from_raw(dataRaw, package, last = packages[length(packages)] == package)
    }
  }

  # Discard renv package
  if (discard_renv) {
    packages <- detect_packages(dataRaw)
    dataRaw <- remove_package_from_raw(dataRaw, "renv", last = packages[length(packages)] == "renv")
  }

  # Discard Campsis suite dependencies if argument no_deps is TRUE
  # Note: mrgsolve and rxode2 are always included
  if (no_deps) {
    packages <- detect_packages(dataRaw)
    campsisSuitePackages <- get_campsis_suite_packages(include_engines = TRUE)
    for (package in packages) {
      if (!package %in% campsisSuitePackages) {
        # print(sprintf("Removing package %s", package))
        dataRaw <- remove_package_from_raw(dataRaw, package, last = packages[length(packages)] == package)
      }
    }
  }

  # Possibly get rid of comma for last package
  dataRaw <- no_comma_for_last_package(dataRaw)

  writeLines(dataRaw, fileConn)
  close(fileConn)

  return(filePath)
}

process_version <- function(version) {
  version_ <- gsub(pattern = "[\\.-]", replacement = "", x = version)
  if (!version_ %in% getAvailableVersions()) {
    stop(sprintf(
      "Version %s is not available. Available versions are: %s. Please run remotes::install_github(\"Calvagone/campsisverse\") to update Campsisverse.",
      version,
      paste(getAvailableVersions(as_date = TRUE), collapse = ", ")
    ))
  }
  return(version_)
}

remove_package_from_raw <- function(raw, package, last) {
  # Detect package start
  start <- which(grepl(pattern = sprintf("^[[:space:]]+\"%s\":[[:space:]]+\\{[[:space:]]*$", package), x = raw))

  # Detect package end
  if (last) {
    end <- which(grepl(pattern = "^[[:space:]]+\\}[[:space:]]*$", x = raw))
  } else {
    end <- which(grepl(pattern = "^[[:space:]]+\\},[[:space:]]*$", x = raw))
  }
  end <- end[which(end > start)][1]

  # Remove package
  raw <- raw[-c(start:end)]

  return(raw)
}

detect_packages <- function(raw) {
  # Detect start of packages
  start <- which(grepl(pattern = "^[[:space:]]+\"Packages\":[[:space:]]+\\{[[:space:]]*$", x = raw))

  # Detect all packages from json
  tmp <- which(grepl(pattern = "^[[:space:]]+\"[a-zA-Z0-9]+\":[[:space:]]+\\{[[:space:]]*$", x = raw))

  # Skip occurrences before the start of packages
  tmp <- tmp[tmp > start]
  packages <- gsub(pattern = "[\" \\{:]", replacement = "", raw[tmp])

  return(packages)
}

no_comma_for_last_package <- function(raw) {
  packages <- detect_packages(raw)
  lastPackage <- packages[length(packages)]

  # Detect package start
  start <- which(grepl(pattern = sprintf("^[[:space:]]+\"%s\":[[:space:]]+\\{[[:space:]]*$", lastPackage), x = raw))

  # Detect package end
  end <- which(grepl(pattern = "^[[:space:]]+\\},?[[:space:]]*$", x = raw))
  end <- end[which(end > start)][1]

  # Remove comma
  raw[end] <- gsub(pattern = ",", replacement = "", x = raw[end])
  return(raw)
}

#'
#' Get the private packages from the Campsis suite.
#'
#' @return a character vector of the private packages
#'
get_private_packages <- function() {
  return(NULL)
}

#'
#' Get the public packages from the Campsis suite.
#'
#' @return a character vector of the public packages
#'
get_public_packages <- function() {
  return(c("campsismod", "campsis", "campsisnca", "campsismisc", "campsistrans", "campsisqual"))
}

#'
#' Get all packages from the Campsis suite.
#'
#' @param include_engines include simulation engines (mrgsolve and rxode2), default is TRUE
#' @return a character vector with the packages
#' @export
#'
get_campsis_suite_packages <- function(include_engines = TRUE) {
  retValue <- c(get_public_packages(), get_private_packages())
  if (include_engines) {
    retValue <- retValue |>
      append(c("mrgsolve", "rxode2"))
  }

  return(retValue)
}

get_package_version <- function() {
  return(
    getNamespaceVersion("campsisverse") |>
      as.character()
  )
}
