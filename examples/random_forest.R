# Original: http://qiita.com/HirofumiYashima/items/f5d60b906cb6664e7f7e
library(foreach)
library(doParallel)
library(randomForest)
library(kernlab)

data(spam)
cores <- detectCores()
cl <- makeCluster(cores)
registerDoParallel(cl)

system.time(fit.rf <- foreach(ntree = rep(500, cores), .combine = combine,
                  .export = "spam", .packages = "randomForest") %dopar% {
  randomForest(type ~ ., data = spam, ntree = ntree)
})

stopCluster(cl)
