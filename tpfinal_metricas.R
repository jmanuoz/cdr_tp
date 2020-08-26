accuracy <- function (y_true, y_pred) {
  sum(y_true == y_pred)/length(y_pred)
}

confusion_matrix <- function (y_true, y_pred) {
  VP <- sum((y_true == 1) & (y_pred == 1))
  FN <- sum((y_true == 1) & (y_pred == 0))
  FP <- sum((y_true == 0) & (y_pred == 1))
  VN <- sum((y_true == 0) & (y_pred == 0))
  list(VP = VP, FN = FN, FP = FP, VN = VN)
}

recall <- function (y_true, y_pred) {
  cm <- confusion_matrix(y_true, y_pred)
  cm$VP / (cm$VP + cm$FN)
}

precision  <- function (y_true, y_pred) {
  cm <- confusion_matrix(y_true, y_pred)
  cm$VP / (cm$VP + cm$FP)
}

ROC_AUC  <- function (y_true, y_pred, thresholds_length = 100) {
  thresholds <- seq(min(y_pred), max(y_pred), length.out = thresholds_length)
  VP_rates<- rep(NA, thresholds_length)
  FP_rates <- rep(NA, thresholds_length)
  for (i in 1:thresholds_length){
    y_pred_binary <- ifelse(y_pred >= thresholds[i], 1, 0) 
    cm <- confusion_matrix(y_true, y_pred_binary)
    VP_rates[i] <- cm$VP / sum(y_true == 1)
    FP_rates[i] <- cm$FP / sum(y_true == 0)
  }
  auc = integrate(approxfun(FP_rates,VP_rates), range(FP_rates)[1], range(FP_rates)[2])$value
  list(VP_rates = VP_rates, FP_rates = FP_rates, auc = auc)
}