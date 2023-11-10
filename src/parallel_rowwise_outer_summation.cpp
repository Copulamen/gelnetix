#include <RcppArmadillo.h>
#include <RcppParallel.h>
// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::depends(RcppParallel)]]

struct RowWiseOuterProductSum : public RcppParallel::Worker {
    const arma::mat& Z;
    arma::mat& A;

    RowWiseOuterProductSum(const arma::mat& Z, arma::mat& A)
        : Z(Z), A(A) {}

    void operator()(std::size_t begin, std::size_t end) {
        for (std::size_t i = begin; i < end; ++i) {
            A += Z.row(i).t() * Z.row(i);
        }
    }
};

// [[Rcpp::export]]
arma::mat parallel_mc_loop(const arma::mat& Z, int mc_iters) {
    const int p = Z.n_cols;
    arma::mat A(p, p, arma::fill::zeros);

    RowWiseOuterProductSum product(Z, A);
    RcppParallel::parallelFor(0, mc_iters, product);

    return A;
}