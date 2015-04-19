// [[Rcpp::depends(RcppArmadillo)]]
#define ARMA_64BIT_WORD
#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
arma::uvec findRowMax(arma::mat X) {
     // get number of rows
     int n = X.n_rows;
     
     // initialize the output vector
     arma::uvec res = arma::ones<arma::uvec>(n);
     
     // for each row
     for (int i = 0; i < n; i++) {
          arma::uword index;
          double max_value = X.row(i).max(index);
          res(i) = index+1;
     };
     
     // return result
     return(res);
};

// [[Rcpp::export]]
std::map<int, int> tabulate_rcpp(arma::uvec a, int k) {
     std::map<int, int> counts;
     
     // initialize the map
     for (int i = 1; i <= k; i++) counts[i];
     
     // compute frequency
     int n = a.size();
     for(int i = 0; i < n; i++) ++counts[a[i]];
     return(counts);
};

typedef std::map<int, int> countMap;

// [[Rcpp::export]]
double cutoffError(arma::rowvec cutoff, arma::mat pred_prob, arma::vec init_distr) {
     // normzalize cutoff vector
     cutoff = cutoff/sum(cutoff);
     
     // find number of classes
     int k = cutoff.size();
     //Rcout << "Number of classes: " << k << std::endl;
     
     // find number of records
     int n = pred_prob.n_rows;
     //Rcout << "Number of rows: " << n << std::endl;
     
     // divide probability matrix by cutoff coefficients
     arma::mat diff = pred_prob/repmat(cutoff, n, 1);
     
     // find the class distribution after appling current cutoff coefficients
     countMap counts = tabulate_rcpp(findRowMax(diff), k);
     arma::vec res = arma::zeros<arma::vec>(k);
     for (countMap::const_iterator it = counts.begin(); it != counts.end(); ++it) {
          res[it->first - 1] = it->second / (double)n;
     };
     
     // function to mimize = sum of abs error per class
     arma::vec dd = abs(res/init_distr-1);    
     double md = sum(dd)/k;
     return(md);
};
