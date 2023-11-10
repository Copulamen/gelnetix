#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]

// [[Rcpp::export]]
arma::mat mc_loop(const arma::mat& Z, int mc_iters) {
    int p = Z.n_cols;
    arma::mat A(p, p, arma::fill::zeros);
    
    for (size_t i=0; i < mc_iters; i++) {
        A += Z.row(i).t() * Z.row(i);
    }
    return A;
}
