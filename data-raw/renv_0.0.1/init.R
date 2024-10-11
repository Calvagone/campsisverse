library(renv)

project <- "data-raw/renv_0.0.1"

renv::init(project=project, repos="https://packagemanager.posit.co/cran/2024-09-30")

# Install open-source packages
renv::install(project=project,
              packages=c("Calvagone/campsismod@v1.1.1",
                         "Calvagone/campsis@v1.5.4",
                         "Calvagone/campsisnca@v1.5.0",
                         "Calvagone/campsismisc@v0.5.0"),
              lock=TRUE)

