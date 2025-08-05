repos <- "https://packagemanager.posit.co/cran/2025-03-29"
options(repos=repos)

# Install correct version of renv
install.packages("renv")

# Init
renv::init(repos=repos)

# Reassign repos variable

# Install tests by default
options(INSTALL_opts="--install-tests")

# Install and snapshot (lock=TRUE)
renv::install(
  packages=c(
    "Calvagone/campsismod@v1.2.3",
    "Calvagone/campsis@v1.7.0",
    "Calvagone/campsisnca@v1.5.1",
    "Calvagone/campsismisc@v0.5.2",
    "Calvagone/campsisqual@v1.4.0",
    "Calvagone/campsistrans@v1.4.0",
    "mrgsolve@1.5.1", # See https://github.com/Calvagone/campsis/issues/160
    "rxode2",
    "ncappc",         # Campsisnca testing
    "xgxr",           # e-Campsis
    "cowplot",        # e-Campsis
    "ragg"            # High-quality 2D drawing library 
    ),
  rebuild=TRUE,
  repos=repos,
  lock=TRUE)

