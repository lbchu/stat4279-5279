
## The Problem: You are given a discrete probability mass function (PMF)
## for a vehicle sensor that detects objects. 
## The sensor has four states of confidence:
## 1 = Low (10%)
## 2 = Medium (40%)
## 3 = High (20%)
## 4 = Certain (30%)
## Coding Task: Write an R function to generate 
## 10,000 samples from this distribution using only 
# runif() as your source of randomness.

### Inverse Transform Method

#1. 
u = runif(10000,0,1)

##
#F(1) = P(X <= 1) = 0.1
#F(2) = P(X <=2) = 0.1 + 0.4 = 0.5
#F(3) = P(X <= 3) = 0.5+ 0.2 = 0.7
#F(4) = 1

inverse_CDF = function(x){
  if(x <= 0.1){
    return(1)
  }else if(x <=0.5){
    return(2)
  }else if(x<=0.7){
    return(3)
  }else{
    return(4)
  }
}

data = sapply(u,inverse_CDF)

data = numeric(10000)
for(i in 1:10000){
  data[i] = inverse_CDF(u[i])
}

table(data)
