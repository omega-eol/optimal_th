## Description
When you are faced working with a multi-class classification problem, often, you ended up building a binary classifier (SVM for example) for each class (1 vs all). Choosing the right classification threshold for each classifier depends on many factors and your goal. If your goal is to make sure that distribution of your prediction is as close as possible to the ground truth, then the following code might be useful to you.

It might be also helpful if you are new to R, Rcpp, and RcppArmadillo packages, and overall optimization field.

## Code

### Optimization Functions
1. `code/optimizeCutoff.R` DEoptim package (with parallel type = 1) and R implementation of the objective function
2. `code/optimal_th_p1.R` DEoptim package (with parallel type = 1) and Rcpp implementation of the objective function
3. `code/optimal_th.R` DEoptim package (with parallel type = 2) and Rcpp implementation of the objective function
4. `code/optimal_th_single.R` DEoptim package (single core) and Rcpp implementation of the objective function
5. `code/optimal_th_sa.R` GenSA package (single core) and Rcpp implementation of the objective function

### Objective Functions
1. `code/cutoffError_r.R` R implementation of the objective function
2. `code/cutoffError.cpp` Rcpp implementation of the objective function
  * `tabulate_rcpp` analog of R tabulate function
  * `findRowMax` finds index of the maximum value in each row of a matrix

### Benchmarks
1. `test/benchmark_objective_function.R` comparison of R (`code/cutoffError_r.R`) and Rcpp (`code/cutoffError.cpp`) implementations of the objective function. Rcpp implementation performs 14x faster (over 1k replications) than implementation in R.
2. `test/benchmark_deoptim.R` test different variations of optimization function and parallel types with DEoptim package.
3. `test/benchmark_deoptim_gensa.R` compare computation speed of DEoptim and GenSA packages.

## References
1. [DEoptim](http://cran.r-project.org/web/packages/DEoptim/DEoptim.pdf): Global Optimization by Differential Evolution package.  by David Ardia, Katharine Mullen, Brian Peterson, Joshua Ulrich, and Kris Boudt
2. [GenSA](http://cran.r-project.org/web/packages/GenSA/GenSA.pdf): Functions for Generalized Simulated Annealing package by Sylvain Gubian, Yang Xiang, Brian Suomela, Julia Hoeng, PMP SA.