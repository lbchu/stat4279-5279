### training and test split

library(ISLR2)
library(class)

data(Default)

dat <- Default[, c("default", "balance", "income")]

y <- dat$default
x <- as.matrix(dat[, c("balance", "income")])

set.seed(1)
n <- nrow(dat)
train_id <- sample(seq_len(n), size = round(n / 2))
test_id <- setdiff(seq_len(n), train_id)

### fit a logistic regression model 

log_fit <- glm(default ~ balance + income,
               data = dat,
               subset = train_id,
               family = binomial)

# predicted probability on the original probability scale
log_prob <- predict(log_fit,
                    newdata = dat[test_id, ],
                    type = "response")

head(log_prob)
range(log_prob)


#### set your threshold 

log_class <- ifelse(log_prob > 0.5, "Yes", "No")
log_class <- factor(log_class, levels = levels(y))

table(predicted = log_class,
      truth = y[test_id])

mean(log_class != y[test_id])

#### extract counts from a confusion matrix

tab_log <- table(predicted = log_class,
                 truth = y[test_id])

TP <- tab_log["Yes", "Yes"]
FP <- tab_log["Yes", "No"]
TN <- tab_log["No", "No"]
FN <- tab_log["No", "Yes"]

c(TP = TP, FP = FP, TN = TN, FN = FN)

### compute TPR and FPR

TPR <- TP / (TP + FN)
FPR <- FP / (FP + TN)
ACC <- (TP + TN) / sum(tab_log)

c(TPR = TPR, FPR = FPR, Accuracy = ACC)


### compute test misclassification error 

log_test_error <- mean(log_class != y[test_id])


#### compare several choices of threshold 

thresholds <- c(0.2, 0.5, 0.8)
results_thresh <- matrix(NA, nrow = length(thresholds), ncol = 4)
colnames(results_thresh) <- c("TPR", "FPR", "Accuracy", "Predicted_Yes")

for (i in seq_along(thresholds)) {
  th <- thresholds[i]
  pred_i <- factor(ifelse(log_prob > th, "Yes", "No"),
                   levels = levels(y))
  
  TP_i <- sum(pred_i == "Yes" & y[test_id] == "Yes")
  FP_i <- sum(pred_i == "Yes" & y[test_id] == "No")
  TN_i <- sum(pred_i == "No"  & y[test_id] == "No")
  FN_i <- sum(pred_i == "No"  & y[test_id] == "Yes")
  
  results_thresh[i, ] <- c(TP_i / (TP_i + FN_i),
                           FP_i / (FP_i + TN_i),
                           mean(pred_i == y[test_id]),
                           sum(pred_i == "Yes"))
}

round(cbind(threshold = thresholds, results_thresh), 3)


### Is the model well-calibrated? 

y_test_num <- as.numeric(y[test_id] == "Yes")

ord <- order(log_prob)
bin_id <- rep(1:5, length.out = length(log_prob))
bin <- numeric(length(log_prob))
bin[ord] <- bin_id

calib_tab <- aggregate(cbind(pred_prob = log_prob,
                             obs_rate = y_test_num),
                       by = list(bin = bin),
                       FUN = mean)

calib_tab

## If the model is reasonably calibrated, `pred_prob` and `obs_rate` should be fairly close within each bin.

#### Compute ROC manually 

threshold_grid <- seq(0, 1, by = 0.01)
roc_mat <- matrix(NA, nrow = length(threshold_grid), ncol = 2)
colnames(roc_mat) <- c("FPR", "TPR")

for (i in seq_along(threshold_grid)) {
  th <- threshold_grid[i]
  pred_i <- factor(ifelse(log_prob > th, "Yes", "No"),
                   levels = levels(y))
  
  TP_i <- sum(pred_i == "Yes" & y[test_id] == "Yes")
  FP_i <- sum(pred_i == "Yes" & y[test_id] == "No")
  TN_i <- sum(pred_i == "No"  & y[test_id] == "No")
  FN_i <- sum(pred_i == "No"  & y[test_id] == "Yes")
  
  roc_mat[i, ] <- c(FP_i / (FP_i + TN_i),
                    TP_i / (TP_i + FN_i))
}

plot(roc_mat[, "FPR"], roc_mat[, "TPR"], type = "l",
     xlab = "False positive rate",
     ylab = "True positive rate")
abline(0, 1, lty = 2)

### compute AUC using trapezoid rule: 

ord_roc <- order(roc_mat[, "FPR"], roc_mat[, "TPR"])
roc_ord <- roc_mat[ord_roc, , drop = FALSE]

auc <- sum(diff(roc_ord[, "FPR"]) *
             (head(roc_ord[, "TPR"], -1) + tail(roc_ord[, "TPR"], -1)) / 2)

auc
