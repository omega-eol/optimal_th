# find optimal thresholds using 
# Inputs:
# pred_prob - matrix of predictin probabilities. One column per class, each row represents an instance from 
# validation/test set.
# Y - vector of ground truth
# err_val - minimum value of the objective function to be reached. If f(current) <= f(err_val) then stop.
optimal_th_sa = function(pred_prob, Y, err_val = NULL) {
     library('GenSA');
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
     
     # run optimization
     out = GenSA(par = rep(1/k, k), lower = slower, upper = supper, fn = wrapper, 
                 control = list(threshold.stop = err_val));
     return(out);
}