
renv_lock_0.0.1 <- readr::read_file("data-raw/renv_0.0.1/renv.lock")
usethis::use_data(renv_lock_0.0.1, overwrite=TRUE)

renv_lock_0.0.1_all <- readr::read_file("data-raw/renv_0.0.1_all/renv.lock")
usethis::use_data(renv_lock_0.0.1_all, overwrite=TRUE)

renv_lock_0.0.2 <- readr::read_file("data-raw/renv_0.0.2/renv.lock")
usethis::use_data(renv_lock_0.0.2, overwrite=TRUE)

renv_lock_0.0.2_all <- readr::read_file("data-raw/renv_0.0.2_all/renv.lock")
usethis::use_data(renv_lock_0.0.2_all, overwrite=TRUE)