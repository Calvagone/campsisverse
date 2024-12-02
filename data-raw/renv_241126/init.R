repos <- "https://packagemanager.posit.co/cran/2024-10-17" # Just before mrgsolve v1.5.2
options(repos=repos)

# Install correct version of renv
install.packages("renv")

# Init
renv::init(repos=repos)

# Install and snapshot (lock=TRUE)
renv::install(
  packages=c(
    "Calvagone/campsismod@v1.1.2",
    "campsis@1.5.5",
    "Calvagone/campsisnca@v1.5.1",
    "Calvagone/campsismisc@v0.5.2",
    "Calvagone/campsisqual@v1.3.0",
    "Calvagone/campsistrans@v1.2.2",
    "Calvagone/calvamod@v0.6.0",
    "mrgsolve",
    "rxode2",
    "xgxr",
    "cowplot",
    "ragg"
    ),
  rebuild=TRUE,
  repos=repos,
  lock=TRUE)

