############################################################
## Basic Probability + Simulation in R
## (d, p, q, r, ecdf, sample)
############################################################


############################################################
## 1) Density Function: d*
############################################################

# Example: Standard Normal distribution

# What is the density at x = 0?
dnorm(0)

# What is the density at x = 2?
dnorm(2)

# Important: this is NOT a probability.
# It is the height of the curve.


############################################################
## 2) Probability Function (CDF): p*
############################################################

# What is P(X <= 0)?
pnorm(0)

# What is P(X <= 2)?
pnorm(2)

# This IS a probability (a number between 0 and 1).

############################################################
## 3) Quantile Function: q*
############################################################

# What value has 50% of the area below it?
qnorm(0.50)

# What value has 95% of the area below it?
qnorm(0.95)

# Quantile answers: "What x gives this probability?"


############################################################
## 4) Random Number Generation: r*
############################################################

# Generate one random draw
rnorm(1)

# Generate 5 random draws
rnorm(5)

# What type of object do we get?
x <- rnorm(5)
x
length(x)
mean(x)


mu <- 170
sigma <- 10
sim <- rnorm(100, mean = mu, sd = sigma)

mean(sim)
sd(sim)
summary(sim)


############################################################
## 5) Empirical CDF (ecdf)
############################################################

# Generate some data
set.seed(1)
sample_data <- rnorm(20)

# Create the empirical CDF
F_hat <- ecdf(sample_data)

# What proportion of values are <= 0?
F_hat(0)

# Compare to the true probability
pnorm(0)

# Plot the ECDF
plot(F_hat, main = "Empirical CDF (n = 20)")


############################################################
## 6) Sampling from a Finite Set: sample()
############################################################

# Sample 5 numbers from 1 to 10 (without replacement)
sample(1:10, size = 5)

# Sample 5 numbers WITH replacement
sample(1:10, size = 5, replace = TRUE)

# Sample letters
sample(c("A", "B", "C"), size = 5, replace = TRUE)

############################################################
## 7) sample() row indices from a data frame
############################################################

df <- data.frame(id = 1:8, score = round(rnorm(8), 2))
df

set.seed(4279)
idx <- sample(seq_len(nrow(df)), size = 3, replace = FALSE)
df[idx, ]
