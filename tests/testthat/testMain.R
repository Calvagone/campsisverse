library(testthat)

context("Test the main script")

source(paste0("", "testUtils.R"))

test_that("Method 'processVersion' works as expected", {

  expect_equal(processVersion("24-10-31"), "241031")
  expect_equal(processVersion("24.10.31"), "241031")
  
  expect_error(processVersion("24-10-30"), regexp="Version 24-10-30 is not available. Available versions are: 24-10-31")
  expect_error(processVersion("24.10.30"), regexp="Version 24\\.10\\.30 is not available. Available versions are: 24-10-31")
})

test_that("Method 'getCampsisSuitePackages' works as expected", {
  
  expect_equal(getCampsisSuitePackages(), c("campsismod", "campsis", "campsisnca", "campsismisc", "campsisqual", "campsistrans", "mrgsolve", "rxode2"))
  expect_equal(getCampsisSuitePackages(include_engines=FALSE), c("campsismod", "campsis", "campsisnca", "campsismisc", "campsisqual", "campsistrans"))
})

