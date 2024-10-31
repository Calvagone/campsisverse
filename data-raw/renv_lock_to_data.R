

renv_lock_241031 <- readr::read_file("data-raw/renv_241031/renv.lock")
usethis::use_data(renv_lock_241031, overwrite=TRUE)