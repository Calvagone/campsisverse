

renv_lock_241031 <- readr::read_file("data-raw/renv_241031/renv.lock")
usethis::use_data(renv_lock_241031, overwrite=TRUE)

renv_lock_241126 <- readr::read_file("data-raw/renv_241126/renv.lock")
usethis::use_data(renv_lock_241126, overwrite=TRUE)