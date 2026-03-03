#' Confidence Interval for the Variance
#'
#' Computes confidence intervals for a population variance.
#'
#' @param x Numeric vector or matrix.
#' @param conf.level Confidence level (default 0.95).
#' @param type Character. "two.sided", "upper", or "lower".
#' @param na.rm Logical. Whether to remove NA values.
#'
#' @return A list of class "ic_var" with variance estimate and confidence interval.
#' @examples
#' data <- matrix(c(5, 7, 8, 6, 9, 10), nrow = 2)
#' ic_var(data)
#' ic_var(data, conf.level = 0.99)
#'
#' @importFrom stats var qchisq
#' @export
ic_var <- function(
  x,
  conf.level = 0.95,
  type = c("two.sided", "upper", "lower"),
  na.rm = TRUE
) {

  if (!is.numeric(conf.level) || conf.level <= 0 || conf.level >= 1)
    stop("'conf.level' must be between 0 and 1.")

  type <- match.arg(type)

  if (is.data.frame(x))
    x <- as.matrix(x)

  if (is.matrix(x)) {
    res <- lapply(seq_len(ncol(x)), function(j)
    ic_var(x[, j], conf.level = conf.level, type = type, na.rm = na.rm))
    names(res) <- colnames(x)
    class(res) <- "ic_var_multi"
    return(res)
  }

  if (!is.numeric(x))
    stop("'x' must be numeric.")

  if (na.rm) x <- x[!is.na(x)]
  else if (anyNA(x))
    stop("Missing values present. Use na.rm = TRUE.")

  n <- length(x)
  if (n < 2) stop("At least 2 observations required.")

  s2 <- stats::var(x)
  df <- n - 1
  alpha <- 1 - conf.level

  conf_int <- switch(
    type,
    two.sided = c(
      lower = df * s2 / stats::qchisq(1 - alpha/2, df),
      upper = df * s2 / stats::qchisq(alpha/2, df)
    ),
    upper = c(
      upper = df * s2 / stats::qchisq(alpha, df)
    ),
    lower = c(
      lower = df * s2 / stats::qchisq(1 - alpha, df)
    )
  )

  structure(
    list(
      estimate = s2,
      conf.int = conf_int,
      conf_level = conf.level,
      method = "chi-square",
      n = n,
      df = df
    ),
    class = "ic_var"
  )
}