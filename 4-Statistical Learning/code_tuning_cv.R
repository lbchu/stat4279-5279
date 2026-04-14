library(ISLR2)
dat <- na.omit(Auto[, c("mpg", "horsepower")])
n <- nrow(dat)

## plot data 
plot(dat$horsepower, dat$mpg,
     pch = 19,
     col = "gray40",
     xlab = "horsepower",
     ylab = "mpg",
     main = "Auto data: mpg vs horsepower")

## 5-fold cross-validation 
cv_poly_mse <- function(degree, dat, K = 5) {
  n <- nrow(dat)
  fold_id <- sample(rep(1:K, length.out = n))
  mse_fold <- numeric(K)
  
  for (k in 1:K) {
    train_dat <- dat[fold_id != k, ]
    valid_dat <- dat[fold_id == k, ]
    
    fit_k <- lm(mpg ~ poly(horsepower, degree), data = train_dat)
    pred_k <- predict(fit_k, newdata = valid_dat)
    
    mse_fold[k] <- mean((valid_dat$mpg - pred_k)^2)
  }
  
  return(mean(mse_fold))
}

### implement on actual data set
set.seed(2026)

deg_grid <- 1:10
cv_mse <- numeric(length(deg_grid))

for (j in seq_along(deg_grid)) {
  cv_mse[j] <- cv_poly_mse(deg_grid[j], dat, K = 5)
}

plot(deg_grid, cv_mse,
     type = "b",
     pch = 19,
     xlab = "polynomial degree",
     ylab = "5-fold CV MSE",
     main = "CV MSE versus degree")

## which degree should we choose? any concerns? 
