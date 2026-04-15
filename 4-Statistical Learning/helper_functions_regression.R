library(glmnet)
library(ISLR2)

# Build X and y from a formula
make_xy <- function(formula, data) {
  mf <- model.frame(formula, data = data)
  X <- model.matrix(formula, data = mf)[, -1, drop = FALSE]  # remove intercept
  y <- model.response(mf)
  list(X = X, y = y)
}

# Create K folds
make_folds <- function(n, K = 5, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)
  sample(rep(seq_len(K), length.out = n))
}

# Mean squared error
mse <- function(y, yhat) {
  mean((y - yhat)^2)
}

# K-fold CV for glmnet
# alpha = 0 -> ridge
# alpha = 1 -> lasso
cv_glmnet_base <- function(X, y, alpha, lambda_grid, fold_id,
                             standardize = TRUE) {
  
  K <- length(unique(fold_id))
  n_lambda <- length(lambda_grid)
  
  cv_err <- matrix(NA_real_, nrow = K, ncol = n_lambda)
  
  for (k in seq_len(K)) {
    train_idx <- which(fold_id != k)
    val_idx   <- which(fold_id == k)
    
    fit_k <- glmnet(
      x = X[train_idx, , drop = FALSE],
      y = y[train_idx],
      alpha = alpha,
      lambda = lambda_grid,
      standardize = standardize
    )
    
    pred_k <- as.matrix(
      predict(
        fit_k,
        newx = X[val_idx, , drop = FALSE],
        s = lambda_grid
      )
    )
    
    for (j in seq_along(lambda_grid)) {
      cv_err[k, j] <- mse(y[val_idx], pred_k[, j])
    }
  }
  
  cv_mean <- colMeans(cv_err)
  lambda_min <- lambda_grid[which.min(cv_mean)]
  
  list(
    lambda_grid = lambda_grid,
    cv_err = cv_err,
    cv_mean = cv_mean,
    lambda_min = lambda_min
  )
}

# Plot CV error against lambda
plot_cv_curve <- function(cv_obj, main = "CV curve") {
  plot(log(cv_obj$lambda_grid), cv_obj$cv_mean,
       type = "b", pch = 19,
       xlab = "log(lambda)",
       ylab = "CV MSE",
       main = main)
  
  abline(v = log(cv_obj$lambda_min), lty = 2)
}

# Plot coefficient paths from a fitted glmnet object
plot_coef_paths <- function(fit, main = "Coefficient paths") {
  beta_mat <- as.matrix(fit$beta)   # excludes intercept
  
  matplot(log(fit$lambda), t(beta_mat),
          type = "l", lty = 1,
          xlab = "log(lambda)",
          ylab = "Coefficient",
          main = main)
  
  abline(h = 0, lty = 3)
}