# do benchmarks
rm(list=ls());

# set working directory (this might be different depending wher you are running the script)
setwd('~/code/optimal_th/');

# load function relative to your working directory
source('code/cutoffError_r.R'); # impelematation in R
Rcpp::sourceCpp('code/cutoffError.cpp'); # impelentation in Rcpp

# load benchmark library
library('rbenchmark');

# B1
k = 30; # number of classes
n = 10000; # number of points

cutoff = runif(k);
init_distr = runif(k);
init_distr = init_distr/sum(init_distr);
pred_prob = matrix(runif(k*n), n, k);

# run the test
tests = list(r=expression(cutoffError_r(cutoff, pred_prob, init_distr)),
             rcpp=expression(cutoffError(cutoff, pred_prob, init_distr)));
do.call(benchmark, c(tests, list(replications=1000, order='elapsed')));

# result
# test replications elapsed relative user.self sys.self user.child sys.child
# 2 rcpp         1000   2.735    1.000     2.042    0.694          0         0
# 1    r         1000  38.195   13.965    36.493    1.708          0         0

# Rcpp impelementation is 14x faster (over 1000 executions) than in R