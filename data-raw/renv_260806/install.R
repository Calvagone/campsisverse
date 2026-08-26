Sys.setenv(GITHUB_PAT = "")

repos <- "https://packagemanager.posit.co/cran/2026-08-06"

# Install tests by default
options(INSTALL_opts = "--install-tests")

pkgs <- c(
  "Calvagone/campsismod@v1.4.0",
  "Calvagone/campsis@v1.9.0.9001",
  "Calvagone/campsisnca@v1.7.0",
  "Calvagone/campsismisc@v1.0.0",
  "Calvagone/campsisqual@v1.5.1",
  "Calvagone/campsistrans@v1.5.0",
  "mrgsolve",
  "rxode2",
  "xgxr", # e-Campsis (R version)
  "cowplot", # e-Campsis (R version)
  "ragg", # High-quality 2D drawing library
  "plumber", # e-Campsis desktop
  "arrow", # e-Campsis desktop
  "base64enc", # e-Campsis desktop
  "webshot2" # e-Campsis desktop
)

# Install and snapshot (lock=TRUE)
renv::install(
  packages = pkgs,
  rebuild = TRUE,
  repos = repos,
  lock = TRUE
)
