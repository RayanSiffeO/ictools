test_that("ic_reg works with lm model", {
  model <- lm(mpg ~ wt + hp, data = mtcars)
  res <- ic_reg(model)

  expect_s3_class(res, "ic_reg")
  expect_true(is.matrix(res$conf.int))
})