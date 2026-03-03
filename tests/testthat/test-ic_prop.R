test_that("ic_prop works for binary data", {
  x <- c(rep(1, 30), rep(0, 20))
  res <- ic_prop(x)

  expect_s3_class(res, "ic_prop")
  expect_length(res$conf.int, 2)
})