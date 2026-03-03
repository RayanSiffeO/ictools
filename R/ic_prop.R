#' Confidence Interval for a Proportion
#'
#' Computes confidence intervals for a population proportion.
#'
#' @param x Numeric vector (0/1) or matrix of 0/1.
#' @param conf.level Confidence level (default 0.95).
#' @param success Value considered a success (default 1, "yes", "true").
#' @param method Character. "wilson", "wald", or "clopper".
#' @param na.rm Logical. Whether to remove NA values.
#'
#' @return A list of class "ic_proportion" with proportion estimate and confidence interval.
#' @examples
#' data <- matrix(c(1, 0, 1, 1, 0, 1), nrow = 2)
#' ic_prop(data)
#' ic_prop(data, conf.level = 0.99)
#'
#' @importFrom stats qnorm
#' @export
ic_prop <- function(
  x,
  conf.level = 0.95,
  success = c(1, "yes", "true"),
  method = c("wilson", "wald", "clopper"),
  na.rm = TRUE
) {

  if (!is.numeric(conf.level) || conf.level <= 0 || conf.level >= 1)
    stop("'conf.level' must be between 0 and 1.")

  method <- match.arg(method)

  if (is.data.frame(x))
    x <- as.matrix(x)

  if (is.matrix(x)) {
    res <- lapply(seq_len(ncol(x)), function(j)
      ic_prop(x[, j], conf.level, success, method, na.rm))
    names(res) <- colnames(x)
    class(res) <- "ic_prop_multi"
    return(res)
  }

  if (na.rm) x <- x[!is.na(x)]
  else if (anyNA(x))
    stop("Missing values present.")

  n <- length(x)
  if (n < 1) stop("Empty vector.")

  k <- sum(x %in% success)
  p <- k / n
  alpha <- 1 - conf.level
  z <- stats::qnorm(1 - alpha/2)

  ci <- switch(
    method,
    wald = {
      se <- sqrt(p * (1 - p) / n)
      c(max(0, p - z*se), min(1, p + z*se))
    },
    wilson = {
      denom <- 1 + z^2/n
      center <- (p + z^2/(2*n)) / denom
      hw <- z*sqrt(p*(1-p)/n + z^2/(4*n^2)) / denom
      c(max(0, center - hw), min(1, center + hw))
    },
    clopper = {
      lower <- if (k == 0) 0 else stats::qbeta(alpha/2, k, n-k+1)
      upper <- if (k == n) 1 else stats::qbeta(1-alpha/2, k+1, n-k)
      c(lower, upper)
    }
  )

  structure(
    list(
      estimate = p,
      conf.int = ci,
      conf.level = conf.level,
      method = method,
      n = n,
      k = k
    ),
    class = "ic_prop"
  )
}