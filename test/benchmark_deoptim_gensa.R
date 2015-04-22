# Test GA versus simulated annealing
rm(list=ls());

# set working directory
setwd('~/code/optimal_th/');

# load functions
source('code/optimal_th_sa.R');
source('code/optimal_th.R');

# generate test data
k = 20;
n = 1000;
pred_prob = matrix(runif(k*n), n, k);
Y = round(runif(n, min=1, max=k));
hist_attr = hist(Y, breaks=0:k, plot=FALSE); 
init_distr = hist_attr$density;

# single run using DEoptim package
rtm = proc.time();
ga_res = optimal_th(pred_prob, Y, err_val = 0.05, max_iterations = 5000);
print(proc.time()-rtm);
# plot progres, pring other metrics
plot(ga_res$member$bestvalit)
ga_res$optim$iter
ga_res$optim$bestval
ga_res$optim$bestmem

# single run usgin GenSA package
rtm = proc.time();
sa_res = optimal_th_sa(pred_prob, Y, err_val = 0.05);
print(proc.time()-rtm);
# plot the progress
plot(sa_res$trace.mat[,3])
sa_res$value
sa_res$counts
sa_res$par

# benchmarks
tests = list( rcpp_deoptim = expression(optimal_th(pred_prob, Y, err_val = 0.05, max_iterations = 5000)),
              rcpp_gensa = expression(gensa_test(pred_prob, Y, err_val = 0.05)) );
# run the test
do.call(benchmark, c(tests, list(replications=10,
                                 order='elapsed')));
# results
# test replications  elapsed relative user.self sys.self user.child sys.child
# 2   rcpp_gensa           10   37.216    1.000    36.674    0.545      0.000     0.000
# 1 rcpp_deoptim           10 1306.828   35.115   212.161  477.487   1255.391   628.179

