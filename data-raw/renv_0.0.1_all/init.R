library(renv)

project <- "data-raw/renv_0.0.1_all"

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
                         "Calvagone/ecampsis@v1.12.3",
                         "Calvagone/calvamod@v0.6.0",
                         "Calvagone/campsisqual@develop",
                         "mrgsolve",
                         "rxode2",
                         "xgxr",
                         "cowplot",
                         "ragg"),
              exclude=c("campsisverse"),
              rebuild=TRUE,
              lock=TRUE)


