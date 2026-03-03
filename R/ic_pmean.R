#' Confidence Interval for the Mean
#'
#' Computes confidence intervals for a population mean.
#'
#' @param x Numeric vector, matrix, or data.frame.
#' @param conf.level Confidence level (default 0.95).
#' @param type Character. "two.sided", "upper", or "lower".
#' @param method Character. "t" (default) or "z".
#' @param sigma Known population standard deviation (required if method = "z").
#' @param na.rm Logical. Whether to remove NA values.
#'
#' @return A list of class "ic_pmean" with mean estimate and confidence interval.
#' @examples
#' data <- c(5, 7, 8, 6, 9, 10)
#' ic_pmean(data)
#' ic_pmean(data, conf.level = 0.99)
#' mat <- matrix(data, nrow = 2)
#' ic_pmean(mat)
#'
#' @importFrom stats sd qt qnorm
#' @export
ic_pmean <- function(
  x,
  conf.level = 0.95,
  type = c("two.sided", "upper", "lower"),
  method = c("t", "z"),
  sigma = NULL,
  na.rm = TRUE
) {

  if (!is.numeric(conf.level) || conf.level <= 0 || conf.level >= 1)
    stop("'conf.level' must be between 0 and 1.")

  type <- match.arg(type)
  method <- match.arg(method)

  if (is.data.frame(x))
    x <- as.matrix(x)

  if (is.matrix(x)) {
    res <- lapply(seq_len(ncol(x)), function(j)
      ic_pmean(x[, j], conf.level, type, method, sigma, na.rm))
    names(res) <- colnames(x)
    class(res) <- "ic_pmean_multi"
    return(res)
  }

  if (na.rm) x <- x[!is.na(x)]
  else if (anyNA(x))
    stop("Missing values present.")

  n <- length(x)
  if (n < 2) stop("At least 2 observations required.")

  xbar <- mean(x)
  alpha <- 1 - conf.level

  if (method == "z") {
    if (is.null(sigma))
      stop("Provide 'sigma' when method = 'z'.")
    crit <- stats::qnorm(1 - alpha/2)
    se <- sigma / sqrt(n)
    df <- NA
  } else {
    s <- stats::sd(x)
    crit <- stats::qt(1 - alpha/2, n - 1)
    se <- s / sqrt(n)
    df <- n - 1
  }

  error <- crit * se

  conf_int <- switch(
    type,
    two.sided = c(lower = xbar - error, upper = xbar + error),
    upper = c(upper = xbar + error),
    lower = c(lower = xbar - error)
  )

  structure(
    list(
      estimate = xbar,
      conf.int = conf_int,
      conf.level = conf.level,
      method = method,
      n = n,
      df = df
    ),
    class = "ic_pmean"
  )
}