#' Estimates the conditional expectation of the mean of a multivariate normal distribution.
#' 
#' @param idx The index of the variable whose conditional expectation is to be estimated.
#' @param n The number of observations.
#' @param p The number of variables.
#' @param theta The precision matrix. Defaults to a diagonal matrix.
#' @param lower Vector of lower truncation points.
#' @param upper Vector of upper truncation points.
#' @param mc_iters The number of Monte Carlo iterations for estimating the conditional expectation. Defaults to 1000.
#' @param burn_in_samples The number of burn-in samples for the Gibbs sampler. Defaults to 1000.
#' @param verbose Whether to print progress messages. Defaults to FALSE.
#' 
#' @examples
#' ...TODO
estimate_cond_expectation <- function(idx, n, p, theta, lower, upper, mc_iters, burn_in_samples, verbose = FALSE) {
  # Z = (Z_1, ..., Z_p), where Z ~ N_p(0, \Omega)
  gaussian_latent_vars <- rtmvnorm.sparseMatrix(
    n = mc_iters,
    H = theta,
    lower = lower[idx, ],
    upper = upper[idx, ],
    burn.in.samples = burn_in_samples,
    algorithm = "gibbs",
  )

  # FIXME: We can vectorize this by using apply() or something.
  # See https://stackoverflow.com/questions/58242399/how-to-perform-dot-product-on-each-row-of-a-data-table
  sum <- 0
  for (i in 1:mc_iters) {
    sum <- sum + (gaussian_latent_vars[i, ] %*% t(gaussian_latent_vars[i, ]))
  }

  cond_expectation <- sum / mc_iters
  return(cond_expectation)
}

estimate_mean_cond_expectation <- function() {
  # TODO
}
