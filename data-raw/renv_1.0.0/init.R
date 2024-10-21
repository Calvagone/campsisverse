library(renv)

project <- "data-raw/renv_1.0.0"

# Note: click no when you are prompted to quit the session
renv::init(project=project, repos="https://packagemanager.posit.co/cran/2024-09-30")

# Configure options for tests
campsisverse::configureOptions()

# Install open-source packages
renv::install(project=project,
              packages=c("Calvagone/campsismod@v1.1.1",
                         "Calvagone/campsis@v1.5.4",
                         "Calvagone/campsisnca@v1.5.0",
                         "Calvagone/campsismisc@v0.5.0",
                         "Calvagone/campsistrans@v1.2.2",
                         "Calvagone/calvamod@v0.6.0",
                         "Calvagone/campsisqual@develop", # To replace by the official release
                         "Calvagone/campsisverse@master", # To replace by the official release
                         "mrgsolve",
                         "rxode2",
                         "xgxr",
                         "cowplot",
                         "ragg",
                         "stats"),
              rebuild=TRUE,
              lock=TRUE)

