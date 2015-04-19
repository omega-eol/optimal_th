rm(list=ls());

# set working directory
setwd('~/code/optimal_th/');

# Test different variations of optimization function and parallel types with DEoptim package.
source('code/optimizeCutoff.R'); # runs in parallel type 1, objective function written in R
source('code/optimal_th_p1.R'); # runs in parallel type 1, objective function written in C++ via Rcpp package
source('code/optimal_th.R'); # runs in parallel type 2, objective function written in C++
source('code/optimal_th_single.R'); # runs on single core, obj. function in C++

# generate test data
k = 35;
n = 2000;
pred_prob = matrix(runif(k*n), n, k);
Y = round(runif(n, min=1, max=k));

# single runs
r1 = optimizeCutoff(pred_prob, Y); # Old version of the function. Runs in parallel on 8 cores/thread, parallel mode 1, OB - R function
r2 = optimal_th_p1(pred_prob, Y); # run in parallel mode 1, OB in Rcpp
r3 = optimal_th(pred_prob, Y); # run in parallel mode 2, OB in Rcpp
r4 = optimal_th_single(pred_prob, Y); # runs one core, OB ib Rcpp

# benchmarks
tests = list( r_old = expression(optimizeCutoff(pred_prob, Y)),
              rcpp_p1 = expression(optimal_th_p1(pred_prob, Y)),
              rcpp_p2 = expression(optimal_th(pred_prob, Y)),
              rcpp_single = expression(optimal_th_single(pred_prob, Y)) );
# run the test
do.call(benchmark, c(tests, list(replications=10,
                                 order='elapsed')));

# results
#          test replications  elapsed relative user.self sys.self user.child sys.child
# 3     rcpp_p2           10  434.553    1.000    27.822   55.202   1131.429    95.231
# 4 rcpp_single           10  814.049    1.873   810.801    3.402      0.000     0.000
# 2     rcpp_p1           10  853.662    1.964    58.384   18.046      0.084     0.079
# 1       r_old           10 5030.905   11.577    71.327   25.843      0.088     0.092

