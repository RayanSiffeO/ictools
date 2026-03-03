#' Confidence Intervals for Regression Coefficients
#'
#' Computes confidence intervals for the coefficients of a linear model (lm).
#'
#' @param model An object of class \code{lm}.
#' @param conf.level Confidence level (defaults to 0.95).
#'
#' @param method Método para calcular el intervalo: "classical", "bootstrap" o "residual".
#' @param R Número de réplicas bootstrap (solo para métodos bootstrap/residual).
#' 
#' @return An object of class \code{ic_reg} containing the estimate and the 
#' confidence interval.
#' 
#' @examples
#' # Create sample data
#' test_data <- data.frame(
#'   y = c(5, 6, 7, 8, 9, 10),
#'   x1 = c(1, 2, 3, 4, 5, 6),
#'   x2 = c(2, 1, 3, 2, 4, 5)
#' )
#' 
#' # Fit model and calculate CI
#' fit <- lm(y ~ x1 + x2, data = test_data)
#' ic_reg(fit)
#'
#' @importFrom stats lm coef qt
#' @export

ic_reg <- function(
  model,
  conf.level = 0.95,
  method = c("classical", "bootstrap", "residual"),
  R = 2000
) {

  if (!inherits(model, "lm"))
    stop("'model' must be an lm object.")

  method <- match.arg(method)
  alpha <- 1 - conf.level
  coef_hat <- coef(model)
  k <- length(coef_hat)

  if (method == "classical") {
    res <- summary(model)
    se <- coef(res)[,2]
    df <- res$df[2]
    crit <- stats::qt(1 - alpha/2, df)
    lower <- coef_hat - crit*se
    upper <- coef_hat + crit*se
    ci <- cbind(lower, upper)
  }

  if (method == "bootstrap") {
    dfdata <- model$model
    boot <- replicate(R, {
      idx <- sample(nrow(dfdata), replace=TRUE)
      coef(lm(formula(model), dfdata[idx,]))
    })
    ci <- t(apply(boot, 1,
                  stats::quantile,
                  probs=c(alpha/2,1-alpha/2)))
  }

  if (method == "residual") {
    yhat <- fitted(model)
    resids <- resid(model)
    dfdata <- model$model
    resp <- names(dfdata)[1]

    boot <- replicate(R, {
      ystar <- yhat + sample(resids, replace=TRUE)
      dfstar <- dfdata
      dfstar[[resp]] <- ystar
      coef(lm(formula(model), dfstar))
    })
    ci <- t(apply(boot, 1,
                  stats::quantile,
                  probs=c(alpha/2,1-alpha/2)))
  }

  structure(
    list(
      estimate = coef_hat,
      conf.int = ci,
      conf.level = conf.level,
      method = method,
      n = nrow(model$model)
    ),
    class = "ic_reg"
  )
}