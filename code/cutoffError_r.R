cutoffError_r = function(cutoff, pred_prob, init_distr) {
     # find number of points
     n = nrow(pred_prob);
     
     # find number of classes
     k = length(cutoff);
     
     # normalization
     cutoff = cutoff/sum(cutoff);
     diff = pred_prob/t(replicate(n, cutoff));
     
     # for each sample find the winner!
     res = rep(0, k);
     for (i in 1:n) {       
          ind = which.max(diff[i,]);
          res[ind] = res[ind] + 1;    
     }
     res=res/n;    
     
     # function to mimize
     dd = abs((init_distr-res)/init_distr);    
     md = sum(dd)/k;          
     return(md);
};