##############################################
#### Sampling Distribution of a statistic ####
##############################################
set.seed(123)

# Settings
n1 <- 20
n2 <- 20
B  <- 5000

# Store simulated statistics
T_vals <- numeric(B)

# Repeated sampling from two populations
for (b in 1:B) {
  x1 <- rnorm(n1, mean = 5, sd = 2)
  x2 <- rnorm(n2, mean = 4, sd = 2)
  
  T_vals[b] <- mean(x1) - mean(x2)
}

# Plot the sampling distribution
hist(T_vals,
     main = "Sampling Distribution of T = xbar1 - xbar2",
     xlab = "Difference in sample means",
     col = "lightgray",
     border = "white")

abline(v = mean(T_vals), lwd = 2, lty = 2)

# Numerical summary
mean(T_vals)
sd(T_vals)
summary(T_vals)
##################################################################
### Alternative: make this more reproducible using a function: ### 
##################################################################

# Function: simulate one value of the statistic T = xbar1 - xbar2
sim_diff_means <- function(n1, n2, mu1 = 5, mu2 = 4, sigma1 = 2, sigma2 = 2) {
  x1 <- rnorm(n1, mean = mu1, sd = sigma1)
  x2 <- rnorm(n2, mean = mu2, sd = sigma2)
  
  T <- mean(x1) - mean(x2)
  return(T)
}

# Settings
n1 <- 20
n2 <- 20
B  <- 5000

# Store simulated statistics
T_vals <- numeric(B)

# Repeatedly call the function
for (b in 1:B) {
  T_vals[b] <- sim_diff_means(n1, n2)
}


#########################################
#### Monte carlo simulation under H0 ####
#########################################
set.seed(123)

# Observed data
group1 <- c(7.2, 5.4, 6.1, 4.8, 5.9, 6.5, 5.7, 6.8, 5.2, 6.0)
group2 <- c(4.9, 5.1, 4.3, 5.0, 4.7, 5.4, 4.8, 5.2, 4.6, 5.1)

# Observed test statistic
T_obs <- mean(group1) - mean(group2)
T_obs

# Null model: both groups come from N(5, 1^2)
mu0 <- 5
sigma0 <- 1
n1 <- length(group1)
n2 <- length(group2)
B  <- 5000

T_null <- numeric(B)

for (b in 1:B) {
  x1 <- rnorm(n1, mean = mu0, sd = sigma0)
  x2 <- rnorm(n2, mean = mu0, sd = sigma0)
  
  T_null[b] <- mean(x1) - mean(x2)
}

hist(T_null,
     main = "Monte Carlo Null Distribution of T",
     xlab = "T under H0",
     col = "lightgray",
     border = "white")

abline(v = T_obs, lwd = 2, lty = 2)

# Two-sided Monte Carlo p-value
p_mc <- mean(abs(T_null) >= abs(T_obs))
p_mc

###################
### Permutation ###
###################
## What if we do not know that the data comes from 
## a normal distribution? 

## How can we obtain the null distribution and compute the p-value? 

group1 <- c(7.2, 5.4, 6.1, 4.8, 5.9, 6.5, 5.7, 6.8, 5.2, 6.0)
group2 <- c(4.9, 5.1, 4.3, 5.0, 4.7, 5.4, 4.8, 5.2, 4.6, 5.1)

# Combine data into one vector
x <- c(group1, group2)

# Original labels
group <- c(rep("A", length(group1)), rep("B", length(group2)))

# Observed test statistic
T_obs <- mean(x[group == "A"]) - mean(x[group == "B"])
T_obs

# Permutation test
B <- 5000
T_perm <- numeric(B)

for (b in 1:B) {
  perm_group <- sample(group)   # shuffle the labels
  T_perm[b] <- mean(x[perm_group == "A"]) - mean(x[perm_group == "B"])
}

hist(T_perm,
     main = "Permutation Distribution of T",
     xlab = "T after permuting labels",
     col = "lightgray",
     border = "white")
abline(v = T_obs, lwd = 2, lty = 2)

# Two-sided permutation p-value
p_perm <- mean(abs(T_perm) >= abs(T_obs))
p_perm
