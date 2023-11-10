library("tmvtnorm")
library("Rcpp")

Rcpp::sourceCpp("/home/gelnetix/gelnetix/src/rowwise_outer_summation.cpp")
Rcpp::sourceCpp("/home/gelnetix/gelnetix/src/parallel_rowwise_outer_summation.cpp")

#' Estimates the...TODO.
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
estimate_cond_expectation <- function(idx, p, theta, lower, upper, mc_iters, burn_in_samples, verbose = FALSE) {
  # Z = (Z_1, ..., Z_p), where Z ~ N_p(0, \Omega)
  gaussian_latent_vars <- rtmvnorm.sparseMatrix(
    n = mc_iters,
    H = theta,
    lower = lower[idx, ],
    upper = upper[idx, ],
    burn.in.samples = burn_in_samples
  )

  running_sum <- parallel_mc_loop(gaussian_latent_vars, mc_iters)

  cond_expectation <- running_sum / mc_iters
  return(cond_expectation)
}

estimate_mean_cond_expectation <- function() {
  # TODO
}

#' Calculates cut-points of ordinal variables with respect to the Gaussian copula.
#' 
#' @param dataset An n by p matrix or a `data.frame` instance,
#' where n is the number of observations and p is the number of variables.
#' 
#' @example
#' TODO
calc_cut_points <- function(dataset) {
  p <- ncol(dataset)
  n <- nrow(dataset)
  k <- unique(sort(unlist(dataset)))
  n_levels <- length(k)
  q <- matrix(nrow = p, ncol = n_levels)
  for (i in 1:p) {
    X <- factor(dataset[, i], levels = k)
    No <- tabulate(X, nbins = n_levels)
    q[i, ] <- qnorm(cumsum(No) / n)
  }
  q[, n_levels] <- Inf
  q <- cbind(-Inf, q)
  return(q)
}

#' Calculates lower and upper bands for each data point, using a set of cut-points obtained from the Gaussian copula.
#' 
#' @param dataset An n by p matrix or a `data.frame` instance,
#' where n is the number of observations and p is the number of variables.
#' 
#' @example 
#' TODO
get_lower_upper_bands <- function(dataset) {
  cutoffs <- calc_cut_points(dataset)
  levels <- unique(sort(unlist(dataset)))
  n <- nrow(dataset)
  p <- ncol(dataset)
  lower <- matrix(nrow = n, ncol = p)
  upper <- matrix(nrow = n, ncol = p)
  for (i in 1:n) {
    sel <- match(dataset[i, ], levels)
    lower[i, ] <- apply(cbind(sel, cutoffs), 1, function(x) {
      x[x[1] + 1]
    })
    upper[i, ] <- apply(cbind(sel, cutoffs), 1, function(x) {
      x[x[1] + 2]
    })
  }
  lower[is.na(lower)] <- -Inf
  upper[is.na(upper)] <- Inf

  return(list(lower = lower, upper = upper))
}
