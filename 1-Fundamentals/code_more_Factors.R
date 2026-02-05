############################################################
## Credit data: lm() vs manual dummy variables + matrix algebra
############################################################

library(ISLR2)

# Interact with data
head(Credit)
str(Credit)

# Inspect Region levels 
levels(Credit$Region)

############################################################
## 1) Fit the model using lm()
############################################################

fit_lm <- lm(Balance ~ Income + Region, data = Credit)
summary(fit_lm)

str(fit_lm)
names(fit_lm)

# Save the lm coefficients
beta_lm <- coef(fit_lm)
beta_lm


############################################################
## 2) Construct the design matrix explicitly. 
##    We will use "East" as the baseline category (like lm does by default).
############################################################

contrasts(Credit$Region)

# Create dummy variables by logical indexing 
Credit$Region_South <- rep(0, nrow(Credit))
Credit$Region_West  <- rep(0, nrow(Credit))

Credit$Region_South[Credit$Region == "South"] <- 1
Credit$Region_West[Credit$Region == "West"]  <- 1

# Response vector y
y <- Credit$Balance

# Design matrix X corresponding to: (Intercept) + Income + RegionSouth + RegionWest
X <- cbind(
  "(Intercept)"  = rep(1, nrow(Credit)),
  "Income"       = Credit$Income,
  "RegionSouth"  = Credit$Region_South,
  "RegionWest"   = Credit$Region_West
)

# least square formula: beta_hat = (X'X)^(-1) X'y
beta_hat <- solve(t(X) %*% X) %*% (t(X) %*% y)

# Make it a named vector to compare easily with lm output
beta_hat <- as.vector(beta_hat)
names(beta_hat) <- colnames(X)
beta_hat


############################################################
## 3) Equivalence
############################################################

# Compare coefficient names and values side-by-side
cbind(
  beta_lm     = beta_lm,
  beta_hat = beta_hat
)

# Check they match numerically (tolerance for floating point)
all.equal(beta_lm, beta_hat, tolerance = 1e-10)

# predictions are identical
yhat_lm = fit_lm$fitted.values
yhat    = as.vector(X %*% beta_hat)
all.equal(yhat_lm, yhat, tolerance = 1e-10)

names(yhat_lm)= NULL
all.equal(yhat_lm, yhat, tolerance = 1e-10)

############################################################
############# What happens if we relevel? #################
############################################################

Credit$Region <- relevel(Credit$Region, ref = "South")
levels(Credit$Region)
