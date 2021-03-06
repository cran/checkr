context("check-prob")

test_that("check_prob errors", {
  y <- 1.0
  expect_identical(check_prob(y), y)
  y <- 1L
  expect_error(check_prob(y), "y must be class numeric")
  y <- c(1.0, 1.0)
  expect_error(check_prob(y), "y must have 1 element")
  y <- NA_real_
  expect_error(check_prob(y), "y must not include missing values")
  y <- 2
  expect_error(check_prob(y), "the values in y must lie between 0 and 1")
})
