######################################
###### Simulation dataset ############
######################################
#t1 <- Sys.time()

Tp <- 10 
cluster <- 2
beta_seq <- mat.or.vec(cluster,Tp) 

beta_seq[1,3:5] <-1
beta_seq[2,8:9] <- -1

## Ground Truth for developing period##
## One is [2,6]; the other is [7,10]
x <- 1:Tp
plot(x, beta_seq[1,],type = 'l',lty=1, col = 'red', lwd = 2, ylim = c(-1,1), xlab = "Time point", ylab = 'Effect size',main='Ground Truth')
abline(h=0)
lines(beta_seq[2,],type = 'l',lty=1, col = 'blue', lwd = 2)

#### Generate Feature #######
p <- 100
N <- 200
set.seed(100)
time <- sample(1:10,200,replace = T)
c_num <- sample(1:2,100,replace = T)

feature <- mat.or.vec(N,p)

for(i in 1:p){
  y_t <- rep(0,Tp)
  y_t[1] <- rnorm(1)  
  for(t in 2:Tp){
    y_t[t] <- beta_seq[c_num[i],t] + y_t[t-1]
  }  
  for(j in 1:N){
    feature[j,i] <- y_t[time[j]] + rnorm(1)
  }  
}



## Estimation ##
beta_estimated <- mat.or.vec(p,Tp)

#################################
### Step 1. Sliding window ######
#################################
wd <- 1
a <- 1

for(k in 1:(Tp-2)){
  age <- a+k
  index <- which(time %in% c(age-wd,age+wd))
  t_sub <- time[index]
  feature_sub <- feature[index,]
  for(j in 1:p){
    y_j <- feature_sub[,j]
    lm_test <- lm(y_j~t_sub)
    lm.summary <- summary(lm_test)
    #lm.summary
    if(lm.summary$coefficients[2,4]<0.05){
      beta_estimated[j,age]<- lm.summary$coefficients[2,1]
    }else{
      beta_estimated[j,age] <- 0
    }
  }
}

## elbow rule for the best k####
## repete iterations ####
set.seed(100)
r <- 100
kc <- 10
wss_all <- mat.or.vec(kc,r)
wss_all[1,] <- (nrow(beta_estimated)-1)*sum(apply(beta_estimated,2,var))
for(j in 1:r){
  for (i in 2:kc){
    wss_all[i,j] <- sum(kmeans(beta_estimated,centers=i)$withinss)
  }
}

wss1 <- rowMeans(wss_all)

plot(1:kc, wss1, type="b", xlab="Number of Clusters",ylab="Within groups sum of squares")


## Numer of clusters is 2 ####

#################################
#### Apply K-means clustering ###
#################################
library(fpc)
c <-2
km.boot <- clusterboot(beta_estimated, B=100, bootmethod="boot",
                              clustermethod=kmeansCBI, count = FALSE,
                              krange=c, seed=100)
cluster_info <- km.boot$result$result

## Calculate distance to match the estimated curve with ground truth
distance <- mat.or.vec(c,cluster)
for(r1 in 1:c){
  for (r2 in 1:cluster){
    dist = sum(abs(cluster_info$centers[r1,]-beta_seq[r2,]))/Tp
    distance[r1,r2] <- dist
  }
}

similar <- data.frame(1:c, apply(distance,1,which.min),apply(distance,1,min))
colnames(similar) <- c('K_means', 'ground truth', 'min distance')

## K-means cluster center 1 match the ground truth beta_seq 2
## K-means cluster center 2 match the ground truth beta_seq 1

## Result plotting

plot(x, cluster_info$centers[1,], xlab = "Time point", ylab = 'Effect size')
lines(beta_seq[2,],type = 'l',lty=2, col = 'blue', lwd = 2)
plot(x, cluster_info$centers[2,], xlab = "Time point", ylab = 'Effect size')
lines(beta_seq[1,],type = 'l',lty=2, col = 'red', lwd = 2)

## It is expected that there is some time lag between estimated curve and ground truth
## The first non-zero beta indicate after that corresponding time point, the change begins
## When we count the developing period, we choose the first non-zero point as the start 
## In this case, for cluster 1 is [7,10], for cluster 2 is [2,6].

#par(mfcol=c(1,2))

## Check the estimated features belong to each cluster

plot(3-cluster_info$cluster, pch=8, col ='blue', main = 'Estimated group', xlab = 'Feature index',ylab = 'Matched cluster with ground truth')

plot(c_num, pch = 8, col='red', main = 'Ground truth', xlab = 'Feature index',ylab = 'Group index')

#t2 <- Sys.time()
