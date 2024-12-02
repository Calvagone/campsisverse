repos <- "https://packagemanager.posit.co/cran/2024-12-01"
options(repos=repos)

# Install correct version of renv
install.packages("renv")

# Init
renv::init(repos=repos)

# Install tests by default
options(INSTALL_opts="--install-tests")

# Set up GitHub PAT

# Install and snapshot (lock=TRUE)
renv::install(
  packages=c(
    "campsismod@1.1.2",
    "campsis@1.5.5",
    "Calvagone/campsisnca@v1.5.1",
    "Calvagone/campsismisc@v0.5.2",
    "Calvagone/campsisqual@v1.3.1",
    "Calvagone/campsistrans@v1.2.3",
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

