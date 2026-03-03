test_that("ic_var works for numeric input", {
  x <- rnorm(40)
  res <- ic_var(x)

  expect_s3_class(res, "ic_var")
  expect_length(res$conf.int, 2)
})