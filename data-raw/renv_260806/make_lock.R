# Sys.setenv(GITHUB_PAT=<REPLACE_ME>)
repos <- "https://packagemanager.posit.co/cran/2026-08-06"
options(repos = repos)

# Initialize a bare renv project without installing bare CRAN defaults
renv::init(bare = TRUE, repos = repos)

# Install and snapshot (lock=TRUE)
pkgs <- c(
    "Calvagone/campsismod@v1.4.0",
    "Calvagone/campsis@v1.9.0",
    "Calvagone/campsisnca@v1.7.0",
    "Calvagone/campsismisc@v1.0.0",
    "Calvagone/campsisqual@v1.5.0",
    "Calvagone/campsistrans@develop",
    "mrgsolve",
    "rxode2",
    "xgxr",           # e-Campsis (R version)
    "cowplot",        # e-Campsis (R version)
    "ragg",           # High-quality 2D drawing library 
    "plumber",        # e-Campsis desktop
    "arrow",          # e-Campsis desktop
    "base64enc",      # e-Campsis desktop
    "webshot2"        # e-Campsis desktop
    )

  renv::record(records = pkgs, lock = TRUE)
