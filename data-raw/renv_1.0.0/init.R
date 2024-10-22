repos <- "https://packagemanager.posit.co/cran/2024-09-30"
options(repos=repos)

# Install correct version of renv
install.packages("renv")

# Init
renv::init(repos=repos)

# Install and snapshot (lock=TRUE)
renv::install(
  packages=c(
    "Calvagone/campsismod@v1.1.1",
    "Calvagone/campsis@v1.5.4",
    "Calvagone/campsisnca@v1.4.0",
    "Calvagone/campsismisc@v0.5.0",
    "Calvagone/campsistrans@v1.2.2",
    "Calvagone/calvamod@v0.6.0",
    "Calvagone/campsisqual@v1.2.0",
    "mrgsolve",
    "rxode2",
    "xgxr",
    "cowplot",
    "ragg",
    "stats"),
  rebuild=TRUE,
  repos=repos,
  lock=TRUE)

