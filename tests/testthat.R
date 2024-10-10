Sys.setenv("R_TESTS" = "")
library(testthat)
library(campsisverse)
test_check("campsisverse")
