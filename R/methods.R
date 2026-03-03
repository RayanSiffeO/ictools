

#' @export
print.ic_pmean <- function(x, ...) {
  cat("\nConfidence Interval for Mean\n")
  cat("Confidence level:", x$conf.level, "\n\n")
  
  cat("Estimate:\n")
  print(x$estimate)
  
  cat("\nConfidence Interval:\n")
  print(x$conf.int)
  
  invisible(x)
}


#' @export
print.ic_var <- function(x, ...) {
  cat("\nConfidence Interval for Variance\n")
  cat("Confidence level:", x$conf.level, "\n\n")
  
  cat("Estimate:\n")
  print(x$estimate)
  
  cat("\nConfidence Interval:\n")
  print(x$conf.int)
  
  invisible(x)
}


#' @export
print.ic_prop <- function(x, ...) {
  cat("\nConfidence Interval for Proportion\n")
  cat("Confidence level:", x$conf.level, "\n\n")
  
  cat("Estimate:\n")
  print(x$estimate)
  
  cat("\nConfidence Interval:\n")
  print(x$conf.int)
  
  invisible(x)
}


#' @export
print.ic_razon_var <- function(x, ...) {
  cat("\nConfidence Interval for Variance Ratio\n")
  cat("Confidence level:", x$conf.level, "\n\n")
  
  cat("Estimate:\n")
  print(x$estimate)
  
  cat("\nConfidence Interval:\n")
  print(x$conf.int)
  
  invisible(x)
}


#' @export
print.ic_reg <- function(x, ...) {
  cat("\nConfidence Intervals for Regression Coefficients\n")
  cat("Method:", x$method, "\n")
  cat("Confidence level:", x$conf.level, "\n")
  
  if (!is.null(x$R)) {
    cat("Bootstrap replications:", x$R, "\n")
  }
  
  cat("\nCoefficients:\n")
  print(x$coefficients)
  
  cat("\nConfidence Intervals:\n")
  print(x$conf.int)
  
  invisible(x)
}




#' @export
as.data.frame.ic_pmean <- function(x, ...) {
  data.frame(
    estimate = x$estimate,
    lower = x$conf.int[1],
    upper = x$conf.int[2],
    row.names = NULL
  )
}


#' @export
as.data.frame.ic_var <- as.data.frame.ic_pmean


#' @export
as.data.frame.ic_prop <- as.data.frame.ic_pmean


#' @export
as.data.frame.ic_razon_var <- as.data.frame.ic_pmean


#' @export
as.data.frame.ic_reg <- function(x, ...) {
  data.frame(
    term = names(x$coefficients),
    estimate = unname(x$coefficients),
    lower = x$conf.int[, 1],
    upper = x$conf.int[, 2],
    row.names = NULL
  )
}