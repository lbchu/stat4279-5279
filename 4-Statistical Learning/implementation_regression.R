

# Response: Salary
# Predictors: everything else
Hitters2 = na.omit(Hitters)
xy <- make_xy(Salary ~ ., data = Hitters2)
X <- xy$X
y <- xy$y

# Train/test split
set.seed(2026)
n <- nrow(X)
test_id <- sample(1:n, size = round(n / 2))
train_id <- setdiff(1:n, test_id)

X_train <- X[train_id, , drop = FALSE]
y_train <- y[train_id]
X_test  <- X[test_id, , drop = FALSE]
y_test  <- y[test_id]

# Use the same folds for ridge and lasso
fold_id <- make_folds(nrow(X_train), K = 5, seed = 2026)

# Let glmnet suggest a reasonable lambda grid on the training data
ridge_grid <- glmnet(X_train, y_train, alpha = 0)$lambda

# base R CV
ridge_cv <- cv_glmnet_base(
  X = X_train,
  y = y_train,
  alpha = 0,
  lambda_grid = ridge_grid,
  fold_id = fold_id
)

ridge_cv$lambda_min
plot_cv_curve(ridge_cv, main = "Ridge: manual 5-fold CV")

# Refit on the full training set using the same lambda grid
ridge_fit <- glmnet(
  X_train, y_train,
  alpha = 0,
  lambda = ridge_grid
)

plot_coef_paths(ridge_fit, main = "Ridge coefficient paths")

# Test-set prediction at lambda.min
ridge_pred <- as.numeric(
  predict(ridge_fit, newx = X_test, s = ridge_cv$lambda_min)
)

ridge_mse <- mse(y_test, ridge_pred)
ridge_mse

###### LASSO #######

lasso_grid <- glmnet(X_train, y_train, alpha = 1)$lambda

lasso_cv <- cv_glmnet_base(
  X = X_train,
  y = y_train,
  alpha = 1,
  lambda_grid = lasso_grid,
  fold_id = fold_id
)

lasso_cv$lambda_min
plot_cv_curve(lasso_cv, main = "Lasso: manual 5-fold CV")

lasso_fit <- glmnet(
  X_train, y_train,
  alpha = 1,
  lambda = lasso_grid
)

plot_coef_paths(lasso_fit, main = "Lasso coefficient paths")

lasso_pred <- as.numeric(
  predict(lasso_fit, newx = X_test, s = lasso_cv$lambda_min)
)

lasso_mse <- mse(y_test, lasso_pred)
lasso_mse

#### COMPARE RESULTS ######
results <- data.frame(
  method = c("Ridge", "Lasso"),
  lambda_min = c(ridge_cv$lambda_min, lasso_cv$lambda_min),
  test_mse = c(ridge_mse, lasso_mse)
)

results


### check coefficients 
coef(lasso_fit, s = lasso_cv$lambda_min)
coef(ridge_fit, s = ridge_cv$lambda_min)

