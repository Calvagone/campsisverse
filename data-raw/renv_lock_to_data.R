
renv_lock_0.0.1 <- readr::read_file("data-raw/renv_0.0.1/renv.lock")
usethis::use_data(renv_lock_0.0.1, overwrite=TRUE)
