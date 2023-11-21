library("microbenchmark")
source("R/estimate_mean_cond_expectation.R")

r_mc_loop <- function(Z, mc_iters) {
  p <- ncol(Z)
  total <- matrix(0, p, p)
  for (i in 1:mc_iters) {
    total <- total + Z[1, ] %*% t(Z[1, ])
  }
  return(total)
}

load("data/CviCol.RData")
idx <- 1
p <- ncol(CviCol)
theta <- sparseMatrix(i=1:p, j=1:p, x=1)
lu <- get_lower_upper_bands(CviCol)
mc_iters <- 10000
burn_in_samples <- 100
Z <- rtmvnorm.sparseMatrix(
  n = mc_iters,
  H = theta,
  lower = lu$lower[idx, ],
  upper = lu$upper[idx, ],
  burn.in.samples = burn_in_samples
)
results <- microbenchmark(
  R = r_mc_loop(Z, mc_iters),
  Rcpp = mc_loop(Z, mc_iters),
  RcppParallel = parallel_mc_loop(Z, mc_iters)
)
print(summary(results)[, c(1:7)], digits = 1)
