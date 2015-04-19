optimal_th = function(pred_prob, Y, max_iterations = 400, err_val = 0.01, randomSeed = 42) {     
     library(DEoptim);
     library(doMC);
     registerDoMC();
     Rcpp::sourceCpp('~/code/optimal_th/code/cutoffError.cpp');
     
     # find number of classes and number of samples
     k = nlevels(factor(Y));
     if (ncol(pred_prob)!=k) {
          warning('optimizeCutoff: different number of classes')
          return(NULL);
     };
     
     n = nrow(pred_prob);
     if (n != length(Y)) stop("Number of samples does not match!");
     
     # getting initial distribution
     hist_attr = hist(Y, breaks=0:k, plot=FALSE);
     init_distr = hist_attr$density;  
     
     # define objective function
     wrapper = function(cutoff) {
          return(cutoffError(cutoff, pred_prob, init_distr));
     };
     
     # where to start or border of the optimization
     slower=rep(0.01, k); supper=rep(0.99, k);
     
     # optimization itself
     set.seed(randomSeed);
     res=DEoptim(fn=wrapper, lower=slower, upper=supper, control=DEoptim.control(VTR = err_val, 
                                                                                 itermax = max_iterations,
                                                                                 NP = round(k*10),
                                                                                 trace=FALSE, 
                                                                                 parallelType=2)
     );
     return(res);          
};
