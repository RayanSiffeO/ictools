#' Confidence Interval for the Ratio of Variances
#'
#' Computes confidence intervals for the ratio of two population variances.
#'
#' @param x Numeric vector or matrix (first sample).
#' @param y Numeric vector or matrix (second sample).
#' @param conf.level Confidence level (default 0.95).
#' @param method Character. "f", "log", or "bootstrap".
#' @param R Number of bootstrap replicates (default 2000).
#' @param na.rm Logical. Whether to remove NA values.
#'
#' @return A list of class "ic_var_ratio" with ratio estimate and confidence interval.
#' @examples
#' data1 <- matrix(c(5, 7, 8, 6, 9, 10), nrow = 2)
#' data2 <- matrix(c(4, 6, 7, 5, 8, 9), nrow = 2)
#' ic_razon_var(data1, data2)
#' ic_razon_var(data1, data2, conf.level = 0.99)
#'
#' @importFrom stats var qf qnorm
#' @export
ic_razon_var <- function(
  x,
  y,
  conf.level = 0.95,
  method = c("f", "log", "bootstrap"),
  R = 2000,
  na.rm = TRUE
) {

  if (!is.numeric(conf.level) || conf.level <= 0 || conf.level >= 1)
    stop("'conf.level' must be between 0 and 1.")

  method <- match.arg(method)

  if (na.rm) {
    x <- x[!is.na(x)]
    y <- y[!is.na(y)]
  }

  if (length(x) < 2 || length(y) < 2)
    stop("Each sample must contain at least 2 observations.")

  s1 <- var(x)
  s2 <- var(y)
  ratio <- s1 / s2
  n1 <- length(x)
  n2 <- length(y)
  alpha <- 1 - conf.level

  ci <- switch(
    method,
    f = c(
      ratio / stats::qf(1 - alpha/2, n1-1, n2-1),
      ratio / stats::qf(alpha/2, n1-1, n2-1)
    ),
    log = {
      se <- sqrt(2/(n1-1) + 2/(n2-1))
      z <- stats::qnorm(1 - alpha/2)
      exp(log(ratio) + c(-1,1)*z*se)
    },
    bootstrap = {
      boot <- replicate(R,
        var(sample(x, replace=TRUE)) /
        var(sample(y, replace=TRUE)))
      stats::quantile(boot, c(alpha/2, 1-alpha/2), names=FALSE)
    }
  )

  structure(
    list(
      estimate = ratio,
      conf.int = ci,
      conf.level = conf.level,
      method = method,
      n1 = n1,
      n2 = n2
    ),
    class = "ic_razon_var"
  )
}