optimizeCutoff = function(pred_prob, Y) {     
     library(DEoptim);
     library(parallel);
     
     # find number of classes and number of samples
     k = length(levels(factor(Y)));
     if (ncol(pred_prob)!=k) {
          warning('optimizeCutoff: different number of classes')
          return(NULL);
     }
     n = length(pred_prob[,1]);
     if (n != length(Y)) stop("Number of samples does not match!");
          
     #getting training classes distributions 
     hist_attr = hist(as.numeric(factor(Y)), breaks=0:k, plot=FALSE);
     init_distr = hist_attr$density;  
     
     #setup random generator seed
     set.seed(42);     
     m_distr<-function(cutoff) { 
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
     
     # where to start or border of the optimization
     slower=rep(0.01, k);
     supper=rep(0.99, k);
     
     # optimization itself
     res<-DEoptim(fn=m_distr, lower=slower, upper=supper, DEoptim.control(VTR=0.01, itermax = 400, trace=FALSE, parallelType=1)); 
     return(res);          
}
