library(testthat)

context("Test the main script")

source(paste0("", "testUtils.R"))

test_that("Method 'processVersion' works as expected", {

  expect_equal(processVersion("24-12-01"), "241201")
  expect_equal(processVersion("24.12.01"), "241201")
  
  expect_error(processVersion("24-10-31"), regexp="Version 24-10-31 is not available. Available versions are: 24-12-01")
  expect_error(processVersion("24.10.31"), regexp="Version 24\\.10\\.31 is not available. Available versions are: 24-12-01")
})

test_that("Method 'getCampsisSuitePackages' works as expected", {
  
  expect_equal(getCampsisSuitePackages(), c("campsismod", "campsis", "campsisnca", "campsismisc", "campsisqual", "campsistrans", "mrgsolve", "rxode2"))
  expect_equal(getCampsisSuitePackages(include_engines=FALSE), c("campsismod", "campsis", "campsisnca", "campsismisc", "campsisqual", "campsistrans"))
})



test_that("Test the renv.lock file dated 250209", {
  version <- "250209"
  
  # All packages
  raw <- readLines(getLockFile(version=version, all=TRUE, no_deps=FALSE))
  packages <- campsisverse:::detectPackages(raw)
  expect_equal(length(packages), 227)
  
  # All but private packages
  raw <- readLines(getLockFile(version=version, all=FALSE, no_deps=FALSE))
  packages <- campsisverse:::detectPackages(raw)
  expect_equal(length(packages), 226)
  expect_false("campsistrans" %in% packages)
  
  # All packages but omit Campsis suite dependencies
  raw <- readLines(getLockFile(version=version, all=TRUE, no_deps=TRUE))
  packages <- campsisverse:::detectPackages(raw)
  expect_equal(packages, c("campsis", "campsismisc", "campsismod", "campsisnca", "campsisqual", "campsistrans", "mrgsolve", "rxode2"))
})

test_that("Test the renv.lock file dated 250314", {
  version <- "250314"
  
  # All packages
  raw <- readLines(getLockFile(version=version, all=TRUE, no_deps=FALSE))
  packages <- campsisverse:::detectPackages(raw)
  expect_equal(length(packages), 227)
  
  # All but private packages
  raw <- readLines(getLockFile(version=version, all=FALSE, no_deps=FALSE))
  packages <- campsisverse:::detectPackages(raw)
  expect_equal(length(packages), 226)
  expect_false("campsistrans" %in% packages)
  
  # All packages but omit Campsis suite dependencies
  raw <- readLines(getLockFile(version=version, all=TRUE, no_deps=TRUE))
  packages <- campsisverse:::detectPackages(raw)
  expect_equal(packages, c("campsis", "campsismisc", "campsismod", "campsisnca", "campsisqual", "campsistrans", "mrgsolve", "rxode2"))
})

