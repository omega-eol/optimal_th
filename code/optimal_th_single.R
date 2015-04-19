optimal_th_single = function(pred_prob, Y, randomSeed = 42) {     
     library(DEoptim);
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
     
     # where to start or border of the optimization
     slower=rep(0.01, k); supper=rep(0.99, k);
     
     # optimization itself
     set.seed(randomSeed);
     res=DEoptim(fn=cutoffError, lower=slower, upper=supper, control=DEoptim.control(VTR=0.01, 
                                                                                 itermax = 400, 
                                                                                 trace=FALSE), pred_prob, init_distr);
     return(res);          
};
