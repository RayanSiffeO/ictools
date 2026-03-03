test_that("ic_razon_var returns valid interval", {
  x <- rnorm(40)
  y <- rnorm(35)

  res <- ic_razon_var(x, y)

  expect_s3_class(res, "ic_razon_var")
  expect_length(res$conf.int, 2)
})