
renv_lock_241201 <- readr::read_file("data-raw/renv_241201/renv.lock")
usethis::use_data(renv_lock_241201, overwrite=TRUE)

renv_lock_250203 <- readr::read_file("data-raw/renv_250203/renv.lock")
usethis::use_data(renv_lock_250203, overwrite=TRUE)