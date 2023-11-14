source("R/calculate_em.R")

build_pheno_geno_net <- function(dataset, rho_vector, alpha_vector, max_em_iters, tol = 1e-3, verbose = FALSE) {
    num_rho <- length(rho_vector)
    estimate <- vector("list", num_rho)

    for (chain_idx in 1:num_rho) {
        if(verbose)
		{
			m <- paste(c("Reconstructing genotype-phenotype networks... : ", floor(100 * chain_idx/num_rho), "%"), collapse="")
			cat(m, "\r")
		}

        if (chain_idx == 1) {
            estimate[[chain_idx]] <- vector("list", num_rho)
            theta <- sparseMatrix(i=1:ncol(dataset), j=1:ncol(dataset), x=1)
            estimate[[chain_idx]] <- calculate_em(dataset,
                                                rho = rho[[chain_idx]],
                                                theta = theta,
                                                mc_iters = 1000,
                                                max_em_iters = max_em_iters,
                                                burn_in_samples = 100,
                                                tol = tol)
        }
        else {
            estimate[[chain_idx]] <- vector("list", num_rho)
            theta <- estimate[[(chain_idx - 1)]]$theta
            estimate[[chain_idx]] <- calculate_em(dataset,
                                            rho = rho[[chain_idx]],
                                            theta = theta,
                                            mc_iters = 1000,
                                            max_em_iters = max_em_iters,
                                            burn_in_samples = 100,
                                            tol = tol)
        }
    }

    return(estimate)
}