source("R/estimate_mean_cond_expectation.R")

library("glasso")

calculate_em <- function(dataset, rho, theta, mc_iters, max_em_iters, burn_in_samples, tol = 1e-3, start_em_iter = 1, verbose = FALSE) {
    p <- ncol(dataset)
    n <- nrow(dataset)

    current_em_iter <- start_em_iter
    delta <- 100
    while (current_em_iter <= max_em_iters && delta >= tol) {
        if (verbose) {
            cat("EM iteration: ", current_em_iter, " / ", max_em_iters, "\n")
        }
        mean_cond_exp <- estimate_mean_cond_expectation(
            dataset = dataset,
            theta = theta,
            mc_iters = mc_iters,
            burn_in_samples = burn_in_samples,
            verbose = verbose
        )
        # TODO: replace glasso with gelnet
        mean_cond_exp_glasso <- glasso(
            s = mean_cond_exp,
            rho = rho,
            maxit = 1000,
            penalize.diagonal = FALSE
        )
        if (det(mean_cond_exp_glasso$w) <= 0) {
            mean_cond_exp_glasso$w <- nearPD(mean_cond_exp_glasso$w, keepDiag = TRUE)$mat
        }
        delta <- sum(abs(theta - mean_cond_exp_glasso$wi) / p^2)
        theta <- as(mean_cond_exp_glasso$wi, "dgTMatrix")
        theta <- as(theta, "sparseMatrix")
        current_em_iter <- current_em_iter + 1
    }

    results <- list()
    results$theta <- Matrix(theta, sparse = TRUE)
    results$sigma <- Matrix(mean_cond_exp_glasso$w, sparse = TRUE)
    results$mean_cond_exp <- Matrix(mean_cond_exp, sparse = TRUE)
    results$Z <- NULL
    results$rho <- rho
    results$loglikelihood <- n/2 * (determinant(results$theta, logarithm = TRUE)$modulus - sum(diag(results$mean_cond_exp %*% results$theta)))

    return(results)
}