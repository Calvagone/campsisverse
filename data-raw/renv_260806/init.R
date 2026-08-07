repos <- "https://packagemanager.posit.co/cran/2026-08-06"
options(repos=repos)

# Install correct version of renv
install.packages("renv")

# Init
renv::init(repos=repos)

