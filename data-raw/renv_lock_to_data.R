

renv_lock_1.0.0 <- readr::read_file("data-raw/renv_1.0.0/renv.lock")
usethis::use_data(renv_lock_1.0.0, overwrite=TRUE)