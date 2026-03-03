test_that("ic_pmean returns correct structure", {
  set.seed(123)
  x <- rnorm(50)
  res <- ic_pmean(x)

  expect_s3_class(res, "ic_pmean")
  expect_true(is.numeric(res$conf.int))
  expect_length(res$conf.int, 2)
  expect_true(res$conf.int[1] < res$conf.int[2])
})