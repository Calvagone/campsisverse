library(renv)

project <- "data-raw/renv_0.0.1"

# Note: click no when you are prompted to quit the session
renv::init(project=project, repos="https://packagemanager.posit.co/cran/2024-09-30")

# Configure options for tests (only useful on this machine, to install packages with tests)
campsisverse::configureOptions()

# Install open-source packages
renv::install(project=project,
              packages=c("Calvagone/campsismod@v1.1.1",
                         "Calvagone/campsis@v1.5.4",
                         "Calvagone/campsisnca@v1.5.0",
                         "Calvagone/campsismisc@v0.5.0",
                         "Calvagone/campsisverse@master", # To replace by the official release
                         "mrgsolve",
                         "rxode2",
                         "xgxr",
                         "cowplot",
                         "ragg"),
              rebuild=TRUE,
              lock=TRUE)

