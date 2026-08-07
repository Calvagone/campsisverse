repos <- "https://packagemanager.posit.co/cran/2026-01-05"
options(repos = repos)

# Install correct version of renv
install.packages("renv")

# Init
renv::init(repos = repos)

# Reassign repos variable

# Install tests by default
options(INSTALL_opts = "--install-tests")

# Install and snapshot (lock=TRUE)
renv::install(
  packages = c(
    "Calvagone/campsismod@v1.3.2",
    "Calvagone/campsis@v1.8.2",
    "Calvagone/campsisnca@v1.6.1",
    "Calvagone/campsismisc@v0.6.0",
    "Calvagone/campsisqual@v1.4.1",
    "Calvagone/campsistrans@v1.4.1",
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
  ),
  rebuild = TRUE,
  repos = repos,
  lock = TRUE
)
