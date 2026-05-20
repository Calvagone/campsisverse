repos <- "https://packagemanager.posit.co/cran/2026-05-19"
options(repos=repos)

# Install correct version of renv
install.packages("renv")

# Init
renv::init(repos=repos)
